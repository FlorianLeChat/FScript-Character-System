-- This file is used to add additional options in the player's context menu.

properties.Add("FScript.ForceCreateCharacter", {
	MenuLabel = FScript.Config.ScriptPrefix .. FScript.Lang.ForceCharacterCreation,
	Order =	1,
	MenuIcon = "icon16/user_add.png",

	Filter = function(self, entity, player)
		if not FScript.IsValidPlayer(entity) then
			return false
		end

		if hook.Run("FScript.CanUseAdminTool", player, "FScript.ForceCreateCharacter") == false then
			return false
		end

		return true
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive	= function(self, length, player)
		local entity = net.ReadEntity()
		if self:Filter(entity, player) then
			FScript.CreateCharacter(entity, player)
		end
	end
})

properties.Add("FScript.ForceChangeCharacter", {
	MenuLabel = FScript.Config.ScriptPrefix .. FScript.Lang.ForceCharacterChange,
	Order =	2,
	MenuIcon = "icon16/user_go.png",

	Filter = function(self, entity, player)
		if not FScript.IsValidPlayer(entity) then
			return false
		end

		if hook.Run("FScript.CanUseAdminTool", player, "FScript.ForceChangeCharacter") == false then
			return false
		end

		return true
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive	= function(self, length, player)
		local entity = net.ReadEntity()
		if self:Filter(entity, player) then
			FScript.ChangeCharacter(entity, player)
		end
	end
})

properties.Add("FScript.ViewCharacterInformations", {
	MenuLabel = FScript.Config.ScriptPrefix .. FScript.Lang.ViewCharacterInformations,
	Order =	3,
	MenuIcon = "icon16/vcard.png",

	Filter = function(self, entity, player)
		if not FScript.IsValidPlayer(entity) then
			return false
		end

		if hook.Run("FScript.CanUseAdminTool", player, "FScript.ViewCharacterInformations") == false then
			return false
		end

		return true
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive	= function(self, length, player)
		local entity = net.ReadEntity()
		if self:Filter(entity, player) then
			FScript.ViewCharacterInformations(entity, _, _, player)
		end
	end
})

properties.Add("FScript.EditCharacterInformations", {
	MenuLabel = FScript.Config.ScriptPrefix .. FScript.Lang.EditCharacterInformations,
	Order = 4,
	MenuIcon = "icon16/user_edit.png",

	Filter = function(self, entity, player)
		if not FScript.IsValidPlayer(entity) then
			return false
		end

		if hook.Run("FScript.CanUseAdminTool", player, "FScript.EditCharacterInformations") == false then
			return false
		end

		return true
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive	= function(self, length, player)
		local entity = net.ReadEntity()
		if self:Filter(entity, player) then
			FScript.EditCharacterInformations(entity, _, _, player)
		end
	end
})

properties.Add("FScript.EditCharacterNotes", {
	MenuLabel = FScript.Config.ScriptPrefix .. FScript.Lang.EditCharacterNotes,
	Order =	5,
	MenuIcon = "icon16/page_white_text.png",

	Filter = function(self, entity, player)
		if not FScript.IsValidPlayer(entity) then
			return false
		end

		if hook.Run("FScript.CanUseAdminTool", player, "FScript.EditCharacterNotes") == false then
			return false
		end

		return true
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive	= function(self, length, player)
		local entity = net.ReadEntity()
		if self:Filter(entity, player) then
			FScript.EditCharacterNotes(entity, _, _, player)
		end
	end
})

properties.Add("FScript.SaveCharacter", {
	MenuLabel = FScript.Config.ScriptPrefix .. FScript.Lang.SaveThisCharacter,
	Order =	6,
	MenuIcon = "icon16/server_go.png",

	Filter = function(self, entity, player)
		if not FScript.IsValidPlayer(entity) then
			return false
		end

		if hook.Run("FScript.CanUseAdminTool", player, "FScript.SaveCharacter") == false then
			return false
		end

		return true
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive	= function(self, length, player)
		local entity = net.ReadEntity()
		if self:Filter(entity, player) then
			FScript.SaveCharacter(entity)
		end
	end
})

properties.Add("FScript.DeleteCharacter", {
	MenuLabel = FScript.Config.ScriptPrefix .. FScript.Lang.DeleteThisCharacter,
	Order =	7,
	MenuIcon = "icon16/user_delete.png",

	Filter = function(self, entity, player)
		if not FScript.IsValidPlayer(entity) then
			return false
		end

		if hook.Run("FScript.CanUseAdminTool", player, "FScript.DeleteCharacter") == false then
			return false
		end

		return true
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive	= function(self, length, player)
		local entity = net.ReadEntity()
		if self:Filter(entity, player) then
			FScript.RemoveCharacter(entity)
			FScript.SendNotification(player, 3, FScript.Lang.OperationSuccess)
		end
	end
})

properties.Add("FScript.DeleteAllCharacters", {
	MenuLabel = FScript.Config.ScriptPrefix .. FScript.Lang.DeleteAllCharacters,
	Order =	8,
	MenuIcon = "icon16/group_delete.png",

	Filter = function(self, entity, player)
		if not FScript.IsValidPlayer(entity) then
			return false
		end

		if hook.Run("FScript.CanUseAdminTool", player, "FScript.DeleteAllCharacters") == false then
			return false
		end

		return true
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive	= function(self, length, player)
		local entity = net.ReadEntity()
		if self:Filter(entity, player) then
			FScript.RemoveAllCharacters(entity)
			FScript.SendNotification(player, 3, FScript.Lang.OperationSuccess)
		end
	end
})