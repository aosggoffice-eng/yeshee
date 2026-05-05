

-- [[ AOSgg Hub - Premium Optimized for Delta Executor ]] --
-- [[ AOSgg Hub - Clean & Optimized Version ]] --
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // Protector Logic (Delta / Common Executors)
local Parent = (gethui and gethui()) or (protect_gui and protect_gui) or CoreGui

local Theme = {
    Main = Color3.fromRGB(20, 20, 20),
    Dark = Color3.fromRGB(15, 15, 15),
    Accent = Color3.fromRGB(255, 45, 45),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Section = Color3.fromRGB(35, 35, 35)
}

local Library = {}

-- // Utility: Animation Helper
function Library:Tween(obj, info, goal)
    if not obj then return end
    local t = TweenService:Create(obj, TweenInfo.new(info, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal)
    t:Play()
    return t
end

-- // Utility: Optimized Dragging
function Library:MakeDraggable(frame, parent)
    local dragging = false
    local dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- // Utility: Minimizer (ย้ายออกมาอยู่นอก CreateWindow)
function Library:CreateMinimizer(mainFrame)
    local miniGui = Parent:FindFirstChild("AOS_Minimizer") or Instance.new("ScreenGui", Parent)
    miniGui.Name = "AOS_Minimizer"
    miniGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local btn = miniGui:FindFirstChild("MiniBtn") or Instance.new("TextButton", miniGui)
    btn.Name = "MiniBtn"
    btn.Size = UDim2.new(0, 45, 0, 45)
    btn.Position = UDim2.new(0, 10, 0.5, -22)
    btn.BackgroundColor3 = Theme.Accent
    btn.Text = "AOS"
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    Library:MakeDraggable(btn, btn)

    local visible = true
    btn.MouseButton1Click:Connect(function()
        visible = not visible
        mainFrame.Visible = visible
    end)
end

function Library:Notify(title, text, duration)
    duration = duration or 3

    -- Holder
    local NotifHolder = Parent:FindFirstChild("AOS_NotifHolder")
    if not NotifHolder then
        NotifHolder = Instance.new("ScreenGui", Parent)
        NotifHolder.Name = "AOS_NotifHolder"
        NotifHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local layout = Instance.new("UIListLayout", NotifHolder)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0,8)
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    end

    -- Main Notif
    local Notif = Instance.new("Frame", NotifHolder)
    Notif.Size = UDim2.new(0, 280, 0, 75)
    Notif.BackgroundColor3 = Theme.Main
    Notif.BackgroundTransparency = 0.05
    Notif.ClipsDescendants = true
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0,10)

    local stroke = Instance.new("UIStroke", Notif)
    stroke.Color = Theme.Accent
    stroke.Transparency = 0.4

    -- Glow effect
    local glow = Instance.new("Frame", Notif)
    glow.Size = UDim2.new(1,0,1,0)
    glow.BackgroundColor3 = Theme.Accent
    glow.BackgroundTransparency = 0.92
    glow.ZIndex = 0
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0,10)

    -- Title
    local T = Instance.new("TextLabel", Notif)
    T.Text = "  "..title
    T.Size = UDim2.new(1,0,0,28)
    T.BackgroundTransparency = 1
    T.TextColor3 = Theme.Accent
    T.Font = Enum.Font.GothamBold
    T.TextSize = 14
    T.TextXAlignment = Enum.TextXAlignment.Left

    -- Description
    local D = Instance.new("TextLabel", Notif)
    D.Text = "  "..text
    D.Size = UDim2.new(1,-10,1,-30)
    D.Position = UDim2.new(0,0,0,28)
    D.BackgroundTransparency = 1
    D.TextColor3 = Theme.Text
    D.Font = Enum.Font.Gotham
    D.TextSize = 12
    D.TextWrapped = true
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.TextYAlignment = Enum.TextYAlignment.Top

    -- Progress Bar
    local barBg = Instance.new("Frame", Notif)
    barBg.Size = UDim2.new(1,0,0,3)
    barBg.Position = UDim2.new(0,0,1,-3)
    barBg.BackgroundColor3 = Color3.fromRGB(50,50,50)

    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.new(1,0,1,0)
    bar.BackgroundColor3 = Theme.Accent

    -- Sound
    local sound = Instance.new("Sound", Notif)
    sound.SoundId = "rbxassetid://113511836483750"
    sound.Volume = 1
    sound:Play()

    -- Start position (slide in)
    Notif.Position = UDim2.new(1, 300, 1, 0)
    Library:Tween(Notif, 0.4, {
        Position = UDim2.new(1, -10, 1, 0)
    })

    -- Animate progress bar
    Library:Tween(bar, duration, {
        Size = UDim2.new(0,0,1,0)
    })

    -- Auto remove
    task.delay(duration, function()
        Library:Tween(Notif, 0.3, {
            Position = UDim2.new(1, 300, 1, 0),
            BackgroundTransparency = 1
        })
        task.wait(0.3)
        if Notif then Notif:Destroy() end
    end)
end 

-- // Window Creator
function Library:CreateWindow(config)
    local Screen = Instance.new("ScreenGui", Parent)
    Screen.Name = "AOSgg_Hub"
    Screen.ResetOnSpawn = false
    Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame", Screen)
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- เริ่มเล็ก
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- กลางจอเป๊ะ
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Main
MainFrame.ClipsDescendants = true
MainFrame.BackgroundTransparency = 1 -- เริ่มโปร่ง
Instance.new("UICorner", MainFrame)
    
    local MS = Instance.new("UIStroke", MainFrame)
    MS.Color = Theme.Accent; MS.Thickness = 1.2
    
    -- Header (สร้างครั้งเดียว)
    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Theme.Dark
    local HeaderCorner = Instance.new("UICorner", Header)
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    Header.Position = UDim2.new(0, 0, 0, -40)
Header.BackgroundTransparency = 1

Library:Tween(Header, 0.4, {
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 0
})
    
    Library:MakeDraggable(Header, MainFrame)

    -- Subtitle (สร้างก่อน Title)
    local SubTitle = Instance.new("TextLabel", Header)
    SubTitle.Text = config.Subtitle or ""
    SubTitle.Size = UDim2.new(0, 200, 0, 15)
    SubTitle.Position = UDim2.new(0, 15, 0, 22)
    SubTitle.TextColor3 = Theme.TextDark
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 10
    SubTitle.BackgroundTransparency = 1
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left

    local Title = Instance.new("TextLabel", Header)
    Title.Text = config.Title or "AOSgg Hub"
    Title.Size = UDim2.new(0, 150, 0, 25)
    Title.Position = UDim2.new(0, 15, 0, 2)
    Title.TextColor3 = Theme.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Minimize & Close Buttons
    local IsMinimized = false
    local MinBtn = Instance.new("TextButton", Header)
    MinBtn.Text = "-"; MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -75, 0, 5)
    MinBtn.BackgroundColor3 = Theme.Section; MinBtn.TextColor3 = Theme.Text; MinBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", MinBtn)

    MinBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        Library:Tween(MainFrame, 0.4, {Size = IsMinimized and UDim2.new(0, 360, 0, 40) or UDim2.new(0, 360, 0, 240)})
        MinBtn.Text = IsMinimized and "+" or "-"
    end)

    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Text = "X"; CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -40, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20); CloseBtn.TextColor3 = Theme.Accent; CloseBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", CloseBtn)
    CloseBtn.MouseButton1Click:Connect(function()
    local mini = Parent:FindFirstChild("AOS_Minimizer")
    if mini then mini:Destroy() end
    Screen:Destroy()
end)

    -- Tab & Page Management
    local TabHolder = Instance.new("ScrollingFrame", MainFrame)
    TabHolder.Size = UDim2.new(0, 90, 1, -40); TabHolder.Position = UDim2.new(0, 0, 0, 40)
    TabHolder.BackgroundColor3 = Theme.Dark; TabHolder.BorderSizePixel = 0; TabHolder.ScrollBarThickness = 0
    TabHolder.CanvasSize = UDim2.new(0,0,0,0)
TabHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

    local PageHolder = Instance.new("Frame", MainFrame)
    PageHolder.Size = UDim2.new(1, -100, 1, -50); PageHolder.Position = UDim2.new(0, 95, 0, 45); PageHolder.BackgroundTransparency = 1

    local Window = { Tabs = {}, FirstTab = nil }

    function Window:AddTab(tabConfig)
        local TabBtn = Instance.new("TextButton", TabHolder)
        TabBtn.Size = UDim2.new(1, -10, 0, 30); TabBtn.BackgroundColor3 = Theme.Main
        TabBtn.Text = tabConfig.Title; TabBtn.TextColor3 = Theme.TextDark; TabBtn.Font = Enum.Font.GothamMedium; TabBtn.TextSize = 12
        Instance.new("UICorner", TabBtn)

        local Page = Instance.new("ScrollingFrame", PageHolder)
Page.Size = UDim2.new(1, 0, 1, 0)
Page.BackgroundTransparency = 1
Page.Visible = false
Page.ScrollBarThickness = 2
Page.ScrollBarImageColor3 = Theme.Accent
Page.CanvasSize = UDim2.new(0,0,0,0) -- เริ่ม 0
Page.AutomaticCanvasSize = Enum.AutomaticSize.Y -- 🔥 ตัวแก้หลัก

local layout = Instance.new("UIListLayout", Page)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

        local function ShowPage()
            for _, p in pairs(PageHolder:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            for _, t in pairs(TabHolder:GetChildren()) do if t:IsA("TextButton") then Library:Tween(t, 0.3, {TextColor3 = Theme.TextDark}) end end
            Page.Visible = true
            Library:Tween(TabBtn, 0.3, {TextColor3 = Theme.Accent})
        end

        TabBtn.MouseButton1Click:Connect(ShowPage)
        if not Window.FirstTab then Window.FirstTab = ShowPage; task.spawn(ShowPage) end

        local Elements = {}
        
        -----
        function Elements:AddCollapse(title)
    local parent = self._Page or Page
    local opened = false

    -- Container
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -10, 0, 40)
    container.BackgroundColor3 = Theme.Section
    container.ClipsDescendants = true
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", container)
    stroke.Color = Theme.Accent
    stroke.Transparency = 0.6

    -- Header Button
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false

    -- Title
    local txt = Instance.new("TextLabel", btn)
    txt.Size = UDim2.new(1, -40, 1, 0)
    txt.Position = UDim2.new(0, 12, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = title
    txt.TextColor3 = Theme.Text
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.TextXAlignment = Enum.TextXAlignment.Left

    -- Arrow
    local arrow = Instance.new("TextLabel", btn)
    arrow.Size = UDim2.new(0, 30, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▶"
    arrow.TextColor3 = Theme.Accent
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 16

    -- Content
    local content = Instance.new("Frame", container)
    content.Position = UDim2.new(0, 0, 0, 40)
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.AutomaticSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 6)

    -- 🔥 ฟังก์ชันอัปเดตขนาด (หัวใจหลัก)
    local function updateSize()
        if not opened then return end

        local target = 40 + content.AbsoluteSize.Y + 6

        Library:Tween(container, 0.2, {
            Size = UDim2.new(1, -10, 0, target)
        })
    end

    -- 🔥 ดักทุกการเปลี่ยน (แก้ dropdown / slider / dynamic UI)
    content:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

    -- Hover
    btn.MouseEnter:Connect(function()
        Library:Tween(container, 0.15, {BackgroundColor3 = Theme.Dark})
    end)

    btn.MouseLeave:Connect(function()
        Library:Tween(container, 0.15, {BackgroundColor3 = Theme.Section})
    end)

    -- Toggle
    btn.MouseButton1Click:Connect(function()
        opened = not opened

        arrow.Text = opened and "▼" or "▶"
        content.Visible = opened

        if opened then
            updateSize()
        else
            Library:Tween(container, 0.2, {
                Size = UDim2.new(1, -10, 0, 40)
            })
        end
    end)

    -- Return Elements
    local NewElements = {}
    setmetatable(NewElements, {__index = Elements})
    NewElements._Page = content

    return NewElements
end
        -----

function Elements:AddButton(text, callback)
    local parent = self._Page or Page -- 🔥 ตัวสำคัญ

    -- Main Button
    local b = Instance.new("TextButton", parent) -- ❗ เปลี่ยนตรงนี้
    b.Size = UDim2.new(1, -10, 0, 40)
    b.BackgroundColor3 = Theme.Dark
    b.Text = ""
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

    -- Stroke
    local stroke = Instance.new("UIStroke", b)
    stroke.Color = Theme.Accent
    stroke.Transparency = 0.6

    -- Text
    local txt = Instance.new("TextLabel", b)
    txt.Size = UDim2.new(1, -20, 1, 0)
    txt.Position = UDim2.new(0,10,0,0)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = Theme.Text
    txt.Font = Enum.Font.GothamSemibold
    txt.TextSize = 13
    txt.TextXAlignment = Enum.TextXAlignment.Left

    -- Glow
    local glow = Instance.new("Frame", b)
    glow.Size = UDim2.new(1,0,1,0)
    glow.BackgroundColor3 = Theme.Accent
    glow.BackgroundTransparency = 0.9
    glow.ZIndex = 0
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0,8)

    -- Hover
    b.MouseEnter:Connect(function()
        Library:Tween(b,0.15,{BackgroundColor3 = Theme.Section})
        Library:Tween(stroke,0.15,{Transparency = 0.3})
    end)

    b.MouseLeave:Connect(function()
        Library:Tween(b,0.15,{BackgroundColor3 = Theme.Dark})
        Library:Tween(stroke,0.15,{Transparency = 0.6})
    end)

    -- Click effect
    b.MouseButton1Down:Connect(function()
        Library:Tween(b,0.08,{Size = UDim2.new(1,-12,0,38)})
    end)

    b.MouseButton1Up:Connect(function()
        Library:Tween(b,0.08,{Size = UDim2.new(1,-10,0,40)})
    end)

    -- Click
    b.MouseButton1Click:Connect(function()
        Library:Tween(glow,0.1,{BackgroundTransparency = 0.7})
        task.delay(0.1,function()
            Library:Tween(glow,0.2,{BackgroundTransparency = 0.9})
        end)

        if callback then
            pcall(callback)
        end
    end)
end

        function Elements:AddToggle(text, default, callback)
    local parent = self._Page or Page -- 🔥 สำคัญมาก
    local active = default or false

    -- Main
    local t = Instance.new("TextButton", parent) -- ❗ เปลี่ยนจาก Page → parent
    t.Size = UDim2.new(1, -10, 0, 40)
    t.BackgroundColor3 = Theme.Dark
    t.Text = ""
    t.AutoButtonColor = false
    Instance.new("UICorner", t).CornerRadius = UDim.new(0,8)

    -- Stroke
    local stroke = Instance.new("UIStroke", t)
    stroke.Color = Theme.Accent
    stroke.Transparency = 0.6

    -- Text
    local txt = Instance.new("TextLabel", t)
    txt.Size = UDim2.new(1, -60, 1, 0)
    txt.Position = UDim2.new(0,10,0,0)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = Theme.Text
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 13
    txt.TextXAlignment = Enum.TextXAlignment.Left

    -- Toggle Bar
    local s = Instance.new("Frame", t)
    s.Size = UDim2.new(0, 36, 0, 18)
    s.Position = UDim2.new(1, -50, 0.5, -9)
    s.BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(60,60,60)
    Instance.new("UICorner", s).CornerRadius = UDim.new(1,0)

    -- Knob
    local c = Instance.new("Frame", s)
    c.Size = UDim2.new(0, 14, 0, 14)
    c.Position = active and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
    c.BackgroundColor3 = Theme.Text
    Instance.new("UICorner", c).CornerRadius = UDim.new(1,0)

    -- Sound
    local sound = Instance.new("Sound", t)
    sound.SoundId = "rbxassetid://101795118548847"
    sound.Volume = 1

    -- Hover
    t.MouseEnter:Connect(function()
        Library:Tween(t,0.15,{BackgroundColor3 = Theme.Section})
        Library:Tween(stroke,0.15,{Transparency = 0.3})
    end)

    t.MouseLeave:Connect(function()
        Library:Tween(t,0.15,{BackgroundColor3 = Theme.Dark})
        Library:Tween(stroke,0.15,{Transparency = 0.6})
    end)

    -- Click
    t.MouseButton1Click:Connect(function()
        active = not active

        sound:Play()

        Library:Tween(s, 0.25, {
            BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(60,60,60)
        })

        Library:Tween(c, 0.25, {
            Position = active and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
        })

        Library:Tween(t,0.08,{Size = UDim2.new(1,-12,0,38)})
        task.delay(0.08,function()
            Library:Tween(t,0.08,{Size = UDim2.new(1,-10,0,40)})
        end)

        if callback then
            pcall(callback, active)
        end
    end)
end

        function Elements:AddSlider(text, min, max, default, callback)
    local parent = self._Page or Page -- 🔥 ตัวสำคัญ
    local value = default or min
    local dragging = false
    local inputConn, endConn

    -- Main
    local s = Instance.new("Frame", parent) -- ❗ เปลี่ยนตรงนี้
    s.Size = UDim2.new(1, -10, 0, 50)
    s.BackgroundColor3 = Theme.Dark
    Instance.new("UICorner", s).CornerRadius = UDim.new(0,8)

    -- Title
    local l = Instance.new("TextLabel", s)
    l.Text = "  "..text
    l.Size = UDim2.new(1,0,0,22)
    l.BackgroundTransparency = 1
    l.TextColor3 = Theme.Text
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left

    -- Value
    local vl = Instance.new("TextLabel", s)
    vl.Text = tostring(value)
    vl.Position = UDim2.new(1,-50,0,0)
    vl.Size = UDim2.new(0,45,0,22)
    vl.BackgroundTransparency = 1
    vl.TextColor3 = Theme.Accent
    vl.Font = Enum.Font.GothamBold
    vl.TextSize = 12

    -- Bar Background
    local bar = Instance.new("Frame", s)
    bar.Size = UDim2.new(1,-20,0,6)
    bar.Position = UDim2.new(0,10,0,34)
    bar.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

    -- Fill
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Theme.Accent
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    -- Knob
    local knob = Instance.new("Frame", bar)
    knob.Size = UDim2.new(0,14,0,14)
    knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((value-min)/(max-min),0,0.5,0)
    knob.BackgroundColor3 = Theme.Text
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    -- Update
    local function setValue(x)
        local percent = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * percent)

        value = val
        vl.Text = tostring(val)

        Library:Tween(fill,0.1,{Size = UDim2.new(percent,0,1,0)})
        Library:Tween(knob,0.1,{Position = UDim2.new(percent,0,0.5,0)})

        if callback then pcall(callback, val) end
    end

    -- Drag
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setValue(input.Position.X)

            if inputConn then inputConn:Disconnect() end
            if endConn then endConn:Disconnect() end

            inputConn = UserInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    setValue(i.Position.X)
                end
            end)

            endConn = UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    if inputConn then inputConn:Disconnect() inputConn = nil end
                    if endConn then endConn:Disconnect() endConn = nil end
                end
            end)
        end
    end)
end

        function Elements:AddDropdown(text, list, callback)
    local parent = self._Page or Page -- 🔥 สำคัญมาก
    local expanded = false
    local selectedOption = "Select Options"
    local optionButtons = {}

    -- Container
    local d = Instance.new("Frame", parent) -- ❗ เปลี่ยนตรงนี้
    d.Size = UDim2.new(1, -10, 0, 50)
    d.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
    d.BorderSizePixel = 0
    d.ClipsDescendants = true
    Instance.new("UICorner", d).CornerRadius = UDim.new(0, 4)

    -- Top Line
    local topLine = Instance.new("Frame", d)
    topLine.Size = UDim2.new(1, 0, 0, 2)
    topLine.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

    -- Label
    local label = Instance.new("TextLabel", d)
    label.Size = UDim2.new(0.4, 0, 0, 50)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- Button
    local dropBtn = Instance.new("TextButton", d)
    dropBtn.Size = UDim2.new(0.5, 0, 0, 34)
    dropBtn.Position = UDim2.new(1, -10, 0, 25)
    dropBtn.AnchorPoint = Vector2.new(1, 0.5)
    dropBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    dropBtn.Text = ""
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)

    local dropText = Instance.new("TextLabel", dropBtn)
    dropText.Size = UDim2.new(1, -35, 1, 0)
    dropText.Position = UDim2.new(0, 10, 0, 0)
    dropText.BackgroundTransparency = 1
    dropText.Text = selectedOption
    dropText.TextColor3 = Color3.fromRGB(200, 200, 200)
    dropText.Font = Enum.Font.Gotham
    dropText.TextSize = 13
    dropText.TextXAlignment = Enum.TextXAlignment.Left

    -- Search
    local searchBar = Instance.new("TextBox", d)
    searchBar.Size = UDim2.new(1, -20, 0, 30)
    searchBar.Position = UDim2.new(0, 10, 0, 55)
    searchBar.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    searchBar.PlaceholderText = "Search"
    searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBar.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    searchBar.Font = Enum.Font.Gotham
    searchBar.TextSize = 13
    Instance.new("UICorner", searchBar)

    -- List
    local listFrame = Instance.new("ScrollingFrame", d)
    listFrame.Position = UDim2.new(0, 10, 0, 95)
    listFrame.Size = UDim2.new(1, -20, 0, 150)
    listFrame.BackgroundTransparency = 1
    listFrame.ScrollBarThickness = 2
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout", listFrame)
    layout.Padding = UDim.new(0, 5)

    -- Search Logic
    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = searchBar.Text:lower()
        for _, btn in pairs(optionButtons) do
            btn.Visible = btn.Name:lower():find(searchText) ~= nil
        end
    end)

    -- Options
    for _, v in pairs(list) do
        local opt = Instance.new("TextButton", listFrame)
        opt.Name = tostring(v)
        opt.Size = UDim2.new(1, -5, 0, 30)
        opt.BackgroundColor3 = Color3.fromRGB(70, 25, 25)
        opt.Text = "  " .. tostring(v)
        opt.TextColor3 = Color3.fromRGB(255, 255, 255)
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 13
        opt.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", opt)

        table.insert(optionButtons, opt)

        opt.MouseButton1Click:Connect(function()
            selectedOption = tostring(v)
            dropText.Text = selectedOption
            expanded = false
            Library:Tween(d, 0.2, {Size = UDim2.new(1, -10, 0, 50)})
            if callback then pcall(callback, v) end
        end)
    end

    -- Toggle Dropdown
    dropBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        Library:Tween(d, expanded and 0.3 or 0.2, {
            Size = expanded and UDim2.new(1, -10, 0, 260) or UDim2.new(1, -10, 0, 50)
        })
    end)
end



function Elements:AddMultiDropdown(text, list, callback)
    local parent = self._Page or Page -- 🔥 ตัวแก้หลัก
    local expanded = false
    local selected = {}
    local optionButtons = {}

    -- Container
    local md = Instance.new("Frame", parent)
    md.Size = UDim2.new(1, -10, 0, 50)
    md.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
    md.ClipsDescendants = true
    Instance.new("UICorner", md).CornerRadius = UDim.new(0, 4)

    local topLine = Instance.new("Frame", md)
    topLine.Size = UDim2.new(1, 0, 0, 2)
    topLine.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

    -- Label
    local label = Instance.new("TextLabel", md)
    label.Size = UDim2.new(0.4, 0, 0, 50)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- Dropdown Button
    local dropBtn = Instance.new("TextButton", md)
    dropBtn.Size = UDim2.new(0.5, 0, 0, 34)
    dropBtn.Position = UDim2.new(1, -10, 0, 25)
    dropBtn.AnchorPoint = Vector2.new(1, 0.5)
    dropBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    dropBtn.Text = ""
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)

    local dropText = Instance.new("TextLabel", dropBtn)
    dropText.Size = UDim2.new(1, -10, 1, 0)
    dropText.Position = UDim2.new(0, 10, 0, 0)
    dropText.BackgroundTransparency = 1
    dropText.Text = "Select Options"
    dropText.TextColor3 = Color3.fromRGB(200, 200, 200)
    dropText.Font = Enum.Font.Gotham
    dropText.TextSize = 12
    dropText.TextXAlignment = Enum.TextXAlignment.Left
    dropText.ClipsDescendants = true

    -- Search Bar
    local searchBar = Instance.new("TextBox", md)
    searchBar.Size = UDim2.new(1, -20, 0, 30)
    searchBar.Position = UDim2.new(0, 10, 0, 55)
    searchBar.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    searchBar.PlaceholderText = "Search"
    searchBar.Text = ""
    searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBar.Font = Enum.Font.Gotham
    Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0, 4)

    -- List
    local listFrame = Instance.new("ScrollingFrame", md)
    listFrame.Position = UDim2.new(0, 10, 0, 95)
    listFrame.Size = UDim2.new(1, -20, 0, 150)
    listFrame.BackgroundTransparency = 1
    listFrame.ScrollBarThickness = 2
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- 🔥 กันล้น

    local layout = Instance.new("UIListLayout", listFrame)
    layout.Padding = UDim.new(0, 5)

    -- Search filter
    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = searchBar.Text:lower()
        for _, btn in pairs(optionButtons) do
            btn.Visible = btn.Name:lower():find(searchText) and true or false
        end
    end)

    -- Options
    for _, v in pairs(list) do
        local opt = Instance.new("TextButton", listFrame)
        opt.Name = tostring(v)
        opt.Size = UDim2.new(1, -5, 0, 30)
        opt.BackgroundColor3 = Color3.fromRGB(70, 25, 25)
        opt.Text = "  " .. tostring(v)
        opt.TextColor3 = Color3.fromRGB(180, 180, 180)
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 13
        opt.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 4)

        local indicator = Instance.new("Frame", opt)
        indicator.Size = UDim2.new(0, 4, 1, 0)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        indicator.Visible = false

        table.insert(optionButtons, opt)

        opt.MouseButton1Click:Connect(function()
            local found = table.find(selected, v)

            if found then
                table.remove(selected, found)
                indicator.Visible = false
                opt.TextColor3 = Color3.fromRGB(180, 180, 180)
            else
                table.insert(selected, v)
                indicator.Visible = true
                opt.TextColor3 = Color3.fromRGB(255, 255, 255)
            end

            dropText.Text = (#selected == 0 and "Select Options") or table.concat(selected, ", ")

            if callback then
                pcall(callback, selected)
            end
        end)
    end

    -- Expand / Collapse
    dropBtn.MouseButton1Click:Connect(function()
        expanded = not expanded

        Library:Tween(md, 0.25, {
            Size = expanded and UDim2.new(1, -10, 0, 260) or UDim2.new(1, -10, 0, 50)
        })
    end)
end


        function Elements:AddSection(text)
    local parent = self._Page or Page -- 🔥 สำคัญ

    local s = Instance.new("Frame", parent)
    s.Size = UDim2.new(1, -10, 0, 22)
    s.BackgroundTransparency = 1

    local l = Instance.new("TextLabel", s)
    l.Text = tostring(text):upper()
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Theme.Accent
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Center
end

        function Elements:AddParagraph(title, content)
    local parent = self._Page or Page -- 🔥 สำคัญ

    local p = Instance.new("Frame", parent)
    p.Size = UDim2.new(1, -10, 0, 65)
    p.BackgroundColor3 = Theme.Section
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", p)
    stroke.Color = Theme.Accent
    stroke.Transparency = 0.8

    -- Title
    local tl = Instance.new("TextLabel", p)
    tl.Text = "  "..tostring(title)
    tl.Size = UDim2.new(1, 0, 0, 24)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = Theme.Accent
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 12
    tl.TextXAlignment = Enum.TextXAlignment.Left

    -- Content
    local cl = Instance.new("TextLabel", p)
    cl.Text = "  "..tostring(content)
    cl.Size = UDim2.new(1, -10, 1, -24)
    cl.Position = UDim2.new(0, 5, 0, 24)
    cl.BackgroundTransparency = 1
    cl.TextColor3 = Theme.TextDark
    cl.Font = Enum.Font.Gotham
    cl.TextWrapped = true
    cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.TextYAlignment = Enum.TextYAlignment.Top
    cl.TextSize = 11
end

        return Elements
    end  
    
    -- // Open Animation
task.spawn(function()
    task.wait() -- กันบัคโหลดไม่ทัน

    -- ขยาย + fade
    Library:Tween(MainFrame, 0.4, {
        Size = UDim2.new(0, 360, 0, 240),
        BackgroundTransparency = 0
    })

    -- เด้งนิดๆ (smooth)
    task.wait(0.4)
    Library:Tween(MainFrame, 0.15, {
        Size = UDim2.new(0, 370, 0, 250)
    })

    task.wait(0.15)
    Library:Tween(MainFrame, 0.15, {
        Size = UDim2.new(0, 360, 0, 240)
    })
end)

    -- เรียกใช้งาน Minimizer อัตโนมัติหลังสร้าง Window เสร็จ
    Library:CreateMinimizer(MainFrame)
    
    return Window
end
