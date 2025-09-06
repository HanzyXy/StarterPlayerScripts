-- FINAL: Fish It Loader v2 (No Blur + Big Menu + Speed Feature)
-- Place in StarterPlayerScripts (LocalScript)
-- Password: YILZI-EXECUTOR

-- ===== Services & Config =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local PASSWORD = "YILZI-EXECUTOR"
local CLICK_SOUND_ID = "rbxassetid://12221967" -- click sound
local UI_W, UI_H = 800, 500 -- bigger menu

-- ===== Helpers =====
local function new(class, props)
    local obj = Instance.new(class)
    if props then for k,v in pairs(props) do obj[k] = v end
    return obj
end
local function tween(inst, props, t, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    TweenService:Create(inst, TweenInfo.new(t, style, dir), props):Play()
end
local function playClick()
    local s = new("Sound", {Parent = game:GetService("SoundService"), SoundId = CLICK_SOUND_ID, Volume = 0.6})
    s:Play()
    task.delay(1, function() pcall(function() s:Destroy() end) end)
end

-- ===== Root GUI =====
local screenGui = new("ScreenGui", {Name = "FishIt_FinalUI", Parent = game.CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})

-- toast notifications
local function toast(text, color)
    color = color or Color3.fromRGB(60,60,60)
    local toast = new("Frame", {Parent = screenGui, Size = UDim2.new(0, 320, 0, 40), Position = UDim2.new(0.5, -160, 0.12, 0), BackgroundColor3 = color})
    new("UICorner", {Parent = toast, CornerRadius = UDim.new(0, 8)})
    local label = new("TextLabel", {Parent = toast, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, Text = text, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255)})
    toast.AnchorPoint = Vector2.new(0.5, 0)
    tween(toast, {Position = UDim2.new(0.5, -160, 0.06, 0), BackgroundTransparency = 0}, 0.18)
    task.delay(2.2, function()
        tween(toast, {Position = UDim2.new(0.5, -160, 0.12, 0), BackgroundTransparency = 1}, 0.18)
        task.delay(0.18, function() pcall(function() toast:Destroy() end) end)
    end)
end

-- ===== PASSWORD SCREEN =====
local passFrame = new("Frame", {Parent = screenGui, Name = "PasswordWindow", Size = UDim2.new(0, 400, 0, 220), Position = UDim2.new(0.5, -200, 0.5, -110), BackgroundColor3 = Color3.fromRGB(20,20,21), Active = true, Draggable = true})
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

-- ===== LOADER BUTTON =====
local loaderBtn = new("TextButton", {Parent = screenGui, Name = "LoaderBtn", Size = UDim2.new(0, 64, 0, 64), Position = UDim2.new(0.06, 0, 0.35, 0), BackgroundColor3 = Color3.fromRGB(13,100,240), Text = "≡", Font = Enum.Font.GothamBold, TextSize = 30, TextColor3 = Color3.fromRGB(255,255,255), Visible = false, AutoButtonColor = false})
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

-- ===== MAIN MENU =====
local mainFrame = new("Frame", {Parent = screenGui, Name = "MainMenu", Size = UDim2.new(0,UI_W,0,UI_H), Position = UDim2.new(0.5, -UI_W/2, 0.5, -UI_H/2), BackgroundColor3 = Color3.fromRGB(18,18,19), Visible = false})
new("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0,12)})
new("UIStroke", {Parent = mainFrame, Thickness = 1, Transparency = 0.85})

-- Title + Close
local titleLbl = new("TextLabel", {Parent = mainFrame, Size = UDim2.new(1, -28, 0, 44), Position = UDim2.new(0,14,0,10), BackgroundTransparency = 1, Text = "⚡ Fish It Loader", Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = Color3.fromRGB(240,240,240), TextXAlignment = Enum.TextXAlignment.Left})
local closeBtn = new("TextButton", {Parent = mainFrame, Size = UDim2.new(0,40,0,40), Position = UDim2.new(1, -54, 0, 10), BackgroundColor3 = Color3.fromRGB(200,60,60), Text = "X", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.fromRGB(255,255,255)})
new("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0,8)})
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- Tabs
local tabBar = new("Frame", {Parent = mainFrame, Size = UDim2.new(1, -28, 0, 40), Position = UDim2.new(0,14,0,60), BackgroundTransparency = 1})
local tabButtons = {}
local tabNames = {"Play","Settings","About"}
local contentFrames = {}
for i,name in ipairs(tabNames) do
    local btn = new("TextButton", {Parent = tabBar, Size = UDim2.new(0, 120, 1, 0), Position = UDim2.new(0, (i-1)*130,0,0), BackgroundColor3 = Color3.fromRGB(28,28,30), Text = name, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(220,220,220)})
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,8)})
    tabButtons[name] = btn
    local frame = new("Frame", {Parent = mainFrame, Size = UDim2.new(1,-28,1,-110), Position = UDim2.new(0,14,0,110), BackgroundTransparency = 1, Visible = (i==1)})
    contentFrames[name] = frame
    btn.MouseButton1Click:Connect(function()
        playClick()
        for k,f in pairs(contentFrames) do f.Visible = false end
        frame.Visible = true
    end)
end

-- ===== PLAY Tab =====
local playFrame = contentFrames["Play"]
local speedLabel = new("TextLabel", {Parent = playFrame, Size = UDim2.new(0,200,0,30), Position = UDim2.new(0,10,0,10), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(220,220,220), Text = "WalkSpeed: 16"})
local speedInput = new("TextBox", {Parent = playFrame, Size = UDim2.new(0,100,0,30), Position = UDim2.new(0,220,0,10), BackgroundColor3 = Color3.fromRGB(30,30,31), Text = "16", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(255,255,255), ClearTextOnFocus = false})
new("UICorner", {Parent = speedInput, CornerRadius = UDim.new(0,6)})
speedInput.FocusLost:Connect(function(enter)
    if enter then
        local val = tonumber(speedInput.Text)
        if val and val>0 then
            Humanoid.WalkSpeed = val
            speedLabel.Text = "WalkSpeed: "..val
            toast("Speed set to "..val, Color3.fromRGB(50,200,50))
        else
            toast("Invalid speed!", Color3.fromRGB(220,80,80))
        end
    end
end)

-- ===== SETTINGS & ABOUT Tabs =====
local settingsFrame = contentFrames["Settings"]
local lbl = new("TextLabel", {Parent = settingsFrame, Size = UDim2.new(1, -16, 0, 30), Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1, Text = "Settings coming soon...", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), TextXAlignment = Enum.TextXAlignment.Left})

local aboutFrame = contentFrames["About"]
local lbl2 = new("TextLabel", {Parent = aboutFrame, Size = UDim2.new(1,-16,0,60), Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1, Text = "Fish It Loader v2.0\nBy Hanzyy", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), TextXAlignment = Enum.TextXAlignment.Left})

-- ===== SUBMIT PASSWORD =====
submitBtn.MouseButton1Click:Connect(function()
    playClick()
    if input.Text == PASSWORD then
        passFrame.Visible = false
        loaderBtn.Visible = true
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
