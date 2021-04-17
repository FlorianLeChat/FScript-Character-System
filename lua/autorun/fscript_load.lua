-- DON'T TOUCH ANYTHING BELOW IT.

if FScript then return end

FScript = FScript or {}
FScript.Config = FScript.Config or {}
FScript.Info = FScript.Info or {}

FScript.Info.Version = "4"
FScript.Info.Revision = "3"
FScript.Info.InitialDate = "27/01/2018"
FScript.Info.UpdateDate = "17/04/2021"

local rootFolder = "fscript_modules/"
local _, folders = file.Find(rootFolder .. "*", "LUA")

hook.Run("FScript.OnStartedLoading")

if SERVER then
	AddCSLuaFile("fscript_settings.lua")
	AddCSLuaFile("fscript_translations.lua")

	include("fscript_settings.lua")
	include("fscript_translations.lua")

	for _, folder in ipairs(folders) do
		for _, file in ipairs(file.Find(rootFolder .. folder .. "/sh_*.lua", "LUA")) do
			AddCSLuaFile(rootFolder .. folder .. "/" .. file)
			include(rootFolder .. folder .. "/" .. file)
		end

		for _, file in ipairs(file.Find(rootFolder .. folder .. "/sv_*.lua", "LUA")) do
			include(rootFolder .. folder .. "/" .. file)
		end

		for _, file in ipairs(file.Find(rootFolder .. folder .. "/cl_*.lua", "LUA")) do
			AddCSLuaFile(rootFolder .. folder .. "/" .. file)
		end
	end
else
	include("fscript_settings.lua")
	include("fscript_translations.lua")

	for _, folder in ipairs(folders) do
		for _, file in ipairs(file.Find(rootFolder .. folder .. "/sh_*.lua", "LUA")) do
			include(rootFolder .. folder .. "/" .. file)
		end

		for _, file in ipairs(file.Find(rootFolder .. folder .. "/cl_*.lua", "LUA")) do
			include(rootFolder .. folder .. "/" .. file)
		end
	end
end

hook.Run("FScript.OnFinishedLoading")