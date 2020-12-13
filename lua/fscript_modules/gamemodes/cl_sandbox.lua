if engine.ActiveGamemode() ~= "darkrp" then
	-- We need to create some fonts that only exist in the DarkRP gamemode.
	-- Source : https://github.com/FPtje/DarkRP/blob/daf2f766bd5be5d6e90504cd5c5965d4827ff44a/gamemode/modules/base/cl_fonts.lua#L36-L41
	surface.CreateFont("Trebuchet24", {
		size = 24,
		weight = 500,
		antialias = true,
		shadow = false,
		font = "Trebuchet MS"
	})
end