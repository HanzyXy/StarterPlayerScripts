-- AutoFishClient.lua
-- Letakkan sebagai LocalScript di StarterPlayerScripts
-- Membuat GUI draggable mini-button + panel, theme, keybind, auto-fire loop, popup notification, save settings

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local RequestFish = ReplicatedStorage:WaitForChild("RequestFish")
local FishResult = ReplicatedStorage:WaitForChild("FishResult")
local SaveSettingsEvent = ReplicatedStorage:WaitForChild("SaveSettings")

-- Config UI & behavior
local AUTO_FIRE_INTERVAL = 0.22 -- client send rate (server enforce cooldown)
local SOUND_ASSET_ID = 12222030 -- placeholder (ganti dengan id sound yang diinginkan)
local TOGGLE_KEY = Enum.KeyCode.F

-- State
local autoOn = false
local currentTheme = "dark"
local autoCoroutine = nil

-- Helper create
local function new(instanceType, props)
    local inst = Instance.new(instanceType)
    if props then
        for k,v in pairs(props) do
            inst[k] = v
        end
    end
    return inst
end

-- create ScreenGui
local screenGui = new("ScreenGui", {Name = "AutoFishGUI", ResetOnSpawn = false})
screenGui.Parent = playerGui

-- Styles by theme
local themes = {
    dark = {
        bg = Color3.fromRGB(18,18,20),
        panel = Color3.fromRGB(28,28,30),
        accent = Color3.fromRGB(24,160,100),
        text = Color3.fromRGB(230,230,230),
        sub = Color3.fromRGB(190,190,190)
    },
    light = {
        bg = Color3.fromRGB(240,240,245),
        panel = Color3.fromRGB(255,255,255),
        accent = Color3.fromRGB(24,160,100),
        text = Color3.fromRGB(30,30,30),
        sub = Color3.fromRGB(80,80,80)
    }
}

-- Mini button
local btn = new("Frame", {
    Name = "MiniButton", Size = UDim2.new(0,52,0,52),
    Position = UDim2.new(0.02,0,0.4,0),
    BackgroundColor3 = themes.dark.panel,
    AnchorPoint = Vector2.new(0,0),
    BorderSizePixel = 0,
})
btn.Parent = screenGui
local corner = new("UICorner", {CornerRadius = UDim.new(0,8), Parent = btn})
local stroke = new("UIStroke", {Parent = btn, Thickness = 1, Transparency = 0.7})

local iconBtn = new("TextButton", {
    Parent = btn, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
    Text = "🎣", Font = Enum.Font.GothamBold, TextSize = 26, TextColor3 = themes.dark.text
})

-- Panel (hidden)
local panel = new("Frame", {
    Name = "MainPanel", Size = UDim2.new(0,380,0,260),
    Position = UDim2.new(0.02,0,0.4,0),
    BackgroundColor3 = themes.dark.bg, Visible = false, BorderSizePixel = 0
})
panel.Parent = screenGui
new("UICorner",{Parent=panel, CornerRadius=UDim.new(0,10)})
new("UIStroke",{Parent=panel, Thickness=1, Transparency=0.8})

-- Header
local header = new("TextLabel",{Parent=panel, Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1,
    Text = "Fish It — Control", Font = Enum.Font.GothamBold, TextSize = 20, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextColor3 = themes.dark.text})
header.Position = UDim2.new(0,16,0,10)

local closeBtn = new("TextButton",{Parent=panel, Size = UDim2.new(0,36,0,36), Position = UDim2.new(1,-44,0,8), BackgroundTransparency = 1, Text = "✕", Font = Enum.Font.Gotham, TextSize = 18, TextColor3 = themes.dark.sub})

-- Info frame
local infoFrame = new("Frame",{Parent=panel, Size=UDim2.new(1,-32,0,120), Position=UDim2.new(0,16,0,66), BackgroundTransparency=1})
local uiList = new("UIListLayout",{Parent=infoFrame, Padding = UDim.new(0,6), VerticalAlignment = Enum.VerticalAlignment.Top})

local idLabel = new("TextLabel",{Parent=infoFrame, Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="UserId: -", Font=Enum.Font.Gotham, TextSize=14, TextColor3=themes.dark.text, TextXAlignment=Enum.TextXAlignment.Left})
local nameLabel = new("TextLabel",{Parent=infoFrame, Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="Name: -", Font=Enum.Font.Gotham, TextSize=14, TextColor3=themes.dark.text, TextXAlignment=Enum.TextXAlignment.Left})
local fpsLabel = new("TextLabel",{Parent=infoFrame, Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="FPS: -", Font=Enum.Font.Gotham, TextSize=14, TextColor3=themes.dark.text, TextXAlignment=Enum.TextXAlignment.Left})
local serverLabel = new("TextLabel",{Parent=infoFrame, Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="Members: -", Font=Enum.Font.Gotham, TextSize=14, TextColor3=themes.dark.text, TextXAlignment=Enum.TextXAlignment.Left})

-- Controls: Auto Toggle, Theme select, ID display
local controls = new("Frame",{Parent=panel, Size=UDim2.new(1,-32,0,56), Position=UDim2.new(0,16,1,-84), BackgroundTransparency=1})
local autoLabel = new("TextLabel",{Parent=controls, Size=UDim2.new(0.5,0,1,0), BackgroundTransparency=1, Text="Auto-Fish", Font=Enum.Font.Gotham, TextSize=16, TextColor3=themes.dark.text, TextXAlignment=Enum.TextXAlignment.Left})
local autoToggle = new("TextButton",{Parent=controls, Size=UDim2.new(0.18,0,0.7,0), Position=UDim2.new(0.5,12,0.15,0), Text="OFF", Font=Enum.Font.GothamBold, TextSize=14, BackgroundColor3=themes.dark.panel, BorderSizePixel=0})
new("UICorner",{Parent=autoToggle, CornerRadius=UDim.new(0,6)})
local themeBtn = new("TextButton",{Parent=controls, Size=UDim2.new(0.18,0,0.7,0), Position=UDim2.new(0.7,12,0.15,0), Text="Theme", Font=Enum.Font.Gotham, TextSize=14, BackgroundColor3=themes.dark.panel, BorderSizePixel=0})
new("UICorner",{Parent=themeBtn, CornerRadius=UDim.new(0,6)})

-- small status text
local statusLabel = new("TextLabel",{Parent=panel, Size=UDim2.new(1,-32,0,20), Position=UDim2.new(0,16,1,-40), BackgroundTransparency=1, Text="Status: Idle", Font=Enum.Font.Gotham, TextSize=14, TextColor3=themes.dark.sub, TextXAlignment=Enum.TextXAlignment.Left})

-- Popup container (for reward floating)
local popupContainer = new("Folder", {Name="PopupContainer", Parent = screenGui})

-- sound (played client-side)
local sound = new("Sound", {Name = "RewardSound", Parent = player:WaitForChild("PlayerGui"), SoundId = "rbxassetid://"..tostring(SOUND_ASSET_ID), Volume = 0.8})

-- utilities
local function applyTheme(themeName)
    currentTheme = themeName
    local t = themes[themeName]
    -- apply colors
    btn.BackgroundColor3 = t.panel
    iconBtn.TextColor3 = t.text
    panel.BackgroundColor3 = t.bg
    header.TextColor3 = t.text
    idLabel.TextColor3 = t.text
    nameLabel.TextColor3 = t.text
    fpsLabel.TextColor3 = t.text
    serverLabel.TextColor3 = t.text
    autoLabel.TextColor3 = t.text
    statusLabel.TextColor3 = t.sub
    autoToggle.BackgroundColor3 = t.panel
    themeBtn.BackgroundColor3 = t.panel
    autoToggle.TextColor3 = t.text
    themeBtn.TextColor3 = t.text
end

-- draggable mini button
do
    local dragging, dragStart, startPos, dragInput
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    btn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- open panel
local opening = false
iconBtn.MouseButton1Click:Connect(function()
    if opening then return end
    opening = true
    panel.Position = btn.Position
    panel.Visible = true
    btn.Visible = false
    panel.Size = UDim2.new(0,52,0,52)
    TweenService:Create(panel, TweenInfo.new(0.24, Enum.EasingStyle.Quad), {Size = UDim2.new(0,380,0,260)}):Play()
    wait(0.26)
    opening = false
end)
closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    btn.Visible = true
end)

-- panel drag via header
do
    local dragging, dragStart, startPos, dragInput
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = panel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- FPS display
do
    local samples = {}
    RunService.RenderStepped:Connect(function(dt)
        local fps = 1/dt
        table.insert(samples, fps)
        if #samples > 10 then table.remove(samples, 1) end
        local sum = 0
        for _,v in ipairs(samples) do sum = sum + v end
        local avg = math.floor(sum / #samples + 0.5)
        fpsLabel.Text = "FPS: "..tostring(avg)
    end)
end

-- update player info & server member count
local function updateUser()
    idLabel.Text = "UserId: "..tostring(player.UserId)
    nameLabel.Text = "Name: "..player.Name
end
updateUser()
spawn(function()
    while true do
        serverLabel.Text = "Members: "..tostring(#Players:GetPlayers())
        wait(2)
    end
end)

-- popup notification when reward datang
local function showRewardPopup(amount, total)
    local root = new("Frame",{Parent = screenGui, Size=UDim2.new(0,220,0,52), Position = UDim2.new(0.5,-110,0.2,0), BackgroundTransparency = 1})
    local bg = new("Frame",{Parent=root, Size=UDim2.new(1,0,1,0), BackgroundColor3 = themes[currentTheme].panel, BorderSizePixel=0})
    new("UICorner",{Parent=bg, CornerRadius=UDim.new(0,8)})
    local lbl = new("TextLabel",{Parent=bg, Size=UDim2.new(1,-16,1,-8), Position=UDim2.new(0,8,0,4), BackgroundTransparency=1,
        Text = "You fished +"..tostring(amount).."  •  Total: "..tostring(total), Font=Enum.Font.GothamBold, TextSize=16, TextColor3=themes[currentTheme].text})
    -- tween in/out
    bg.Position = UDim2.new(0,0,0,-60)
    TweenService:Create(bg, TweenInfo.new(0.28, Enum.EasingStyle.Back), {Position=UDim2.new(0,0,0,4)}):Play()
    if sound and sound.PlayOnRemove == false then
        pcall(function() sound:Play() end)
    end
    delay(2.2, function()
        TweenService:Create(bg, TweenInfo.new(0.22), {Position=UDim2.new(0,0,0,-60)}):Play()
        wait(0.26)
        root:Destroy()
    end)
end

-- handle FishResult events from server
FishResult.OnClientEvent:Connect(function(data)
    if not data then return end
    -- if it's loadSettings
    if data.loadSettings then
        local s = data.settings or {autoOn=false, theme="dark"}
        autoOn = s.autoOn and true or false
        applyTheme(s.theme == "light" and "light" or "dark")
        -- update toggle UI
        if autoOn then
            autoToggle.Text = "ON"
            autoToggle.BackgroundColor3 = themes[currentTheme].accent
            statusLabel.Text = "Status: Auto-Fishing (running)"
            -- start auto if loaded true
            -- startAuto() will be called below
        else
            autoToggle.Text = "OFF"
            autoToggle.BackgroundColor3 = themes[currentTheme].panel
            statusLabel.Text = "Status: Idle"
        end
        return
    end

    -- normal reward payload
    local amount = data.amount or 0
    local total = data.total or 0
    showRewardPopup(amount, total)
end)

-- persist settings to server
local function saveSettings()
    local s = {autoOn = autoOn, theme = currentTheme}
    pcall(function() SaveSettingsEvent:FireServer(s) end)
end

-- auto loop
local function startAuto()
    if autoOn and autoCoroutine then return end
    autoOn = true
    autoToggle.Text = "ON"
    autoToggle.BackgroundColor3 = themes[currentTheme].accent
    statusLabel.Text = "Status: Auto-Fishing (running)"
    saveSettings()
    autoCoroutine = coroutine.create(function()
        while autoOn do
            pcall(function() RequestFish:FireServer() end)
            wait(AUTO_FIRE_INTERVAL)
        end
    end)
    coroutine.resume(autoCoroutine)
end

local function stopAuto()
    autoOn = false
    autoToggle.Text = "OFF"
    autoToggle.BackgroundColor3 = themes[currentTheme].panel
    statusLabel.Text = "Status: Idle"
    saveSettings()
end

-- toggle via UI
autoToggle.MouseButton1Click:Connect(function()
    if autoOn then stopAuto() else startAuto() end
end)

-- theme button cycle
themeBtn.MouseButton1Click:Connect(function()
    if currentTheme == "dark" then
        applyTheme("light")
    else
        applyTheme("dark")
    end
    saveSettings()
end)

-- keybind toggle (ContextActionService)
local function handleToggleAction(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        if autoOn then stopAuto() else startAuto() end
    end
    return Enum.ContextActionResult.Sink
end
ContextActionService:BindAction("ToggleAutoFish", handleToggleAction, false, TOGGLE_KEY)

-- quick open panel by right-click on mini button
iconBtn.MouseButton2Click:Connect(function()
    panel.Visible = true
    btn.Visible = false
end)

-- when respawn etc, ensure UI reflect autoOn loaded
-- Request settings persistence from server by waiting for FishResult loadSettings earlier

-- Graceful cleanup when leaving
player:GetPropertyChangedSignal("Character"):Connect(function()
    -- do not stop auto on death; but you may want to
end)

-- initial theme default
applyTheme("dark")
-- show coins in status if exist (poll)
spawn(function()
    while true do
        local leader = player:FindFirstChild("leaderstats")
        if leader and leader:FindFirstChild("Coins") then
            statusLabel.Text = "Coins: "..tostring(leader.Coins.Value)
        end
        wait(3)
    end
end)

-- small accessibility: if loaded autoOn true (set by server load), start auto
-- handled when server sends loadSettings: that sets autoOn; but start loop if autoOn true
-- defensively start if autoOn true
delay(1.1, function()
    if autoOn then
        startAuto()
    end
end)
