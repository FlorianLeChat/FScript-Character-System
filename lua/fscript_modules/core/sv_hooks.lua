--[[
	These restrictions are imposed by default to allow the script to work properly but they can be easily modified at any time.
	Please think carefully before making any changes as deleting some hooks can create critical security issues.

	A hook can be created this way:

	hook.Add("FScript.CanSaveCharacter", "UniqueName", function(ply)	-- This hook is used to check if the player's character can be saved.
		if ply:Health() <= 20 then										-- If the player's health is less than or equal to 20%.
			return false, "The failure message"							-- Return "false" to block the save, you can also enter an failure message (this is optional, but I recommend it).
		end																-- End of condition.
	end)																-- End of hook.

	=> More informations : https://wiki.facepunch.com/gmod/hook.Add
--]]

hook.Add("FScript.CanCreateCharacter", "FScript.CreateRestrictions", function(ply)
	local Characters = file.Find("fscript_data/players/" .. ply:SteamID64() .. "/*", "DATA")
	if #Characters > FScript.Config.MaxCharacters then
		return false, FScript.Lang.TooManyCharacters
	end

	if not ply:Alive() then
		return false, FScript.Lang.MustBeAlive
	end
end)

hook.Add("FScript.CanChangeCharacter", "FScript.ChangeRestrictions", function(ply)
	if not ply:Alive() then
		return false, FScript.Lang.MustBeAlive
	end
end)

hook.Add("FScript.CanEditCharacterInformations", "FScript.EditInformationRestrictions", function(ply)
	if not ply:Alive() then
		return false, FScript.Lang.MustBeAlive
	end
end)

hook.Add("FScript.CanEditCharacterNotes", "FScript.EditNoteRestrictions", function(ply)
	if not ply:Alive() then
		return false, FScript.Lang.MustBeAlive
	end
end)

hook.Add("FScript.CanViewCharacterDatabase", "FScript.DatabaseRestrictions", function(ply)
	if not ply:IsAdmin() then
		return false, FScript.Lang.MustBeAdmin
	end
end)

hook.Add("FScript.CanSaveCharacter", "FScript.SaveRestrictions", function(ply)
	if not ply:HasCharacterLoaded() then
		return false, FScript.Lang.MustPlayCharacter
	end

	if not ply:Alive() then
		return false, FScript.Lang.MustBeAlive
	end
end)

hook.Add("FScript.CanLoadCharacter", "FScript.LoadRestrictions", function(ply)
	if not ply:Alive() then
		return false, FScript.Lang.MustBeAlive
	end
end)

hook.Add("FScript.CanUseAdminTool", "FScript.AdminToolRestrictions", function(ply, tool)
	if not ply:IsAdmin() then
		return false, FScript.Lang.MustBeAdmin
	end
end)