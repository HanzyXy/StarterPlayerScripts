-- ULTRA CINEMATIC: Mizu Hub Script Hub
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

-- ===== Loader Cinematic =====
OrionLib:MakeNotification({
    Name = "Evolution Hub Loading...",
    Content = "Harap tunggu sebentar",
    Image = "rbxassetid://4483345998",
    Time = 3
})
wait(3)

-- ===== Background Particle Neon =====
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

RunService.RenderStepped:Connect(function()
    local mouse = LocalPlayer:GetMouse()
    bgPart.Position = Vector3.new(mouse.Hit.X, mouse.Hit.Y, mouse.Hit.Z)
end)

-- ===== Window Setup =====
local Window = OrionLib:MakeWindow({
    Name = "Evolution Hub | Script Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MizuHubConfig",
    IntroEnabled = true,
    IntroText = "Evolution Hub",
    IntroIcon = "rbxassetid://4483345998",
    Dragable = true
})

-- ===== Tabs Setup =====
local UniversalTab = Window:MakeTab({ Name = "Universal Scripts", Icon = "rbxassetid://4483345998", PremiumOnly = false })
local GameTab = Window:MakeTab({ Name = "Game Scripts", Icon = "rbxassetid://4483345998", PremiumOnly = false })
local AboutTab = Window:MakeTab({ Name = "About", Icon = "rbxassetid://4483345998", PremiumOnly = false })
local SettingsTab = Window:MakeTab({ Name = "Settings", Icon = "rbxassetid://4483345998", PremiumOnly = false })

-- ===== About Tab =====
AboutTab:AddLabel("Developer : Yilzi")
AboutTab:AddLabel("Telegram : @XyHanzyy")
AboutTab:AddLabel("Discord : @Xauzi")

-- ===== Settings Tab (Toggle Hijau/Merah) =====
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

-- ===== Button Sound + Neon Hover Bounce =====
local function EnhanceButton(btn)
    local originalColor = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(0,255,255),
            Size = btn.Size + UDim2.new(0,10,0,10)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = originalColor,
            Size = btn.Size - UDim2.new(0,10,0,10)
        }):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://12222225"
        s.Volume = 1
        s.Parent = LocalPlayer:WaitForChild("PlayerGui")
        s:Play()
        Debris:AddItem(s,2)
    end)
end

-- Apply to all buttons
for _, tab in pairs({UniversalTab, GameTab, SettingsTab}) do
    for _, btnObj in pairs(tab.Buttons) do
        EnhanceButton(btnObj.Button)
    end
end

-- ===== Universal & Game Buttons =====
UniversalTab:AddButton({ Name = "Fly Script", Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/YOURFLYSCRIPT"))() end })
UniversalTab:AddButton({ Name = "ESP Script", Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/YOURESPSCRIPT"))() end })

GameTab:AddButton({ Name = "Blox Fruits Script", Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/YOURBLOXFRUITSSCRIPT"))() end })
GameTab:AddButton({ Name = "Doors Script", Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/YOURDOORSSCRIPT"))() end })

-- ===== Logo Shortcut (Draggable + Fade + Smooth) =====
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

-- Draggable Logo
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
logoButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = logoButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
logoButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        logoButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Fade In/Out Logo
local function FadeLogo(enable)
    logoGui.Enabled = true
    local goal = {BackgroundTransparency = enable and 0 or 1}
    TweenService:Create(logoButton, TweenInfo.new(0.5), goal):Play()
    if not enable then
        wait(0.5)
        logoGui.Enabled = false
    end
end

logoButton.MouseButton1Click:Connect(function()
    Window:Show()
    FadeLogo(false)
end)

-- ===== Tab Slide + Fade =====
local function SlideFadeTab(tab)
    tab.Frame.Position = UDim2.new(1,0,0,0)
    tab.Frame.BackgroundTransparency = 1
    TweenService:Create(tab.Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0,0,0,0),
        BackgroundTransparency = 0
    }):Play()
end

for _, tab in pairs({UniversalTab, GameTab, AboutTab, SettingsTab}) do
    tab.Button.MouseButton1Click:Connect(function()
        SlideFadeTab(tab)
    end)
end

-- ===== Close Button Override =====
Window:MakeButton({ Name = "Close", Callback = function()
    Window:Hide()
    FadeLogo(true)
end })

-- ===== Toggle Window Shortcut =====
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.RightShift and not processed then
        if Window.Visible then
            Window:Hide()
            FadeLogo(true)
        else
            Window:Show()
            FadeLogo(false)
        end
    end
end)

-- ===== Init Orion =====
OrionLib:Init()
