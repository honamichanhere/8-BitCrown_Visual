local Players = game:GetService("Players")

local player = Players.LocalPlayer

local function GetCharacter()

	local rigs = workspace:FindFirstChild("Rigs")

	if rigs then
		local rig = rigs:FindFirstChild(player.Name)

		if rig then
			local humanoid = rig:FindFirstChildOfClass("Humanoid")

			if humanoid then
				print(
					"[Accessory Loader] Using Workspace.Rigs:",
					rig:GetFullName()
				)

				return rig, humanoid
			end
		end
	end

	local character = player.Character

	if not character then
		character = player.CharacterAdded:Wait()
	end

	if character then
		local humanoid =
			character:FindFirstChildOfClass("Humanoid")
			or character:WaitForChild("Humanoid", 5)

		if humanoid then
			print(
				"[Accessory Loader] Using default character:",
				character:GetFullName()
			)

			return character, humanoid
		end
	end

	warn("[Accessory Loader] Character tidak ditemukan")

	return nil, nil
end

local function FindBodyAttachment(character, attachmentName)
	for _, object in ipairs(character:GetDescendants()) do
		if object:IsA("Attachment")
			and object.Name == attachmentName
			and object.Parent:IsA("BasePart") then

			return object
		end
	end

	return nil
end

local function LoadAccessory(assetId, offset)
	local character, humanoid = GetCharacter()

	if not character or not humanoid then
		warn("[Accessory Loader] Tidak ada character/humanoid")
		return nil
	end

	local success, objects = pcall(function()
		return game:GetObjects(
			"rbxassetid://" .. tostring(assetId)
		)
	end)

	if not success
		or not objects
		or not objects[1] then

		warn(
			"[Accessory Loader] Gagal load asset:",
			assetId
		)

		return nil
	end

	local loaded = objects[1]

	local accessory

	if loaded:IsA("Accessory") then
		accessory = loaded

	else
		accessory =
			loaded:FindFirstChildWhichIsA(
				"Accessory",
				true
			)
	end

	if not accessory then
		warn(
			"[Accessory Loader] Asset bukan Accessory:",
			assetId
		)

		loaded:Destroy()

		return nil
	end

	accessory.Parent = nil

	if loaded ~= accessory then
		loaded:Destroy()
	end

	local handle =
		accessory:FindFirstChild("Handle")

	if not handle
		or not handle:IsA("BasePart") then

		warn(
			"[Accessory Loader] Accessory tidak punya Handle:",
			accessory.Name
		)

		accessory:Destroy()

		return nil
	end

	handle.CanCollide = false
	handle.CanTouch = false
	handle.CanQuery = false
	handle.Massless = true

	local itemAttachment =
		handle:FindFirstChildWhichIsA(
			"Attachment"
		)

	if itemAttachment then
		print(
			"[Accessory Loader] Accessory:",
			accessory.Name
		)

		print(
			"[Accessory Loader] Attachment:",
			itemAttachment.Name
		)

		local bodyAttachment =
			FindBodyAttachment(
				character,
				itemAttachment.Name
			)

		if bodyAttachment then

			local bodyPart =
				bodyAttachment.Parent

			accessory.Parent = character

			local oldWeld =
				handle:FindFirstChild(
					"AccessoryWeld"
				)

			if oldWeld then
				oldWeld:Destroy()
			end

			local weld =
				Instance.new("Weld")

			weld.Name = "AccessoryWeld"

			weld.Part0 = bodyPart
			weld.Part1 = handle

			weld.C0 =
				bodyAttachment.CFrame

			if offset then
				weld.C1 =
					itemAttachment.CFrame
					* offset
			else
				weld.C1 =
					itemAttachment.CFrame
			end

			weld.Parent = handle

			print(
				"[Accessory Loader] Attached:",
				accessory.Name,
				"->",
				bodyPart.Name,
				"using",
				itemAttachment.Name
			)

			return accessory
		end
	end

	print(
		"[Accessory Loader] Attachment pair tidak ditemukan, menggunakan Humanoid:AddAccessory()"
	)

	local addSuccess, addError =
		pcall(function()

			humanoid:AddAccessory(
				accessory
			)

		end)

	if not addSuccess then
		warn(
			"[Accessory Loader] AddAccessory gagal:",
			addError
		)

		accessory:Destroy()

		return nil
	end

	pcall(function()
		humanoid:BuildRigFromAttachments()
	end)

	return accessory
end

local ITEM_ID = 10159600649

LoadAccessory(ITEM_ID)
