-- DON'T TOUCH ANYTHING BELOW IT.

if FScript then return end

FScript = FScript or {}
FScript.Config = FScript.Config or {}
FScript.Info = FScript.Info or {}

FScript.Info.Version = "4"
FScript.Info.Revision = "4"
FScript.Info.InitialDate = "27/01/2018"
FScript.Info.UpdateDate = "28/05/2021"

local rootFolder = "fscript_modules/"
local _, folders = file.Find(rootFolder .. "*", "LUA")

hook.Run("FScript.OnStartedLoading")

if SERVER then
	AddCSLuaFile("fscript_settings.lua")
	AddCSLuaFile("fscript_translations.lua")

	include("fscript_settings.lua")
	include("fscript_translations.lua")

	for _, Folder in ipairs(folders) do
		for _, File in ipairs(file.Find(rootFolder .. Folder .. "/sh_*.lua", "LUA")) do
			AddCSLuaFile(rootFolder .. Folder .. "/" .. File)
			include(rootFolder .. Folder .. "/" .. File)
		end

		for _, File in ipairs(file.Find(rootFolder .. Folder .. "/sv_*.lua", "LUA")) do
			include(rootFolder .. Folder .. "/" .. File)
		end

		for _, File in ipairs(file.Find(rootFolder .. Folder .. "/cl_*.lua", "LUA")) do
			AddCSLuaFile(rootFolder .. Folder .. "/" .. File)
		end
	end
else
	include("fscript_settings.lua")
	include("fscript_translations.lua")

	for _, Folder in ipairs(folders) do
		for _, File in ipairs(file.Find(rootFolder .. Folder .. "/sh_*.lua", "LUA")) do
			include(rootFolder .. Folder .. "/" .. File)
		end

		for _, File in ipairs(file.Find(rootFolder .. Folder .. "/cl_*.lua", "LUA")) do
			include(rootFolder .. Folder .. "/" .. File)
		end
	end
end

hook.Run("FScript.OnFinishedLoading")