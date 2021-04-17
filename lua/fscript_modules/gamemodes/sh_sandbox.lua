if engine.ActiveGamemode() ~= "sandbox" then
	return
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