

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
    Main = Color3.fromRGB(40, 40, 40), -- พื้น UI
    Dark = Color3.fromRGB(15, 15, 15), -- 🔥 ปุ่มดำจริง
    Accent = Color3.fromRGB(255, 45, 45),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Section = Color3.fromRGB(30, 30, 30)
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

    -- 🎨 Button Container
    local btn = miniGui:FindFirstChild("MiniBtn") or Instance.new("Frame", miniGui)
    btn.Name = "MiniBtn"
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0, 12, 0.5, -25)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Transparency = 0.4

    -- 🔘 Click Layer
    local click = Instance.new("TextButton", btn)
    click.Size = UDim2.new(1,0,1,0)
    click.BackgroundTransparency = 1
    click.Text = ""

    -- 📌 Icon (แทน AOS)
    local icon = Instance.new("ImageLabel", btn)
    icon.Size = UDim2.new(0, 22, 0, 22)
    icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6031091004" -- เปลี่ยนได้
    icon.ImageColor3 = Color3.fromRGB(200,200,200)

    -- ✨ Hover
    click.MouseEnter:Connect(function()
        Library:Tween(btn, 0.15, {
            BackgroundColor3 = Color3.fromRGB(30,30,30)
        })
        Library:Tween(stroke, 0.15, {
            Transparency = 0.1
        })
    end)

    click.MouseLeave:Connect(function()
        Library:Tween(btn, 0.15, {
            BackgroundColor3 = Color3.fromRGB(25,25,25)
        })
        Library:Tween(stroke, 0.15, {
            Transparency = 0.4
        })
    end)

    -- 🔥 Click toggle (มี animation)
    local visible = true
    click.MouseButton1Click:Connect(function()
        visible = not visible

        if visible then
            mainFrame.Visible = true
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 20)
            Library:Tween(mainFrame, 0.25, {
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
        else
            Library:Tween(mainFrame, 0.2, {
                Position = UDim2.new(0.5, 0, 0.5, 20)
            })
            task.delay(0.2, function()
                mainFrame.Visible = false
            end)
        end
    end)

    -- 📦 Drag
    Library:MakeDraggable(btn, click)
end

function Library:Notify(title, text, duration)
    duration = duration or 3

    -- 🔹 Holder
    local NotifHolder = Parent:FindFirstChild("AOS_NotifHolder")
    if not NotifHolder then
        NotifHolder = Instance.new("ScreenGui")
        NotifHolder.Name = "AOS_NotifHolder"
        NotifHolder.Parent = Parent
        NotifHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local layout = Instance.new("UIListLayout", NotifHolder)
        layout.Padding = UDim.new(0, 8)
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    end

    -- 🔹 Main Container
    local Notif = Instance.new("Frame", NotifHolder)
    Notif.Size = UDim2.new(0, 320, 0, 85)
    Notif.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Notif.ClipsDescendants = true
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 12)

    -- Stroke
    local stroke = Instance.new("UIStroke", Notif)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Transparency = 0.4

    -- 🔹 Accent Bar
    local accent = Instance.new("Frame", Notif)
    accent.Position = UDim2.new(0, 8, 0, 8)
    accent.Size = UDim2.new(0, 3, 1, -16)
    accent.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    accent.BorderSizePixel = 0
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

    -- 🔹 Content Holder
    local content = Instance.new("Frame", Notif)
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, -20, 1, -16)
    content.Position = UDim2.new(0, 16, 0, 8)

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 2)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Title
    local T = Instance.new("TextLabel", content)
    T.Size = UDim2.new(1, 0, 0, 22)
    T.BackgroundTransparency = 1
    T.Text = title
    T.TextColor3 = Color3.fromRGB(235, 235, 235)
    T.Font = Enum.Font.GothamBold
    T.TextSize = 14
    T.TextXAlignment = Enum.TextXAlignment.Left

    -- Description
    local D = Instance.new("TextLabel", content)
    D.Size = UDim2.new(1, 0, 1, -22)
    D.BackgroundTransparency = 1
    D.Text = text
    D.TextColor3 = Color3.fromRGB(170, 170, 170)
    D.Font = Enum.Font.Gotham
    D.TextSize = 12
    D.TextWrapped = true
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.TextYAlignment = Enum.TextYAlignment.Top

    -- 🔹 Progress Bar
    local barBg = Instance.new("Frame", Notif)
    barBg.Size = UDim2.new(1, 0, 0, 3)
    barBg.Position = UDim2.new(0, 0, 1, -3)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(220, 60, 60)

    -- 🔹 Sound Effect
    local sound = Instance.new("Sound", Notif)
    sound.SoundId = "rbxassetid://113511836483750"
    sound.Volume = 0.4
    sound:Play()

    -- 🔹 Animation In (slide + fade)
    Notif.Position = UDim2.new(1, 350, 1, 0)
    Notif.BackgroundTransparency = 0.2
    Notif.Size = UDim2.new(0, 320, 0, 80)

    Library:Tween(Notif, 0.35, {
        Position = UDim2.new(1, -10, 1, 0),
        BackgroundTransparency = 0
    })

    -- Progress Animation
    Library:Tween(bar, duration, {
        Size = UDim2.new(0, 0, 1, 0)
    })

    -- 🔹 Animation Out
    task.delay(duration, function()
        Library:Tween(Notif, 0.25, {
            Position = UDim2.new(1, 350, 1, 0),
            BackgroundTransparency = 1
        })
        task.wait(0.25)
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
    BackgroundTransparency = 0.5
})
    
    Library:MakeDraggable(Header, MainFrame)

    -- LOGO (ใหญ่ขึ้น)
local Logo = Instance.new("ImageLabel", Header)
Logo.Size = UDim2.new(0, 28, 0, 28) -- 🔥 ปรับตรงนี้ (ลอง 26-30 ได้)
Logo.Position = UDim2.new(0, 10, 0, 6) -- 🔥 ขยับขึ้นนิดให้กลาง
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://114022791352635"
Logo.ScaleType = Enum.ScaleType.Fit

-- ทำให้โค้ง
local logoCorner = Instance.new("UICorner", Logo)
logoCorner.CornerRadius = UDim.new(1,0)

-- TITLE (ขยับตามโลโก้)
local Title = Instance.new("TextLabel", Header)
Title.Text = config.Title or "AOSgg Hub"
Title.Size = UDim2.new(1, -90, 0, 20)
Title.Position = UDim2.new(0, 48, 0, 4) -- 🔥 ขยับออกจากโลโก้
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextTruncate = Enum.TextTruncate.AtEnd

-- 📦 HOLDER (เอาไว้จัดเรียง)
local PlayerHolder = Instance.new("Frame", Header)
PlayerHolder.Size = UDim2.new(1, -200, 0, 30) -- กันชนปุ่มขวา
PlayerHolder.Position = UDim2.new(0, 200, 0, 5)
PlayerHolder.BackgroundTransparency = 1

-- 🔥 Layout เรียงแนวนอน
local layout = Instance.new("UIListLayout", PlayerHolder)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)

-- PLAYER AVATAR
local PlayerIcon = Instance.new("ImageLabel", PlayerHolder)
PlayerIcon.Size = UDim2.new(0, 18, 0, 18)
PlayerIcon.BackgroundTransparency = 1
PlayerIcon.ScaleType = Enum.ScaleType.Fit
PlayerIcon.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
    .. Players.LocalPlayer.UserId ..
    "&width=420&height=420&format=png"
Instance.new("UICorner", PlayerIcon).CornerRadius = UDim.new(1,0)

-- PLAYER NAME
local PlayerName = Instance.new("TextLabel", PlayerHolder)
PlayerName.Text = Players.LocalPlayer.Name
PlayerName.AutomaticSize = Enum.AutomaticSize.X
PlayerName.Size = UDim2.new(0, 0, 0, 14)
PlayerName.BackgroundTransparency = 1
PlayerName.TextColor3 = Theme.Text
PlayerName.Font = Enum.Font.Gotham
PlayerName.TextSize = 10
PlayerName.TextXAlignment = Enum.TextXAlignment.Left
PlayerName.TextYAlignment = Enum.TextYAlignment.Center
PlayerName.TextTruncate = Enum.TextTruncate.AtEnd

-- RANK
local Rank = Instance.new("TextLabel", PlayerHolder)
Rank.Text = "| Premium"
Rank.AutomaticSize = Enum.AutomaticSize.X
Rank.Size = UDim2.new(0, 0, 0, 14)
Rank.BackgroundTransparency = 1
Rank.TextColor3 = Theme.Accent
Rank.Font = Enum.Font.GothamBold
Rank.TextSize = 10
Rank.TextXAlignment = Enum.TextXAlignment.Left
Rank.TextYAlignment = Enum.TextYAlignment.Center

-- SUBTITLE (อยู่ด้านล่าง)
local SubTitle = Instance.new("TextLabel", Header)
SubTitle.Text = config.Subtitle or ""
SubTitle.Size = UDim2.new(1, -90, 0, 14)
SubTitle.Position = UDim2.new(0, 48, 0, 22)
SubTitle.TextColor3 = Theme.TextDark
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 10
SubTitle.BackgroundTransparency = 1
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.TextYAlignment = Enum.TextYAlignment.Center
SubTitle.TextTruncate = Enum.TextTruncate.AtEnd
    

    -- Minimize & Close Buttons
    local IsMinimized = false
    local MinBtn = Instance.new("TextButton", Header)
    MinBtn.Text = "-"; MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -75, 0, 5)
    MinBtn.BackgroundColor3 = Theme.Section; MinBtn.TextColor3 = Theme.Text; MinBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", MinBtn)

    MinBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        Library:Tween(MainFrame, 0.4, {
    Size = IsMinimized and UDim2.new(0, 500, 0, 40) or UDim2.new(0, 500, 0, 320)
})
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

-- 📌 TAB HOLDER (ซ้าย)
local TabHolder = Instance.new("ScrollingFrame")
TabHolder.Parent = MainFrame
TabHolder.Size = UDim2.new(0, 110, 1, -40)
TabHolder.Position = UDim2.new(0, 0, 0, 40)
TabHolder.BackgroundColor3 = Theme.Dark
TabHolder.BorderSizePixel = 0
TabHolder.ScrollBarThickness = 0

-- 🔥 แก้เลื่อนมั่ว
TabHolder.CanvasSize = UDim2.new(0,0,0,0)
TabHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- 🔥 กันล้น / เนียนขึ้น
local tabPadding = Instance.new("UIPadding")
tabPadding.Parent = TabHolder
tabPadding.PaddingTop = UDim.new(0,5)
tabPadding.PaddingBottom = UDim.new(0,5)

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = TabHolder
tabLayout.Padding = UDim.new(0, 5)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 🔥 FIX: ล็อคขนาดจริง (กันเลื่อนเกิน)
tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabHolder.CanvasSize = UDim2.new(0,0,0,tabLayout.AbsoluteContentSize.Y + 10)
end)

-- 🔥 ซ่อน scrollbar ถ้าไม่จำเป็น
TabHolder:GetPropertyChangedSignal("CanvasSize"):Connect(function()
    TabHolder.ScrollBarThickness = (TabHolder.CanvasSize.Y.Offset > TabHolder.AbsoluteSize.Y) and 3 or 0
end)



-- 📌 PAGE HOLDER (ขวา)
local PageHolder = Instance.new("Frame")
PageHolder.Parent = MainFrame
PageHolder.Size = UDim2.new(1, -120, 1, -50)
PageHolder.Position = UDim2.new(0, 115, 0, 45)
PageHolder.BackgroundTransparency = 1

-- 🔥 กัน element ล้นออกนอก frame
PageHolder.ClipsDescendants = true

local Window = { Tabs = {}, FirstTab = nil }

function Window:AddTab(tabConfig)
tabConfig = tabConfig or {}

-- 🧱 Tab Button  
local TabBtn = Instance.new("TextButton")  
TabBtn.Parent = TabHolder  
TabBtn.Size = UDim2.new(1, -10, 0, 30)  
TabBtn.BackgroundColor3 = Theme.Main  
TabBtn.Text = ""  
TabBtn.AutoButtonColor = false  
Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0,6)  

-- 🔴 Indicator (ใช้ Size ไม่ใช้ Visible)  
local indicator = Instance.new("Frame")  
indicator.Parent = TabBtn  
indicator.Size = UDim2.new(0, 0, 0, 2)  
indicator.Position = UDim2.new(0, 0, 1, -2)  
indicator.BackgroundColor3 = Theme.Accent  
indicator.BorderSizePixel = 0  

-- 📌 ICON  
local icon = Instance.new("ImageLabel")  
icon.Parent = TabBtn  
icon.Size = UDim2.new(0, 18, 0, 18)  
icon.Position = UDim2.new(0, 6, 0.5, -9)  
icon.BackgroundTransparency = 1  
icon.Image = tabConfig.Icon or "rbxassetid://0"  
icon.ImageColor3 = Theme.TextDark  

-- 📌 TEXT  
local txt = Instance.new("TextLabel")  
txt.Parent = TabBtn  
txt.Size = UDim2.new(1, -30, 1, 0)  
txt.Position = UDim2.new(0, 26, 0, 0)  
txt.BackgroundTransparency = 1  
txt.Text = tabConfig.Title or "Tab"  
txt.TextColor3 = Theme.TextDark  
txt.Font = Enum.Font.GothamMedium  
txt.TextSize = 12  
txt.TextXAlignment = Enum.TextXAlignment.Left  

-- 📄 Page  
local Page = Instance.new("ScrollingFrame")  
Page.Parent = PageHolder  
Page.Size = UDim2.new(1, 0, 1, 0)  
Page.BackgroundTransparency = 1  
Page.Visible = false  
Page.ScrollBarThickness = 2  
Page.ScrollBarImageColor3 = Theme.Accent  
Page.AutomaticCanvasSize = Enum.AutomaticSize.Y  

local layout = Instance.new("UIListLayout")  
layout.Parent = Page  
layout.Padding = UDim.new(0, 8)  
layout.SortOrder = Enum.SortOrder.LayoutOrder  
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center  

-- 🔥 ShowPage (กันบัคครบ)  
local function ShowPage()  
    -- ปิดทุกหน้า  
    for _, p in ipairs(PageHolder:GetChildren()) do  
        if p:IsA("ScrollingFrame") then  
            p.Visible = false  
        end  
    end  

    -- รี Tab ทั้งหมด  
    for _, t in ipairs(TabHolder:GetChildren()) do  
        if t:IsA("TextButton") then  
            local label = t:FindFirstChildWhichIsA("TextLabel")  
            local ic = t:FindFirstChildWhichIsA("ImageLabel")  
            local line = t:FindFirstChildWhichIsA("Frame")  

            if label then  
                Library:Tween(label, 0.2, {TextColor3 = Theme.TextDark})  
            end  

            if ic then  
                Library:Tween(ic, 0.2, {ImageColor3 = Theme.TextDark})  
            end  

            if line then  
                Library:Tween(line, 0.2, {Size = UDim2.new(0,0,0,2)})  
            end  

            Library:Tween(t, 0.2, {  
                BackgroundColor3 = Theme.Main  
            })  
        end  
    end  

    -- เปิดหน้า  
    Page.Visible = true  

    -- 🔥 Active  
    Library:Tween(txt, 0.25, {TextColor3 = Theme.Accent})  
    Library:Tween(icon, 0.25, {ImageColor3 = Theme.Accent})  

    Library:Tween(TabBtn, 0.25, {  
        BackgroundColor3 = Theme.Section  
    })  

    Library:Tween(indicator, 0.25, {  
        Size = UDim2.new(1,0,0,2)  
    })  
end  

-- 🖱 Hover (ไม่ชน state)  
TabBtn.MouseEnter:Connect(function()  
    if not Page.Visible then  
        Library:Tween(TabBtn, 0.15, {  
            BackgroundColor3 = Theme.Dark  
        })  
    end  
end)  

TabBtn.MouseLeave:Connect(function()  
    if not Page.Visible then  
        Library:Tween(TabBtn, 0.15, {  
            BackgroundColor3 = Theme.Main  
        })  
    end  
end)  

-- Click  
TabBtn.MouseButton1Click:Connect(ShowPage)  

-- First Tab  
if not Window.FirstTab then  
    Window.FirstTab = ShowPage  
    task.spawn(ShowPage)  
end  

    
    

        local Elements = {}
        
        -----
        function Elements:AddCollapse(title)
    local parent = self._Page or Page
    local opened = false

    -- 🎨 Container
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -10, 0, 44)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    container.ClipsDescendants = true
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", container)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Transparency = 0.5

    -- 📦 Header
    local header = Instance.new("Frame", container)
    header.Size = UDim2.new(1, 0, 0, 44)
    header.BackgroundTransparency = 1

    local pad = Instance.new("UIPadding", header)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)

    -- Title
    local txt = Instance.new("TextLabel", header)
    txt.Size = UDim2.new(1, -30, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = title
    txt.TextColor3 = Color3.fromRGB(220, 220, 220)
    txt.Font = Enum.Font.GothamSemibold
    txt.TextSize = 14
    txt.TextXAlignment = Enum.TextXAlignment.Left

    -- 🔽 Arrow (หมุนได้)
    local arrow = Instance.new("ImageLabel", header)
    arrow.Size = UDim2.new(0, 14, 0, 14)
    arrow.Position = UDim2.new(1, -18, 0.5, 0)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Image = "rbxassetid://6031091004" -- ไอคอนลูกศร
    arrow.ImageColor3 = Color3.fromRGB(180, 180, 180)

    -- ปุ่มกด
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 0, 44)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    -- 📜 Content
    local content = Instance.new("Frame", container)
    content.Position = UDim2.new(0, 0, 0, 44)
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.AutomaticSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 8)

    local contentPad = Instance.new("UIPadding", content)
    contentPad.PaddingTop = UDim.new(0, 6)
    contentPad.PaddingBottom = UDim.new(0, 6)

    -- 📏 Update Size
    local function updateSize()
        if not opened then return end

        local target = 44 + content.AbsoluteSize.Y

        Library:Tween(container, 0.2, {
            Size = UDim2.new(1, -10, 0, target)
        })
    end

    content:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

    -- ✨ Hover
    btn.MouseEnter:Connect(function()
        Library:Tween(container, 0.15, {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        })
        Library:Tween(stroke, 0.15, {
            Transparency = 0.2
        })
    end)

    btn.MouseLeave:Connect(function()
        Library:Tween(container, 0.15, {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        })
        Library:Tween(stroke, 0.15, {
            Transparency = 0.5
        })
    end)

    -- 🔥 Toggle
    btn.MouseButton1Click:Connect(function()
        opened = not opened
        content.Visible = true

        -- หมุนลูกศร
        Library:Tween(arrow, 0.2, {
            Rotation = opened and 90 or 0
        })

        if opened then
            updateSize()
        else
            Library:Tween(container, 0.2, {
                Size = UDim2.new(1, -10, 0, 44)
            })
            task.delay(0.2, function()
                content.Visible = false
            end)
        end
    end)

    -- 📦 Return
    local NewElements = {}
    setmetatable(NewElements, {__index = Elements})
    NewElements._Page = content

    return NewElements
end
        -----

function Elements:AddButton(text, desc, callback)
    local parent = self._Page or Page
    local hasDesc = desc and desc ~= ""

    -- 🎨 Container
    local b = Instance.new("Frame", parent)
    b.Size = UDim2.new(1, -10, 0, hasDesc and 60 or 44)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", b)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Transparency = 0.5

    -- 🔘 Click layer
    local btn = Instance.new("TextButton", b)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    -- 📦 Padding (สำคัญ)
    local pad = Instance.new("UIPadding", b)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)

    -- 📝 Title
    local txt = Instance.new("TextLabel", b)
    txt.Size = UDim2.new(1, -30, 0, 20)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = Color3.fromRGB(230, 230, 230)
    txt.Font = Enum.Font.GothamSemibold
    txt.TextSize = 13
    txt.TextXAlignment = Enum.TextXAlignment.Left

    -- 📄 Description
    if hasDesc then
        local d = Instance.new("TextLabel", b)
        d.Size = UDim2.new(1, -30, 0, 18)
        d.Position = UDim2.new(0, 0, 0, 20)
        d.BackgroundTransparency = 1
        d.Text = desc
        d.TextColor3 = Color3.fromRGB(160, 160, 160)
        d.Font = Enum.Font.Gotham
        d.TextSize = 12
        d.TextXAlignment = Enum.TextXAlignment.Left
    end

    -- ➤ Arrow (เล็ก + subtle)
    local arrow = Instance.new("ImageLabel", b)
    arrow.Size = UDim2.new(0, 14, 0, 14)
    arrow.Position = UDim2.new(1, -4, 0.5, 0)
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Image = "rbxassetid://6031091004"
    arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)

    -- ✨ Hover
    btn.MouseEnter:Connect(function()
        Library:Tween(b, 0.15, {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        })
        Library:Tween(stroke, 0.15, {
            Transparency = 0.2
        })
        Library:Tween(arrow, 0.15, {
            ImageColor3 = Color3.fromRGB(200,200,200)
        })
    end)

    btn.MouseLeave:Connect(function()
        Library:Tween(b, 0.15, {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        })
        Library:Tween(stroke, 0.15, {
            Transparency = 0.5
        })
        Library:Tween(arrow, 0.15, {
            ImageColor3 = Color3.fromRGB(140,140,140)
        })
    end)

    -- 🔥 Click (scale + feedback)
    btn.MouseButton1Down:Connect(function()
        Library:Tween(b, 0.07, {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        })
    end)

    btn.MouseButton1Up:Connect(function()
        Library:Tween(b, 0.1, {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        })
    end)

    -- Click
    btn.MouseButton1Click:Connect(function()
        if callback then
            pcall(callback)
        end
    end)
end

function Elements:AddToggle(text, desc, default, callback)
    local parent = self._Page or Page
    local active = default or false

    -- Main container
    local t = Instance.new("TextButton")
    t.Parent = parent
    t.Size = UDim2.new(1, -10, 0, 40)
    t.AutomaticSize = Enum.AutomaticSize.Y
    t.BackgroundColor3 = Theme.Dark
    t.Text = ""
    t.AutoButtonColor = false

    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 8)

    -- 🔥 Stroke (FIX: เทา 50,50,50 ตลอด)
    local stroke = Instance.new("UIStroke", t)
    stroke.Color = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.Transparency = 0

    -- Title
    local txt = Instance.new("TextLabel")
    txt.Parent = t
    txt.Size = UDim2.new(1, -60, 0, 20)
    txt.Position = UDim2.new(0, 10, 0, 5)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = Theme.Text
    txt.Font = Enum.Font.GothamSemibold
    txt.TextSize = 13
    txt.TextXAlignment = Enum.TextXAlignment.Left

    -- Description
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = t
    descLabel.Size = UDim2.new(1, -60, 0, 0)
    descLabel.Position = UDim2.new(0, 10, 0, 22)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc or ""
    descLabel.TextColor3 = Theme.TextDark
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.AutomaticSize = Enum.AutomaticSize.Y

    -- Padding
    local padding = Instance.new("UIPadding", t)
    padding.PaddingBottom = UDim.new(0, 8)

    -- Toggle background
    local s = Instance.new("Frame")
    s.Parent = t
    s.Size = UDim2.new(0, 36, 0, 18)
    s.Position = UDim2.new(1, -50, 0, 10)
    s.BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)

    -- Knob
    local c = Instance.new("Frame")
    c.Parent = s
    c.Size = UDim2.new(0, 14, 0, 14)
    c.Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    c.BackgroundColor3 = Theme.Text
    Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)

    -- Sound
    local sound = Instance.new("Sound", t)
    sound.SoundId = "rbxassetid://101795118548847"
    sound.Volume = 1

    -- Hover (❗ ไม่ยุ่ง stroke แล้ว เพื่อให้ขอบนิ่ง)
    t.MouseEnter:Connect(function()
        Library:Tween(t, 0.15, {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        })
    end)

    t.MouseLeave:Connect(function()
        Library:Tween(t, 0.15, {
            BackgroundColor3 = Theme.Dark
        })
    end)

    -- Click toggle
    t.MouseButton1Click:Connect(function()
        active = not active
        sound:Play()

        Library:Tween(s, 0.2, {
            BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(60, 60, 60)
        })

        Library:Tween(c, 0.2, {
            Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        })

        if callback then
            pcall(callback, active)
        end
    end)
end

        function Elements:AddSlider(text, min, max, default, callback)
    local parent = self._Page or Page
    local value = default or min
    local dragging = false
    local inputConn, endConn

    -- 🎨 Container
    local s = Instance.new("Frame", parent)
    s.Size = UDim2.new(1, -10, 0, 60)
    s.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", s).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", s)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Transparency = 0.5

    -- 📦 Padding
    local pad = Instance.new("UIPadding", s)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingTop = UDim.new(0, 8)

    -- 📝 Title
    local l = Instance.new("TextLabel", s)
    l.Text = text
    l.Size = UDim2.new(1, -50, 0, 18)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(220, 220, 220)
    l.Font = Enum.Font.GothamSemibold
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left

    -- 🔢 Value (ชัดขึ้น + ขวา)
    local vl = Instance.new("TextLabel", s)
    vl.Text = tostring(value)
    vl.Size = UDim2.new(0, 40, 0, 18)
    vl.Position = UDim2.new(1, -40, 0, 0)
    vl.BackgroundTransparency = 1
    vl.TextColor3 = Color3.fromRGB(180, 180, 180)
    vl.Font = Enum.Font.GothamBold
    vl.TextSize = 13
    vl.TextXAlignment = Enum.TextXAlignment.Right

    -- 🎚️ Bar BG
    local bar = Instance.new("Frame", s)
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.Position = UDim2.new(0, 0, 0, 32)
    bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    -- ✨ Fill (gradient)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    -- 🔘 Knob (ใหญ่ขึ้น + มี depth)
    local knob = Instance.new("Frame", bar)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((value - min)/(max - min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = Color3.fromRGB(100, 100, 100)
    knobStroke.Thickness = 1

    -- 🎯 Update
    local function setValue(x)
        local percent = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * percent)

        value = val
        vl.Text = tostring(val)

        Library:Tween(fill, 0.08, {
            Size = UDim2.new(percent, 0, 1, 0)
        })

        Library:Tween(knob, 0.08, {
            Position = UDim2.new(percent, 0, 0.5, 0)
        })

        if callback then
            pcall(callback, val)
        end
    end

    -- ✨ Hover (ทั้งกล่อง)
    s.MouseEnter:Connect(function()
        Library:Tween(s, 0.15, {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        })
        Library:Tween(stroke, 0.15, {
            Transparency = 0.2
        })
    end)

    s.MouseLeave:Connect(function()
        Library:Tween(s, 0.15, {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        })
        Library:Tween(stroke, 0.15, {
            Transparency = 0.5
        })
    end)

    -- 🔥 Drag
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            setValue(input.Position.X)

            if inputConn then inputConn:Disconnect() end
            if endConn then endConn:Disconnect() end

            inputConn = UserInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch) then
                    setValue(i.Position.X)
                end
            end)

            endConn = UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then

                    dragging = false
                    if inputConn then inputConn:Disconnect() inputConn = nil end
                    if endConn then endConn:Disconnect() endConn = nil end
                end
            end)
        end
    end)
end

        function Elements:AddDropdown(text, list, callback)
    local parent = self._Page or Page
    local expanded = false
    local selectedOption = "Select Options"
    local optionButtons = {}

    -- 🎨 Container (ดำเทา)
    local d = Instance.new("Frame", parent)
    d.Size = UDim2.new(1, -10, 0, 50)
    d.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    d.BorderSizePixel = 0
    d.ClipsDescendants = true
    Instance.new("UICorner", d).CornerRadius = UDim.new(0, 6)

    -- 🔥 Top Line (accent เทาอ่อน)
    local topLine = Instance.new("Frame", d)
    topLine.Size = UDim2.new(1, 0, 0, 2)
    topLine.BackgroundColor3 = Color3.fromRGB(120, 120, 120)

    -- 📝 Label
    local label = Instance.new("TextLabel", d)
    label.Size = UDim2.new(0.4, 0, 0, 50)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- 🔘 Button
    local dropBtn = Instance.new("TextButton", d)
    dropBtn.Size = UDim2.new(0.5, 0, 0, 34)
    dropBtn.Position = UDim2.new(1, -10, 0, 25)
    dropBtn.AnchorPoint = Vector2.new(1, 0.5)
    dropBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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

    -- 🔍 Search
    local searchBar = Instance.new("TextBox", d)
    searchBar.Size = UDim2.new(1, -20, 0, 30)
    searchBar.Position = UDim2.new(0, 10, 0, 55)
    searchBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    searchBar.PlaceholderText = "Search"
    searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBar.Font = Enum.Font.Gotham
    searchBar.TextSize = 13
    Instance.new("UICorner", searchBar)

    -- 📜 List
    local listFrame = Instance.new("ScrollingFrame", d)
    listFrame.Position = UDim2.new(0, 10, 0, 95)
    listFrame.Size = UDim2.new(1, -20, 0, 150)
    listFrame.BackgroundTransparency = 1
    listFrame.ScrollBarThickness = 2
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout", listFrame)
    layout.Padding = UDim.new(0, 5)

    -- 🔍 Search Logic
    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = searchBar.Text:lower()
        for _, btn in pairs(optionButtons) do
            btn.Visible = btn.Name:lower():find(searchText) ~= nil
        end
    end)

    -- 📌 Options
    for _, v in pairs(list) do
        local opt = Instance.new("TextButton", listFrame)
        opt.Name = tostring(v)
        opt.Size = UDim2.new(1, -5, 0, 30)
        opt.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        opt.Text = "  " .. tostring(v)
        opt.TextColor3 = Color3.fromRGB(220, 220, 220)
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 13
        opt.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", opt)

        -- ✨ Hover เอฟเฟค
        opt.MouseEnter:Connect(function()
            opt.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
        opt.MouseLeave:Connect(function()
            opt.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)

        table.insert(optionButtons, opt)

        opt.MouseButton1Click:Connect(function()
            selectedOption = tostring(v)
            dropText.Text = selectedOption
            expanded = false
            Library:Tween(d, 0.2, {Size = UDim2.new(1, -10, 0, 50)})
            if callback then pcall(callback, v) end
        end)
    end

    -- 🔽 Toggle
    dropBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        Library:Tween(d, expanded and 0.3 or 0.2, {
            Size = expanded and UDim2.new(1, -10, 0, 260) or UDim2.new(1, -10, 0, 50)
        })
    end)
end


function Elements:AddMultiDropdown(text, list, callback)
    local parent = self._Page or Page
    local expanded = false
    local selected = {}
    local optionButtons = {}

    -- 🎨 Container
    local md = Instance.new("Frame", parent)
    md.Size = UDim2.new(1, -10, 0, 50)
    md.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    md.ClipsDescendants = true
    Instance.new("UICorner", md).CornerRadius = UDim.new(0, 6)

    -- 🔥 Top Line
    local topLine = Instance.new("Frame", md)
    topLine.Size = UDim2.new(1, 0, 0, 2)
    topLine.BackgroundColor3 = Color3.fromRGB(120, 120, 120)

    -- 📝 Label
    local label = Instance.new("TextLabel", md)
    label.Size = UDim2.new(0.4, 0, 0, 50)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- 🔘 Button
    local dropBtn = Instance.new("TextButton", md)
    dropBtn.Size = UDim2.new(0.5, 0, 0, 34)
    dropBtn.Position = UDim2.new(1, -10, 0, 25)
    dropBtn.AnchorPoint = Vector2.new(1, 0.5)
    dropBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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

    -- 🔍 Search
    local searchBar = Instance.new("TextBox", md)
    searchBar.Size = UDim2.new(1, -20, 0, 30)
    searchBar.Position = UDim2.new(0, 10, 0, 55)
    searchBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    searchBar.PlaceholderText = "Search"
    searchBar.Text = ""
    searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBar.Font = Enum.Font.Gotham
    Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0, 6)

    -- 📜 List
    local listFrame = Instance.new("ScrollingFrame", md)
    listFrame.Position = UDim2.new(0, 10, 0, 95)
    listFrame.Size = UDim2.new(1, -20, 0, 150)
    listFrame.BackgroundTransparency = 1
    listFrame.ScrollBarThickness = 2
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout", listFrame)
    layout.Padding = UDim.new(0, 5)

    -- 🔍 Search filter
    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = searchBar.Text:lower()
        for _, btn in pairs(optionButtons) do
            btn.Visible = btn.Name:lower():find(searchText) ~= nil
        end
    end)

    -- 📌 Options
    for _, v in pairs(list) do
        local opt = Instance.new("TextButton", listFrame)
        opt.Name = tostring(v)
        opt.Size = UDim2.new(1, -5, 0, 30)
        opt.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        opt.Text = "  " .. tostring(v)
        opt.TextColor3 = Color3.fromRGB(180, 180, 180)
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 13
        opt.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 6)

        -- ✨ Indicator (เทาอ่อนแทนแดง)
        local indicator = Instance.new("Frame", opt)
        indicator.Size = UDim2.new(0, 4, 1, 0)
        indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        indicator.Visible = false

        -- ✨ Hover
        opt.MouseEnter:Connect(function()
            opt.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
        opt.MouseLeave:Connect(function()
            if not table.find(selected, v) then
                opt.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
        end)

        table.insert(optionButtons, opt)

        opt.MouseButton1Click:Connect(function()
            local found = table.find(selected, v)

            if found then
                table.remove(selected, found)
                indicator.Visible = false
                opt.TextColor3 = Color3.fromRGB(180, 180, 180)
                opt.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            else
                table.insert(selected, v)
                indicator.Visible = true
                opt.TextColor3 = Color3.fromRGB(255, 255, 255)
                opt.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end

            dropText.Text = (#selected == 0 and "Select Options") or table.concat(selected, ", ")

            if callback then
                pcall(callback, selected)
            end
        end)
    end

    -- 🔽 Toggle
    dropBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        Library:Tween(md, expanded and 0.3 or 0.2, {
            Size = expanded and UDim2.new(1, -10, 0, 260) or UDim2.new(1, -10, 0, 50)
        })
    end)
end


    

        function Elements:AddSection(text)
    local parent = self._Page or Page

    local s = Instance.new("Frame", parent)
    s.Size = UDim2.new(1, -10, 0, 24)
    s.BackgroundTransparency = 1

    -- เส้นซ้าย
    local line = Instance.new("Frame", s)
    line.Size = UDim2.new(0, 3, 0.6, 0)
    line.Position = UDim2.new(0, 0, 0.2, 0)
    line.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)

    -- ข้อความ
    local l = Instance.new("TextLabel", s)
    l.Text = "  ".. tostring(text):upper()
    l.Size = UDim2.new(1, -10, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(180, 180, 180)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left

    -- เส้นขวา (บาง ๆ)
    local fadeLine = Instance.new("Frame", s)
    fadeLine.Size = UDim2.new(1, 0, 0, 1)
    fadeLine.Position = UDim2.new(0, 0, 1, -2)
    fadeLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end

function Elements:AddParagraph(title, content)
    local parent = self._Page or Page

    local p = Instance.new("Frame", parent)
    p.Size = UDim2.new(1, -10, 0, 70)
    p.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 8)

    -- Stroke เบา ๆ
    local stroke = Instance.new("UIStroke", p)
    stroke.Color = Color3.fromRGB(80, 80, 80)
    stroke.Transparency = 0.6

    -- Padding (สำคัญมาก)
    local padding = Instance.new("UIPadding", p)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)

    -- Title
    local tl = Instance.new("TextLabel", p)
    tl.Text = tostring(title)
    tl.Size = UDim2.new(1, 0, 0, 20)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = Color3.fromRGB(230, 230, 230)
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 13
    tl.TextXAlignment = Enum.TextXAlignment.Left

    -- Content
    local cl = Instance.new("TextLabel", p)
    cl.Text = tostring(content)
    cl.Size = UDim2.new(1, 0, 1, -22)
    cl.Position = UDim2.new(0, 0, 0, 22)
    cl.BackgroundTransparency = 1
    cl.TextColor3 = Color3.fromRGB(170, 170, 170)
    cl.Font = Enum.Font.Gotham
    cl.TextWrapped = true
    cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.TextYAlignment = Enum.TextYAlignment.Top
    cl.TextSize = 12
end

function Elements:AddTextBox(text, placeholder, subtext, callback)
    local parent = self._Page or Page

    local box = Instance.new("Frame")
    box.Parent = parent
    box.Size = UDim2.new(1, -10, 0, 60)
    box.BackgroundColor3 = Theme.Dark
    box.BorderSizePixel = 0
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", box)
    stroke.Color = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1

    -- Left side (text info)
    local label = Instance.new("Frame")
    label.Parent = box
    label.Size = UDim2.new(0.6, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1

    local title = Instance.new("TextLabel")
    title.Parent = label
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = Theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left

    local sub = Instance.new("TextLabel")
    sub.Parent = label
    sub.Size = UDim2.new(1, 0, 0, 18)
    sub.Position = UDim2.new(0, 0, 0, 28)
    sub.BackgroundTransparency = 1
    sub.Text = subtext or "Type something..."
    sub.TextColor3 = Theme.TextDark
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 11
    sub.TextXAlignment = Enum.TextXAlignment.Left

    -- Input box
    local inputFrame = Instance.new("Frame")
    inputFrame.Parent = box
    inputFrame.Size = UDim2.new(0.35, 0, 0, 30)
    inputFrame.Position = UDim2.new(1, -10, 0.5, 0)
    inputFrame.AnchorPoint = Vector2.new(1, 0.5)
    inputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 6)

    local inputStroke = Instance.new("UIStroke", inputFrame)
    inputStroke.Color = Color3.fromRGB(60, 60, 60)
    inputStroke.Thickness = 1

    local input = Instance.new("TextBox")
    input.Parent = inputFrame
    input.Size = UDim2.new(1, -10, 1, 0)
    input.Position = UDim2.new(0, 5, 0, 0)
    input.BackgroundTransparency = 1
    input.Text = ""
    input.PlaceholderText = placeholder or "Enter value"
    input.TextColor3 = Theme.Text
    input.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    input.Font = Enum.Font.Gotham
    input.TextSize = 12
    input.ClearTextOnFocus = false
    input.TextXAlignment = Enum.TextXAlignment.Left

    -- Hover effect
    input.Focused:Connect(function()
        Library:Tween(inputStroke, 0.15, {Color = Theme.Accent})
    end)

    input.FocusLost:Connect(function(enterPressed)
        Library:Tween(inputStroke, 0.15, {Color = Color3.fromRGB(60, 60, 60)})

        if callback then
            pcall(function()
                callback(input.Text, enterPressed)
            end)
        end
    end)
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
    Size = UDim2.new(0, 510, 0, 330)
})

task.wait(0.15)

Library:Tween(MainFrame, 0.15, {
    Size = UDim2.new(0, 500, 0, 320)
})
end)

    -- เรียกใช้งาน Minimizer อัตโนมัติหลังสร้าง Window เสร็จ
    Library:CreateMinimizer(MainFrame)
    
    return Window
end


