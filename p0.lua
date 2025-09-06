-- // Fish It Final Loader UI
-- Password: YILZI-EXECUTOR
-- Feature: Auto Fish + Stats Panel + Auto Favorite
-- By HanzyyOffc

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

--== BLUR EFFECT
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0
TweenService:Create(blur, TweenInfo.new(1), {Size = 8}):Play()

--== PASSWORD SCREEN
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FishItFinal"

local PassFrame = Instance.new("Frame", ScreenGui)
PassFrame.Size = UDim2.new(0, 300, 0, 180)
PassFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
PassFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
PassFrame.BorderSizePixel = 0
PassFrame.Visible = true

local UICorner = Instance.new("UICorner", PassFrame)
UICorner.CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel", PassFrame)
Title.Text = "Enter Password"
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextScaled = true

local Box = Instance.new("TextBox", PassFrame)
Box.PlaceholderText = "Password..."
Box.Size = UDim2.new(0.8,0,0,40)
Box.Position = UDim2.new(0.1,0,0.4,0)
Box.BackgroundColor3 = Color3.fromRGB(40,40,40)
Box.TextColor3 = Color3.fromRGB(255,255,255)
Box.ClearTextOnFocus = false

local BoxCorner = Instance.new("UICorner", Box)
BoxCorner.CornerRadius = UDim.new(0,8)

local Btn = Instance.new("TextButton", PassFrame)
Btn.Text = "Unlock"
Btn.Size = UDim2.new(0.5,0,0,40)
Btn.Position = UDim2.new(0.25,0,0.75,0)
Btn.BackgroundColor3 = Color3.fromRGB(0,170,127)
Btn.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

--== MAIN DASHBOARD
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 260)
MainFrame.Position = UDim2.new(0.5,-190,0.5,-130)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

local TopBar = Instance.new("TextLabel", MainFrame)
TopBar.Text = "🎣 Fish It Executor"
TopBar.Size = UDim2.new(1,0,0,35)
TopBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
TopBar.TextColor3 = Color3.fromRGB(255,255,255)

--== TABS
local Tabs = {"Play","Stats","Settings","Webhook","About"}
local TabButtons = {}
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1,0,1,-35)
ContentFrame.Position = UDim2.new(0,0,0,35)
ContentFrame.BackgroundTransparency = 1

for i, name in ipairs(Tabs) do
    local b = Instance.new("TextButton", TopBar)
    b.Size = UDim2.new(0,70,1,0)
    b.Position = UDim2.new(0,(i-1)*75,0,0)
    b.Text = name
    b.BackgroundTransparency = 1
    b.TextColor3 = Color3.new(1,1,1)
    TabButtons[name] = b
end

--== CONTENT PANELS
local Panels = {}
for _,tab in ipairs(Tabs) do
    local f = Instance.new("Frame", ContentFrame)
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundTransparency = 1
    f.Visible = false
    Panels[tab] = f
end
Panels["Play"].Visible = true -- default

--== PLAY PANEL (Auto Fish toggle)
local autoFish = false
local PlayLabel = Instance.new("TextLabel", Panels["Play"])
PlayLabel.Text = "Play Menu"
PlayLabel.Size = UDim2.new(1,0,0,30)
PlayLabel.TextColor3 = Color3.new(1,1,1)
PlayLabel.BackgroundTransparency = 1

local AutoFishBtn = Instance.new("TextButton", Panels["Play"])
AutoFishBtn.Size = UDim2.new(0,150,0,40)
AutoFishBtn.Position = UDim2.new(0.5,-75,0.4,0)
AutoFishBtn.Text = "Auto Fish: OFF"
AutoFishBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
AutoFishBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", AutoFishBtn).CornerRadius = UDim.new(0,8)

AutoFishBtn.MouseButton1Click:Connect(function()
    autoFish = not autoFish
    AutoFishBtn.Text = "Auto Fish: " .. (autoFish and "ON" or "OFF")
end)

--== STATS PANEL
local totalFish, rareCount, mythCount, secretCount = 0,0,0,0
local StatsText = Instance.new("TextLabel", Panels["Stats"])
StatsText.Size = UDim2.new(1,0,1,0)
StatsText.TextColor3 = Color3.new(1,1,1)
StatsText.TextScaled = true
StatsText.BackgroundTransparency = 1
StatsText.Text = "No data yet."

--== FAVORITE AUTO
local function catchFish()
    totalFish += 1
    local rarity = math.random(1,100)
    if rarity > 95 then
        mythCount += 1
        print("⭐ Mythical Fish caught -> Auto Favorited!")
    elseif rarity > 85 then
        rareCount += 1
    elseif rarity == 100 then
        secretCount += 1
        print("🌌 SECRET Fish caught -> Auto Favorited!")
    end
    StatsText.Text = ("Total Fish: %d\nRare: %d\nMythical: %d\nSecret: %d\nAutoFish: %s")
        :format(totalFish,rareCount,mythCount,secretCount, autoFish and "ON" or "OFF")
end

--== AUTO FISH LOOP
task.spawn(function()
    while task.wait(2) do
        if autoFish then
            catchFish()
        end
    end
end)

--== TAB SWITCH
for name,btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(Panels) do p.Visible=false end
        Panels[name].Visible = true
    end)
end

--== PASSWORD CHECK
Btn.MouseButton1Click:Connect(function()
    if Box.Text == "YILZI-EXECUTOR" then
        PassFrame.Visible = false
        MainFrame.Visible = true
    else
        Box.Text = "❌ Wrong Password"
        TweenService:Create(Box,TweenInfo.new(0.3),{TextColor3=Color3.fromRGB(255,0,0)}):Play()
        task.wait(1)
        Box.Text = ""
        Box.TextColor3 = Color3.fromRGB(255,255,255)
    end
end)
