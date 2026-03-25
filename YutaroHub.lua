-- ================================
--         Yutaro Hub
--         Bee Garden
-- ================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cypherdh/VanisUILIB/main/.gitignore"))()
local Window = Library:CreateWindow("Yutaro Hub", "v1.0", 6031071057)

-- =====================
--       SERVICES
-- =====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- =====================
--       EVENTS
-- =====================
local Events = ReplicatedStorage:WaitForChild("Events")
local SwatterEvent = Events:WaitForChild("Swatter")
local ClaimCoinsEvent = Events:WaitForChild("ClaimCoins")
local BeeShopEvent = Events:WaitForChild("BeeShopHandler")
local SellAllEvent = Events:WaitForChild("SellAll")

-- =====================
--      STATE FLAGS
-- =====================
local AutoCollectEnabled = false
local AutoSellEnabled = false
local AutoSlapEnabled = false
local AutoBuyBeeEnabled = false
local SlapMode = "Ghost"
local SelectedSlapTarget = nil
local BeeShopSlot = 1
local CollectDelay = 1
local SellDelay = 2
local BeeDelay = 1
local SlapDelay = 0.5

-- =====================
--        TABS
-- =====================
local FarmTab = Window:CreateTab("Farm")
local ShopTab = Window:CreateTab("Shop")
local CombatTab = Window:CreateTab("Combat")

-- ================================================
--                  FARM PAGE
-- ================================================
local FarmPage = FarmTab:CreateFrame("Auto Farm")

local CollectLabel = FarmPage:CreateLabel("Auto Collect Coins: OFF")

FarmPage:CreateToggle("Auto Collect Coins", "Automatically collects coins on the map", function(state)
    AutoCollectEnabled = state
    CollectLabel:UpdateLabel("Auto Collect Coins: " .. (state and "ON" or "OFF"))
end)

FarmPage:CreateSlider("Collect Delay (seconds)", 1, 5, function(value)
    CollectDelay = value
end)

local SellLabel = FarmPage:CreateLabel("Auto Sell Flowers: OFF")

FarmPage:CreateToggle("Auto Sell Flowers", "Automatically sells all collected flowers", function(state)
    AutoSellEnabled = state
    SellLabel:UpdateLabel("Auto Sell Flowers: " .. (state and "ON" or "OFF"))
end)

FarmPage:CreateSlider("Sell Delay (seconds)", 1, 10, function(value)
    SellDelay = value
end)

FarmPage:CreateButton("Sell All Flowers Now", "Manually sell all flowers", function()
    SellAllEvent:InvokeServer()
end)

-- ================================================
--                  SHOP PAGE
-- ================================================
local ShopPage = ShopTab:CreateFrame("Bee Shop")

local SlotLabel = ShopPage:CreateLabel("Selected Slot: 1")

ShopPage:CreateSlider("Bee Shop Slot (1-14)", 1, 14, function(value)
    BeeShopSlot = math.floor(value)
    SlotLabel:UpdateLabel("Selected Slot: " .. BeeShopSlot)
end)

ShopPage:CreateSlider("Buy Delay (seconds)", 1, 10, function(value)
    BeeDelay = value
end)

local AutoBuyLabel = ShopPage:CreateLabel("Auto Buy Bee: OFF")

ShopPage:CreateToggle("Auto Buy Bee", "Continuously buys bee from selected slot", function(state)
    AutoBuyBeeEnabled = state
    AutoBuyLabel:UpdateLabel("Auto Buy Bee: " .. (state and "ON" or "OFF"))
end)

ShopPage:CreateButton("Buy Bee Now", "Manually buy bee from selected slot", function()
    BeeShopEvent:FireServer("Purchase", {
        slotIndex = BeeShopSlot,
        quantity = 1
    })
end)

-- ================================================
--                 COMBAT PAGE
-- ================================================
local CombatPage = CombatTab:CreateFrame("Auto Slap")

local SlapModeLabel = CombatPage:CreateLabel("Slap Mode: Ghost")
local TargetLabel = CombatPage:CreateLabel("Target: None")

-- Ghost Mode Toggle
CombatPage:CreateToggle("Target Ghost", "Slaps the ghost from the Spooky Event", function(state)
    if state then
        SlapMode = "Ghost"
        SelectedSlapTarget = nil
        SlapModeLabel:UpdateLabel("Slap Mode: Ghost")
        TargetLabel:UpdateLabel("Target: Spooky Ghost")
    end
end)

-- Player Mode Toggle
CombatPage:CreateToggle("Target Player", "Slaps a selected player in the server", function(state)
    if state then
        SlapMode = "Player"
        SlapModeLabel:UpdateLabel("Slap Mode: Player")
        TargetLabel:UpdateLabel("Target: None selected - pick below")
    end
end)

-- Player List
CombatPage:CreateLabel("--- Players In Server ---")

local PlayerButtons = {}

local function RefreshPlayerList()
    PlayerButtons = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = CombatPage:CreateButton("Target: " .. player.Name, "Click to set as slap target", function()
                if SlapMode == "Player" then
                    SelectedSlapTarget = player.Name
                    TargetLabel:UpdateLabel("Target: " .. player.Name)
                end
            end)
            table.insert(PlayerButtons, { name = player.Name, btn = btn })
        end
    end
end

RefreshPlayerList()

CombatPage:CreateButton("Refresh Player List", "Refreshes the list of players in server", function()
    RefreshPlayerList()
end)

Players.PlayerAdded:Connect(function()
    task.wait(1)
    RefreshPlayerList()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    RefreshPlayerList()
end)

CombatPage:CreateSlider("Slap Delay (seconds)", 0.1, 3, function(value)
    SlapDelay = value
end)

local AutoSlapLabel = CombatPage:CreateLabel("Auto Slap: OFF")

CombatPage:CreateToggle("Auto Slap", "Automatically slaps the selected target", function(state)
    AutoSlapEnabled = state
    AutoSlapLabel:UpdateLabel("Auto Slap: " .. (state and "ON" or "OFF"))
end)

CombatPage:CreateButton("Slap Now", "Manually fire one slap", function()
    SwatterEvent:FireServer()
end)

-- ================================================
--               MAIN LOOP
-- ================================================
local lastCollect = 0
local lastSell = 0
local lastSlap = 0
local lastBuy = 0

RunService.Heartbeat:Connect(function()
    local now = tick()

    -- Auto Collect Coins
    if AutoCollectEnabled and (now - lastCollect) >= CollectDelay then
        lastCollect = now
        ClaimCoinsEvent:FireServer("Collect_Coins")
    end

    -- Auto Sell Flowers
    if AutoSellEnabled and (now - lastSell) >= SellDelay then
        lastSell = now
        SellAllEvent:InvokeServer()
    end

    -- Auto Slap
    if AutoSlapEnabled and (now - lastSlap) >= SlapDelay then
        lastSlap = now

        if SlapMode == "Ghost" then
            SwatterEvent:FireServer()

        elseif SlapMode == "Player" and SelectedSlapTarget then
            local targetPlayer = Players:FindFirstChild(SelectedSlapTarget)
            if targetPlayer and targetPlayer.Character then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root and targetRoot then
                    root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -3)
                end
                SwatterEvent:FireServer()
            end
        end
    end

    -- Auto Buy Bee
    if AutoBuyBeeEnabled and (now - lastBuy) >= BeeDelay then
        lastBuy = now
        BeeShopEvent:FireServer("Purchase", {
            slotIndex = BeeShopSlot,
            quantity = 1
        })
    end
end)

-- ================================================
--          NOTIFICATION ON LOAD
-- ================================================
Notification("Yutaro Hub", "Loaded! Welcome to Bee Garden.", function() end)
