local ServerData
local NeedRefresh = false

net.Receive("FScript.ViewCharacterDatabase.SendServerData", function()
	ServerData = net.ReadTable()
	NeedRefresh = true
end)

net.Receive("FScript.ViewCharacterDatabase.OpenMenu", function()
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
		surface.DrawLine(self:GetWide() / 2, 70, self:GetWide() / 2, 245)

		surface.SetDrawColor(FScript.Config.BlackColor)
		surface.DrawLine(10, 255, self:GetWide() - 10, 255)

		surface.SetDrawColor(FScript.Config.BlackColor)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local Title = vgui.Create("DLabel", DermaFrame)
	Title:SetText(FScript.Lang.ViewDatabaseTitle1)
	Title:SetFont(FScript.Config.TitleFont)
	Title:SetTextColor(FScript.Config.TitleColor)
	Title:SizeToContents()
	Title:SetPos(60, 15)

	local TitleIcon = vgui.Create("DImage", DermaFrame)
	TitleIcon:SetPos(20, 16)
	TitleIcon:SetSize(24, 24)
	TitleIcon:SetImage("icon16/application_view_detail.png")

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

	local SubTitle1 = vgui.Create("DLabel", DermaFrame)
	SubTitle1:SetText(FScript.Lang.ViewDatabaseSubTitle1)
	SubTitle1:SetFont(FScript.Config.SubTitleFont)
	SubTitle1:SetTextColor(FScript.Config.TextColor)
	SubTitle1:SizeToContents()
	SubTitle1:SetPos(((DermaFrame:GetWide() / 2) - SubTitle1:GetWide()) / 2, 70)

	local SubTitle1Pos = SubTitle1:GetPos()
	local SubTitle1Wide = SubTitle1:GetWide()
	local SeparatorPos = DermaFrame:GetWide() / 2
	if SubTitle1Pos + SubTitle1Wide >= (SeparatorPos - 20) then
		local _, Y = SubTitle1:GetSize()
		SubTitle1:SetPos(20, 70)
		SubTitle1:SetSize(SeparatorPos - 40, Y)
	end

	local SteamIDSearch = vgui.Create("DTextEntry", DermaFrame)
	SteamIDSearch.DefaultText = FScript.Lang.ViewDatabaseSteamID64Search
	SteamIDSearch:SetPos(10, 105)
	SteamIDSearch:SetSize((DermaFrame:GetWide() / 2) - 20, 30)
	SteamIDSearch:SetText(SteamIDSearch.DefaultText)
	SteamIDSearch:SetFont(FScript.Config.TextFont)
	SteamIDSearch:SetDrawLanguageID(false)
	SteamIDSearch.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	SteamIDSearch.OnMousePressed = function(self)
		self:SetTextColor(FScript.Config.BlackColor)
	end
	SteamIDSearch.Think = function(self)
		if not self:HasFocus() and string.Trim(self:GetText()) == "" then
			self:SetText(self.DefaultText)
		elseif self:HasFocus() and self:GetText() == self.DefaultText then
			self:SetText("")
		end
	end
	SteamIDSearch.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > 18 then
			self:SetText(self.PrevText or string.sub(Text, 0, 18))
		else
			self.PrevText = Text
		end
	end

	local NameSearch = vgui.Create("DTextEntry", DermaFrame)
	NameSearch.DefaultText = FScript.Lang.ViewDatabaseRPNameSearch
	NameSearch:SetPos(10, 140)
	NameSearch:SetSize((DermaFrame:GetWide() / 2) - 20, 30)
	NameSearch:SetText(NameSearch.DefaultText)
	NameSearch:SetFont(FScript.Config.TextFont)
	NameSearch:SetDrawLanguageID(false)
	NameSearch.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	NameSearch.OnMousePressed = function(self)
		self:SetTextColor(FScript.Config.BlackColor)
	end
	NameSearch.Think = function(self)
		if not self:HasFocus() and string.Trim(self:GetText()) == "" then
			self:SetText(self.DefaultText)
		elseif self:HasFocus() and self:GetText() == self.DefaultText then
			self:SetText("")
		end
	end
	NameSearch.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > (FScript.Config.FirstnameMaxLenght + FScript.Config.SurnameMaxLenght) then
			self:SetText(self.PrevText or string.sub(Text, 0, (FScript.Config.FirstnameMaxLenght + FScript.Config.SurnameMaxLenght)))
		else
			self.PrevText = Text
		end
	end

	local IDSearch = vgui.Create("DTextEntry", DermaFrame)
	IDSearch.DefaultText = FScript.Lang.ViewDatabaseIDSearch
	IDSearch:SetPos(10, 175)
	IDSearch:SetSize((DermaFrame:GetWide() / 2) - 20, 30)
	IDSearch:SetText(IDSearch.DefaultText)
	IDSearch:SetFont(FScript.Config.TextFont)
	IDSearch:SetNumeric(true)
	IDSearch:SetDrawLanguageID(false)
	IDSearch.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	IDSearch.OnMousePressed = function(self)
		self:SetTextColor(FScript.Config.BlackColor)
	end
	IDSearch.Think = function(self)
		if not self:HasFocus() and string.Trim(self:GetText()) == "" then
			self:SetText(self.DefaultText)
		elseif self:HasFocus() and self:GetText() == self.DefaultText then
			self:SetText("")
		end
	end
	IDSearch.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > FScript.Config.IDLenght then
			self:SetText(self.PrevText or string.sub(Text, 0, FScript.Config.IDLenght))
		else
			self.PrevText = Text
		end
	end

	local DescriptionSearch = vgui.Create("DTextEntry", DermaFrame)
	DescriptionSearch.DefaultText = FScript.Lang.ViewDatabaseDescriptionSearch
	DescriptionSearch:SetPos(10, 210)
	DescriptionSearch:SetSize((DermaFrame:GetWide() / 2) - 20, 30)
	DescriptionSearch:SetText(DescriptionSearch.DefaultText)
	DescriptionSearch:SetFont(FScript.Config.TextFont)
	DescriptionSearch:SetDrawLanguageID(false)
	DescriptionSearch.OnCursorEntered = function()
		surface.PlaySound(FScript.Config.HoverSound)
	end
	DescriptionSearch.OnMousePressed = function(self)
		self:SetTextColor(FScript.Config.BlackColor)
	end
	DescriptionSearch.Think = function(self)
		if not self:HasFocus() and string.Trim(self:GetText()) == "" then
			self:SetText(self.DefaultText)
		elseif self:HasFocus() and self:GetText() == self.DefaultText then
			self:SetText("")
		end
	end
	DescriptionSearch.OnTextChanged = function(self)
		local Text = self:GetText()
		if #Text > FScript.Config.DescriptionMaxLenght then
			self:SetText(self.PrevText or string.sub(Text, 0, FScript.Config.DescriptionMaxLenght))
		else
			self.PrevText = Text
		end
	end

	local SubTitle2 = vgui.Create("DLabel", DermaFrame)
	SubTitle2:SetText(FScript.Lang.ViewDatabaseSubTitle2)
	SubTitle2:SetFont(FScript.Config.SubTitleFont)
	SubTitle2:SetTextColor(FScript.Config.TextColor)
	SubTitle2:SizeToContents()
	SubTitle2:SetPos((DermaFrame:GetWide() / 2) + (((DermaFrame:GetWide() / 2) - SubTitle2:GetWide()) / 2), 70)

	local SeparatorPos = DermaFrame:GetWide() / 2
	local SubTitle2Pos = SubTitle2:GetPos() - SeparatorPos
	local SubTitle2Wide = SubTitle2:GetWide()
	if SubTitle2Pos + SubTitle2Wide >= (SeparatorPos - 20) then
		local _, Y = SubTitle2:GetSize()
		SubTitle2:SetPos(SeparatorPos + 20, 70)
		SubTitle2:SetSize(SeparatorPos - 40, Y)
	end

	local PlayersList = vgui.Create("DListView", DermaFrame)
	PlayersList:SetMultiSelect(false)
	PlayersList:Dock(FILL)
	PlayersList:DockMargin((DermaFrame:GetWide() / 2) + 5, 75, 5, DermaFrame:GetTall() - 245)
	PlayersList:AddColumn(FScript.Lang.RPName)
	PlayersList:AddColumn(FScript.Lang.SteamID64)
	PlayersList.OnRowSelected = function(list, index, panel)
		surface.PlaySound(FScript.Config.ClickSound)
	end

	for _, v in ipairs(player.GetHumans()) do
		PlayersList:AddLine(v:Nick(), v:SteamID64())
	end

	local SubTitle3 = vgui.Create("DLabel", DermaFrame)
	SubTitle3:SetText(FScript.Lang.ViewDatabaseSubTitle3)
	SubTitle3:SetFont(FScript.Config.SubTitleFont)
	SubTitle3:SetTextColor(FScript.Config.TextColor)
	SubTitle3:SizeToContents()
	SubTitle3:SetPos((DermaFrame:GetWide() - SubTitle3:GetWide()) / 2, 265)

	local SearchIcon = vgui.Create("DImage", DermaFrame)
	SearchIcon:SetSize(16, 16)
	SearchIcon:SetImage("icon16/zoom.png")
	SearchIcon.Think = function(self)
		self:SetPos(SubTitle3:GetPos() - 25, 270)
	end

	local SearchList = vgui.Create("DListView", DermaFrame)
	SearchList:SetMultiSelect(false)
	SearchList:Dock(FILL)
	SearchList:DockMargin(5, 270, 5, 70)
	SearchList.Think = function(self)
		if not NeedRefresh then
			return
		end

		NeedRefresh = false

		SearchList:Clear()

		for k, v in ipairs(ServerData) do
			SearchList:AddLine(v[1], v[2], v[3])
			SearchList.OnRowSelected = function(list, index, panel)
				local data = ServerData[index]

				surface.PlaySound(FScript.Config.ClickSound)

				Derma_Query(FScript.Lang.CharacterRequest, FScript.Lang.Warning,
					FScript.Lang.SeeProfile, function()
						DermaFrame:Close()

						net.Start("FScript.ViewCharacterDatabase.Validate")
							net.WriteTable({"ViewCharacterInformations", data[4], data[5]})
						net.SendToServer()
					end,

					FScript.Lang.EditCharacterInformationsValidation, function()
						Derma_Query(FScript.Lang.ViewDatabaseCharacterEdition, FScript.Lang.Warning,
							FScript.Lang.EditCharacterInformations, function()
								DermaFrame:Close()

								net.Start("FScript.ViewCharacterDatabase.Validate")
									net.WriteTable({"EditCharacterInformations", data[4], data[5]})
								net.SendToServer()
							end,

							FScript.Lang.EditCharacterNotes, function()
								DermaFrame:Close()

								net.Start("FScript.ViewCharacterDatabase.Validate")
									net.WriteTable({"EditCharacterNotes", data[4], data[5]})
								net.SendToServer()
							end,

							FScript.Lang.Close, function()
								-- Nothing here
							end
						)
					end,

					FScript.Lang.DeleteCharacter, function()
						Derma_Query(FScript.Lang.ViewDatabaseCharacterDeletion, FScript.Lang.Warning,
							FScript.Lang.DeleteCharacter, function()
								DermaFrame:Close()

								net.Start("FScript.ViewCharacterDatabase.Validate")
									net.WriteTable({"DeleteCharacter", data[4], data[5]})
								net.SendToServer()
							end,

							FScript.Lang.DeleteCharacters, function()
								DermaFrame:Close()

								net.Start("FScript.ViewCharacterDatabase.Validate")
									net.WriteTable({"DeleteAllCharacters", data[4], data[5]})
								net.SendToServer()
							end,

							FScript.Lang.Close, function()
								-- Nothing here
							end
						)
					end,

					FScript.Lang.Close, function()
						-- Nothing here
					end
				)
			end
		end
	end

	local Column1 = SearchList:AddColumn(FScript.Lang.RPName)
	Column1:SetMinWidth(140)
	Column1:SetMaxWidth(140)

	local Column2 = SearchList:AddColumn(FScript.Lang.Number)
	Column2:SetMinWidth(50)
	Column2:SetMaxWidth(50)

	local Column3 = SearchList:AddColumn(FScript.Lang.Description)

	local ConfirmButton = vgui.Create("DButton", DermaFrame)
	ConfirmButton:SetText(FScript.Lang.ViewDatabaseValidation)
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
		local SteamID = SteamIDSearch:GetText()
		local Name = NameSearch:GetText()
		local ID = IDSearch:GetText()
		local Description = DescriptionSearch:GetText()
		local ListData = PlayersList:GetSelected()[1]

		SearchList:Clear()

		if SteamID ~= SteamIDSearch.DefaultText then
			net.Start("FScript.ViewCharacterDatabase.RequestServerData")
				net.WriteTable({"SteamID", SteamID})
			net.SendToServer()

			surface.PlaySound(FScript.Config.ClickSound)

			return
		elseif Name ~= NameSearch.DefaultText then
			net.Start("FScript.ViewCharacterDatabase.RequestServerData")
				net.WriteTable({"Name", Name})
			net.SendToServer()

			surface.PlaySound(FScript.Config.ClickSound)

			return
		elseif ID ~= IDSearch.DefaultText then
			net.Start("FScript.ViewCharacterDatabase.RequestServerData")
				net.WriteTable({"ID", ID})
			net.SendToServer()

			surface.PlaySound(FScript.Config.ClickSound)

			return
		elseif Description ~= DescriptionSearch.DefaultText then
			net.Start("FScript.ViewCharacterDatabase.RequestServerData")
				net.WriteTable({"Description", Description})
			net.SendToServer()

			surface.PlaySound(FScript.Config.ClickSound)

			return
		elseif ListData then
			net.Start("FScript.ViewCharacterDatabase.RequestServerData")
				net.WriteTable({"List", ListData:GetColumnText(2)})
			net.SendToServer()

			surface.PlaySound(FScript.Config.ClickSound)

			return
		end

		surface.PlaySound(FScript.Config.ErrorSound)

		SteamIDSearch:SetTextColor(FScript.Config.RedColor)
		NameSearch:SetTextColor(FScript.Config.RedColor)
		IDSearch:SetTextColor(FScript.Config.RedColor)
		DescriptionSearch:SetTextColor(FScript.Config.RedColor)
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