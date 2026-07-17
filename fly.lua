-- Modern Fly Script (Professional Version)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- Cleanup purana UI
if CoreGui:FindFirstChild("ProFlyUI") then CoreGui:FindFirstChild("ProFlyUI"):Destroy() end

-- GUI Construction
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "ProFlyUI"
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame", Screen)
Frame.Size = UDim2.new(0, 140, 0, 50)
Frame.Position = UDim2.new(0.5, -70, 0.5, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true -- Mobile drag support

local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0, 12)

local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(1, 0, 1, 0)
Toggle.Text = "FLY : OFF"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 18
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 12)

-- Physics
local bv = Instance.new("BodyVelocity", root)
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Velocity = Vector3.new(0, 0, 0)

local flying = false

Toggle.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        Toggle.Text = "FLY : ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    else
        bv.MaxForce = Vector3.new(0, 0, 0)
        Toggle.Text = "FLY : OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

-- Smoother Movement
RunService.RenderStepped:Connect(function()
    if flying and char:FindFirstChild("HumanoidRootPart") then
        local move = hum.MoveDirection
        -- Speed yahan control kar (abhi 60 hai)
        bv.Velocity = (move * 60) + Vector3.new(0, 1.5, 0)
    end
end)
