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
local function SteamIDSearching(value, callback)
	if string.StartWith(value, "STEAM_") then
		value = util.SteamIDTo64(value)
	end

	local Characters = file.Find("fscript_data/players/" .. value .. "/*", "DATA")
	if #Characters > 0 then
		local result = {}

		for i = 1, #Characters do
			file.AsyncRead("fscript_data/players/" .. value .. "/" .. i .. ".json", "DATA", function(fileName, gamePath, status, data)
				if FScript.IsValidString(data) and status == FSASYNC_OK then
					data = util.JSONToTable(data)

					result[#result + 1] = {
						data["Name"],
						data["ID"],
						#data["Description"] > 75 and string.sub(data["Description"], 0, 75) .. "..." or data["Description"],
						value,
						i,
					}

					if math.min(#Characters, FScript.Config.MaxCharacters) == #result then
						callback(result)
					end
				end
			end)
		end
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
local function StringSearching(type, value, callback)
	local _, Folders = file.Find("fscript_data/players/*", "DATA")
	for _, v1 in ipairs(Folders) do
		local result = {}

		local Files = file.Find("fscript_data/players/" .. v1 .. "/*", "DATA")
		for _, v2 in ipairs(Files) do
			file.AsyncRead("fscript_data/players/" .. v1 .. "/" .. v2, "DATA", function(fileName, gamePath, status, data)
				if FScript.IsValidString(data) and status == FSASYNC_OK then
					data = util.JSONToTable(data)

					if string.find(string.lower(data[type]), string.lower(value)) then
						v2 = string.Replace(v2, ".json", "")

						result[#result + 1] = {
							data["Name"],
							data["ID"],
							#data["Description"] > 75 and string.sub(data["Description"], 0, 75) .. "..." or data["Description"],
							v1,
							v2,
						}

						if math.min(#Files, FScript.Config.MaxCharacters) == #result then
							callback(result)
						end
					end
				end
			end)
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
		FScript.EditCharacterInformations(ply, SteamID64, CharacterNumber)
	elseif Action == "EditCharacterNotes" then
		FScript.EditCharacterNotes(ply, SteamID64, CharacterNumber)
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
			SteamIDSearching(Search, function(data)
				if data then
					net.Start("FScript.ViewCharacterDatabase.SendServerData")
						net.WriteTable(data)
						FScript.ValidateNetworkMessage(ply)
					net.Send(ply)
				end
			end)
		elseif Type == "Name" or Type == "ID" or Type == "Description" then
			StringSearching(Type, Search, function(data)
				if data then
					net.Start("FScript.ViewCharacterDatabase.SendServerData")
						net.WriteTable(data)
						FScript.ValidateNetworkMessage(ply)
					net.Send(ply)
				end
			end)
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