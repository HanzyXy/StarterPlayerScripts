-- ===== Services =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = Workspace.CurrentCamera

-- ===== ScreenGui =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishItGodUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- ===== Blur Background =====
local Blur = Instance.new("BlurEffect")
Blur.Size = 30
Blur.Parent = Lighting

-- ===== Main Frame =====
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,800,0,600)
MainFrame.Position = UDim2.new(0.5,-400,0.5,-300)
MainFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.ClipsDescendants = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,40)
UICorner.Parent = MainFrame

-- ===== Floating Panels GOD MODE =====
local FloatingPanels = {}
for i=1,7 do
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0,200,0,130)
    panel.Position = UDim2.new(math.random()*0.7,0,math.random()*0.7,0)
    panel.BackgroundColor3 = Color3.fromRGB(30,30,35)
    panel.BorderSizePixel = 0
    panel.BackgroundTransparency = 0.25
    panel.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,20)
    corner.Parent = panel

    FloatingPanels[#FloatingPanels+1] = panel
end

RunService.RenderStepped:Connect(function()
    for i,panel in ipairs(FloatingPanels) do
        local offsetX = math.sin(tick()*0.5 + i) * 10
        local offsetY = math.cos(tick()*0.5 + i) * 10
        panel.Position = panel.Position + UDim2.new(0, offsetX,0, offsetY)
        panel.BackgroundTransparency = 0.2 + 0.1*math.sin(tick()*i)
    end
end)

-- ===== Neon Glow Dynamic GOD MODE =====
local NeonGlow = Instance.new("Frame")
NeonGlow.Size = UDim2.new(0,240,0,240)
NeonGlow.Position = UDim2.new(0.5,-120,0.5,-120)
NeonGlow.BackgroundColor3 = Color3.fromRGB(0,255,255)
NeonGlow.BackgroundTransparency = 0.85
NeonGlow.BorderSizePixel = 0
NeonGlow.Parent = MainFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0,120)
glowCorner.Parent = NeonGlow

RunService.RenderStepped:Connect(function()
    NeonGlow.Position = UDim2.new(0, mouse.X - MainFrame.AbsolutePosition.X - 120, 0, mouse.Y - MainFrame.AbsolutePosition.Y - 120)
end)

-- ===== Particle GOD MODE =====
local ParticleFrame = Instance.new("Frame")
ParticleFrame.Size = UDim2.new(1,0,1,0)
ParticleFrame.BackgroundTransparency = 1
ParticleFrame.Parent = MainFrame

local ParticleEmitter = Instance.new("ParticleEmitter")
ParticleEmitter.Rate = 0
ParticleEmitter.Lifetime = NumberRange.new(0.8,1.5)
ParticleEmitter.Speed = NumberRange.new(20,50)
ParticleEmitter.VelocitySpread = 360
ParticleEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,3),NumberSequenceKeypoint.new(1,0)})
ParticleEmitter.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255,0,255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,0))
}
ParticleEmitter.LightEmission = 1
ParticleEmitter.Parent = ParticleFrame

-- Particle follows mouse + map objects
local function SpawnGodParticles()
    local cx, cy = mouse.X - MainFrame.AbsolutePosition.X, mouse.Y - MainFrame.AbsolutePosition.Y
    for _,obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Part") and (obj.Position - camera.CFrame.Position).Magnitude < 100 then
            local particle = ParticleEmitter:Clone()
            particle.Parent = ParticleFrame
            particle.Speed = NumberRange.new(50)
            particle:Emit(1)
        end
    end
    -- Mouse-centered burst
    if math.random() < 0.12 then
        local particle = ParticleEmitter:Clone()
        particle.Parent = ParticleFrame
        particle.Speed = NumberRange.new(60)
        particle:Emit(2)
    end
end

RunService.RenderStepped:Connect(function()
    SpawnGodParticles()
end)

-- ===== Title =====
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,60)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "Fish It ULTIMATE GOD MODE"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 38
Title.Parent = MainFrame

-- ===== Full Cheat Menu Tabs =====
local Tabs = {"Speed","AutoFish","Inventory","Sell","Teleport","Extra","Fun"}
local TabFrames = {}

for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,160,0,50)
    btn.Position = UDim2.new(0,20 + (i-1)*170,0,80)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Text = tabName
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,15)
    corner.Parent = btn

    -- Hover sound
    local hoverSound = Instance.new("Sound")
    hoverSound.SoundId = "rbxassetid://9118821880"
    hoverSound.Volume = 0.5
    hoverSound.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{BackgroundColor3=Color3.fromRGB(0,170,255)}):Play()
        hoverSound:Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{BackgroundColor3=Color3.fromRGB(40,40,50)}):Play()
    end)

    -- Tab frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.Position = UDim2.new(1,0,0,0)
    frame.BackgroundTransparency = 1
    frame.Parent = MainFrame
    TabFrames[tabName] = frame

    -- Feature Buttons
    for j=1,5 do
        local featureBtn = Instance.new("TextButton")
        featureBtn.Size = UDim2.new(0,180,0,45)
        featureBtn.Position = UDim2.new(0,20,0,20 + (j-1)*55)
        featureBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
        featureBtn.TextColor3 = Color3.fromRGB(255,255,255)
        featureBtn.Font = Enum.Font.GothamBold
        featureBtn.TextSize = 18
        featureBtn.Text = tabName.." Feature "..j
        featureBtn.Parent = frame

        local fcorner = Instance.new("UICorner")
        fcorner.CornerRadius = UDim.new(0,15)
        fcorner.Parent = featureBtn

        local clickSound = Instance.new("Sound")
        clickSound.SoundId = "rbxassetid://9118821880"
        clickSound.Volume = 0.6
        clickSound.Parent = featureBtn

        featureBtn.MouseButton1Click:Connect(function()
            clickSound:Play()
            print(featureBtn.Text.." activated!")
        end)
    end

    -- Smooth cinematic tab slide
    btn.MouseButton1Click:Connect(function()
        for name,f in pairs(TabFrames) do
            local targetPos = (name==tabName) and UDim2.new(0,0,0,0) or UDim2.new(1,0,0,0)
            TweenService:Create(f,TweenInfo.new(0.5,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out),{Position=targetPos}):Play()
        end
    end)
end

-- ===== Ambient Cinematic Soundscape =====
local ambient = Instance.new("Sound")
ambient.SoundId = "rbxassetid://9118821880" -- ganti dengan asset sound cinematic
ambient.Volume = 0.3
ambient.Looped = true
ambient.Parent = MainFrame
ambient:Play()

-- ===== Loader + Password =====
local LoaderFrame = Instance.new("Frame")
LoaderFrame.Size = UDim2.new(0,400,0,200)
LoaderFrame.Position = UDim2.new(0.5,-200,0.5,-100)
LoaderFrame.BackgroundColor3 = Color3.fromRGB(20,20,25)
LoaderFrame.BorderSizePixel = 0
LoaderFrame.AnchorPoint = Vector2.new(0.5,0.5)
LoaderFrame.Parent = ScreenGui

local loaderCorner = Instance.new("UICorner")
loaderCorner.CornerRadius = UDim.new(0,20)
loaderCorner.Parent = LoaderFrame

local loaderText = Instance.new("TextLabel")
loaderText.Size = UDim2.new(1,0,0,50)
loaderText.Position = UDim2.new(0,0,0,20)
loaderText.BackgroundTransparency = 1
loaderText.Text = "Enter Password"
loaderText.TextColor3 = Color3.fromRGB(255,255,255)
loaderText.Font = Enum.Font.GothamBold
loaderText.TextSize = 24
loaderText.Parent = LoaderFrame

local passwordBox = Instance.new("TextBox")
passwordBox.Size = UDim2.new(0.8,0,0,50)
passwordBox.Position = UDim2.new(0.1,0,0,90)
passwordBox.BackgroundColor3 = Color3.fromRGB(40,40,50)
passwordBox.TextColor3 = Color3.fromRGB(255,255,255)
passwordBox.Font = Enum.Font.GothamBold
passwordBox.TextSize = 20
passwordBox.PlaceholderText = "Type here..."
passwordBox.Parent = LoaderFrame

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.4,0,0,40)
submitBtn.Position = UDim2.new(0.3,0,0,150)
submitBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
submitBtn.TextColor3 = Color3.fromRGB(255,255,255)
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 18
submitBtn.Text = "Submit"
submitBtn.Parent = LoaderFrame

local correctPassword = "YILZI-LEGENDARY"

submitBtn.MouseButton1Click:Connect(function()
    if passwordBox.Text == correctPassword then
        TweenService:Create(LoaderFrame,TweenInfo.new(0.5),{Position=UDim2.new(0.5,-200,1,300)}):Play()
        print("Access granted! Welcome to ULTIMATE GOD MODE")
    else
        passwordBox.Text = ""
        print("Wrong password!")
    end
end)
