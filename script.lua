-- UI Menu dengan Animasi + Auto Button (script.lua)
-- Aman, hanya contoh belajar

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MainMenu"
ScreenGui.Parent = game.CoreGui

-- Buat Frame utama
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 200)
Frame.Position = UDim2.new(0.5, -125, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Parent = ScreenGui

-- Efek overload (awal invisible + scale kecil)
Frame.Size = UDim2.new(0, 0, 0, 0)
Frame.BackgroundTransparency = 1

-- Tween Service buat animasi
local TweenService = game:GetService("TweenService")

local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local goal = {
    Size = UDim2.new(0, 250, 0, 200),
    BackgroundTransparency = 0
}
TweenService:Create(Frame, tweenInfo, goal):Play()

-- Judul Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Main Menu ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = Frame

-- Fungsi pembuat button
local function makeButton(name, order, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.8, 0, 0.18, 0)
    Button.Position = UDim2.new(0.1, 0, 0.22 + (order * 0.22), 0)
    Button.Text = name
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 120)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 18
    Button.Parent = Frame

    -- Animasi hover
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(80, 80, 200)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 120)}):Play()
    end)

    Button.MouseButton1Click:Connect(callback)
end

-- Daftar tombol (bisa kamu tambah/edit di sini)
local buttons = {
    {Name = "Info", Callback = function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Info",
            Text = "Ini contoh UI dari GitHub!",
            Duration = 5
        })
    end},

    {Name = "Tools", Callback = function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Tools",
            Text = "Belum ada tool, ini hanya demo.",
            Duration = 5
        })
    end},

    {Name = "Close", Callback = function()
        TweenService:Create(Frame, TweenInfo.new(0.5), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
        wait(0.5)
        ScreenGui:Destroy()
    end},
}

-- Generate tombol otomatis
for i, data in ipairs(buttons) do
    makeButton(data.Name, i - 1, data.Callback)
end
