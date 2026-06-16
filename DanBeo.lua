--[[
    DANBEO HUB // BY AIPEPPAPIG
    Cyberpunk Orange - Professional Mobile Edition
    Optimized with Smooth Tweens, Notification System & Screen Saver
--]]

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 30)

if not PlayerGui then return end
if PlayerGui:FindFirstChild("DanbeoHub") then PlayerGui:FindFirstChild("DanbeoHub"):Destroy() end

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local Vars = {
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    InfJump = false,
    SavedCFrame = nil,
    ESP = false,
    FullBright = false,
    InstantPrompt = false,
    AntiAFK = false,
    OriginalPrompts = {},
    ScreenSaver = false
}

local ThemeColor = Color3.fromRGB(255, 110, 24)

-- KHỞI TẠO GUI CHÍNH
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DanbeoHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- HỆ THỐNG THÔNG BÁO CHUYÊN NGHIỆP (NOTIFICATION SYSTEM)
local NotifyContainer = Instance.new("Frame")
NotifyContainer.Size = UDim2.new(0, 240, 1, 0)
NotifyContainer.Position = UDim2.new(1, -250, 0, 20)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.Parent = ScreenGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Padding = UDim.new(0, 8)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifyLayout.Parent = NotifyContainer

local function Notify(msg, duration)
    duration = duration or 3
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(1, 0, 0, 45)
    Box.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Box.BackgroundTransparency = 1
    Box.ClipsDescendants = true
    Box.Parent = NotifyContainer

    local Corner = Instance.new("UICorner", Box)
    Corner.CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", Box)
    Stroke.Color = ThemeColor
    Stroke.Thickness = 1.5
    Stroke.Transparency = 1

    local Text = Instance.new("TextLabel", Box)
    Text.Size = UDim2.new(1, -20, 1, 0)
    Text.Position = UDim2.new(0, 10, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = msg
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 12
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.TextTransparency = 1

    -- Anim hiện thông báo mượt mà
    TweenService:Create(Box, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(Text, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.delay(duration, function()
        TweenService:Create(Box, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(Text, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.3)
        Box:Destroy()
    end)
end

-- TẤM NỀN TIẾT KIỆM PIN & MÁT MÁY (SCREEN SAVER)
local SaverFrame = Instance.new("Frame")
SaverFrame.Size = UDim2.new(1, 0, 1, 50)
SaverFrame.Position = UDim2.new(0, 0, 0, -50)
SaverFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
SaverFrame.Visible = false
SaverFrame.ZIndex = 99999
SaverFrame.Parent = ScreenGui

local SaverText = Instance.new("TextLabel", SaverFrame)
SaverText.Size = UDim2.new(1, 0, 1, 0)
SaverText.BackgroundTransparency = 1
SaverText.Text = "HỆ THỐNG ĐANG TREO MÁY (AFK MODE ACTIVE)\n[ Chạm đúp vào màn hình để mở lại ]"
SaverText.TextColor3 = ThemeColor
SaverText.Font = Enum.Font.GothamBold
SaverText.TextSize = 18

-- Chạm đúp để tắt chế độ tiết kiệm pin
local lastTouch = 0
SaverFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local now = os.clock()
        if now - lastTouch < 0.4 then
            Vars.ScreenSaver = false
            SaverFrame.Visible = false
            setfpscap(60)
            Notify("Đã tắt chế độ tiết kiệm pin!")
        end
        lastTouch = now
    end
end)


-- THIẾT KẾ KHUNG MENU CHÍNH
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 340)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = ThemeColor
MainStroke.Thickness = 2

-- Thanh Tiêu Đề
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
TopBar.BorderSizePixel = 0

Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local GlowLine = Instance.new("Frame", TopBar)
GlowLine.Size = UDim2.new(1, 0, 0, 1)
GlowLine.Position = UDim2.new(0, 0, 1, -1)
GlowLine.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
GlowLine.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Danbeo Hub // by Aipeppapig"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.Size = UDim2.new(0, 35, 1, 0)
MinimizeBtn.Position = UDim2.new(1, -75, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 75, 75)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16

-- ICON THU NHỎ GAMING ROBLOX
local MiniIcon = Instance.new("ImageButton")
MiniIcon.Name = "MiniIcon"
MiniIcon.Size = UDim2.new(0, 55, 0, 55)
MiniIcon.Position = UDim2.new(0.05, 0, 0.15, 0)
MiniIcon.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MiniIcon.Image = "rbxassetid://6031068433"
MiniIcon.ImageColor3 = ThemeColor
MiniIcon.Visible = false
MiniIcon.Parent = ScreenGui

Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)
local MiniIconStroke = Instance.new("UIStroke", MiniIcon)
MiniIconStroke.Color = ThemeColor
MiniIconStroke.Thickness = 2

-- Sidebar & Content Container
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Sidebar.BorderSizePixel = 0

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local SidebarPadding = Instance.new("UIPadding", Sidebar)
SidebarPadding.PaddingTop = UDim.new(0, 10)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -150, 1, -52)
ContentContainer.Position = UDim2.new(0, 145, 0, 47)
ContentContainer.BackgroundTransparency = 1


-- ENGINE CHỐNG GIẬT KHI KÉO (ANTI-FLICKER DRAG)
local function CreateAntiFlickerDrag(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if input.Target:IsA("TextButton") or input.Target:IsA("ImageButton") or input.Target:IsA("TextBox") or input.Target:IsA("ScrollingFrame") then return end
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
CreateAntiFlickerDrag(MainFrame)
CreateAntiFlickerDrag(MiniIcon)

-- HIỆU ỨNG TWEEN ĐÓNG MỞ MƯỢT MÀ (SMOOTH ANIMATION)
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
    task.wait(0.2)
    ScreenGui:Destroy()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 560, 0, 0)}):Play()
    task.wait(0.15)
    MainFrame.Visible = false
    MiniIcon.Visible = true
    MiniIcon.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MiniIcon, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)

MiniIcon.MouseButton1Click:Connect(function()
    TweenService:Create(MiniIcon, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.15)
    MiniIcon.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 560, 0, 340)}):Play()
end)


-- UI BUILDER LOGIC
local FirstTab = true
local function CreateTab(tabName)
    local TabButton = Instance.new("TextButton", Sidebar)
    TabButton.Size = UDim2.new(0, 125, 0, 36)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(140, 140, 150)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 13
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame", ContentContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0; Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = ThemeColor; Page.Visible = false

    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 8); PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 15) end)

    if FirstTab then Page.Visible = true; TabButton.BackgroundTransparency = 0; TabButton.TextColor3 = ThemeColor; FirstTab = false end

    TabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(ContentContainer:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundTransparency = 1; v.TextColor3 = Color3.fromRGB(140, 140, 150) end end
        Page.Visible = true; TabButton.BackgroundTransparency = 0; TabButton.TextColor3 = ThemeColor
    end)

    local Elements = {}
    function Elements:CreateSection(title)
        local Label = Instance.new("TextLabel", Page)
        Label.Size = UDim2.new(0.96, 0, 0, 25); Label.BackgroundTransparency = 1
        Label.Text = "── " .. string.upper(title) .. " ──"; Label.TextColor3 = Color3.fromRGB(100, 100, 110); Label.Font = Enum.Font.GothamBold; Label.TextSize = 11
    end

    function Elements:CreateButton(text, callback)
        local Btn = Instance.new("TextButton", Page)
        Btn.Size = UDim2.new(0.96, 0, 0, 38); Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        Btn.Text = text; Btn.TextColor3 = Color3.fromRGB(230, 230, 235); Btn.Font = Enum.Font.GothamMedium; Btn.TextSize = 13
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
        local Stroke = Instance.new("UIStroke", Btn) Stroke.Color = Color3.fromRGB(35, 35, 40)
        Btn.MouseButton1Click:Connect(function() pcall(callback) end)
    end

    function Elements:CreateToggle(text, default, callback)
        local TglState = default
        local Frame = Instance.new("Frame", Page) Frame.Size = UDim2.new(0.96, 0, 0, 40); Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
        local Stroke = Instance.new("UIStroke", Frame) Stroke.Color = Color3.fromRGB(35, 35, 40)
        
        local Label = Instance.new("TextLabel", Frame) Label.Size = UDim2.new(0.7, 0, 1, 0); Label.Position = UDim2.new(0, 12, 0, 0); Label.BackgroundTransparency = 1
        Label.Text = text; Label.TextColor3 = Color3.fromRGB(220, 220, 225); Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 13; Label.TextXAlignment = Enum.TextXAlignment.Left

        local Switch = Instance.new("TextButton", Frame) Switch.Size = UDim2.new(0, 45, 0, 22); Switch.Position = UDim2.new(1, -57, 0.5, -11)
        Switch.BackgroundColor3 = TglState and ThemeColor or Color3.fromRGB(45, 45, 50); Switch.Text = ""
        Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame", Switch) Circle.Size = UDim2.new(0, 16, 0, 16)
        Circle.Position = TglState and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        Switch.MouseButton1Click:Connect(function()
            TglState = not TglState
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = TglState and ThemeColor or Color3.fromRGB(45, 45, 50)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = TglState and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)}):Play()
            pcall(callback, TglState)
        end)
    end

    function Elements:CreateSlider(text, min, max, default, callback)
        local Frame = Instance.new("Frame", Page) Frame.Size = UDim2.new(0.96, 0, 0, 48); Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
        local Stroke = Instance.new("UIStroke", Frame) Stroke.Color = Color3.fromRGB(35, 35, 40)

        local Label = Instance.new("TextLabel", Frame) Label.Size = UDim2.new(0.6, 0, 0, 22); Label.Position = UDim2.new(0, 12, 0, 4); Label.BackgroundTransparency = 1
        Label.Text = text; Label.TextColor3 = Color3.fromRGB(220, 220, 225); Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 13; Label.TextXAlignment = Enum.TextXAlignment.Left

        local ValueLabel = Instance.new("TextLabel", Frame) ValueLabel.Size = UDim2.new(0.3, 0, 0, 22); ValueLabel.Position = UDim2.new(1, -122, 0, 4); ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(default); ValueLabel.TextColor3 = ThemeColor; ValueLabel.Font = Enum.Font.GothamBold; ValueLabel.TextSize = 13; ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

        local SliderBar = Instance.new("TextButton", Frame) SliderBar.Size = UDim2.new(0.94, 0, 0, 5); SliderBar.Position = UDim2.new(0.03, 0, 0, 34); SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55); SliderBar.Text = ""
        Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

        local Fill = Instance.new("Frame", SliderBar) Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); Fill.BackgroundColor3 = ThemeColor
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

        local function UpdateSlider(input)
            local sizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * sizeX)
            Fill.Size = UDim2.new(sizeX, 0, 1, 0); ValueLabel.Text = tostring(value)
            pcall(callback, value)
        end

        local sliding = false
        SliderBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true; UpdateSlider(input) end end)
        UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end end)
    end
    return Elements
end


-- PHÂN CHIA HỆ THỐNG 4 TAB

-- TAB 1: PLAYER
local Tab1 = CreateTab("Người Chơi")
Tab1:CreateSection("Chỉ số cơ bản")
Tab1:CreateSlider("Tốc độ di chuyển", 16, 300, 16, function(val) Vars.WalkSpeed = val end)
Tab1:CreateSlider("Sức mạnh nhảy", 50, 400, 50, function(val) Vars.JumpPower = val end)
Tab1:CreateSection("Tính năng đặc biệt")
Tab1:CreateToggle("Đi xuyên tường (Noclip)", false, function(state) Vars.Noclip = state Notify("Noclip: "..(state and "BẬT" or "TẮT")) end)
Tab1:CreateToggle("Nhảy vô hạn trên không", false, function(state) Vars.InfJump = state end)
Tab1:CreateSection("Góc nhìn camera")
Tab1:CreateSlider("Tầm rộng Camera (FOV)", 70, 130, 70, function(val) workspace.CurrentCamera.FieldOfView = val end)

-- TAB 2: TELEPORT
local Tab2 = CreateTab("Dịch Chuyển")
Tab2:CreateSection("Hệ thống tọa độ")
Tab2:CreateButton("Lưu vị trí đứng hiện tại", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then Vars.SavedCFrame = root.CFrame Notify("Đã lưu tọa độ nhân vật!") end
end)
Tab2:CreateButton("Biến hình về vị trí đã lưu", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and Vars.SavedCFrame then root.CFrame = Vars.SavedCFrame Notify("Teleport thành công!") else Notify("Chưa lưu vị trí!", 4) end
end)
Tab2:CreateSection("Công cụ di chuyển")
Tab2:CreateButton("Mở bảng điều khiển Bay (Fly GUI)", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-gui-v3-78856"))() end)

-- TAB 3: VISUALS
local Tab3 = CreateTab("Định Vị")
Tab3:CreateSection("Hỗ trợ quan sát")
Tab3:CreateToggle("Bật Wallhack định vị (ESP)", false, function(state) Vars.ESP = state end)
Tab3:CreateToggle("Siêu sáng bản đồ (FullBright)", false, function(state) Vars.FullBright = state end)

-- TAB 4: LINH TINH (MISC & NEW ADVANCED CHIPS)
local Tab4 = CreateTab("Linh Tinh")
Tab4:CreateSection("Tối ưu tương tác")
Tab4:CreateToggle("Loại bỏ thời gian giữ nút", false, function(state)
    Vars.InstantPrompt = state
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if state then if not Vars.OriginalPrompts[v] then Vars.OriginalPrompts[v] = v.HoldDuration end v.HoldDuration = 0
            else if Vars.OriginalPrompts[v] then v.HoldDuration = Vars.OriginalPrompts[v] end end
        end
    end
    Notify("Instant Prompt: "..(state and "BẬT" or "TẮT"))
end)

Tab4:CreateSection("Treo máy nâng cao (AFK)")
Tab4:CreateToggle("Chống treo máy (Anti-AFK)", false, function(state) Vars.AntiAFK = state end)

-- CHỨC NĂNG MỚI NÂNG CẤP: KHÓA MÀN HÌNH TIẾT KIỆM PIN & GIẢM RAM TỐI ĐA
Tab4:CreateToggle("Màn hình đen tiết kiệm Pin", false, function(state)
    Vars.ScreenSaver = state
    if state then
        setfpscap(5) -- Hạ FPS cực thấp để giảm tải CPU/GPU điện thoại
        SaverFrame.Visible = true
    end
end)

Tab4:CreateSection("Hệ thống & Tối ưu RAM")
Tab4:CreateButton("Giải phóng RAM máy (Anti-Crash)", function()
    -- Xóa sạch các tài nguyên rác sinh ra trong quá trình chơi game để tránh crash Delta
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail") then v:Destroy() end
    end
    collectgarbage("collect") -- Ép hệ thống dọn dẹp RAM ngay lập tức
    Notify("Đã giải phóng bộ nhớ RAM!")
end)

Tab4:CreateButton("Vào lại Server cũ (Rejoin)", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)


-- VÒNG LẶP CHẠY NGẦM LOGIC KHÔNG ĐỔI
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Vars.WalkSpeed; hum.UseJumpPower = true; hum.JumpPower = Vars.JumpPower end
        if Vars.Noclip then for _, part in pairs(char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Vars.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.RenderStepped:Connect(function() if Vars.FullBright then Lighting.Ambient = Color3.fromRGB(255, 255, 255) Lighting.Brightness = 3 end end)

local function CreateESPForPlayer(player)
    if player == LocalPlayer then return end
    local function onCharAdded(char)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if not root then return end
        local hl = Instance.new("Highlight", char) hl.Name = "Danbeo_HL"; hl.FillColor = ThemeColor; hl.FillTransparency = 0.5; hl.Enabled = false
        local bgui = Instance.new("BillboardGui", root) bgui.Name = "Danbeo_BGui"; bgui.Size = UDim2.new(0, 180, 0, 45); bgui.AlwaysOnTop = true; bgui.ExtentsOffset = Vector3.new(0, 3, 0); bgui.Enabled = false
        local lbl = Instance.new("TextLabel", bgui) lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(255, 255, 255); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13
        local conn; conn = RunService.RenderStepped:Connect(function()
            if not char.Parent or not root.Parent or not ScreenGui.Parent then conn:Disconnect() return end
            if Vars.ESP then
                hl.Enabled = true; bgui.Enabled = true
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then lbl.Text = string.format("%s\n[%d m]", player.DisplayName, math.floor((root.Position - myRoot.Position).Magnitude)) else lbl.Text = player.DisplayName end
            else hl.Enabled = false; bgui.Enabled = false end
        end)
    end
    if player.Character then onCharAdded(player.Character) end
    player.CharacterAdded:Connect(onCharAdded)
end
for _, p in pairs(Players:GetPlayers()) do CreateESPForPlayer(p) end
Players.PlayerAdded:Connect(CreateESPForPlayer)

workspace.DescendantAdded:Connect(function(d) if d:IsA("ProximityPrompt") and Vars.InstantPrompt then if not Vars.OriginalPrompts[d] then Vars.OriginalPrompts[d] = d.HoldDuration end d.HoldDuration = 0 end end)
LocalPlayer.Idled:Connect(function() if Vars.AntiAFK then game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(0.5) game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end end)

Notify("Danbeo Hub Loaded Successfully!", 4)
