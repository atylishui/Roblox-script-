local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Fly Logic
local flying = false
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bv.Velocity = Vector3.new(0, 0, 0)

-- UI Setup (Modern Look)
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 160, 0, 80)
frame.Position = UDim2.new(0.5, -80, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true -- Mobile par drag kar sakega

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 15)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0, 140, 0, 60)
button.Position = UDim2.new(0.5, -70, 0.5, -30)
button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
button.Text = "FLY : OFF"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 20

local btnCorner = Instance.new("UICorner", button)
btnCorner.CornerRadius = UDim.new(0, 10)

-- Click Logic
button.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        bv.Parent = root
        button.Text = "FLY : ON"
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        bv.Parent = nil
        button.Text = "FLY : OFF"
        button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- Movement
game:GetService("RunService").RenderStepped:Connect(function()
    if flying then
        -- Joystick movement + smooth control
        bv.Velocity = (humanoid.MoveDirection * 60) + Vector3.new(0, 0, 0)
    end
end)

