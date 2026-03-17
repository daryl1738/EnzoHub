--[[
╔═══════════════════════════════════════════════════════════════════╗
║                    ENZO HUB  ·  v2.0  (Luau)                     ║
║   Tabbed UI · Toggle Automations · Lasso Selector · Notifs        ║
╚═══════════════════════════════════════════════════════════════════╝
--]]

------------------------------------------------------------------------
-- SERVICES
------------------------------------------------------------------------
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer       = Players.LocalPlayer

------------------------------------------------------------------------
-- THEME
------------------------------------------------------------------------
local T = {
    BG        = Color3.fromRGB(13,  14,  17),
    Surface   = Color3.fromRGB(20,  22,  27),
    SurfaceHi = Color3.fromRGB(28,  31,  38),
    Border    = Color3.fromRGB(38,  42,  52),
    Accent    = Color3.fromRGB(88, 166, 255),
    AccentDim = Color3.fromRGB(40,  80, 140),
    Green     = Color3.fromRGB(52, 211, 153),
    Red       = Color3.fromRGB(248,  81,  73),
    Yellow    = Color3.fromRGB(251, 191,  36),
    TextPri   = Color3.fromRGB(225, 228, 235),
    TextSec   = Color3.fromRGB(130, 138, 155),
    TitleBar  = Color3.fromRGB(17,  19,  24),
    Dropdown  = Color3.fromRGB(16,  18,  23),
}

------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------
local WIN_W      = 490
local WIN_H      = 550
local TITLE_H    = 38
local TAB_H      = 36
local ROW_H      = 78
local NOTIF_TIME = 2.2
local STATUS_H   = 52

------------------------------------------------------------------------
-- LASSO LIST
------------------------------------------------------------------------
local LASSOS = {
    "Basic Lasso",
    "Rancher's Rope",
    "Metal Lasso",
    "Stealcoil Lasso",
    "Stormwrangler",
    "Sunforged Lasso",
    "Nightveil Lasso",
    "Voidweave Lasso",
    "Celestial Lasso",
    "Nebula Lasso",
    "Fragmented Lasso",
    "Blackhole Lasso",
    "Helion Lasso",
    "Valentines Lasso",
    "Stellar Lasso",
    "Cat and Dog Lasso",
}

------------------------------------------------------------------------
-- HELPERS
------------------------------------------------------------------------
local function inst(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function corner(r, p)
    inst("UICorner", { CornerRadius = UDim.new(0, r) }, p)
end

local function uistroke(p, color, thick)
    inst("UIStroke", {
        Color = color or T.Border,
        Thickness = thick or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, p)
end

local function tween(obj, info, goals)
    TweenService:Create(obj, info, goals):Play()
end

local fast   = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local medium = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

------------------------------------------------------------------------
-- CLEANUP PREVIOUS INSTANCE
------------------------------------------------------------------------
if LocalPlayer.PlayerGui:FindFirstChild("EnzoHub") then
    LocalPlayer.PlayerGui.EnzoHub:Destroy()
end

------------------------------------------------------------------------
-- SCREEN GUI
------------------------------------------------------------------------
local ScreenGui = inst("ScreenGui", {
    Name           = "EnzoHub",
    ResetOnSpawn   = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
}, LocalPlayer.PlayerGui)

------------------------------------------------------------------------
-- MAIN WINDOW
------------------------------------------------------------------------
local MainFrame = inst("Frame", {
    Name             = "MainFrame",
    Size             = UDim2.fromOffset(WIN_W, WIN_H),
    Position         = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
    BackgroundColor3 = T.BG,
    BorderSizePixel  = 0,
    ClipsDescendants = false,
}, ScreenGui)
corner(10, MainFrame)
uistroke(MainFrame, T.Border, 1)

-- Clip inner content separately so dropdown can overflow
local InnerClip = inst("Frame", {
    Size             = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex           = 1,
}, MainFrame)

-- Accent top bar
local accentBar = inst("Frame", {
    Size             = UDim2.new(1, 0, 0, 2),
    BackgroundColor3 = T.Accent,
    BorderSizePixel  = 0,
    ZIndex           = 10,
}, InnerClip)
inst("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   T.Accent),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 200, 255)),
        ColorSequenceKeypoint.new(1,   T.Accent),
    }),
}, accentBar)

------------------------------------------------------------------------
-- TITLE BAR
------------------------------------------------------------------------
local TitleBar = inst("Frame", {
    Size             = UDim2.new(1, 0, 0, TITLE_H),
    Position         = UDim2.new(0, 0, 0, 2),
    BackgroundColor3 = T.TitleBar,
    BorderSizePixel  = 0,
    ZIndex           = 5,
}, InnerClip)

-- Logo dot
local logoDot = inst("Frame", {
    Size             = UDim2.fromOffset(8, 8),
    Position         = UDim2.new(0, 12, 0.5, -4),
    BackgroundColor3 = T.Accent,
    BorderSizePixel  = 0,
    ZIndex           = 7,
}, TitleBar)
corner(4, logoDot)

inst("TextLabel", {
    Size             = UDim2.new(1, -110, 1, 0),
    Position         = UDim2.new(0, 26, 0, 0),
    BackgroundTransparency = 1,
    Text             = "ENZO HUB",
    TextColor3       = T.TextPri,
    Font             = Enum.Font.GothamBold,
    TextSize         = 14,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 6,
    LetterSpacing    = 2,
}, TitleBar)

-- Version badge
local verBg = inst("Frame", {
    Size             = UDim2.fromOffset(38, 18),
    Position         = UDim2.new(0, 118, 0.5, -9),
    BackgroundColor3 = T.AccentDim,
    BorderSizePixel  = 0,
    ZIndex           = 6,
}, TitleBar)
corner(4, verBg)
inst("TextLabel", {
    Size             = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text             = "v2.0",
    TextColor3       = T.Accent,
    Font             = Enum.Font.GothamBold,
    TextSize         = 10,
    ZIndex           = 7,
}, verBg)

-- Minimize button
local MinBtn = inst("TextButton", {
    Size             = UDim2.fromOffset(26, 26),
    Position         = UDim2.new(1, -62, 0.5, -13),
    BackgroundColor3 = Color3.fromRGB(55, 48, 18),
    Text             = "─",
    TextColor3       = T.Yellow,
    Font             = Enum.Font.GothamBold,
    TextSize         = 12,
    BorderSizePixel  = 0,
    ZIndex           = 6,
    AutoButtonColor  = false,
}, TitleBar)
corner(6, MinBtn)

-- Close button
local CloseBtn = inst("TextButton", {
    Size             = UDim2.fromOffset(26, 26),
    Position         = UDim2.new(1, -32, 0.5, -13),
    BackgroundColor3 = Color3.fromRGB(55, 22, 24),
    Text             = "✕",
    TextColor3       = T.Red,
    Font             = Enum.Font.GothamBold,
    TextSize         = 12,
    BorderSizePixel  = 0,
    ZIndex           = 6,
    AutoButtonColor  = false,
}, TitleBar)
corner(6, CloseBtn)

CloseBtn.MouseEnter:Connect(function()
    tween(CloseBtn, fast, { BackgroundColor3 = T.Red, TextColor3 = Color3.fromRGB(255,255,255) })
end)
CloseBtn.MouseLeave:Connect(function()
    tween(CloseBtn, fast, { BackgroundColor3 = Color3.fromRGB(55,22,24), TextColor3 = T.Red })
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

MinBtn.MouseEnter:Connect(function()
    tween(MinBtn, fast, { BackgroundColor3 = T.Yellow, TextColor3 = Color3.fromRGB(20,20,20) })
end)
MinBtn.MouseLeave:Connect(function()
    tween(MinBtn, fast, { BackgroundColor3 = Color3.fromRGB(55,48,18), TextColor3 = T.Yellow })
end)

local minimized  = false
local fullHeight = WIN_H
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetH = minimized and (TITLE_H + TAB_H + 4) or fullHeight
    tween(MainFrame, medium, { Size = UDim2.fromOffset(WIN_W, targetH) })
end)

------------------------------------------------------------------------
-- DRAG LOGIC
------------------------------------------------------------------------
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging  = true
        dragStart = input.Position
        startPos  = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

------------------------------------------------------------------------
-- TAB BAR
------------------------------------------------------------------------
local TabBar = inst("Frame", {
    Size             = UDim2.new(1, 0, 0, TAB_H),
    Position         = UDim2.new(0, 0, 0, TITLE_H + 2),
    BackgroundColor3 = T.TitleBar,
    BorderSizePixel  = 0,
    ZIndex           = 5,
}, InnerClip)
inst("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder     = Enum.SortOrder.LayoutOrder,
    Padding       = UDim.new(0, 0),
}, TabBar)

local TabIndicator = inst("Frame", {
    Size             = UDim2.new(0.5, 0, 0, 2),
    Position         = UDim2.new(0, 0, 1, -2),
    BackgroundColor3 = T.Accent,
    BorderSizePixel  = 0,
    ZIndex           = 7,
}, TabBar)

------------------------------------------------------------------------
-- CONTENT AREA
------------------------------------------------------------------------
local contentY = TITLE_H + 2 + TAB_H
local contentH = WIN_H - contentY - STATUS_H - 10

local ContentArea = inst("Frame", {
    Size             = UDim2.new(1, 0, 0, contentH),
    Position         = UDim2.new(0, 0, 0, contentY),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
}, InnerClip)

local function makeScrollFrame()
    local sf = inst("ScrollingFrame", {
        Size                 = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        ScrollBarThickness   = 4,
        ScrollBarImageColor3 = T.Border,
        CanvasSize           = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
    })
    inst("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, 4),
    }, sf)
    inst("UIPadding", {
        PaddingTop    = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft   = UDim.new(0, 10),
        PaddingRight  = UDim.new(0, 10),
    }, sf)
    return sf
end

local AutoFrame    = makeScrollFrame()
AutoFrame.Parent   = ContentArea

local MainTabFrame = makeScrollFrame()
MainTabFrame.Parent  = ContentArea
MainTabFrame.Visible = false

------------------------------------------------------------------------
-- NOTIFICATION SYSTEM
------------------------------------------------------------------------
local NotifContainer = inst("Frame", {
    Size             = UDim2.new(0, 250, 1, 0),
    Position         = UDim2.new(1, 12, 0, 0),
    BackgroundTransparency = 1,
    ZIndex           = 20,
}, MainFrame)
inst("UIListLayout", {
    SortOrder         = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding           = UDim.new(0, 5),
}, NotifContainer)

local notifOrder = 0
local function showNotif(message, color)
    color      = color or T.Accent
    notifOrder = notifOrder + 1
    local nf = inst("Frame", {
        Size             = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
        ZIndex           = 21,
        LayoutOrder      = notifOrder,
        BackgroundTransparency = 1,
    }, NotifContainer)
    corner(8, nf)
    uistroke(nf, color, 1)

    inst("Frame", {
        Size             = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = color,
        BorderSizePixel  = 0,
        ZIndex           = 22,
    }, nf)

    inst("TextLabel", {
        Size             = UDim2.new(1, -14, 1, 0),
        Position         = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text             = message,
        TextColor3       = T.TextPri,
        Font             = Enum.Font.Gotham,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
        ZIndex           = 22,
    }, nf)

    tween(nf, fast, { BackgroundTransparency = 0 })
    task.delay(NOTIF_TIME, function()
        tween(nf, medium, { BackgroundTransparency = 1 })
        task.delay(0.35, function() nf:Destroy() end)
    end)
end

------------------------------------------------------------------------
-- STATUS PANEL
------------------------------------------------------------------------
local StatusPanel = inst("Frame", {
    Size             = UDim2.new(1, -20, 0, STATUS_H - 10),
    Position         = UDim2.new(0, 10, 1, -(STATUS_H - 2)),
    BackgroundColor3 = T.Surface,
    BorderSizePixel  = 0,
    ZIndex           = 5,
}, InnerClip)
corner(8, StatusPanel)
uistroke(StatusPanel, T.Border, 1)

inst("TextLabel", {
    Size             = UDim2.new(0, 65, 1, 0),
    Position         = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text             = "ACTIVE:",
    TextColor3       = T.TextSec,
    Font             = Enum.Font.GothamBold,
    TextSize         = 10,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 6,
}, StatusPanel)

local StatusText = inst("TextLabel", {
    Size             = UDim2.new(1, -78, 1, 0),
    Position         = UDim2.new(0, 70, 0, 0),
    BackgroundTransparency = 1,
    Text             = "None",
    TextColor3       = T.TextSec,
    Font             = Enum.Font.Gotham,
    TextSize         = 10,
    TextXAlignment   = Enum.TextXAlignment.Left,
    TextWrapped      = true,
    ZIndex           = 6,
}, StatusPanel)

_G.EnzoHubFeatures = {}
for i = #(_G.EnzoHubFeatures or {}), 1, -1 do _G.EnzoHubFeatures[i] = nil end

local function updateStatus()
    local active = {}
    for _, f in ipairs(_G.EnzoHubFeatures) do
        if f.enabled then table.insert(active, f.label) end
    end
    StatusText.Text       = #active > 0 and table.concat(active, "  ·  ") or "None"
    StatusText.TextColor3 = #active > 0 and T.Green or T.TextSec
end

------------------------------------------------------------------------
-- SECTION HEADER
------------------------------------------------------------------------
local function makeHeader(parent, order, text)
    local hdr = inst("Frame", {
        Size             = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        LayoutOrder      = order,
    }, parent)
    inst("TextLabel", {
        Size             = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text             = text,
        TextColor3       = T.TextSec,
        Font             = Enum.Font.GothamBold,
        TextSize         = 10,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, hdr)
    inst("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
    }, hdr)
end

------------------------------------------------------------------------
-- TOGGLE ROW BUILDER
------------------------------------------------------------------------
local function makeToggleRow(parent, order, icon, label, description, onEnable, onDisable, defaultDelay)
    defaultDelay = defaultDelay or 0.5

    local featureState = { label = label, enabled = false, delay = defaultDelay, thread = nil }
    table.insert(_G.EnzoHubFeatures, featureState)

    local row = inst("Frame", {
        Size             = UDim2.new(1, 0, 0, ROW_H),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
        LayoutOrder      = order,
        ZIndex           = 3,
    }, parent)
    corner(8, row)
    uistroke(row, T.Border, 1)

    inst("TextLabel", {
        Size             = UDim2.fromOffset(28, 28),
        Position         = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text             = icon,
        TextSize         = 17,
        Font             = Enum.Font.GothamBold,
        TextColor3       = T.TextPri,
        ZIndex           = 4,
    }, row)

    inst("TextLabel", {
        Size             = UDim2.new(1, -130, 0, 18),
        Position         = UDim2.new(0, 44, 0, 7),
        BackgroundTransparency = 1,
        Text             = label,
        TextColor3       = T.TextPri,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 4,
    }, row)

    inst("TextLabel", {
        Size             = UDim2.new(1, -130, 0, 13),
        Position         = UDim2.new(0, 44, 0, 27),
        BackgroundTransparency = 1,
        Text             = description,
        TextColor3       = T.TextSec,
        Font             = Enum.Font.Gotham,
        TextSize         = 10,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 4,
    }, row)

    -- Toggle pill
    local toggleBg = inst("Frame", {
        Size             = UDim2.fromOffset(46, 24),
        Position         = UDim2.new(1, -56, 0, 12),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        ZIndex           = 4,
    }, row)
    corner(12, toggleBg)

    local knob = inst("Frame", {
        Size             = UDim2.fromOffset(18, 18),
        Position         = UDim2.new(0, 3, 0.5, -9),
        BackgroundColor3 = T.TextSec,
        BorderSizePixel  = 0,
        ZIndex           = 5,
    }, toggleBg)
    corner(9, knob)

    local dot = inst("Frame", {
        Size             = UDim2.fromOffset(7, 7),
        Position         = UDim2.new(1, -57, 0, 14),
        BackgroundColor3 = T.Red,
        BorderSizePixel  = 0,
        ZIndex           = 4,
    }, row)
    corner(4, dot)

    -- Delay slider
    local sliderRow = inst("Frame", {
        Size             = UDim2.new(1, -20, 0, 16),
        Position         = UDim2.new(0, 10, 0, ROW_H - 22),
        BackgroundTransparency = 1,
        ZIndex           = 4,
    }, row)

    inst("TextLabel", {
        Size             = UDim2.fromOffset(38, 16),
        BackgroundTransparency = 1,
        Text             = "Delay:",
        TextColor3       = T.TextSec,
        Font             = Enum.Font.Gotham,
        TextSize         = 9,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 5,
    }, sliderRow)

    local track = inst("Frame", {
        Size             = UDim2.new(1, -100, 0, 4),
        Position         = UDim2.new(0, 44, 0.5, -2),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        ZIndex           = 5,
    }, sliderRow)
    corner(2, track)

    local fill = inst("Frame", {
        Size             = UDim2.new(defaultDelay / 2.0, 0, 1, 0),
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
        ZIndex           = 6,
    }, track)
    corner(2, fill)

    local handle = inst("Frame", {
        Size             = UDim2.fromOffset(12, 12),
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Position         = UDim2.new(defaultDelay / 2.0, 0, 0.5, 0),
        BackgroundColor3 = T.TextPri,
        BorderSizePixel  = 0,
        ZIndex           = 7,
    }, track)
    corner(6, handle)

    local delayLbl = inst("TextLabel", {
        Size             = UDim2.fromOffset(50, 16),
        Position         = UDim2.new(1, -50, 0, 0),
        BackgroundTransparency = 1,
        Text             = string.format("%.1fs", defaultDelay),
        TextColor3       = T.Accent,
        Font             = Enum.Font.GothamBold,
        TextSize         = 9,
        TextXAlignment   = Enum.TextXAlignment.Right,
        ZIndex           = 5,
    }, sliderRow)

    local sliding = false
    local function updateSlider(mouseX)
        local rel      = math.clamp((mouseX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local newDelay = math.max(0.1, rel * 2.0)
        featureState.delay = newDelay
        tween(fill,   fast, { Size     = UDim2.new(rel, 0, 1, 0) })
        tween(handle, fast, { Position = UDim2.new(rel, 0, 0.5, 0) })
        delayLbl.Text = string.format("%.1fs", newDelay)
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            updateSlider(i.Position.X)
        end
    end)
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(i.Position.X)
        end
    end)

    -- Toggle logic
    local function setEnabled(state)
        featureState.enabled = state
        if state then
            tween(toggleBg, fast, { BackgroundColor3 = T.Green })
            tween(knob,     fast, { Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255,255,255) })
            tween(dot,      fast, { BackgroundColor3 = T.Green })
            tween(row,      fast, { BackgroundColor3 = T.SurfaceHi })
            showNotif("✅  " .. label .. "  →  ON", T.Green)
            if featureState.thread then task.cancel(featureState.thread) end
            featureState.thread = task.spawn(function()
                while featureState.enabled do
                    local ok, err = pcall(onEnable)
                    if not ok then warn("[EnzoHub] " .. label .. ": " .. tostring(err)) end
                    task.wait(featureState.delay)
                end
            end)
        else
            tween(toggleBg, fast, { BackgroundColor3 = T.Border })
            tween(knob,     fast, { Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = T.TextSec })
            tween(dot,      fast, { BackgroundColor3 = T.Red })
            tween(row,      fast, { BackgroundColor3 = T.Surface })
            showNotif("🔴  " .. label .. "  →  OFF", T.Red)
            if featureState.thread then
                task.cancel(featureState.thread)
                featureState.thread = nil
            end
            if onDisable then pcall(onDisable) end
        end
        updateStatus()
    end

    local toggleBtn = inst("TextButton", {
        Size             = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text             = "",
        ZIndex           = 8,
    }, toggleBg)
    toggleBtn.MouseButton1Click:Connect(function()
        setEnabled(not featureState.enabled)
    end)

    row.MouseEnter:Connect(function()
        if not featureState.enabled then
            tween(row, fast, { BackgroundColor3 = Color3.fromRGB(23, 26, 32) })
        end
    end)
    row.MouseLeave:Connect(function()
        if not featureState.enabled then
            tween(row, fast, { BackgroundColor3 = T.Surface })
        end
    end)

    return featureState
end

------------------------------------------------------------------------
-- REMOTE SHORTCUTS
------------------------------------------------------------------------
local RS  = ReplicatedStorage
local Rem = RS:WaitForChild("Remotes")
local Pkg = RS:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_knit@1.7.0")
    :WaitForChild("knit")
    :WaitForChild("Services")

------------------------------------------------------------------------
-- ══════════════════  AUTO TAB  ════════════════════════════════════
------------------------------------------------------------------------
makeHeader(AutoFrame, 0, "  CLICK & PROGRESS")

makeToggleRow(AutoFrame, 1, "🖱️", "Auto Finish Click",
    "Fires UpdateProgress(100) to finish clicks instantly",
    function()
        Rem:WaitForChild("UpdateProgress"):FireServer(100)
    end, nil, 0.5)

makeHeader(AutoFrame, 9, "  PETS")

makeToggleRow(AutoFrame, 10, "🧬", "Auto Breed Pets",
    "Sends breed request for first 2 pets in pen",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local pf = pen:FindFirstChild("Pets")
        if not pf then return end
        local pets = pf:GetChildren()
        if #pets < 2 then return end
        local p1 = pets[1].PrimaryPart and pets[1].PrimaryPart.Position or Vector3.new(30,12,-3067)
        local p2 = pets[2].PrimaryPart and pets[2].PrimaryPart.Position or Vector3.new(11,12,-3034)
        Rem:WaitForChild("breedRequest"):InvokeServer(pets[1], pets[2], p1, p2)
    end, nil, 1.0)

makeToggleRow(AutoFrame, 11, "🌾", "Auto Feed Pet",
    "Feeds each pet with Hay (amount: 10)",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local pf = pen:FindFirstChild("Pets")
        if not pf then return end
        for _, pet in ipairs(pf:GetChildren()) do
            Pkg:WaitForChild("FoodService"):WaitForChild("RF")
               :WaitForChild("FeedPet"):InvokeServer("Hay", pet.Name, 10)
            task.wait(0.1)
        end
    end, nil, 2.0)

makeToggleRow(AutoFrame, 12, "💰", "Auto Sell Pet",
    "Sells all pets currently in your pen",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local pf = pen:FindFirstChild("Pets")
        if not pf then return end
        for _, pet in ipairs(pf:GetChildren()) do
            Rem:WaitForChild("sellPet"):InvokeServer(pet.Name, false)
            task.wait(0.1)
        end
    end, nil, 1.5)

makeHeader(AutoFrame, 19, "  EGGS")

makeToggleRow(AutoFrame, 20, "🥚", "Auto Hatch Egg",
    "Triggers egg flicker for all eggs in pen",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local ef = pen:FindFirstChild("Eggs")
        if not ef then return end
        for _, egg in ipairs(ef:GetChildren()) do
            local pos = egg.PrimaryPart and egg.PrimaryPart.Position or Vector3.new(20,12,-3050)
            Pkg:WaitForChild("TimerService"):WaitForChild("RF")
               :WaitForChild("StartEggFlicker"):InvokeServer(egg.Name, pos)
            task.wait(0.15)
        end
    end, nil, 1.0)

makeToggleRow(AutoFrame, 21, "🛒", "Auto Sell Egg",
    "Sells all eggs currently in your pen",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local ef = pen:FindFirstChild("Eggs")
        if not ef then return end
        for _, egg in ipairs(ef:GetChildren()) do
            Rem:WaitForChild("sellEgg"):InvokeServer(egg.Name, false)
            task.wait(0.1)
        end
    end, nil, 1.5)

makeToggleRow(AutoFrame, 22, "🗑️", "Auto Remove Egg",
    "Picks up and removes all eggs from pen",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local ef = pen:FindFirstChild("Eggs")
        if not ef then return end
        for _, egg in ipairs(ef:GetChildren()) do
            local dummy = Instance.new("Model")
            Rem:WaitForChild("pickupRequest"):InvokeServer("Egg", egg.Name, dummy)
            dummy:Destroy()
            task.wait(0.1)
        end
    end, nil, 1.5)

makeHeader(AutoFrame, 29, "  ECONOMY")

makeToggleRow(AutoFrame, 30, "💵", "Auto Collect Cash",
    "Collects all pet cash income automatically",
    function()
        Rem:WaitForChild("collectAllPetCash"):FireServer()
    end, nil, 0.8)

makeToggleRow(AutoFrame, 31, "🛍️", "Auto Buy Merchant",
    "Buys Sand Totem ×7 from the merchant",
    function()
        Rem:WaitForChild("BuyMerchant"):FireServer(7, "Sand Totem")
    end, nil, 2.0)

------------------------------------------------------------------------
-- ══════════════════  MAIN TAB  ════════════════════════════════════
------------------------------------------------------------------------
makeHeader(MainTabFrame, 0, "  LASSO SHOP")

------------------------------------------------------------------------
-- LASSO CARD  (with custom dropdown)
------------------------------------------------------------------------
local selectedLasso = LASSOS[1]   -- default selection
local dropdownOpen  = false

local lassoCard = inst("Frame", {
    Size             = UDim2.new(1, 0, 0, 130),
    BackgroundColor3 = T.Surface,
    BorderSizePixel  = 0,
    LayoutOrder      = 1,
    ZIndex           = 3,
    ClipsDescendants = false,
}, MainTabFrame)
corner(8, lassoCard)
uistroke(lassoCard, T.Border, 1)

-- Card header
inst("TextLabel", {
    Size             = UDim2.new(1, -20, 0, 22),
    Position         = UDim2.new(0, 14, 0, 12),
    BackgroundTransparency = 1,
    Text             = "🪢  Buy Lasso",
    TextColor3       = T.TextPri,
    Font             = Enum.Font.GothamBold,
    TextSize         = 14,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 4,
}, lassoCard)

inst("TextLabel", {
    Size             = UDim2.new(1, -20, 0, 13),
    Position         = UDim2.new(0, 14, 0, 36),
    BackgroundTransparency = 1,
    Text             = "Select a lasso then press BUY",
    TextColor3       = T.TextSec,
    Font             = Enum.Font.Gotham,
    TextSize         = 10,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 4,
}, lassoCard)

-- ── Dropdown ──────────────────────────────────────────────────────
local dropBtn = inst("Frame", {
    Size             = UDim2.new(1, -20, 0, 32),
    Position         = UDim2.new(0, 10, 0, 56),
    BackgroundColor3 = T.Dropdown,
    BorderSizePixel  = 0,
    ZIndex           = 5,
    ClipsDescendants = false,
}, lassoCard)
corner(8, dropBtn)
uistroke(dropBtn, T.Border, 1)

-- Selected label
local selectedLabel = inst("TextLabel", {
    Size             = UDim2.new(1, -36, 1, 0),
    Position         = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1,
    Text             = selectedLasso,
    TextColor3       = T.TextPri,
    Font             = Enum.Font.Gotham,
    TextSize         = 12,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 6,
}, dropBtn)

-- Arrow icon
local arrowLbl = inst("TextLabel", {
    Size             = UDim2.fromOffset(24, 24),
    Position         = UDim2.new(1, -28, 0.5, -12),
    BackgroundTransparency = 1,
    Text             = "▾",
    TextColor3       = T.TextSec,
    Font             = Enum.Font.GothamBold,
    TextSize         = 14,
    ZIndex           = 6,
}, dropBtn)

-- Dropdown list frame (appears above/below)
local dropList = inst("Frame", {
    Size             = UDim2.new(1, 0, 0, 0),
    Position         = UDim2.new(0, 0, 1, 4),
    BackgroundColor3 = T.Dropdown,
    BorderSizePixel  = 0,
    ZIndex           = 50,
    Visible          = false,
    ClipsDescendants = true,
}, dropBtn)
corner(8, dropList)
uistroke(dropList, T.Accent, 1)

local dropScroll = inst("ScrollingFrame", {
    Size                 = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel      = 0,
    ScrollBarThickness   = 3,
    ScrollBarImageColor3 = T.Border,
    CanvasSize           = UDim2.new(0, 0, 0, #LASSOS * 30),
    ZIndex               = 51,
}, dropList)

inst("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding   = UDim.new(0, 0),
}, dropScroll)

-- Build option rows
for i, name in ipairs(LASSOS) do
    local optBtn = inst("TextButton", {
        Size             = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = T.Dropdown,
        BackgroundTransparency = 0,
        Text             = "",
        BorderSizePixel  = 0,
        LayoutOrder      = i,
        ZIndex           = 52,
        AutoButtonColor  = false,
    }, dropScroll)

    inst("TextLabel", {
        Size             = UDim2.new(1, -14, 1, 0),
        Position         = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text             = name,
        TextColor3       = T.TextPri,
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 53,
    }, optBtn)

    -- Divider (not on last item)
    if i < #LASSOS then
        inst("Frame", {
            Size             = UDim2.new(1, -20, 0, 1),
            Position         = UDim2.new(0, 10, 1, -1),
            BackgroundColor3 = T.Border,
            BorderSizePixel  = 0,
            ZIndex           = 53,
        }, optBtn)
    end

    optBtn.MouseEnter:Connect(function()
        tween(optBtn, fast, { BackgroundColor3 = T.SurfaceHi })
    end)
    optBtn.MouseLeave:Connect(function()
        tween(optBtn, fast, { BackgroundColor3 = T.Dropdown })
    end)
    optBtn.MouseButton1Click:Connect(function()
        selectedLasso      = name
        selectedLabel.Text = name
        -- Close dropdown
        dropdownOpen = false
        tween(dropList, fast, { Size = UDim2.new(1, 0, 0, 0) })
        tween(arrowLbl, fast, { Rotation = 0 })
        task.delay(0.18, function() dropList.Visible = false end)
        showNotif("🪢  Selected: " .. name, T.Accent)
    end)
end

-- Dropdown toggle button (invisible, over dropBtn)
local dropToggleBtn = inst("TextButton", {
    Size             = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text             = "",
    ZIndex           = 7,
}, dropBtn)

local DROP_MAX_H = math.min(#LASSOS * 30, 180)

dropToggleBtn.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    if dropdownOpen then
        dropList.Visible = true
        tween(dropList, medium, { Size = UDim2.new(1, 0, 0, DROP_MAX_H) })
        tween(arrowLbl, fast,   { Rotation = 180 })
    else
        tween(dropList, fast, { Size = UDim2.new(1, 0, 0, 0) })
        tween(arrowLbl, fast, { Rotation = 0 })
        task.delay(0.18, function() dropList.Visible = false end)
    end
end)

-- ── Buy Button ────────────────────────────────────────────────────
local buyBtn = inst("TextButton", {
    Size             = UDim2.new(1, -20, 0, 32),
    Position         = UDim2.new(0, 10, 0, 94),
    BackgroundColor3 = T.Accent,
    Text             = "BUY LASSO",
    TextColor3       = Color3.fromRGB(255, 255, 255),
    Font             = Enum.Font.GothamBold,
    TextSize         = 13,
    BorderSizePixel  = 0,
    AutoButtonColor  = false,
    ZIndex           = 4,
}, lassoCard)
corner(8, buyBtn)

-- Shine overlay
local shine = inst("Frame", {
    Size             = UDim2.new(0.4, 0, 1, 0),
    Position         = UDim2.new(-0.4, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.85,
    BorderSizePixel  = 0,
    ZIndex           = 5,
}, buyBtn)
corner(8, shine)

local lassoCd = false

local function animateShine()
    shine.Position = UDim2.new(-0.4, 0, 0, 0)
    tween(shine, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Position = UDim2.new(1.4, 0, 0, 0) })
end

buyBtn.MouseButton1Click:Connect(function()
    if lassoCd then return end
    lassoCd = true

    -- Close dropdown if open
    if dropdownOpen then
        dropdownOpen = false
        tween(dropList, fast, { Size = UDim2.new(1, 0, 0, 0) })
        tween(arrowLbl, fast, { Rotation = 0 })
        task.delay(0.18, function() dropList.Visible = false end)
    end

    tween(buyBtn, fast, { BackgroundColor3 = T.AccentDim })
    buyBtn.Text = "Buying..."

    local ok, err = pcall(function()
        Pkg:WaitForChild("LassoService"):WaitForChild("RE")
           :WaitForChild("BuyLasso"):FireServer(selectedLasso)
    end)

    if ok then
        animateShine()
        showNotif("✅  Bought: " .. selectedLasso, T.Green)
        buyBtn.Text = "✓  PURCHASED"
        tween(buyBtn, fast, { BackgroundColor3 = T.Green })
    else
        showNotif("❌  Failed: " .. selectedLasso, T.Red)
        buyBtn.Text = "✕  FAILED"
        tween(buyBtn, fast, { BackgroundColor3 = T.Red })
        warn("[EnzoHub] BuyLasso: " .. tostring(err))
    end

    task.delay(2.2, function()
        buyBtn.Text = "BUY LASSO"
        tween(buyBtn, medium, { BackgroundColor3 = T.Accent })
        lassoCd = false
    end)
end)

buyBtn.MouseEnter:Connect(function()
    if not lassoCd then tween(buyBtn, fast, { BackgroundColor3 = Color3.fromRGB(110, 185, 255) }) end
end)
buyBtn.MouseLeave:Connect(function()
    if not lassoCd then tween(buyBtn, fast, { BackgroundColor3 = T.Accent }) end
end)

------------------------------------------------------------------------
-- TAB BUTTONS
------------------------------------------------------------------------
local AutoTabBtn = inst("TextButton", {
    Size             = UDim2.new(0.5, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "⚙  AUTOMATICALLY",
    TextColor3       = T.TextPri,
    Font             = Enum.Font.GothamBold,
    TextSize         = 11,
    LayoutOrder      = 1,
    ZIndex           = 6,
}, TabBar)

local MainTabBtn = inst("TextButton", {
    Size             = UDim2.new(0.5, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "🏠  MAIN",
    TextColor3       = T.TextSec,
    Font             = Enum.Font.GothamBold,
    TextSize         = 11,
    LayoutOrder      = 2,
    ZIndex           = 6,
}, TabBar)

local activeTab = "AUTO"
local function switchTab(tab)
    activeTab = tab
    if tab == "AUTO" then
        AutoFrame.Visible    = true
        MainTabFrame.Visible = false
        tween(AutoTabBtn,   fast, { TextColor3 = T.TextPri })
        tween(MainTabBtn,   fast, { TextColor3 = T.TextSec })
        tween(TabIndicator, medium, { Position = UDim2.new(0, 0, 1, -2) })
    else
        AutoFrame.Visible    = false
        MainTabFrame.Visible = true
        tween(AutoTabBtn,   fast, { TextColor3 = T.TextSec })
        tween(MainTabBtn,   fast, { TextColor3 = T.TextPri })
        tween(TabIndicator, medium, { Position = UDim2.new(0.5, 0, 1, -2) })
    end
end

AutoTabBtn.MouseButton1Click:Connect(function() switchTab("AUTO") end)
MainTabBtn.MouseButton1Click:Connect(function() switchTab("MAIN") end)
AutoTabBtn.MouseEnter:Connect(function()
    if activeTab ~= "AUTO" then tween(AutoTabBtn, fast, { TextColor3 = T.TextPri }) end
end)
AutoTabBtn.MouseLeave:Connect(function()
    if activeTab ~= "AUTO" then tween(AutoTabBtn, fast, { TextColor3 = T.TextSec }) end
end)
MainTabBtn.MouseEnter:Connect(function()
    if activeTab ~= "MAIN" then tween(MainTabBtn, fast, { TextColor3 = T.TextPri }) end
end)
MainTabBtn.MouseLeave:Connect(function()
    if activeTab ~= "MAIN" then tween(MainTabBtn, fast, { TextColor3 = T.TextSec }) end
end)

switchTab("AUTO")

------------------------------------------------------------------------
-- OPEN ANIMATION
------------------------------------------------------------------------
MainFrame.Size                   = UDim2.fromOffset(WIN_W, 0)
MainFrame.BackgroundTransparency = 1
tween(MainFrame, medium, {
    Size                   = UDim2.fromOffset(WIN_W, WIN_H),
    BackgroundTransparency = 0,
})

------------------------------------------------------------------------
-- WELCOME NOTIFICATION
------------------------------------------------------------------------
task.delay(0.5, function()
    showNotif("⚡  Enzo Hub  v2.0  loaded!", T.Accent)
end)

print("[EnzoHub] ✅ Script loaded successfully.")
