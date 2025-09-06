-- ⚡ Fish It UI Clone (Safe + Animasi + Blur)
-- Dibuat untuk showcase UI, bukan exploit

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- ScreenGui utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishItUI"
ScreenGui.Parent = game.CoreGui

-- Buat BlurEffect di background
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Enabled = false
Blur.Parent = Lighting

-- Frame utama (window besar)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

MainFrame.ClipsDescendants = true
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Fish It Script - Demo"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Tombol close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame

-- Tab bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 40)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local Tabs = {"Settings", "WebhookTab", "About"}
local ActiveTab = nil

for i, name in ipairs(Tabs) do
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(0, 150, 0, 35)
    Tab.Position = UDim2.new(0, (i - 1) * 160 + 10, 0, 0)
    Tab.Text = name
    Tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Tab.Font = Enum.Font.SourceSansBold
    Tab.TextSize = 18
    Tab.Parent = TabBar
    
    local Corner = Instance.new("UICorner", Tab)
    Corner.CornerRadius = UDim.new(0, 6)
    
    Tab.MouseButton1Click:Connect(function()
        if ActiveTab then
            ActiveTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        ActiveTab = Tab
        Tab.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    end)
end

-- Isi content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -90)
Content.Position = UDim2.new(0, 10, 0, 90)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local ExampleBtn = Instance.new("TextButton")
ExampleBtn.Size = UDim2.new(1, 0, 0, 40)
ExampleBtn.Text = "Rejoin Server (Dummy)"
ExampleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExampleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ExampleBtn.Font = Enum.Font.SourceSans
ExampleBtn.TextSize = 18
ExampleBtn.Parent = Content
Instance.new("UICorner", ExampleBtn)

ExampleBtn.MouseButton1Click:Connect(function()
    print("Rejoin button ditekan!")
end)

-- Floating menu button bawah
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 300, 0, 80)
MenuFrame.Position = UDim2.new(0.5, -150, 1, -100)
MenuFrame.BackgroundTransparency = 1
MenuFrame.Parent = ScreenGui

local function OpenUI()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Blur.Enabled = true
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 15}):Play()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 500, 0, 300)
    })
    tween:Play()
end

local function CloseUI()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    tween:Play()
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        Blur.Enabled = false
        MainFrame.Size = UDim2.new(0, 500, 0, 300)
    end)
end

local Buttons = {
    {Icon = "⚙️", Action = function()
        if not MainFrame.Visible then
            OpenUI()
        else
            CloseUI()
        end
    end},
    {Icon = "🐟", Action = function() print("Fish Button!") end},
    {Icon = "🛒", Action = function() print("Shop Button!") end}
}

for i, data in ipairs(Buttons) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 70, 0, 70)
    Btn.Position = UDim2.new(0, (i - 1) * 100, 0, 0)
    Btn.Text = data.Icon
    Btn.TextSize = 30
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Btn.Parent = MenuFrame
    
    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(1, 0)
    
    Btn.MouseButton1Click:Connect(data.Action)
end

-- Tombol close juga pakai blur animasi
CloseBtn.MouseButton1Click:Connect(function()
    CloseUI()
end)
