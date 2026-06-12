local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local Footer = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MinBtn = Instance.new("TextButton")
local RestoreBtn = Instance.new("TextButton")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
-- Build gui
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "TheChosenOne_GUI"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 230, 0, 330)
MainFrame.Active = true
MainFrame.Draggable = true

UIStroke.Parent = MainFrame
UIStroke.Thickness = 4
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSans
Title.Text = "The Chosen One GUI"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.TextSize = 20

CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

MinBtn.Parent = MainFrame
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
MinBtn.Position = UDim2.new(1, -50, 0, 5)
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(0, 0, 0)

RestoreBtn.Parent = MainFrame
RestoreBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
RestoreBtn.Position = UDim2.new(1, -50, 0, 5)
RestoreBtn.Size = UDim2.new(0, 20, 0, 20)
RestoreBtn.Text = "□"
RestoreBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
RestoreBtn.Visible = false

Footer.Parent = MainFrame
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Font = Enum.Font.SourceSans
Footer.Text = "Made by Blob_raccoon"
Footer.TextColor3 = Color3.fromRGB(0, 0, 0)
Footer.TextSize = 14

ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 10, 0, 45)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -75)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1.5, 0)
ScrollingFrame.ScrollBarThickness = 2

UIListLayout.Parent = ScrollingFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 5)
-- Gui toggle functions
local minimized = false
local fullSize = MainFrame.Size

local function setMinimized(state)
	minimized = state
	if state then
		ScrollingFrame.Visible = false
		Footer.Visible = false
		MainFrame.Size = UDim2.new(fullSize.X.Scale, fullSize.X.Offset, 0, 40)
		MinBtn.Visible = false
		CloseBtn.Visible = true
		RestoreBtn.Visible = true
	else
		ScrollingFrame.Visible = true
		Footer.Visible = true
		MainFrame.Size = fullSize
		MinBtn.Visible = true
		CloseBtn.Visible = true
		RestoreBtn.Visible = false
	end
end
-- Gui toggle callers
MinBtn.MouseButton1Click:Connect(function()
	setMinimized(true)
end)

RestoreBtn.MouseButton1Click:Connect(function()
	setMinimized(false)
end)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)
-- Create Button function
local function CreateButton(name, code)
	local btn = Instance.new("TextButton")
	btn.Parent = ScrollingFrame
	btn.Size = UDim2.new(1, -5, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSans
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.TextSize = 15

	local s = Instance.new("UIStroke")
	s.Parent = btn
	s.Thickness = 2
	s.Color = Color3.fromRGB(0, 0, 0)

	btn.MouseButton1Click:Connect(function()
		pcall(function()
			code()
		end)
	end)
end
-- Buttons
CreateButton("Emote Script", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
end)

CreateButton("Drop Kick", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/universal/DropKick.lua"))()
end)

CreateButton("Animation Fly", function()
    local UIS = game:GetService("UserInputService")
    if UIS.TouchEnabled and not UIS.KeyboardEnabled then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/MobileFly.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/FlyR15.lua"))()
    end
end)
CreateButton("Agar ware", function()
    loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\97\103\97\114\118\115\111\99\111\111\111\108\115\109\105\116\104\47\83\99\114\105\112\116\115\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\65\71\65\82\87\65\82\69\46\108\117\97"))()
end)
