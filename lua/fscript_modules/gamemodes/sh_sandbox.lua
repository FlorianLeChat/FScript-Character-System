if engine.ActiveGamemode() ~= "sandbox" then
	return
end

-- We need to create some fonts that only exist in the DarkRP gamemode.
-- Source : https://github.com/FPtje/DarkRP/blob/daf2f766bd5be5d6e90504cd5c5965d4827ff44a/gamemode/modules/base/cl_fonts.lua#L36-L41
if CLIENT then
	surface.CreateFont("Trebuchet24", {
		size = 24,
		weight = 500,
		antialias = true,
		shadow = false,
		font = "Trebuchet MS"
	})
end

-- Let's override this function to make it FScript compatible.
-- Source : https://github.com/FPtje/DarkRP/blob/35ca64069be4e090604544d9fe8a4b41aafeba87/gamemode/modules/base/sh_entityvars.lua#L99-L110
local PLAYER = FindMetaTable("Player")
PLAYER._Name = PLAYER._Name or PLAYER.Name

function PLAYER:Name()

	if self:IsValid() then

		local rpName = self:GetNWString("FScript.CharacterName")

		return rpName ~= "" and rpName or PLAYER._Name(self)

	end

	return PLAYER._Name(self)

end

PLAYER.GetName = PLAYER.Name
PLAYER.Nick = PLAYER.Name