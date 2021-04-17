util.AddNetworkString("FScript.CreateCharacter.OpenMenu")
util.AddNetworkString("FScript.CreateCharacter.CloseMenu")
util.AddNetworkString("FScript.CreateCharacter.Validate")

net.Receive("FScript.CreateCharacter.Validate", function(lenght, ply)
	if not FScript.IsValidPlayer(ply) or lenght == 0 then
		return
	end

	local CanCreate, Reason = hook.Run("FScript.CanCreateCharacter", ply)
	if CanCreate == false then
		if Reason then
			FScript.SendNotification(ply, 1, Reason)
		end

		return
	end

	local CharacterData = net.ReadTable()
	if #CharacterData ~= 5 then
		FScript.SendNotification(ply, 1, FScript.Lang.InvalidData)
		return
	end

	for _, v in ipairs(CharacterData) do
		v = string.Trim(v)
	end

	local Firstname = CharacterData[1]
	local Surname = CharacterData[2]
	local ID = CharacterData[3]
	local Description = CharacterData[4]
	local PlayerModel = CharacterData[5]

	if not FScript.IsValidData(Firstname, "^[%a-Ѐ-џ]+$", FScript.Config.FirstnameMinLenght, FScript.Config.FirstnameMaxLenght, FScript.Lang.CreateCharacterFirstname) then
		FScript.SendNotification(ply, 1, string.format(FScript.Lang.FirstnameCheck, FScript.Config.FirstnameMinLenght, FScript.Config.FirstnameMaxLenght))
		return
	elseif not FScript.IsValidData(Surname, "^[%a-Ѐ-џ]+$", FScript.Config.SurnameMinLenght, FScript.Config.SurnameMaxLenght, FScript.Lang.CreateCharacterSurname) then
		FScript.SendNotification(ply, 1, string.format(FScript.Lang.SurnameCheck, FScript.Config.SurnameMinLenght, FScript.Config.SurnameMaxLenght))
		return
	elseif not FScript.IsValidData(ID, "^[%d]+$", FScript.Config.IDLenght, FScript.Config.IDLenght, FScript.Lang.CreateCharacterID) then
		FScript.SendNotification(ply, 1, string.format(FScript.Lang.IDCheck, FScript.Config.IDLenght))
		return
	elseif not FScript.IsValidData(Description, "^[%w-%p-%s-Ѐ-џ]+$", FScript.Config.DescriptionMinLenght, FScript.Config.DescriptionMaxLenght, FScript.Lang.CreateCharacterDescription) then
		FScript.SendNotification(ply, 1, string.format(FScript.Lang.DescriptionCheck, FScript.Config.DescriptionMinLenght, FScript.Config.DescriptionMaxLenght))
		return
	elseif not PlayerModel or not string.find(PlayerModel, "models/") or not string.EndsWith(PlayerModel, ".mdl") then
		FScript.SendNotification(ply, 1, FScript.Lang.ModelCheck)
		return
	end

	Firstname = string.upper(Firstname[1]) .. string.lower(string.sub(Firstname, 2))
	Surname = string.upper(Surname[1]) .. string.lower(string.sub(Surname, 2))

	local RPName = Firstname .. " " .. Surname
	if RPName ~= ply:Nick() then
		if DarkRP then
			ply:setRPName(RPName)
		else
			ply:SetNWString("FScript.CharacterName", RPName)
		end
	end

	if PlayerModel ~= ply:GetModel() then
		if util.IsValidModel(PlayerModel) then
			ply:SetModel(PlayerModel)
		else
			ply:SetModel(FScript.GetDefaultModels()[1])
		end
	end

	local Characters = file.Find("fscript_data/players/" .. ply:SteamID64() .. "/*", "DATA")

	ply:SetCharacterID(ID)
	ply:SetCharacterDescription(Description)
	ply:SetCharacterNumber(#Characters + 1)
	ply:SetHasCharacterLoaded(true)

	FScript.SaveCharacter(ply)

	hook.Run("FScript.PostCreateCharacter", ply, CharacterData)

	FScript.SendNotification(ply, 3, FScript.Lang.CreateSuccess)
end)

net.Receive("FScript.CreateCharacter.CloseMenu", function(lenght, ply)
	if FScript.IsValidPlayer(ply) and lenght == 0 then
		FScript.ChangeCharacter(ply)
	end
end)

function FScript.CreateCharacter(ply, requester)
	if not FScript.IsValidPlayer(ply) then
		return
	end

	local CanCreate, Reason = hook.Run("FScript.CanCreateCharacter", ply)
	if CanCreate == false then
		if Reason then
			FScript.SendNotification(requester or ply, 1, Reason)
		end

		return
	end

	if requester then
		FScript.SendNotification(requester, 3, FScript.Lang.OperationSuccess)
	end

	hook.Run("FScript.PreCreateCharacter", ply)

	FScript.ResetPlayer(ply)

	local Characters = file.Find("fscript_data/players/" .. ply:SteamID64() .. "/*", "DATA")

	net.Start("FScript.CreateCharacter.OpenMenu")
		net.WriteBool(#Characters == 0)
	net.Send(ply)
end