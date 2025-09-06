-- ⚡ Fish It UI Clone (One Floating Button + Drag + Blur + Animasi)
-- Showcase UI Aman (BUKAN exploit)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- ScreenGui utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishItUI"
ScreenGui.Parent = game.CoreGui

-- Blur background
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Enabled = false
Blur.Parent = Lighting

-- Frame utama (window)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Fish It Script - Demo"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Tombol close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local ExampleBtn = Instance.new("TextButton")
ExampleBtn.Size = UDim2.new(1, 0, 0, 40)
ExampleBtn.Text = "Rejoin Server (Dummy)"
ExampleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExampleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ExampleBtn.Font = Enum.Font.SourceSans
ExampleBtn.TextSize = 18
ExampleBtn.Parent = Content
Instance.new("UICorner", ExampleBtn)
ExampleBtn.MouseButton1Click:Connect(function()
    print("Rejoin button ditekan!")
end)

-- Fungsi buka UI
local function OpenUI()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Blur.Enabled = true
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 15}):Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 500, 0, 300)}):Play()
end

-- Fungsi tutup UI
local function CloseUI()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        Blur.Enabled = false
        MainFrame.Size = UDim2.new(0, 500, 0, 300)
    end)
end

CloseBtn.MouseButton1Click:Connect(function()
    CloseUI()
end)

-- 🔘 Floating Button (kecil & draggable)
local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 60, 0, 60)
FloatBtn.Position = UDim2.new(0.1, 0, 0.8, 0)
FloatBtn.Text = "⚙️"
FloatBtn.TextSize = 28
FloatBtn.Font = Enum.Font.SourceSansBold
FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FloatBtn.Parent = ScreenGui
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)

-- Animasi hover
FloatBtn.MouseEnter:Connect(function()
    TweenService:Create(FloatBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,80,80)}):Play()
end)
FloatBtn.MouseLeave:Connect(function()
    TweenService:Create(FloatBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
end)

-- Toggle buka/tutup UI
FloatBtn.MouseButton1Click:Connect(function()
    if not MainFrame.Visible then
        OpenUI()
    else
        CloseUI()
    end
end)

-- Sistem drag untuk FloatBtn
local dragging, dragInput, dragStart, startPos
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

FloatBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        FloatBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
