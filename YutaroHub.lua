-- ================================
--         Yutaro Hub
--         Bee Garden
--      Modern GUI v2.0
-- ================================

-- =====================
--       SERVICES
-- =====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
local IsMinimized = false

-- =====================
--     THEME COLORS
-- =====================
local Theme = {
    Background   = Color3.fromRGB(13, 13, 20),
    Surface      = Color3.fromRGB(20, 20, 32),
    SurfaceAlt   = Color3.fromRGB(28, 28, 44),
    Accent       = Color3.fromRGB(255, 195, 0),
    AccentDim    = Color3.fromRGB(180, 135, 0),
    TextPrimary  = Color3.fromRGB(240, 240, 255),
    TextSecond   = Color3.fromRGB(140, 140, 170),
    Border       = Color3.fromRGB(45, 45, 70),
    ToggleOn     = Color3.fromRGB(80, 220, 120),
    ToggleOff    = Color3.fromRGB(70, 70, 100),
    ButtonHover  = Color3.fromRGB(40, 40, 60),
    Shadow       = Color3.new(0, 0, 0),
}

-- =====================
--     GUI BUILDER
-- =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YutaroHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- Helper: Create instance with props
local function New(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    return inst
end

local function Corner(radius, parent)
    return New("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function Stroke(color, thickness, parent)
    return New("UIStroke", { Color = color, Thickness = thickness, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, parent)
end

local function Pad(top, bottom, left, right, parent)
    return New("UIPadding", {
        PaddingTop    = UDim.new(0, top),
        PaddingBottom = UDim.new(0, bottom),
        PaddingLeft   = UDim.new(0, left),
        PaddingRight  = UDim.new(0, right),
    }, parent)
end

local function ListLayout(spacing, parent)
    return New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, spacing),
    }, parent)
end

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

-- =====================
--    MAIN WINDOW
-- =====================
local MainFrame = New("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 370, 0, 480),
    Position = UDim2.new(0.5, -185, 0.5, -240),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, ScreenGui)
Corner(12, MainFrame)
Stroke(Theme.Border, 1.5, MainFrame)

-- Shadow layer
New("ImageLabel", {
    Size = UDim2.new(1, 40, 1, 40),
    Position = UDim2.new(0, -20, 0, -15),
    BackgroundTransparency = 1,
    Image = "rbxassetid://6014261993",
    ImageColor3 = Color3.new(0,0,0),
    ImageTransparency = 0.55,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    ZIndex = 0,
}, MainFrame)

-- =====================
--      TITLE BAR
-- =====================
local TitleBar = New("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
}, MainFrame)
Corner(12, TitleBar)

-- Fill bottom corners of titlebar (make flush)
New("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
}, TitleBar)

-- Bee icon
New("TextLabel", {
    Text = "🐝",
    Size = UDim2.new(0, 26, 0, 26),
    Position = UDim2.new(0, 12, 0.5, -13),
    BackgroundTransparency = 1,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
}, TitleBar)

-- Title text
New("TextLabel", {
    Text = "YUTARO HUB",
    Size = UDim2.new(1, -130, 0, 20),
    Position = UDim2.new(0, 44, 0, 6),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = Theme.TextPrimary,
    TextXAlignment = Enum.TextXAlignment.Left,
}, TitleBar)

-- Sub text
New("TextLabel", {
    Text = "Bee Garden  v2.0",
    Size = UDim2.new(1, -130, 0, 14),
    Position = UDim2.new(0, 44, 0, 26),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextColor3 = Theme.TextSecond,
    TextXAlignment = Enum.TextXAlignment.Left,
}, TitleBar)

-- Minimize button
local MinBtn = New("TextButton", {
    Text = "−",
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -64, 0.5, -14),
    BackgroundColor3 = Theme.SurfaceAlt,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Theme.TextSecond,
    BorderSizePixel = 0,
    AutoButtonColor = false,
}, TitleBar)
Corner(6, MinBtn)

-- Close button
local CloseBtn = New("TextButton", {
    Text = "×",
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -32, 0.5, -14),
    BackgroundColor3 = Theme.SurfaceAlt,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Theme.TextSecond,
    BorderSizePixel = 0,
    AutoButtonColor = false,
}, TitleBar)
Corner(6, CloseBtn)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, { BackgroundColor3 = Color3.fromRGB(200, 60, 60), TextColor3 = Color3.fromRGB(255,255,255) })
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, { BackgroundColor3 = Theme.SurfaceAlt, TextColor3 = Theme.TextSecond })
end)
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, { Size = UDim2.new(0, 370, 0, 0) }, 0.25)
    task.wait(0.28)
    ScreenGui:Destroy()
end)

MinBtn.MouseEnter:Connect(function()
    Tween(MinBtn, { BackgroundColor3 = Theme.Accent, TextColor3 = Color3.fromRGB(0,0,0) })
end)
MinBtn.MouseLeave:Connect(function()
    Tween(MinBtn, { BackgroundColor3 = Theme.SurfaceAlt, TextColor3 = Theme.TextSecond })
end)
MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        Tween(MainFrame, { Size = UDim2.new(0, 370, 0, 46) }, 0.28)
        MinBtn.Text = "+"
    else
        Tween(MainFrame, { Size = UDim2.new(0, 370, 0, 480) }, 0.28)
        MinBtn.Text = "−"
    end
end)

-- =====================
--      DRAGGABLE
-- =====================
do
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local vp = workspace.CurrentCamera.ViewportSize
            local newX = math.clamp(startPos.X.Offset + delta.X, 0, vp.X - MainFrame.AbsoluteSize.X)
            local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, vp.Y - MainFrame.AbsoluteSize.Y)
            MainFrame.Position = UDim2.new(0, newX, 0, newY)
        end
    end)
end

-- =====================
--      TAB BAR
-- =====================
local TabBar = New("Frame", {
    Name = "TabBar",
    Size = UDim2.new(1, -24, 0, 34),
    Position = UDim2.new(0, 12, 0, 52),
    BackgroundColor3 = Theme.SurfaceAlt,
    BorderSizePixel = 0,
}, MainFrame)
Corner(8, TabBar)
New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 2),
}, TabBar)
Pad(3, 3, 4, 4, TabBar)

-- =====================
--    CONTENT AREA
-- =====================
local ContentArea = New("Frame", {
    Size = UDim2.new(1, -24, 1, -102),
    Position = UDim2.new(0, 12, 0, 94),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
}, MainFrame)

-- =====================
--   TAB SYSTEM
-- =====================
local Tabs = {}

local function SetTab(name)
    for tabName, data in pairs(Tabs) do
        local on = tabName == name
        Tween(data.Button, {
            BackgroundColor3 = on and Theme.Accent or Color3.fromRGB(0,0,0),
            BackgroundTransparency = on and 0 or 1,
            TextColor3 = on and Color3.fromRGB(0,0,0) or Theme.TextSecond,
        })
        data.Page.Visible = on
    end
end

local function CreateTab(name, icon)
    local order = 0
    for _ in pairs(Tabs) do order = order + 1 end

    local Btn = New("TextButton", {
        Text = icon .. "  " .. name,
        Size = UDim2.new(0, 106, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Theme.TextSecond,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        LayoutOrder = order + 1,
    }, TabBar)
    Corner(6, Btn)

    local Page = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
    }, ContentArea)
    Pad(6, 10, 0, 4, Page)
    ListLayout(8, Page)

    Btn.MouseButton1Click:Connect(function() SetTab(name) end)
    Tabs[name] = { Button = Btn, Page = Page }
    return Page
end

-- =====================
--   UI COMPONENTS
-- =====================
local function CreateSection(label, parent)
    local f = New("Frame", {
        Size = UDim2.new(1, -8, 0, 28),
        BackgroundTransparency = 1,
    }, parent)
    New("TextLabel", {
        Text = string.upper(label),
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0, 2),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, f)
    New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
    }, f)
    return f
end

local function CreateLabel(text, parent)
    return New("TextLabel", {
        Text = text,
        Size = UDim2.new(1, -8, 0, 18),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = Theme.TextSecond,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, parent)
end

local function CreateToggle(labelText, desc, parent, callback)
    local Row = New("Frame", {
        Size = UDim2.new(1, -8, 0, 44),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
    }, parent)
    Corner(8, Row)
    Stroke(Theme.Border, 1, Row)
    Pad(0, 0, 12, 12, Row)

    New("TextLabel", {
        Text = labelText,
        Size = UDim2.new(1, -58, 0, 20),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Row)

    New("TextLabel", {
        Text = desc,
        Size = UDim2.new(1, -58, 0, 14),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextColor3 = Theme.TextSecond,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Row)

    local Track = New("Frame", {
        Size = UDim2.new(0, 42, 0, 22),
        Position = UDim2.new(1, -42, 0.5, -11),
        BackgroundColor3 = Theme.ToggleOff,
        BorderSizePixel = 0,
    }, Row)
    Corner(11, Track)

    local Knob = New("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Theme.TextPrimary,
        BorderSizePixel = 0,
    }, Track)
    Corner(8, Knob)

    local state = false
    local Hit = New("TextButton", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "" }, Row)
    Hit.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Tween(Track, { BackgroundColor3 = Theme.ToggleOn }, 0.2)
            Tween(Knob, { Position = UDim2.new(0, 23, 0.5, -8) }, 0.2)
        else
            Tween(Track, { BackgroundColor3 = Theme.ToggleOff }, 0.2)
            Tween(Knob, { Position = UDim2.new(0, 3, 0.5, -8) }, 0.2)
        end
        callback(state)
    end)
end

local function CreateSlider(labelText, min, max, default, parent, callback)
    local Row = New("Frame", {
        Size = UDim2.new(1, -8, 0, 52),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
    }, parent)
    Corner(8, Row)
    Stroke(Theme.Border, 1, Row)
    Pad(0, 0, 12, 12, Row)

    New("TextLabel", {
        Text = labelText,
        Size = UDim2.new(1, -44, 0, 20),
        Position = UDim2.new(0, 0, 0, 7),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Row)

    local ValLbl = New("TextLabel", {
        Text = tostring(default),
        Size = UDim2.new(0, 38, 0, 20),
        Position = UDim2.new(1, -38, 0, 7),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, Row)

    local Track = New("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = Theme.SurfaceAlt,
        BorderSizePixel = 0,
    }, Row)
    Corner(3, Track)

    local pct = (default - min) / (max - min)
    local Fill = New("Frame", {
        Size = UDim2.new(pct, 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
    }, Track)
    Corner(3, Fill)

    local Knob = New("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(pct, -7, 0.5, -7),
        BackgroundColor3 = Theme.TextPrimary,
        BorderSizePixel = 0,
        ZIndex = 2,
    }, Track)
    Corner(7, Knob)

    local dragging = false
    local function Update(input)
        local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * rel) * 10 + 0.5) / 10
        ValLbl.Text = tostring(val)
        Tween(Fill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.05)
        Tween(Knob, { Position = UDim2.new(rel, -7, 0.5, -7) }, 0.05)
        callback(val)
    end

    Track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; Update(i)
        end
    end)
    Track.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            Update(i)
        end
    end)
end

local function CreateButton(labelText, parent, callback)
    local Btn = New("TextButton", {
        Text = "▶  " .. labelText,
        Size = UDim2.new(1, -8, 0, 36),
        BackgroundColor3 = Theme.SurfaceAlt,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Theme.Accent,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, parent)
    Corner(8, Btn)
    Stroke(Theme.Border, 1, Btn)

    Btn.MouseEnter:Connect(function() Tween(Btn, { BackgroundColor3 = Theme.ButtonHover }) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, { BackgroundColor3 = Theme.SurfaceAlt }) end)
    Btn.MouseButton1Click:Connect(function()
        Tween(Btn, { BackgroundColor3 = Theme.Accent, TextColor3 = Color3.fromRGB(0,0,0) }, 0.08)
        task.wait(0.08)
        Tween(Btn, { BackgroundColor3 = Theme.SurfaceAlt, TextColor3 = Theme.Accent }, 0.15)
        callback()
    end)
    return Btn
end

-- =====================
--   NOTIFICATION
-- =====================
local function ShowNotif(title, message)
    local N = New("Frame", {
        Size = UDim2.new(0, 260, 0, 58),
        Position = UDim2.new(1, 20, 1, -80),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
    }, ScreenGui)
    Corner(10, N)
    Stroke(Theme.Accent, 1.5, N)

    New("TextLabel", {
        Text = "🐝  " .. title,
        Size = UDim2.new(1, -16, 0, 22),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, N)
    New("TextLabel", {
        Text = message,
        Size = UDim2.new(1, -16, 0, 18),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = Theme.TextSecond,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, N)

    Tween(N, { Position = UDim2.new(1, -270, 1, -80) }, 0.3)
    task.wait(3)
    Tween(N, { Position = UDim2.new(1, 20, 1, -80) }, 0.3)
    task.wait(0.35)
    N:Destroy()
end

-- =====================
--    BUILD TABS
-- =====================
local FarmPage   = CreateTab("Farm",   "🌸")
local ShopPage   = CreateTab("Shop",   "🛒")
local CombatPage = CreateTab("Combat", "⚔️")
SetTab("Farm")

-- ================================================
--                  FARM PAGE
-- ================================================
CreateSection("Auto Collect", FarmPage)
local collectLbl = CreateLabel("Status: 🔴 Disabled", FarmPage)
CreateToggle("Auto Collect Coins", "Automatically collects coins on the map", FarmPage, function(s)
    AutoCollectEnabled = s
    collectLbl.Text = s and "Status: 🟢 Active" or "Status: 🔴 Disabled"
    collectLbl.TextColor3 = s and Theme.ToggleOn or Theme.TextSecond
end)
CreateSlider("Collect Delay (sec)", 1, 5, 1, FarmPage, function(v) CollectDelay = v end)

CreateSection("Auto Sell", FarmPage)
local sellLbl = CreateLabel("Status: 🔴 Disabled", FarmPage)
CreateToggle("Auto Sell Flowers", "Automatically sells all collected flowers", FarmPage, function(s)
    AutoSellEnabled = s
    sellLbl.Text = s and "Status: 🟢 Active" or "Status: 🔴 Disabled"
    sellLbl.TextColor3 = s and Theme.ToggleOn or Theme.TextSecond
end)
CreateSlider("Sell Delay (sec)", 1, 10, 2, FarmPage, function(v) SellDelay = v end)
CreateButton("Sell All Flowers Now", FarmPage, function()
    SellAllEvent:InvokeServer()
    task.spawn(ShowNotif, "Sell All", "Sold all flowers!")
end)

-- ================================================
--                  SHOP PAGE
-- ================================================
CreateSection("Bee Shop", ShopPage)
local slotLbl = CreateLabel("Selected Slot: 1", ShopPage)
CreateSlider("Bee Shop Slot (1-14)", 1, 14, 1, ShopPage, function(v)
    BeeShopSlot = math.floor(v)
    slotLbl.Text = "Selected Slot: " .. BeeShopSlot
end)
CreateSlider("Buy Delay (sec)", 1, 10, 1, ShopPage, function(v) BeeDelay = v end)

local buyLbl = CreateLabel("Status: 🔴 Disabled", ShopPage)
CreateToggle("Auto Buy Bee", "Continuously buys bee from selected slot", ShopPage, function(s)
    AutoBuyBeeEnabled = s
    buyLbl.Text = s and "Status: 🟢 Active" or "Status: 🔴 Disabled"
    buyLbl.TextColor3 = s and Theme.ToggleOn or Theme.TextSecond
end)
CreateButton("Buy Bee Now", ShopPage, function()
    BeeShopEvent:FireServer("Purchase", { slotIndex = BeeShopSlot, quantity = 1 })
    task.spawn(ShowNotif, "Buy Bee", "Purchased slot " .. BeeShopSlot)
end)

-- ================================================
--                 COMBAT PAGE
-- ================================================
CreateSection("Slap Mode", CombatPage)
local slapInfoLbl = CreateLabel("Mode: Ghost  |  Target: Spooky Ghost", CombatPage)

CreateToggle("Target Ghost", "Slaps the ghost from the Spooky Event", CombatPage, function(s)
    if s then
        SlapMode = "Ghost"
        SelectedSlapTarget = nil
        slapInfoLbl.Text = "Mode: Ghost  |  Target: Spooky Ghost"
    end
end)
CreateToggle("Target Player", "Slaps a selected player in the server", CombatPage, function(s)
    if s then
        SlapMode = "Player"
        slapInfoLbl.Text = "Mode: Player  |  Target: " .. (SelectedSlapTarget or "None")
    end
end)

CreateSection("Players In Server", CombatPage)

local PlayerListFrame = New("Frame", {
    Size = UDim2.new(1, -8, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
}, CombatPage)
ListLayout(5, PlayerListFrame)

local function RefreshPlayerList()
    for _, c in pairs(PlayerListFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local pBtn = New("TextButton", {
                Text = "👤  " .. player.Name,
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Theme.Surface,
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = Theme.TextPrimary,
                BorderSizePixel = 0,
                AutoButtonColor = false,
            }, PlayerListFrame)
            Corner(7, pBtn)
            Stroke(Theme.Border, 1, pBtn)

            pBtn.MouseEnter:Connect(function()
                if SelectedSlapTarget ~= player.Name then
                    Tween(pBtn, { BackgroundColor3 = Theme.ButtonHover })
                end
            end)
            pBtn.MouseLeave:Connect(function()
                if SelectedSlapTarget ~= player.Name then
                    Tween(pBtn, { BackgroundColor3 = Theme.Surface })
                end
            end)
            pBtn.MouseButton1Click:Connect(function()
                if SlapMode == "Player" then
                    SelectedSlapTarget = player.Name
                    slapInfoLbl.Text = "Mode: Player  |  Target: " .. player.Name
                    for _, c in pairs(PlayerListFrame:GetChildren()) do
                        if c:IsA("TextButton") then
                            Tween(c, { BackgroundColor3 = Theme.Surface })
                        end
                    end
                    Tween(pBtn, { BackgroundColor3 = Color3.fromRGB(45, 38, 10) })
                    task.spawn(ShowNotif, "Target Set", "Now targeting: " .. player.Name)
                end
            end)
        end
    end
end

RefreshPlayerList()
CreateButton("↻ Refresh Player List", CombatPage, RefreshPlayerList)

Players.PlayerAdded:Connect(function() task.wait(1) RefreshPlayerList() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5) RefreshPlayerList() end)

CreateSection("Auto Slap", CombatPage)
local slapLbl = CreateLabel("Status: 🔴 Disabled", CombatPage)
CreateSlider("Slap Delay (sec)", 0.1, 3, 0.5, CombatPage, function(v) SlapDelay = v end)
CreateToggle("Auto Slap", "Automatically slaps the selected target", CombatPage, function(s)
    AutoSlapEnabled = s
    slapLbl.Text = s and "Status: 🟢 Active" or "Status: 🔴 Disabled"
    slapLbl.TextColor3 = s and Theme.ToggleOn or Theme.TextSecond
end)
CreateButton("Slap Now", CombatPage, function()
    SwatterEvent:FireServer()
    task.spawn(ShowNotif, "Slap", "Slap fired!")
end)

-- ================================================
--               MAIN LOOP
-- ================================================
local lastCollect = 0
local lastSell    = 0
local lastSlap    = 0
local lastBuy     = 0

RunService.Heartbeat:Connect(function()
    local now = tick()

    if AutoCollectEnabled and (now - lastCollect) >= CollectDelay then
        lastCollect = now
        ClaimCoinsEvent:FireServer("Collect_Coins")
    end

    if AutoSellEnabled and (now - lastSell) >= SellDelay then
        lastSell = now
        SellAllEvent:InvokeServer()
    end

    if AutoSlapEnabled and (now - lastSlap) >= SlapDelay then
        lastSlap = now
        if SlapMode == "Ghost" then
            SwatterEvent:FireServer()
        elseif SlapMode == "Player" and SelectedSlapTarget then
            local tgt = Players:FindFirstChild(SelectedSlapTarget)
            if tgt and tgt.Character then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local tRoot = tgt.Character:FindFirstChild("HumanoidRootPart")
                if root and tRoot then
                    root.CFrame = tRoot.CFrame * CFrame.new(0, 0, -3)
                end
                SwatterEvent:FireServer()
            end
        end
    end

    if AutoBuyBeeEnabled and (now - lastBuy) >= BeeDelay then
        lastBuy = now
        BeeShopEvent:FireServer("Purchase", { slotIndex = BeeShopSlot, quantity = 1 })
    end
end)

-- ================================================
--          STARTUP NOTIFICATION
-- ================================================
task.wait(0.5)
task.spawn(ShowNotif, "Yutaro Hub", "Loaded! Welcome to Bee Garden.")
