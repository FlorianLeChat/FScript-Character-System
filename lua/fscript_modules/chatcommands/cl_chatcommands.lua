local LastOpenTime = 0

hook.Add("PlayerButtonDown", "FScript.ChatCommands", function(ply, button)
	if button ~= FScript.Config.CommandMenuKey then
		return
	end

	if CurTime() < LastOpenTime then
		return
	end

	LastOpenTime = CurTime() + 0.5

	local CanOpen = hook.Run("FScript.CanOpenPlayerMenu", ply, "ChatCommands")
	if CanOpen == false then
		return
	end

	local DermaFrame = vgui.Create("DFrame")
	DermaFrame:SetSize(FScript.ResponsiveWidthSize(550), FScript.ResponsiveHeightSize(380))
	DermaFrame:SetTitle("")
	DermaFrame:ShowCloseButton(false)
	DermaFrame:SetDraggable(false)
	DermaFrame:Center()
	DermaFrame:MakePopup()
	DermaFrame.Paint = function(self, w, h)
		Derma_DrawBackgroundBlur(self)

		surface.SetDrawColor(FScript.Config.DermaBackgroundColor)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(FScript.Config.BlackColor)
		surface.DrawLine(10, 60, self:GetWide() - 10, 60)

		surface.SetDrawColor(FScript.Config.BlackColor)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local Title = vgui.Create("DLabel", DermaFrame)
	Title:SetText(FScript.Lang.ChatCommandsTitle)
	Title:SetFont(FScript.Config.TitleFont)
	Title:SetTextColor(FScript.Config.TitleColor)
	Title:SizeToContents()
	Title:SetPos(60, 15)

	local TitleIcon = vgui.Create("DImage", DermaFrame)
	TitleIcon:SetPos(20, 16)
	TitleIcon:SetSize(24, 24)
	TitleIcon:SetImage("icon16/text_list_bullets.png")

	local CloseButton = vgui.Create("DButton", DermaFrame)
	CloseButton:SetSize(80, 30)
	CloseButton:SetPos(DermaFrame:GetWide() - 100, 15)
	CloseButton:SetFont(FScript.Config.SubTitleFont)
	CloseButton:SetText(FScript.Lang.Close)
	CloseButton.Slide = 0
	CloseButton.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Slide = Lerp(0.05, self.Slide, w)
			self:SetColor(FScript.Config.BlackColor)
			draw.RoundedBox(5, 0, 0, w, h, FScript.Config.ButtonColor)
			draw.RoundedBox(5, 0, 0, self.Slide, h, FScript.Config.WhiteColor)
		else
			self.Slide = Lerp(0.05, self.Slide, 0)
			self:SetColor(FScript.Config.WhiteColor)
			draw.RoundedBox(5, 0, 0, w, h, FScript.Config.RedColor)
			draw.RoundedBox(5, 0, 0, self.Slide, h, FScript.Config.WhiteColor)
		end
	end
	CloseButton.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	CloseButton.DoClick = function()
		surface.PlaySound(FScript.Config.ClickSound)
		DermaFrame:Close()
	end

	local TitlePos = Title:GetPos()
	local TitleWide = Title:GetWide()
	local CloseButtonPos = CloseButton:GetPos()
	if TitlePos + TitleWide >= (CloseButtonPos - 10) then
		local X, Y = Title:GetSize()
		Title:SetSize(X - ((TitlePos + TitleWide) - CloseButtonPos + 10), Y)
	end

	local DermaList = vgui.Create("DListView", DermaFrame)
	DermaList:SetMultiSelect(false)
	DermaList:Dock(FILL)
	DermaList:DockMargin(0, 50, 0, 35)

	local Column1 = DermaList:AddColumn(FScript.Lang.Commands)
	Column1:SetMinWidth(150)
	Column1:SetMaxWidth(150)

	local Column2 = DermaList:AddColumn(FScript.Lang.Description)

	for _, v in SortedPairs(FScript.GetChatCommands()) do
		DermaList:AddLine(v["Name"], v["Desc"])
	end

	DermaList.DoDoubleClick = function(line, index)
		surface.PlaySound(FScript.Config.ClickSound)

		local SelectedCommand = DermaList:GetLine(index):GetValue(1)

		Derma_Query(string.format(FScript.Lang.ExecuteCommand, SelectedCommand), FScript.Lang.Warning,
			FScript.Lang.Yes, function()
				RunConsoleCommand("say", SelectedCommand)
				DermaFrame:Close()
			end,

			FScript.Lang.No, function()

			end
		)
	end

	DermaList.OnRowRightClick = function(line, index)
		surface.PlaySound(FScript.Config.ClickSound)

		local Menu = DermaMenu()
		local SelectedCommand = DermaList:GetLine(index):GetValue(1)

		local ExecuteButton = Menu:AddOption(FScript.Lang.ExecuteThisCommand)
		ExecuteButton:SetIcon("icon16/application_xp_terminal.png")
		ExecuteButton.DoClick = function(self)
			Derma_Query(string.format(FScript.Lang.ExecuteCommand, SelectedCommand), FScript.Lang.Warning,
				FScript.Lang.Yes, function()
					RunConsoleCommand("say", SelectedCommand)
					DermaFrame:Close()
				end,

				FScript.Lang.No, function()

				end
			)
		end

		local CopyButton = Menu:AddOption(FScript.Lang.CopyToClipboard)
		CopyButton:SetIcon("icon16/page_white_add.png")
		CopyButton.DoClick = function(self)
			SetClipboardText(SelectedCommand)
			DermaFrame:Close()
		end

		Menu:Open()
	end

	local AddonInfo = vgui.Create("DLabel", DermaFrame)
	AddonInfo:SetText("FScript - " .. FScript.Lang.Version .. " " .. FScript.Info.Version .. " " .. FScript.Lang.Revision .. " " .. FScript.Info.Revision)
	AddonInfo:SetFont(FScript.Config.TextFont)
	AddonInfo:SetTextColor(Color(82, 82, 82))
	AddonInfo:SetVisible(false)
	AddonInfo:SizeToContents()
	AddonInfo:SetPos((DermaFrame:GetWide() - AddonInfo:GetWide()) / 2, DermaFrame:GetTall() - 30)

	local AddonIcon = vgui.Create("DImage", DermaFrame)
	AddonIcon:SetPos(AddonInfo:GetPos() - 25, DermaFrame:GetTall() - 30)
	AddonIcon:SetSize(16, 16)
	AddonIcon:SetImage("icon16/lightbulb.png")
	AddonIcon:SetVisible(false)

	local CreditText = vgui.Create("RichText", DermaFrame)
	CreditText:SetSize(300, 20)
	CreditText:InsertColorChange(82, 82, 82, 255)

	local Words = {"Made", "By", "Florian", "Dubois", "<3"}
	local Delay = 0

	for k, v in ipairs(Words) do
		if k == 1 then
			Delay = 0.2
		else
			Delay = (k - 1) * 0.45
		end

		timer.Simple(Delay, function()
			if IsValid(DermaFrame) then
				CreditText:AppendText(v .. " ")
				CreditText:InsertFade(2, 1)
				CreditText:SetFontInternal(FScript.Config.TextFont)
				CreditText:SetPos((DermaFrame:GetWide() - AddonInfo:GetWide()) / 2, DermaFrame:GetTall() - 30)
			end
		end)
	end

	timer.Simple(4, function()
		if IsValid(DermaFrame) then
			AddonInfo:SetVisible(true)
			AddonIcon:SetVisible(true)
		end
	end)
end)