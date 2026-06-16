-- [[ ROBLOX DANBEO HUB PREMIUM ULTRA HARDCODE - BY AIPEPPAPIG ]]
-- Không sử dụng thư viện ngoài, chạy thuần 100% chống sập trên Mobile/PC
-- Phiên bản: Toàn diện vô hạn tính năng (Full Features Remastered)
-- Tác giả: Aipeppapig

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- [[ KHO LƯU TRỮ TRẠNG THÁI TOÀN CỤC ]]
local Flags = {
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    InfJump = false,
    FOV = 70,
    MaxZoom = false,
    SavedCFrame = nil,
    ESPEnabled = false,
    FullBright = false,
    AntiAFK = false,
    InstantHarvest = true -- Tự động kích hoạt ngay khi chạy
}

-- [[ TẠO GIAO DIỆN SCREEN GUI CHUẨN GỐC ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DanbeoHub_Ultimate"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Hệ thống thông báo góc màn hình (Notification Engine)
local function SendNotification(title, msg)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 260, 0, 70)
    Frame.Position = UDim2.new(1, 20, 1, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 12, 16)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 110, 180) -- Màu hồng thương hiệu Peppapig
    Stroke.Thickness = 2
    Stroke.Parent = Frame

    local TxtTitle = Instance.new("TextLabel")
    TxtTitle.Size = UDim2.new(1, -20, 0, 25)
    TxtTitle.Position = UDim2.new(0, 10, 0, 5)
    TxtTitle.Text = "🐷 " .. title
    TxtTitle.TextColor3 = Color3.fromRGB(255, 130, 190)
    TxtTitle.Font = Enum.Font.GothamBold
    TxtTitle.TextSize = 13
    TxtTitle.TextXAlignment = Enum.TextXAlignment.Left
    TxtTitle.BackgroundTransparency = 1
    TxtTitle.Parent = Frame

    local TxtMsg = Instance.new("TextLabel")
    TxtMsg.Size = UDim2.new(1, -20, 1, -35)
    TxtMsg.Position = UDim2.new(0, 10, 0, 30)
    TxtMsg.Text = msg
    TxtMsg.TextColor3 = Color3.fromRGB(230, 230, 235)
    TxtMsg.Font = Enum.Font.Gotham
    TxtMsg.TextSize = 11
    TxtMsg.TextXAlignment = Enum.TextXAlignment.Left
    TxtMsg.TextWrapped = true
    TxtMsg.BackgroundTransparency = 1
    TxtMsg.Parent = Frame

    TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -280, 1, -100)}):Play()
    task.delay(4, function()
        local t = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 1, -100)})
        t:Play()
        t.Completed:Connect(function() Frame:Destroy() end)
    end)
end

-- [[ CƠ CHẾ KÉO THẢ CHỐNG TRÔI CỦA DANBEO HUB ]]
local function DraggingScript(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ NÚT TRÒN TOGGLE THU NHỎ / PHÓNG TO UI SIÊU CẤP ]]
local MiniBtn = Instance.new("ImageButton")
MiniBtn.Size = UDim2.new(0, 52, 0, 52)
MiniBtn.Position = UDim2.new(0, 20, 0, 80)
MiniBtn.BackgroundColor3 = Color3.fromRGB(20, 15, 22)
MiniBtn.Image = "rbxassetid://13831316131" -- Ảnh Peppa Pig độc quyền
MiniBtn.ImageColor3 = Color3.fromRGB(255, 130, 190)
MiniBtn.Active = true
MiniBtn.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MiniBtn

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(255, 110, 180)
MiniStroke.Thickness = 2
MiniStroke.Parent = MiniBtn

DraggingScript(MiniBtn)

-- [[ KHUNG MENU CHÍNH (MAIN INTERFACE) ]]
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0, 520, 0, 340)
MainMenu.Position = UDim2.new(0.5, -260, 0.5, -170)
MainMenu.BackgroundColor3 = Color3.fromRGB(11, 12, 15)
MainMenu.BorderSizePixel = 0
MainMenu.Active = true
MainMenu.Visible = true
MainMenu.ClipsDescendants = true
MainMenu.Parent = ScreenGui

local MainMenuCorner = Instance.new("UICorner")
MainMenuCorner.CornerRadius = UDim.new(0, 12)
MainMenuCorner.Parent = MainMenu

local MainMenuStroke = Instance.new("UIStroke")
MainMenuStroke.Color = Color3.fromRGB(45, 40, 50)
MainMenuStroke.Thickness = 1.5
MainMenuStroke.Parent = MainMenu

-- Thanh Tiêu Đề Thượng Hạng
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 16, 22)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainMenu

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TopBarLabel = Instance.new("TextLabel")
TopBarLabel.Size = UDim2.new(0.8, 0, 1, 0)
TopBarLabel.Position = UDim2.new(0, 15, 0, 0)
TopBarLabel.Text = "DANBEO HUB  •  by Aipeppapig [ULTRA PRO]"
TopBarLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TopBarLabel.Font = Enum.Font.GothamBold
TopBarLabel.TextSize = 14
TopBarLabel.TextXAlignment = Enum.TextXAlignment.Left
TopBarLabel.BackgroundTransparency = 1
TopBarLabel.Parent = TopBar

-- Đường Chỉ Neon Lấp Lánh phía dưới TopBar
local NeonLine = Instance.new("Frame")
NeonLine.Size = UDim2.new(1, 0, 0, 2)
NeonLine.Position = UDim2.new(0, 0, 1, -2)
NeonLine.BorderSizePixel = 0
NeonLine.Parent = TopBar

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 110, 180)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 90, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 110, 180))
}
Gradient.Parent = NeonLine

DraggingScript(MainMenu)

-- [[ THANH DANH MỤC TAB (SIDEBAR) ]]
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 140, 1, -42)
SideBar.Position = UDim2.new(0, 0, 0, 42)
SideBar.BackgroundColor3 = Color3.fromRGB(14, 13, 18)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainMenu

local SideBarList = Instance.new("UIListLayout")
SideBarList.Parent = SideBar
SideBarList.Padding = UDim.new(0, 6)
SideBarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local SideBarPadding = Instance.new("UIPadding")
SideBarPadding.PaddingTop = UDim.new(0, 10)
SideBarPadding.Parent = SideBar

-- Khu Vực Chứa Các Trang Nội Dung Bên Phải
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -150, 1, -52)
Container.Position = UDim2.new(0, 145, 0, 48)
Container.BackgroundTransparency = 1
Container.Parent = MainMenu

-- [[ CƠ CHẾ KHỞI TẠO TAB & PHÂN CHIA SECTION ]]
local CurrentActiveTab = nil
local FirstTabCheck = true

local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 125, 0, 36)
    TabButton.BackgroundColor3 = Color3.fromRGB(24, 20, 28)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(165, 160, 175)
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.TextSize = 12
    TabButton.Parent = SideBar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton

    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = Color3.fromRGB(38, 35, 45)
    TabStroke.Thickness = 1
    TabStroke.Parent = TabButton

    -- Trang cuộn nội dung ứng với Tab
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 0, 650)
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 110, 180)
    Page.Visible = false
    Page.Parent = Container

    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.Padding = UDim.new(0, 8)
    PageList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Hàm tạo các Tiêu Đề Phân Mục Nhỏ (Section) đúng chuẩn mạng
    local function CreateSection(sectName)
        local SectLabel = Instance.new("TextLabel")
        SectLabel.Size = UDim2.new(1, -10, 0, 25)
        SectLabel.Text = "--- [ " .. string.upper(sectName) .. " ] ---"
        SectLabel.TextColor3 = Color3.fromRGB(255, 110, 180)
        SectLabel.Font = Enum.Font.GothamBold
        SectLabel.TextSize = 11
        SectLabel.TextXAlignment = Enum.TextXAlignment.Center
        SectLabel.BackgroundTransparency = 1
        SectLabel.Parent = Page
    end

    if FirstTabCheck then
        TabButton.BackgroundColor3 = Color3.fromRGB(55, 30, 45)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabStroke.Color = Color3.fromRGB(255, 110, 180)
        Page.Visible = true
        CurrentActiveTab = TabButton
        FirstTabCheck = false
    end

    TabButton.MouseButton1Click:Connect(function()
        for _, obj in pairs(SideBar:GetChildren()) do
            if obj:IsA("TextButton") then
                obj.BackgroundColor3 = Color3.fromRGB(24, 20, 28)
                obj.TextColor3 = Color3.fromRGB(165, 160, 175)
                obj:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(38, 35, 45)
            end
        end
        for _, pg in pairs(Container:GetChildren()) do
            if pg:IsA("ScrollingFrame") then pg.Visible = false end
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(55, 30, 45)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabStroke.Color = Color3.fromRGB(255, 110, 180)
        Page.Visible = true
    end)

    return Page, CreateSection
end

-- [[ KHỞI TẠO CÁC HÀM ĐIỀU KHIỂN CHỨC NĂNG TRONG MENU ]]
local function NewToggle(targetPage, text, current, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -8, 0, 38)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 17, 24)
    Frame.BorderSizePixel = 0
    Frame.Parent = targetPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(225, 225, 230)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local StateBtn = Instance.new("TextButton")
    StateBtn.Size = UDim2.new(0, 42, 0, 20)
    StateBtn.Position = UDim2.new(1, -52, 0, 9)
    StateBtn.BackgroundColor3 = current and Color3.fromRGB(255, 110, 180) or Color3.fromRGB(45, 45, 55)
    StateBtn.Text = ""
    StateBtn.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 10)
    BtnCorner.Parent = StateBtn

    local active = current
    StateBtn.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(StateBtn, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(255, 110, 180) or Color3.fromRGB(45, 45, 55)}):Play()
        pcall(callback, active)
    end)
end

local function NewButton(targetPage, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -8, 0, 36)
    Button.BackgroundColor3 = Color3.fromRGB(24, 22, 30)
    Button.Text = "⚡  " .. text
    Button.TextColor3 = Color3.fromRGB(240, 240, 245)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 12
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = targetPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(50, 45, 55)
    Stroke.Thickness = 1
    Stroke.Parent = Button

    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 110, 180)}):Play()
        task.wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 22, 30)}):Play()
        pcall(callback)
    end)
end

local function NewSlider(targetPage, text, min, max, default, callback)
    local SlideFrame = Instance.new("Frame")
    SlideFrame.Size = UDim2.new(1, -8, 0, 46)
    SlideFrame.BackgroundColor3 = Color3.fromRGB(18, 17, 24)
    SlideFrame.BorderSizePixel = 0
    SlideFrame.Parent = targetPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = SlideFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 22)
    Label.Position = UDim2.new(0, 12, 0, 4)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(215, 215, 220)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = SlideFrame

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0.3, 0, 0, 22)
    ValLabel.Position = UDim2.new(1, -112, 0, 4)
    ValLabel.Text = tostring(default)
    ValLabel.TextColor3 = Color3.fromRGB(255, 110, 180)
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 12
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.BackgroundTransparency = 1
    ValLabel.Parent = SlideFrame

    local MainTrack = Instance.new("TextButton")
    MainTrack.Size = UDim2.new(1, -24, 0, 5)
    MainTrack.Position = UDim2.new(0, 12, 0, 32)
    MainTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    MainTrack.Text = ""
    MainTrack.AutoButtonColor = false
    MainTrack.Parent = SlideFrame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = MainTrack

    local TrackFill = Instance.new("Frame")
    TrackFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    TrackFill.BackgroundColor3 = Color3.fromRGB(255, 110, 180)
    TrackFill.BorderSizePixel = 0
    TrackFill.Parent = MainTrack

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = TrackFill

    local dragging = false
    local function MoveSlider(input)
        local length = MainTrack.AbsoluteSize.X
        local deltaX = input.Position.X - MainTrack.AbsolutePosition.X
        local pct = math.clamp(deltaX / length, 0, 1)
        local finalVal = math.floor(min + (pct * (max - min)))
        TrackFill.Size = UDim2.new(pct, 0, 1, 0)
        ValLabel.Text = tostring(finalVal)
        pcall(callback, finalVal)
    end

    MainTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            MoveSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            MoveSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- =======================================================
-- [[ XÂY DỰNG TOÀN BỘ CÁC MỤC CHỨC NĂNG KHÔNG CẮT XÉN ]]
-- =======================================================

-- TAB 1: NGƯỜI CHƠI (PLAYER)
local PagePlayer, SectPlayer = CreateTab("Người Chơi 🏃‍♂️")

SectPlayer("Tốc Độ & Sức Mạnh")
NewSlider(PagePlayer, "Tốc độ di chuyển (WalkSpeed)", 16, 300, 16, function(v)
    Flags.WalkSpeed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)

NewSlider(PagePlayer, "Sức mạnh nhảy (JumpPower)", 50, 400, 50, function(v)
    Flags.JumpPower = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.JumpPower = v
        hum.UseJumpPower = true
    end
end)

SectPlayer("Khả Năng Đặc Biệt")
NewToggle(PagePlayer, "Đi xuyên tường (Noclip)", false, function(v)
    Flags.Noclip = v
end)

NewToggle(PagePlayer, "Nhảy vô hạn trên không (Inf Jump)", false, function(v)
    Flags.InfJump = v
end)

SectPlayer("Cấu Hình Tầm Nhìn")
NewSlider(PagePlayer, "Góc nhìn rộng (FOV Camera)", 70, 130, 70, function(v)
    Flags.FOV = v
    workspace.CurrentCamera.FieldOfView = v
end)

NewToggle(PagePlayer, "Mở khóa Max Zoom Camera", false, function(v)
    Flags.MaxZoom = v
    if v then
        LocalPlayer.CameraMaxZoomDistance = 5000
    else
        LocalPlayer.CameraMaxZoomDistance = 400
    end
end)


-- TAB 2: DỊCH CHUYỂN (TELEPORT)
local PageTeleport, SectTeleport = CreateTab("Dịch Chuyển 📍")

SectTeleport("Tọa Độ Cá Nhân")
NewButton(PageTeleport, "Ghi nhớ / Lưu vị trí hiện tại", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Flags.SavedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        SendNotification("TỌA ĐỘ", "Đã ghi nhớ vị trí đứng thành công!")
    end
end)

NewButton(PageTeleport, "Biến hình về vị trí đã lưu", function()
    if Flags.SavedCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = Flags.SavedCFrame
    else
        SendNotification("LỖI HỆ THỐNG", "Bạn chưa thực hiện lưu tọa độ!")
    end
end)

SectTeleport("Công Cụ Hỗ Trợ Khác")
NewButton(PageTeleport, "Mở bảng điều khiển Bay (Universal Fly GUI)", function()
    SendNotification("FLY SCRIPT", "Đang tải Fly GUI mạng...")
    pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-gui-v3-78856"))() end)
end)


-- TAB 3: ĐỊNH VỊ (VISUALS)
local PageVisuals, SectVisuals = CreateTab("Định Vị ESP 👁️")

SectVisuals("Quét Vị Trí Người Chơi")
NewToggle(PageVisuals, "Kích hoạt Wallhack định vị (ESP)", false, function(v)
    Flags.ESPEnabled = v
end)

SectVisuals("Môi Trường Bản Đồ")
NewToggle(PageVisuals, "Siêu sáng bản đồ (FullBright)", false, function(v)
    Flags.FullBright = v
    if v then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = Color3.fromRGB(130, 130, 130)
        Lighting.Brightness = 1
    end
end)


-- TAB 4: LINH TINH & HỆ THỐNG (SERVER)
local PageServer, SectServer = CreateTab("Linh Tinh ⚙️")

SectServer("Quản Lý Phòng Chơi")
NewButton(PageServer, "Vào lại Server cũ (Rejoin Server)", function()
    pcall(function() TeleportService:Tele
