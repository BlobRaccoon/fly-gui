local Players = game:GetService("Players")

local player = Players.LocalPlayer

local function ResetAtSamePosition()
	local character = player.Character
	if not character then
		return
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not root or not humanoid then
		return
	end

	local savedCFrame = root.CFrame

	humanoid.Health = 0

	local newCharacter = player.CharacterAdded:Wait()
	local newRoot = newCharacter:WaitForChild("HumanoidRootPart")

	repeat
		task.wait()
	until newCharacter.Parent

	newRoot.CFrame = savedCFrame
end

ResetAtSamePosition()
