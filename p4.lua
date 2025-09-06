-- ⚡ Fish It Loader (Auto Fish + UI Elegant + Animasi + Sound)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- GUI Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishItLoader"
ScreenGui.Parent = game.CoreGui

-- Blur Background
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 40)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageTransparency = 0.5

-- Tombol kecil
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, 0, 1, 0)
Button.Text = "⚙️ Fish Loader"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 14
Button.BackgroundTransparency = 1
Button.Parent = MainFrame

-- Panel Settings
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(0, 220, 0, 0) -- mulai hidden
SettingsFrame.Position = UDim2.new(0, 0, 1.2, 0)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SettingsFrame.BorderSizePixel = 0
SettingsFrame.ClipsDescendants = true
SettingsFrame.Visible = false
SettingsFrame.Parent = MainFrame

local SettingsCorner = Instance.new("UICorner", SettingsFrame)
SettingsCorner.CornerRadius = UDim.new(0, 10)

-- Info Label
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 25)
Info.Text = "⚡ Fish It Loader"
Info.TextColor3 = Color3.fromRGB(0, 255, 140)
Info.Font = Enum.Font.GothamBold
Info.TextSize = 14
Info.BackgroundTransparency = 1
Info.Parent = SettingsFrame

-- Data Player
local UserIdLabel = Instance.new("TextLabel")
UserIdLabel.Size = UDim2.new(1, -10, 0, 20)
UserIdLabel.Position = UDim2.new(0, 5, 0, 30)
UserIdLabel.Text = "UserId: " .. LocalPlayer.UserId
UserIdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UserIdLabel.Font = Enum.Font.Gotham
UserIdLabel.TextSize = 12
UserIdLabel.BackgroundTransparency = 1
UserIdLabel.TextXAlignment = Enum.TextXAlignment.Left
UserIdLabel.Parent = SettingsFrame

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(1, -10, 0, 20)
NameLabel.Position = UDim2.new(0, 5, 0, 55)
NameLabel.Text = "Name: " .. LocalPlayer.Name
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.Font = Enum.Font.Gotham
NameLabel.TextSize = 12
NameLabel.BackgroundTransparency = 1
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Parent = SettingsFrame

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, -10, 0, 20)
FPSLabel.Position = UDim2.new(0, 5, 0, 80)
FPSLabel.Text = "FPS: ..."
FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextSize = 12
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
FPSLabel.Parent = SettingsFrame

local MemberLabel = Instance.new("TextLabel")
MemberLabel.Size = UDim2.new(1, -10, 0, 20)
MemberLabel.Position = UDim2.new(0, 5, 0, 105)
MemberLabel.Text = "Members: " .. #Players:GetPlayers()
MemberLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MemberLabel.Font = Enum.Font.Gotham
MemberLabel.TextSize = 12
MemberLabel.BackgroundTransparency = 1
MemberLabel.TextXAlignment = Enum.TextXAlignment.Left
MemberLabel.Parent = SettingsFrame

-- Toggle Auto Fish
local AutoFishEnabled = false
local AutoFishBtn = Instance.new("TextButton")
AutoFishBtn.Size = UDim2.new(0, 120, 0, 28)
AutoFishBtn.Position = UDim2.new(0.5, -60, 1, -35)
AutoFishBtn.Text = "🎣 Auto Fish: OFF"
AutoFishBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
AutoFishBtn.Font = Enum.Font.GothamBold
AutoFishBtn.TextSize = 12
AutoFishBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoFishBtn.Parent = SettingsFrame

local AutoFishCorner = Instance.new("UICorner", AutoFishBtn)
AutoFishCorner.CornerRadius = UDim.new(0, 8)

-- Suara klik
local ClickSound = Instance.new("Sound", SoundService)
ClickSound.SoundId = "rbxassetid://12221967" -- suara klik
ClickSound.Volume = 0.5

-- Fungsi play klik
local function playClick()
    ClickSound:Play()
end

-- Toggle Settings (Animasi + Blur + Sound)
Button.MouseButton1Click:Connect(function()
    playClick()
    if SettingsFrame.Visible == false then
        SettingsFrame.Visible = true
        TweenService:Create(SettingsFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 220, 0, 160)}):Play()
        TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 5}):Play()
    else
        TweenService:Create(SettingsFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 220, 0, 0)}):Play()
        TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
        wait(0.4)
        SettingsFrame.Visible = false
    end
end)

-- Update FPS & Members
local LastTick = tick()
local Frames = 0
RunService.RenderStepped:Connect(function()
    Frames = Frames + 1
    if tick() - LastTick >= 1 then
        FPSLabel.Text = "FPS: " .. tostring(Frames)
        MemberLabel.Text = "Members: " .. #Players:GetPlayers()
        Frames = 0
        LastTick = tick()
    end
end)

-- Sistem Auto Fish
AutoFishBtn.MouseButton1Click:Connect(function()
    playClick()
    AutoFishEnabled = not AutoFishEnabled
    if AutoFishEnabled then
        AutoFishBtn.Text = "🎣 Auto Fish: ON"
        AutoFishBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        AutoFishBtn.Text = "🎣 Auto Fish: OFF"
        AutoFishBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end

    spawn(function()
        while AutoFishEnabled do
            -- TODO: Sesuaikan RemoteEvent asli di game Fish It
            local Event = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
            Event:FireServer("Cast")
            wait(5)
            Event:FireServer("Reel")
            wait(2)
        end
    end)
end)
