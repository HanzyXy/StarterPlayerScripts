-- ===== Fish It Modern UI & Features =====
-- Place in StarterPlayerScripts (LocalScript)
-- Script ini dibuat untuk showcase, gunakan dengan game yang mendukung

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()

-- ===== UI Setup =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishItModernUI"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.7, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

-- UI Title
local Title = Instance.new("TextLabel")
Title.Text = "Fish It UI"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- ===== Button Template =====
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ===== Feature: Speed Boat =====
local speedEnabled = false
local speedValue = 100 -- default speed

local function toggleSpeed()
    speedEnabled = not speedEnabled
end

createButton("Toggle Speed Boat", 60, toggleSpeed)

RunService.RenderStepped:Connect(function()
    if speedEnabled then
        local boat = workspace:FindFirstChild("Boat") or workspace:FindFirstChild("Perahu")
        if boat and boat:FindFirstChild("PrimaryPart") then
            boat.PrimaryPart.Velocity = boat.PrimaryPart.CFrame.LookVector * speedValue
        end
    end
end)

-- ===== Feature: Auto Fish (Klik Tanda Seru) =====
local autoFishEnabled = false

local function toggleAutoFish()
    autoFishEnabled = not autoFishEnabled
end

createButton("Toggle Auto Fish", 110, toggleAutoFish)

RunService.RenderStepped:Connect(function()
    if autoFishEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ClickDetector") and obj.Parent:FindFirstChild("Exclamation") then
                local exclamation = obj.Parent.Exclamation
                if exclamation.Visible then
                    obj:FireClick(player)
                end
            end
        end
    end
end)

-- ===== Slider: Speed Value =====
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0, 200)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Text = "Speed: "..speedValue
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 16
speedLabel.Parent = MainFrame

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0.9, 0, 0, 20)
speedSlider.Position = UDim2.new(0.05, 0, 0, 230)
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedSlider.Parent = MainFrame

local sliderBtn = Instance.new("TextButton")
sliderBtn.Size = UDim2.new(0, 20, 1, 0)
sliderBtn.Position = UDim2.new(0, 0, 0, 0)
sliderBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
sliderBtn.Text = ""
sliderBtn.Parent = speedSlider
sliderBtn.Active = true
sliderBtn.Draggable = true

sliderBtn.DragEnded:Connect(function()
    local relPos = (sliderBtn.Position.X.Scale + sliderBtn.Position.X.Offset / speedSlider.AbsoluteSize.X)
    speedValue = math.clamp(math.floor(relPos * 200), 0, 200)
    speedLabel.Text = "Speed: "..speedValue
end)

-- ===== UI Enhancements =====
MainFrame.Active = true
MainFrame.Draggable = true

print("Fish It Modern UI Loaded ✅")
