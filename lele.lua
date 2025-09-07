--[[ 
    SCRIPT UI TEMPLATE "Fish It" (AMAN)
    Dibuat dengan Orion UI Library
    Fitur:
    - UI Full Bahasa Indonesia
    - Auto Save Config (Orion)
    - Export / Import Config (JSON)
    - Log Aktivitas
    - Webhook Test
]]

-- Load Orion
local OrionURL = "https://raw.githubusercontent.com/jensonhirst/Orion/main/source"
local success, Orion = pcall(function()
    return loadstring(game:HttpGet(OrionURL))()
end)
if not success then warn("Gagal load Orion UI") return end

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Config
local CONFIG_FOLDER = "FishItTemplateConfig"

-- State awal
local state = {
    PerfectCast = false,
    AmazingCast = true,
    AutoFishingEnabled = false,
    AutoFishingDelay = 0.7,
    ModifierMaxRod = true,

    SelectedIslands = "Tidak Ada",
    AutoTeleportThreshold = "10",
    AutoFishSelectedIsland = false,

    AutoSellThreshold = "30",
    AutoSellEnabled = false,

    TradeItem = "Tidak Ada",
    TradeTarget = "",
    TradeAmount = "5",
    TradeStart = false,

    WebhookEnabled = false,
    WebhookURL = "",
    WebhookUserID = "",
    WebhookFishRarity = "Tidak Ada",

    MinPlayersToJoin = "2"
}

-- Log Aktivitas
local aktivitas = {}

local function tambahLog(teks)
    table.insert(aktivitas, os.date("[%H:%M:%S] ")..teks)
    if #aktivitas > 100 then table.remove(aktivitas, 1) end
end

-- Notifikasi
local function notif(judul, isi, durasi)
    Orion:MakeNotification({
        Name = judul or "Info",
        Content = isi or "",
        Duration = durasi or 4
    })
    tambahLog((judul or "Info").." - "..(isi or ""))
end

-- Buat window
local Window = Orion:MakeWindow({
    Name = "Fish It Script - AldyToi",
    HidePremium = false,
    IntroText = "Fish It Script (UI Aman)",
    SaveConfig = true,
    ConfigFolder = CONFIG_FOLDER
})

local function buatTab(nama)
    return Window:MakeTab({
        Name = nama,
        Icon = "rbxassetid://6023426926",
        PremiumOnly = false
    })
end

-- Tabs
local tabAutoFishing = buatTab("🎣 Auto Fishing")
local tabAutoFarm    = buatTab("🌐 Auto Farm")
local tabAutoSell    = buatTab("🛒 Auto Jual")
local tabAutoTrade   = buatTab("🔁 Auto Trade")
local tabBeli        = buatTab("🎁 Beli Rod & Umpan")
local tabWebhook     = buatTab("🔔 Webhook")
local tabPengaturan  = buatTab("⚙️ Pengaturan")
local tabLog         = buatTab("📜 Log Aktivitas")
local tabTentang     = buatTab("ℹ️ Tentang")

---------------------------------------------------------
-- AUTO FISHING
---------------------------------------------------------
tabAutoFishing:AddToggle({
    Name = "Perfect Cast",
    Default = state.PerfectCast,
    Callback = function(v) state.PerfectCast=v tambahLog("Perfect Cast: "..tostring(v)) end
})
tabAutoFishing:AddToggle({
    Name = "Amazing Cast",
    Default = state.AmazingCast,
    Callback = function(v) state.AmazingCast=v tambahLog("Amazing Cast: "..tostring(v)) end
})
tabAutoFishing:AddToggle({
    Name = "Auto Fishing (placeholder)",
    Default = state.AutoFishingEnabled,
    Callback = function(v) state.AutoFishingEnabled=v notif("Auto Fishing","Status: "..tostring(v),3) end
})
tabAutoFishing:AddSlider({
    Name = "Delay Auto Fishing (detik)",
    Min = 0.1, Max = 5, Default = state.AutoFishingDelay,
    Increment = 0.1, ValueName = "detik",
    Callback = function(val) state.AutoFishingDelay=val tambahLog("Delay Auto Fishing: "..val) end
})
tabAutoFishing:AddToggle({
    Name = "Rod / Enchant / Bait Maksimal (placeholder)",
    Default = state.ModifierMaxRod,
    Callback = function(v) state.ModifierMaxRod=v tambahLog("Modifier Maks: "..tostring(v)) end
})

---------------------------------------------------------
-- AUTO FARM
---------------------------------------------------------
tabAutoFarm:AddDropdown({
    Name = "Pilih Pulau",
    Default = state.SelectedIslands,
    Options = {"Tidak Ada","Pulau Nelayan","Pulau A","Pulau B"},
    Callback = function(opt) state.SelectedIslands=opt tambahLog("Pulau: "..opt) end
})
tabAutoFarm:AddTextbox({
    Name = "Threshold Auto Teleport",
    Text = state.AutoTeleportThreshold,
    Callback = function(t) state.AutoTeleportThreshold=t tambahLog("Threshold Teleport: "..t) end
})
tabAutoFarm:AddToggle({
    Name = "Auto Pancing di Pulau (placeholder)",
    Default = state.AutoFishSelectedIsland,
    Callback = function(v) state.AutoFishSelectedIsland=v tambahLog("Auto Pulau: "..tostring(v)) end
})

---------------------------------------------------------
-- AUTO JUAL
---------------------------------------------------------
tabAutoSell:AddTextbox({
    Name = "Threshold Auto Jual",
    Text = state.AutoSellThreshold,
    Callback = function(t) state.AutoSellThreshold=t tambahLog("Threshold Jual: "..t) end
})
tabAutoSell:AddToggle({
    Name = "Auto Jual (placeholder)",
    Default = state.AutoSellEnabled,
    Callback = function(v) state.AutoSellEnabled=v tambahLog("Auto Jual: "..tostring(v)) end
})

---------------------------------------------------------
-- AUTO TRADE
---------------------------------------------------------
tabAutoTrade:AddDropdown({
    Name = "Pilih Item",
    Default = state.TradeItem,
    Options = {"Tidak Ada","65 Ikan","Ikan Epic","Rod Astral"},
    Callback = function(opt) state.TradeItem=opt tambahLog("Item Trade: "..opt) end
})
tabAutoTrade:AddTextbox({
    Name = "Pilih Pemain",
    Text = state.TradeTarget,
    Callback = function(t) state.TradeTarget=t tambahLog("Target Trade: "..t) end
})
tabAutoTrade:AddTextbox({
    Name = "Jumlah",
    Text = state.TradeAmount,
    Callback = function(t) state.TradeAmount=t tambahLog("Jumlah Trade: "..t) end
})
tabAutoTrade:AddToggle({
    Name = "Mulai Trade! (placeholder)",
    Default = state.TradeStart,
    Callback = function(v) state.TradeStart=v notif("Trade","Mulai Trade: "..tostring(v),3) end
})
tabAutoTrade:AddButton({
    Name = "Refresh Item",
    Callback = function() tambahLog("Refresh Item ditekan") notif("Inventory","Refresh item (placeholder)",2) end
})

---------------------------------------------------------
-- BELI ROD & UMPAN
---------------------------------------------------------
for _,rod in ipairs({
    "Chrome Rod (437k Koin)","Lucky Rod (15k Koin)","Starter Rod (50 Koin)",
    "Steampunk Rod (215k Koin)","Carbon Rod (900 Koin)",
    "Ice Rod (5k Koin)","Luck Rod (350 Koin)"
}) do
    tabBeli:AddButton({
        Name = rod,
        Callback = function() tambahLog("Beli: "..rod) notif("Pembelian","Tombol "..rod.." ditekan (placeholder)",2) end
    })
end

---------------------------------------------------------
-- WEBHOOK
---------------------------------------------------------
tabWebhook:AddToggle({
    Name = "Aktifkan Webhook (placeholder)",
    Default = state.WebhookEnabled,
    Callback = function(v) state.WebhookEnabled=v tambahLog("Webhook Aktif: "..tostring(v)) end
})
tabWebhook:AddDropdown({
    Name = "Rarity Ikan",
    Default = state.WebhookFishRarity,
    Options = {"Tidak Ada","Common","Rare","Epic","Legendary"},
    Callback = function(opt) state.WebhookFishRarity=opt tambahLog("Webhook Rarity: "..opt) end
})
tabWebhook:AddTextbox({
    Name = "User ID Discord",
    Text = state.WebhookUserID,
    Callback = function(t) state.WebhookUserID=t tambahLog("UserID Discord: "..t) end
})
tabWebhook:AddTextbox({
    Name = "Webhook URL",
    Text = state.WebhookURL,
    Callback = function(t) state.WebhookURL=t tambahLog("Webhook URL: "..t) end
})
tabWebhook:AddButton({
    Name = "Test Webhook",
    Callback = function()
        if state.WebhookURL=="" then notif("Webhook","URL belum diisi",4) return end
        local payload={content="Pesan Test dari "..(Players.LocalPlayer and Players.LocalPlayer.Name or "User"),username="FishItBot"}
        local ok,res=pcall(function() return HttpService:PostAsync(state.WebhookURL,HttpService:JSONEncode(payload),Enum.HttpContentType.ApplicationJson) end)
        if ok then notif("Webhook","Pesan terkirim",4) tambahLog("Test Webhook sukses") else notif("Webhook","Gagal: "..tostring(res),5) tambahLog("Webhook error: "..tostring(res)) end
    end
})

---------------------------------------------------------
-- PENGATURAN
---------------------------------------------------------
tabPengaturan:AddButton({
    Name = "Anti Lag (placeholder)",
    Callback = function() tambahLog("Anti Lag ditekan") notif("Pengaturan","Mode low texture (placeholder)",3) end
})
tabPengaturan:AddButton({
    Name = "Rejoin Server (placeholder)",
    Callback = function() tambahLog("Rejoin ditekan") notif("Pengaturan","Rejoin server (placeholder)",3) end
})
tabPengaturan:AddTextbox({
    Name = "Minimal Pemain",
    Text = state.MinPlayersToJoin,
    Callback = function(t) state.MinPlayersToJoin=t tambahLog("Minimal Pemain: "..t) end
})
tabPengaturan:AddButton({
    Name = "Server Hop (placeholder)",
    Callback = function() tambahLog("Server Hop ditekan") notif("Pengaturan","Server Hop (placeholder)",3) end
})
-- Export / Import Config
tabPengaturan:AddButton({
    Name = "Export Konfigurasi",
    Callback = function()
        local json = HttpService:JSONEncode(state)
        print("Export Config:\n"..json)
        notif("Config","Config diexport (lihat Output)",5)
        tambahLog("Export Config")
    end
})
tabPengaturan:AddTextbox({
    Name = "Import Config (Tempel JSON)",
    Text = "",
    Callback = function(teks)
        local ok, data = pcall(function() return HttpService:JSONDecode(teks) end)
        if ok and type(data)=="table" then
            for k,v in pairs(data) do if state[k]~=nil then state[k]=v end end
            notif("Config","Config berhasil diimport",5)
            tambahLog("Import Config sukses")
        else
            notif("Config","Gagal import JSON",5)
            tambahLog("Import Config gagal")
        end
    end
})

---------------------------------------------------------
-- LOG AKTIVITAS
---------------------------------------------------------
local paragraf = tabLog:AddParagraph("Aktivitas", "Belum ada aktivitas")
game:GetService("RunService").Heartbeat:Connect(function()
    if paragraf then paragraf:Set("Aktivitas", table.concat(aktivitas,"\n")) end
end)

---------------------------------------------------------
-- TENTANG
---------------------------------------------------------
tabTentang:AddParagraph("Tentang", [[
Script ini adalah TEMPLATE UI AMAN.
Tidak ada aksi otomatis di game.
Semua tombol hanya placeholder.
Gunakan hanya sebagai referensi UI.
]])

---------------------------------------------------------
-- Init
---------------------------------------------------------
Orion:Init()
notif("UI Siap","Fish It Template berhasil dimuat",5)
