net.Receive("FScript.ViewCharacterInformations.OpenMenu", function()
	local CharacterData = net.ReadTable()

	local RPName = string.Explode(" ", CharacterData["Name"])
	if #RPName == 1 then
		RPName[2] = "-"
	end

	local DermaFrame = vgui.Create("DFrame")
	DermaFrame:SetSize(FScript.ResponsiveWidthSize(600), FScript.ResponsiveHeightSize(570))
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
		surface.DrawLine(10, 60, DermaFrame:GetWide() - 10, 60)

		surface.SetDrawColor(FScript.Config.BlackColor)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local Title = vgui.Create("DLabel", DermaFrame)
	Title:SetText(FScript.Lang.ViewCharacterInformationsTitle)
	Title:SetFont(FScript.Config.TitleFont)
	Title:SetTextColor(FScript.Config.TitleColor)
	Title:SizeToContents()
	Title:SetPos(60, 15)

	local TitleIcon = vgui.Create("DImage", DermaFrame)
	TitleIcon:SetPos(20, 16)
	TitleIcon:SetSize(24, 24)
	TitleIcon:SetImage("icon16/vcard.png")

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

	local FirstnameEntry = vgui.Create("DTextEntry", DermaFrame)
	FirstnameEntry.DefaultText = RPName[1]
	FirstnameEntry:SetPos(10, 75)
	FirstnameEntry:SetSize(DermaFrame:GetWide() - 20, 30)
	FirstnameEntry:SetText(FirstnameEntry.DefaultText)
	FirstnameEntry:SetFont(FScript.Config.TextFont)
	FirstnameEntry:SetDisabled(true)
	FirstnameEntry:SetDrawLanguageID(false)
	FirstnameEntry.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	FirstnameEntry.OnMousePressed = function(self)
		self:SetTextColor(FScript.Config.BlackColor)
	end
	FirstnameEntry.Think = function(self)
		if not self:HasFocus() and string.Trim(self:GetText()) == "" then
			self:SetText(self.DefaultText)
		end
	end
	FirstnameEntry.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > FScript.Config.FirstnameMaxLen then
			self:SetText(self.PrevText or string.sub(Text, 0, FScript.Config.FirstnameMaxLen))
		else
			self.PrevText = Text
		end
	end

	local SurnameEntry = vgui.Create("DTextEntry", DermaFrame)
	SurnameEntry.DefaultText = RPName[2]
	SurnameEntry:SetPos(10, 110)
	SurnameEntry:SetSize(DermaFrame:GetWide() - 20, 30)
	SurnameEntry:SetText(SurnameEntry.DefaultText)
	SurnameEntry:SetFont(FScript.Config.TextFont)
	SurnameEntry:SetDisabled(true)
	SurnameEntry:SetDrawLanguageID(false)
	SurnameEntry.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	SurnameEntry.OnMousePressed = function(self)
		self:SetTextColor(FScript.Config.BlackColor)
	end
	SurnameEntry.Think = function(self)
		if not self:HasFocus() and string.Trim(self:GetText()) == "" then
			self:SetText(self.DefaultText)
		end
	end
	SurnameEntry.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > FScript.Config.SurnameMaxLen then
			self:SetText(self.PrevText or string.sub(Text, 0, FScript.Config.SurnameMaxLen))
		else
			self.PrevText = Text
		end
	end

	local IDEntry = vgui.Create("DTextEntry", DermaFrame)
	IDEntry.DefaultText = CharacterData["ID"]
	IDEntry:SetPos(10, 145)
	IDEntry:SetSize(DermaFrame:GetWide() - 20, 30)
	IDEntry:SetText(IDEntry.DefaultText)
	IDEntry:SetFont(FScript.Config.TextFont)
	IDEntry:SetDisabled(true)
	IDEntry:SetDrawLanguageID(false)
	IDEntry.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	IDEntry.OnMousePressed = function(self)
		self:SetTextColor(FScript.Config.BlackColor)
	end
	IDEntry.Think = function(self)
		if not self:HasFocus() and string.Trim(self:GetText()) == "" then
			self:SetText(self.DefaultText)
		end
	end
	IDEntry.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > FScript.Config.IDLenght then
			self:SetText(self.PrevText or string.sub(Text, 0, FScript.Config.IDLenght))
		else
			self.PrevText = Text
		end
	end

	local DescriptionEntry = vgui.Create("DTextEntry", DermaFrame)
	DescriptionEntry.DefaultText = CharacterData["Description"]
	DescriptionEntry:SetPos(10, 180)
	DescriptionEntry:SetSize(DermaFrame:GetWide() - 20, 120)
	DescriptionEntry:SetText(DescriptionEntry.DefaultText)
	DescriptionEntry:SetFont(FScript.Config.TextFont)
	DescriptionEntry:SetMultiline(true)
	DescriptionEntry:SetVerticalScrollbarEnabled(true)
	DescriptionEntry:SetDisabled(true)
	DescriptionEntry:SetDrawLanguageID(false)
	DescriptionEntry.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	DescriptionEntry.OnMousePressed = function(self)
		self:SetTextColor(FScript.Config.BlackColor)
	end
	DescriptionEntry.Think = function(self)
		if not self:HasFocus() and string.Trim(self:GetText()) == "" then
			self:SetText(self.DefaultText)
		end
	end
	DescriptionEntry.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > FScript.Config.DescriptionMaxLen then
			self:SetText(self.PrevText or string.sub(Text, 0, FScript.Config.DescriptionMaxLen))
		else
			self.PrevText = Text
		end
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

	local ModelPanel = vgui.Create("DModelPanel", DermaFrame)
	ModelPanel:SetAnimated(false)
	ModelPanel.LayoutEntity = function(self) end
	ModelPanel:SetModel(CharacterData["Model"])
	ModelPanel.Think = function(self)
		local _, DescriptionEntryPos = DescriptionEntry:GetPos()
		local _, AddonInfoPos = AddonInfo:GetPos()

		local ModelPanelSize = (AddonInfoPos - 15) - (DescriptionEntryPos + DescriptionEntry:GetTall())
		self:SetSize(ModelPanelSize, ModelPanelSize)
		self:SetPos((DermaFrame:GetWide() - self:GetWide()) / 2, 300)
	end

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