net.Receive("FScript.EditCharacterNotes.OpenMenu", function(len)
	local Notes = net.ReadString()

	local DermaFrame = vgui.Create("DFrame")
	DermaFrame:SetSize(FScript.ResponsiveWidthSize(600), FScript.ResponsiveHeightSize(700))
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
	Title:SetText(FScript.Lang.EditCharacterNotesTitle)
	Title:SetFont(FScript.Config.TitleFont)
	Title:SetTextColor(FScript.Config.TitleColor)
	Title:SizeToContents()
	Title:SetPos(60, 15)

	local TitleIcon = vgui.Create("DImage", DermaFrame)
	TitleIcon:SetPos(20, 16)
	TitleIcon:SetSize(24, 24)
	TitleIcon:SetImage("icon16/page_white_text.png")

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

	local SubTitle = vgui.Create("DLabel", DermaFrame)
	SubTitle:SetText(FScript.Lang.EditCharacterNotesSubTitle)
	SubTitle:SetFont(FScript.Config.SubTitleFont)
	SubTitle:SetTextColor(FScript.Config.TextColor)
	SubTitle:SizeToContents()
	SubTitle:SetPos((DermaFrame:GetWide() - SubTitle:GetWide()) / 2, 70)

	local SubTitlePos = SubTitle:GetPos()
	local SubTitleWide = SubTitle:GetWide()
	local DermaFrameWide = DermaFrame:GetWide()
	if SubTitlePos + SubTitleWide >= (DermaFrameWide - 40) then
		local _, Y = SubTitle:GetSize()
		SubTitle:SetPos(20, 70)
		SubTitle:SetSize(DermaFrameWide - 40, Y)
	end

	local NotesEntry = vgui.Create("DTextEntry", DermaFrame)
	NotesEntry.DefaultText = string.format(FScript.Lang.EditCharacterNotesDefaultText, FScript.Config.NotesLenght)
	NotesEntry:SetText(FScript.IsValidString(Notes) and Notes or NotesEntry.DefaultText)
	NotesEntry:SetFont(FScript.Config.TextFont)
	NotesEntry:Dock(FILL)
	NotesEntry:DockMargin(5, 80, 5, 95)
	NotesEntry:SetMultiline(true)
	NotesEntry:SetVerticalScrollbarEnabled(true)
	NotesEntry:SetDrawLanguageID(false)
	NotesEntry.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	NotesEntry.OnMousePressed = function(self)
		self:SetTextColor(FScript.Config.BlackColor)
	end
	NotesEntry.Think = function(self)
		if not self:HasFocus() and string.Trim(self:GetText()) == "" then
			self:SetText(self.DefaultText)
		elseif self:HasFocus() and self:GetText() == self.DefaultText then
			self:SetText("")
		end
	end
	NotesEntry.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > FScript.Config.NotesLenght then
			self:SetText(self.PrevText or string.sub(Text, 0, FScript.Config.NotesLenght))
		else
			self.PrevText = Text
		end
	end

	local ValidationText = vgui.Create("DLabel", DermaFrame)
	ValidationText:SetText(FScript.Lang.CheckWaiting)
	ValidationText:SetColor(FScript.Config.TextColor)
	ValidationText:SetFont(FScript.Config.TextFont)
	ValidationText.Think = function(self)
		self:SizeToContents()
		self:SetPos(((DermaFrame:GetWide() - self:GetWide()) / 2) + 12.5, DermaFrame:GetTall() - 90)
	end

	local ValidationIcon = vgui.Create("DImage", DermaFrame)
	ValidationIcon:SetSize(16, 16)
	ValidationIcon:SetImage("icon16/magnifier.png")
	ValidationIcon.Think = function(self)
		self:SetPos(ValidationText:GetPos() - 25, DermaFrame:GetTall() - 90)
	end

	local ConfirmButton = vgui.Create("DButton", DermaFrame)
	ConfirmButton:SetText(FScript.Lang.EditCharacterNotesValidation)
	ConfirmButton:SetIcon("icon16/tick.png")
	ConfirmButton:SetSize(DermaFrame:GetWide() - 20, 25)
	ConfirmButton:SetPos((DermaFrame:GetWide() - ConfirmButton:GetWide()) / 2, DermaFrame:GetTall() - 65)
	ConfirmButton.Slide = 0
	ConfirmButton.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Slide = Lerp(0.05, self.Slide, w)
			self:SetColor(FScript.Config.BlackColor)
			draw.RoundedBox(5, 0, 0, w, h, FScript.Config.ButtonColor)
			draw.RoundedBox(5, 0, 0, self.Slide, h, FScript.Config.WhiteColor)
		else
			self.Slide = Lerp(0.05, self.Slide, 0)
			self:SetColor(FScript.Config.WhiteColor)
			draw.RoundedBox(5, 0, 0, w, h, FScript.Config.GreenColor)
			draw.RoundedBox(5, 0, 0, self.Slide, h, FScript.Config.WhiteColor)
		end
	end
	ConfirmButton.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	ConfirmButton.DoClick = function(self)
		local CharacterNotes = NotesEntry:GetText()
		if not FScript.IsValidData(CharacterNotes, "^[%w-%p-%s-Ѐ-џ]+$", 0, FScript.Config.NotesLenght, NotesEntry.DefaultText) then
			surface.PlaySound(FScript.Config.ErrorSound)

			ValidationText:SetText(string.format(FScript.Lang.NotesCheck, FScript.Config.NotesLenght))
			ValidationText:SetColor(FScript.Config.RedColor)
			ValidationIcon:SetImage("icon16/cancel.png")

			NotesEntry:SetTextColor(FScript.Config.RedColor)

			return
		end

		-- We throw an error if we reach the limit of strings that can be sent over the network.
		-- https://wiki.facepunch.com/gmod/net.WriteString
		if #CharacterNotes > 64000 then
			surface.PlaySound(FScript.Config.ErrorSound)

			ValidationText:SetText(FScript.Lang.InternalError)
			ValidationText:SetColor(FScript.Config.RedColor)
			ValidationIcon:SetImage("icon16/cancel.png")

			NotesEntry:SetTextColor(FScript.Config.RedColor)

			return
		end

		self:Remove()

		local ProgressBar = vgui.Create("DProgress", DermaFrame)
		ProgressBar:SetSize(DermaFrame:GetWide() - 20, 25)
		ProgressBar:SetPos((DermaFrame:GetWide() - ConfirmButton:GetWide()) / 2, DermaFrame:GetTall() - 65)
		ProgressBar:SetFraction(0)

		timer.Simple(0.25, function()
			if IsValid(ProgressBar) then
				ProgressBar:SetFraction(0.25)
			end
		end)

		timer.Simple(0.50, function()
			if IsValid(ProgressBar) then
				ProgressBar:SetFraction(0.50)
			end
		end)

		timer.Simple(0.75, function()
			if IsValid(ProgressBar) then
				ProgressBar:SetFraction(0.75)
			end
		end)

		timer.Simple(0.9, function()
			if IsValid(ProgressBar) then
				ProgressBar:SetFraction(1)
			end
		end)

		ValidationText:SetText(FScript.Lang.CheckSuccess)
		ValidationText:SetColor(FScript.Config.GreenColor)
		ValidationIcon:SetImage("icon16/accept.png")

		surface.PlaySound(CRP.Config.ClickSound)

		net.Start("FScript.EditCharacterNotes.Validate")
			net.WriteString(CharacterNotes)
			FScript.ValidateNetworkMessage()
		net.SendToServer()

		timer.Simple(1, function()
			if IsValid(DermaFrame) then
				DermaFrame:Close()
			end
		end)
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