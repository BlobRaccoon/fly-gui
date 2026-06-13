local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local enabled = false
local swimConnection

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function enableAirSwim()
	local character = getCharacter()
	local humanoid = character:WaitForChild("Humanoid")
	local root = character:WaitForChild("HumanoidRootPart")

	humanoid:ChangeState(Enum.HumanoidStateType.Swimming)

	swimConnection = RunService.RenderStepped:Connect(function()
		if not enabled then return end

		root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end)
end

local function disableAirSwim()
	if swimConnection then
		swimConnection:Disconnect()
		swimConnection = nil
	end

	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
	end
end

local function toggleAirSwim()
	enabled = not enabled

	if enabled then
		enableAirSwim()
	else
		disableAirSwim()
	end
end

toggleAirSwim()
