-- Location: Place this script inside a LocalScript inside StarterGui
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Cyberpunk Color Palette
local COLORS = {
	Background = Color3.fromRGB(11, 11, 15),
	Header = Color3.fromRGB(18, 18, 24),
	AccentCyan = Color3.fromRGB(0, 255, 240),
	AccentPink = Color3.fromRGB(255, 0, 127),
	TextMain = Color3.fromRGB(240, 240, 250),
	TextDark = Color3.fromRGB(120, 120, 135),
	ButtonNormal = Color3.fromRGB(24, 24, 32),
	ButtonHover = Color3.fromRGB(35, 35, 48),
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltraUniversalAdminHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 380)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
mainFrame.BackgroundColor3 = COLORS.Background
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- UI Corner & Stroke (Cyberpunk Cybernetic Border)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 6)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = COLORS.AccentCyan
uiStroke.Thickness = 1.5
uiStroke.Parent = mainFrame

-- Glow Effect (Simulated via a faint secondary border)
local glowStroke = Instance.new("UIStroke")
glowStroke.Color = COLORS.AccentPink
glowStroke.Thickness = 0.5
glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glowStroke.Parent = mainFrame

-- Title/Header Bar
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = COLORS.Header
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 6)
headerCorner.Parent = header

-- Title Text
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ULTRA UNIVERSAL ADMIN HUB"
title.TextColor3 = COLORS.AccentCyan
title.Font = Enum.Font.RobotoMono
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Toggle Key Info
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(0.35, 0, 1, 0)
infoText.Position = UDim2.new(0.6, 0, 0, 0)
infoText.BackgroundTransparency = 1
infoText.Text = "[RightShift to Toggle]"
infoText.TextColor3 = COLORS.TextDark
infoText.Font = Enum.Font.SourceSansItalic
infoText.TextSize = 12
infoText.TextXAlignment = Enum.TextXAlignment.Right
infoText.Parent = header

-- Sidebar (Tabs navigation)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = COLORS.Header
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarLine = Instance.new("Frame")
sidebarLine.Size = UDim2.new(0, 1, 1, 0)
sidebarLine.Position = UDim2.new(1, -1, 0, 0)
sidebarLine.BackgroundColor3 = COLORS.AccentPink
sidebarLine.BorderSizePixel = 0
sidebarLine.Parent = sidebar

-- Content Container
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -145, 1, -45)
contentContainer.Position = UDim2.new(0, 145, 0, 45)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

----------------------------------------------------
-- DRAGGING FUNCTIONALITY
----------------------------------------------------
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

----------------------------------------------------
-- SCREEN TOGGLE BUTTON (ON/OFF)
----------------------------------------------------
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0.02, 0, 0.8, 0)
toggleButton.BackgroundColor3 = COLORS.Background
toggleButton.Text = "HUB"
toggleButton.TextColor3 = COLORS.AccentCyan
toggleButton.Font = Enum.Font.RobotoMono
toggleButton.TextSize = 14
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0) -- Circular Button
btnCorner.Parent = toggleButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = COLORS.AccentPink
btnStroke.Thickness = 2
btnStroke.Parent = toggleButton

-- Toggle button animation
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
	local targetColor = mainFrame.Visible and COLORS.AccentCyan or COLORS.AccentPink
	TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = targetColor}):Play()
end)

----------------------------------------------------
-- TAB AND FEATURE CREATION (MODULAR SYSTEM)
----------------------------------------------------
local tabs = {}
local activeTab = nil

local function createTab(tabName)
	-- Create ScrollFrame for Tab Content
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -10, 1, -10)
	scrollFrame.Position = UDim2.new(0, 5, 0, 5)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 4
	scrollFrame.ScrollBarImageColor3 = COLORS.AccentPink
	scrollFrame.Visible = false
	scrollFrame.Parent = contentContainer

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = scrollFrame

	-- Sidebar Tab Button
	local tabButton = Instance.new("TextButton")
	tabButton.Size = UDim2.new(0.9, 0, 0, 35)
	tabButton.Position = UDim2.new(0.05, 0, 0, (#sidebar:GetChildren() - 1) * 40 + 10)
	tabButton.BackgroundColor3 = COLORS.ButtonNormal
	tabButton.Text = tabName:upper()
	tabButton.TextColor3 = COLORS.TextDark
	tabButton.Font = Enum.Font.RobotoMono
	tabButton.TextSize = 13
	tabButton.BorderSizePixel = 0
	tabButton.Parent = sidebar

	local sidebarBtnCorner = Instance.new("UICorner")
	sidebarBtnCorner.CornerRadius = UDim.new(0, 4)
	sidebarBtnCorner.Parent = tabButton

	-- Hover & Click effects
	tabButton.MouseEnter:Connect(function()
		if activeTab ~= tabName then
			TweenService:Create(tabButton, TweenInfo.new(0.2), {TextColor3 = COLORS.AccentCyan}):Play()
		end
	end)

	tabButton.MouseLeave:Connect(function()
		if activeTab ~= tabName then
			TweenService:Create(tabButton, TweenInfo.new(0.2), {TextColor3 = COLORS.TextDark}):Play()
		end
	end)

	local function select()
		for name, data in pairs(tabs) do
			data.Frame.Visible = false
			TweenService:Create(data.Button, TweenInfo.new(0.2), {TextColor3 = COLORS.TextDark, BackgroundColor3 = COLORS.ButtonNormal}):Play()
		end
		activeTab = tabName
		scrollFrame.Visible = true
		TweenService:Create(tabButton, TweenInfo.new(0.2), {TextColor3 = COLORS.AccentPink, BackgroundColor3 = COLORS.ButtonHover}):Play()
	end

	tabButton.MouseButton1Click:Connect(select)

	tabs[tabName] = {
		Frame = scrollFrame,
		Button = tabButton,
		Select = select
	}

	return scrollFrame
end

-- Helper: Create Standard Button within a tab
local function createButton(parentTabFrame, text, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.95, 0, 0, 40)
	button.BackgroundColor3 = COLORS.ButtonNormal
	button.Text = text
	button.TextColor3 = COLORS.TextMain
	button.Font = Enum.Font.SourceSansSemibold
	button.TextSize = 15
	button.BorderSizePixel = 0
	button.Parent = parentTabFrame

	local elementCorner = Instance.new("UICorner")
	elementCorner.CornerRadius = UDim.new(0, 4)
	elementCorner.Parent = button

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = COLORS.ButtonHover
	btnStroke.Thickness = 1
	btnStroke.Parent = button

	-- Animations
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.ButtonHover}):Play()
		TweenService:Create(btnStroke, TweenInfo.new(0.15), {Color = COLORS.AccentCyan}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.ButtonNormal}):Play()
		TweenService:Create(btnStroke, TweenInfo.new(0.15), {Color = COLORS.ButtonHover}):Play()
	end)

	button.MouseButton1Click:Connect(callback)
	return button
end

-- Helper: Create Value Slider/Input
local function createTextBox(parentTabFrame, placeholder, callback)
	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(0.95, 0, 0, 40)
	textBox.BackgroundColor3 = COLORS.ButtonNormal
	textBox.PlaceholderText = placeholder
	textBox.PlaceholderColor3 = COLORS.TextDark
	textBox.Text = ""
	textBox.TextColor3 = COLORS.AccentCyan
	textBox.Font = Enum.Font.SourceSansSemibold
	textBox.TextSize = 15
	textBox.BorderSizePixel = 0
	textBox.Parent = parentTabFrame

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 4)
	boxCorner.Parent = textBox

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Color = COLORS.ButtonHover
	boxStroke.Thickness = 1
	boxStroke.Parent = textBox

	textBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			callback(textBox.Text)
		end
	end)
	
	return textBox
end

----------------------------------------------------
-- CREATING TABS & POPULATING FEATURES
----------------------------------------------------

-- =================================================
-- 1. MOVEMENT TAB
-- =================================================
local movementTab = createTab("Movement")

createTextBox(movementTab, "Set Speed (Default: 16)", function(val)
	local num = tonumber(val)
	if num then
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = num end
	end
end)

createTextBox(movementTab, "Set JumpPower (Default: 50)", function(val)
	local num = tonumber(val)
	if num then
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.UseJumpPower = true
			hum.JumpPower = num
		end
	end
end)

-- Fly Mechanic
local flying = false
local flySpeed = 50
local flyConnection = nil

local function toggleFly()
	flying = not flying
	local char = player.Character or player.CharacterAdded:Wait()
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	
	if flying then
		local bv = Instance.new("BodyVelocity")
		bv.Name = "DevFlyVelocity"
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.Parent = root
		
		local bg = Instance.new("BodyGyro")
		bg.Name = "DevFlyGyro"
		bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bg.CFrame = root.CFrame
		bg.Parent = root
		
		flyConnection = RunService.RenderStepped:Connect(localMove)
	else
		if flyConnection then flyConnection:Disconnect() end
		local bv = root:FindFirstChild("DevFlyVelocity")
		local bg = root:FindFirstChild("DevFlyGyro")
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end

function localMove()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end
	
	local bv = root:FindFirstChild("DevFlyVelocity")
	local bg = root:FindFirstChild("DevFlyGyro")
	if not bv or not bg then return end
	
	local dir = hum.MoveDirection
	local finalVelocity = dir * flySpeed
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		finalVelocity = finalVelocity + Vector3.new(0, flySpeed, 0)
	elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		finalVelocity = finalVelocity - Vector3.new(0, flySpeed, 0)
	end
	
	bv.Velocity = finalVelocity
	bg.CFrame = camera.CFrame
end

createButton(movementTab, "Toggle Flight Mode", function()
	toggleFly()
end)

-- Infinite Jump Feature
local infiniteJumpEnabled = false
local infJumpConnection = nil

createButton(movementTab, "Toggle Infinite Jump", function()
	infiniteJumpEnabled = not infiniteJumpEnabled
	if infiniteJumpEnabled then
		infJumpConnection = UserInputService.JumpRequest:Connect(function()
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	else
		if infJumpConnection then
			infJumpConnection:Disconnect()
			infJumpConnection = nil
		end
	end
end)

-- No-Clip Feature (Local Collisions)
local noclipEnabled = false
local noclipConnection = nil

createButton(movementTab, "Toggle No-Clip (Pass Walls)", function()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		noclipConnection = RunService.Stepped:Connect(function()
			local char = player.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
	end
end)

-- =================================================
-- 2. VISUALS TAB
-- =================================================
local visualsTab = createTab("Visuals")

createButton(visualsTab, "Set Day Time", function()
	game:GetService("Lighting").TimeOfDay = "12:00:00"
end)

createButton(visualsTab, "Set Night Time", function()
	game:GetService("Lighting").TimeOfDay = "00:00:00"
end)

createButton(visualsTab, "Remove Fog", function()
	game:GetService("Lighting").FogEnd = 999999
end)

createTextBox(visualsTab, "Set Gravity (Default: 196.2)", function(val)
	local num = tonumber(val)
	if num then
		workspace.Gravity = num
	end
end)

-- =================================================
-- 3. UTILITY TAB
-- =================================================
local utilityTab = createTab("Utility")

createButton(utilityTab, "Reset Character", function()
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.Health = 0 end
	end
end)

createButton(utilityTab, "Teleport to World Spawn", function()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local spawnPoint = workspace:FindFirstChildOfClass("SpawnLocation")
	
	if root and spawnPoint then
		root.CFrame = spawnPoint.CFrame + Vector3.new(0, 5, 0)
	end
end)

-- =================================================
-- 4. STATS TAB (REAL-TIME ENGINE DATA)
-- =================================================
local statsTab = createTab("Stats")

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.95, 0, 0, 40)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: Calculating..."
fpsLabel.TextColor3 = COLORS.AccentCyan
fpsLabel.Font = Enum.Font.RobotoMono
fpsLabel.TextSize = 14
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = statsTab

local posLabel = Instance.new("TextLabel")
posLabel.Size = UDim2.new(0.95, 0, 0, 40)
posLabel.BackgroundTransparency = 1
posLabel.Text = "Position: X: 0, Y: 0, Z: 0"
posLabel.TextColor3 = COLORS.TextMain
posLabel.Font = Enum.Font.RobotoMono
posLabel.TextSize = 12
posLabel.TextXAlignment = Enum.TextXAlignment.Left
posLabel.Parent = statsTab

-- Real-time Engine Updates for Stats
local lastUpdate = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
	frameCount = frameCount + 1
	local now = tick()
	if now - lastUpdate >= 1 then
		fpsLabel.Text = "FPS: " .. tostring(frameCount)
		frameCount = 0
		lastUpdate = now
	end
	
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		local pos = root.Position
		posLabel.Text = string.format("POS: X: %.2f, Y: %.2f, Z: %.2f", pos.X, pos.Y, pos.Z)
	else
		posLabel.Text = "Character not loaded."
	end
end)

----------------------------------------------------
-- INITIALIZE AND TOGGLE LOGIC
----------------------------------------------------
-- Default Select first tab
if tabs["Movement"] then
	tabs["Movement"].Select()
end

-- Keybind to Toggle Menu Visibility (RightShift)
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
		local targetColor = mainFrame.Visible and COLORS.AccentCyan or COLORS.AccentPink
		TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = targetColor}):Play()
	end
end)
