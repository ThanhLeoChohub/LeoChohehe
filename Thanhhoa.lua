--================================================--
-- LEOCHO HUB V11 FULL - UI NHỎ GỌN & LOAD CHẮC CHẮN
--================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- Wait load character đầy đủ
repeat task.wait() until player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart")
local character = player.Character
local humanoid = character.Humanoid
local root = character.HumanoidRootPart

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
end)

-- Notification load hub
StarterGui:SetCore("SendNotification", {
	Title = "LeoCho Hub V11",
	Text = "Hub loaded! Nếu không thấy GUI, restart executor hoặc kiểm tra mạng.",
	Duration = 8
})

-- GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 480)
main.Position = UDim2.new(0.5, -150, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

-- Top bar
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 45)
top.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 16)
local topGradient = Instance.new("UIGradient", top)
topGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
}

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "LeoCho Hub V11"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26
title.TextColor3 = Color3.fromRGB(255, 220, 220)
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -45, 0, 5)
close.Text = "X"
close.Font = Enum.Font.SourceSansBold
close.TextSize = 28
close.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 10)
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local mini = Instance.new("TextButton", top)
mini.Size = UDim2.new(0, 35, 0, 35)
mini.Position = UDim2.new(1, -90, 0, 5)
mini.Text = "-"
mini.Font = Enum.Font.SourceSansBold
mini.TextSize = 35
mini.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 10)

local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0.02, 0, 0.5, -30)
icon.Text = "Leo"
icon.Font = Enum.Font.SourceSansBold
icon.TextSize = 32
icon.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
icon.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
icon.Visible = false

mini.MouseButton1Click:Connect(function()
	main.Visible = false
	icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
	main.Visible = true
	icon.Visible = false
end)

-- Hover effect
local function AddHover(btn, origColor)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = origColor:Lerp(Color3.new(1,1,1), 0.15)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = origColor}):Play()
	end)
end

AddHover(close, Color3.fromRGB(220, 60, 60))
AddHover(mini, Color3.fromRGB(90, 90, 90))

-- Scroll
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 55)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 100)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 12)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 20)
end)

local function CreateBox(titleText, height)
	local box = Instance.new("Frame", scroll)
	box.Size = UDim2.new(1, 0, 0, height)
	box.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 14)
	
	local label = Instance.new("TextLabel", box)
	label.Size = UDim2.new(1, -20, 0, 30)
	label.Position = UDim2.new(0, 10, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = titleText
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 20
	label.TextColor3 = Color3.fromRGB(255, 160, 160)
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	return box
end

-- Speed
local speedValue = 16
local speedBox = CreateBox("Speed", 85)

local speedLabel = Instance.new("TextLabel", speedBox)
speedLabel.Position = UDim2.new(0,10,0,35)
speedLabel.Size = UDim2.new(1,-20,0,25)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Value: 16"
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 18
speedLabel.TextColor3 = Color3.new(1,1,1)

local function UpdateSpeed()
	speedLabel.Text = "Value: " .. speedValue
	pcall(function() humanoid.WalkSpeed = speedValue end)
end

local sMinus = Instance.new("TextButton", speedBox)
sMinus.Size = UDim2.new(0.45,0,0,35)
sMinus.Position = UDim2.new(0.05,0,0.62,0)
sMinus.Text = "-"
sMinus.Font = Enum.Font.SourceSansBold
sMinus.TextSize = 24
sMinus.BackgroundColor3 = Color3.fromRGB(55,55,55)
sMinus.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", sMinus).CornerRadius = UDim.new(0,10)
AddHover(sMinus, Color3.fromRGB(55,55,55))

local sPlus = sMinus:Clone()
sPlus.Position = UDim2.new(0.5,0,0.62,0)
sPlus.Text = "+"
sPlus.Parent = speedBox
AddHover(sPlus, Color3.fromRGB(55,55,55))

sMinus.MouseButton1Click:Connect(function()
	speedValue = math.clamp(speedValue-10,16,300)
	UpdateSpeed()
end)
sPlus.MouseButton1Click:Connect(function()
	speedValue = math.clamp(speedValue+10,16,300)
	UpdateSpeed()
end)

-- Jump (tương tự Speed)
local jumpValue = 50
local jumpBox = CreateBox("Jump Power", 85)

local jumpLabel = Instance.new("TextLabel", jumpBox)
jumpLabel.Position = UDim2.new(0,10,0,35)
jumpLabel.Size = UDim2.new(1,-20,0,25)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Value: 50"
jumpLabel.Font = Enum.Font.SourceSans
jumpLabel.TextSize = 18
jumpLabel.TextColor3 = Color3.new(1,1,1)

local function UpdateJump()
	jumpLabel.Text = "Value: " .. jumpValue
	pcall(function() humanoid.JumpPower = jumpValue end)
end

local jMinus = Instance.new("TextButton", jumpBox)
jMinus.Size = UDim2.new(0.45,0,0,35)
jMinus.Position = UDim2.new(0.05,0,0.62,0)
jMinus.Text = "-"
jMinus.Font = Enum.Font.SourceSansBold
jMinus.TextSize = 24
jMinus.BackgroundColor3 = Color3.fromRGB(55,55,55)
jMinus.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", jMinus).CornerRadius = UDim.new(0,10)
AddHover(jMinus, Color3.fromRGB(55,55,55))

local jPlus = jMinus:Clone()
jPlus.Position = UDim2.new(0.5,0,0.62,0)
jPlus.Text = "+"
jPlus.Parent = jumpBox
AddHover(jPlus, Color3.fromRGB(55,55,55))

jMinus.MouseButton1Click:Connect(function()
	jumpValue = math.clamp(jumpValue-10,50,400)
	UpdateJump()
end)
jPlus.MouseButton1Click:Connect(function()
	jumpValue = math.clamp(jumpValue+10,50,400)
	UpdateJump()
end)

-- Noclip
local noclipOn = false
local noclipBox = CreateBox("Noclip", 70)

local noclipBtn = Instance.new("TextButton", noclipBox)
noclipBtn.Size = UDim2.new(0.9,0,0,40)
noclipBtn.Position = UDim2.new(0.05,0,0.35,0)
noclipBtn.Text = "OFF"
noclipBtn.Font = Enum.Font.SourceSansBold
noclipBtn.TextSize = 22
noclipBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
noclipBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0,12)
AddHover(noclipBtn, Color3.fromRGB(60,60,60))

noclipBtn.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	noclipBtn.Text = noclipOn and "ON" or "OFF"
	noclipBtn.BackgroundColor3 = noclipOn and Color3.fromRGB(80,200,80) or Color3.fromRGB(60,60,60)
end)

RunService.Stepped:Connect(function()
	if noclipOn and character then
		pcall(function()
			for _, v in pairs(character:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end)
	end
end)

-- Infinite Jump
local infJump = false
local infBox = CreateBox("Infinite Jump", 70)

local infBtn = Instance.new("TextButton", infBox)
infBtn.Size = UDim2.new(0.9,0,0,40)
infBtn.Position = UDim2.new(0.05,0,0.35,0)
infBtn.Text = "OFF"
infBtn.Font = Enum.Font.SourceSansBold
infBtn.TextSize = 22
infBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
infBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", infBtn).CornerRadius = UDim.new(0,12)
AddHover(infBtn, Color3.fromRGB(60,60,60))

infBtn.MouseButton1Click:Connect(function()
	infJump = not infJump
	infBtn.Text = infJump and "ON" or "OFF"
	infBtn.BackgroundColor3 = infJump and Color3.fromRGB(80,200,80) or Color3.fromRGB(60,60,60)
end)

UIS.JumpRequest:Connect(function()
	if infJump and humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Player Teleport
local selectedPlayer = nil
local tpBox = CreateBox("Player Teleport", 160)

local playerScroll = Instance.new("ScrollingFrame", tpBox)
playerScroll.Size = UDim2.new(0.9,0,0,90)
playerScroll.Position = UDim2.new(0.05,0,0.2,0)
playerScroll.CanvasSize = UDim2.new(0,0,0,0)
playerScroll.ScrollBarThickness = 5
playerScroll.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", playerScroll).CornerRadius = UDim.new(0,10)

local pLayout = Instance.new("UIListLayout", playerScroll)
pLayout.Padding = UDim.new(0,6)

pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	playerScroll.CanvasSize = UDim2.new(0,0,0,pLayout.AbsoluteContentSize.Y + 10)
end)

local function RefreshPlayers()
	for _,v in pairs(playerScroll:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
	
	for _,plr in pairs(Players:GetPlayers()) do
		if plr \~= player then
			local btn = Instance.new("TextButton", playerScroll)
			btn.Size = UDim2.new(1,-10,0,30)
			btn.Text = plr.Name
			btn.Font = Enum.Font.SourceSans
			btn.TextSize = 18
			btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
			btn.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
			AddHover(btn, Color3.fromRGB(50,50,50))
			btn.MouseButton1Click:Connect(function()
				selectedPlayer = plr
			end)
		end
	end
end

RefreshPlayers()
Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)

local tpBtn = Instance.new("TextButton", tpBox)
tpBtn.Size = UDim2.new(0.9,0,0,40)
tpBtn.Position = UDim2.new(0.05,0,0.75,0)
tpBtn.Text = "Teleport To Selected"
tpBtn.Font = Enum.Font.SourceSansBold
tpBtn.TextSize = 20
tpBtn.BackgroundColor3 = Color3.fromRGB(70,70,200)
tpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,12)
AddHover(tpBtn, Color3.fromRGB(70,70,200))

tpBtn.MouseButton1Click:Connect(function()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") and root then
		root.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
	end
end)

-- Fullbright
local fullbrightOn = false
local originalLighting = {
	Ambient = Lighting.Ambient,
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	FogStart = Lighting.FogStart,
	GlobalShadows = Lighting.GlobalShadows
}

local fbBox = CreateBox("Fullbright", 70)

local fbBtn = Instance.new("TextButton", fbBox)
fbBtn.Size = UDim2.new(0.9,0,0,40)
fbBtn.Position = UDim2.new(0.05,0,0.35,0)
fbBtn.Text = "OFF"
fbBtn.Font = Enum.Font.SourceSansBold
fbBtn.TextSize = 22
fbBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
fbBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", fbBtn).CornerRadius = UDim.new(0,12)
AddHover(fbBtn, Color3.fromRGB(60,60,60))

local function ApplyFullbright(enable)
	pcall(function()
		if enable then
			Lighting.Ambient = Color3.new(1,1,1)
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			Lighting.FogEnd = 1e5
			Lighting.FogStart = 0
			Lighting.GlobalShadows = false
		else
			Lighting.Ambient = originalLighting.Ambient
			Lighting.Brightness = originalLighting.Brightness
			Lighting.ClockTime = originalLighting.ClockTime
			Lighting.FogEnd = originalLighting.FogEnd
			Lighting.FogStart = originalLighting.FogStart
			Lighting.GlobalShadows = originalLighting.GlobalShadows
		end
	end)
end

fbBtn.MouseButton1Click:Connect(function()
	fullbrightOn = not fullbrightOn
	fbBtn.Text = fullbrightOn and "ON" or "OFF"
	fbBtn.BackgroundColor3 = fullbrightOn and Color3.fromRGB(80,200,80) or Color3.fromRGB(60,60,60)
	ApplyFullbright(fullbrightOn)
end)

-- Fly load GUI
local flyBox = CreateBox("Fly (Bay GUI)", 70)

local flyBtn = Instance.new("TextButton", flyBox)
flyBtn.Size = UDim2.new(0.9,0,0,40)
flyBtn.Position = UDim2.new(0.05,0,0.35,0)
flyBtn.Text = "OFF"
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextSize = 22
flyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
flyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0,12)
AddHover(flyBtn, Color3.fromRGB(60,60,60))

flyBtn.MouseButton1Click:Connect(function()
	pcall(function()
		if flyBtn.Text == "OFF" then
			flyBtn.Text = "ON"
			flyBtn.BackgroundColor3 = Color3.fromRGB(80,200,80)
			
			local old = player.PlayerGui:FindFirstChild("FlyGui") or player.PlayerGui:FindFirstChild("flygui")
			if old then old:Destroy() end
			
			loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
			
			StarterGui:SetCore("SendNotification", {Title = "Fly", Text = "Loaded Fly V3! Nhấn nút FLY trong GUI để bay.", Duration = 5})
		else
			flyBtn.Text = "OFF"
			flyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
			
			local old = player.PlayerGui:FindFirstChild("FlyGui") or player.PlayerGui:FindFirstChild("flygui")
			if old then old:Destroy() end
			
			StarterGui:SetCore("SendNotification", {Title = "Fly", Text = "Tắt Fly GUI thành công.", Duration = 3})
		end
	end)
end)

-- (Nếu mày muốn thêm ESP hoặc chức năng khác, copy từ bản cũ và dán vào đây)

-- End script
print("LeoCho Hub V11 loaded - Full chức năng!")
