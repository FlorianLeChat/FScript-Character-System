FScript.Lang = {}

--[[
	You can add translations into another language with :

	FScript.Lang["X"] = {
		TooManyCharacters = "Your translation...",
		MustBeAlive = "Your translation...",
		MustPlayCharacter = "Your translation...",
		...
	}

	Where X represents the ISO code of your country: https://en.wikipedia.org/wiki/ISO_3166-1#Current_codes
--]]

FScript.Lang["EN"] = {
	TooManyCharacters = "You have reached the maximum number of characters that can be created.",
	MustBeAlive = "You must be alive to be able to do this action.",
	MustPlayCharacter = "You have to play a character to be able to do this action.",
	MustBeAdmin = "You must be an administrator to be able to do this action.",
	NotSleeping = "You don't have to be sleeping to do this action.",
	InvalidData = "The character data is invalid.",
	CannotSwitchJob = "You cannot change jobs at the moment (DarkRP denial).",
	CreateSuccess = "The character was successfully created.",
	SaveSuccess = "Your character has been successfully saved.",
	LoadSuccess = "Your character has been successfully loaded.",
	EditSuccess = "Your character has been successfully edited.",
	SingleDeleteSuccess = "The character was successfully deleted.",
	PluralDeleteSuccess = "The characters were successfully deleted.",
	ServerSaveSuccess = "All characters on the server have been successfully saved.",
	OperationSuccess = "Operation successfully completed.",
	NoDataFound = "No data found. Creating a new character...",
	DataFound = "Player data found. Loading characters...",
	NoPhysicalDescription = "None description are available right now.",
	WaitCooldown = "You have to wait a bit before you perform this action again.",
	InvalidPlayer = "This player is invalid.",
	PlayerNotFound = "This player cannot be found.",
	TooFar = "You are too far away from this player to perform this action.",
	InternalError = "An internal error has occurred. Please check the server console for more information.",

	FirstnameCheck = "The first name must have a minimum of %s characters and a maximum of %s characters.",
	SurnameCheck = "The surname must have a minimum of %s characters and a maximum of %s characters.",
	IDCheck = "The identification number must only be composed of %s digits.",
	DescriptionCheck = "The physical description must have a minimum of %s character and a maximum of %s characters.",
	NotesCheck = "The notes can contain up to a maximum of %s characters.",
	ModelCheck = "The player model path is invalid or missing.",

	CharacterSavingSuccess = "The character of \"%s\" has been successfully saved.",
	CharacterSavingFailed = "The character of \"%s\" couldn't be saved.",
	LostCharacterOnDead = "%s lost his character when he died.",

	Close = "Close",
	Yes = "Yes",
	No = "No",
	SteamID64 = "SteamID64",
	ID = "ID",
	Warning = "Warning",
	Commands = "Commands",
	Description = "Description",
	Version = "Version",
	Revision = "Revision",

	CreatedBy = "Script created by",
	CreatedOn = "Script created on",
	UpdateOn = "last updated on",

	CharacterRequest = "What do you want to do with this character ?",
	ExecuteCommand = "Do you want to execute this command ? (%s)",
	ExecuteThisCommand = "Execute this command",
	CopyToClipboard = "Copy to clipboard",
	SeeProfile = "See his profile",
	DeleteCharacter = "Delete this character",
	DeleteCharacters = "Delete his characters",

	CheckWaiting = "We check your information...",
	CheckSuccess = "It's all good! Transfer data to the server...",
	RPName = "Roleplay name",
	Number = "Number",

	ChatCommandsTitle = "Chat Commands",
	SaveCharacterCommandInfo = "Allows you to save all the characters on the server.",
	DeleteCharacterCommandInfo = "Allows you to delete the player's current character.",
	DeleteAllCharactersCommandInfo = "Allows you to delete all of the player's characters.",

	CreateCharacterTitle = "Character Creation",
	CreateCharacterSubTitle = "Please create your character.",
	CreateCharacterFirstname = "Write your first name...",
	CreateCharacterSurname = "Write your surname...",
	CreateCharacterID = "Write your identification number...",
	CreateCharacterDescription = "Write your physical description...",
	CreateCharacterValidation = "Create my character",
	CreateCharacterCommandInfo = "Allows you to create a character.",

	ChangeCharacterTitle = "Character Change",
	ChangeCharacterSubTitle = "Please select a character.",
	ChangeCharacterValidation = "Select this character",
	ChangeCharacterCommandInfo = "Allows you to change characters.",

	EditCharacterInformationsTitle = "Character Edition",
	EditCharacterInformationsSubTitle = "You can edit your character information.",
	EditCharacterInformationsValidation = "Edit this character",
	EditCharacterInformationsCommandInfo = "Allows you to edit your character.",

	EditCharacterNotesTitle = "Character notes",
	EditCharacterNotesSubTitle = "Write what you want about this character.",
	EditCharacterNotesDefaultText = "You can write whatever you want within a limit of %s characters.",
	EditCharacterNotesValidation = "Update notes",
	EditCharacterNotesCommandInfo = "Allows access to the character's notes.",

	ViewDatabaseTitle1 = "Database",
	ViewDatabaseSubTitle1 = "Please enter your search...",
	ViewDatabaseSubTitle2 = "Or select a player...",
	ViewDatabaseSubTitle3 = "Search results",
	ViewDatabaseSteamID64Search = "Search by SteamID/SteamID64...",
	ViewDatabaseRPNameSearch = "Search by roleplay name...",
	ViewDatabaseIDSearch = "Search by ID number...",
	ViewDatabaseDescriptionSearch = "Search by physical description...",
	ViewDatabaseValidation = "Start the search",
	ViewDatabaseCharacterEdition = "Do you want to edit the character's information or notes ?",
	ViewDatabaseCharacterDeletion = "Do you want to delete this character or all of the player's characters ?",
	ViewDatabaseCommandInfo = "Allows access to the character's database.",

	ViewCharacterInformationsTitle = "Character Viewer",
	ViewCharacterInformationsCommandInfo = "Allows you to display character information.",

	ForceCharacterCreation = "Force the character's creation",
	ForceCharacterChange = "Force the character's change",
	EditCharacterInformations = "Edit the character's information",
	EditCharacterNotes = "Edit the character's notes",
	SaveThisCharacter = "Save this character",
	DeleteThisCharacter = "Delete this character",
	DeleteAllCharacters = "Delete all his characters",
	ViewCharacterInformations = "See the character's information",
}

FScript.Lang["FR"] = {
	TooManyCharacters = "Vous avez atteint la limite maximale de personnages pouvant être crées.",
	MustBeAlive = "Vous devez être obligatoirement vivant pour pouvoir faire cette action.",
	MustPlayCharacter = "Vous devez jouer un personnage pour pouvoir faire cette action.",
	MustBeAdmin = "Vous devez être un administrateur pour pouvoir faire cette action.",
	NotSleeping = "Vous ne devez pas être en train de dormir pour pouvoir faire cette action.",
	InvalidData = "Les données du personnage sont invalides.",
	CannotSwitchJob = "Vous ne pouvez pas changer de job actuellement (refus du DarkRP).",
	CreateSuccess = "Le personnage a été créé avec succès.",
	SaveSuccess = "Votre personnage a été sauvegardé avec succès.",
	LoadSuccess = "Votre personnage a été chargé avec succès.",
	EditSuccess = "Votre personnage a été édité avec succès.",
	SingleDeleteSuccess = "Le personnage a été supprimé avec succès.",
	PluralDeleteSuccess = "Les personnages ont été supprimés avec succès.",
	ServerSaveSuccess = "Tous les personnages du serveur ont été sauvegardés avec succès.",
	OperationSuccess = "Opération terminée avec succès.",
	NoDataFound = "Aucune donnée trouvée. Création d'un nouveau personnage...",
	DataFound = "Données du joueur trouvées. Chargement des personnages...",
	NoPhysicalDescription = "Aucune description n'est disponible pour le moment.",
	WaitCooldown = "Vous devez attendre un peu avant d'effectuer de nouveau cette action.",
	InvalidPlayer = "Ce joueur est invalide.",
	PlayerNotFound = "Ce joueur est introuvable.",
	TooFar = "Vous êtes trop loin de ce joueur pour effectuer cette action.",
	InternalError = "Une erreur interne s'est produite. Veuillez regarder la console du serveur pour plus d'informations.",

	FirstnameCheck = "Le prénom doit avoir %s caractères minimum et %s caractères maximum.",
	SurnameCheck = "Le nom de famille doit avoir %s caractères minimum et %s caractères maximum.",
	IDCheck = "Le numéro d'identification doit être uniquement composé de %s chiffres.",
	DescriptionCheck = "La description physique doit avoir %s caractères minimum et %s caractères maximum.",
	NotesCheck = "Les notes peuvent contenir jusqu'à %s caractères au maximum.",
	ModelCheck = "Le chemin d'accès du modèle est invalide ou manquant.",

	CharacterSavingSuccess = "Le personnage de \"%s\" (%s) a été sauvegardé avec succès.",
	CharacterSavingFailed = "Le personnage de \"%s\" (%s) n'a pas pu être sauvegardé.",
	LostCharacterOnDead = "%s (%s) a perdu son personnage lors de sa mort.",

	Close = "Fermer",
	Yes = "Oui",
	No = "Non",
	SteamID64 = "SteamID64",
	ID = "ID",
	Warning = "Avertissement",
	Commands = "Commandes",
	Description = "Description",
	Version = "Version",
	Revision = "Révision",

	CreatedBy = "Script créé par",
	CreatedOn = "Script créé le",
	UpdateOn = "dernière mise à jour le",

	CharacterRequest = "Que voulez-vous faire avec ce personnage ?",
	ExecuteCommand = "Voulez-vous exécuter cette commande ? (%s)",
	ExecuteThisCommand = "Exécuter cette commande",
	CopyToClipboard = "Copier dans le presse-papiers",
	SeeProfile = "Voir son profil",
	DeleteCharacter = "Supprimer ce personnage",
	DeleteCharacters = "Supprimer tous ses personnages",

	CheckWaiting = "Nous vérifions vos informations...",
	CheckSuccess = "Tout est bon ! Transfert des données vers le serveur...",
	RPName = "Nom roleplay",
	Number = "Numéro",

	ChatCommandsTitle = "Commandes de chat",
	SaveCharacterCommandInfo = "Permet de sauvegarder tous les personnages du serveur.",
	DeleteCharacterCommandInfo = "Permet de supprimer le personnage actuel du joueur.",
	DeleteAllCharactersCommandInfo = "Permet de supprimer tous les personnages du joueur.",

	CreateCharacterTitle = "Création de personnage",
	CreateCharacterSubTitle = "Veuillez créer votre personnage.",
	CreateCharacterFirstname = "Écrivez votre prénom...",
	CreateCharacterSurname = "Écrivez votre nom de famille...",
	CreateCharacterID = "Écrivez votre numéro d'identification...",
	CreateCharacterDescription = "Écrivez votre description physique...",
	CreateCharacterValidation = "Créer mon personnage",
	CreateCharacterCommandInfo = "Permet de créer un personnage.",

	ChangeCharacterTitle = "Changement de personnage",
	ChangeCharacterSubTitle = "Veuillez sélectionner un personnage.",
	ChangeCharacterValidation = "Sélectionner ce personnage",
	ChangeCharacterCommandInfo = "Permet de changer de personnage.",

	EditCharacterInformationsTitle = "Édition du personnage",
	EditCharacterInformationsSubTitle = "Vous pouvez éditer les informations de votre personnage.",
	EditCharacterInformationsValidation = "Éditer ce personnage",
	EditCharacterInformationsCommandInfo = "Permet d'éditer son personnage.",

	EditCharacterNotesTitle = "Notes du personnage",
	EditCharacterNotesSubTitle = "Écrivez ce que vous voulez à propos de ce personnage.",
	EditCharacterNotesDefaultText = "Vous pouvez écrire ce que vous voulez dans une limite de %s caractères.",
	EditCharacterNotesValidation = "Mettre à jour les notes",
	EditCharacterNotesCommandInfo = "Permet d'accéder aux notes du personnages.",

	ViewDatabaseTitle1 = "Base de données",
	ViewDatabaseSubTitle1 = "Veuillez entrer votre recherche...",
	ViewDatabaseSubTitle2 = "Ou sélectionnez un joueur...",
	ViewDatabaseSubTitle3 = "Résultats de la recherche",
	ViewDatabaseSteamID64Search = "Rechercher par SteamID/SteamID64...",
	ViewDatabaseRPNameSearch = "Rechercher par nom roleplay...",
	ViewDatabaseIDSearch = "Rechercher par numéro d'identification...",
	ViewDatabaseDescriptionSearch = "Rechercher par description physique...",
	ViewDatabaseValidation = "Lancer la recherche",
	ViewDatabaseCharacterEdition = "Voulez-vous éditer les informations ou les notes du personnage ?",
	ViewDatabaseCharacterDeletion = "Voulez-vous supprimer ce personnage ou tous les personnages du joueur ?",
	ViewDatabaseCommandInfo = "Permet d'accéder à la base de données du personnage.",

	ViewCharacterInformationsTitle = "Affichage du personnage",
	ViewCharacterInformationsCommandInfo = "Permet d'afficher les informations du personnage.",

	ForceCharacterCreation = "Forcer la création d'un personnage",
	ForceCharacterChange = "Forcer le changement du personnage",
	EditCharacterInformations = "Éditer les informations ce personnage",
	EditCharacterNotes = "Éditer les notes du personnage",
	SaveThisCharacter = "Sauvegarder ce personnage",
	DeleteThisCharacter = "Supprimer ce personnage",
	DeleteAllCharacters = "Supprimer tous ses personnages",
	ViewCharacterInformations = "Voir les informations du personnage",
}






-- ADD YOUR TRANSLATIONS HERE, NOT FURTHER DOWN.
-- ADD YOUR TRANSLATIONS HERE, NOT FURTHER DOWN.
-- ADD YOUR TRANSLATIONS HERE, NOT FURTHER DOWN.






-- Allows you to add or change translations without touching the settings in the file.
hook.Run("FScript.OnLoadScriptTranslations")

-- If the script does not find a translation in your language, then it will use the English language.
-- We also check if the translation in the chosen language is complete.
local LanguageCode = string.upper(FScript.Config.Language)
local DefaultLanguage = FScript.Lang["EN"]
local SelectedLanguage = FScript.Lang[LanguageCode]

MsgC(FScript.Config.BlueColor, FScript.Config.ScriptPrefix .. "Language initialized : " .. LanguageCode .. ".\n")

local RequestedLanguage = FScript.Lang[LanguageCode]
if RequestedLanguage then
	if table.Count(DefaultLanguage) ~= table.Count(SelectedLanguage) then
		FScript.Lang = DefaultLanguage
		error("\n" .. FScript.Config.ScriptPrefix .. "The translation in this language is not complete. Return to the default language.")
	end

	FScript.Lang = SelectedLanguage
else
	FScript.Lang = DefaultLanguage
	error("\n" .. FScript.Config.ScriptPrefix .. "The translation in this language is missing (" .. LanguageCode .. "). Return to the default language.")
end

MsgC(FScript.Config.BlueColor, FScript.Config.ScriptPrefix .. table.Count(FScript.Lang) .. " translations loaded.\n")

-- When all the translations have been loaded.
hook.Run("FScript.ScriptTranslationsLoaded", FScript.Lang)