-- Check to be able to use the administration tools.
hook.Add("FScript.CanUseAdminTool", "FScript.AdminToolRestrictions", function(ply, tool)
	if not ply:IsAdmin() then
		return false, FScript.Lang.MustBeAdmin
	end
end)