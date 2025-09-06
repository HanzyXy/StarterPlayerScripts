-- FINAL Fish It Loader (All-in-one)
-- Place as LocalScript in StarterPlayerScripts
-- Features:
--  • Small draggable circular loader button
--  • Click opens modern modal UI with Tabs
--  • Server Info (UserId, Name, FPS, PlayerCount)
--  • Auto-Fish toggle (client sends requests; adapt server-side RemoteEvent)
--  • Buttons 1/2/3 for custom actions
--  • Settings: Anti-Lag (low graphics), Rejoin, Server Hop (stub), Min Players
--  • Smooth animations, hover effects, click sound

-- ===== Services =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ===== Config =====
local UI_WIDTH, UI_HEIGHT = 480, 360
local CLICK_SOUND_ID = "rbxassetid://12221967" -- click sound
local AUTO_FISH_CLIENT_INTERVAL = 4 -- seconds between cast/reel requests (client-side)
local CAST_EVENT_NAME = "RemoteEvent" -- TODO: change if your game uses different RemoteEvent for Cast/Reel
local MIN_PLAYERS_TO_JOIN = 2

-- ===== Helper functions =====
local function new(class, props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if type(k) == "number" then
                -- ignore numeric keys
            else
                obj[k] = v
            end
        end
    end
    return obj
end

local function tweenProperty(instance, props, time, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    TweenService:Create(instance, TweenInfo.new(time, style, dir), props):Play()
end

-- ===== Root GUI =====
local screenGui = new("ScreenGui", {Name = "FishItLoaderUI", Parent = game.CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})

-- optional blur (only visually on client)
local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 0

-- ===== Click sound =====
local clickSound = new("Sound", {Parent = SoundService, SoundId = CLICK_SOUND_ID, Volume = 0.6})

local function playClick()
    pcall(function() clickSound:Play() end)
end

-- ===== Small circular loader button (draggable) =====
local loaderBtn = new("TextButton", {
    Name = "LoaderBtn",
    Parent = screenGui,
    Size = UDim2.new(0, 52, 0, 52),
    Position = UDim2.new(0, 28, 0.4, 0),
    BackgroundColor3 = Color3.fromRGB(37,37,38),
    Text = "≡",
    Font = Enum.Font.GothamBold,
    TextSize = 26,
    TextColor3 = Color3.fromRGB(240,240,240),
    BorderSizePixel = 0,
    AutoButtonColor = false,
})
local loaderCorner = new("UICorner", {Parent = loaderBtn, CornerRadius = UDim.new(1,0)})
local loaderStroke = new("UIStroke", {Parent = loaderBtn, Thickness = 1, Transparency = 0.85})

-- Drag logic (touch + mouse)
do
    local dragging = false
    local dragInput, dragStart, startPos
    loaderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = loaderBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    loaderBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragInput and input == dragInput and dragging then
            local delta = input.Position - dragStart
            loaderBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Hover effect for loader
loaderBtn.MouseEnter:Connect(function()
    tweenProperty(loaderBtn, {BackgroundColor3 = Color3.fromRGB(55,55,56)}, 0.12)
end)
loaderBtn.MouseLeave:Connect(function()
    tweenProperty(loaderBtn, {BackgroundColor3 = Color3.fromRGB(37,37,38)}, 0.12)
end)

-- ===== Main modal UI (hidden by default) =====
local mainFrame = new("Frame", {
    Name = "MainFrame",
    Parent = screenGui,
    Size = UDim2.new(0, 0, 0, 0), -- start closed
    Position = UDim2.new(0.5, -UI_WIDTH/2, 0.5, -UI_HEIGHT/2),
    BackgroundColor3 = Color3.fromRGB(25,25,27),
    BorderSizePixel = 0,
})
local mainCorner = new("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0,12)})
local mainStroke = new("UIStroke", {Parent = mainFrame, Thickness = 1, Transparency = 0.85})

-- Top bar (tabs)
local topBar = new("Frame", {Parent = mainFrame, Size = UDim2.new(1,0,0,48), BackgroundColor3 = Color3.fromRGB(30,30,31)})
new("UICorner", {Parent = topBar, CornerRadius = UDim.new(0,12)})

local titleLabel = new("TextLabel", {
    Parent = topBar,
    Size = UDim2.new(0.6, 0, 1, 0),
    Position = UDim2.new(0, 16, 0, 0),
    BackgroundTransparency = 1,
    Text = "Fish It Script - Loader",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(235,235,235),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Tabs setup
local tabNames = {"Buy Rod & Bait", "Settings", "WebhookTab", "About"}
local tabs = {}
local contentFrames = {}

for i, name in ipairs(tabNames) do
    local btn = new("TextButton", {
        Parent = topBar,
        Size = UDim2.new(0, 110, 1, -8),
        Position = UDim2.new(0, (i-1)*115 + 8, 0, 6),
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(190,190,190),
    })
    tabs[name] = btn

    local content = new("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -28, 1, -78),
        Position = UDim2.new(0, 14, 0, 64),
        BackgroundTransparency = 1,
        Visible = (i == 1),
    })
    contentFrames[name] = content
end

-- Tab switching with fade animation
local function openTab(name)
    for k,v in pairs(contentFrames) do
        if k == name then
            v.Visible = true
            v.BackgroundTransparency = 1
            tweenProperty(v, {BackgroundTransparency = 0}, 0.25)
        else
            v.Visible = false
        end
    end
    -- highlight selected tab text color
    for k,btn in pairs(tabs) do
        if k == name then
            tweenProperty(btn, {TextColor3 = Color3.fromRGB(235,235,235)}, 0.15)
        else
            tweenProperty(btn, {TextColor3 = Color3.fromRGB(170,170,170)}, 0.15)
        end
    end
end

for name, btn in pairs(tabs) do
    btn.MouseButton1Click:Connect(function()
        playClick()
        openTab(name)
    end)
    btn.MouseEnter:Connect(function() tweenProperty(btn, {TextColor3 = Color3.fromRGB(220,220,220)}, 0.12) end)
    btn.MouseLeave:Connect(function() tweenProperty(btn, {TextColor3 = Color3.fromRGB(170,170,170)}, 0.12) end)
end

-- ===== Content: Settings tab (server info + buttons) =====
local settingsFrame = contentFrames["Settings"]

local infoBox = new("Frame", {
    Parent = settingsFrame,
    Size = UDim2.new(1, 0, 0, 86),
    Position = UDim2.new(0,0,0,0),
    BackgroundColor3 = Color3.fromRGB(34,34,36),
})
new("UICorner", {Parent = infoBox, CornerRadius = UDim.new(0,8)})
local infoText = new("TextLabel", {
    Parent = infoBox,
    Size = UDim2.new(1, -16, 1, -16),
    Position = UDim2.new(0, 8, 0, 8),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(220,220,220),
    TextXAlignment = Enum.TextXAlignment.Left,
})
infoText.Text = "Server Info\nPlayers: ...\nPlaceId: ..."

-- update real-time (FPS, players, name/id)
spawn(function()
    local lastTick = tick()
    local frameCount = 0
    while true do
        frameCount = frameCount + 1
        if tick() - lastTick >= 1 then
            local fps = math.floor(frameCount / (tick() - lastTick) + 0.5)
            local playerCount = #Players:GetPlayers()
            infoText.Text = "Server Info\nPlayers in server: " .. tostring(playerCount)
                .. "\nPlaceId: " .. tostring(game.PlaceId)
                .. "\n\nUser: " .. tostring(LocalPlayer.Name) .. "  (ID: " .. tostring(LocalPlayer.UserId) .. ")"
                .. "\nFPS: " .. tostring(fps)
            frameCount = 0
            lastTick = tick()
        end
        RunService.RenderStepped:Wait()
    end
end)

-- Button factory (styled)
local function styledButton(parent, y, text)
    local btn = new("TextButton", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 38),
        Position = UDim2.new(0, 0, 0, y),
        BackgroundColor3 = Color3.fromRGB(36,36,38),
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(220,220,220),
    })
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,8)})
    btn.MouseEnter:Connect(function() tweenProperty(btn, {BackgroundColor3 = Color3.fromRGB(55,55,57)}, 0.12) end)
    btn.MouseLeave:Connect(function() tweenProperty(btn, {BackgroundColor3 = Color3.fromRGB(36,36,38)}, 0.12) end)
    return btn
end

-- place buttons in settingsFrame below infoBox
local ybase = 96
local antiLagBtn = styledButton(settingsFrame, ybase, "Anti Lag / Low Texture")
local rejoinBtn = styledButton(settingsFrame, ybase + 46, "Rejoin Server")
local minPlayersBtn = styledButton(settingsFrame, ybase + 92, "Minimum Players to Join: " .. tostring(MIN_PLAYERS_TO_JOIN))
local serverHopBtn = styledButton(settingsFrame, ybase + 138, "Server Hop (Join Random Server)")

antiLagBtn.MouseButton1Click:Connect(function()
    playClick()
    -- Low texture / anti-lag: set graphics to low if possible
    pcall(function()
        -- try change rendering quality (may be client-limited)
        for i = 1, 10 do
            pcall(function() settings().Rendering.QualityLevel = 1 end)
        end
        -- fallback: reduce terrain detail / effects if you implemented toggles in-game
    end)
    antiLagBtn.Text = "Anti Lag / Low Texture (Applied)"
    wait(1.5)
    antiLagBtn.Text = "Anti Lag / Low Texture"
end)

rejoinBtn.MouseButton1Click:Connect(function()
    playClick()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

minPlayersBtn.MouseButton1Click:Connect(function()
    playClick()
    -- cycle minimum players value (example)
    MIN_PLAYERS_TO_JOIN = (MIN_PLAYERS_TO_JOIN % 10) + 1
    minPlayersBtn.Text = "Minimum Players to Join: " .. tostring(MIN_PLAYERS_TO_JOIN)
end)

serverHopBtn.MouseButton1Click:Connect(function()
    playClick()
    -- Server hop is game-specific. This is a stub placeholder.
    serverHopBtn.Text = "Server Hop (Not Implemented)"
    wait(1.2)
    serverHopBtn.Text = "Server Hop (Join Random Server)"
end)

-- ===== Content: Buy Rod & Bait tab (Auto Fish + Buttons 1/2/3) =====
local buyFrame = contentFrames["Buy Rod & Bait"]

-- Auto Fish Toggle (client-side loop; ensure server validates)
local autoFish = false
local autoBtn = styledButton(buyFrame, 8, "🎣 Auto Fish: OFF")
autoBtn.MouseButton1Click:Connect(function()
    playClick()
    autoFish = not autoFish
    autoBtn.Text = "🎣 Auto Fish: " .. (autoFish and "ON" or "OFF")
    if autoFish then
        spawn(function()
            while autoFish do
                -- Attempt to call server remote event to Cast/Reel
                pcall(function()
                    local rs = ReplicatedStorage
                    if rs:FindFirstChild(CAST_EVENT_NAME) then
                        -- This pattern expects server RemoteEvent to accept action strings:
                        -- "Cast" and "Reel". Adjust to your game's API.
                        rs[CAST_EVENT_NAME]:FireServer("Cast")
                        wait(math.max(1, AUTO_FISH_CLIENT_INTERVAL))
                        rs[CAST_EVENT_NAME]:FireServer("Reel")
                    else
                        -- If event not found, just print for debug
                        warn("RemoteEvent '"..CAST_EVENT_NAME.."' not found in ReplicatedStorage.")
                    end
                end)
                wait(AUTO_FISH_CLIENT_INTERVAL)
            end
        end)
    end
end)

-- Buttons 1 / 2 / 3
local btn1 = styledButton(buyFrame, 62, "🔘 Button 1")
local btn2 = styledButton(buyFrame, 110, "🔘 Button 2")
local btn3 = styledButton(buyFrame, 158, "🔘 Button 3")

btn1.MouseButton1Click:Connect(function() playClick(); print("Button 1 action") end)
btn2.MouseButton1Click:Connect(function() playClick(); print("Button 2 action") end)
btn3.MouseButton1Click:Connect(function() playClick(); print("Button 3 action") end)

-- ===== Content: Webhook Tab (simple placeholder) =====
local webFrame = contentFrames["WebhookTab"]
local wLabel = new("TextLabel", {
    Parent = webFrame,
    Size = UDim2.new(1,0,0,36),
    Position = UDim2.new(0,0,0,8),
    BackgroundTransparency = 1,
    Text = "Webhook settings & URL (placeholder)",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(210,210,210),
})

-- ===== Content: About Tab =====
local aboutFrame = contentFrames["About"]
local aboutLabel = new("TextLabel", {
    Parent = aboutFrame,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Text = "Fish It Script Loader\nMade by Hanzyy\nUI: modern dark theme\nUse responsibly in your own place.",
    Font = Enum.Font.Gotham,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(220,220,220),
    TextWrapped = true,
    TextYAlignment = Enum.TextYAlignment.Top
})

-- ===== Open/Close UI via loader button (animated) =====
local uiOpen = false
loaderBtn.MouseButton1Click:Connect(function()
    playClick()
    uiOpen = not uiOpen
    if uiOpen then
        -- open: tween size & show blur
        mainFrame.Visible = true
        tweenProperty(mainFrame, {Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)}, 0.28)
        tweenProperty(blur, {Size = 8}, 0.28)
    else
        -- close
        tweenProperty(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.22)
        tweenProperty(blur, {Size = 0}, 0.22)
        delay(0.25, function() mainFrame.Visible = false end)
    end
end)

-- Close UI if player hits ESC (optional)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Escape and uiOpen then
        playClick()
        uiOpen = false
        tweenProperty(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.22)
        tweenProperty(blur, {Size = 0}, 0.22)
        delay(0.25, function() mainFrame.Visible = false end)
    end
end)

-- ===== Initial setup: open first tab =====
openTab(tabNames[1])

-- ===== Clean up on leave =====
Players.PlayerRemoving:Connect(function(p)
    if p == LocalPlayer then
        pcall(function() blur:Destroy() end)
    end
end)

-- End of script
