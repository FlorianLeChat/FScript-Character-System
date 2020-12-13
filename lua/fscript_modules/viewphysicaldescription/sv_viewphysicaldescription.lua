util.AddNetworkString("FScript.ViewPhysicalDescription.OpenMenu")

local PlayerDistance = 130 ^ 2

hook.Add("KeyPress", "FScript.ViewPhysicalDescription", function(ply, key)
	if key ~= FScript.Config.ViewPhysicalDescriptionKey then
		return
	end

	if (ply.LastOpenTime or 0) > CurTime() then
		return
	end

	ply.LastOpenTime = CurTime() + 3

	local EntityTrace = ply:GetEyeTrace().Entity
	if not FScript.IsValidPlayer(EntityTrace) then
		return
	elseif EntityTrace:GetPos():DistToSqr(ply:GetPos()) > PlayerDistance then
		FScript.SendNotification(ply, 1, FScript.Lang.TooFar)
		return
	end

	local CanOpen, Reason = hook.Run("FScript.CanOpenPlayerMenu", ply, "PhysicalDescription")
	if CanOpen == false then
		if Reason then
			FScript.SendNotification(ply, 1, Reason)
		end

		return
	end

	local CharacterData = EntityTrace:GetCharacterData()
	if not CharacterData then
		FScript.SendNotification(ply, 1, FScript.Lang.InvalidData)
		return
	end

	net.Start("FScript.ViewPhysicalDescription.OpenMenu")
		net.WriteTable({CharacterData["Name"], CharacterData["ID"], CharacterData["Description"]})
		FScript.ValidateNetworkMessage(ply)
	net.Send(ply)
end)