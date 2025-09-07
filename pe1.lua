-- ===== Fish It Loader Cinematic v1.0 =====
-- Place in StarterPlayerScripts
-- Password: YILZI-EXECUTOR

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local UI_PASSWORD = "YILZI-EXECUTOR"

local cheats = {
    {Name="Speed", Type="Button"},
    {Name="Auto Sell", Type="Button"},
    {Name="Magnet Fish", Type="Button"},
    {Name="Fast Reel", Type="Button"},
    {Name="XP Boost", Type="Slider"},
    {Name="Super Jump", Type="Slider"}
}

-- Sound Effects
local clickSound = Instance.new("Sound", SoundService)
clickSound.SoundId = "rbxassetid://9118820750"
clickSound.Volume = 0.5

-- ===== Utility Functions =====
local function makeDraggable(frame)
    local dragging=false
    local dragInput, mousePos, framePos
    local function update(input)
        local delta=input.Position-mousePos
        frame.Position=UDim2.new(framePos.X.Scale, framePos.X.Offset+delta.X,
                                 framePos.Y.Scale, framePos.Y.Offset+delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            mousePos=input.Position
            framePos=frame.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement then
            dragInput=input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input==dragInput and dragging then update(input) end
    end)
end

local function addNeonHover(button)
    local original=button.BackgroundColor3
    button.MouseEnter:Connect(function()
        TweenService:Create(button,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(0,255,200)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button,TweenInfo.new(0.2),{BackgroundColor3=original}):Play()
    end)
end

-- ===== Background Particle & Gradient =====
local function createBackground(frame)
    local gradient=Instance.new("UIGradient", frame)
    gradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(45,0,255)),
                                      ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,200))})
    gradient.Rotation=45
    for i=1,50 do
        local dot=Instance.new("Frame", frame)
        dot.Size=UDim2.new(0,5,0,5)
        dot.Position=UDim2.new(math.random(),0,math.random(),0)
        dot.BackgroundColor3=Color3.fromRGB(255,255,255)
        dot.BackgroundTransparency=0.7
        dot.BorderSizePixel=0
        dot.AnchorPoint=Vector2.new(0.5,0.5)
        spawn(function()
            while true do
                TweenService:Create(dot,TweenInfo.new(math.random(3,6),Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{
                    Position=UDim2.new(math.random(),0,math.random(),0)
                }):Play()
                wait(math.random(2,4))
            end
        end)
    end
end

-- ===== Cinematic Loader =====
local function cinematicLoader(onComplete)
    local gui=Instance.new("ScreenGui", game.CoreGui)
    gui.Name="CinematicLoader"

    local overlay=Instance.new("Frame", gui)
    overlay.Size=UDim2.new(1,0,1,0)
    overlay.BackgroundColor3=Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency=1

    local barBG=Instance.new("Frame", overlay)
    barBG.Size=UDim2.new(0,400,0,30)
    barBG.Position=UDim2.new(0.5,-200,0.5,-15)
    barBG.BackgroundColor3=Color3.fromRGB(50,50,50)
    local bgCorner=Instance.new("UICorner", barBG)
    bgCorner.CornerRadius=UDim.new(0,15)

    local bar=Instance.new("Frame", barBG)
    bar.Size=UDim2.new(0,0,1,0)
    bar.BackgroundColor3=Color3.fromRGB(0,255,200)
    local barCorner=Instance.new("UICorner", bar)
    barCorner.CornerRadius=UDim.new(0,15)

    -- Fade In
    TweenService:Create(overlay, TweenInfo.new(0.7), {BackgroundTransparency=0}):Play()
    wait(0.7)

    -- Animate loading bar
    local t=TweenService:Create(bar, TweenInfo.new(2, Enum.EasingStyle.Linear), {Size=UDim2.new(1,0,1,0)})
    t:Play()
    t.Completed:Wait()
    wait(0.3)

    -- Fade Out
    TweenService:Create(overlay, TweenInfo.new(0.7), {BackgroundTransparency=1}):Play()
    wait(0.7)
    gui:Destroy()
    onComplete()
end

-- ===== Password Prompt =====
local function passwordPrompt()
    local gui=Instance.new("ScreenGui", game.CoreGui)
    local frame=Instance.new("Frame", gui)
    frame.Size=UDim2.new(0,400,0,200)
    frame.Position=UDim2.new(0.5,-200,0.5,-100)
    frame.BackgroundColor3=Color3.fromRGB(30,30,50)
    local uic=Instance.new("UICorner", frame)
    uic.CornerRadius=UDim.new(0,15)

    local title=Instance.new("TextLabel", frame)
    title.Size=UDim2.new(1,0,0,50)
    title.Position=UDim2.new(0,0,0,20)
    title.Text="Enter Password"
    title.TextScaled=true
    title.TextColor3=Color3.fromRGB(255,255,255)
    title.Font=Enum.Font.GothamBold
    title.BackgroundTransparency=1

    local box=Instance.new("TextBox", frame)
    box.Size=UDim2.new(0,300,0,50)
    box.Position=UDim2.new(0.5,-150,0,90)
    box.BackgroundColor3=Color3.fromRGB(50,50,70)
    box.TextColor3=Color3.fromRGB(255,255,255)
    box.PlaceholderText="Password"
    box.Font=Enum.Font.GothamSemibold
    box.TextScaled=true
    box.ClearTextOnFocus=false
    local boxCorner=Instance.new("UICorner", box)
    boxCorner.CornerRadius=UDim.new(0,12)

    box.FocusLost:Connect(function(enter)
        if enter then
            if box.Text==UI_PASSWORD then
                gui:Destroy()
                cinematicLoader(createUI)
            else
                title.Text="Wrong Password!"
                box.Text=""
            end
        end
    end)
end

-- ===== Main UI (Same as final version) =====
function createUI()
    local gui=Instance.new("ScreenGui", game.CoreGui)
    local blur=Instance.new("BlurEffect", Lighting)
    blur.Size=10

    local frame=Instance.new("Frame", gui)
    frame.Size=UDim2.new(0,550,0,420)
    frame.Position=UDim2.new(0.5,-275,0.5,-210)
    frame.BackgroundColor3=Color3.fromRGB(20,20,30)
    frame.ClipsDescendants=true
    local uic=Instance.new("UICorner", frame)
    uic.CornerRadius=UDim.new(0,25)
    makeDraggable(frame)
    createBackground(frame)

    local title=Instance.new("TextLabel", frame)
    title.Size=UDim2.new(1,0,0,50)
    title.Position=UDim2.new(0,0,0,10)
    title.Text="Fish It Cinematic Loader"
    title.TextScaled=true
    title.Font=Enum.Font.GothamBold
    title.TextColor3=Color3.fromRGB(255,255,255)
    title.BackgroundTransparency=1

    local tabContainer=Instance.new("Frame", frame)
    tabContainer.Size=UDim2.new(1,-40,0,50)
    tabContainer.Position=UDim2.new(0,20,0,70)
    tabContainer.BackgroundTransparency=1

    local tabLayout=Instance.new("UIListLayout", tabContainer)
    tabLayout.FillDirection=Enum.FillDirection.Horizontal
    tabLayout.SortOrder=Enum.SortOrder.LayoutOrder
    tabLayout.Padding=UDim.new(0,5)

    local tabPages={}
    local currentPage

    for _, cheat in pairs(cheats) do
        local btn=Instance.new("TextButton", tabContainer)
        btn.Size=UDim2.new(0,140,1,0)
        btn.Text=cheat.Name
        btn.TextScaled=true
        btn.Font=Enum.Font.GothamSemibold
        btn.BackgroundColor3=Color3.fromRGB(50,50,80)
        addNeonHover(btn)
        local corner=Instance.new("UICorner", btn)
        corner.CornerRadius=UDim.new(0,12)

        local page=Instance.new("Frame", frame)
        page.Size=UDim2.new(1,-40,1,-150)
        page.Position=UDim2.new(0,20,0,130)
        page.BackgroundColor3=Color3.fromRGB(35,35,50)
        page.Visible=false
        local pCorner=Instance.new("UICorner", page)
        pCorner.CornerRadius=UDim.new(0,20)
        tabPages[cheat.Name]=page

        btn.MouseButton1Click:Connect(function()
            clickSound:Play()
            if currentPage then
                TweenService:Create(currentPage,TweenInfo.new(0.3),{Position=UDim2.new(1,0,currentPage.Position.Y.Scale,currentPage.Position.Y.Offset)}):Play()
                wait(0.3)
                currentPage.Visible=false
            end
            page.Position=UDim2.new(-1,0,page.Position.Y.Scale,page.Position.Y.Offset)
            page.Visible=true
            TweenService:Create(page,TweenInfo.new(0.3),{Position=UDim2.new(0,20,page.Position.Y.Scale,page.Position.Y.Offset)}):Play()
            currentPage=page
        end)

        -- Add button or slider inside page
        if cheat.Type=="Button" then
            local cbtn=Instance.new("TextButton", page)
            cbtn.Size=UDim2.new(0,200,0,50)
            cbtn.Position=UDim2.new(0,20,0,20)
            cbtn.Text="Activate "..cheat.Name
            cbtn.TextScaled=true
            cbtn.Font=Enum.Font.GothamBold
            cbtn.BackgroundColor3=Color3.fromRGB(70,70,100)
            local cbCorner=Instance.new("UICorner", cbtn)
            cbCorner.CornerRadius=UDim.new(0,12)
            addNeonHover(cbtn)
            cbtn.MouseButton1Click:Connect(function()
                clickSound:Play()
                print(cheat.Name.." activated!")
            end)
        elseif cheat.Type=="Slider" then
            local sliderFrame=Instance.new("Frame", page)
            sliderFrame.Size=UDim2.new(0,300,0,50)
            sliderFrame.Position=UDim2.new(0,20,0,20)
            sliderFrame.BackgroundColor3=Color3.fromRGB(50,50,70)
            local sCorner=Instance.new("UICorner", sliderFrame)
            sCorner.CornerRadius=UDim.new(0,12)

            local knob=Instance.new("Frame", sliderFrame)
            knob.Size=UDim2.new(0,50,1,0)
            knob.Position=UDim2.new(0,0,0,0)
            knob.BackgroundColor3=Color3.fromRGB(0,255,200)
            local kCorner=Instance.new("UICorner", knob)
            kCorner.CornerRadius=UDim.new(0,12)

            local dragging=false
            local mousePos, knobPos
            knob.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then
                    dragging=true
                    mousePos=input.Position
                    knobPos=knob.Position
                    input.Changed:Connect(function()
                        if input.UserInputState==Enum.UserInputState.End then dragging=false end
                    end)
                end
            end)
            knob.InputChanged:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseMovement then
                    dragInput=input
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if input==dragInput and dragging then
                    local delta=input.Position.X-mousePos.X
                    local newX=math.clamp(knobPos.X.Offset+delta,0,sliderFrame.AbsoluteSize.X-50)
                    knob.Position=UDim2.new(0,newX,0,0)
                end
            end)
        end
    end
end

passwordPrompt()
