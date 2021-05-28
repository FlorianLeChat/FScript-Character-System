local CameraPosition = Vector(70, 0, 55)

net.Receive("FScript.ChangeCharacter.OpenMenu", function(len)
	local Characters = net.ReadTable()
	local CurrentCharacter = 1

	local DermaFrame = vgui.Create("DFrame")
	DermaFrame:SetSize(FScript.ResponsiveWidthSize(700), FScript.ResponsiveHeightSize(600))
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
	Title:SetText(FScript.Lang.ChangeCharacterTitle)
	Title:SetFont(FScript.Config.TitleFont)
	Title:SetTextColor(FScript.Config.TitleColor)
	Title:SizeToContents()
	Title:SetPos(60, 15)

	local TitleIcon = vgui.Create("DImage", DermaFrame)
	TitleIcon:SetPos(20, 16)
	TitleIcon:SetSize(24, 24)
	TitleIcon:SetImage("icon16/group_go.png")

	local ply = LocalPlayer()
	if IsValid(ply) and ply:IsAdmin() then
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
	end

	local SubTitle = vgui.Create("DLabel", DermaFrame)
	SubTitle:SetText(FScript.Lang.ChangeCharacterSubTitle)
	SubTitle:SetFont(FScript.Config.SubTitleFont)
	SubTitle:SetTextColor(FScript.Config.TextColor)
	SubTitle:SizeToContents()
	SubTitle:SetPos((DermaFrame:GetWide() - SubTitle:GetWide()) / 2, 70)

	do
		local SubTitlePos = SubTitle:GetPos()
		local SubTitleWide = SubTitle:GetWide()
		local DermaFrameWide = DermaFrame:GetWide()
		if SubTitlePos + SubTitleWide >= (DermaFrameWide - 40) then
			local _, Y = SubTitle:GetSize()
			SubTitle:SetPos(20, 70)
			SubTitle:SetSize(DermaFrameWide - 40, Y)
		end
	end

	local AllCharacters = vgui.Create("DLabel", DermaFrame)
	AllCharacters:SetTextColor(FScript.Config.TextColor)
	AllCharacters:SetFont(FScript.Config.TextFont)
	AllCharacters.Think = function(self)
		self:SetText(CurrentCharacter .. " / " .. #Characters)
		self:SizeToContents()
		self:SetPos((DermaFrame:GetWide() - self:GetWide()) / 2, DermaFrame:GetTall() - 155)
	end

	local CharactersIcon = vgui.Create("DImage", DermaFrame)
	CharactersIcon:SetSize(16, 16)
	CharactersIcon:SetImage("icon16/text_list_numbers.png")
	CharactersIcon.Think = function(self)
		self:SetPos(AllCharacters:GetPos() - 25, DermaFrame:GetTall() - 155)
	end

	local ModelPanel = vgui.Create("DModelPanel", DermaFrame)
	ModelPanel:SetModel(Characters[CurrentCharacter]["Model"])
	ModelPanel:SetCamPos(CameraPosition)
	ModelPanel:SetAnimated(false)
	ModelPanel.LayoutEntity = function(self) end
	ModelPanel.Think = function(self)
		local _, SubTitlePos = SubTitle:GetPos()
		local _, AllCharactersPos = AllCharacters:GetPos()

		local ModelPanelSize = (AllCharactersPos - 15) - (SubTitlePos + SubTitle:GetTall())
		self:SetSize(ModelPanelSize, ModelPanelSize)
		self:SetPos((DermaFrame:GetWide() - self:GetWide()) / 2, 95)
	end

	local CharacterName = vgui.Create("DLabel", DermaFrame)
	CharacterName:SetTextColor(FScript.Config.TextColor)
	CharacterName:SetFont(FScript.Config.TextFont)
	CharacterName.Think = function(self)
		self:SetText(Characters[CurrentCharacter]["Name"])
		self:SizeToContents()
		self:SetPos((DermaFrame:GetWide() - self:GetWide()) / 2, DermaFrame:GetTall() - 135)
	end

	local NameIcon = vgui.Create("DImage", DermaFrame)
	NameIcon:SetSize(16, 16)
	NameIcon:SetImage("icon16/vcard.png")
	NameIcon.Think = function(self)
		self:SetPos(CharacterName:GetPos() - 25, DermaFrame:GetTall() - 135)
	end

	local CharacterHealth = vgui.Create("DLabel", DermaFrame)
	CharacterHealth:SetTextColor(FScript.Config.TextColor)
	CharacterHealth:SetFont(FScript.Config.TextFont)
	CharacterHealth:SizeToContents()
	CharacterHealth.Think = function(self)
		self:SetText(Characters[CurrentCharacter]["Health"] .. "%")
		self:SizeToContents()
		self:SetPos((DermaFrame:GetWide() / 2) - (self:GetWide() + 10), DermaFrame:GetTall() - 115)
	end

	local HealthIcon = vgui.Create("DImage", DermaFrame)
	HealthIcon:SetSize(16, 16)
	HealthIcon:SetImage("icon16/heart.png")
	HealthIcon.Think = function(self)
		self:SetPos(CharacterHealth:GetPos() - 25, DermaFrame:GetTall() - 115)
	end

	local CharacterArmor = vgui.Create("DLabel", DermaFrame)
	CharacterArmor:SetTextColor(FScript.Config.TextColor)
	CharacterArmor:SetFont(FScript.Config.TextFont)
	CharacterArmor:SizeToContents()
	CharacterArmor.Think = function(self)
		self:SetText(Characters[CurrentCharacter]["Armor"] .. "%")
		self:SizeToContents()
		self:SetPos((CharacterHealth:GetPos() + CharacterHealth:GetWide()) + 30, DermaFrame:GetTall() - 115)
	end

	local ArmorIcon = vgui.Create("DImage", DermaFrame)
	ArmorIcon:SetSize(16, 16)
	ArmorIcon:SetImage("icon16/shield.png")
	ArmorIcon.Think = function(self)
		self:SetPos(CharacterArmor:GetPos() - 20, DermaFrame:GetTall() - 115)
	end

	local CharacterJob = vgui.Create("DLabel", DermaFrame)
	CharacterJob:SetTextColor(FScript.Config.TextColor)
	CharacterJob:SetFont(FScript.Config.TextFont)
	CharacterJob:SizeToContents()
	CharacterJob.Think = function(self)
		local JobName = DarkRP and DarkRP.getJobByCommand(Characters[CurrentCharacter]["Job"])

		self:SetText((JobName and JobName.name) or "N/A")
		self:SizeToContents()
		self:SetPos((DermaFrame:GetWide() - self:GetWide()) / 2, DermaFrame:GetTall() - 95)
	end

	local JobIcon = vgui.Create("DImage", DermaFrame)
	JobIcon:SetSize(16, 16)
	JobIcon:SetImage("icon16/user_suit.png")
	JobIcon.Think = function(self)
		self:SetPos(CharacterJob:GetPos() - 25, DermaFrame:GetTall() - 95)
	end

	local LeftArrow = vgui.Create("DButton", DermaFrame)
	LeftArrow:SetText("←")
	LeftArrow:SetFont(FScript.Config.TitleFont)
	LeftArrow:SetTextColor(FScript.Config.WhiteColor)
	LeftArrow:Dock(LEFT)
	LeftArrow:DockMargin(0, 45, 0, 0)
	LeftArrow.Paint = function(self, w, h)
		draw.RoundedBox(5, 0, 0, w, h, FScript.Config.ButtonColor)
	end
	LeftArrow.OnCursorEntered = function(self)
		surface.PlaySound(FScript.Config.HoverSound)
	end
	LeftArrow.DoClick = function(self)
		if CurrentCharacter ~= 1 then
			surface.PlaySound(FScript.Config.ClickSound)
			CurrentCharacter = CurrentCharacter - 1
		else
			surface.PlaySound(FScript.Config.ErrorSound)

			self:SetText("X")

			timer.Simple(1, function()
				if IsValid(self) then
					self:SetText("←")
				end
			end)
		end
	end

	local RightArrow = vgui.Create("DButton", DermaFrame)
	RightArrow:SetText("→")
	RightArrow:SetFont(FScript.Config.TitleFont)
	RightArrow:SetTextColor(FScript.Config.WhiteColor)
	RightArrow:Dock(RIGHT)
	RightArrow:DockMargin(0, 45, 0, 0)
	RightArrow.Paint = function(self, w, h)
		draw.RoundedBox(5, 0, 0, w, h, FScript.Config.ButtonColor)
	end
	RightArrow.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	RightArrow.DoClick = function(self)
		if CurrentCharacter ~= #Characters then
			surface.PlaySound(FScript.Config.ClickSound)
			CurrentCharacter = CurrentCharacter + 1
		else
			surface.PlaySound(FScript.Config.ErrorSound)

			self:SetText("X")

			timer.Simple(1, function()
				if IsValid(self) then
					self:SetText("→")
				end
			end)
		end
	end

	local ConfirmButton = vgui.Create("DButton", DermaFrame)
	ConfirmButton:SetText(FScript.Lang.ChangeCharacterValidation)
	ConfirmButton:SetIcon("icon16/tick.png")
	ConfirmButton:SetSize(300, 25)
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
	ConfirmButton.DoClick = function()
		surface.PlaySound(FScript.Config.ClickSound)

		net.Start("FScript.ChangeCharacter.Validate")
			net.WriteInt(CurrentCharacter, 4)
		net.SendToServer()

		DermaFrame:Close()
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