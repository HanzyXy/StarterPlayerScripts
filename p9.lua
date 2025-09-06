-- FINAL: Fish It Loader (Password + Loader + Dashboard + Tabs)
-- Place in StarterPlayerScripts (LocalScript)
-- Password: YILZI-EXECUTOR

-- ===== Services & Config =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local PASSWORD = "YILZI-EXECUTOR"
local CLICK_SOUND_ID = "rbxassetid://12221967" -- click
local UI_W, UI_H = 620, 420
local AUTO_FISH_CLIENT_INTERVAL = 4 -- client-side interval
local CAST_EVENT_NAME = "RemoteEvent" -- change to your game's RemoteEvent name

-- ===== Helpers =====
local function new(class, props)
    local obj = Instance.new(class)
    if props then for k,v in pairs(props) do obj[k] = v end end
    return obj
end
local function tween(inst, props, t, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    TweenService:Create(inst, TweenInfo.new(t, style, dir), props):Play()
end
local function safeFireRemote(action)
    pcall(function()
        local ev = ReplicatedStorage:FindFirstChild(CAST_EVENT_NAME)
        if ev and ev:IsA("RemoteEvent") then
            ev:FireServer(action)
        else
            warn("RemoteEvent '"..CAST_EVENT_NAME.."' not found in ReplicatedStorage")
        end
    end)
end

-- ===== Root GUI =====
local screenGui = new("ScreenGui", {Name = "FishIt_FinalUI", Parent = game.CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})

-- click sound
local clickSound = new("Sound", {Parent = SoundService, SoundId = CLICK_SOUND_ID, Volume = 0.6})
local function playClick() pcall(function() clickSound:Play() end) end

-- blur (client only)
local lighting = game:GetService("Lighting")
local blur = new("BlurEffect", {Parent = lighting, Size = 0})

-- toast notifications
local function toast(text, color)
    color = color or Color3.fromRGB(60,60,60)
    local toast = new("Frame", {Parent = screenGui, Size = UDim2.new(0, 320, 0, 40), Position = UDim2.new(0.5, -160, 0.12, 0), BackgroundColor3 = color})
    new("UICorner", {Parent = toast, CornerRadius = UDim.new(0, 8)})
    local label = new("TextLabel", {Parent = toast, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, Text = text, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255)})
    toast.AnchorPoint = Vector2.new(0.5, 0)
    toast.Position = UDim2.new(0.5, -160, 0.12, 0)
    tween(toast, {Position = UDim2.new(0.5, -160, 0.06, 0), BackgroundTransparency = 0}, 0.18)
    task.delay(2.2, function()
        tween(toast, {Position = UDim2.new(0.5, -160, 0.12, 0), BackgroundTransparency = 1}, 0.18)
        task.delay(0.18, function() pcall(function() toast:Destroy() end) end)
    end)
end

-- ===== PASSWORD SCREEN =====
local passFrame = new("Frame", {Parent = screenGui, Name = "PasswordWindow", Size = UDim2.new(0, 380, 0, 200), Position = UDim2.new(0.5, -190, 0.5, -100), BackgroundColor3 = Color3.fromRGB(20,20,21), Active = true, Draggable = true})
new("UICorner", {Parent = passFrame, CornerRadius = UDim.new(0,12)})
local title = new("TextLabel", {Parent = passFrame, Size = UDim2.new(1, -28, 0, 40), Position = UDim2.new(0,14,0,8), BackgroundTransparency = 1, Text = "🔒 Secure Access", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.fromRGB(240,240,240), TextXAlignment = Enum.TextXAlignment.Left})
local desc = new("TextLabel", {Parent = passFrame, Size = UDim2.new(1, -28, 0, 28), Position = UDim2.new(0,14,0,46), BackgroundTransparency = 1, Text = "Enter password to unlock the loader.", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Color3.fromRGB(180,180,180), TextXAlignment = Enum.TextXAlignment.Left})
local input = new("TextBox", {Parent = passFrame, Size = UDim2.new(0.86, 0, 0, 44), Position = UDim2.new(0.07, 0, 0, 86), BackgroundColor3 = Color3.fromRGB(30,30,31), Text = "", PlaceholderText = "Password", Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(240,240,240), ClearTextOnFocus = false})
new("UICorner", {Parent = input, CornerRadius = UDim.new(0,8)})
local submitBtn = new("TextButton", {Parent = passFrame, Size = UDim2.new(0.5, 0, 0, 38), Position = UDim2.new(0.25,0,0,140), BackgroundColor3 = Color3.fromRGB(6,135,255), Font = Enum.Font.GothamBold, Text = "Unlock", TextSize = 16, TextColor3 = Color3.fromRGB(255,255,255)})
new("UICorner", {Parent = submitBtn, CornerRadius = UDim.new(0,8)})
local errorLabel = new("TextLabel", {Parent = passFrame, Size = UDim2.new(1, -28, 0, 20), Position = UDim2.new(0,14,1,-26), BackgroundTransparency = 1, Text = "", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Color3.fromRGB(255,120,120), TextXAlignment = Enum.TextXAlignment.Center})

input.FocusLost:Connect(function(enter)
    if enter then submitBtn:CaptureFocus(); submitBtn:ReleaseFocus(); submitBtn:MouseButton1Click() end
end)

-- ===== LOADER BUTTON (hidden) =====
local loaderBtn = new("TextButton", {Parent = screenGui, Name = "LoaderBtn", Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(0.06, 0, 0.35, 0), BackgroundColor3 = Color3.fromRGB(13,100,240), Text = "≡", Font = Enum.Font.GothamBold, TextSize = 26, TextColor3 = Color3.fromRGB(255,255,255), Visible = false, AutoButtonColor = false})
new("UICorner", {Parent = loaderBtn, CornerRadius = UDim.new(1,0)})
new("UIStroke", {Parent = loaderBtn, Thickness = 1, Transparency = 0.8})

-- draggable loader
do
    local dragging, dragInput, dragStart, startPos
    loaderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = loaderBtn.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    loaderBtn.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if dragInput and input == dragInput and dragging then
            local delta = input.Position - dragStart
            loaderBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    loaderBtn.MouseEnter:Connect(function() tween(loaderBtn, {BackgroundColor3 = Color3.fromRGB(28,130,255)}, 0.12) end)
    loaderBtn.MouseLeave:Connect(function() tween(loaderBtn, {BackgroundColor3 = Color3.fromRGB(13,100,240)}, 0.12) end)
end

-- ===== MAIN MENU (hidden) =====
local mainFrame = new("Frame", {Parent = screenGui, Name = "MainMenu", Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5, -UI_W/2, 0.5, -UI_H/2), BackgroundColor3 = Color3.fromRGB(18,18,19), Visible = false})
new("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0,10)})
new("UIStroke", {Parent = mainFrame, Thickness = 1, Transparency = 0.85})

-- Title + Close
local titleLbl = new("TextLabel", {Parent = mainFrame, Size = UDim2.new(1, -28, 0, 44), Position = UDim2.new(0,14,0,10), BackgroundTransparency = 1, Text = "⚡ Fish It Loader", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.fromRGB(240,240,240), TextXAlignment = Enum.TextXAlignment.Left})
local closeBtn = new("TextButton", {Parent = mainFrame, Size = UDim2.new(0,34,0,34), Position = UDim2.new(1, -46, 0, 8), BackgroundColor3 = Color3.fromRGB(200,60,60), Text = "X", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(255,255,255)})
new("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0,8)})
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- Tabs
local tabBar = new("Frame", {Parent = mainFrame, Size = UDim2.new(1, -28, 0, 34), Position = UDim2.new(0,14,0,60), BackgroundTransparency = 1})
local tabButtons = {}
local tabNames = {"Play","Settings","About"}
local contentFrames = {}
for i,name in ipairs(tabNames) do
    local btn = new("TextButton", {Parent = tabBar, Size = UDim2.new(0, 90, 1, 0), Position = UDim2.new(0, (i-1)*100,0,0), BackgroundColor3 = Color3.fromRGB(28,28,30), Text = name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220)})
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
    tabButtons[name] = btn
    local frame = new("Frame", {Parent = mainFrame, Size = UDim2.new(1,-28,1,-110), Position = UDim2.new(0,14,0,100), BackgroundTransparency = 1, Visible = (i==1)})
    contentFrames[name] = frame
    btn.MouseButton1Click:Connect(function()
        playClick()
        for k,f in pairs(contentFrames) do f.Visible = false end
        frame.Visible = true
    end)
end

-- ===== PLAY tab (UI only, no buttons) =====
local playFrame = contentFrames["Play"]

local infoPanel = new("Frame", {Parent = playFrame, Size = UDim2.new(1,0,0,90), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(28,28,30)})
new("UICorner", {Parent = infoPanel, CornerRadius = UDim.new(0,8)})
local infoTxt = new("TextLabel", {Parent = infoPanel, Size = UDim2.new(1,-16,1,-16), Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top})
infoTxt.Text = "Fishing info will appear here..."

-- Buttons removed:
-- fishBtn, invBtn, sellBtn, shopOpenBtn

-- ===== SETTINGS tab =====
local settingsFrame = contentFrames["Settings"]
local lbl = new("TextLabel", {Parent = settingsFrame, Size = UDim2.new(1, -16, 0, 30), Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1, Text = "Settings coming soon...", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), TextXAlignment = Enum.TextXAlignment.Left})

-- ===== ABOUT tab =====
local aboutFrame = contentFrames["About"]
local lbl2 = new("TextLabel", {Parent = aboutFrame, Size = UDim2.new(1,-16,0,60), Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1, Text = "Fish It Loader v1.0\nBy Hanzyy", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), TextXAlignment = Enum.TextXAlignment.Left})

-- ===== SUBMIT PASSWORD =====
submitBtn.MouseButton1Click:Connect(function()
    playClick()
    if input.Text == PASSWORD then
        passFrame.Visible = false
        loaderBtn.Visible = true
        blur.Size = 6
        toast("Access granted!", Color3.fromRGB(50,220,50))
    else
        errorLabel.Text = "Incorrect password!"
        toast("Wrong password!", Color3.fromRGB(220,80,80))
    end
end)

-- ===== OPEN MENU =====
loaderBtn.MouseButton1Click:Connect(function()
    playClick()
    mainFrame.Visible = not mainFrame.Visible
end)
