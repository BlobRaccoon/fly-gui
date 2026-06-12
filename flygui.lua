# Roblox LocalScript for Head Joint Rotation

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local head = character:WaitForChild("Head")
local neck = head:FindFirstChild("Neck")

local spinning = false
local speed = 1

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0, 0)
toggleButton.Text = "Toggle Spin"

local speedSlider = Instance.new("TextBox", screenGui)
speedSlider.Size = UDim2.new(0, 200, 0, 50)
speedSlider.Position = UDim2.new(0.5, -100, 0, 60)
speedSlider.Text = "Speed (1-10)"
speedSlider.TextScaled = true

toggleButton.MouseButton1Click:Connect(function()
    spinning = not spinning
    toggleButton.Text = spinning and "Stop Spin" or "Start Spin"
end)

speedSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(speedSlider.Text)
        if newSpeed and newSpeed > 0 and newSpeed <= 10 then
            speed = newSpeed
        end
    end
end)

while true do
    if spinning then
        local rotation = CFrame.Angles(0, math.rad(speed * 10), 0)
        neck.C0 = neck.C0 * rotation
        neck.C1 = neck.C1 * rotation
        game.ReplicatedStorage:WaitForChild("Neck").Changed:Fire()
    end
    wait(0.1)
end

