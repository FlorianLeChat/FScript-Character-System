-- The sound produced when a click is made on one of the menus of the script.
FScript.Config.ClickSound = Sound("UI/buttonclick.wav")
-- The sound produced when your mouse passes over a button or text box.
FScript.Config.HoverSound = Sound("UI/buttonrollover.wav")
-- The sound produced when an error occurs.
FScript.Config.ErrorSound = Sound("buttons/button8.wav")

-- All colours used in the menus.
-- Some colors use constants included in Garry's Mod: https://wiki.facepunch.com/gmod/Global_Variables#constants
FScript.Config.DermaColor = Color(0, 0, 0, 140)
FScript.Config.BlackColor = color_black or Color(0, 0, 0)
FScript.Config.WhiteColor = color_white or Color(255, 255, 255)
FScript.Config.RedColor = Color(255, 0, 0)
FScript.Config.GreenColor = Color(22, 184, 78)
FScript.Config.BlueColor = Color(0, 127, 255)
FScript.Config.DermaBackgroundColor = Color(201, 201, 199)
FScript.Config.TitleColor = Color(61, 61, 61)
FScript.Config.TextColor = Color(82, 82, 82)
FScript.Config.ButtonColor = Color(153, 153, 153)

-- The prefix used in some chat notifications. MUST have a space at the end.
FScript.Config.ScriptPrefix = "[FScript] "

-- Fonts used in titles, subtitles and texts in menus.
-- Here is the official list of default fonts in Garry's Mod: https://wiki.facepunch.com/gmod/Default_Fonts
FScript.Config.TitleFont = "DermaLarge"
FScript.Config.SubTitleFont = "Trebuchet24"
FScript.Config.TextFont = "Trebuchet18"

-- The language used by the script.
-- By default it uses the server language, but you can change it to your own if you have added new translations in the "fscript_translations.lua" file.
-- If the translation remains in English, it means that this script needs to be translated into your language or there is an error somewhere else.
FScript.Config.Language = GetConVar("gmod_language"):GetString()

-- The minimum and maximum length of a character's first name.
FScript.Config.FirstnameMinLenght = 3
FScript.Config.FirstnameMaxLenght = 20
-- The minimum and maximum length of a character's surname.
FScript.Config.SurnameMinLenght = 3
FScript.Config.SurnameMaxLenght = 15
-- The length of the character identification number. The default value represents the "CIDs" used on some HL2RPs.
FScript.Config.IDLenght = 5
-- The minimum and maximum length of the physical description of the character.
FScript.Config.DescriptionMinLenght = 30
FScript.Config.DescriptionMaxLenght = 500
-- The length of the character's notes.
FScript.Config.NotesLenght = 10000
-- The maximum number of characters that can be created by the player.
FScript.Config.MaxCharacters = 5
-- The delay between each full character save.
FScript.Config.SaveDataTime = 180

-- Allows you to configure the button to open the menu containing all the script commands.
-- All keys from the official Garry's Mod wiki: https://wiki.facepunch.com/gmod/Enums/KEY
FScript.Config.CommandMenuKey = KEY_F2
-- Allows you to configure the button to open the physical description viewer.
-- All enumerations from the official Garry's Mod wiki: https://wiki.facepunch.com/gmod/Enums/IN
FScript.Config.ViewPhysicalDescriptionKey = IN_USE

-- Allows you to block the degradation of the DarkRP's hunger if the player does not have a loaded character.
FScript.Config.HungerProtection = true
-- Allows you to block all damage to the player if he doesn't have a loaded character.
FScript.Config.DamageProtection = true
-- Allows you to delete the player's character if the player dies.
FScript.Config.LostCharacterOnDeath = false
-- Allows you to override job limitations if the player's job is full or unavailable.
FScript.Config.ForceSwitchJob = false
-- Allows you to add an extra line in the default HUD in the DarkRP gamemode for the physical description of the character.
-- BE CAREFUL, if you use a different HUD than the DarkRP one, you have to adapt it for the script and disable this parameter.
FScript.Config.AddCustomDarkRPHUD = true
-- Prevents the player from being reset when creating a character for the first time.
FScript.Config.FirstTimeNoReset = true

-- You can add additional blacklisted weapons. These weapons will not be saved/restored by the script.
FScript.Config.BlacklistedWeapons = {
	["weapon_class1"] = true,
	["weapon_class2"] = true,
}

-- You can write some data that will never be saved or loaded.
-- Example: FScript.Config.IgnoreData = {"Health", "Armor"} => so health and armor will never be saved or loaded.
FScript.Config.IgnoreData = {}

MsgC(FScript.Config.BlueColor, FScript.Config.ScriptPrefix .. table.Count(FScript.Config) .. " settings loaded.\n")

-- Allows you to add or change settings without touching the settings in the file.
hook.Run("FScript.ScriptSettingsLoaded", FScript.Config)