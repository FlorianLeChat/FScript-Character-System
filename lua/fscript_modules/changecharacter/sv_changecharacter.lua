util.AddNetworkString("FScript.ChangeCharacter.OpenMenu")
util.AddNetworkString("FScript.ChangeCharacter.Validate")

net.Receive("FScript.ChangeCharacter.Validate", function(lenght, ply)
	if not FScript.IsValidPlayer(ply) or lenght == 0 then
		return
	end

	local CanChange, Reason = hook.Run("FScript.CanChangeCharacter", ply)
	if CanChange == false then
		if Reason then
			FScript.SendNotification(ply, 1, Reason)
		end

		return
	end

	local CharacterNumber = net.ReadUInt(4)
	if isnumber(CharacterNumber) then
		FScript.LoadCharacter(ply, CharacterNumber)
	else
		FScript.ChangeCharacter(ply)
	end

	hook.Run("FScript.PostChangeCharacter", ply, CharacterNumber)
end)

function FScript.ChangeCharacter(ply, requester)
	if not FScript.IsValidPlayer(ply) then
		return
	end

	local CanChange, Reason = hook.Run("FScript.CanChangeCharacter", ply)
	if CanChange == false then
		if Reason then
			FScript.SendNotification(requester or ply, 1, Reason)
		end

		return
	end

	if requester then
		FScript.SendNotification(requester, 3, FScript.Lang.OperationSuccess)
	end

	hook.Run("FScript.PreChangeCharacter", ply)

	FScript.ResetPlayer(ply)

	local PlayerSteamID64 = ply:SteamID64()

	local Characters = file.Find("fscript_data/players/" .. PlayerSteamID64 .. "/*", "DATA")
	if #Characters == 0 then
		FScript.CreateCharacter(ply)
		FScript.SendNotification(ply, 1, FScript.Lang.NoDataFound)
		return
	end

	local CharactersData = {}

	for _, v in ipairs(Characters) do
		file.AsyncRead("fscript_data/players/" .. PlayerSteamID64 .. "/" .. v, "DATA", function(fileName, gamePath, status, data)
			if status == FSASYNC_OK then
				CharactersData[#CharactersData + 1] = util.JSONToTable(data)

				if #Characters == #CharactersData then
					net.Start("FScript.ChangeCharacter.OpenMenu")
						net.WriteTable(CharactersData)
						FScript.ValidateNetworkMessage(ply)
					net.Send(ply)

					FScript.SendNotification(ply, 3, FScript.Lang.DataFound)
				end
			end
		end)
	end
end