--[[ 
    LEOCHO HUB - ULTIMATE CLEAN VERSION
    - Đầy đủ: Speed, Jump, Noclip, Custom Fly, ESP, Visuals, Anti-AFK.
    - Giao diện: LeoCho Hub (No Avatar, X/- Buttons, Rainbow Border).
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- 1. BYPASS & SECURITY
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    if not checkcaller() and getnamecallmethod() == "Kick" then return nil end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- 2. UI SETUP
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "LeoChoHub_Ultimate"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 2.2
task.spawn(function()
    while task.wait() do Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "  LeoCho Hub"
Title.Size = UDim2.new(0, 200, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 3. X / - BUTTONS
local MiniBtn = Instance.new("TextButton", ScreenGui)
MiniBtn.Size = UDim2.new(0, 50, 0, 50)
MiniBtn.Position = UDim2.new(0, 20, 0.5, 0)
MiniBtn.Text = "Leo"
MiniBtn.Visible = false
MiniBtn.BackgroundColor3 = Color3.new(0, 0, 0)
MiniBtn.TextColor3 = Color3.new(0, 1, 1)
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local HideBtn = Instance.new("TextButton", MainFrame)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(1, -70, 0, 5)
HideBtn.Text = "-"
HideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HideBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", HideBtn)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
HideBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false MiniBtn.Visible = true end)
MiniBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true MiniBtn.Visible = false end)

-- 4. TABS SYSTEM
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 140, 1, -50)
SideBar.Position = UDim2.new(0, 10, 0, 45)
SideBar.BackgroundTransparency = 1
Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 6)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -170, 1, -55)
Container.Position = UDim2.new(0, 160, 0, 45)
Container.BackgroundTransparency = 1

local function CreateTab(name)
    local TabFrame = Instance.new("ScrollingFrame", Container)
    TabFrame.Size = UDim2.new(1, 1, 1, 1)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = false
    TabFrame.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabFrame).Padding = UDim.new(0, 6)
    local TabBtn = Instance.new("TextButton", SideBar)
    TabBtn.Size = UDim2.new(1, 0, 0, 38)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    TabBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    Instance.new("UICorner", TabBtn)
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        TabFrame.Visible = true
    end)
    return TabFrame
end

local function AddToggle(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.Text = text .. ": OFF"
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s
        b.Text = text .. ": " .. (s and "ON" or "OFF")
        b.TextColor3 = s and Color3.new(0, 1, 1) or Color3.new(1, 1, 1)
        callback(s)
    end)
end

-- 5. CONTENT
local T1 = CreateTab("Visuals 👁️")
local T2 = CreateTab("Movement ⚡")
local T3 = CreateTab("Utilities ⚙️")
local T4 = CreateTab("ESP 🔴")

-- Visuals
AddToggle(T1, "Max Vision", function(s) LocalPlayer.CameraMaxZoomDistance = s and 100000 or 128 end)
AddToggle(T1, "No Fog", function(s) Lighting.FogEnd = s and 999999 or 1000 end)

-- Movement (ĐÃ THÊM ĐỦ SPEED, JUMP, NOCLIP, FLY)
local function CreateSlider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 50)
    f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = text .. ": " .. default
    l.TextColor3 = Color3.new(1, 1, 1)
    l.BackgroundTransparency = 1
    local val = default
    local function b(t, x, d)
        local btn = Instance.new("TextButton", f)
        btn.Size = UDim2.new(0, 30, 0, 20)
        btn.Position = UDim2.new(x, 0, 0.5, 0)
        btn.Text = t
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.MouseButton1Click:Connect(function() 
            val = math.clamp(val + d, min, max)
            l.Text = text .. ": " .. val
            callback(val) 
        end)
    end
    b("-", 0.3, -10) b("+", 0.6, 10)
end

CreateSlider(T2, "WalkSpeed", 16, 500, 16, function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v end)
CreateSlider(T2, "JumpPower", 50, 500, 50, function(v) LocalPlayer.Character.Humanoid.JumpPower = v end)

AddToggle(T2, "Noclip (Xuyên tường)", function(s)
    _G.Noclip = s
    RunService.Stepped:Connect(function()
        if _G.Noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

local FlyBtn = Instance.new("TextButton", T2)
FlyBtn.Size = UDim2.new(1, 0, 0, 35)
FlyBtn.Text = "Kích Hoạt Custom Fly (Script)"
FlyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FlyBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", FlyBtn)
FlyBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-fly-gui-animation-88191"))()
end)

AddToggle(T2, "Inf Jump", function(s) _G.InfJump = s end)
UserInputService.JumpRequest:Connect(function() if _G.InfJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)

-- ESP & Utils
AddToggle(T4, "Show Players", function(s)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if s then Instance.new("Highlight", p.Character).Name = "LeoESP"
            elseif p.Character:FindFirstChild("LeoESP") then p.Character.LeoESP:Destroy() end
        end
    end
end)
AddToggle(T3, "Anti-AFK", function(s)
    if s then LocalPlayer.Idled:Connect(function() game:GetService("VirtualUser"):CaptureController() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end) end
end)

T1.Visible = true
print("LeoCho Hub Full Loaded!")
