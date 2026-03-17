--[[
╔═══════════════════════════════════════════════════════════════════╗
║                    ENZO HUB  ·  v2.0  (Luau)                     ║
║         Fixed: Drag · Content Visible · Dropdown Working          ║
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
local STATUS_H   = 48

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

local function stroke(p, color, thick)
    inst("UIStroke", {
        Color = color or T.Border,
        Thickness = thick or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, p)
end

local function tw(obj, info, goals)
    TweenService:Create(obj, info, goals):Play()
end

local fast   = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

------------------------------------------------------------------------
-- CLEANUP
------------------------------------------------------------------------
if LocalPlayer.PlayerGui:FindFirstChild("EnzoHub") then
    LocalPlayer.PlayerGui.EnzoHub:Destroy()
end

------------------------------------------------------------------------
-- SCREEN GUI
------------------------------------------------------------------------
local Gui = inst("ScreenGui", {
    Name           = "EnzoHub",
    ResetOnSpawn   = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
}, LocalPlayer.PlayerGui)

------------------------------------------------------------------------
-- MAIN FRAME  — NO ClipsDescendants so dropdown can overflow
------------------------------------------------------------------------
local Main = inst("Frame", {
    Size             = UDim2.fromOffset(WIN_W, WIN_H),
    Position         = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
    BackgroundColor3 = T.BG,
    BorderSizePixel  = 0,
    ClipsDescendants = false,   -- IMPORTANT: keeps dropdown visible
}, Gui)
corner(10, Main)
stroke(Main, T.Border, 1)

-- Top accent line (drawn directly on Main, ZIndex keeps it on top)
local topBar = inst("Frame", {
    Size             = UDim2.new(1, 0, 0, 2),
    Position         = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = T.Accent,
    BorderSizePixel  = 0,
    ZIndex           = 8,
}, Main)
corner(10, topBar)
inst("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   T.Accent),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 200, 255)),
        ColorSequenceKeypoint.new(1,   T.Accent),
    }),
}, topBar)

------------------------------------------------------------------------
-- TITLE BAR
------------------------------------------------------------------------
local TitleBar = inst("Frame", {
    Size             = UDim2.new(1, 0, 0, TITLE_H),
    Position         = UDim2.new(0, 0, 0, 2),
    BackgroundColor3 = T.TitleBar,
    BorderSizePixel  = 0,
    ZIndex           = 5,
}, Main)

-- Logo dot
local dot = inst("Frame", {
    Size             = UDim2.fromOffset(8, 8),
    Position         = UDim2.new(0, 12, 0.5, -4),
    BackgroundColor3 = T.Accent,
    BorderSizePixel  = 0,
    ZIndex           = 6,
}, TitleBar)
corner(4, dot)

inst("TextLabel", {
    Size             = UDim2.new(1, -120, 1, 0),
    Position         = UDim2.new(0, 26, 0, 0),
    BackgroundTransparency = 1,
    Text             = "ENZO HUB",
    TextColor3       = T.TextPri,
    Font             = Enum.Font.GothamBold,
    TextSize         = 14,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 6,
}, TitleBar)

-- Version badge
local vbg = inst("Frame", {
    Size             = UDim2.fromOffset(38, 18),
    Position         = UDim2.new(0, 115, 0.5, -9),
    BackgroundColor3 = T.AccentDim,
    BorderSizePixel  = 0,
    ZIndex           = 6,
}, TitleBar)
corner(4, vbg)
inst("TextLabel", {
    Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
    Text = "v2.0", TextColor3 = T.Accent,
    Font = Enum.Font.GothamBold, TextSize = 10, ZIndex = 7,
}, vbg)

-- Minimize
local MinBtn = inst("TextButton", {
    Size = UDim2.fromOffset(26,26), Position = UDim2.new(1,-62,0.5,-13),
    BackgroundColor3 = Color3.fromRGB(55,48,18), Text = "─",
    TextColor3 = T.Yellow, Font = Enum.Font.GothamBold, TextSize = 12,
    BorderSizePixel = 0, ZIndex = 6, AutoButtonColor = false,
}, TitleBar)
corner(6, MinBtn)

-- Close
local CloseBtn = inst("TextButton", {
    Size = UDim2.fromOffset(26,26), Position = UDim2.new(1,-32,0.5,-13),
    BackgroundColor3 = Color3.fromRGB(55,22,24), Text = "✕",
    TextColor3 = T.Red, Font = Enum.Font.GothamBold, TextSize = 12,
    BorderSizePixel = 0, ZIndex = 6, AutoButtonColor = false,
}, TitleBar)
corner(6, CloseBtn)

CloseBtn.MouseEnter:Connect(function() tw(CloseBtn, fast, {BackgroundColor3=T.Red, TextColor3=Color3.new(1,1,1)}) end)
CloseBtn.MouseLeave:Connect(function() tw(CloseBtn, fast, {BackgroundColor3=Color3.fromRGB(55,22,24), TextColor3=T.Red}) end)
CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)

MinBtn.MouseEnter:Connect(function() tw(MinBtn, fast, {BackgroundColor3=T.Yellow, TextColor3=Color3.fromRGB(20,20,20)}) end)
MinBtn.MouseLeave:Connect(function() tw(MinBtn, fast, {BackgroundColor3=Color3.fromRGB(55,48,18), TextColor3=T.Yellow}) end)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tw(Main, medium, {Size = UDim2.fromOffset(WIN_W, minimized and (TITLE_H + TAB_H + 4) or WIN_H)})
end)

------------------------------------------------------------------------
-- DRAG  — attached directly to TitleBar on Main (no InnerClip)
------------------------------------------------------------------------
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos  = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                   startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

------------------------------------------------------------------------
-- TAB BAR
------------------------------------------------------------------------
local TabBar = inst("Frame", {
    Size = UDim2.new(1,0,0,TAB_H),
    Position = UDim2.new(0,0,0,TITLE_H+2),
    BackgroundColor3 = T.TitleBar,
    BorderSizePixel = 0, ZIndex = 5,
}, Main)
inst("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, SortOrder=Enum.SortOrder.LayoutOrder}, TabBar)

local TabLine = inst("Frame", {
    Size = UDim2.new(0.5,0,0,2),
    Position = UDim2.new(0,0,1,-2),
    BackgroundColor3 = T.Accent,
    BorderSizePixel = 0, ZIndex = 7,
}, TabBar)

------------------------------------------------------------------------
-- CONTENT AREA
------------------------------------------------------------------------
local CY = TITLE_H + 2 + TAB_H
local CH = WIN_H - CY - STATUS_H - 8

-- We need ClipsDescendants TRUE here to clip the scrolling content,
-- but the dropdown lives OUTSIDE this frame (parented to Main directly)
local ContentClip = inst("Frame", {
    Size = UDim2.new(1,0,0,CH),
    Position = UDim2.new(0,0,0,CY),
    BackgroundTransparency = 1,
    ClipsDescendants = true,   -- clips scroll content only
    ZIndex = 2,
}, Main)

local function makeScroll()
    local sf = inst("ScrollingFrame", {
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = T.Border,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 2,
    })
    inst("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,4)}, sf)
    inst("UIPadding", {
        PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,8),
        PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10),
    }, sf)
    return sf
end

local AutoScroll = makeScroll()
AutoScroll.Parent = ContentClip

local MainScroll = makeScroll()
MainScroll.Parent   = ContentClip
MainScroll.Visible  = false

------------------------------------------------------------------------
-- NOTIFICATIONS
------------------------------------------------------------------------
local NotifHolder = inst("Frame", {
    Size = UDim2.new(0,240,1,0),
    Position = UDim2.new(1,10,0,0),
    BackgroundTransparency = 1,
    ZIndex = 30,
}, Main)
inst("UIListLayout", {
    SortOrder=Enum.SortOrder.LayoutOrder,
    VerticalAlignment=Enum.VerticalAlignment.Bottom,
    Padding=UDim.new(0,5),
}, NotifHolder)

local nOrder = 0
local function notify(msg, color)
    color  = color or T.Accent
    nOrder = nOrder + 1
    local f = inst("Frame", {
        Size = UDim2.new(1,0,0,38),
        BackgroundColor3 = T.Surface,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = nOrder, ZIndex = 31,
    }, NotifHolder)
    corner(7, f)
    stroke(f, color, 1)
    inst("Frame", {Size=UDim2.new(0,3,1,0), BackgroundColor3=color, BorderSizePixel=0, ZIndex=32}, f)
    inst("TextLabel", {
        Size=UDim2.new(1,-14,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1, Text=msg, TextColor3=T.TextPri,
        Font=Enum.Font.Gotham, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, ZIndex=32,
    }, f)
    tw(f, fast, {BackgroundTransparency=0})
    task.delay(NOTIF_TIME, function()
        tw(f, medium, {BackgroundTransparency=1})
        task.delay(0.3, function() f:Destroy() end)
    end)
end

------------------------------------------------------------------------
-- STATUS PANEL
------------------------------------------------------------------------
local StatusBar = inst("Frame", {
    Size = UDim2.new(1,-20,0,STATUS_H-10),
    Position = UDim2.new(0,10,1,-(STATUS_H-2)),
    BackgroundColor3 = T.Surface,
    BorderSizePixel = 0, ZIndex = 5,
}, Main)
corner(8, StatusBar)
stroke(StatusBar, T.Border, 1)

inst("TextLabel", {
    Size=UDim2.new(0,62,1,0), Position=UDim2.new(0,10,0,0),
    BackgroundTransparency=1, Text="ACTIVE:",
    TextColor3=T.TextSec, Font=Enum.Font.GothamBold,
    TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6,
}, StatusBar)

local StatusTxt = inst("TextLabel", {
    Size=UDim2.new(1,-75,1,0), Position=UDim2.new(0,68,0,0),
    BackgroundTransparency=1, Text="None",
    TextColor3=T.TextSec, Font=Enum.Font.Gotham,
    TextSize=10, TextXAlignment=Enum.TextXAlignment.Left,
    TextWrapped=true, ZIndex=6,
}, StatusBar)

_G.EnzoFeatures = {}
local function updateStatus()
    local a = {}
    for _, f in ipairs(_G.EnzoFeatures) do
        if f.enabled then a[#a+1] = f.label end
    end
    StatusTxt.Text       = #a > 0 and table.concat(a,"  ·  ") or "None"
    StatusTxt.TextColor3 = #a > 0 and T.Green or T.TextSec
end

------------------------------------------------------------------------
-- SECTION HEADER
------------------------------------------------------------------------
local function mkHeader(parent, order, text)
    local h = inst("Frame", {Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, LayoutOrder=order}, parent)
    inst("TextLabel", {
        Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
        Text=text, TextColor3=T.TextSec, Font=Enum.Font.GothamBold,
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left,
    }, h)
    inst("Frame", {
        Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
        BackgroundColor3=T.Border, BorderSizePixel=0,
    }, h)
end

------------------------------------------------------------------------
-- TOGGLE ROW
------------------------------------------------------------------------
local function mkToggle(parent, order, icon, label, desc, onOn, onOff, defDelay)
    defDelay = defDelay or 0.5
    local fs = {label=label, enabled=false, delay=defDelay, thread=nil}
    table.insert(_G.EnzoFeatures, fs)

    local row = inst("Frame", {
        Size=UDim2.new(1,0,0,ROW_H), BackgroundColor3=T.Surface,
        BorderSizePixel=0, LayoutOrder=order, ZIndex=3,
    }, parent)
    corner(8, row)
    stroke(row, T.Border, 1)

    inst("TextLabel", {
        Size=UDim2.fromOffset(28,28), Position=UDim2.new(0,10,0,8),
        BackgroundTransparency=1, Text=icon, TextSize=17,
        Font=Enum.Font.GothamBold, TextColor3=T.TextPri, ZIndex=4,
    }, row)
    inst("TextLabel", {
        Size=UDim2.new(1,-130,0,18), Position=UDim2.new(0,44,0,7),
        BackgroundTransparency=1, Text=label, TextColor3=T.TextPri,
        Font=Enum.Font.GothamBold, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
    }, row)
    inst("TextLabel", {
        Size=UDim2.new(1,-130,0,13), Position=UDim2.new(0,44,0,27),
        BackgroundTransparency=1, Text=desc, TextColor3=T.TextSec,
        Font=Enum.Font.Gotham, TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
    }, row)

    -- Toggle pill
    local pill = inst("Frame", {
        Size=UDim2.fromOffset(46,24), Position=UDim2.new(1,-56,0,12),
        BackgroundColor3=T.Border, BorderSizePixel=0, ZIndex=4,
    }, row)
    corner(12, pill)
    local knob = inst("Frame", {
        Size=UDim2.fromOffset(18,18), Position=UDim2.new(0,3,0.5,-9),
        BackgroundColor3=T.TextSec, BorderSizePixel=0, ZIndex=5,
    }, pill)
    corner(9, knob)
    local sdot = inst("Frame", {
        Size=UDim2.fromOffset(7,7), Position=UDim2.new(1,-57,0,14),
        BackgroundColor3=T.Red, BorderSizePixel=0, ZIndex=4,
    }, row)
    corner(4, sdot)

    -- Delay slider
    local sr = inst("Frame", {
        Size=UDim2.new(1,-20,0,16), Position=UDim2.new(0,10,0,ROW_H-22),
        BackgroundTransparency=1, ZIndex=4,
    }, row)
    inst("TextLabel", {
        Size=UDim2.fromOffset(38,16), BackgroundTransparency=1,
        Text="Delay:", TextColor3=T.TextSec, Font=Enum.Font.Gotham,
        TextSize=9, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=5,
    }, sr)
    local trk = inst("Frame", {
        Size=UDim2.new(1,-100,0,4), Position=UDim2.new(0,44,0.5,-2),
        BackgroundColor3=T.Border, BorderSizePixel=0, ZIndex=5,
    }, sr)
    corner(2, trk)
    local fil = inst("Frame", {
        Size=UDim2.new(defDelay/2,0,1,0), BackgroundColor3=T.Accent,
        BorderSizePixel=0, ZIndex=6,
    }, trk)
    corner(2, fil)
    local hdl = inst("Frame", {
        Size=UDim2.fromOffset(12,12), AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.new(defDelay/2,0,0.5,0),
        BackgroundColor3=T.TextPri, BorderSizePixel=0, ZIndex=7,
    }, trk)
    corner(6, hdl)
    local dlbl = inst("TextLabel", {
        Size=UDim2.fromOffset(50,16), Position=UDim2.new(1,-50,0,0),
        BackgroundTransparency=1, Text=string.format("%.1fs",defDelay),
        TextColor3=T.Accent, Font=Enum.Font.GothamBold,
        TextSize=9, TextXAlignment=Enum.TextXAlignment.Right, ZIndex=5,
    }, sr)

    local sliding = false
    local function doSlide(mx)
        local r = math.clamp((mx - trk.AbsolutePosition.X)/trk.AbsoluteSize.X, 0, 1)
        fs.delay = math.max(0.1, r*2)
        tw(fil, fast, {Size=UDim2.new(r,0,1,0)})
        tw(hdl, fast, {Position=UDim2.new(r,0,0.5,0)})
        dlbl.Text = string.format("%.1fs", fs.delay)
    end
    trk.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true doSlide(i.Position.X) end
    end)
    hdl.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then doSlide(i.Position.X) end
    end)

    -- Set state
    local function setState(on)
        fs.enabled = on
        if on then
            tw(pill, fast, {BackgroundColor3=T.Green})
            tw(knob, fast, {Position=UDim2.new(1,-21,0.5,-9), BackgroundColor3=Color3.new(1,1,1)})
            tw(sdot, fast, {BackgroundColor3=T.Green})
            tw(row,  fast, {BackgroundColor3=T.SurfaceHi})
            notify("✅  "..label.."  →  ON", T.Green)
            if fs.thread then task.cancel(fs.thread) end
            fs.thread = task.spawn(function()
                while fs.enabled do
                    local ok,err = pcall(onOn)
                    if not ok then warn("[EnzoHub] "..label..": "..tostring(err)) end
                    task.wait(fs.delay)
                end
            end)
        else
            tw(pill, fast, {BackgroundColor3=T.Border})
            tw(knob, fast, {Position=UDim2.new(0,3,0.5,-9), BackgroundColor3=T.TextSec})
            tw(sdot, fast, {BackgroundColor3=T.Red})
            tw(row,  fast, {BackgroundColor3=T.Surface})
            notify("🔴  "..label.."  →  OFF", T.Red)
            if fs.thread then task.cancel(fs.thread) fs.thread=nil end
            if onOff then pcall(onOff) end
        end
        updateStatus()
    end

    local tb = inst("TextButton", {
        Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
        Text="", ZIndex=8,
    }, pill)
    tb.MouseButton1Click:Connect(function() setState(not fs.enabled) end)

    row.MouseEnter:Connect(function()
        if not fs.enabled then tw(row, fast, {BackgroundColor3=Color3.fromRGB(23,26,32)}) end
    end)
    row.MouseLeave:Connect(function()
        if not fs.enabled then tw(row, fast, {BackgroundColor3=T.Surface}) end
    end)
end

------------------------------------------------------------------------
-- REMOTES
------------------------------------------------------------------------
local Rem = ReplicatedStorage:WaitForChild("Remotes")
local Pkg = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0")
    :WaitForChild("knit"):WaitForChild("Services")

------------------------------------------------------------------------
-- AUTO TAB FEATURES
------------------------------------------------------------------------
mkHeader(AutoScroll, 0,  "  CLICK & PROGRESS")

mkToggle(AutoScroll, 1, "🖱️", "Auto Finish Click",
    "Fires UpdateProgress(100) instantly",
    function() Rem:WaitForChild("UpdateProgress"):FireServer(100) end, nil, 0.5)

mkHeader(AutoScroll, 9,  "  PETS")

mkToggle(AutoScroll, 10, "🧬", "Auto Breed Pets",
    "Breeds first 2 pets found in pen",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local pf = pen:FindFirstChild("Pets"); if not pf then return end
        local p = pf:GetChildren(); if #p < 2 then return end
        local a = p[1].PrimaryPart and p[1].PrimaryPart.Position or Vector3.new(30,12,-3067)
        local b = p[2].PrimaryPart and p[2].PrimaryPart.Position or Vector3.new(11,12,-3034)
        Rem:WaitForChild("breedRequest"):InvokeServer(p[1],p[2],a,b)
    end, nil, 1.0)

mkToggle(AutoScroll, 11, "🌾", "Auto Feed Pet",
    "Feeds each pet with Hay (×10)",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local pf = pen:FindFirstChild("Pets"); if not pf then return end
        for _, pet in ipairs(pf:GetChildren()) do
            Pkg:WaitForChild("FoodService"):WaitForChild("RF")
               :WaitForChild("FeedPet"):InvokeServer("Hay", pet.Name, 10)
            task.wait(0.1)
        end
    end, nil, 2.0)

mkToggle(AutoScroll, 12, "💰", "Auto Sell Pet",
    "Sells all pets in your pen",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local pf = pen:FindFirstChild("Pets"); if not pf then return end
        for _, pet in ipairs(pf:GetChildren()) do
            Rem:WaitForChild("sellPet"):InvokeServer(pet.Name, false)
            task.wait(0.1)
        end
    end, nil, 1.5)

mkHeader(AutoScroll, 19, "  EGGS")

mkToggle(AutoScroll, 20, "🥚", "Auto Hatch Egg",
    "Triggers egg flicker for all eggs",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local ef = pen:FindFirstChild("Eggs"); if not ef then return end
        for _, egg in ipairs(ef:GetChildren()) do
            local pos = egg.PrimaryPart and egg.PrimaryPart.Position or Vector3.new(20,12,-3050)
            Pkg:WaitForChild("TimerService"):WaitForChild("RF")
               :WaitForChild("StartEggFlicker"):InvokeServer(egg.Name, pos)
            task.wait(0.15)
        end
    end, nil, 1.0)

mkToggle(AutoScroll, 21, "🛒", "Auto Sell Egg",
    "Sells all eggs in your pen",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local ef = pen:FindFirstChild("Eggs"); if not ef then return end
        for _, egg in ipairs(ef:GetChildren()) do
            Rem:WaitForChild("sellEgg"):InvokeServer(egg.Name, false)
            task.wait(0.1)
        end
    end, nil, 1.5)

mkToggle(AutoScroll, 22, "🗑️", "Auto Remove Egg",
    "Removes all eggs from pen",
    function()
        local pen = workspace:WaitForChild("PlayerPens"):FindFirstChild("1")
        if not pen then return end
        local ef = pen:FindFirstChild("Eggs"); if not ef then return end
        for _, egg in ipairs(ef:GetChildren()) do
            local dm = Instance.new("Model")
            Rem:WaitForChild("pickupRequest"):InvokeServer("Egg", egg.Name, dm)
            dm:Destroy(); task.wait(0.1)
        end
    end, nil, 1.5)

mkHeader(AutoScroll, 29, "  ECONOMY")

mkToggle(AutoScroll, 30, "💵", "Auto Collect Cash",
    "Collects all pet cash income",
    function() Rem:WaitForChild("collectAllPetCash"):FireServer() end, nil, 0.8)

mkToggle(AutoScroll, 31, "🛍️", "Auto Buy Merchant",
    "Buys Sand Totem ×7 from merchant",
    function() Rem:WaitForChild("BuyMerchant"):FireServer(7, "Sand Totem") end, nil, 2.0)

------------------------------------------------------------------------
-- MAIN TAB  —  LASSO CARD
------------------------------------------------------------------------
mkHeader(MainScroll, 0, "  LASSO SHOP")

local selectedLasso = LASSOS[1]
local dropOpen      = false

-- Card
local card = inst("Frame", {
    Size=UDim2.new(1,0,0,136), BackgroundColor3=T.Surface,
    BorderSizePixel=0, LayoutOrder=1, ZIndex=3,
    ClipsDescendants=false,
}, MainScroll)
corner(8, card)
stroke(card, T.Border, 1)

inst("TextLabel", {
    Size=UDim2.new(1,-20,0,20), Position=UDim2.new(0,14,0,10),
    BackgroundTransparency=1, Text="🪢  Buy Lasso",
    TextColor3=T.TextPri, Font=Enum.Font.GothamBold, TextSize=14,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
}, card)
inst("TextLabel", {
    Size=UDim2.new(1,-20,0,13), Position=UDim2.new(0,14,0,32),
    BackgroundTransparency=1, Text="Select a lasso then press BUY",
    TextColor3=T.TextSec, Font=Enum.Font.Gotham, TextSize=10,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
}, card)

-- Dropdown trigger button
local dropTrigger = inst("Frame", {
    Size=UDim2.new(1,-20,0,30), Position=UDim2.new(0,10,0,52),
    BackgroundColor3=T.Dropdown, BorderSizePixel=0, ZIndex=5,
    ClipsDescendants=false,
}, card)
corner(7, dropTrigger)
stroke(dropTrigger, T.Border, 1)

local selLbl = inst("TextLabel", {
    Size=UDim2.new(1,-34,1,0), Position=UDim2.new(0,10,0,0),
    BackgroundTransparency=1, Text=selectedLasso,
    TextColor3=T.TextPri, Font=Enum.Font.Gotham, TextSize=12,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6,
}, dropTrigger)

local arrow = inst("TextLabel", {
    Size=UDim2.fromOffset(22,22), Position=UDim2.new(1,-26,0.5,-11),
    BackgroundTransparency=1, Text="▾", TextColor3=T.TextSec,
    Font=Enum.Font.GothamBold, TextSize=14, ZIndex=6,
}, dropTrigger)

-- Dropdown list  — parented to Main so it's never clipped
local DROP_H    = math.min(#LASSOS * 28, 180)
local dropList  = inst("Frame", {
    Size=UDim2.fromOffset(0,0),
    BackgroundColor3=T.Dropdown,
    BorderSizePixel=0, ZIndex=60,
    Visible=false, ClipsDescendants=true,
}, Main)   -- parented to Main, NOT card or ContentClip
corner(8, dropList)
stroke(dropList, T.Accent, 1)

local dropScroll = inst("ScrollingFrame", {
    Size=UDim2.fromScale(1,1),
    BackgroundTransparency=1, BorderSizePixel=0,
    ScrollBarThickness=3, ScrollBarImageColor3=T.Border,
    CanvasSize=UDim2.new(0,0,0,#LASSOS*28), ZIndex=61,
}, dropList)
inst("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,0)}, dropScroll)

-- Position helper: update dropList position relative to Main each time it opens
local function positionDropList()
    local absPos  = dropTrigger.AbsolutePosition
    local mainAbs = Main.AbsolutePosition
    local relX    = absPos.X - mainAbs.X
    local relY    = absPos.Y - mainAbs.Y + dropTrigger.AbsoluteSize.Y + 4
    dropList.Position = UDim2.fromOffset(relX, relY)
    dropList.Size     = UDim2.fromOffset(dropTrigger.AbsoluteSize.X, 0)
end

-- Option rows
for i, name in ipairs(LASSOS) do
    local opt = inst("TextButton", {
        Size=UDim2.new(1,0,0,28), BackgroundColor3=T.Dropdown,
        BackgroundTransparency=0, Text="",
        BorderSizePixel=0, LayoutOrder=i, ZIndex=62, AutoButtonColor=false,
    }, dropScroll)
    inst("TextLabel", {
        Size=UDim2.new(1,-14,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1, Text=name,
        TextColor3=T.TextPri, Font=Enum.Font.Gotham, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=63,
    }, opt)
    if i < #LASSOS then
        inst("Frame", {
            Size=UDim2.new(1,-20,0,1), Position=UDim2.new(0,10,1,-1),
            BackgroundColor3=T.Border, BorderSizePixel=0, ZIndex=63,
        }, opt)
    end
    opt.MouseEnter:Connect(function() tw(opt, fast, {BackgroundColor3=T.SurfaceHi}) end)
    opt.MouseLeave:Connect(function() tw(opt, fast, {BackgroundColor3=T.Dropdown}) end)
    opt.MouseButton1Click:Connect(function()
        selectedLasso = name
        selLbl.Text   = name
        dropOpen      = false
        tw(dropList, fast, {Size=UDim2.fromOffset(dropTrigger.AbsoluteSize.X, 0)})
        tw(arrow, fast, {Rotation=0})
        task.delay(0.18, function() dropList.Visible=false end)
        notify("🪢  Selected: "..name, T.Accent)
    end)
end

-- Open / close dropdown
local dropBtn2 = inst("TextButton", {
    Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
    Text="", ZIndex=7,
}, dropTrigger)
dropBtn2.MouseButton1Click:Connect(function()
    dropOpen = not dropOpen
    if dropOpen then
        positionDropList()
        dropList.Size    = UDim2.fromOffset(dropTrigger.AbsoluteSize.X, 0)
        dropList.Visible = true
        tw(dropList, medium, {Size=UDim2.fromOffset(dropTrigger.AbsoluteSize.X, DROP_H)})
        tw(arrow, fast, {Rotation=180})
    else
        tw(dropList, fast, {Size=UDim2.fromOffset(dropTrigger.AbsoluteSize.X, 0)})
        tw(arrow, fast, {Rotation=0})
        task.delay(0.18, function() dropList.Visible=false end)
    end
end)

-- Buy button
local buyBtn = inst("TextButton", {
    Size=UDim2.new(1,-20,0,30), Position=UDim2.new(0,10,0,90),
    BackgroundColor3=T.Accent, Text="BUY LASSO",
    TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold,
    TextSize=13, BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
}, card)
corner(8, buyBtn)

local lassoCd = false
buyBtn.MouseButton1Click:Connect(function()
    if lassoCd then return end
    lassoCd = true
    if dropOpen then
        dropOpen = false
        tw(dropList, fast, {Size=UDim2.fromOffset(dropTrigger.AbsoluteSize.X, 0)})
        tw(arrow, fast, {Rotation=0})
        task.delay(0.18, function() dropList.Visible=false end)
    end
    tw(buyBtn, fast, {BackgroundColor3=T.AccentDim})
    buyBtn.Text = "Buying..."
    local ok, err = pcall(function()
        Pkg:WaitForChild("LassoService"):WaitForChild("RE")
           :WaitForChild("BuyLasso"):FireServer(selectedLasso)
    end)
    if ok then
        notify("✅  Bought: "..selectedLasso, T.Green)
        buyBtn.Text = "✓  PURCHASED"
        tw(buyBtn, fast, {BackgroundColor3=T.Green})
    else
        notify("❌  Failed: "..selectedLasso, T.Red)
        buyBtn.Text = "✕  FAILED"
        tw(buyBtn, fast, {BackgroundColor3=T.Red})
        warn("[EnzoHub] BuyLasso: "..tostring(err))
    end
    task.delay(2.2, function()
        buyBtn.Text = "BUY LASSO"
        tw(buyBtn, medium, {BackgroundColor3=T.Accent})
        lassoCd = false
    end)
end)
buyBtn.MouseEnter:Connect(function()
    if not lassoCd then tw(buyBtn, fast, {BackgroundColor3=Color3.fromRGB(110,185,255)}) end
end)
buyBtn.MouseLeave:Connect(function()
    if not lassoCd then tw(buyBtn, fast, {BackgroundColor3=T.Accent}) end
end)

------------------------------------------------------------------------
-- TAB BUTTONS
------------------------------------------------------------------------
local AutoTab = inst("TextButton", {
    Size=UDim2.new(0.5,0,1,0), BackgroundTransparency=1,
    Text="⚙  AUTOMATICALLY", TextColor3=T.TextPri,
    Font=Enum.Font.GothamBold, TextSize=11,
    LayoutOrder=1, ZIndex=6,
}, TabBar)

local MainTab = inst("TextButton", {
    Size=UDim2.new(0.5,0,1,0), BackgroundTransparency=1,
    Text="🏠  MAIN", TextColor3=T.TextSec,
    Font=Enum.Font.GothamBold, TextSize=11,
    LayoutOrder=2, ZIndex=6,
}, TabBar)

local activeTab = "AUTO"
local function switchTab(t)
    activeTab = t
    if t == "AUTO" then
        AutoScroll.Visible = true
        MainScroll.Visible = false
        tw(AutoTab, fast, {TextColor3=T.TextPri})
        tw(MainTab, fast, {TextColor3=T.TextSec})
        tw(TabLine, medium, {Position=UDim2.new(0,0,1,-2)})
    else
        AutoScroll.Visible = false
        MainScroll.Visible = true
        tw(AutoTab, fast, {TextColor3=T.TextSec})
        tw(MainTab, fast, {TextColor3=T.TextPri})
        tw(TabLine, medium, {Position=UDim2.new(0.5,0,1,-2)})
    end
end
AutoTab.MouseButton1Click:Connect(function() switchTab("AUTO") end)
MainTab.MouseButton1Click:Connect(function() switchTab("MAIN") end)
AutoTab.MouseEnter:Connect(function() if activeTab~="AUTO" then tw(AutoTab,fast,{TextColor3=T.TextPri}) end end)
AutoTab.MouseLeave:Connect(function() if activeTab~="AUTO" then tw(AutoTab,fast,{TextColor3=T.TextSec}) end end)
MainTab.MouseEnter:Connect(function() if activeTab~="MAIN" then tw(MainTab,fast,{TextColor3=T.TextPri}) end end)
MainTab.MouseLeave:Connect(function() if activeTab~="MAIN" then tw(MainTab,fast,{TextColor3=T.TextSec}) end end)
switchTab("AUTO")

------------------------------------------------------------------------
-- OPEN ANIMATION
------------------------------------------------------------------------
Main.Size                   = UDim2.fromOffset(WIN_W, 0)
Main.BackgroundTransparency = 1
tw(Main, medium, {Size=UDim2.fromOffset(WIN_W, WIN_H), BackgroundTransparency=0})

task.delay(0.5, function()
    notify("⚡  Enzo Hub  v2.0  loaded!", T.Accent)
end)

print("[EnzoHub] ✅ Loaded.")
