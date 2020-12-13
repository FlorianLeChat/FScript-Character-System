--[[
	Source : https://github.com/MysteryPancake/Fun/blob/master/gmod/scaled.lua
	Thanks MysteryPancake !
--]]

-- This function automatically adjusts the menu width.
function FScript.ResponsiveWidthSize(width)
	return (width / 1920) * ScrW()
end

-- This function automatically adjusts the menu height.
function FScript.ResponsiveHeightSize(height)
	return (height / 1080) * ScrH()
end