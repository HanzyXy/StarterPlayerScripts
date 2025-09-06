-- ⚡ Fish It Loader UI (Auto Fish + Settings + Mini Menu)
-- Dibuat rapih & elegant

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "FishItLoaderUI"
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Loader Button (Bulat & kecil)
local loaderBtn = Instance.new("TextButton")
loaderBtn.Name = "LoaderButton"
loaderBtn.Parent = gui
loaderBtn.Size = UDim2.new(0, 50, 0, 50)
loaderBtn.Position = UDim2.new(0, 100, 0, 200)
loaderBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loaderBtn.Text = "≡"
loaderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loaderBtn.Font = Enum.Font.GothamBold
loaderBtn.TextSize = 20
loaderBtn.AutoButtonColor = true
loaderBtn.BorderSizePixel = 0
loaderBtn.ClipsDescendants = true
loaderBtn.ZIndex = 10
loaderBtn.BackgroundTransparency = 0.1
loaderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
loaderBtn.Position = UDim2.new(0, 80, 0, 200)
loaderBtn.TextWrapped = true
loaderBtn.TextScaled = true
loaderBtn.TextYAlignment = Enum.TextYAlignment.Center
loaderBtn.TextXAlignment = Enum.TextXAlignment.Center
loaderBtn.TextStrokeTransparency = 0.8
loaderBtn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
loaderBtn.UICorner = Instance.new("UICorner", loaderBtn)
loaderBtn.UICorner.CornerRadius = UDim.new(1,0) -- Biar bulat

-- Drag system
local dragging, dragInput, mousePos, framePos
loaderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = loaderBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
loaderBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
RunService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        loaderBtn.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0, 150, 0, 150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Parent = gui
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.UICorner = Instance.new("UICorner", mainFrame)
mainFrame.UICorner.CornerRadius = UDim.new(0,12)

-- Title
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "⚡ Fish It Loader"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)

-- Info Label
local info = Instance.new("TextLabel")
info.Parent = mainFrame
info.Size = UDim2.new(1, -20, 0, 80)
info.Position = UDim2.new(0, 10, 0, 45)
info.BackgroundTransparency = 1
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.TextColor3 = Color3.fromRGB(200,200,200)
info.TextWrapped = true

-- Update info
RunService.RenderStepped:Connect(function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    info.Text = "👤 ID: " .. LocalPlayer.UserId ..
        "\n📛 Nama: " .. LocalPlayer.Name ..
        "\n⚡ FPS: " .. fps ..
        "\n👥 Member Server: " .. #Players:GetPlayers()
end)

-- Auto Fish Toggle
local autoFish = false
local autoFishBtn = Instance.new("TextButton")
autoFishBtn.Parent = mainFrame
autoFishBtn.Size = UDim2.new(0.9, 0, 0, 35)
autoFishBtn.Position = UDim2.new(0.05, 0, 0, 140)
autoFishBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoFishBtn.Text = "🎣 Auto Fish: OFF"
autoFishBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFishBtn.Font = Enum.Font.GothamBold
autoFishBtn.TextSize = 14
autoFishBtn.UICorner = Instance.new("UICorner", autoFishBtn)
autoFishBtn.UICorner.CornerRadius = UDim.new(0,8)

autoFishBtn.MouseButton1Click:Connect(function()
    autoFish = not autoFish
    autoFishBtn.Text = "🎣 Auto Fish: " .. (autoFish and "ON" or "OFF")
    if autoFish then
        spawn(function()
            while autoFish do
                wait(2) -- delay pancing
                print("🎣 Mancing otomatis...")
                -- taruh script mancing otomatis disini
            end
        end)
    end
end)

-- Button 1, 2, 3
for i = 1, 3 do
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0.28, 0, 0, 30)
    btn.Position = UDim2.new(0.05 + (i-1)*0.32, 0, 0, 190)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = "Btn " .. i
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.UICorner = Instance.new("UICorner", btn)
    btn.UICorner.CornerRadius = UDim.new(0,6)
    btn.MouseButton1Click:Connect(function()
        print("⚡ Button " .. i .. " ditekan")
    end)
end

-- Toggle show/hide
loaderBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = mainFrame.Visible and UDim2.new(0,250,0,300) or UDim2.new(0,0,0,0)
    }):Play()
end)
