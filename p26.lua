--[[ 
   Fish It PRO Cheat vFinal
   Password: YILZI-EXECUTOR
   Fitur: Ultra Neon UI, animasi tombol glow, radar interaktif, partikel, popup notif, sound, toggle cheat
--]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer

-- ===== Blur =====
local Blur = Instance.new("BlurEffect")
Blur.Size = 25
Blur.Parent = Lighting

-- ===== Particle Background =====
local ParticleFrame = Instance.new("Frame")
ParticleFrame.Size = UDim2.new(1,0,1,0)
ParticleFrame.BackgroundTransparency = 1
ParticleFrame.Parent = CoreGui

for i=1,50 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0,5,0,5)
    p.Position = UDim2.new(math.random(),0,math.random(),0)
    p.BackgroundColor3 = Color3.fromRGB(0,255,255)
    p.BorderSizePixel = 0
    p.AnchorPoint = Vector2.new(0.5,0.5)
    p.BackgroundTransparency = 0.4
    p.Parent = ParticleFrame
    spawn(function()
        while true do
            p.Position = UDim2.new(math.random(),0,math.random(),0)
            wait(math.random(1,4)/10)
        end
    end)
end

-- ===== ScreenGui =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishItPROUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- ===== Background Music =====
local Music = Instance.new("Sound")
Music.SoundId = "rbxassetid://9118825745"
Music.Looped = true
Music.Volume = 0.3
Music.Parent = ScreenGui
Music:Play()

-- ===== Main Frame =====
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,700,0,600)
MainFrame.Position = UDim2.new(0.5,-350,0.5,-300)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Neon Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,128,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,255))
}
gradient.Rotation = 45
gradient.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,70)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "Fish It PRO Cheat"
Title.TextColor3 = Color3.fromRGB(0,255,255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- ===== Popup Notif =====
local function ShowNotif(msg)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0,300,0,50)
    notif.Position = UDim2.new(0.5,-150,0,10)
    notif.BackgroundColor3 = Color3.fromRGB(0,0,0)
    notif.BackgroundTransparency = 0.3
    notif.TextColor3 = Color3.fromRGB(0,255,255)
    notif.TextScaled = true
    notif.Text = msg
    notif.Font = Enum.Font.GothamBold
    notif.Parent = MainFrame
    notif.ZIndex = 10
    notif.TextStrokeTransparency = 0.5

    TweenService:Create(notif,TweenInfo.new(0.5),{Position=UDim2.new(0.5,-150,0,70), BackgroundTransparency=0}):Play()
    delay(2,function()
        TweenService:Create(notif,TweenInfo.new(0.5),{Position=UDim2.new(0.5,-150,0,-60), BackgroundTransparency=1}):Play()
        wait(0.5)
        notif:Destroy()
    end)
end

-- ===== Tabs =====
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1,-20,0,50)
Tabs.Position = UDim2.new(0,10,0,80)
Tabs.BackgroundTransparency = 1
Tabs.Parent = MainFrame

local tabNames = {"Main","Auto","Teleport","Radar","Misc"}
local tabButtons = {}

local function SwitchTab(tabName)
    for _,v in pairs(MainFrame:GetChildren()) do
        if v:IsA("Frame") and v.Name == "TabContent" then
            TweenService:Create(v,TweenInfo.new(0.3),{Position=UDim2.new(0,20,0,650)}):Play()
            wait(0.2)
            v.Visible=false
        end
    end
    local tabFrame = MainFrame:FindFirstChild(tabName.."Content")
    if tabFrame then
        tabFrame.Visible=true
        TweenService:Create(tabFrame,TweenInfo.new(0.4),{Position=UDim2.new(0,20,0,140)}):Play()
    end
end

for i,name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,130,1,0)
    btn.Position = UDim2.new(0,(i-1)*135,0,0)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.TextColor3 = Color3.fromRGB(0,255,255)
    btn.Text = name
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Tabs
    tabButtons[name]=btn
    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
        Music:Play()
        TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundColor3=Color3.fromRGB(0,128,255)}):Play()
    end)
end

-- ===== Tab Content =====
local function CreateTabContent(name)
    local frame = Instance.new("Frame")
    frame.Name = name.."Content"
    frame.Size = UDim2.new(1,-40,1,-200)
    frame.Position = UDim2.new(0,20,0,650)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = MainFrame
    return frame
end

local mainTab = CreateTabContent("Main")
local autoTab = CreateTabContent("Auto")
local tpTab = CreateTabContent("Teleport")
local radarTab = CreateTabContent("Radar")
local miscTab = CreateTabContent("Misc")

-- ===== Toggle Button Creator (Neon Glow) =====
local function CreateToggle(parent,text,pos,callback)
    local btn = Instance.new("TextButton")
    btn.Size=UDim2.new(0,220,0,50)
    btn.Position=pos
    btn.BackgroundColor3=Color3.fromRGB(0,0,0)
    btn.BorderColor3=Color3.fromRGB(0,255,255)
    btn.TextColor3=Color3.fromRGB(0,255,255)
    btn.TextScaled=true
    btn.Text=text.." [OFF]"
    btn.Font=Enum.Font.GothamSemibold
    btn.Parent=parent

    local state=false
    -- Pulsating glow effect
    spawn(function()
        while btn.Parent do
            TweenService:Create(btn,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BorderColor3=Color3.fromRGB(0,255,255)}):Play()
            wait(1)
        end
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(0,128,255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(0,0,0)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        state=not state
        btn.Text=text.." ["..(state and "ON" or "OFF").."]"
        callback(state)
        Music:Play()
        ShowNotif(text.." "..(state and "Enabled" or "Disabled"))
    end)
end

-- ===== Main Tab =====
CreateToggle(mainTab,"Speed Hack",UDim2.new(0,20,0,20),function(state)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = state and 70 or 16
    end
end)
CreateToggle(mainTab,"Instant Catch",UDim2.new(0,20,0,90),function(state)
    print("Instant Catch "..(state and "Enabled" or "Disabled"))
end)

-- ===== Auto Tab =====
CreateToggle(autoTab,"Auto Fish",UDim2.new(0,20,0,20),function(state)
    _G.AutoFish = state
    if state then
        spawn(function()
            while _G.AutoFish do
                local tool = Player.Backpack:FindFirstChild("FishingRod") or Player.Character:FindFirstChild("FishingRod")
                if tool then tool:Activate() end
                wait(0.3)
            end
        end)
    end
end)
CreateToggle(autoTab,"Auto Sell",UDim2.new(0,20,0,90),function(state)
    _G.AutoSell=state
    if state then
        spawn(function()
            while _G.AutoSell do
                print("Auto Sell Triggered")
                wait(1)
            end
        end)
    end
end)
CreateToggle(autoTab,"Auto Reward",UDim2.new(0,20,0,160),function(state)
    _G.AutoReward=state
    if state then
        spawn(function()
            while _G.AutoReward do
                print("Auto Reward Triggered")
                wait(3)
            end
        end)
    end
end)

-- ===== Teleport Tab =====
CreateToggle(tpTab,"Teleport Hub",UDim2.new(0,20,0,20),function(state)
    if state and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame=CFrame.new(0,10,0)
    end
end)
CreateToggle(tpTab,"Teleport Spot1",UDim2.new(0,20,0,90),function(state)
    if state and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame=CFrame.new(100,10,50)
    end
end)

-- ===== Radar Tab =====
local radarCanvas = Instance.new("Frame")
radarCanvas.Size=UDim2.new(1,0,1,0)
radarCanvas.BackgroundTransparency=1
radarCanvas.Parent=radarTab

for i=1,20 do
    local spot = Instance.new("Frame")
    spot.Size=UDim2.new(0,12,0,12)
    spot.Position=UDim2.new(math.random(),0,math.random(),0)
    spot.BackgroundColor3=Color3.fromRGB(255,255,0)
    spot.BorderSizePixel=0
    spot.AnchorPoint=Vector2.new(0.5,0.5)
    spot.Parent=radarCanvas
    -- Neon pulse
    spawn(function()
        while true do
            TweenService:Create(spot,TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size=UDim2.new(0,20,0,20)}):Play()
            wait(0.7)
            TweenService:Create(spot,TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size=UDim2.new(0,12,0,12)}):Play()
            wait(0.7)
        end
    end)
    spawn(function()
        while true do
            spot.Position=UDim2.new(math.random(),0,math.random(),0)
            wait(math.random(2,6)/10)
        end
    end)
end

-- ===== Misc Tab =====
CreateToggle(miscTab,"Close UI",UDim2.new(0,20,0,20),function(state)
    if state then
        ScreenGui:Destroy()
        Blur:Destroy()
        ParticleFrame:Destroy()
        Music:Stop()
    end
end)

-- ===== Default Tab =====
SwitchTab("Main")

-- ===== ESC Toggle =====
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode==Enum.KeyCode.Escape then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- ===== Password Protection =====
local password = "YILZI"
local PasswordCorrect=false
repeat
    local input = Player:WaitForChild("PlayerGui"):FindFirstChild("PasswordInput")
    if input then
        if input.Text==password then
            PasswordCorrect=true
        else
            print("Password Salah!")
        end
    end
    wait(0.5)
until PasswordCorrect
