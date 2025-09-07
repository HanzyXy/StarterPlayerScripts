-- ULTRA CINEMATIC: Mizu Hub Script Hub
-- Place in StarterPlayerScripts (LocalScript)

-- ===== Services =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

-- ===== Security User =====
local AllowedUsers = { "Franzyyy16", "7SEAYilzi", "Player3" }
if not table.find(AllowedUsers, LocalPlayer.Name) then
    warn("Access Denied: Username tidak terdaftar")
    return
end

-- ===== Password Security =====
local function RequestPassword(correctPassword)
    local passwordGui = Instance.new("ScreenGui")
    passwordGui.Name = "PasswordGui"
    passwordGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,300,0,150)
    frame.Position = UDim2.new(0.5,-150,0.5,-75)
    frame.BackgroundColor3 = Color3.fromRGB(45,0,80)
    frame.BorderSizePixel = 0
    frame.Parent = passwordGui

    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(0,250,0,50)
    textbox.Position = UDim2.new(0.5,-125,0,30)
    textbox.PlaceholderText = "Enter Password"
    textbox.Text = ""
    textbox.BackgroundColor3 = Color3.fromRGB(60,0,100)
    textbox.TextColor3 = Color3.fromRGB(255,255,255)
    textbox.TextScaled = true
    textbox.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0,120,0,40)
    button.Position = UDim2.new(0.5,-60,0,90)
    button.Text = "Enter"
    button.BackgroundColor3 = Color3.fromRGB(120,0,255)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.TextScaled = true
    button.Parent = frame

    local success = Instance.new("BoolValue")
    success.Value = false

    local function CheckPassword()
        if textbox.Text == correctPassword then
            success.Value = true
            passwordGui:Destroy()
        else
            textbox.Text = ""
            textbox.PlaceholderText = "Wrong Password!"
        end
    end

    button.MouseButton1Click:Connect(CheckPassword)
    textbox.FocusLost:Connect(function(enter)
        if enter then CheckPassword() end
    end)

    repeat wait() until success.Value
end

RequestPassword("YILZI-EXECUTOR") -- PASSWORD

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
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180,0,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}
particle.Parent = bgPart

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

-- ===== Tabs Setup (Purple Theme) =====
local UniversalTab = Window:MakeTab({ Name = "Universal Scripts", Icon = "rbxassetid://4483345998", PremiumOnly = false })
local GameTab = Window:MakeTab({ Name = "Game Scripts", Icon = "rbxassetid://4483345998", PremiumOnly = false })
local AboutTab = Window:MakeTab({ Name = "About", Icon = "rbxassetid://4483345998", PremiumOnly = false })
local SettingsTab = Window:MakeTab({ Name = "Settings", Icon = "rbxassetid://4483345998", PremiumOnly = false })

-- ===== About Tab =====
AboutTab:AddLabel("Developer : Yilzi")
AboutTab:AddLabel("Telegram : @XyHanzyy")
AboutTab:AddLabel("Discord : @Xauzi")

-- ===== Settings Tab =====
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
CreateToggleButton(SettingsTab, "Auto Perfect", false)
CreateToggleButton(SettingsTab, "Auto Amazing", false)

-- ===== Button Sound + Neon Hover Bounce =====
local function EnhanceButton(btn)
    local originalColor = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(180,0,255),
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

-- ===== Logo Shortcut (Draggable + Fade) =====
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

-- ===== Draggable Function =====
local function MakeDraggable(guiObject, frame)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ===== Apply draggable =====
MakeDraggable(logoGui, logoButton)
MakeDraggable(LocalPlayer.PlayerGui, Window.Frame)

-- ===== Fade In/Out Logo =====
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

-- ===== Close Button =====
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
