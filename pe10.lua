-- ===== Services =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ===== Config =====
local PASSWORD = "YILZI-EXECUTOR"
local LoaderKey = Enum.KeyCode.RightShift

-- ===== ScreenGui =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FinalDeluxeLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ===== Background Frame =====
local BgFrame = Instance.new("Frame")
BgFrame.Size = UDim2.new(0, 550, 0, 360)
BgFrame.Position = UDim2.new(0.5, -275, 0.5, -180)
BgFrame.AnchorPoint = Vector2.new(0.5,0.5)
BgFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
BgFrame.BackgroundTransparency = 0.1
BgFrame.BorderSizePixel = 0
BgFrame.Visible = false
BgFrame.Parent = ScreenGui

local BgCorner = Instance.new("UICorner")
BgCorner.CornerRadius = UDim.new(0,30)
BgCorner.Parent = BgFrame

-- ===== Dynamic Gradient =====
local BgGradient = Instance.new("UIGradient")
BgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255,0,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,255))
}
BgGradient.Rotation = 0
BgGradient.Parent = BgFrame

RunService.RenderStepped:Connect(function()
    BgGradient.Rotation = (BgGradient.Rotation + 0.5)%360
end)

-- ===== Blur =====
local Blur = Instance.new("UIBlurEffect")
Blur.Size = 15
Blur.Parent = Lighting

-- ===== Particle Trail =====
local Particle = Instance.new("Frame")
Particle.Size = UDim2.new(1,0,1,0)
Particle.BackgroundTransparency = 1
Particle.Parent = BgFrame

local mouse = Player:GetMouse()
local trailParticles = {}

for i=1,80 do
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0,3,0,3)
    dot.Position = UDim2.new(math.random(),0,math.random(),0)
    dot.BackgroundColor3 = Color3.fromRGB(0,255,255)
    dot.AnchorPoint = Vector2.new(0.5,0.5)
    dot.BackgroundTransparency = 0.5
    dot.Parent = Particle
    table.insert(trailParticles,dot)
end

RunService.RenderStepped:Connect(function()
    for _,dot in ipairs(trailParticles) do
        local mx,my = mouse.X, mouse.Y
        local target = UDim2.new(0,mx + math.random(-30,30),0,my + math.random(-30,30))
        TweenService:Create(dot,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=target}):Play()
    end
end)

-- ===== Title =====
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "🚀 Final Deluxe Loader"
Title.TextColor3 = Color3.fromRGB(0,255,255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 30
Title.Parent = BgFrame

-- ===== Password Frame =====
local PWFrame = Instance.new("Frame")
PWFrame.Size = UDim2.new(1, -40, 0, 50)
PWFrame.Position = UDim2.new(0,20,0,60)
PWFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
PWFrame.Parent = BgFrame

local PWCorner = Instance.new("UICorner")
PWCorner.CornerRadius = UDim.new(0,15)
PWCorner.Parent = PWFrame

local PWBox = Instance.new("TextBox")
PWBox.Size = UDim2.new(0.7,0,1,0)
PWBox.Position = UDim2.new(0,5,0,0)
PWBox.PlaceholderText = "Enter Password..."
PWBox.BackgroundTransparency = 1
PWBox.TextColor3 = Color3.fromRGB(0,255,255)
PWBox.Font = Enum.Font.Gotham
PWBox.TextSize = 16
PWBox.ClearTextOnFocus = true
PWBox.Parent = PWFrame

local PWButton = Instance.new("TextButton")
PWButton.Size = UDim2.new(0.25,-5,1,0)
PWButton.Position = UDim2.new(0.73,0,0,0)
PWButton.BackgroundColor3 = Color3.fromRGB(0,100,255)
PWButton.Text = "Unlock"
PWButton.TextColor3 = Color3.fromRGB(255,255,255)
PWButton.Font = Enum.Font.GothamBold
PWButton.TextSize = 16
PWButton.Parent = PWFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0,12)
BtnCorner.Parent = PWButton

-- ===== Tabs =====
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, -40, 0, 50)
TabsFrame.Position = UDim2.new(0,20,0,120)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = BgFrame

local UIList = Instance.new("UIListLayout")
UIList.FillDirection = Enum.FillDirection.Horizontal
UIList.Padding = UDim.new(0,15)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIList.Parent = TabsFrame

local FeatureFrame = Instance.new("Frame")
FeatureFrame.Size = UDim2.new(1, -40, 1, -180)
FeatureFrame.Position = UDim2.new(0,20,0,180)
FeatureFrame.BackgroundTransparency = 1
FeatureFrame.Parent = BgFrame

local Tabs = {
    ["Movement"] = {"Speed Boost","Jump Boost","Fly"},
    ["Combat"] = {"Auto Aim","No Recoil","Kill Aura"},
    ["Utility"] = {"ESP","Teleport","Infinite Jump"}
}

local CurrentTab = nil

local function clearFeatures()
    for _, child in pairs(FeatureFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

local function showFeatures(tabName)
    clearFeatures()
    local features = Tabs[tabName]
    local yOffset = 0
    for _, fName in ipairs(features) do
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1,0,0,35)
        Btn.Position = UDim2.new(0,0,0,yOffset)
        Btn.BackgroundColor3 = Color3.fromRGB(20,20,50)
        Btn.Text = fName
        Btn.TextColor3 = Color3.fromRGB(0,255,255)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 16
        Btn.Parent = FeatureFrame

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0,12)
        BtnCorner.Parent = Btn

        coroutine.wrap(function()
            while Btn.Parent do
                TweenService:Create(Btn,TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(0,100,255)}):Play()
                wait(0.7)
                TweenService:Create(Btn,TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(20,20,50)}):Play()
                wait(0.7)
            end
        end)()

        Btn.MouseButton1Click:Connect(function()
            local clickSound = Instance.new("Sound")
            clickSound.SoundId = "rbxassetid://9118822411"
            clickSound.Volume = 1
            clickSound.Parent = Btn
            clickSound:Play()
            Debris:AddItem(clickSound,2)
            print(fName.." activated!")
        end)
        yOffset = yOffset + 45
    end
end

-- Create Tabs Buttons
for tabName,_ in pairs(Tabs) do
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0,100,1,0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(10,50,50)
    TabBtn.Text = tabName
    TabBtn.TextColor3 = Color3.fromRGB(0,255,255)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    TabBtn.Parent = TabsFrame

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0,12)
    TabCorner.Parent = TabBtn

    TabBtn.MouseButton1Click:Connect(function()
        CurrentTab = tabName
        for _, child in pairs(FeatureFrame:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
            end
        end
        wait(0.2)
        showFeatures(tabName)
    end)
end

-- Unlock Button
PWButton.MouseButton1Click:Connect(function()
    if PWBox.Text == PASSWORD then
        PWFrame:Destroy()
        TabsFrame.Visible = true
        FeatureFrame.Visible = true
        if CurrentTab == nil then CurrentTab = next(Tabs) end
        showFeatures(CurrentTab)
        BgFrame.Position = UDim2.new(0.5,-260,0.5,-200)
        BgFrame.Size = UDim2.new(0,400,0,250)
        TweenService:Create(BgFrame,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,-275,0.5,-180),Size=UDim2.new(0,550,0,360)}):Play()
    else
        PWBox.Text = ""
        PWBox.PlaceholderText = "Wrong Password!"
    end
end)

TabsFrame.Visible = false
FeatureFrame.Visible = false

-- Toggle Loader
local isVisible = false
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == LoaderKey then
        isVisible = not isVisible
        if isVisible then
            BgFrame.Visible = true
            BgFrame.BackgroundTransparency = 1
            TweenService:Create(BgFrame,TweenInfo.new(0.5),{BackgroundTransparency=0.1}):Play()
        else
            TweenService:Create(BgFrame,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
            wait(0.5)
            BgFrame.Visible = false
        end
    end
end)
