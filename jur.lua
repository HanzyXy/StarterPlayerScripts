-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Daftar Admin/Mod (edit sesuai kebutuhanmu)
local AdminList = {"Admin1","ModeratorX","OwnerGame"}

-- Window
local Window = OrionLib:MakeWindow({
    Name = "GUI Secure Admin Detect",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GUISecureAdmin"
})

-- =====================================================
-- TAB FARMING
-- =====================================================
local FarmingTab = Window:MakeTab({Name = "Farming", Icon = "rbxassetid://4483345998"})

local AutoFarm = false
local FarmSpeed, FarmDelay = 10, 0.2

FarmingTab:AddToggle({
    Name = "Auto Farm Coin",
    Default = false,
    Callback = function(v) AutoFarm = v end
})

FarmingTab:AddSlider({
    Name = "Kecepatan",
    Min = 1, Max = 50, Default = 10, Increment = 1,
    Callback = function(v) FarmSpeed = v end
})

FarmingTab:AddSlider({
    Name = "Delay",
    Min = 0, Max = 2, Default = 0.2, Increment = 0.1,
    Callback = function(v) FarmDelay = v end
})

task.spawn(function()
    while true do
        if AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, Coin in pairs(Workspace:GetChildren()) do
                if not AutoFarm then break end
                if Coin:IsA("Part") and Coin.Name == "Coin" then
                    LocalPlayer.Character.HumanoidRootPart.CFrame =
                        LocalPlayer.Character.HumanoidRootPart.CFrame:Lerp(Coin.CFrame, FarmSpeed/100)
                    task.wait(FarmDelay)
                end
            end
        end
        task.wait(0.1)
    end
end)

-- =====================================================
-- TAB ESP
-- =====================================================
local ESPTab = Window:MakeTab({Name = "ESP", Icon = "rbxassetid://4483345998"})

local ESPEnabled = false
ESPTab:AddToggle({
    Name = "ESP Player",
    Default = false,
    Callback = function(v) ESPEnabled = v end
})

local function MakeESP(plr)
    if not plr.Character or not plr.Character:FindFirstChild("Head") then return end
    if plr.Character.Head:FindFirstChild("ESP") then return end

    local Billboard = Instance.new("BillboardGui", plr.Character.Head)
    Billboard.Name = "ESP"
    Billboard.Size = UDim2.new(0,150,0,40)
    Billboard.AlwaysOnTop = true

    local Name = Instance.new("TextLabel", Billboard)
    Name.Size = UDim2.new(1,0,0.5,0)
    Name.BackgroundTransparency = 1
    Name.Text = plr.Name
    Name.TextColor3 = Color3.fromRGB(0,255,0)

    local HealthBG = Instance.new("Frame", Billboard)
    HealthBG.Size = UDim2.new(0.8,0,0.2,0)
    HealthBG.Position = UDim2.new(0.1,0,0.6,0)
    HealthBG.BackgroundColor3 = Color3.fromRGB(50,50,50)

    local Health = Instance.new("Frame", HealthBG)
    Health.Size = UDim2.new(1,0,1,0)
    Health.BackgroundColor3 = Color3.fromRGB(0,255,0)
    Health.Name = "Bar"
end

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if ESPEnabled then
                MakeESP(p)
                if p.Character:FindFirstChild("Humanoid") and p.Character.Head:FindFirstChild("ESP") then
                    local hum = p.Character.Humanoid
                    local bar = p.Character.Head.ESP.Frame.Bar
                    bar.Size = UDim2.new(hum.Health/hum.MaxHealth,0,1,0)
                    bar.BackgroundColor3 = hum.Health/hum.MaxHealth > 0.5 and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
                end
            else
                if p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESP") then
                    p.Character.Head.ESP:Destroy()
                end
            end
        end
    end
end)

-- =====================================================
-- TAB TELEPORT
-- =====================================================
local TeleTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998"})

local Preset = {Spawn=Vector3.new(0,5,0), Shop=Vector3.new(50,5,50), Boss=Vector3.new(100,5,100)}
local Custom = {}
local Drop

Drop = TeleTab:AddDropdown({
    Name = "Pilih Lokasi",
    Default = "Spawn",
    Options = {"Spawn","Shop","Boss"},
    Callback = function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if Preset[val] then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Preset[val])
            elseif Custom[val] then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Custom[val])
            end
        end
    end
})

TeleTab:AddTextbox({
    Name = "Teleport ke Koordinat",
    Default = "0,5,0",
    TextDisappear = true,
    Callback = function(v)
        local x,y,z = v:match("([^,]+),([^,]+),([^,]+)")
        if x and y and z then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(tonumber(x),tonumber(y),tonumber(z))
        end
    end
})

TeleTab:AddTextbox({
    Name = "Simpan Lokasi (Nama)",
    Default = "Markas",
    TextDisappear = true,
    Callback = function(v)
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        Custom[v] = pos
        local opts = {"Spawn","Shop","Boss"}
        for n,_ in pairs(Custom) do table.insert(opts,n) end
        Drop:Refresh(opts,true)
    end
})

-- =====================================================
-- TAB SECURITY
-- =====================================================
local SecurityTab = Window:MakeTab({Name = "Security", Icon = "rbxassetid://4483345998"})

-- Anti AFK
local AntiAFK = false
SecurityTab:AddToggle({
    Name = "Anti AFK",
    Default = false,
    Callback = function(v)
        AntiAFK = v
        OrionLib:MakeNotification({
            Name = "Security",
            Content = v and "Anti AFK Aktif" or "Anti AFK Nonaktif",
            Time = 3
        })
    end
})

game.Players.LocalPlayer.Idled:Connect(function()
    if AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Panic Button
local function PanicMode(reason)
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui.Name == "Orion" then
            gui.Enabled = false
        end
    end
    AutoFarm = false
    ESPEnabled = false
    OrionLib:MakeNotification({
        Name = "Panic Mode",
        Content = "Semua fungsi dimatikan! ("..reason..")",
        Time = 5
    })
end

SecurityTab:AddBind({
    Name = "Panic Button",
    Default = Enum.KeyCode.RightControl,
    Hold = false,
    Callback = function()
        PanicMode("Manual")
    end
})

-- Auto-detect admin/mod
Players.PlayerAdded:Connect(function(plr)
    if table.find(AdminList, plr.Name) then
        PanicMode("Admin/Mod Terdeteksi: "..plr.Name)
    end
end)

-- =====================================================
-- Jalankan Orion
-- =====================================================
OrionLib:Init()
