-- Mizu Hub Script Hub dengan Logo Toggle, About & Settings
-- Place in StarterPlayerScripts (LocalScript)

-- ===== Services =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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

-- ===== Loader Notification =====
OrionLib:MakeNotification({
    Name = "Mizu Hub Loading...",
    Content = "Harap tunggu sebentar",
    Image = "rbxassetid://4483345998",
    Time = 3
})

wait(3)

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

-- Buttons Examples
local function ButtonSound(btn)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://12222225"
    s.Volume = 1
    s.Parent = LocalPlayer:WaitForChild("PlayerGui")
    s:Play()
    Debris:AddItem(s,2)
    
    if btn then
        local original = btn.BackgroundColor3
        btn.BackgroundColor3 = Color3.fromRGB(0,255,255)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = original}):Play()
    end
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

-- Game Tab
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

-- About Tab
local AboutTab = Window:MakeTab({
    Name = "About",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

AboutTab:AddLabel("Developer : Yilzi")
AboutTab:AddLabel("Telegram : @XyHanzyy")
AboutTab:AddLabel("Discord : @Xauzi")

-- Settings Tab
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Custom toggle-like button
local function CreateToggleButton(tab, name, default)
    local state = default or false
    local btn = tab:AddButton({
        Name = name,
        Callback = function()
            state = not state
            btn.Button.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        end
    })
    btn.Button.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end

CreateToggleButton(SettingsTab, "Auto Fish", false)
CreateToggleButton(SettingsTab, "Auto Prefect", false)
CreateToggleButton(SettingsTab, "Auto Amazing", false)

-- ===== Logo Shortcut Button =====
local logoGui = Instance.new("ScreenGui")
logoGui.Name = "MizuHubLogoGui"
logoGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
logoGui.Enabled = false

local logoButton = Instance.new("ImageButton")
logoButton.Size = UDim2.new(0, 100, 0, 100)
logoButton.Position = UDim2.new(0, 20, 0, 20)
logoButton.Image = "rbxassetid://4483345998"
logoButton.BackgroundTransparency = 1
logoButton.Parent = logoGui

logoButton.MouseButton1Click:Connect(function()
    Window:Show()
    logoGui.Enabled = false
end)

-- ===== Close Button Override =====
Window:MakeButton({
    Name = "Close",
    Callback = function()
        Window:Hide()
        logoGui.Enabled = true
    end
})

-- ===== Toggle Window Shortcut =====
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.RightShift and not processed then
        if Window.Visible then
            Window:Hide()
            logoGui.Enabled = true
        else
            Window:Show()
            logoGui.Enabled = false
        end
    end
end)

-- ===== Init Orion =====
OrionLib:Init()
