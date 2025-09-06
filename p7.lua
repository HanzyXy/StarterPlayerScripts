-- FINAL: Secure FishIt Loader (Password + Loader + Dashboard)
-- Place as LocalScript in StarterPlayerScripts
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
local CLICK_SOUND_ID = "rbxassetid://12221967" -- change if you want other sound
local UI_WIDTH, UI_HEIGHT = 460, 360
local AUTO_FISH_CLIENT_INTERVAL = 4 -- seconds between Cast/Reel attempts
local CAST_EVENT_NAME = "RemoteEvent" -- <-- change to your game's RemoteEvent name

-- ===== helper =====
local function new(class, props)
    local o = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            o[k] = v
        end
    end
    return o
end
local function tween(inst, props, t, style, dir) 
    style = style or Enum.EasingStyle.Quad; dir = dir or Enum.EasingDirection.Out
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

-- ===== root GUI =====
local screenGui = new("ScreenGui", {Name = "FishIt_SecureLoader", Parent = game.CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})

-- click sound
local clickSound = new("Sound", {Parent = SoundService, SoundId = CLICK_SOUND_ID, Volume = 0.6})
local function playClick() pcall(function() clickSound:Play() end) end

-- optional blur (client only)
local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
blur.Size = 0

-- ===== PASSWORD SCREEN =====
local passFrame = new("Frame", {
    Parent = screenGui,
    Name = "PasswordWindow",
    Size = UDim2.new(0, 360, 0, 200),
    Position = UDim2.new(0.5, -180, 0.5, -100),
    BackgroundColor3 = Color3.fromRGB(25,25,26),
    Active = true,
    Draggable = true,
})
new("UICorner", {Parent = passFrame, CornerRadius = UDim.new(0,12)})
local title = new("TextLabel", {
    Parent = passFrame, Size = UDim2.new(1, -24, 0, 44), Position = UDim2.new(0,12,0,8),
    BackgroundTransparency = 1, Text = "🔒 Secure Access", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.fromRGB(245,245,245), TextXAlignment = Enum.TextXAlignment.Left
})
local desc = new("TextLabel", {
    Parent = passFrame, Size = UDim2.new(1, -24, 0, 32), Position = UDim2.new(0,12,0,48),
    BackgroundTransparency = 1, Text = "Enter password to unlock the loader.", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(200,200,200), TextXAlignment = Enum.TextXAlignment.Left
})
local input = new("TextBox", {
    Parent = passFrame, Size = UDim2.new(0.86, 0, 0, 40), Position = UDim2.new(0.07, 0, 0, 94),
    BackgroundColor3 = Color3.fromRGB(36,36,38), Text = "", PlaceholderText = "Password", Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(240,240,240), ClearTextOnFocus = false
})
new("UICorner", {Parent = input, CornerRadius = UDim.new(0,8)})
local submitBtn = new("TextButton", {
    Parent = passFrame, Size = UDim2.new(0.5, 0, 0, 36), Position = UDim2.new(0.25, 0, 0, 146),
    BackgroundColor3 = Color3.fromRGB(6,135,255), Font = Enum.Font.GothamBold, Text = "Unlock", TextSize = 16, TextColor3 = Color3.fromRGB(255,255,255)
})
new("UICorner", {Parent = submitBtn, CornerRadius = UDim.new(0,8)})
local errorLabel = new("TextLabel", {
    Parent = passFrame, Size = UDim2.new(1, -24, 0, 22), Position = UDim2.new(0,12,1,-26),
    BackgroundTransparency = 1, Text = "", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(255,120,120)
})

-- Press Enter to submit
input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        submitBtn:CaptureFocus(); submitBtn:ReleaseFocus()
        submitBtn:MouseButton1Click()
    end
end)

-- ===== HIDDEN LOADER BUTTON (appears only after correct password) =====
local loaderBtn = new("TextButton", {
    Parent = screenGui, Name = "LoaderBtn", Size = UDim2.new(0, 56, 0, 56),
    Position = UDim2.new(0.05, 0, 0.34, 0),
    BackgroundColor3 = Color3.fromRGB(13,100,240),
    Text = "≡", Font = Enum.Font.GothamBold, TextSize = 26, TextColor3 = Color3.fromRGB(255,255,255),
    Visible = false, AutoButtonColor = false
})
new("UICorner", {Parent = loaderBtn, CornerRadius = UDim.new(1,0)})
new("UIStroke", {Parent = loaderBtn, Thickness = 1, Transparency = 0.8})

-- draggable logic for loaderBtn
do
    local dragging, dragInput, dragStart, startPos
    loaderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = loaderBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
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

-- ===== MAIN MENU (hidden initially) =====
local mainFrame = new("Frame", {
    Parent = screenGui, Name = "MainMenu", Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, -UI_WIDTH/2, 0.5, -UI_HEIGHT/2),
    BackgroundColor3 = Color3.fromRGB(20,20,21), Visible = false
})
new("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0,12)})
new("UIStroke", {Parent = mainFrame, Thickness = 1, Transparency = 0.85})

-- Title + Close
local title = new("TextLabel",{Parent = mainFrame, Size = UDim2.new(1, -20, 0, 44), Position = UDim2.new(0,10,0,8), BackgroundTransparency = 1, Text = "⚡ Fish It Loader", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.fromRGB(245,245,245), TextXAlignment = Enum.TextXAlignment.Left})
local closeBtn = new("TextButton",{Parent = mainFrame, Size = UDim2.new(0,34,0,34), Position = UDim2.new(1, -44, 0, 8), BackgroundColor3 = Color3.fromRGB(200,60,60), Text = "X", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(255,255,255)})
new("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(1,0)})

-- Panel Info (top)
local infoPanel = new("Frame", {Parent = mainFrame, Size = UDim2.new(1, -24, 0, 98), Position = UDim2.new(0,12,0,60), BackgroundColor3 = Color3.fromRGB(30,30,31)})
new("UICorner", {Parent = infoPanel, CornerRadius = UDim.new(0,8)})
local infoText = new("TextLabel", {Parent = infoPanel, Size = UDim2.new(1, -16, 1, -16), Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top})
infoText.Text = "Loading info..."

-- AutoFish button
local autoBtn = new("TextButton", {
    Parent = mainFrame, Size = UDim2.new(0.6, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0, 180),
    BackgroundColor3 = Color3.fromRGB(36,36,38),
    Text = "🎣 Auto Fish: OFF",
    Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = Color3.fromRGB(240,240,240)
})
new("UICorner", {Parent = autoBtn, CornerRadius = UDim.new(0,8)})
autoBtn.MouseEnter:Connect(function() tween(autoBtn, {BackgroundColor3 = Color3.fromRGB(60,60,62)}, 0.12) end)
autoBtn.MouseLeave:Connect(function() tween(autoBtn, {BackgroundColor3 = Color3.fromRGB(36,36,38)}, 0.12) end)

-- Buttons 1/2/3
local smallBtns = {}
for i = 1, 3 do
    local b = new("TextButton", {
        Parent = mainFrame,
        Size = UDim2.new(0.22, 0, 0, 34),
        Position = UDim2.new(0.05 + (i-1)*0.32, 0, 0, 240),
        BackgroundColor3 = Color3.fromRGB(36,36,38),
        Text = "Button "..i,
        Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(235,235,235)
    })
    new("UICorner", {Parent = b, CornerRadius = UDim.new(0,8)})
    b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = Color3.fromRGB(60,60,62)}, 0.12) end)
    b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = Color3.fromRGB(36,36,38)}, 0.12) end)
    smallBtns[i] = b
end

-- ===== Behavior & realtime info =====
-- FPS & player info update
do
    local last = tick()
    local frames = 0
    RunService.RenderStepped:Connect(function(dt)
        frames = frames + 1
        if tick() - last >= 1 then
            local fps = math.floor(frames / (tick() - last) + 0.5)
            local playersCount = #Players:GetPlayers()
            infoText.Text = ("👤 %s  (ID: %s)\n⚡ FPS: %d    👥 Players: %d"):format(tostring(LocalPlayer.Name), tostring(LocalPlayer.UserId), fps, playersCount)
            frames = 0
            last = tick()
        end
    end)
end

-- Auto-Fish logic (client-side loop; server must validate)
local autoFishing = false
autoBtn.MouseButton1Click:Connect(function()
    playClick()
    autoFishing = not autoFishing
    autoBtn.Text = "🎣 Auto Fish: " .. (autoFishing and "ON" or "OFF")
    autoBtn.TextColor3 = autoFishing and Color3.fromRGB(140,255,140) or Color3.fromRGB(255,180,180)
    if autoFishing then
        spawn(function()
            while autoFishing do
                -- send remote requests (Cast -> wait -> Reel)
                safeFireRemote("Cast")
                wait(math.max(1, AUTO_FISH_CLIENT_INTERVAL))
                safeFireRemote("Reel")
                wait(AUTO_FISH_CLIENT_INTERVAL)
            end
        end)
    end
end)

-- small buttons actions (placeholder)
smallBtns[1].MouseButton1Click:Connect(function() playClick(); print("Button 1 pressed") end)
smallBtns[2].MouseButton1Click:Connect(function() playClick(); print("Button 2 pressed") end)
smallBtns[3].MouseButton1Click:Connect(function() playClick(); print("Button 3 pressed") end)

-- Close behavior
closeBtn.MouseButton1Click:Connect(function()
    playClick()
    tween(mainFrame, {Size = UDim2.new(0,0,0,0)}, 0.2)
    tween(blur, {Size = 0}, 0.2)
    task.delay(0.22, function() mainFrame.Visible = false end)
end)

-- Open menu via loader
loaderBtn.MouseButton1Click:Connect(function()
    playClick()
    if not mainFrame.Visible then
        mainFrame.Visible = true
        tween(blur, {Size = 7}, 0.22)
        tween(mainFrame, {Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)}, 0.28)
    else
        -- close
        tween(mainFrame, {Size = UDim2.new(0,0,0,0)}, 0.2)
        tween(blur, {Size = 0}, 0.2)
        task.delay(0.22, function() mainFrame.Visible = false end)
    end
end)

-- ===== Password submit logic =====
local function showError(msg)
    errorLabel.Text = "❌ " .. tostring(msg)
    tween(errorLabel, {TextTransparency = 0}, 0.06)
    task.delay(1.6, function() tween(errorLabel, {TextTransparency = 1}, 0.24); errorLabel.Text = "" end)
end

submitBtn.MouseButton1Click:Connect(function()
    playClick()
    local v = tostring(input.Text or "")
    if v == PASSWORD then
        -- unlock: remove password UI & reveal loader button
        passFrame:Destroy()
        loaderBtn.Visible = true
        -- small appear tween
        loaderBtn.Size = UDim2.new(0, 1, 0, 1)
        tween(loaderBtn, {Size = UDim2.new(0,56,0,56)}, 0.18)
    else
        showError("Wrong password")
    end
end)

-- disable loader/menu until password entered
loaderBtn.Visible = false
mainFrame.Visible = false
mainFrame.Size = UDim2.new(0,0,0,0)

-- allow ESC to close menu (if open)
UserInputService.InputBegan:Connect(function(input, typing)
    if typing then return end
    if input.KeyCode == Enum.KeyCode.Escape and mainFrame.Visible then
        playClick()
        tween(mainFrame, {Size = UDim2.new(0,0,0,0)}, 0.18)
        tween(blur, {Size = 0}, 0.18)
        task.delay(0.2, function() mainFrame.Visible = false end)
    end
end)

-- Clean up on leave
Players.PlayerRemoving:Connect(function(p)
    if p == LocalPlayer then
        pcall(function() blur:Destroy() end)
    end
end)

-- End of script
