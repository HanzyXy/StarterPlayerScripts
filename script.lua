-- Script UI Test Aman (script.lua)
-- Ini cuma buat belajar, bukan cheat

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestUI"
ScreenGui.Parent = game.CoreGui

-- Buat Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Buat TextLabel
local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 0.5, 0)
Label.BackgroundTransparency = 1
Label.Text = "Hello from GitHub!"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.SourceSansBold
Label.TextSize = 20
Label.Parent = Frame

-- Buat Button
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, 0, 0.5, 0)
Button.Position = UDim2.new(0, 0, 0.5, 0)
Button.Text = "Close"
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.SourceSans
Button.TextSize = 18
Button.Parent = Frame

-- Fungsi tombol close
Button.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
