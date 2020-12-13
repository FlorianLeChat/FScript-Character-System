-- This is the saving timer for the characters on the server.
timer.Create("FScript.Timer.SaveAllCharacters", FScript.Config.SaveDataTime, 0, function()
	FScript.SaveAllCharacters()
end)

-- Executes the character change when the player spawn on the server.
hook.Add("PlayerInitialSpawn", "FScript.CharacterChange", function(ply, transition)
	timer.Simple(1, function() -- We need this => https://github.com/Facepunch/garrysmod-requests/issues/718
		if IsValid(ply) then
			FScript.ChangeCharacter(ply)
		end
	end)
end)

-- Blocks all damage until the player loads a character.
-- "FScript.Config.DamageProtection" must be set to true for this to work.
if FScript.Config.DamageProtection then
	hook.Add("PlayerShouldTakeDamage", "FScript.DamageProtection", function(target, attacker)
		if not target:HasCharacterLoaded() then
			return false
		end
	end)
end

-- Permanently deletes the player's character when he dies.
-- "FScript.Config.LostCharacterOnDeath" must be set to true for this to work.
if FScript.Config.LostCharacterOnDeath then
	hook.Add("PlayerSpawn", "FScript.CharacterDeletion", function(ply)
		if not ply.FScriptDead then
			return
		end

		FScript.ResetPlayer(ply)
		FScript.ChangeCharacter(ply)

		ply.FScriptDead = nil
	end)

	hook.Add("PlayerDeath", "FScript.CharacterDeletion", function(victim, inflictor, attacker)
		if victim == attacker or not victim:HasCharacterLoaded() then
			return
		end

		victim.FScriptDead = true
		victim:SetHasCharacterLoaded(false)

		file.Delete("fscript_data/players/" .. victim:SteamID64() .. "/" .. victim:GetCharacterNumber() .. ".json")

		local VictimName = victim:Nick()
		local VictimSteamID = victim:SteamID()

		if DarkRP then
			DarkRP.log(FScript.Config.ScriptPrefix .. string.format(FScript.Lang.LostCharacterOnDead, VictimName, VictimSteamID), FScript.Config.BlueColor)
			FAdmin.Log(FScript.Config.ScriptPrefix .. string.format(FScript.Lang.LostCharacterOnDead, VictimName, VictimSteamID))
		end

		MsgC(FScript.Config.BlueColor, FScript.Config.ScriptPrefix, FScript.Config.WhiteColor, string.format(FScript.Lang.LostCharacterOnDead, VictimName, VictimSteamID) .. "\n")
	end)
end

-- Allows the character to be saved when the player disconnects.
hook.Add("PlayerDisconnected", "FScript.CharacterSaving", function(ply)
	if hook.Run("FScript.CanSaveCharacter", ply) ~= false then
		FScript.SaveCharacter(ply)
		MsgC(FScript.Config.GreenColor, FScript.Config.ScriptPrefix, FScript.Config.WhiteColor, string.format(FScript.Lang.CharacterSavingSuccess, ply:Nick(), ply:SteamID()) .. "\n")
	else
		MsgC(FScript.Config.RedColor, FScript.Config.ScriptPrefix, FScript.Config.WhiteColor, string.format(FScript.Lang.CharacterSavingFailed, ply:Nick(), ply:SteamID()) .. "\n")
	end
end)

-- Allows all characters on the server when the server shutdown.
hook.Add("ShutDown", "FScript.CharacterSaving", function()
	FScript.SaveAllCharacters()
end)