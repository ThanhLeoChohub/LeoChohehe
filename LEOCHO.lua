-- [[ GEMINI SUPER HUB V2 - OPTIMIZED FOR DELTA ANDROID ]] --
-- Không Obfuscate | Đầy đủ chú thích | Tối ưu hóa hiệu năng

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Ngăn chặn trùng lặp giao diện trên Delta
if PlayerGui:FindFirstChild("ModernHub") then
    PlayerGui:FindFirstChild("ModernHub"):Destroy()
end

-- ==========================================
-- [ CẤU HÌNH & TRẠNG THÁI ]
-- ==========================================
local Config = {
    Noclip = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,
    UnlockFOV = false,
    FOVValue = 70,
    FullBright = false,
    SavedPosition = nil,
    Waypoints = {},
    ESPEnabled = false,
    -- Tính năng mới thêm:
    FlyEnabled = false,
    FlySpeed = 50,
    AimbotEnabled = false,
    AutoClickEnabled = false,
    AntiAFKEnabled = true
}

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows
}

-- Anti-AFK (Tự động kích hoạt ngầm bảo vệ bạn)
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end
end)

-- ==========================================
-- [ HỆ THỐNG GIAO DIỆN (UI SYSTEM) ]
-- ==========================================
local ModernHub = Instance.new("ScreenGui")
ModernHub.Name = "ModernHub"
ModernHub.Parent = PlayerGui -- Đã đổi sang PlayerGui để Delta chạy mượt
ModernHub.ResetOnSpawn = false

-- Notification System
local function ShowNotification(title, text, duration)
    local NotifFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TitleLabel = Instance.new("TextLabel")
    local TextLabel = Instance.new("TextLabel")
    
    NotifFrame.Size = UDim2.new(0, 240, 0, 65)
    NotifFrame.Position = UDim2.new(1, 30, 1, -85)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.ZIndex = 10
    NotifFrame.Parent = ModernHub
    
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = NotifFrame
    
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    TitleLabel.TextSize = 13
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame
    
    TextLabel.Size = UDim2.new(1, -20, 0, 35)
    TextLabel.Position = UDim2.new(0, 10, 0, 25)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextLabel.TextSize = 11
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top
    TextLabel.TextWrapped = true
    TextLabel.Parent = NotifFrame
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -250, 1, -85)}):Play()
    
    task.delay(duration or 3, function()
        local tweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 30, 1, -85)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function() NotifFrame:Destroy() end)
    end)
end

-- Main GUI
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local Sidebar = Instance.new("Frame")
local SideCorner = Instance.new("UICorner")
local ContentFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")

MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ModernHub

MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

Title.Size = UDim2.new(0, 250, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "GEMINI SUPER HUB v2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame

MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "━"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Parent = MainFrame

Sidebar.Size = UDim2.new(0, 130, 1, -50)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

SideCorner.CornerRadius = UDim.new(0, 8)
SideCorner.Parent = Sidebar

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, -10, 1, -10)
TabContainer.Position = UDim2.new(0, 5, 0, 5)
TabContainer.BackgroundTransparency = 1
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = TabContainer.Parent and Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabContainer
TabListLayout.Padding = UDim.new(0, 5)

ContentFrame.Size = UDim2.new(1, -160, 1, -50)
ContentFrame.Position = UDim2.new(0, 150, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local FloatingIcon = Instance.new("TextButton")
local IconCorner = Instance.new("UICorner")
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
FloatingIcon.Position = UDim2.new(0, 15, 0, 15)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
FloatingIcon.Text = "⚡"
FloatingIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingIcon.TextSize = 22
FloatingIcon.Visible = false
FloatingIcon.Parent = ModernHub

IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatingIcon

-- ==========================================
-- [ XỬ LÝ KÉO THẢ (DRAGGABLE) ]
-- ==========================================
local function MakeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle = dragHandle or frame
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

MakeDraggable(MainFrame, Title)
MakeDraggable(FloatingIcon)

-- ==========================================
-- [ THÀNH PHẦN TẠO NHANH UI ]
-- ==========================================
local Tabs = {}
local FirstTab = true

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local Page = Instance.new("ScrollingFrame")
    local PageLayout = Instance.new("UIListLayout")
    
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextSize = 13
    TabBtn.Parent = TabContainer
    
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabBtn
    
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 2
    Page.Parent = ContentFrame
    
    PageLayout.Parent = Page
    PageLayout.Padding = UDim.new(0, 6)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
    end)
    
    if FirstTab then
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        Page.Visible = true
        FirstTab = false
    end
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            t.Page.Visible = false
        end
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        Page.Visible = true
    end)
    
    table.insert(Tabs, {Btn = TabBtn, Page = Page})
    return Page
end

local function AddToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    local Label = Instance.new("TextLabel")
    local Button = Instance.new("TextButton")
    local BCOrner = Instance.new("UICorner")
    local Indicator = Instance.new("Frame")
    local ICOrner = Instance.new("UICorner")
    
    ToggleFrame.Size = UDim2.new(1, -10, 0, 38)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    ToggleFrame.Parent = parent
    Instance.new("UICorner").Parent = ToggleFrame
    
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    Button.Size = UDim2.new(0, 42, 0, 20)
    Button.Position = UDim2.new(1, -52, 0.5, -10)
    Button.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 55)
    Button.Text = ""
    Button.Parent = ToggleFrame
    BCOrner.CornerRadius = UDim.new(1, 0)
    BCOrner.Parent = Button
    
    Indicator.Size = UDim2.new(0, 14, 0, 14)
    Indicator.Position = default and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Indicator.Parent = Button
    ICCorner.CornerRadius = UDim.new(1, 0)
    ICCorner.Parent = Indicator
    
    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)
        local targetColor = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 55)
        TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        task.spawn(callback, state)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    local Label = Instance.new("TextLabel")
    local SliderBar = Instance.new("TextButton")
    local SliderFill = Instance.new("Frame")
    local ValueLabel = Instance.new("TextLabel")
    
    SliderFrame.Size = UDim2.new(1, -10, 0, 45)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    SliderFrame.Parent = parent
    Instance.new("UICorner").Parent = SliderFrame
    
    Label.Size = UDim2.new(0, 150, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 3)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -60, 0, 3)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    ValueLabel.Font = Enum.Font.SourceSansBold
    ValueLabel.TextSize = 14
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 28)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    SliderBar.Text = ""
    SliderBar.Parent = SliderFrame
    Instance.new("UICorner").Parent = SliderBar
    
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.Parent = SliderBar
    Instance.new("UICorner").Parent = SliderFill
    
    local function UpdateSlider(input)
        local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * percentage)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        ValueLabel.Text = tostring(value)
        task.spawn(callback, value)
    end
    
    local sliding = false
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true; UpdateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
    end)
end

local function AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 14
    Btn.Text = text
    Btn.Parent = parent
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    Btn.MouseButton1Click:Connect(function() task.spawn(callback) end)
    return Btn
end

local function AddTextBox(parent, placeholder, callback)
    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(1, -10, 0, 32)
    Box.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.PlaceholderText = placeholder
    Box.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    Box.Font = Enum.Font.SourceSans
    Box.TextSize = 14
    Box.Parent = parent
    Instance.new("UICorner").Parent = Box
    Box.FocusLost:Connect(function(enter) if enter then task.spawn(callback, Box.Text) end end)
    return Box
end

-- ==========================================
-- [ TẠO TABS NÂNG CẤP ]
-- ==========================================
local MainTab = CreateTab("Chức Năng Plr")
local CombatTab = CreateTab("Bắn Súng/Combat")
local TeleportTab = CreateTab("Dịch Chuyển")
local VisualsTab = CreateTab("Thị Giác (ESP)")
local MiscTab = CreateTab("Hệ Thống")

-- ==========================================
-- [ XỬ LÝ LOGIC CHỨC NĂNG CHÍNH ]
-- ==========================================

-- 1. Noclip
AddToggle(MainTab, "Xuyên Tường (Noclip)", Config.Noclip, function(st) Config.Noclip = st end)
RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- 2. WalkSpeed
AddSlider(MainTab, "Tốc Độ (WalkSpeed)", 16, 250, 16, function(v)
    Config.WalkSpeed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)

-- 3. JumpPower
AddSlider(MainTab, "Độ Cao Nhảy (JumpPower)", 50, 300, 50, function(v)
    Config.JumpPower = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        h.JumpPower = v; h.UseJumpPower = true
    end
end)

-- 4. Infinite Jump
AddToggle(MainTab, "Nhảy Vô Hạn (Inf Jump)", Config.InfJump, function(st) Config.InfJump = st end)
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- NÂNG CẤP MỚI: Tính Năng Fly (Bay Tự Do)
local FlyBodyGyro, FlyBodyVelocity
AddToggle(MainTab, "Bật Chế Độ Bay (Fly)", Config.FlyEnabled, function(st)
    Config.FlyEnabled = st
    if not st and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if FlyBodyGyro then FlyBodyGyro:Destroy() end
        if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end)
AddSlider(MainTab, "Tốc Độ Bay", 10, 200, 50, function(v) Config.FlySpeed = v end)

RunService.RenderStepped:Connect(function()
    if Config.FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = true end
        
        if not FlyBodyGyro then
            FlyBodyGyro = Instance.new("BodyGyro", hrp)
            FlyBodyGyro.P = 9e4
            FlyBodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        end
        if not FlyBodyVelocity then
            FlyBodyVelocity = Instance.new("BodyVelocity", hrp)
            FlyBodyVelocity.velocity = Vector3.new(0, 0.1, 0)
            FlyBodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        end
        
        FlyBodyGyro.cframe = workspace.CurrentCamera.CFrame
        local camera = workspace.CurrentCamera
        local moveDir = Vector3.new(0,0,0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVec
