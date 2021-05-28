----------------------
-- Player Functions --
----------------------

local PLAYER = assert(FindMetaTable("Player"), "Unable to find Player Table")

--[[
	=> This function returns the character's identification number.
	Args: None
	Return: Character identification number
--]]
function PLAYER:GetCharacterID()
	return DarkRP and self:getDarkRPVar("FScript.CharacterID") or self:GetNWString("FScript.CharacterID")
end

--[[
	=> This function returns the physical description of the character.
	Args: None
	Return: Partial character physical description (199 characters max)
--]]
function PLAYER:GetCharacterDescription()
	return DarkRP and self:getDarkRPVar("FScript.CharacterDescription") or self:GetNWString("FScript.CharacterDescription")
end

-----------------------
-- FScript Functions --
-----------------------

--[[
	=> This function determines if the player is valid and is not a robot.
	Args: Player (ply)
	Return: Player is valid
--]]
function FScript.IsValidPlayer(ply)
	if IsValid(ply) and ply:IsPlayer() and not ply:IsBot() then
		return true
	end

	return false
end

--[[
	=> This function determines whether the string is valid or not.
	Args: String (string)
	Return: String is not empty
--]]
function FScript.IsValidString(string)
	if string and string.Trim(string) ~= "" then
		return true
	end

	return false
end

--[[
	=> This function determines whether the data entered by a player complies with some parameters.
	Args: Value (value), Pattern (pattern), Minimum Characters (minChar), Maximum Characters (maxChar), Default Value (defaultValue)
	Return: The value satisfies all requirements
--]]
function FScript.IsValidData(value, pattern, minChar, maxChar, defaultValue)
	if FScript.IsValidString(value) and FScript.PatternCheck(value, pattern) and FScript.LenghtCheck(value, minChar, maxChar) and value ~= defaultValue then
		return true
	end

	return false
end

--[[
	=> This function determines whether the entered string meets the lenght requirements.
	Args: String (string), Minimum Lenght (min), Maximum Lenght (max)
	Return: The value satisfies the length requirements
--]]
function FScript.LenghtCheck(string, min, max)
	if #string >= min and #string <= max then
		return true
	end

	return false
end

--[[
	=> This function determines whether the string fills the pattern check.
	Args: String (string), Pattern (pattern)
	Return: The value satisfies the pattern requirements
--]]
function FScript.PatternCheck(string, pattern)
	if string.find(string, pattern) then
		return true
	end

	return false
end

--[[
	=> This function converts a boolean value to "0" or "1".
	Args: Boolean value (bool)
	Return: Binary value (0 or 1)
--]]
function FScript.BoolToNumber(bool)
	return bool and 1 or 0
end

--[[
	=> This function allows you to get all the commands available on this script.
	Args: None
	Return: All script commands
--]]
function FScript.GetChatCommands()
	return FScript.ChatCommands
end

--[[
	=> Allows you to get the playermodels of the default job (requires DarkRP). Otherwise, the function will give playermodels included in Garry's Mod.
	Args: None
	Return: Default models (may depend on the server's gamemode)
--]]
function FScript.GetDefaultModels()
	if DarkRP then
		local DefaultModels = RPExtraTeams[GAMEMODE.DefaultTeam].model
		return istable(DefaultModels) and DefaultModels or {DefaultModels[1]}
	else
		return {
			"models/player/group01/male_01.mdl",
			"models/player/group01/male_02.mdl",
			"models/player/group01/male_03.mdl",
			"models/player/group01/male_04.mdl",
			"models/player/group01/male_05.mdl",
			"models/player/group01/male_06.mdl",
			"models/player/group01/male_07.mdl",
			"models/player/group01/male_08.mdl",
			"models/player/group01/male_09.mdl",
			"models/player/group01/female_01.mdl",
			"models/player/group01/female_02.mdl",
			"models/player/group01/female_03.mdl",
			"models/player/group01/female_04.mdl",
			"models/player/group01/female_06.mdl",
		}
	end
end

--[[
	=> This function allows you to find a player on the server based on his roleplay name or his userID.
	Args: Player Info (info)
	Return: Player founded (or nothing)
--]]
function FScript.FindPlayer(info)
	if DarkRP then
		return DarkRP.findPlayer(info)
	else
		info = string.lower(info)

		for _, v in ipairs(player.GetHumans()) do
			if string.find(string.lower(v:Nick()), info) then
				return v
			end
		end
	end
end

--[[
	=> This function checks if the network message does not exceed 64kb and throws an error if the size is exceeded.
	Args: Player (ply)
	Return: None (an error if there is an overflow)
--]]
function FScript.ValidateNetworkMessage(ply)
	local BytesWritten = net.BytesWritten()
	if BytesWritten > 64000 then -- A network message cannot exceed 64 kb.
		if SERVER then
			FScript.SendNotification(ply, 1, FScript.Lang.InternalError)
		end

		error("\n" .. FScript.Config.ScriptPrefix .. "Data out of bounds (lenght: " .. BytesWritten .. ">64000). See: https://wiki.facepunch.com/gmod/net.Start for more information.", 2)
	end
end

--[[
	=> Create a basic server => client notification system.
	Args: Player (ply), Message Type (type), Message (message)
	Return: None (a notification)
--]]
if SERVER then
	util.AddNetworkString("FScript.SendNotification")

	function FScript.SendNotification(ply, type, message)
		message = FScript.Config.ScriptPrefix .. message

		if DarkRP then
			DarkRP.notify(ply, type, 5, message)
		else
			local CanSend = hook.Run("FScript.OnSendNotification", ply, type, message)
			if CanSend == false then
				return
			end

			net.Start("FScript.SendNotification")
				net.WriteUInt(type, 2)
				net.WriteString(message)
			net.Send(ply)
		end
	end
else
	net.Receive("FScript.SendNotifications", function()
		notification.AddLegacy(net.ReadUInt(2), net.ReadString(), 5)
	end)
end