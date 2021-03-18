-- Allows not to open the command menu if the player is in front of the door.
-- This avoids conflict with the DarkRP's door menu.
-- Source : https://github.com/FPtje/DarkRP/blob/db3bfc6e838fbeba7efcb6732a342a16707089a6/entities/weapons/keys/cl_menu.lua#L49
hook.Add("FScript.CanOpenPlayerMenu", "FScript.PlayerMenuRestrictions", function(ply, name)
	if FScript.Config.CommandMenuKey == KEY_F2 and name == "ChatCommands" then
		local trace = ply:GetEyeTrace()
		local entity = trace.Entity
		if IsValid(entity) and entity:isKeysOwnable() and trace.HitPos:DistToSqr(ply:EyePos()) <= 40000 then
			return false
		end
	end
end)