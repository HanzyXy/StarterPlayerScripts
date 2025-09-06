--[[ 
   Fish It PRO v2
   Password: YILZI-EXECUTOR
   Fitur lengkap: Loader, Tabs, Toggle Cheat, Radar, Teleport, Auto, Main, Misc, Neon UI
--]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer

-- ===== Blur =====
local Blur = Instance.new("BlurEffect")
Blur.Size = 20
Blur.Parent = Lighting

-- ===== Particle Background =====
local ParticleFrame = Instance.new("Frame")
ParticleFrame.Size = UDim2.new(1,0,1,0)
ParticleFrame.BackgroundTransparency = 1
ParticleFrame.Parent = CoreGui
for i=1,40 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0,4,0,4)
    p.Position = UDim2.new(math.random(),0,math.random(),0)
    p.BackgroundColor3 = Color3.fromRGB(0,200,255)
    p.BorderSizePixel = 0
    p.AnchorPoint = Vector2.new(0.5,0.5)
    p.Parent = ParticleFrame
    spawn(function()
        while true do
            p.Position = UDim2.new(math.random(),0,math.random(),0)
            wait(math.random(1,5)/10)
        end
    end)
end

-- ===== ScreenGui =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishItPROv2"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- ===== Password Prompt =====
local function PasswordPrompt()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,350,0,150)
    frame.Position = UDim2.new(0.5,-175,0.5,-75)
    frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
    frame.BorderSizePixel = 0
    frame.Parent = ScreenGui

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,200,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,100,255))
    }
    gradient.Rotation = 45
    gradient.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,50)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.Text = "Enter Password"
    title.TextColor3 = Color3.fromRGB(0,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.Parent = frame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.8,0,0,40)
    input.Position = UDim2.new(0.1,0,0,60)
    input.BackgroundColor3 = Color3.fromRGB(0,0,0)
    input.BorderColor3 = Color3.fromRGB(0,255,255)
    input.TextColor3 = Color3.fromRGB(0,255,255)
    input.TextScaled = true
    input.PlaceholderText = "Password"
    input.Font = Enum.Font.Gotham
    input.ClearTextOnFocus = false
    input.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5,0,0,40)
    btn.Position = UDim2.new(0.25,0,0,110)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.BorderColor3 = Color3.fromRGB(0,255,255)
    btn.TextColor3 = Color3.fromRGB(0,255,255)
    btn.Text = "Submit"
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame

    local success = Instance.new("BindableEvent")
    btn.MouseButton1Click:Connect(function()
        if input.Text == "YILZI-EXECUTOR" then
            success:Fire(true)
            frame:Destroy()
        else
            input.Text = ""
            input.PlaceholderText = "Wrong Password!"
        end
    end)
    return success.Event
end

PasswordPrompt():Wait()

-- ===== Loader Button =====
local LoaderBtn = Instance.new("TextButton")
LoaderBtn.Size = UDim2.new(0,180,0,45)
LoaderBtn.Position = UDim2.new(0.5,-90,0.5,-22)
LoaderBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
LoaderBtn.BorderColor3 = Color3.fromRGB(0,255,255)
LoaderBtn.TextColor3 = Color3.fromRGB(0,255,255)
LoaderBtn.Text = "Open Fish It Menu"
LoaderBtn.TextScaled = true
LoaderBtn.Font = Enum.Font.GothamBold
LoaderBtn.Parent = ScreenGui

-- Glow animation
spawn(function()
    while LoaderBtn.Parent do
        TweenService:Create(LoaderBtn,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BorderColor3=Color3.fromRGB(0,200,255)}):Play()
        wait(1)
        TweenService:Create(LoaderBtn,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BorderColor3=Color3.fromRGB(0,255,255)}):Play()
        wait(1)
    end
end)

-- ===== Main Menu =====
local function CreateMenu()
    LoaderBtn:Destroy()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,650,0,550)
    MainFrame.Position = UDim2.new(0.5,-325,0.5,-275)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.Draggable = true

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,128,255))
    }
    gradient.Rotation = 45
    gradient.Parent = MainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,60)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.Text = "Fish It PRO v2"
    title.TextColor3 = Color3.fromRGB(0,255,255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = MainFrame

    -- Tabs
    local tabNames = {"Main","Auto","Teleport","Radar","Misc"}
    local tabFrames = {}
    for i,name in ipairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,110,0,35)
        btn.Position = UDim2.new(0,20+(i-1)*120,0,70)
        btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        btn.BorderColor3 = Color3.fromRGB(0,255,255)
        btn.TextColor3 = Color3.fromRGB(0,255,255)
        btn.Text = name
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = MainFrame

        -- Tab frame
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,-40,1,-150)
        frame.Position = UDim2.new(0,20,0,150)
        frame.BackgroundTransparency = 1
        frame.Visible = false
        frame.Parent = MainFrame
        tabFrames[name]=frame

        btn.MouseButton1Click:Connect(function()
            for _,f in pairs(tabFrames) do f.Visible=false end
            frame.Visible=true
        end)
    end

    -- Small toggle creator
    local function CreateSmallToggle(parent,text,pos,callback)
        local btn = Instance.new("TextButton")
        btn.Size=UDim2.new(0,150,0,35)
        btn.Position=pos
        btn.BackgroundColor3=Color3.fromRGB(0,0,0)
        btn.BorderColor3=Color3.fromRGB(0,255,255)
        btn.TextColor3=Color3.fromRGB(0,255,255)
        btn.Text=text.." [OFF]"
        btn.TextScaled=true
        btn.Font=Enum.Font.Gotham
        btn.Parent=parent
        local state=false
        btn.MouseButton1Click:Connect(function()
            state=not state
            btn.Text=text.." ["..(state and "ON" or "OFF").."]"
            callback(state)
        end)
    end

    -- Main Tab toggles
    CreateSmallToggle(tabFrames["Main"],"Speed Hack",UDim2.new(0,20,0,20),function(state)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = state and 60 or 16
        end
    end)
    CreateSmallToggle(tabFrames["Main"],"Instant Catch",UDim2.new(0,20,0,70),function(state) end)
    CreateSmallToggle(tabFrames["Main"],"Fast Sell",UDim2.new(0,20,0,120),function(state) end)
end

LoaderBtn.MouseButton1Click:Connect(function()
    CreateMenu()
end)

-- ESC toggle
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode==Enum.KeyCode.Escape then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
