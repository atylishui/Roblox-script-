-- // SAM'S ULTIMATE HUB V1.0 // --
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- // UI SETUP // --
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "SamsUltimateHub"

local MainFrame = Instance.new("Frame", Screen)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Text = "SAM'S ULTIMATE HUB | 2026"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

-- // FEATURE LIST // --
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2

-- // LOGIC ENGINE // --
local function CreateCategory(Name)
    local Label = Instance.new("TextLabel", Container)
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.Text = "--- " .. Name .. " ---"
    Label.TextColor3 = Color3.fromRGB(150, 150, 150)
    Label.BackgroundTransparency = 1
    return Label
end

local function CreateButton(Name, Callback)
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Btn.Text = Name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
    Btn.MouseButton1Click:Connect(Callback)
    return Btn
end

-- // FEATURES // --
CreateCategory("MOVEMENT")

local flyState = false
local bv = Instance.new("BodyVelocity", Character:FindFirstChild("HumanoidRootPart"))
bv.MaxForce = Vector3.new(0,0,0)

CreateButton("Toggle Fly", function()
    flyState = not flyState
    bv.MaxForce = flyState and Vector3.new(math.huge, math.huge, math.huge) or Vector3.new(0,0,0)
end)

CreateButton("Speed Boost", function()
    Character.Humanoid.WalkSpeed = 100
end)

CreateCategory("PLAYER")

CreateButton("Infinite Jump", function()
    UserInputService.JumpRequest:Connect(function()
        Character.Humanoid:ChangeState("Jumping")
    end)
end)

-- // GLOBAL LOOP // --
RunService.RenderStepped:Connect(function()
    if flyState and Character:FindFirstChild("Humanoid") then
        bv.Velocity = (Character.Humanoid.MoveDirection * 70) + Vector3.new(0, 1.5, 0)
    end
end)
