----------------------
-- Player Functions --
----------------------

local PLAYER = assert(FindMetaTable("Player"), "Unable to find Player Table")

--[[
	=> Allows you to define if the player has loaded a character or not.
	Args: Boolean value (value)
	Return: None
--]]
function PLAYER:SetHasCharacterLoaded(value)
	self["FScript.CharacterLoaded"] = value
end

--[[
	=> Allows you to see if the player has loaded a character or not.
	Args: None
	Return: Boolean value
--]]
function PLAYER:HasCharacterLoaded()
	return self["FScript.CharacterLoaded"]
end

--[[
	=> Allows you to define the player's character number.
	Args: Number (value)
	Return: None
--]]
function PLAYER:SetCharacterNumber(value)
	self["FScript.CharacterNumber"] = value
end

--[[
	=> Allows you to get the player's character number.
	Args: None
	Return: Number
--]]
function PLAYER:GetCharacterNumber()
	return self["FScript.CharacterNumber"]
end

--[[
	=> Allows you to get all the character data saved on the server.
	Args: None
	Return: Character data
--]]
function PLAYER:GetCharacterData()
	if not self:HasCharacterLoaded() then
		MsgC(FScript.Config.RedColor, "\n" .. FScript.Config.ScriptPrefix .. "GetCharacterData: " .. self:Nick() .. " (" .. self:SteamID() .. ") doesn't have a loaded character right now.\n")
		return
	end

	local CharacterData = file.Read("fscript_data/players/" .. self:SteamID64() .. "/" .. self:GetCharacterNumber() .. ".json")
	if not FScript.IsValidString(CharacterData) then
		MsgC(FScript.Config.RedColor, "\n" .. FScript.Config.ScriptPrefix .. "GetCharacterData: " .. self:Nick() .. " (" .. self:SteamID() .. ") has no stored data.\n")
		return
	end

	return util.JSONToTable(CharacterData)
end

--[[
	=> Allows you to define the character's identification number.
	Args: Identification number (value)
	Return: None
--]]
function PLAYER:SetCharacterID(value)
	if DarkRP then
		self:setDarkRPVar("FScript.CharacterID", value)
	else
		self:SetNWString("FScript.CharacterID", value)
	end
end

--[[
	=> Allows you to define the character's physical description.
	Args: Physical description (value)
	Return: None
--]]
function PLAYER:SetCharacterDescription(value)
	if DarkRP then
		self:setDarkRPVar("FScript.CharacterDescription", value)
	else
		self:SetNWString("FScript.CharacterDescription", value)
	end
end

--[[
	=> Allows you to get all the weapons in the blacklist that the player has.
	Args: Weapon class (class)
	Return: Boolean value
--]]
function PLAYER:HasBlacklistedWeapon(class)
	if FScript.Config.BlacklistedWeapons[class] then
		return true
	end

	return false
end

-----------------------
-- FScript Functions --
-----------------------

--[[
	=> Allows you to add additional data unique to the character that will be saved by the script.
	Args: Data name (name), Data function (func)
	Return: All custom informations (only with "FScript.GetCharacterInformations()")
--]]
local CustomInformations = {}

function FScript.AddCharacterInformation(name, func)
	CustomInformations[name] = func
end

function FScript.GetCharacterInformations()
	return CustomInformations
end

--[[
	=> Allows you to get the data of a disconnected character.
	Args: Player SteamID64 (SteamID64), Character Number (CharacterNumber)
	Return: Character data
--]]
function FScript.GetOfflineData(SteamID64, CharacterNumber)
	local CharacterData = file.Read("fscript_data/players/" .. SteamID64 .. "/" .. CharacterNumber .. ".json")
	if not FScript.IsValidString(CharacterData) then
		MsgC(FScript.Config.RedColor, "\n" .. FScript.Config.ScriptPrefix .. "GetOfflineData: " .. SteamID64 .. " (" .. CharacterNumber .. ") has no stored data.\n")
		return
	end

	return util.JSONToTable(CharacterData)
end

--[[
	=> Allows you to delete a specified character.
	Args: Player (target), [SteamID64 (steamID64), Character Number (charNumber) -Optional]
	Return: None
--]]
function FScript.RemoveCharacter(target, steamID64, charNumber)
	steamID64 = steamID64 or target:SteamID64()
	charNumber = charNumber or target:GetCharacterNumber()

	file.Delete("fscript_data/players/" .. steamID64 .. "/" .. charNumber .. ".json")

	for _, v in ipairs(player.GetHumans()) do
		if v:SteamID64() == steamID64 and v:GetCharacterNumber() == charNumber then
			v:SetHasCharacterLoaded(false)
			FScript.ResetPlayer(v)
			FScript.ChangeCharacter(v)
			break
		end
	end
end

--[[
	=> Allows you to delete all of a player's characters.
	Args: Player (target), [SteamID64 (steamID64) -Optional]
	Return: None
--]]
function FScript.RemoveAllCharacters(target, steamID64)
	steamID64 = steamID64 or target:SteamID64()

	for _, v in ipairs(file.Find("fscript_data/players/" .. steamID64 .. "/*", "DATA")) do
		file.Delete("fscript_data/players/" .. steamID64 .. "/" .. v)
	end

	for _, v in ipairs(player.GetHumans()) do
		if v:SteamID64() == steamID64 then
			v:SetHasCharacterLoaded(false)
			FScript.ResetPlayer(v)
			FScript.ChangeCharacter(v)
			break
		end
	end
end

--[[
	=> Allows you to completely save all the characters of the players connected to the server.
	Args: None
	Return: None
--]]
function FScript.SaveAllCharacters()
	for _, v in ipairs(player.GetHumans()) do
		if hook.Run("FScript.CanSaveCharacter", v) ~= false then
			FScript.SaveCharacter(v)
		end
	end
end

--[[
	=> Allows you to reset the player data in order to be able to load another character.
	Args: Player (ply)
	Return: None
--]]
function FScript.ResetPlayer(ply)
	if hook.Run("FScript.CanSaveCharacter", ply) ~= false then
		FScript.SaveCharacter(ply)
	end

	if FScript.Config.FirstTimeNoReset and not file.IsDir("fscript_data/players/" .. ply:SteamID64(), "DATA") then
		return
	end

	hook.Run("FScript.OnResetPlayer", ply)

	ply:SetHasCharacterLoaded(false)
	ply:SetCharacterNumber(nil)

	local PlayerSkinCount = ply:SkinCount()
	if PlayerSkinCount then
		ply:SetSkin(math.random(PlayerSkinCount))
	end

	for i = 1, ply:GetNumBodyGroups() do
		ply:SetBodygroup(i, 0)
	end

	if DarkRP then
		if ply:isWanted() then
			ply:unWanted(ply)
		end

		if ply:isArrested() then
			ply:unArrest(ply)
		end

		if ply:Team() ~= GAMEMODE.DefaultTeam then
			ply:changeTeam(GAMEMODE.DefaultTeam, true)

			if not GAMEMODE.Config.norespawn then
				ply:Spawn()
			end
		end

		ply:setDarkRPVar("money", 0)
	end

	if itemstore and ply:CanUseInventory() then
		for k, _ in ipairs(ply.Inventory:GetItems()) do
			ply.Inventory:SetItem(k, nil)
		end

		for k, _ in ipairs(ply.Bank:GetItems()) do
			ply.Bank:SetItem(k, nil)
		end
	end

	for _, v in ipairs(ply:GetWeapons()) do
		local WeaponClass = v:GetClass()
		if not ply:HasBlacklistedWeapon(WeaponClass) then
			ply:StripWeapon(WeaponClass)
		end
	end
end