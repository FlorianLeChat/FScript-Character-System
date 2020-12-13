-- Please leave me the credits :D

local AsciiLogo1 = [[

        ________           _                _____           _       __
       / ____/ /___  _____(_)___ _____     / ___/__________(_)___  / /_
      / /_  / / __ \/ ___/ / __ `/ __ \    \__ \/ ___/ ___/ / __ \/ __/
     / __/ / / /_/ / /  / / /_/ / / / /   ___/ / /__/ /  / / /_/ / /_
    /_/   /_/\____/_/  /_/\__,_/_/ /_/   /____/\___/_/  /_/ .___/\__/
                                                         /_/
]]

local AsciiLogo2 = [[

        ___________           _       __
       / ____/ ___/__________(_)___  / /_
      / /_   \__ \/ ___/ ___/ / __ \/ __/
     / __/  ___/ / /__/ /  / / /_/ / /_
    /_/    /____/\___/_/  /_/ .___/\__/
                           /_/
]]

local Color1 = Color(0, 180, 240)
local Color2 = Color(255, 255, 255)

local function DrawCredits()
	MsgC(Color1, "\n" .. AsciiLogo1, Color1, AsciiLogo2 .. "\n")
	MsgC(Color1, "[FScript] ", Color2, FScript.Lang.CreatedBy .. " Florian Dubois => https://steamcommunity.com/profiles/76561198053479101/\n")
	MsgC(Color1, "[FScript] ", Color2, FScript.Lang.Version .. " " .. FScript.Info.Version .. " " .. FScript.Lang.Revision .. " " .. FScript.Info.Revision .. " (" .. FScript.Lang.CreatedOn .. " " .. FScript.Info.InitialDate .. ", " .. FScript.Lang.UpdateOn .. " " .. FScript.Info.UpdateDate .. ")\n")
end

if CLIENT then
	net.Receive("FScript.Credits", function()
		DrawCredits()
	end)
else
	util.AddNetworkString("FScript.Credits")

	hook.Add("InitPostEntity", "FScript.Credits", function()
		DrawCredits()
	end)

	hook.Add("PlayerInitialSpawn", "FScript.Credits", function(ply, transition)
		net.Start("FScript.Credits")
		net.Send(ply)
	end)
end