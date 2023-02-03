-- The character saving function.
function FScript.SaveCharacter(ply, requester)
	if not FScript.IsValidPlayer(ply) then
		return
	end

	local CanSave, Reason = hook.Run("FScript.CanSaveCharacter", ply)
	if CanSave == false then
		if Reason then
			FScript.SendNotification(requester or ply, 1, Reason)
		end

		return
	end

	if requester then
		FScript.SendNotification(requester, 3, FScript.Lang.OperationSuccess)
	end

	local PlayerSteamID64 = ply:SteamID64()

	local CharacterData = {}
	CharacterData["Name"] = ply:Nick()
	CharacterData["Health"] = ply:Health()
	CharacterData["Armor"] = ply:Armor()
	CharacterData["Position"] = ply:GetPos()
	CharacterData["Angle"] = ply:EyeAngles()
	CharacterData["Model"] = ply:GetModel()
	CharacterData["Skin"] = ply:GetSkin()
	CharacterData["ID"] = ply:GetCharacterID()
	CharacterData["Description"] = ply:GetCharacterDescription()
	CharacterData["Map"] = game.GetMap()

	if DarkRP then
		CharacterData["Hunger"] = DarkRP.disabledDefaults["modules"]["hungermod"] and 100 or math.Round(ply:getDarkRPVar("Energy"))
		CharacterData["Job"] = RPExtraTeams[ply:Team()].command
		CharacterData["Money"] = math.Round(ply:getDarkRPVar("money"))
		CharacterData["Wanted"] = ply:getDarkRPVar("wanted")
		CharacterData["WantedReason"] = ply:getDarkRPVar("wantedReason")
		CharacterData["Arrested"] = ply:getDarkRPVar("Arrested")
		CharacterData["JailTime"] = timer.TimeLeft(PlayerSteamID64 .. "jailtimer")
	end

	if itemstore and ply:CanUseInventory() then
		local GetPlayerInventory = ply.Inventory:GetItems()
		local GetPlayerBank = ply.Bank:GetItems()

		for k, _ in pairs(GetPlayerInventory) do
			GetPlayerInventory[k].Container = nil
		end

		for k, _ in pairs(GetPlayerBank) do
			GetPlayerBank[k].Container = nil
		end

		CharacterData["Inventory"] = util.TableToJSON(GetPlayerInventory)
		CharacterData["Bank"] = util.TableToJSON(GetPlayerBank)
	end

	local GetPlayerWeapons = {}
	local GetPlayerAmmos = {}
	local GetPlayerBodyGroups = {}

	for _, v in ipairs(ply:GetWeapons()) do
		local WeaponClass = v:GetClass()
		if not ply:HasBlacklistedWeapon(WeaponClass) then
			GetPlayerWeapons[#GetPlayerWeapons + 1] = WeaponClass

			local PrimaryAmmoType = v:GetPrimaryAmmoType()
			local AmmoCount = ply:GetAmmoCount(PrimaryAmmoType)

			GetPlayerAmmos[#GetPlayerAmmos + 1] = PrimaryAmmoType .. "@" .. ((AmmoCount > 0 and AmmoCount) or 0)
		end
	end

	for _, v in ipairs(ply:GetBodyGroups()) do
		GetPlayerBodyGroups[#GetPlayerBodyGroups + 1] = v.id .. "@" .. ply:GetBodygroup(v.id)
	end

	for k, v in pairs(FScript.GetCharacterInformations()) do
		local Result = v()
		if Result then
			CharacterData[k] = Result
		end
	end

	CharacterData["Weapons"] = table.concat(GetPlayerWeapons, ";")
	CharacterData["Ammos"] = table.concat(GetPlayerAmmos, ";")
	CharacterData["BodyGroups"] = table.concat(GetPlayerBodyGroups, ";")

	for _, v in ipairs(FScript.Config.IgnoreData) do
		CharacterData[v] = nil
	end

	file.CreateDir("fscript_data/players/" .. PlayerSteamID64)
	file.Write("fscript_data/players/" .. PlayerSteamID64 .. "/" .. ply:GetCharacterNumber() .. ".json", util.TableToJSON(CharacterData, true))

	FScript.SendNotification(ply, 3, FScript.Lang.SaveSuccess)

	hook.Run("FScript.OnCharacterSaved", ply, CharacterData)
end

-- The character loading function.
function FScript.LoadCharacter(ply, characterNumber)
	if not FScript.IsValidPlayer(ply) or not characterNumber then
		return
	end

	local CanLoad, Reason = hook.Run("FScript.CanLoadCharacter", ply, characterNumber)
	if CanLoad == false then
		if Reason then
			FScript.SendNotification(ply, 1, Reason)
		end

		return
	end

	file.AsyncRead("fscript_data/players/" .. ply:SteamID64() .. "/" .. characterNumber .. ".json", "DATA", function(fileName, gamePath, status, data)
		if status == FSASYNC_OK then
			if not FScript.IsValidString(data) then
				FScript.SendNotification(ply, 1, FScript.Lang.InvalidData)
				return
			end

			data = util.JSONToTable(data)

			for _, v in ipairs(FScript.Config.IgnoreData) do
				data[v] = nil
			end

			if DarkRP then
				local CharacterJob = data["Job"]
				if CharacterJob then
					local _, GetJob = DarkRP.getJobByCommand(CharacterJob)
					if ply:Team() ~= GetJob then
						local CanJob = ply:changeTeam(GetJob, FScript.Config.ForceSwitchJob)
						if not CanJob then
							FScript.SendNotification(ply, 1, FScript.Lang.CannotSwitchJob)
							return
						end

						if not GAMEMODE.Config.norespawn then
							ply:Spawn()
						end
					end
				end

				local CharacterMoney = data["Money"]
				if CharacterMoney then
					ply:setDarkRPVar("money", tonumber(CharacterMoney))
				end

				if not DarkRP.disabledDefaults["modules"]["hungermod"] then
					local CharacterHunger = data["Hunger"]
					if CharacterHunger then
						ply:setDarkRPVar("Energy", tonumber(CharacterHunger))
					end
				end

				local CharacterName = data["Name"]
				if ply:Nick() ~= CharacterName then
					ply:setRPName(CharacterName)
				end

				local WantedCharacter = data["Wanted"]
				if WantedCharacter then
					ply:setDarkRPVar("wanted", true)
					ply:setDarkRPVar("wantedReason", data["WantedReason"])
				end

				local ArrestedCharacter = data["Arrested"]
				if ArrestedCharacter then
					ply:arrest(tonumber(data["JailTime"]), ply)
				end
			else
				local CharacterName = data["Name"]
				if ply:Nick() ~= CharacterName then
					ply:SetNWString("FScript.CharacterName", CharacterName)
				end
			end

			if itemstore and ply:CanUseInventory() then
				data["Inventory"] = util.JSONToTable(data["Inventory"])
				data["Bank"] = util.JSONToTable(data["Bank"])

				for k, v in pairs(data["Inventory"]) do
					ply.Inventory:SetItem(k, itemstore.Item(v.Class, v.Data))
				end

				for k, v in pairs(data["Bank"]) do
					ply.Bank:SetItem(k, itemstore.Item(v.Class, v.Data))
				end
			end

			local SaveMap = data["Map"]
			if SaveMap and SaveMap == game.GetMap() then
				local CharacterPosition = data["Position"]
				if CharacterPosition then
					ply:SetPos(Vector(CharacterPosition))
				end

				local CharacterAngle = data["Angle"]
				if CharacterAngle then
					ply:SetEyeAngles(Angle(CharacterAngle))
				end
			end

			local CharacterHealth = data["Health"]
			if CharacterHealth then
				ply:SetHealth(tonumber(CharacterHealth))
			end

			local CharacterArmor = data["Armor"]
			if CharacterArmor then
				ply:SetArmor(tonumber(CharacterArmor))
			end

			local CharacterModel = data["Model"]
			if CharacterModel and util.IsValidModel(CharacterModel) then
				ply:SetModel(CharacterModel)
			end

			local CharacterSkin = data["Skin"]
			if CharacterSkin then
				ply:SetSkin(tonumber(CharacterSkin))
			end

			local CharacterID = data["ID"]
			if CharacterID then
				ply:SetCharacterID(CharacterID)
			end

			local CharacterDescription = data["Description"]
			if CharacterDescription then
				ply:SetCharacterDescription(CharacterDescription)
			end

			local CharacterWeapons = data["Weapons"]
			if FScript.IsValidString(CharacterWeapons) then
				for _, v in ipairs(string.Explode(";", CharacterWeapons)) do
					ply:Give(string.Explode(" ", v)[1])
				end
			end

			local CharacterAmmos = data["Ammos"]
			if FScript.IsValidString(CharacterAmmos) then
				for _, v in ipairs(string.Explode(";", CharacterAmmos)) do
					local Ammo = string.Explode("@", v)
					ply:SetAmmo(tonumber(Ammo[1]), tonumber(Ammo[2]))
				end
			end

			local CharacterBodyGroups = data["BodyGroups"]
			if FScript.IsValidString(CharacterBodyGroups) then
				for _, v in ipairs(string.Explode(";", CharacterBodyGroups)) do
					local BodyGroup = string.Explode("@", v)
					ply:SetBodygroup(tonumber(BodyGroup[1]), tonumber(BodyGroup[2]))
				end
			end

			ply:SetCharacterNumber(characterNumber)
			ply:SetHasCharacterLoaded(true)

			FScript.SendNotification(ply, 3, FScript.Lang.LoadSuccess)

			hook.Run("FScript.OnCharacterLoaded", ply, data)
		end
	end)
end