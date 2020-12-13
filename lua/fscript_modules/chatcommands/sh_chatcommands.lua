-- This file contains all the script commands.
FScript.ChatCommands = {
	{
		["Name"] = "/createchar",
		["Desc"] = FScript.Lang.CreateCharacterCommandInfo,
		["Func"] = function(ply, args)
			FScript.CreateCharacter(ply)
		end,
	},

	{
		["Name"] = "/changechar",
		["Desc"] = FScript.Lang.ChangeCharacterCommandInfo,
		["Func"] = function(ply, args)
			FScript.ChangeCharacter(ply)
		end,
	},

	{
		["Name"] = "/editchar",
		["Desc"] = FScript.Lang.EditCharacterInformationsCommandInfo,
		["Func"] = function(ply, args)
			if FScript.IsValidString(args) then
				local Target = FScript.FindPlayer(args)
				if not Target then
					FScript.SendNotification(ply, 1, FScript.Lang.PlayerNotFound)
					return
				end

				FScript.EditCharacterInformations(Target, _, _, ply)
			else
				FScript.EditCharacterInformations(ply)
			end
		end,
	},

	{
		["Name"] = "/editnotes",
		["Desc"] = FScript.Lang.EditCharacterNotesCommandInfo,
		["Func"] = function(ply, args)
			if FScript.IsValidString(args) then
				local Target = FScript.FindPlayer(args)
				if not Target then
					FScript.SendNotification(ply, 1, FScript.Lang.PlayerNotFound)
					return
				end

				FScript.EditCharacterNotes(Target, _, _, ply)
			else
				FScript.EditCharacterNotes(ply)
			end
		end,
	},

	{
		["Name"] = "/viewdatabase",
		["Desc"] = FScript.Lang.ViewDatabaseCommandInfo,
		["Func"] = function(ply, args)
			FScript.ViewCharacterDatabase(ply)
		end,
	},

	{
		["Name"] = "/viewinformations",
		["Desc"] = FScript.Lang.ViewCharacterInformationsCommandInfo,
		["Func"] = function(ply, args)
			if FScript.IsValidString(args) then
				local Target = FScript.FindPlayer(args)
				if not Target then
					FScript.SendNotification(ply, 1, FScript.Lang.PlayerNotFound)
					return
				end

				FScript.ViewCharacterInformations(Target, _, _, ply)
			else
				FScript.ViewCharacterInformations(ply)
			end
		end,
	},

	{
		["Name"] = "/deletechar",
		["Desc"] = FScript.Lang.DeleteCharacterCommandInfo,
		["Func"] = function(ply, args)
			if FScript.IsValidString(args) then
				local CanDelete, Reason = hook.Run("FScript.CanUseAdminTool", ply, "DeleteCharacter")
				if CanDelete == false then
					if Reason then
						FScript.SendNotification(ply, 1, Reason)
					end

					return
				end

				local Target = FScript.FindPlayer(args)
				if not Target then
					FScript.SendNotification(ply, 1, FScript.Lang.PlayerNotFound)
					return
				end

				FScript.RemoveCharacter(Target)
			else
				FScript.RemoveCharacter(ply)
			end
		end,
	},

	{
		["Name"] = "/deleteallchar",
		["Desc"] = FScript.Lang.DeleteAllCharactersCommandInfo,
		["Func"] = function(ply, args)
			if FScript.IsValidString(args) then
				local CanDelete, Reason = hook.Run("FScript.CanUseAdminTool", ply, "DeleteCharacter")
				if CanDelete == false then
					if Reason then
						FScript.SendNotification(ply, 1, Reason)
					end

					return
				end

				local Target = FScript.FindPlayer(args)
				if not Target then
					FScript.SendNotification(ply, 1, FScript.Lang.PlayerNotFound)
					return
				end

				FScript.RemoveAllCharacters(Target)
			else
				FScript.RemoveAllCharacters(ply)
			end
		end,
	},

	{
		["Name"] = "/saveallchar",
		["Desc"] = FScript.Lang.SaveCharacterCommandInfo,
		["Func"] = function(ply, args)
			local CanUse, Reason = hook.Run("FScript.CanUseAdminTool", ply, "SaveAllCharacters")
			if CanUse == false then
				if Reason then
					FScript.SendNotification(ply, 1, Reason)
				end

				return
			end

			FScript.SaveAllCharacters()
			FScript.SendNotification(ply, 3, FScript.Lang.ServerSaveSuccess)
		end,
	},
}