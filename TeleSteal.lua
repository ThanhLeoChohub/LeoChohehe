-- Danbeo Teleport // Cyberpunk Mobile Edition
-- Optimized for Mobile Executors (Delta, Vega X, Fluxus, Codex...)
-- Author: Grok (Custom Built for Request)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CONFIG_FILE = "DanbeoTeleport_Config.json"
local SAVED_CFRAME = nil

-- ==================== UI COLORS (Cyberpunk Neon Orange) ====================
local COLOR_BG = Color3.fromRGB(14, 14, 16)
local COLOR_ACCENT = Color3.fromRGB(255, 140, 0)   -- Neon Orange
local COLOR_ACCENT_DARK = Color3.fromRGB(200, 80, 0)
local COLOR_TEXT = Color3.fromRGB(255, 255, 255)
local COLOR_STROKE = Color3.fromRGB(255, 180, 50)

-- ==================== CREATE SCREEN GUI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DanbeoTeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- ==================== MAIN FRAME ====================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 280)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
mainFrame.BackgroundColor3 = COLOR_BG
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = COLOR_STROKE
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "DANBEO TELEPORT"
titleLabel.TextColor3 = COLOR_ACCENT
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -55)
contentFrame.Position = UDim2.new(0, 10, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Section Title
local sectionLabel = Instance.new("TextLabel")
sectionLabel.Size = UDim2.new(1, 0, 0, 30)
sectionLabel.BackgroundTransparency = 1
sectionLabel.Text = "Coordinate System"
sectionLabel.TextColor3 = COLOR_TEXT
sectionLabel.TextScaled = true
sectionLabel.Font = Enum.Font.GothamSemibold
sectionLabel.Parent = contentFrame

-- Save Button
local saveBtn = Instance.new("TextButton")
saveBtn.Name = "SaveBtn"
saveBtn.Size = UDim2.new(1, 0, 0, 55)
saveBtn.Position = UDim2.new(0, 0, 0, 40)
saveBtn.BackgroundColor3 = COLOR_ACCENT_DARK
saveBtn.Text = "Save Current Position"
saveBtn.TextColor3 = COLOR_TEXT
saveBtn.TextScaled = true
saveBtn.Font = Enum.Font.GothamBold
saveBtn.Parent = contentFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 10)
saveCorner.Parent = saveBtn

local saveStroke = Instance.new("UIStroke")
saveStroke.Thickness = 1.5
saveStroke.Color = COLOR_ACCENT
saveStroke.Parent = saveBtn

-- Teleport Button
local tpBtn = Instance.new("TextButton")
tpBtn.Name = "TeleportBtn"
tpBtn.Size = UDim2.new(1, 0, 0, 55)
tpBtn.Position = UDim2.new(0, 0, 0, 105)
tpBtn.BackgroundColor3 = COLOR_ACCENT_DARK
tpBtn.Text = "Teleport to Saved Position"
tpBtn.TextColor3 = COLOR_TEXT
tpBtn.TextScaled = true
tpBtn.Font = Enum.Font.GothamBold
tpBtn.Parent = contentFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 10)
tpCorner.Parent = tpBtn

local tpStroke = Instance.new("UIStroke")
tpStroke.Thickness = 1.5
tpStroke.Color = COLOR_ACCENT
tpStroke.Parent = tpBtn

-- ==================== MINI ICON ====================
local miniIcon = Instance.new("Frame")
miniIcon.Name = "MiniIcon"
miniIcon.Size = UDim2.new(0, 60, 0, 60)
miniIcon.Position = UDim2.new(0.9, -30, 0.8, -30)
miniIcon.BackgroundColor3 = COLOR_ACCENT
miniIcon.BorderSizePixel = 0
miniIcon.Visible = false
miniIcon.ZIndex = 20
miniIcon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0) -- Circle
iconCorner.Parent = miniIcon

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 1, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "📍"
iconLabel.TextColor3 = Color3.new(0, 0, 0)
iconLabel.TextScaled = true
iconLabel.Font = Enum.Font.GothamBold
iconLabel.Parent = miniIcon

local iconStroke = Instance.new("UIStroke")
iconStroke.Thickness = 3
iconStroke.Color = Color3.new(1, 1, 1)
iconStroke.Parent = miniIcon

-- ==================== NOTIFICATION SYSTEM ====================
local function createNotification(text: string, isError: boolean)
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 280, 0, 60)
	notif.Position = UDim2.new(1, -300, 0, 20)
	notif.BackgroundColor3 = isError and Color3.fromRGB(180, 40, 40) or COLOR_ACCENT_DARK
	notif.BorderSizePixel = 0
	notif.ZIndex = 100
	notif.Parent = screenGui
	
	local nCorner = Instance.new("UICorner")
	nCorner.CornerRadius = UDim.new(0, 10)
	nCorner.Parent = notif
	
	local nStroke = Instance.new("UIStroke")
	nStroke.Thickness = 2
	nStroke.Color = COLOR_ACCENT
	nStroke.Parent = notif
	
	local nText = Instance.new("TextLabel")
	nText.Size = UDim2.new(1, -20, 1, 0)
	nText.Position = UDim2.new(0, 10, 0, 0)
	nText.BackgroundTransparency = 1
	nText.Text = text
	nText.TextColor3 = Color3.new(1, 1, 1)
	nText.TextScaled = true
	nText.Font = Enum.Font.GothamSemibold
	nText.TextXAlignment = Enum.TextXAlignment.Left
	nText.Parent = notif
	
	-- Slide in
	notif:TweenPosition(UDim2.new(1, -290, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
	
	task.delay(3, function()
		if notif and notif.Parent then
			notif:TweenPosition(UDim2.new(1, 10, 0, 20), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.4, true)
			task.wait(0.4)
			notif:Destroy()
		end
	end)
end

-- ==================== CONFIG SYSTEM ====================
local function saveConfig()
	if not SAVED_CFRAME then return end
	local data = {
		CFrame = {
			X = SAVED_CFRAME.Position.X,
			Y = SAVED_CFRAME.Position.Y,
			Z = SAVED_CFRAME.Position.Z,
			R00 = SAVED_CFRAME.Rotation.X,
			R01 = SAVED_CFRAME.Rotation.Y,
			R02 = SAVED_CFRAME.Rotation.Z,
			-- Simplified storage (full CFrame can be reconstructed)
		}
	}
	
	local success, err = pcall(function()
		writefile(CONFIG_FILE, HttpService:JSONEncode(data))
	end)
	
	if success then
		createNotification("Position Saved to Config!", false)
	else
		createNotification("Failed to save config!", true)
	end
end

local function loadConfig()
	task.spawn(function()
		if isfile(CONFIG_FILE) then
			local success, data = pcall(function()
				local content = readfile(CONFIG_FILE)
				return HttpService:JSONDecode(content)
			end)
			
			if success and data and data.CFrame then
				local cfData = data.CFrame
				SAVED_CFRAME = CFrame.new(cfData.X, cfData.Y, cfData.Z)
				createNotification("Loaded saved position from config", false)
			end
		end
	end)
end

-- ==================== DRAGGABLE FUNCTION (Optimized) ====================
local function makeDraggable(frame: Frame, dragBar: Frame?)
	local dragBar = dragBar or frame
	local dragging = false
	local dragInput: InputObject
	local dragStart: Vector3
	local startPos: UDim2
	
	local function updateInput(input: InputObject)
		if dragging then
			local delta = input.Position - dragStart
			local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			frame.Position = newPos
		end
	end
	
	dragBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	dragBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			updateInput(input)
		end
	end)
end

-- ==================== BUTTON FUNCTIONALITY ====================
saveBtn.MouseButton1Click:Connect(function()
	local character = player.Character
	if not character then 
		createNotification("Character not loaded!", true)
		return 
	end
	
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then 
		createNotification("HumanoidRootPart not found!", true)
		return 
	end
	
	SAVED_CFRAME = root.CFrame
	saveConfig()
	createNotification("Position Saved!", false)
end)

tpBtn.MouseButton1Click:Connect(function()
	local character = player.Character
	if not character then 
		createNotification("Character not loaded!", true)
		return 
	end
	
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then 
		createNotification("HumanoidRootPart not found!", true)
		return 
	end
	
	if not SAVED_CFRAME then
		createNotification("No Saved Position Found!", true)
		return
	end
	
	root.CFrame = SAVED_CFRAME
	createNotification("Teleported to Saved Position!", false)
end)

-- ==================== WINDOW CONTROLS ====================
closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	miniIcon.Visible = true
end)

miniIcon.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		mainFrame.Visible = true
		miniIcon.Visible = false
	end
end)

-- ==================== INIT ====================
makeDraggable(mainFrame, titleBar)
makeDraggable(miniIcon)

-- Load config in background
loadConfig()

-- Initial notification
task.delay(1, function()
	createNotification("Danbeo Teleport Loaded ✓", false)
end)

print("✅ Danbeo Teleport // Cyberpunk Mobile Edition loaded successfully!")
