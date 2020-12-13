util.AddNetworkString("FScript.EditCharacterNotes.OpenMenu")
util.AddNetworkString("FScript.EditCharacterNotes.Validate")

net.Receive("FScript.EditCharacterNotes.Validate", function(lenght, ply)
	if not FScript.IsValidPlayer(ply) or lenght == 0 then
		return
	end

	local Notes = net.ReadString()
	if not FScript.IsValidData(Notes, "^[%w-%p-%s-Ѐ-џ]+$", 0, FScript.Config.NotesLenght, string.format(FScript.Lang.EditCharacterNotesDefaultText, FScript.Config.NotesLenght)) then
		FScript.SendNotification(ply, 1, string.format(FScript.Lang.NotesCheck, FScript.Config.NotesLenght))
		return
	end

	if ply.OfflineSearch then
		local CanEdit, Reason = hook.Run("FScript.CanUseAdminTool", ply, "FScript.EditCharacterNotes")
		if CanEdit == false then
			if Reason then
				FScript.SendNotification(ply, 1, Reason)
			end

			return
		end

		local CharacterData = FScript.GetOfflineData(ply.OfflineSearch[1], ply.OfflineSearch[2])
		if not CharacterData then
			FScript.SendNotification(ply, 1, FScript.Lang.InvalidData)
			return
		end

		CharacterData["Notes"] = string.Trim(Notes)

		file.Write("fscript_data/players/" .. ply.OfflineSearch[1] .. "/" .. ply.OfflineSearch[2] .. ".json", util.TableToJSON(CharacterData, true))

		ply.OfflineSearch = nil
	else
		local CanEdit, Reason = hook.Run("FScript.CanEditCharacterNotes", ply)
		if CanEdit == false then
			if Reason then
				FScript.SendNotification(ply, 1, Reason)
			end

			return
		end

		local CharacterData = ply:GetCharacterData()
		if not CharacterData then
			FScript.SendNotification(ply, 1, FScript.Lang.InvalidData)
			return
		end

		CharacterData["Notes"] = string.Trim(Notes)

		file.Write("fscript_data/players/" .. ply:SteamID64() .. "/" .. ply:GetCharacterNumber() .. ".json", util.TableToJSON(CharacterData, true))
	end

	hook.Run("FScript.PostEditCharacterNotes", ply, Notes)

	FScript.SendNotification(ply, 3, FScript.Lang.EditSuccess)
end)

function FScript.EditCharacterNotes(target, steamID64, characterNumber, admin)
	if not FScript.IsValidPlayer(target) then
		return
	end

	local CharacterData
	local Requester = admin and admin or target

	if steamID64 and characterNumber then
		local CanEdit, Reason = hook.Run("FScript.CanUseAdminTool", target, "FScript.EditCharacterNotes")
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
		local CanEdit, Reason = hook.Run("FScript.CanEditCharacterNotes", target)
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

	hook.Run("FScript.PreEditCharacterNotes", Requester)

	local CharacterNotes = CharacterData["Notes"]
	if not FScript.IsValidString(CharacterNotes) then
		CharacterNotes = ""
	end

	-- We throw an error if we reach the limit of strings that can be sent over the network.
	-- https://wiki.facepunch.com/gmod/net.WriteString
	if #CharacterNotes > 65533 then
		FScript.SendNotification(target, 1, FScript.Lang.InternalError)
		return
	end

	net.Start("FScript.EditCharacterNotes.OpenMenu")
		net.WriteString(CharacterNotes)
		FScript.ValidateNetworkMessage(Requester)
	net.Send(Requester)
end