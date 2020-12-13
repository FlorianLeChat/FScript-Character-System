util.AddNetworkString("FScript.ViewCharacterInformations.OpenMenu")

function FScript.ViewCharacterInformations(target, steamID64, characterNumber, admin)
	if not FScript.IsValidPlayer(target) then
		return
	end

	local CharacterData
	local Requester = admin and admin or target

	if steamID64 and characterNumber then
		local CanView, Reason = hook.Run("FScript.CanUseAdminTool", target, "FScript.ViewCharacterInformations")
		if CanView == false then
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
	else
		local CanView, Reason = hook.Run("FScript.CanViewCharacterInformations", target)
		if CanView == false then
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

	hook.Run("FScript.OnViewCharacterInformations", Requester)

	net.Start("FScript.ViewCharacterInformations.OpenMenu")
		net.WriteTable(CharacterData)
		FScript.ValidateNetworkMessage(Requester)
	net.Send(Requester)
end