-- This file is used to execute the code below only if the server uses the DarkRP gamemode.
hook.Add("loadCustomDarkRPItems", "FScript.LoadDarkRPStuff", function()
	-- Allows you to add the physical description to the default HUD of the DarkRP.
	if CLIENT and FScript.Config.AddCustomDarkRPHUD then
		local PLAYER = assert(FindMetaTable("Player"), "Unable to find Player Table")
		local CustomWhiteColor = Color(255, 255, 255, 200)

		local OldFunction = PLAYER.drawPlayerInfo
		function PLAYER:drawPlayerInfo()
			OldFunction(self)

			local pos = self:EyePos()

			pos.z = pos.z + 10
			pos = pos:ToScreen()
			if not self:getDarkRPVar("wanted") then
				pos.y = pos.y - 50
			end

			local Description = self:GetCharacterDescription()
			Description = (#Description > 0 and (string.sub(Description, 1, 50) .. "...")) or FScript.Lang.NoPhysicalDescription

			draw.DrawNonParsedText(Description, "DarkRPHUD2", pos.x + 1, pos.y + 61, FScript.Config.BlackColor, 1)
			draw.DrawNonParsedText(Description, "DarkRPHUD2", pos.x, pos.y + 60, CustomWhiteColor, 1)
		end
	end

	-- Declares the DarkRP variables for identification number and physical description.
	DarkRP.registerDarkRPVar("FScript.CharacterID", net.WriteString, net.ReadString)
	DarkRP.registerDarkRPVar("FScript.CharacterDescription", net.WriteString, net.ReadString)

	if SERVER then
		-- Allows you to restrict the character's actions if he is sleeping.
		local function DarkRPCheck(ply)
			if ply.Sleeping then
				return false, FScript.Lang.NotSleeping
			end
		end
		hook.Add("FScript.CanCreateCharacter", "FScript.DarkRPRestrictions", DarkRPCheck)
		hook.Add("FScript.CanChangeCharacter", "FScript.DarkRPRestrictions", DarkRPCheck)
		hook.Add("FScript.CanEditCharacter", "FScript.DarkRPRestrictions", DarkRPCheck)
		hook.Add("FScript.CanSaveCharacter", "FScript.DarkRPRestrictions", DarkRPCheck)
		hook.Add("FScript.CanLoadCharacter", "FScript.DarkRPRestrictions", DarkRPCheck)

		-- Blocks the hunger degradation if the player does not have a loaded character.
		if FScript.Config.HungerProtection then
			hook.Add("hungerUpdate", "FScript.DarkRPHunger", function(ply, energy)
				if not ply:HasCharacterLoaded() then
					return true
				end
			end)
		end

		-- We define blacklisted weapons here.
		for _, v in ipairs(GAMEMODE.Config.DefaultWeapons) do
			FScript.Config.BlacklistedWeapons[v] = true
		end

		for _, v in ipairs(GAMEMODE.Config.AdminWeapons) do
			FScript.Config.BlacklistedWeapons[v] = true
		end
	end
end)