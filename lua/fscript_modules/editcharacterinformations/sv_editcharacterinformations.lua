util.AddNetworkString("FScript.EditCharacterInformations.OpenMenu")
util.AddNetworkString("FScript.EditCharacterInformations.Validate")

net.Receive("FScript.EditCharacterInformations.Validate", function(lenght, ply)
	if not FScript.IsValidPlayer(ply) or lenght == 0 then
		return
	end

	local CharacterData = net.ReadTable()
	if #CharacterData ~= 5 then
		FScript.SendNotification(ply, 1, FScript.Lang.InvalidData)
		return
	end

	for _, v in ipairs(CharacterData) do
		v = string.Trim(v)
	end

	local Firstname = CharacterData[1]
	local Surname = CharacterData[2]
	local ID = CharacterData[3]
	local Description = CharacterData[4]
	local PlayerModel = CharacterData[5]

	if not FScript.IsValidData(Firstname, "^[%a-Ѐ-џ]+$", FScript.Config.FirstnameMinLenght, FScript.Config.FirstnameMaxLenght) then
		FScript.SendNotification(ply, 1, string.format(FScript.Lang.FirstnameCheck, FScript.Config.FirstnameMinLenght, FScript.Config.FirstnameMaxLenght))
		return
	elseif not FScript.IsValidData(Surname, "^[%a-Ѐ-џ]+$", FScript.Config.SurnameMinLenght, FScript.Config.SurnameMaxLenght) then
		FScript.SendNotification(ply, 1, string.format(FScript.Lang.SurnameCheck, FScript.Config.SurnameMinLenght, FScript.Config.SurnameMaxLenght))
		return
	elseif not FScript.IsValidData(ID, "^[%d]+$", FScript.Config.IDLenght, FScript.Config.IDLenght) then
		FScript.SendNotification(ply, 1, string.format(FScript.Lang.IDCheck, FScript.Config.IDLenght))
		return
	elseif not FScript.IsValidData(Description, "^[%w-%p-%s-Ѐ-џ]+$", FScript.Config.DescriptionMinLenght, FScript.Config.DescriptionMaxLenght) then
		FScript.SendNotification(ply, 1, string.format(FScript.Lang.DescriptionCheck, FScript.Config.DescriptionMinLenght, FScript.Config.DescriptionMaxLenght))
		return
	elseif not PlayerModel or not string.find(PlayerModel, "models/") or not string.EndsWith(PlayerModel, ".mdl") then
		FScript.SendNotification(ply, 1, FScript.Lang.ModelCheck)
		return
	end

	Firstname = string.upper(Firstname[1]) .. string.lower(string.sub(Firstname, 2))
	Surname = string.upper(Surname[1]) .. string.lower(string.sub(Surname, 2))

	local RPName = Firstname .. " " .. Surname
	local Target = ply

	if ply.OfflineSearch then
		local CanEdit, Reason = hook.Run("FScript.CanUseAdminTool", ply, "FScript.EditCharacterInformations")
		if CanEdit == false then
			if Reason then
				FScript.SendNotification(ply, 1, Reason)
			end

			return
		end

		Target = player.GetBySteamID64(ply.OfflineSearch[1])

		if not Target then
			CharacterData = FScript.GetOfflineData(ply.OfflineSearch[1], ply.OfflineSearch[2])

			if not CharacterData then
				FScript.SendNotification(ply, 1, FScript.Lang.InvalidData)
				return
			end

			CharacterData["Name"] = RPName
			CharacterData["ID"] = ID
			CharacterData["Description"] = Description
			CharacterData["Model"] = PlayerModel

			file.Write("fscript_data/players/" .. ply.OfflineSearch[1] .. "/" .. ply.OfflineSearch[2] .. ".json", util.TableToJSON(CharacterData, true))

			ply.OfflineSearch = nil

			hook.Run("FScript.PostEditCharacterInformations", ply, CharacterData)

			FScript.SendNotification(ply, 3, FScript.Lang.EditSuccess)

			return
		end

		ply.OfflineSearch = nil
	end

	local CanEdit, Reason = hook.Run("FScript.CanEditCharacterInformations", Target)
	if CanEdit == false then
		if Reason then
			FScript.SendNotification(ply, 1, Reason)
		end

		return
	end

	Target:SetHasCharacterLoaded(false)

	if RPName ~= Target:Nick() then
		if DarkRP then
			Target:setRPName(RPName)
		else
			Target:SetNWString("FScript.CharacterName", RPName)
		end
	end

	if PlayerModel ~= Target:GetModel() then
		if util.IsValidModel(PlayerModel) then
			Target:SetModel(PlayerModel)
		else
			Target:SetModel(FScript.GetDefaultModels()[1])
		end
	end

	Target:SetCharacterID(ID)
	Target:SetCharacterDescription(Description)
	Target:SetHasCharacterLoaded(true)

	FScript.SaveCharacter(Target)

	hook.Run("FScript.PostEditCharacterInformations", Target, CharacterData)

	FScript.SendNotification(ply, 3, FScript.Lang.EditSuccess)
end)

function FScript.EditCharacterInformations(target, steamID64, characterNumber, admin)
	if not FScript.IsValidPlayer(target) then
		return
	end

	local CharacterData
	local Requester = admin and admin or target

	if steamID64 and characterNumber then
		local CanEdit, Reason = hook.Run("FScript.CanUseAdminTool", target, "FScript.EditCharacterInformations")
		if CanEdit == false then
			if Reason then
				FScript.SendNotification(target, 1, Reason)
			end

			return
		end

		CharacterData = FScript.GetOfflineData(steamID64, characterNumber)

		if not CharacterData then
			FScript.SendNotification(target, 1, FScript.Lang.InvalidData)
			return
		end

		target.OfflineSearch = {steamID64, characterNumber}
	else
		local CanEdit, Reason = hook.Run("FScript.CanEditCharacterInformations", target)
		if CanEdit == false then
			if Reason then
				FScript.SendNotification(Requester, 1, Reason)
			end

			return
		end

		CharacterData = target:GetCharacterData()

		if not CharacterData then
			FScript.SendNotification(Requester, 1, FScript.Lang.InvalidData)
			return
		end
	end

	hook.Run("FScript.PreEditCharacterInformations", Requester)

	net.Start("FScript.EditCharacterInformations.OpenMenu")
		net.WriteTable(CharacterData)
		FScript.ValidateNetworkMessage(Requester)
	net.Send(Requester)
end