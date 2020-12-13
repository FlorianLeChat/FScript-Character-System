util.AddNetworkString("FScript.ViewCharacterDatabase.OpenMenu")
util.AddNetworkString("FScript.ViewCharacterDatabase.Validate")
util.AddNetworkString("FScript.ViewCharacterDatabase.RequestServerData")
util.AddNetworkString("FScript.ViewCharacterDatabase.SendServerData")

--[[
	Args:
	- Value = "SteamID"

	Return:
	- [1] = Character Name (Firstname + surname),
	- [2] = Character ID,
	- [3] = Character Physical Description,
	- [4] = Player SteamID64,
	- [5] = Character number
--]]
local function SteamIDSearching(value)
	if string.StartWith(value, "STEAM_") then
		value = util.SteamIDTo64(value)
	end

	local Characters = file.Find("fscript_data/players/" .. value .. "/*", "DATA")
	if #Characters > 0 then
		local CharactersData = {}

		for i = 1, #Characters do
			local Character = file.Read("fscript_data/players/" .. value .. "/" .. i .. ".json")
			if not FScript.IsValidString(Character) then
				return
			end

			Character = util.JSONToTable(Character)

			CharactersData[i] = {
				Character["Name"],
				Character["ID"],
				#Character["Description"] > 75 and string.sub(Character["Description"], 0, 75) .. "..." or Character["Description"],
				value,
				i,
			}
		end

		return CharactersData
	end
end

--[[
	Args:
	- Type = "SteamID" or "Name" or "ID" or "Description"
	- Value = Any character value.

	Return:
	- [1] = Character Name (Firstname + surname),
	- [2] = Character ID,
	- [3] = Character Physical Description,
	- [4] = Player SteamID64,
	- [5] = Character number
--]]
local function StringSearching(type, value)
	local _, Folders = file.Find("fscript_data/players/*", "DATA")
	for _, v1 in ipairs(Folders) do
		local Files = file.Find("fscript_data/players/" .. v1 .. "/*", "DATA")
		for _, v2 in ipairs(Files) do
			local Character = file.Read("fscript_data/players/" .. v1 .. "/" .. v2)
			if not FScript.IsValidString(Character) then
				return
			end

			Character = util.JSONToTable(Character)

			if string.find(string.lower(Character[type]), string.lower(value)) then
				v2 = string.Replace(v2, ".json", "")

				return {
					[1] = {
						Character["Name"],
						Character["ID"],
						#Character["Description"] > 75 and string.sub(Character["Description"], 0, 75) .. "..." or Character["Description"],
						v1,
						v2,
					}
				}
			end
		end
	end
end

net.Receive("FScript.ViewCharacterDatabase.Validate", function(lenght, ply)
	if not FScript.IsValidPlayer(ply) or lenght == 0 then
		return
	end

	local CanView, Reason = hook.Run("FScript.CanViewCharacterDatabase", ply)
	if CanView == false then
		if Reason then
			FScript.SendNotification(ply, 1, Reason)
		end

		return
	end

	local Data = net.ReadTable()
	if not Data or #Data ~= 3 then
		FScript.SendNotification(ply, 1, FScript.Lang.InvalidData)
		return
	end

	local Action = Data[1]
	local SteamID64 = Data[2]
	local CharacterNumber = Data[3]

	if Action == "ViewCharacterInformations" then
		FScript.ViewCharacterInformations(ply, SteamID64, CharacterNumber)
	elseif Action == "EditCharacterInformations" then
		FScript.EditCharacter(ply, SteamID64, CharacterNumber)
	elseif Action == "EditCharacterNotes" then
		FScript.ViewCharacterNotes(ply, SteamID64, CharacterNumber)
	elseif Action == "DeleteCharacter" then
		FScript.RemoveCharacter(ply, SteamID64, CharacterNumber)
		FScript.SendNotification(ply, 3, FScript.Lang.SingleDeleteSuccess)
	elseif Action == "DeleteAllCharacters" then
		FScript.RemoveAllCharacters(ply, SteamID64)
		FScript.SendNotification(ply, 3, FScript.Lang.PluralDeleteSuccess)
	end

	hook.Run("FScript.PostViewCharacterDatabase", ply, Action, SteamID64, CharacterNumber)
end)

net.Receive("FScript.ViewCharacterDatabase.RequestServerData", function(lenght, ply)
	if not FScript.IsValidPlayer(ply) or lenght == 0 then
		return
	end

	local CanView, Reason = hook.Run("FScript.CanViewCharacterDatabase", ply)
	if CanView == false then
		if Reason then
			FScript.SendNotification(ply, 1, Reason)
		end

		return
	end

	local Data = net.ReadTable()
	if Data and #Data == 2 then
		local Search = Data[2]
		if not FScript.IsValidString(Search) then
			return
		end

		local Type = Data[1]
		if Type == "SteamID" or Type == "List" then
			local Search = SteamIDSearching(Search)
			if Search then
				net.Start("FScript.ViewCharacterDatabase.SendServerData")
					net.WriteTable(Search)
					FScript.ValidateNetworkMessage(ply)
				net.Send(ply)
			end
		elseif Type == "Name" or Type == "ID" or Type == "Description" then
			local Search = StringSearching(Type, Search)
			if Search then
				net.Start("FScript.ViewCharacterDatabase.SendServerData")
					net.WriteTable(Search)
					FScript.ValidateNetworkMessage(ply)
				net.Send(ply)
			end
		end
	end
end)

function FScript.ViewCharacterDatabase(ply)
	if not FScript.IsValidPlayer(ply) then
		return
	end

	local CanView, Reason = hook.Run("FScript.CanViewCharacterDatabase", ply)
	if CanView == false then
		if Reason then
			FScript.SendNotification(ply, 1, Reason)
		end

		return
	end

	hook.Run("FScript.PreViewCharacterDatabase", ply)

	net.Start("FScript.ViewCharacterDatabase.OpenMenu")
	net.Send(ply)
end