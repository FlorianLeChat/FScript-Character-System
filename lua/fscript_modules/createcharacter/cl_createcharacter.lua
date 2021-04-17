net.Receive("FScript.CreateCharacter.OpenMenu", function()
	local FirstRun = net.ReadBool()

	local DermaFrame = vgui.Create("DFrame")
	DermaFrame:SetSize(FScript.ResponsiveWidthSize(600), FScript.ResponsiveHeightSize(685))
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
	Title:SetText(FScript.Lang.CreateCharacterTitle)
	Title:SetFont(FScript.Config.TitleFont)
	Title:SetTextColor(FScript.Config.TitleColor)
	Title:SizeToContents()
	Title:SetPos(60, 15)

	local TitleIcon = vgui.Create("DImage", DermaFrame)
	TitleIcon:SetPos(20, 16)
	TitleIcon:SetSize(24, 24)
	TitleIcon:SetImage("icon16/user_add.png")

	if not FirstRun then
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

			net.Start("FScript.CreateCharacter.CloseMenu")
			net.SendToServer()

			DermaFrame:Close()
		end

		local TitlePos = Title:GetPos()
		local TitleWide = Title:GetWide()
		local CloseButtonPos = CloseButton:GetPos()
		if TitlePos + TitleWide >= (CloseButtonPos - 10) then
			local X, Y = Title:GetSize()
			Title:SetSize(X - ((TitlePos + TitleWide) - CloseButtonPos + 10), Y)
		end
	end

	local SubTitle = vgui.Create("DLabel", DermaFrame)
	SubTitle:SetText(FScript.Lang.CreateCharacterSubTitle)
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

	local FirstnameEntry = vgui.Create("DTextEntry", DermaFrame)
	FirstnameEntry.DefaultText = FScript.Lang.CreateCharacterFirstname
	FirstnameEntry:SetPos(10, 110)
	FirstnameEntry:SetSize(DermaFrame:GetWide() - 20, 30)
	FirstnameEntry:SetText(FirstnameEntry.DefaultText)
	FirstnameEntry:SetFont(FScript.Config.TextFont)
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
		elseif self:HasFocus() and self:GetText() == self.DefaultText then
			self:SetText("")
		end
	end
	FirstnameEntry.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > FScript.Config.FirstnameMaxLenght then
			self:SetText(self.PrevText or string.sub(Text, 0, FScript.Config.FirstnameMaxLenght))
		else
			self.PrevText = Text
		end
	end

	local SurnameEntry = vgui.Create("DTextEntry", DermaFrame)
	SurnameEntry.DefaultText = FScript.Lang.CreateCharacterSurname
	SurnameEntry:SetPos(10, 145)
	SurnameEntry:SetSize(DermaFrame:GetWide() - 20, 30)
	SurnameEntry:SetText(SurnameEntry.DefaultText)
	SurnameEntry:SetFont(FScript.Config.TextFont)
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
		elseif self:HasFocus() and self:GetText() == self.DefaultText then
			self:SetText("")
		end
	end
	SurnameEntry.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > FScript.Config.SurnameMaxLenght then
			self:SetText(self.PrevText or string.sub(Text, 0, FScript.Config.SurnameMaxLenght))
		else
			self.PrevText = Text
		end
	end

	local IDEntry = vgui.Create("DTextEntry", DermaFrame)
	IDEntry.DefaultText = FScript.Lang.CreateCharacterID
	IDEntry:SetPos(10, 180)
	IDEntry:SetSize(DermaFrame:GetWide() - 20, 30)
	IDEntry:SetText(IDEntry.DefaultText)
	IDEntry:SetFont(FScript.Config.TextFont)
	IDEntry:SetNumeric(true)
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
		elseif self:HasFocus() and self:GetText() == self.DefaultText then
			self:SetText("")
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
	DescriptionEntry.DefaultText = FScript.Lang.CreateCharacterDescription
	DescriptionEntry:SetPos(10, 215)
	DescriptionEntry:SetSize(DermaFrame:GetWide() - 20, 120)
	DescriptionEntry:SetText(DescriptionEntry.DefaultText)
	DescriptionEntry:SetFont(FScript.Config.TextFont)
	DescriptionEntry:SetMultiline(true)
	DescriptionEntry:SetVerticalScrollbarEnabled(true)
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
		elseif self:HasFocus() and self:GetText() == self.DefaultText then
			self:SetText("")
		end
	end
	DescriptionEntry.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > FScript.Config.DescriptionMaxLenght then
			self:SetText(self.PrevText or string.sub(Text, 0, FScript.Config.DescriptionMaxLenght))
		else
			self.PrevText = Text
		end
	end

	local ModelsList = vgui.Create("DPanelList", DermaFrame)
	ModelsList:SetPos(40, 350)
	ModelsList:SetSize(220, 230)
	ModelsList:EnableVerticalScrollbar(true)
	ModelsList:EnableHorizontal(true)
	ModelsList:SetPadding(10)
	ModelsList:SetSpacing(5)
	ModelsList.Paint = function(self, w, h)
		surface.SetDrawColor(FScript.Config.WhiteColor)
		surface.DrawRect(0, 0, w, h)
	end

	local ModelPanel = vgui.Create("DModelPanel", DermaFrame)
	ModelPanel:SetSize(275, 275)
	ModelPanel:SetPos((DermaFrame:GetWide() - ModelPanel:GetSize()) - 40, 310)
	ModelPanel:SetAnimated(false)
	ModelPanel.LayoutEntity = function(self) end

	for _, v in ipairs(FScript.GetDefaultModels()) do
		local ModelIcon = vgui.Create("SpawnIcon")
		ModelIcon:SetPos(64, 64)
		ModelIcon:SetModel(v)
		ModelsList:AddItem(ModelIcon)
		ModelIcon.OnMousePressed = function()
			ModelPanel:SetModel(v)
		end
	end

	ModelPanel:SetModel(ModelsList:GetItems()[1]:GetModelName())

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
	ConfirmButton:SetText(FScript.Lang.CreateCharacterValidation)
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
		local Firstname = FirstnameEntry:GetText()
		local Surname = SurnameEntry:GetText()
		local ID = IDEntry:GetText()
		local Description = DescriptionEntry:GetText()
		local PlayerModel = ModelPanel:GetModel()

		if not FScript.IsValidData(Firstname, "^[%a-Ѐ-џ]+$", FScript.Config.FirstnameMinLenght, FScript.Config.FirstnameMaxLenght, FirstnameEntry.DefaultText) then
			surface.PlaySound(FScript.Config.ErrorSound)

			ValidationText:SetText(string.format(FScript.Lang.FirstnameCheck, FScript.Config.FirstnameMinLenght, FScript.Config.FirstnameMaxLenght))
			ValidationText:SetColor(FScript.Config.RedColor)
			ValidationIcon:SetImage("icon16/cancel.png")

			FirstnameEntry:SetTextColor(FScript.Config.RedColor)

			return
		elseif not FScript.IsValidData(Surname, "^[%a-Ѐ-џ]+$", FScript.Config.SurnameMinLenght, FScript.Config.SurnameMaxLenght, SurnameEntry.DefaultText) then
			surface.PlaySound(FScript.Config.ErrorSound)

			ValidationText:SetText(string.format(FScript.Lang.SurnameCheck, FScript.Config.SurnameMinLenght, FScript.Config.SurnameMaxLenght))
			ValidationText:SetColor(FScript.Config.RedColor)
			ValidationIcon:SetImage("icon16/cancel.png")

			SurnameEntry:SetTextColor(FScript.Config.RedColor)

			return
		elseif not FScript.IsValidData(ID, "^[%d]+$", FScript.Config.IDLenght, FScript.Config.IDLenght, IDEntry.DefaultText) then
			surface.PlaySound(FScript.Config.ErrorSound)

			ValidationText:SetText(string.format(FScript.Lang.IDCheck, FScript.Config.IDLenght))
			ValidationText:SetColor(FScript.Config.RedColor)
			ValidationIcon:SetImage("icon16/cancel.png")

			IDEntry:SetTextColor(FScript.Config.RedColor)

			return
		elseif not FScript.IsValidData(Description, "^[%w-%p-%s-Ѐ-џ]+$", FScript.Config.DescriptionMinLenght, FScript.Config.DescriptionMaxLenght, DescriptionEntry.DefaultText) then
			surface.PlaySound(FScript.Config.ErrorSound)

			ValidationText:SetText(string.format(FScript.Lang.DescriptionCheck, FScript.Config.DescriptionMinLenght, FScript.Config.DescriptionMaxLenght))
			ValidationText:SetColor(FScript.Config.RedColor)
			ValidationIcon:SetImage("icon16/cancel.png")

			DescriptionEntry:SetTextColor(FScript.Config.RedColor)

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

		local CharacterData = {}
		CharacterData[1] = Firstname
		CharacterData[2] = Surname
		CharacterData[3] = ID
		CharacterData[4] = Description
		CharacterData[5] = PlayerModel

		surface.PlaySound(FScript.Config.ClickSound)

		net.Start("FScript.CreateCharacter.Validate")
			net.WriteTable(CharacterData)
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