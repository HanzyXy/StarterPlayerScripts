-- ===== Fish It UI Dashboard + Tabs Modern =====
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
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0,300,0,50)
    box.Position = UDim2.new(0.5,-150,0.5,-25)
    box.PlaceholderText = "Enter Password"
    box.TextColor3 = Color3.fromRGB(0,255,255)
    box.BackgroundColor3 = Color3.fromRGB(40,40,40)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 20
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

-- ===== Loader =====
function showLoader()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "LoaderGui"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,300,0,100)
    frame.Position = UDim2.new(0.5,-150,0.5,-50)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
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

-- ===== Main UI =====
function createUI()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "FishItUI"

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0,450,0,550)
    main.Position = UDim2.new(0.5,-225,0.5,-275)
    main.BackgroundColor3 = Color3.fromRGB(15,15,15)
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Name = "MainFrame"
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.Position = UDim2.new(0.5,0,0.5,0)
    main.Rotation = 0
    main.AutomaticSize = Enum.AutomaticSize.None

    -- Background Gradient & Glow
    local gradient = Instance.new("UIGradient", main)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(0,255,255))
    }
    gradient.Rotation = 45

    -- Title
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1,0,0,50)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.Text = "Fish It | Dashboard"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.TextColor3 = Color3.fromRGB(0,255,255)

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

    -- ===== Tab Buttons =====
    local tabContainer = Instance.new("Frame", main)
    tabContainer.Size = UDim2.new(1,0,0,50)
    tabContainer.Position = UDim2.new(0,0,0,50)
    tabContainer.BackgroundTransparency = 1

    local tabs = {}

    local function createTab(name)
        local btn = Instance.new("TextButton", tabContainer)
        btn.Size = UDim2.new(0,120,0,30)
        btn.Position = UDim2.new(#tabs * 0.3,10,0,10)
        btn.Text = name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.TextColor3 = Color3.fromRGB(0,255,255)
        btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Name = name.."Tab"

        -- Rounded corners
        local uicorner = Instance.new("UICorner", btn)
        uicorner.CornerRadius = UDim.new(0,10)

        -- Glow stroke
        local stroke = Instance.new("UIStroke", btn)
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(0,255,255)

        -- Hover Animation
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(0,0,0)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(20,20,20)}):Play()
        end)

        table.insert(tabs, btn)
        return btn
    end

    local dashboardTab = createTab("Dashboard")
    local featuresTab = createTab("Features")

    -- ===== Dashboard Panel =====
    local dashboardFrame = Instance.new("Frame", main)
    dashboardFrame.Size = UDim2.new(0.9,0,0.7,0)
    dashboardFrame.Position = UDim2.new(0.05,0,0.15,0)
    dashboardFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    dashboardFrame.Visible = true
    local dashCorner = Instance.new("UICorner", dashboardFrame)
    dashCorner.CornerRadius = UDim.new(0,15)

    local dashLabel = Instance.new("TextLabel", dashboardFrame)
    dashLabel.Size = UDim2.new(1,-20,1,-20)
    dashLabel.Position = UDim2.new(0,10,0,10)
    dashLabel.BackgroundTransparency = 1
    dashLabel.TextColor3 = Color3.fromRGB(0,255,255)
    dashLabel.Font = Enum.Font.GothamSemibold
    dashLabel.TextSize = 20
    dashLabel.TextWrapped = true
    dashLabel.Text = "Welcome, "..player.Name.."\nServer Members: "..#Players:GetPlayers()

    -- ===== Features Panel =====
    local featuresFrame = Instance.new("Frame", main)
    featuresFrame.Size = UDim2.new(0.9,0,0.7,0)
    featuresFrame.Position = UDim2.new(0.05,0,0.15,0)
    featuresFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    featuresFrame.Visible = false
    local featCorner = Instance.new("UICorner", featuresFrame)
    featCorner.CornerRadius = UDim.new(0,15)

    local function createFeatureButton(parent,text,pos,callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0,200,0,40)
        btn.Position = pos
        btn.BackgroundColor3 = Color3.fromRGB(15,15,15)
        btn.Text = text
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 18
        btn.TextColor3 = Color3.fromRGB(0,255,255)
        local corner = Instance.new("UICorner",btn)
        corner.CornerRadius = UDim.new(0,10)
        local stroke = Instance.new("UIStroke",btn)
        stroke.Color = Color3.fromRGB(0,255,255)
        stroke.Thickness = 2

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(0,0,0)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(15,15,15)}):Play()
        end)

        btn.MouseButton1Click:Connect(callback)
    end

    createFeatureButton(featuresFrame,"Toggle Speed",UDim2.new(0.5,-100,0,0),function()
        if humanoid.WalkSpeed == 16 then humanoid.WalkSpeed = 100 else humanoid.WalkSpeed = 16 end
    end)
    createFeatureButton(featuresFrame,"Toggle Jump",UDim2.new(0.5,-100,0,60),function()
        if humanoid.JumpPower == 50 then humanoid.JumpPower = 200 else humanoid.JumpPower = 50 end
    end)
    createFeatureButton(featuresFrame,"About",UDim2.new(0.5,-100,0,120),function()
        local about = Instance.new("Frame", main)
        about.Size = UDim2.new(0,300,0,150)
        about.Position = UDim2.new(0.5,-150,0.5,-75)
        about.BackgroundColor3 = Color3.fromRGB(15,15,15)
        local corner = Instance.new("UICorner",about)
        corner.CornerRadius = UDim.new(0,15)
        local label = Instance.new("TextLabel", about)
        label.Size = UDim2.new(1,-20,1,-20)
        label.Position = UDim2.new(0,10,0,10)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(0,255,255)
        label.TextSize = 18
        label.Font = Enum.Font.GothamSemibold
        label.TextWrapped = true
        label.Text = "Fish It UI\nPlayer: "..player.Name.."\nServer Member: "..#Players:GetPlayers()
        task.wait(5)
        about:Destroy()
    end)

    -- ===== Tab Switch =====
    dashboardTab.MouseButton1Click:Connect(function()
        dashboardFrame.Visible = true
        featuresFrame.Visible = false
    end)
    featuresTab.MouseButton1Click:Connect(function()
        dashboardFrame.Visible = false
        featuresFrame.Visible = true
    end)
end

requestPassword()
