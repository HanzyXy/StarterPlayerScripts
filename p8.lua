-- FINAL: Fish It Loader (Password + Loader + Dashboard + Inventory + Shop + Sell + Tabs)
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
new("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(1,0)})

-- Tabs bar
local tabBar = new("Frame", {Parent = mainFrame, Size = UDim2.new(1, -28, 0, 38), Position = UDim2.new(0,14,0,60), BackgroundColor3 = Color3.fromRGB(26,26,27)})
new("UICorner", {Parent = tabBar, CornerRadius = UDim.new(0,8)})
local tabs = {"Play","Settings","Webhook","About","Shop"}
local tabBtns, contentFrames = {}, {}
for i,name in ipairs(tabs) do
    local btn = new("TextButton", {Parent = tabBar, Size = UDim2.new(0, 100, 1, -6), Position = UDim2.new(0, (i-1)*104 + 8, 0, 3), BackgroundTransparency = 1, Text = name, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(200,200,200)})
    tabBtns[name] = btn
    local content = new("Frame", {Parent = mainFrame, Size = UDim2.new(1, -28, 1, -120), Position = UDim2.new(0,14,0,110), BackgroundTransparency = 1, Visible = (name=="Play")})
    contentFrames[name] = content
end

local function switchTab(name)
    for k,v in pairs(contentFrames) do
        v.Visible = (k==name)
    end
    for k,btn in pairs(tabBtns) do
        tween(btn, {TextColor3 = (k==name) and Color3.fromRGB(245,245,245) or Color3.fromRGB(160,160,160)}, 0.12)
    end
end
for name,btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function() playClick(); switchTab(name) end)
    btn.MouseEnter:Connect(function() tween(btn, {TextColor3 = Color3.fromRGB(220,220,220)}, 0.12) end)
    btn.MouseLeave:Connect(function() tween(btn, {TextColor3 = Color3.fromRGB(160,160,160)}, 0.12) end)
end

-- ===== PLAY tab (UI + Buttons) =====
local playFrame = contentFrames["Play"]

local infoPanel = new("Frame", {Parent = playFrame, Size = UDim2.new(1,0,0,90), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(28,28,30)})
new("UICorner", {Parent = infoPanel, CornerRadius = UDim.new(0,8)})
local infoTxt = new("TextLabel", {Parent = infoPanel, Size = UDim2.new(1,-16,1,-16), Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top})
infoTxt.Text = "Loading..."

-- Play buttons: Fish, Inventory, Sell, Shop open
local fishBtn = new("TextButton", {Parent = playFrame, Size = UDim2.new(0,200,0,46), Position = UDim2.new(0.5, -100, 0, 110), BackgroundColor3 = Color3.fromRGB(36,36,38), Text = "🎣 Start Fishing", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.fromRGB(245,245,245)})
new("UICorner", {Parent = fishBtn, CornerRadius = UDim.new(0,8)})
local invBtn = new("TextButton", {Parent = playFrame, Size = UDim2.new(0,140,0,36), Position = UDim2.new(0.02,0,0,110), BackgroundColor3 = Color3.fromRGB(45,45,47), Text = "📦 Inventory", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(240,240,240)})
new("UICorner", {Parent = invBtn, CornerRadius = UDim.new(0,8)})
local sellBtn = new("TextButton", {Parent = playFrame, Size = UDim2.new(0,140,0,36), Position = UDim2.new(0.02,0,0,156), BackgroundColor3 = Color3.fromRGB(80,40,40), Text = "💰 Sell All", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(245,245,245)})
new("UICorner", {Parent = sellBtn, CornerRadius = UDim.new(0,8)})
local shopOpenBtn = new("TextButton", {Parent = playFrame, Size = UDim2.new(0,140,0,36), Position = UDim2.new(1,-150,0,110), BackgroundColor3 = Color3.fromRGB(36,36,38), Text = "🏪 Open Shop", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(245,245,245)})
new("UICorner", {Parent = shopOpenBtn, CornerRadius = UDim.new(0,8)})

-- gold label
local gold = 0
local goldLbl = new("TextLabel", {Parent = playFrame, Size = UDim2.new(0,220,0,36), Position = UDim2.new(1,-240,0,16), BackgroundTransparency = 1, Text = "💰 Gold: 0", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(255,215,0), TextXAlignment = Enum.TextXAlignment.Right})

-- Inventory UI
local inventory = {}
local invFrame = new("Frame", {Parent = screenGui, Size = UDim2.new(0, 400, 0, 260), Position = UDim2.new(0.5, -200, 0.5, -130), BackgroundColor3 = Color3.fromRGB(28,28,30), Visible = false})
new("UICorner", {Parent = invFrame, CornerRadius = UDim.new(0,10)})
local invTitle = new("TextLabel", {Parent = invFrame, Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1, Text = "📦 Inventory", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.fromRGB(220,220,220)})
local invScroll = new("ScrollingFrame", {Parent = invFrame, Size = UDim2.new(1, -24, 1, -70), Position = UDim2.new(0,12,0,44), BackgroundTransparency = 1, ScrollBarThickness = 6})
local invList = new("UIListLayout", {Parent = invScroll, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,6)})

local function refreshInventory()
    for _,c in pairs(invScroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
    for i, item in ipairs(inventory) do
        local lbl = new("TextLabel", {Parent = invScroll, Size = UDim2.new(1, -6, 0, 28), BackgroundColor3 = Color3.fromRGB(36,36,38), Text = item, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(240,240,240)})
        new("UICorner", {Parent = lbl, CornerRadius = UDim.new(0,6)})
    end
    invScroll.CanvasSize = UDim2.new(0,0,0, #inventory * 34)
end

-- prices
local prices = {["🐟 Common Fish"]=10, ["🐠 Tropical Fish"]=15, ["🐡 Pufferfish"]=20, ["🦑 Squid"]=30, ["🦞 Lobster"]=40, ["🐬 Dolphin (Rare!)"]=100, ["🦈 Shark (Epic!)"]=200}

-- fishing logic (client-side demo)
local fishing = false
fishBtn.MouseButton1Click:Connect(function()
    playClick()
    if fishing then return end
    fishing = true
    -- simulate
    infoTxt.Text = "🎣 Casting..."
    tween(fishBtn, {BackgroundColor3 = Color3.fromRGB(45,130,255)}, 0.25)
    task.wait(1.2)
    infoTxt.Text = "🌊 Waiting for bite..."
    task.wait(math.random(2,4))
    local fishPool = {"🐟 Common Fish","🐠 Tropical Fish","🐡 Pufferfish","🦑 Squid","🦞 Lobster","🐬 Dolphin (Rare!)","🦈 Shark (Epic!)"}
    local catch = fishPool[math.random(1,#fishPool)]
    table.insert(inventory, catch)
    refreshInventory()
    infoTxt.Text = "⚡ Caught: "..catch
    tween(fishBtn, {BackgroundColor3 = Color3.fromRGB(36,36,38)}, 0.35)
    fishing = false
end)

invBtn.MouseButton1Click:Connect(function() playClick(); invFrame.Visible = not invFrame.Visible end)

sellBtn.MouseButton1Click:Connect(function()
    playClick()
    if #inventory == 0 then toast("No fish to sell", Color3.fromRGB(220,60,60)); return end
    local total = 0
    for _, it in ipairs(inventory) do total = total + (prices[it] or 5) end
    gold = gold + total
    goldLbl.Text = "💰 Gold: "..gold
    inventory = {}
    refreshInventory()
    toast("Sold all fish for "..tostring(total).." gold", Color3.fromRGB(60,160,80))
end)

-- ===== SHOP tab (grid cards) =====
local shopFrame = contentFrames["Shop"]
local shopTitle = new("TextLabel", {Parent = shopFrame, BackgroundTransparency = 1, Position = UDim2.new(0,0,0,0), Size = UDim2.new(1,0,0,26), Text = "🏪 Shop", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(220,220,220)})
-- sample store items
local store = {
    {id="rod_1", name="Rod Upgrade I", desc="Increase chance for rare fish", price=150, type="rod", level=1},
    {id="rod_2", name="Rod Upgrade II", desc="Better catch rates", price=350, type="rod", level=2},
    {id="bait_1", name="Bait Pack", desc="Use to increase bites temporarily", price=80, type="consumable"},
    {id="bag_1", name="Bag Expansion", desc="Hold 10 more fish", price=200, type="bag", extra=10},
}
-- grid layout
local grid = new("Frame", {Parent = shopFrame, Position = UDim2.new(0,0,0,36), Size = UDim2.new(1,0,1, -36), BackgroundTransparency = 1})
local function createCard(item, pos)
    local card = new("Frame", {Parent = grid, Size = UDim2.new(0, 180, 0, 100), Position = pos, BackgroundColor3 = Color3.fromRGB(32,32,34)})
    new("UICorner", {Parent = card, CornerRadius = UDim.new(0,8)})
    local name = new("TextLabel", {Parent = card, Size = UDim2.new(1,-12,0,22), Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1, Text = item.name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(230,230,230), TextXAlignment = Enum.TextXAlignment.Left})
    local desc = new("TextLabel", {Parent = card, Size = UDim2.new(1,-12,0,36), Position = UDim2.new(0,8,0,30), BackgroundTransparency = 1, Text = item.desc, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Color3.fromRGB(190,190,190), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true})
    local priceLbl = new("TextLabel", {Parent = card, Size = UDim2.new(0.5,-12,0,20), Position = UDim2.new(0,8,1,-28), BackgroundTransparency = 1, Text = "Price: "..item.price, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,215,0)})
    local buyBtn = new("TextButton", {Parent = card, Size = UDim2.new(0.4, -12, 0, 26), Position = UDim2.new(1,- (0.4), 1, -34), BackgroundColor3 = Color3.fromRGB(6,135,255), Text = "Buy", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255)})
    new("UICorner", {Parent = buyBtn, CornerRadius = UDim.new(0,6)})
    buyBtn.MouseEnter:Connect(function() tween(buyBtn, {BackgroundColor3 = Color3.fromRGB(40,160,255)}, 0.12) end)
    buyBtn.MouseLeave:Connect(function() tween(buyBtn, {BackgroundColor3 = Color3.fromRGB(6,135,255)}, 0.12) end)
    buyBtn.MouseButton1Click:Connect(function()
        playClick()
        if gold >= item.price then
            gold = gold - item.price
            goldLbl.Text = "💰 Gold: "..gold
            -- apply item effect (simple demo)
            if item.type == "rod" then
                toast("Purchased "..item.name.."!", Color3.fromRGB(60,160,80))
                -- you can increase game-level rod_power here
            elseif item.type == "consumable" then
                toast("Purchased "..item.name.."!", Color3.fromRGB(60,160,80))
            elseif item.type == "bag" then
                toast("Purchased "..item.name.."! Bag expanded.", Color3.fromRGB(60,160,80))
            end
        else
            toast("Not enough gold", Color3.fromRGB(200,60,60))
        end
    end)
end

-- layout store in 2-column grid
do
    local xOffsets = {8, 8 + 192}
    local y = 8
    for i,item in ipairs(store) do
        local col = ((i-1) % 2) + 1
        local row = math.floor((i-1) / 2)
        createCard(item, UDim2.new(0, xOffsets[col], 0, 8 + row * 110))
    end
end

-- ===== SETTINGS tab =====
local settingsFrame = contentFrames["Settings"]
local sInfo = new("TextLabel", {Parent = settingsFrame, Size = UDim2.new(1,0,0,72), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(30,30,31), Text = "", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top})
new("UICorner", {Parent = sInfo, CornerRadius = UDim.new(0,8)})

local antiBtn = new("TextButton", {Parent = settingsFrame, Size = UDim2.new(0,200,0,36), Position = UDim2.new(0,0,0,86), BackgroundColor3 = Color3.fromRGB(36,36,38), Text = "Anti Lag / Low Texture", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(240,240,240)})
new("UICorner", {Parent = antiBtn, CornerRadius = UDim.new(0,8)})
antiBtn.MouseButton1Click:Connect(function() playClick(); toast("Anti Lag applied (demo)", Color3.fromRGB(60,160,80)) end)

local rejoinBtn = new("TextButton", {Parent = settingsFrame, Size = UDim2.new(0,200,0,36), Position = UDim2.new(0,0,0,132), BackgroundColor3 = Color3.fromRGB(36,36,38), Text = "Rejoin Server", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(240,240,240)})
new("UICorner", {Parent = rejoinBtn, CornerRadius = UDim.new(0,8)})
rejoinBtn.MouseButton1Click:Connect(function() playClick(); Players.LocalPlayer:Kick("Rejoining..."); wait(0.5); end) -- demo; real rejoin you'd teleport

local minPlayers = 2
local minBtn = new("TextButton", {Parent = settingsFrame, Size = UDim2.new(0,200,0,36), Position = UDim2.new(0,0,0,178), BackgroundColor3 = Color3.fromRGB(36,36,38), Text = "Minimum Players: "..minPlayers, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(240,240,240)})
new("UICorner", {Parent = minBtn, CornerRadius = UDim.new(0,8)})
minBtn.MouseButton1Click:Connect(function() playClick(); minPlayers = minPlayers + 1; if minPlayers > 10 then minPlayers = 2 end; minBtn.Text = "Minimum Players: "..minPlayers end)

local hopBtn = new("TextButton", {Parent = settingsFrame, Size = UDim2.new(0,200,0,36), Position = UDim2.new(0,0,0,224), BackgroundColor3 = Color3.fromRGB(36,36,38), Text = "Server Hop (demo)", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(240,240,240)})
new("UICorner", {Parent = hopBtn, CornerRadius = UDim.new(0,8)})
hopBtn.MouseButton1Click:Connect(function() playClick(); toast("Server Hop not implemented in demo", Color3.fromRGB(200,160,60)) end)

-- ===== WEBHOOK tab =====
local webhookFrame = contentFrames["Webhook"]
local webhookInput = new("TextBox", {Parent = webhookFrame, Size = UDim2.new(1,-20,0,32), Position = UDim2.new(0,10,0,12), BackgroundColor3 = Color3.fromRGB(32,32,33), PlaceholderText = "Paste webhook URL here...", Font = Enum.Font.Gotham})
new("UICorner", {Parent = webhookInput, CornerRadius = UDim.new(0,6)})
local saveHook = new("TextButton", {Parent = webhookFrame, Size = UDim2.new(0,140,0,34), Position = UDim2.new(0,10,0,58), BackgroundColor3 = Color3.fromRGB(6,135,255), Text = "Save Webhook", Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(255,255,255)})
new("UICorner", {Parent = saveHook, CornerRadius = UDim.new(0,8)})
local testHook = new("TextButton", {Parent = webhookFrame, Size = UDim2.new(0,140,0,34), Position = UDim2.new(0,160,0,58), BackgroundColor3 = Color3.fromRGB(36,36,38), Text = "Test Webhook", Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(230,230,230)})
new("UICorner", {Parent = testHook, CornerRadius = UDim.new(0,8)})

local savedWebhook = nil
saveHook.MouseButton1Click:Connect(function() playClick(); savedWebhook = webhookInput.Text; toast("Webhook saved (demo)", Color3.fromRGB(60,160,80)) end)
testHook.MouseButton1Click:Connect(function() playClick(); if savedWebhook and savedWebhook ~= "" then toast("Webhook test sent (demo)", Color3.fromRGB(60,160,80)) else toast("No webhook saved", Color3.fromRGB(220,60,60)) end end)

-- ===== ABOUT tab =====
local aboutFrame = contentFrames["About"]
local aboutLabel = new("TextLabel", {Parent = aboutFrame, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "Fish It Loader\nMade by HanzyyOffc\nVersion 1.0\nUI Demo with Inventory, Shop & Password", Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(220,220,220), TextWrapped = true})

-- ===== Realtime updates (info text) =====
do
    local last = tick(); local frames = 0
    RunService.RenderStepped:Connect(function(dt)
        frames = frames + 1
        if tick() - last >= 1 then
            local fps = math.floor(frames / (tick() - last) + 0.5)
            infoTxt.Text = ("👤 %s (ID: %s)\n⚡ FPS: %d   👥 Players: %d"):format(LocalPlayer.Name, tostring(LocalPlayer.UserId), fps, #Players:GetPlayers())
            frames = 0; last = tick()
        end
    end)
end

-- ===== Open/Close UI behavior =====
local uiOpen = false
loaderBtn.MouseButton1Click:Connect(function()
    playClick()
    uiOpen = not uiOpen
    if uiOpen then
        mainFrame.Visible = true
        tween(blur, {Size = 8}, 0.22)
        tween(mainFrame, {Size = UDim2.new(0, UI_W, 0, UI_H)}, 0.28)
    else
        tween(mainFrame, {Size = UDim2.new(0,0,0,0)}, 0.18)
        tween(blur, {Size = 0}, 0.18)
        task.delay(0.2, function() mainFrame.Visible = false end)
    end
end)
closeBtn.MouseButton1Click:Connect(function() playClick(); uiOpen = false; tween(mainFrame, {Size = UDim2.new(0,0,0,0)}, 0.18); tween(blur, {Size = 0}, 0.18); task.delay(0.2, function() mainFrame.Visible = false end) end)

-- ===== Shop open button (shortcut from Play tab) =====
shopOpenBtn.MouseButton1Click:Connect(function() playClick(); switchTab("Shop") end)

-- ===== Shop open via Shop tab already created earlier =====

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
        passFrame:Destroy()
        loaderBtn.Visible = true
        tween(loaderBtn, {Size = UDim2.new(0,56,0,56)}, 0.18)
    else
        showError("Wrong password")
    end
end)

-- ===== Inventory refresh initially =====
refreshInventory()

-- ===== Simple hover style for some buttons =====
local function addHover(b, onCol, offCol)
    b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = onCol}, 0.12) end)
    b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = offCol}, 0.12) end)
end
addHover(invBtn, Color3.fromRGB(60,60,62), Color3.fromRGB(45,45,47))
addHover(sellBtn, Color3.fromRGB(120,60,60), Color3.fromRGB(80,40,40))
addHover(shopOpenBtn, Color3.fromRGB(55,55,57), Color3.fromRGB(36,36,38))

-- ===== Cleanup on exit =====
Players.PlayerRemoving:Connect(function(p) if p == LocalPlayer then pcall(function() blur:Destroy() end) end end)

-- ===== End of script =====
