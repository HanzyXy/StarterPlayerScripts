-- Floating Button + Radial Menu All-in-One
-- Dibuat modern & smooth
-- Tinggal copas ke executor Roblox

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- 🔘 Floating Button
local mainButton = Instance.new("ImageButton")
mainButton.Parent = screenGui
mainButton.Size = UDim2.new(0, 50, 0, 50)
mainButton.Position = UDim2.new(0.5, -25, 0.5, -25)
mainButton.BackgroundTransparency = 1
mainButton.Image = "rbxassetid://3926305904"
mainButton.ImageRectOffset = Vector2.new(4, 4)
mainButton.ImageRectSize = Vector2.new(36, 36)
mainButton.ZIndex = 10

-- 🖐️ Drag system
local dragging, dragInput, dragStart, startPos
mainButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	elseif input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainButton.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

-- 🎛️ Daftar fitur
local menuItems = {
	{Icon = "rbxassetid://3926305904", Name="⚡ Boost Speed", Action = function()
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 50 end
	end},

	{Icon = "rbxassetid://3926307971", Name="💰 Auto Farm", Action = function()
		print("Auto Farm aktif 🚜 (contoh, sesuaikan game)")
	end},

	{Icon = "rbxassetid://3926309567", Name="🎵 Music", Action = function()
		local sound = Instance.new("Sound", player:WaitForChild("PlayerGui"))
		sound.SoundId = "rbxassetid://1843553790" -- ganti ID lagu
		sound:Play()
	end},

	{Icon = "rbxassetid://3926311105", Name="🛡️ God Mode", Action = function()
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
	end},

	{Icon = "rbxassetid://3926305904", Name="🎮 Teleport", Action = function()
		local char = player.Character or player.CharacterAdded:Wait()
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(0,100,0) -- pindah ke atas
		end
	end},
}

-- 🎨 Radial Menu
local open = false
local menuButtons = {}

local function toggleMenu()
	open = not open
	for i, item in ipairs(menuItems) do
		if not menuButtons[i] then
			local btn = Instance.new("ImageButton")
			btn.Parent = screenGui
			btn.Size = UDim2.new(0, 40, 0, 40)
			btn.BackgroundTransparency = 1
			btn.Image = item.Icon
			btn.Position = mainButton.Position
			btn.Visible = false
			btn.ZIndex = 9
			btn.MouseButton1Click:Connect(item.Action)
			menuButtons[i] = btn
		end
		local angle = (i - 1) * (math.pi * 2 / #menuItems)
		local offset = Vector2.new(math.cos(angle), math.sin(angle)) * 80
		if open then
			menuButtons[i].Visible = true
			TweenService:Create(menuButtons[i], TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, mainButton.Position.X.Offset + offset.X, 0, mainButton.Position.Y.Offset + offset.Y)
			}):Play()
		else
			TweenService:Create(menuButtons[i], TweenInfo.new(0.3), {
				Position = mainButton.Position
			}):Play()
			task.delay(0.3, function() menuButtons[i].Visible = false end)
		end
	end
end

mainButton.MouseButton1Click:Connect(toggleMenu)

print("✅ Floating Button GUI loaded!")
