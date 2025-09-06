-- ===== Fish It UI Super Estetik =====
-- Password: YILZI-EXECUTOR
-- Place in StarterPlayerScripts (LocalScript)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local password = "YILZI-EXECUTOR"

-- ===== Password Security =====
local function requestPassword()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "PasswordGui"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,400,0,100)
    frame.Position = UDim2.new(0.5,-200,0.5,-50)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.Parent = gui

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0,300,0,50)
    box.Position = UDim2.new(0.5,-150,0.5,-25)
    box.PlaceholderText = "Enter Password"
    box.TextColor3 = Color3.fromRGB(0,255,255)
    box.BackgroundColor3 = Color3.fromRGB(40,40,40)
    box.Parent = frame

    box.FocusLost:Connect(function(enter)
        if enter then
            if box.Text ~= password then
                box.Text = "Wrong!"
                task.wait(1)
                player:Kick("Wrong Password")
            else
                gui:Destroy()
                showLoader()
            end
        end
    end)
end

-- ===== Loader Animasi =====
function showLoader()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "LoaderGui"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,300,0,100)
    frame.Position = UDim2.new(0.5,-150,0.5,-50)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.Parent = gui

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0,0,1,0)
    bar.BackgroundColor3 = Color3.fromRGB(0,255,255)
    bar.Parent = frame

    local progress = 0
    while progress < 1 do
        progress += 0.01
        bar.Size = UDim2.new(progress,0,1,0)
        bar.BackgroundColor3 = Color3.fromHSV(progress,1,1)
        task.wait(0.03)
    end
    task.wait(0.5)
    gui:Destroy()
    createUI()
end

-- ===== Super Estetik UI =====
function createUI()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "FishItUI"

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,450,0,550)
    main.Position = UDim2.new(0.5,-225,0.5,-275)
    main.BackgroundColor3 = Color3.fromRGB(10,10,10)
    main.BorderSizePixel = 0
    main.Parent = gui

    -- Background Neon / Glow
    local gradient = Instance.new("UIGradient", main)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(0,255,255))
    }
    gradient.Rotation = 45

    -- Particle Background
    local particleFrame = Instance.new("Frame", main)
    particleFrame.Size = UDim2.new(1,0,1,0)
    particleFrame.BackgroundTransparency = 1
    local ps = Instance.new("ParticleEmitter", particleFrame)
    ps.Texture = "rbxassetid://241594314"
    ps.Rate = 10
    ps.Speed = NumberRange.new(20)
    ps.Lifetime = NumberRange.new(1,2)
    ps.Size = NumberSequence.new(2)
    ps.Rotation = NumberRange.new(0,360)

    -- Title
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1,0,0,50)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.Text = "Fish It | Super UI"
    title.TextSize = 28
    title.TextColor3 = Color3.fromRGB(0,255,255)
    title.Font = Enum.Font.GothamBold

    -- FPS Label
    local fpsLabel = Instance.new("TextLabel", main)
    fpsLabel.Size = UDim2.new(0,100,0,30)
    fpsLabel.Position = UDim2.new(1,-110,0,10)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.TextColor3 = Color3.fromRGB(255,255,255)
    fpsLabel.TextSize = 18
    fpsLabel.Text = "FPS: 0"

    local lastTime = tick()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount += 1
        if tick() - lastTime >= 1 then
            fpsLabel.Text = "FPS: "..frameCount
            frameCount = 0
            lastTime = tick()
        end
    end)

    -- ===== Tab Container =====
    local tabFrame = Instance.new("Frame", main)
    tabFrame.Size = UDim2.new(1,0,1,0)
    tabFrame.Position = UDim2.new(0,0,0,50)
    tabFrame.BackgroundTransparency = 1

    local tabs = {}
    local currentTab = nil

    local function createTabButton(name, position)
        local btn = Instance.new("TextButton", main)
        btn.Size = UDim2.new(0,120,0,40)
        btn.Position = position
        btn.Text = name
        btn.TextSize = 18
        btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
        btn.TextColor3 = Color3.fromRGB(0,255,255)
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0

        -- Hover glow
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(0,0,0)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(20,20,20)}):Play()
        end)

        return btn
    end

    -- ===== Feature Tabs =====
    local featureTab = Instance.new("Frame", tabFrame)
    featureTab.Size = UDim2.new(1,0,1,0)
    featureTab.BackgroundTransparency = 1
    featureTab.Visible = true

    -- Buttons dalam Feature Tab
    local function createFeatureButton(text, pos, callback)
        local btn = Instance.new("TextButton", featureTab)
        btn.Size = UDim2.new(0,200,0,50)
        btn.Position = pos
        btn.Text = text
        btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
        btn.TextColor3 = Color3.fromRGB(0,255,255)
        btn.TextSize = 18
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0

        -- Glow neon effect
        local stroke = Instance.new("UIStroke", btn)
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(0,255,255)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(0,0,0)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(20,20,20)}):Play()
        end)

        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    createFeatureButton("Toggle Speed", UDim2.new(0.5,-100,0,0), function()
        if humanoid.WalkSpeed == 16 then humanoid.WalkSpeed = 100 else humanoid.WalkSpeed = 16 end
    end)
    createFeatureButton("Toggle Jump", UDim2.new(0.5,-100,0,70), function()
        if humanoid.JumpPower == 50 then humanoid.JumpPower = 200 else humanoid.JumpPower = 50 end
    end)
    createFeatureButton("About", UDim2.new(0.5,-100,0,140), function()
        local about = Instance.new("Frame", main)
        about.Size = UDim2.new(0,300,0,150)
        about.Position = UDim2.new(0.5,-150,0.5,-75)
        about.BackgroundColor3 = Color3.fromRGB(10,10,10)
        local label = Instance.new("TextLabel", about)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(0,255,255)
        label.TextSize = 18
        label.TextWrapped = true
        label.Text = "Fish It UI\nPlayer: "..player.Name.."\nServer Member: "..#Players:GetPlayers()
        task.wait(5)
        about:Destroy()
    end)

    -- Tab Buttons
    createTabButton("Features", UDim2.new(0,10,0,50))
    -- Bisa ditambah Tab lain seperti Inventory, Shop dsb
end

requestPassword()
