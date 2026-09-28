local Players = game:GetService("Players")

local player = Players.LocalPlayer
local rigs = workspace:WaitForChild("Rigs")

local function GetCharacter()
	local rig = rigs:FindFirstChild(player.Name)

	while not rig do
		rigs.ChildAdded:Wait()
		rig = rigs:FindFirstChild(player.Name)
	end

	return rig
end

local character = GetCharacter()
local humanoid = character:WaitForChild("Humanoid")

local function LoadAccessory(assetId)
	local success, objects = pcall(function()
		return game:GetObjects("rbxassetid://" .. tostring(assetId))
	end)

	if not success or not objects or not objects[1] then
		warn("Gagal load asset:", assetId)
		return
	end

	local loaded = objects[1]

	local accessory

	if loaded:IsA("Accessory") then
		accessory = loaded
	else
		accessory = loaded:FindFirstChildWhichIsA("Accessory", true)
	end

	if not accessory then
		warn("Asset ini bukan Accessory:", assetId)
		loaded:Destroy()
		return
	end

	accessory.Parent = nil

	if loaded ~= accessory then
		loaded:Destroy()
	end

	local handle = accessory:FindFirstChild("Handle")

	if not handle then
		warn("Accessory tidak punya Handle")
		accessory:Destroy()
		return
	end

	local itemAttachment = handle:FindFirstChildWhichIsA("Attachment")

	if itemAttachment then
		print("Accessory:", accessory.Name)
		print("Attachment type:", itemAttachment.Name)
		print("Item attachment position:", itemAttachment.Position)
		print("Item attachment rotation:", itemAttachment.Orientation)

		local bodyAttachment =
			character:FindFirstChild(itemAttachment.Name, true)

		if bodyAttachment
			and bodyAttachment:IsA("Attachment")
			and bodyAttachment.Parent:IsA("BasePart") then

			accessory.Parent = character

			local weld = Instance.new("Weld")
			weld.Name = "AccessoryWeld"

			weld.Part0 = bodyAttachment.Parent
			weld.Part1 = handle

			weld.C0 = bodyAttachment.CFrame
			weld.C1 = itemAttachment.CFrame

			weld.Parent = handle

			handle.CanCollide = false
			handle.Massless = true

			print(
				"Attached:",
				accessory.Name,
				"->",
				bodyAttachment.Parent.Name,
				"using",
				itemAttachment.Name
			)

			return accessory
		end
	end

	humanoid:AddAccessory(accessory)

	pcall(function()
		humanoid:BuildRigFromAttachments()
	end)

	return accessory
end

LoadAccessory(10159600649)
