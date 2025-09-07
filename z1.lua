--[[
Fish It UI Cinematic
LocalScript → StarterPlayerScripts
Fitur:
- Slide in/out animation
- Background glow + particle
- Draggable & resizable buttons
--]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===== ScreenGui =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FishItUICinematic"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ===== Main Frame =====
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, -250) -- start off-screen right
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 25)
uiCorner.Parent = mainFrame

-- ===== Background Glow =====
local glow = Instance.new("Frame")
glow.Size = UDim2.new(1,0,1,0)
glow.Position = UDim2.new(0,0,0,0)
glow.BackgroundColor3 = Color3.fromRGB(0,255,150)
glow.BackgroundTransparency = 0.85
glow.ZIndex = 0
glow.Parent = mainFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0,25)
glowCorner.Parent = glow

-- Particle effect (simple frame blinking)
spawn(function()
    while true do
        for i=0,1,0.05 do
            glow.BackgroundTransparency = 0.85 + 0.1 * math.sin(i*math.pi*2)
            RunService.RenderStepped:Wait()
        end
    end
end)

-- ===== UI Title =====
local title = Instance.new("TextLabel")
title.Text = "Fish It Menu"
title.Size = UDim2.new(1,0,0,50)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame
title.ZIndex = 1

-- ===== Button Container =====
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1,-20,1,-60)
buttonContainer.Position = UDim2.new(0,10,0,50)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame
buttonContainer.ZIndex = 1

-- ===== Draggable function =====
local function makeDraggable(frame)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(mainFrame)

-- ===== Create Button =====
local function createButton(name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1,0,0,50)
    button.BackgroundColor3 = Color3.fromRGB(60,60,70)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Font = Enum.Font.GothamSemibold
    button.TextScaled = true
    button.Text = name
    button.Parent = buttonContainer
    button.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,12)
    corner.Parent = button

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(0,255,150)
    uiStroke.Thickness = 2
    uiStroke.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,80,90)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,60,70)}):Play()
    end)

    button.MouseButton1Click:Connect(callback)

    -- Draggable button
    makeDraggable(button)
end

-- ===== Example Buttons =====
createButton("Auto Fish", function()
    print("Auto Fish Activated!")
end)

createButton("Speed Boost", function()
    print("Speed Boost Activated!")
end)

createButton("Open Inventory", function()
    print("Inventory Opened!")
end)

createButton("Sell Fish", function()
    print("Sell Fish Activated!")
end)

-- ===== Slide In/Out Animation =====
local function slideIn()
    mainFrame.Position = UDim2.new(1.5,0,0.5,-250)
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5,0,0.5,-250)}):Play()
end

local function slideOut()
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1.5,0,0.5,-250)}):Play()
end

-- Show UI with slide in
slideIn()

-- ===== Close Button =====
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,30,0,30)
closeButton.Position = UDim2.new(1,-35,0,5)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeButton.TextColor3 = Color3.fromRGB(255,255,255)
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0,10)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(slideOut)
