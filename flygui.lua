local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MovementGui"
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(220, 320)
frame.Position = UDim2.new(0, 20, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui

local layout = Instance.new("UIListLayout")
layout.Parent = frame

local function makeButton(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,30)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	b.Parent = frame
	return b
end

-- Character refs
local char, hum, root

local function refreshChar()
	char = plr.Character or plr.CharacterAdded:Wait()
	hum = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
end

refreshChar()
plr.CharacterAdded:Connect(refreshChar)

-- STATES
local airSwim = false
local bunnyHop = false
local spin = false
local jetpack = false
local superJump = false
local hover = false
local moonGravity = false

-- BUTTONS
local airBtn = makeButton("Air Swim: OFF")
local hopBtn = makeButton("Bunny Hop: OFF")
local spinBtn = makeButton("Spin: OFF")
local jetBtn = makeButton("Jetpack: OFF")
local sjBtn = makeButton("Super Jump: OFF")
local hoverBtn = makeButton("Hover: OFF")
local moonBtn = makeButton("Moon Gravity: OFF")

-- TOGGLES
airBtn.MouseButton1Click:Connect(function()
	airSwim = not airSwim
	airBtn.Text = "Air Swim: "..(airSwim and "ON" or "OFF")
end)

hopBtn.MouseButton1Click:Connect(function()
	bunnyHop = not bunnyHop
	hopBtn.Text = "Bunny Hop: "..(bunnyHop and "ON" or "OFF")
end)

spinBtn.MouseButton1Click:Connect(function()
	spin = not spin
	spinBtn.Text = "Spin: "..(spin and "ON" or "OFF")
end)

jetBtn.MouseButton1Click:Connect(function()
	jetpack = not jetpack
	jetBtn.Text = "Jetpack: "..(jetpack and "ON" or "OFF")
end)

sjBtn.MouseButton1Click:Connect(function()
	superJump = not superJump
	hum.JumpPower = superJump and 110 or 50
	sjBtn.Text = "Super Jump: "..(superJump and "ON" or "OFF")
end)

hoverBtn.MouseButton1Click:Connect(function()
	hover = not hover
	hoverBtn.Text = "Hover: "..(hover and "ON" or "OFF")
end)

moonBtn.MouseButton1Click:Connect(function()
	moonGravity = not moonGravity
	moonBtn.Text = "Moon Gravity: "..(moonGravity and "ON" or "OFF")
end)

-- DASH (visible to others)
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Q then
		if root then
			root.AssemblyLinearVelocity += root.CFrame.LookVector * 90
		end
	end
end)

-- MAIN LOOP
RunService.Heartbeat:Connect(function()
	if not char or not hum or not root then return end

	-- AIR SWIM
	if airSwim and UIS:IsKeyDown(Enum.KeyCode.Space) then
		root.AssemblyLinearVelocity += Vector3.new(0, 3.5, 0)
	end

	-- BUNNY HOP
	if bunnyHop and hum.FloorMaterial ~= Enum.Material.Air then
		hum.Jump = true
	end

	-- SPIN (replicates to others)
	if spin then
		root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(6), 0)
	end

	-- JETPACK
	if jetpack and UIS:IsKeyDown(Enum.KeyCode.Space) then
		root.AssemblyLinearVelocity += Vector3.new(0, 6, 0)
	end

	-- HOVER (kill fall momentum)
	if hover and hum.FloorMaterial == Enum.Material.Air then
		local v = root.AssemblyLinearVelocity
		root.AssemblyLinearVelocity = Vector3.new(v.X, math.max(v.Y, 0), v.Z)
	end

	-- MOON GRAVITY (light simulation)
	if moonGravity then
		root.AssemblyLinearVelocity += Vector3.new(0, 0.15, 0)
	end
end)
