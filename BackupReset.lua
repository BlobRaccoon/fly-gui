
-- swim menu (FAST VERSION)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "swim_gui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0.5, -90, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "swim"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 40)
toggle.BackgroundColor3 = Color3.fromRGB(120,0,0)
toggle.Text = "OFF"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 16
toggle.Parent = frame

-- SWIM SETTINGS
local SWIM_SPEED = 55

local swimming = false
local swimConn

local function startSwim()
    humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    swimConn = RunService.RenderStepped:Connect(function()
        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        root.Velocity = humanoid.MoveDirection * SWIM_SPEED
    end)
end

local function stopSwim()
    if swimConn then
        swimConn:Disconnect()
        swimConn = nil
    end
    root.Velocity = Vector3.zero
    humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
end

toggle.MouseButton1Click:Connect(function()
    swimming = not swimming
    if swimming then
        toggle.Text = "ON"
        toggle.BackgroundColor3 = Color3.fromRGB(0,120,0)
        startSwim()
    else
        toggle.Text = "OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(120,0,0)
        stopSwim()
    end
end)

-- INSERT TO OPEN / CLOSE
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)

-- RESPAWN FIX
player.CharacterAdded:Connect(function(c)
    char = c
    humanoid = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
    if swimming then
        startSwim()
    end
end)
