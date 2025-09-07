-- FINAL ULTIMATE: Mizu Hub Script Hub (Cinematic Modern UI)
-- Place in StarterPlayerScripts (LocalScript)

-- ===== Services =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

-- ===== Security =====
local AllowedUsers = { "Franzyyy16", "7SEAYilzi", "Player3" }
if not table.find(AllowedUsers, LocalPlayer.Name) then
    warn("Access Denied: Username tidak terdaftar")
    return
end

-- ===== OrionLib Load =====
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- ===== Loader Cinematic =====
OrionLib:MakeNotification({
    Name = "Mizu Hub Loading...",
    Content = "Harap tunggu sebentar",
    Image = "rbxassetid://4483345998",
    Time = 3
})

-- Sound loading
local LoadSound = Instance.new("Sound")
LoadSound.SoundId = "rbxassetid://138187576"
LoadSound.Volume = 1
LoadSound.PlayOnRemove = true
LoadSound.Parent = LocalPlayer:WaitForChild("PlayerGui")
LoadSound:Destroy()

wait(3)

-- ===== Background Particle Neon Interaktif =====
local bgPart = Instance.new("Part")
bgPart.Anchored = true
bgPart.CanCollide = false
bgPart.Size = Vector3.new(50,50,1)
bgPart.Position = Vector3.new(0,10,0)
bgPart.Transparency = 1
bgPart.Parent = workspace

local particle = Instance.new("ParticleEmitter")
particle.Texture = "rbxassetid://243660364"
particle.Rate = 75
particle.Lifetime = NumberRange.new(2)
particle.Speed = NumberRange.new(2,4)
particle.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}
particle.Parent = bgPart

-- Particle mengikuti mouse
RunService.RenderStepped:Connect(function()
    local mouse = LocalPlayer:GetMouse()
    bgPart.Position = Vector3.new(mouse.Hit.X, mouse.Hit.Y, mouse.Hit.Z)
end)

-- ===== Window Setup =====
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

-- ===== Tabs =====
local UniversalTab = Window:MakeTab({
    Name = "Universal Scripts",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Toggle Example with auto save
UniversalTab:AddToggle({
    Name = "Auto Jump",
    Default = OrionLib:LoadConfig("Auto Jump") or false,
    Callback = function(value)
        OrionLib:SaveConfig("Auto Jump", value)
        if value then
            print("Auto Jump ON")
        else
            print("Auto Jump OFF")
        end
    end
})

-- Slider Example with auto save
UniversalTab:AddSlider({
    Name = "Speed",
    Min = 16,
    Max = 100,
    Default = OrionLib:LoadConfig("Speed") or 16,
    Increment = 1,
    Suffix = " WalkSpeed",
    Callback = function(value)
        OrionLib:SaveConfig("Speed", value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

-- Dropdown Example with auto save
UniversalTab:AddDropdown({
    Name = "Select Tool",
    Options = { "Sword", "Gun", "Magic" },
    Default = OrionLib:LoadConfig("Select Tool") or "Sword",
    Callback = function(option)
        OrionLib:SaveConfig("Select Tool", option)
        print("Tool dipilih: "..option)
    end
})

-- Button sound function with glow animation
local function ButtonSound(btn)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://12222225"
    s.Volume = 1
    s.Parent = LocalPlayer:WaitForChild("PlayerGui")
    s:Play()
    Debris:AddItem(s,2)

    -- Glow animation
    if btn then
        local originalColor = btn.BackgroundColor3
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = originalColor}):Play()
    end
end

-- Buttons
UniversalTab:AddButton({
    Name = "Fly Script",
    Callback = function()
        ButtonSound()
        loadstring(game:HttpGet("https://pastebin.com/raw/YOURFLYSCRIPT"))()
    end
})

UniversalTab:AddButton({
    Name = "ESP Script",
    Callback = function()
        ButtonSound()
        loadstring(game:HttpGet("https://pastebin.com/raw/YOURESPSCRIPT"))()
    end
})

-- Game Specific Tab
local GameTab = Window:MakeTab({
    Name = "Game Scripts",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

GameTab:AddButton({
    Name = "Blox Fruits Script",
    Callback = function()
        ButtonSound()
        loadstring(game:HttpGet("https://pastebin.com/raw/YOURBLOXFRUITSSCRIPT"))()
    end
})

GameTab:AddButton({
    Name = "Doors Script",
    Callback = function()
        ButtonSound()
        loadstring(game:HttpGet("https://pastebin.com/raw/YOURDOORSSCRIPT"))()
    end
})

-- Toggle Auto Farm
GameTab:AddToggle({
    Name = "Auto Farm",
    Default = OrionLib:LoadConfig("Auto Farm") or false,
    Callback = function(value)
        OrionLib:SaveConfig("Auto Farm", value)
        if value then
            print("Auto Farm ON")
        else
            print("Auto Farm OFF")
        end
    end
})

-- ===== Init Orion =====
OrionLib:Init()

-- ===== Toggle Window Shortcut =====
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.RightShift and not processed then
        Window:Toggle()
    end
end)
