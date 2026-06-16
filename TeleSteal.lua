-- [[ DANBEO TELEPORT // CYBERPUNK MOBILE LIGHTWEIGHT ]]
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

local FILE_NAME = "DanbeoTeleport_Config.json"
local SavedCFrame = nil

-- Hủy UI cũ nếu chạy lại script
if PlayerGui:FindFirstChild("DanbeoTeleport") then PlayerGui["DanbeoTeleport"]:Destroy() end

-- KHỞI TẠO UI CHÍNH
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DanbeoTeleport"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- NOTIFICATION POP-UP
local function Notify(msg)
    task.spawn(function()
        local n = Instance.new("TextLabel")
        n.Size = UDim2.new(0, 200, 0, 35)
        n.Position = UDim2.new(0.5, -100, 0.1, 0)
        n.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
        n.Text = msg
        n.TextColor3 = Color3.fromRGB(255, 102, 0)
        n.Font = Enum.Font.GothamBold
        n.TextSize = 13
        n.Parent = ScreenGui
        Instance.new("UICorner", n).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", n).Color = Color3.fromRGB(255, 102, 0)
        task.wait(1.5)
        n:Destroy()
    end)
end

-- CONFIG AUTO SAVE/LOAD
local function SaveConfig()
    if SavedCFrame then
        writefile(FILE_NAME, HttpService:JSONEncode({Pos = {SavedCFrame:GetComponents()}}))
    end
end

task.spawn(function()
    if isfile and isfile(FILE_NAME) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(FILE_NAME)) end)
        if success and data and data.Pos then
            SavedCFrame = CFrame.new(unpack(data.Pos))
            Notify("Config Loaded!")
        end
    end
end)

-- MENU CHÍNH
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 180)
Main.Position = UDim2.new(0.5, -140, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(255, 102, 0)
MainStroke.Thickness = 2

-- THANH TIÊU ĐỀ (TOPBAR)
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
Top.Parent = Main
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DANBEO TELEPORT"
Title.TextColor3 = Color3.fromRGB(255, 102, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

-- NÚT ĐÓNG (✕)
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 35)
Close.Position = UDim2.new(1, -30, 0, 0)
Close.BackgroundTransparency = 1
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(150, 150, 150)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.Parent = Top

-- NÚT THU NHỎ (—)
local Mini = Instance.new("TextButton")
Mini.Size = UDim2.new(0, 30, 0, 35)
Mini.Position = UDim2.new(1, -60, 0, 0)
Mini.BackgroundTransparency = 1
Mini.Text = "—"
Mini.TextColor3 = Color3.fromRGB(150, 150, 150)
Mini.Font = Enum.Font.GothamBold
Mini.TextSize = 14
Mini.Parent = Top

-- NÚT MINI ICON TRÒN SMART
local MiniIcon = Instance.new("TextButton")
MiniIcon.Size = UDim2.new(0, 50, 0, 50)
MiniIcon.Position = UDim2.new(0, 20, 0, 20)
MiniIcon.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
MiniIcon.Text = "⚡"
MiniIcon.TextColor3 = Color3.fromRGB(255, 102, 0)
MiniIcon.Font = Enum.Font.GothamBlack
MiniIcon.TextSize = 22
MiniIcon.Visible = false
MiniIcon.Parent = ScreenGui
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", MiniIcon)
IconStroke.Color = Color3.fromRGB(255, 102, 0)
IconStroke.Thickness = 2

-- KHU VỰC CHỨC NĂNG (SECTION)
local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(1, -20, 0, 40)
SaveBtn.Position = UDim2.new(0, 10, 0, 55)
SaveBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
SaveBtn.Text = "Save Current Position"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 13
SaveBtn.Parent = Main
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 6)

local TeleBtn = Instance.new("TextButton")
TeleBtn.Size = UDim2.new(1, -20, 0, 40)
TeleBtn.Position = UDim2.new(0, 10, 0, 110)
TeleBtn.BackgroundColor3 = Color3.fromRGB(255, 102, 0)
TeleBtn.Text = "Teleport to Saved Position"
TeleBtn.TextColor3 = Color3.fromRGB(14, 14, 16)
TeleBtn.Font = Enum.Font.GothamBlack
TeleBtn.TextSize = 13
TeleBtn.Parent = Main
Instance.new("UICorner", TeleBtn).CornerRadius = UDim.new(0, 6)

-- HÀM KÉO THẢ MƯỢT CHỐNG LAG
local function Drag(frame, handle)
    local drag, inputStart, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; inputStart = i.Position; startPos = frame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - inputStart
            TS:Create(frame, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end
Drag(Main, Top)
Drag(MiniIcon, MiniIcon)

-- XỬ LÝ SỰ KIỆN
Mini.MouseButton1Click:Connect(function() Main.Visible = false; MiniIcon.Visible = true end)
MiniIcon.MouseButton1Click:Connect(function() MiniIcon.Visible = false; Main.Visible = true end)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

SaveBtn.MouseButton1Click:Connect(function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        SavedCFrame = root.CFrame
        SaveConfig()
        Notify("Position Saved!")
    else
        Notify("Character Not Found!")
    end
end)

TeleBtn.MouseButton1Click:Connect(function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        if SavedCFrame then
            root.CFrame = SavedCFrame
            Notify("Teleported!")
        else
            Notify("No Saved Position!")
        end
    else
        Notify("Character Not Found!")
    end
end)
