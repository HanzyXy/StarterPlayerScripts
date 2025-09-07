-- ===== Mizu Hub Full Upgrade =====
-- Place in StarterPlayerScripts (LocalScript)

-- Password Setup
local PASSWORD = "MIZUHUB123"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- Prompt Password
local success = false
repeat
    local input = OrionLib:MakeNotification({
        Name = "Mizu Hub Password",
        Content = "Masukkan Password untuk mengakses hub",
        Image = "rbxassetid://4483345998",
        Time = 10
    })
    wait(0.1)
    local text = OrionLib:Prompt("Masukkan Password", "Password required:", "")
    if text == PASSWORD then
        success = true
    else
        OrionLib:MakeNotification({
            Name = "Password Salah",
            Content = "Coba lagi",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
until success

-- Loading Screen
OrionLib:MakeNotification({
    Name = "Mizu Hub Loading...",
    Content = "Harap tunggu sebentar",
    Image = "rbxassetid://4483345998",
    Time = 3
})

wait(3)

-- Main Window
local Window = OrionLib:MakeWindow({
    Name = "Mizu Hub | Script Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MizuHubConfig",
    IntroEnabled = true,
    IntroText = "Mizu Hub",
    IntroIcon = "rbxassetid://4483345998",
    Dragable = true
})

-- Particle Background
local particleFrame = Instance.new("Frame")
particleFrame.Size = UDim2.new(1,0,1,0)
particleFrame.BackgroundTransparency = 1
particleFrame.Parent = Window.Main

for i=1,50 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0,2,0,2)
    particle.BackgroundColor3 = Color3.fromRGB(math.random(50,255), math.random(50,255), math.random(50,255))
    particle.Position = UDim2.new(math.random(),0,math.random(),0)
    particle.AnchorPoint = Vector2.new(0.5,0.5)
    particle.BackgroundTransparency = 0.2
    particle.Parent = particleFrame

    local tweenInfo = TweenInfo.new(math.random(2,5), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
    TweenService:Create(particle, tweenInfo, {Position = UDim2.new(math.random(),0,math.random(),0)}):Play()
end

-- Universal Scripts Tab
local UniversalTab = Window:MakeTab({
    Name = "Universal Scripts",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

UniversalTab:AddButton({
    Name = "Fly Script",
    Callback = function()
        OrionLib:MakeNotification({Name="Fly Script", Content="Loaded!", Image="rbxassetid://4483345998", Time=2})
        loadstring(game:HttpGet("https://pastebin.com/raw/YOURFLYSCRIPT"))()
    end
})

UniversalTab:AddButton({
    Name = "ESP Script",
    Callback = function()
        OrionLib:MakeNotification({Name="ESP Script", Content="Loaded!", Image="rbxassetid://4483345998", Time=2})
        loadstring(game:HttpGet("https://pastebin.com/raw/YOURESPSCRIPT"))()
    end
})

-- Game Scripts Tab
local GameTab = Window:MakeTab({
    Name = "Game Scripts",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Auto Detect Game
local PlaceId = game.PlaceId

if PlaceId == 2753915549 then -- Blox Fruits
    GameTab:AddButton({
        Name = "Blox Fruits Script",
        Callback = function()
            OrionLib:MakeNotification({Name="Blox Fruits", Content="Loaded!", Image="rbxassetid://4483345998", Time=2})
            loadstring(game:HttpGet("https://pastebin.com/raw/YOURBLOXFRUITSSCRIPT"))()
        end
    })
elseif PlaceId == 6839171748 then -- Doors
    GameTab:AddButton({
        Name = "Doors Script",
        Callback = function()
            OrionLib:MakeNotification({Name="Doors", Content="Loaded!", Image="rbxassetid://4483345998", Time=2})
            loadstring(game:HttpGet("https://pastebin.com/raw/YOURDOORSSCRIPT"))()
        end
    })
else
    GameTab:AddLabel("No game specific scripts available")
end

-- Sound Click Effect
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://142376088" -- contoh sound
clickSound.Volume = 1
clickSound.Parent = Window.Main

-- Override Buttons to Play Sound
for _,tab in pairs(Window.Tabs) do
    for _,obj in pairs(tab.Objects) do
        if obj.Type == "Button" then
            local oldCallback = obj.Callback
            obj.Callback = function(...)
                clickSound:Play()
                oldCallback(...)
            end
        end
    end
end

-- Initialize Orion
OrionLib:Init()
