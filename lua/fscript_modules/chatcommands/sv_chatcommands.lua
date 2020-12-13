-- For detecting chat commands.
hook.Add("PlayerSay", "FScript.ChatCommands", function(ply, text, teamChat)
	if teamChat then
		return
	end

	for _, v in ipairs(FScript.ChatCommands) do
		if string.StartWith(string.lower(text), v["Name"]) then
			text = string.Replace(text, v["Name"], "")
			text = string.Trim(text)

			local CanUse, Reason = hook.Run("FScript.CanUseChatCommand", ply, v["Name"], text)
			if CanUse == false then
				if Reason then
					FScript.SendNotification(ply, 1, Reason)
				end

				return ""
			end

			v["Func"](ply, text)

			return ""
		end
	end
end)