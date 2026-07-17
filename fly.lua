-- =================================================================
-- ULTRA UNIVERSAL GAME HUB (ADVANCED AAA EDITION - COMPLETED)
-- Optimized for High-End Look, Compatibility & Performance
-- =================================================================

-- 1. Ensure Game loads fully
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
while not player do
	task.wait(0.1)
	player = Players.LocalPlayer
end

local camera = workspace.CurrentCamera

-- Cyberpunk Neon Palette
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

-- SAFE GUI PARENTING (Bypasses Game Detection on Mobile)
local parent = nil
local gethui = gethui or nil

if gethui then
	parent = gethui()
else
	local success, _ = pcall(function()
		parent = game:GetService("CoreGui")
	end)
	if not success or not parent then
		parent = player:WaitForChild("PlayerGui", 10)
	end
end

screenGui.Parent = parent

-- Main Panel Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 380)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
mainFrame.BackgroundColor3 = COLORS.Background
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true -- Required for sliding open/close transition
mainFrame.Parent = screenGui

-- Rounded Corners and Glowing Cybernetic Borders
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 6)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = COLORS.AccentCyan
uiStroke.Thickness = 1.5
uiStroke.Parent = mainFrame

local glowStroke = Instance.new("UIStroke")
glowStroke.Color = COLORS.AccentPink
glowStroke.Thickness = 0.5
glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glowStroke.Parent = mainFrame

-- ADVANCED: Pulsing Neon Border Animation
task.spawn(function()
	while task.wait(1) do
		pcall(function()
			TweenService:Create(uiStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = COLORS.AccentPink}):Play()
			TweenService:Create(glowStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = COLORS.AccentCyan}):Play()
			task.wait(1)
			TweenService:Create(uiStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = COLORS.AccentCyan}):Play()
			TweenService:Create(glowStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = COLORS.AccentPink}):Play()
		end)
	end
end)

-- Title Header Bar
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = COLORS.Header
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 6)
headerCorner.Parent = header

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

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(0.35, 0, 1, 0)
infoText.Position = UDim2.new(0.6, 0, 0, 0)
infoText.BackgroundTransparency = 1
infoText.Text = "[Drag Header or Toggle]"
infoText.TextColor3 = COLORS.TextDark
infoText.Font = Enum.Font.SourceSansItalic
infoText.TextSize = 11
infoText.TextXAlignment = Enum.TextXAlignment.Right
infoText.Parent = header

-- Sidebar (Tabs Area)
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

-- Tab Content Window
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -145, 1, -45)
contentContainer.Position = UDim2.new(0, 145, 0, 45)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

----------------------------------------------------
-- DRAGGING ENGINE (For Mobile Touch & PC Mouse)
----------------------------------------------------
local function makeDraggable(dragObject, targetFrame)
	local dragging, dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	dragObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = targetFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragObject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

-- Header dragging
makeDraggable(header, mainFrame)

----------------------------------------------------
-- FLOATING EXTERNAL FPS HUD (Outside UI)
----------------------------------------------------
local floatingHud = Instance.new("Frame")
floatingHud.Size = UDim2.new(0, 110, 0, 35)
floatingHud.Position = UDim2.new(0.02, 0, 0.05, 0)
floatingHud.BackgroundColor3 = COLORS.Background
floatingHud.BorderSizePixel = 0
floatingHud.Parent = screenGui

local hudCorner = Instance.new("UICorner")
hudCorner.CornerRadius = UDim.new(0, 4)
hudCorner.Parent = floatingHud

local hudStroke = Instance.new("UIStroke")
hudStroke.Color = COLORS.AccentCyan
hudStroke.Thickness = 1
hudStroke.Parent = floatingHud

local fpsTextLabel = Instance.new("TextLabel")
fpsTextLabel.Size = UDim2.new(1, 0, 1, 0)
fpsTextLabel.BackgroundTransparency = 1
fpsTextLabel.Text = "FPS: ..."
fpsTextLabel.TextColor3 = COLORS.AccentCyan
fpsTextLabel.Font = Enum.Font.RobotoMono
fpsTextLabel.TextSize = 13
fpsTextLabel.Parent = floatingHud

-- Make FPS box draggable
makeDraggable(floatingHud, floatingHud)

-- FPS tracking loop
local lastUpdate = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
	frameCount = frameCount + 1
	local now = tick()
	if now - lastUpdate >= 1 then
		fpsTextLabel.Text = "FPS: " .. tostring(frameCount)
		frameCount = 0
		lastUpdate = now
	end
end)

----------------------------------------------------
-- DRAGGABLE ON/OFF TOGGLE BUTTON (WITH SMOOTH SLIDE)
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
btnCorner.CornerRadius = UDim.new(1, 0) -- Circle
btnCorner.Parent = toggleButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = COLORS.AccentPink
btnStroke.Thickness = 2
btnStroke.Parent = toggleButton

-- ADVANCED: Sliding opening & closing GUI transition
local isMenuVisible = true
local function toggleMenu()
	isMenuVisible = not isMenuVisible
	local targetColor = isMenuVisible and COLORS.AccentCyan or COLORS.AccentPink
	TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = targetColor}):Play()
	
	if isMenuVisible then
		mainFrame.Visible = true
		mainFrame:TweenSize(UDim2.new(0, 550, 0, 380), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
	else
		mainFrame:TweenSize(UDim2.new(0, 550, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true, function()
			mainFrame.Visible = false
		end)
	end
end

toggleButton.MouseButton1Click:Connect(toggleMenu)
makeDraggable(toggleButton, toggleButton)

----------------------------------------------------
-- MODULAR TAB CREATOR WITH ACTIVE TIPS
----------------------------------------------------
local tabs = {}
local activeTab = nil

local function createTab(tabName)
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

-- Helper: Standard Button
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

	local bStroke = Instance.new("UIStroke")
	bStroke.Color = COLORS.ButtonHover
	bStroke.Thickness = 1
	bStroke.Parent = button

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.ButtonHover}):Play()
		TweenService:Create(bStroke, TweenInfo.new(0.15), {Color = COLORS.AccentCyan}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.ButtonNormal}):Play()
		TweenService:Create(bStroke, TweenInfo.new(0.15), {Color = COLORS.ButtonHover}):Play()
	end)

	button.MouseButton1Click:Connect(callback)
	return button
end

-- Helper: Toggle Button with Dynamic [ON] / [OFF] Tips
local function createToggleButton(parentTabFrame, text, defaultState, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.95, 0, 0, 40)
	button.BackgroundColor3 = COLORS.ButtonNormal
	button.Text = text .. " [OFF]"
	button.TextColor3 = COLORS.TextMain
	button.Font = Enum.Font.SourceSansSemibold
	button.TextSize = 15
	button.BorderSizePixel = 0
	button.Parent = parentTabFrame

	local elementCorner = Instance.new("UICorner")
	elementCorner.CornerRadius = UDim.new(0, 4)
	elementCorner.Parent = button

	local bStroke = Instance.new("UIStroke")
	bStroke.Color = COLORS.ButtonHover
	bStroke.Thickness = 1
	bStroke.Parent = button

	local active = defaultState or false

	local function updateVisualState()
		if active then
			button.Text = text .. " [ON]"
			button.TextColor3 = COLORS.AccentCyan
			bStroke.Color = COLORS.AccentCyan
		else
			button.Text = text .. " [OFF]"
			button.TextColor3 = COLORS.TextMain
			bStroke.Color = COLORS.ButtonHover
		end
	end

	updateVisualState()

	button.MouseButton1Click:Connect(function()
		active = not active
		updateVisualState()
		callback(active)
	end)

	button.MouseEnter:Connect(function()
		if not active then
			TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.ButtonHover}):Play()
		end
	end)

	button.MouseLeave:Connect(function()
		if not active then
			TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.ButtonNormal}):Play()
		end
	end)

	return button
end

-- Helper: Input Text Box
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

-- PC & MOBILE COMPATIBLE SMOOTH FLY ENGINE (Camera Relative)
local flying = false
local flySpeed = 60
local flyConnection = nil

local function getFlyDirection(hum)
	local moveDirection = Vector3.new(0, 0, 0)
	local cameraCFrame = camera.CFrame
	local isPC = false
	
	-- Keyboard detection (PC Only)
	if UserInputService:GetFocusedTextBox() == nil then
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cameraCFrame.LookVector isPC = true end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cameraCFrame.LookVector isPC = true end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cameraCFrame.RightVector isPC = true end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cameraCFrame.RightVector isPC = true end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) isPC = true end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) isPC = true end
	end
	
	-- Mobile Joystick detection (Works universally on Phone thumbsticks)
	if not isPC and hum and hum.MoveDirection.Magnitude > 0 then
		moveDirection = cameraCFrame.LookVector * hum.MoveDirection.Magnitude
	end
	
	return moveDirection
end

local function handleFlight(state)
	flying = state
	local char = player.Character or player.CharacterAdded:Wait()
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end

	if flying then
		hum.PlatformStand = true
		flyConnection = RunService.RenderStepped:Connect(function(dt)
			local moveDirection = getFlyDirection(hum)

			if moveDirection.Magnitude > 0 then
				moveDirection = moveDirection.Unit * flySpeed
			else
				moveDirection = Vector3.new(0, 0, 0)
			end

			root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			root.CFrame = root.CFrame + (moveDirection * dt)
		end)
	else
		if flyConnection then
			flyConnection:Disconnect()
			flyConnection = nil
		end
		hum.PlatformStand = false
		root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	end
end

createToggleButton(movementTab, "Flight Mode (Tilt Cam to Fly Up/Down)", false, function(state)
	handleFlight(state)
end)

-- ADVANCED: Hover / Bobbing Glider (Visual glide - Server Replicated)
local hovering = false
local hoverConnection = nil

local function handleHover(state)
	hovering = state
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not root then return end

	if hovering then
		hum.HipHeight = 3.5 -- Raises the character physically off the ground
		hoverConnection = RunService.RenderStepped:Connect(function()
			if hum and root then
				-- Gentle levitating bounce
				local bob = math.sin(tick() * 4) * 0.3
				hum.CameraOffset = Vector3.new(0, -bob, 0) -- Stops camera from shaking
			end
		end)
	else
		if hoverConnection then
			hoverConnection:Disconnect()
			hoverConnection = nil
		end
		hum.HipHeight = 0 -- Default
		hum.CameraOffset = Vector3.new(0, 0, 0)
	end
end

createToggleButton(movementTab, "Hover Mode (Floating Glide)", false, function(state)
	handleHover(state)
end)

-- ADVANCED: Neon Lightning Trail (Visible to all other players)
local trailEnabled = false

local function handleTrail(state)
	trailEnabled = state
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Clean old trails first
	local oldAtt0 = root:FindFirstChild("TrailAtt0")
	local oldAtt1 = root:FindFirstChild("TrailAtt1")
	local oldTrail = root:FindFirstChild("DevNeonTrail")
	if oldAtt0 then oldAtt0:Destroy() end
	if oldAtt1 then oldAtt1:Destroy() end
	if oldTrail then oldTrail:Destroy() end

	if trailEnabled then
		local att0 = Instance.new("Attachment")
		att0.Name = "TrailAtt0"
		att0.Position = Vector3.new(0, 1, 0)
		att0.Parent = root

		local att1 = Instance.new("Attachment")
		att1.Name = "TrailAtt1"
		att1.Position = Vector3.new(0, -1, 0)
		att1.Parent = root

		local trail = Instance.new("Trail")
		trail.Name = "DevN
