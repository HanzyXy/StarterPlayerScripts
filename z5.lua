-- FINAL: Mizu Hub Script Hub (Modern UI)
-- Place in StarterPlayerScripts (LocalScript)
-- Security: hanya user yang ada di database username bisa akses

-- ===== Services =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ===== Security =====
local AllowedUsers = { "Franzyyy16", "7SEAYilzi", "Player3" } -- Ganti dengan username Roblox yang diizinkan

local function isAllowed(username)
    for _, name in pairs(AllowedUsers) do
        if name == username then
            return true
        end
    end
    return false
end

if not isAllowed(LocalPlayer.Name) then
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

-- Tambahkan sound loading
local LoadSound = Instance.new("Sound")
LoadSound.SoundId = "rbxassetid://138187576" -- Ganti dengan sound ID yang diinginkan
LoadSound.Volume = 1
LoadSound.PlayOnRemove = true
LoadSound.Parent = LocalPlayer:WaitForChild("PlayerGui")
LoadSound:Destroy() -- Play sound

wait(3)

-- ===== Background Glow & Particle =====
local bgPart = Instance.new("Part")
bgPart.Anchored = true
bgPart.CanCollide = false
bgPart.Size = Vector3.new(50,50,1)
bgPart.Position = Vector3.new(0,10,0)
bgPart.Transparency = 1
bgPart.Parent = workspace

local particle = Instance.new("ParticleEmitter")
particle.Texture = "rbxassetid://243660364" -- Partikel glow
particle.Rate = 50
particle.Lifetime = NumberRange.new(2)
particle.Speed = NumberRange.new(1,3)
particle.Parent = bgPart

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

-- Toggle Example
UniversalTab:AddToggle({
    Name = "Auto Jump",
    Default = false,
    Callback = function(value)
        if value then
            print("Auto Jump ON")
        else
            print("Auto Jump OFF")
        end
    end
})

-- Slider Example
UniversalTab:AddSlider({
    Name = "Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    Suffix = " WalkSpeed",
    Callback = function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

-- Dropdown Example
UniversalTab:AddDropdown({
    Name = "Select Tool",
    Options = { "Sword", "Gun", "Magic" },
    Default = "Sword",
    Callback = function(option)
        print("Tool dipilih: "..option)
    end
})

-- Buttons dengan sound
local function ButtonSound()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://12222225" -- Ganti dengan sound ID tombol
    s.Volume = 1
    s.Parent = LocalPlayer:WaitForChild("PlayerGui")
    s:Play()
    game:GetService("Debris"):AddItem(s,2)
end

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

-- Toggle untuk auto farm (contoh)
GameTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        if value then
            print("Auto Farm ON")
        else
            print("Auto Farm OFF")
        end
    end
})

-- ===== Init Orion =====
OrionLib:Init()

-- ===== Toggle Window dengan RightShift =====
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.RightShift and not processed then
        Window:Toggle()
    end
end)
