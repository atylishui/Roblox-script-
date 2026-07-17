local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0.5, -50, 0.1, 0)
button.Text = "Fly: OFF"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

-- Fly Variables
local flying = false
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bv.Velocity = Vector3.new(0, 0, 0)

-- Logic
button.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        bv.Parent = root
        button.Text = "Fly: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        bv.Parent = nil
        button.Text = "Fly: OFF"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Movement (Camera direction mein fly karne ke liye)
game:GetService("RunService").RenderStepped:Connect(function()
    if flying then
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0,0,0)
        
        -- Keyboard input (W,A,S,D)
        local userInput = game:GetService("UserInputService")
        if userInput:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
        if userInput:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
        
        bv.Velocity = moveDirection * 50 -- 50 speed hai
    end
end)
