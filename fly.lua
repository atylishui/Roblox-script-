-- // SAM'S ULTIMATE HUB V2.0 - PROFESSIONAL FRAMEWORK // --
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- // GUI CONSTRUCTION // --
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "SamsUltimateHub"

local MainFrame = Instance.new("Frame", Screen)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- // HEADER & MINIMIZE/CLOSE // --
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Text = "SAM'S HUB 2026"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.MouseButton1Click:Connect(function() Screen:Destroy() end)

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Size = minimized and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 400)
end)

-- // FEATURE CONTAINER // --
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1

local function CreateToggle(Name, Callback)
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(1, 0, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Btn.Text = Name .. " : OFF"
    Btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = state and Name .. " : ON" or Name .. " : OFF"
        Btn.BackgroundColor3 = state and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(40, 40, 50)
        Callback(state)
    end)
    return Btn
end

-- // FEATURES IMPLEMENTATION // --
local fly = false
local bv = Instance.new("BodyVelocity", Character:WaitForChild("HumanoidRootPart"))
bv.MaxForce = Vector3.new(0,0,0)

CreateToggle("FLY", function(s) fly = s; bv.MaxForce = s and Vector3.new(math.huge, math.huge, math.huge) or Vector3.new(0,0,0) end)

CreateToggle("SPEED", function(s) Character.Humanoid.WalkSpeed = s and 100 or 16 end)

CreateToggle("JUMP", function(s) 
    if s then 
        _G.InfJump = UserInputService.JumpRequest:Connect(function() Character.Humanoid:ChangeState("Jumping") end)
    else 
        if _G.InfJump then _G.InfJump:Disconnect() end 
    end 
end)

-- // ENGINE LOOP // --
RunService.RenderStepped:Connect(function()
    if fly and Character:FindFirstChild("Humanoid") then
        bv.Velocity = (Character.Humanoid.MoveDirection * 70) + Vector3.new(0, 1.5, 0)
    end
end)

