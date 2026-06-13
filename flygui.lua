local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Footer = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MinBtn = Instance.new("TextButton")
local RestoreBtn = Instance.new("TextButton")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- build gui
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "TheChosenOne_GUI"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -140)
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 8)

UIStroke.Parent = MainFrame
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(80, 80, 100)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Title.Size = UDim2.new(1, 0, 0, 28)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "The Chosen One GUI"
Title.TextColor3 = Color3.fromRGB(235, 235, 235)
Title.TextSize = 16

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = Title

CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
CloseBtn.Position = UDim2.new(1, -24, 0, 5)
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 12

MinBtn.Parent = MainFrame
MinBtn.BackgroundColor3 = Color3.fromRGB(240, 180, 60)
MinBtn.Position = UDim2.new(1, -48, 0, 5)
MinBtn.Size = UDim2.new(0, 18, 0, 18)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 14

RestoreBtn.Parent = MainFrame
RestoreBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
RestoreBtn.Position = UDim2.new(1, -48, 0, 5)
RestoreBtn.Size = UDim2.new(0, 18, 0, 18)
RestoreBtn.Text = "□"
RestoreBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
RestoreBtn.Font = Enum.Font.SourceSansBold
RestoreBtn.TextSize = 12
RestoreBtn.Visible = false

Footer.Parent = MainFrame
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 0, 1, -18)
Footer.Size = UDim2.new(1, 0, 0, 16)
Footer.Font = Enum.Font.SourceSans
Footer.Text = "Made by Blob_raccoon"
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
Footer.TextSize = 12

ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 8, 0, 32)
ScrollingFrame.Size = UDim2.new(1, -16, 1, -52)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 3

UIListLayout.Parent = ScrollingFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 3)

-- gui toggle functions
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

-- gui toggle callers
MinBtn.MouseButton1Click:Connect(function()
	setMinimized(true)
end)

RestoreBtn.MouseButton1Click:Connect(function()
	setMinimized(false)
end)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- create button function
local function CreateButton(name, code)
	local btn = Instance.new("TextButton")
	btn.Parent = ScrollingFrame
	btn.Size = UDim2.new(1, -6, 0, 28)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	btn.Font = Enum.Font.SourceSans
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(235, 235, 235)
	btn.TextSize = 14

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Parent = btn
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(90, 90, 120)

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
CreateButton("Reset", function()
		    loadstring(game:HttpGet("https://raw.githubusercontent.com/BlobRaccoon/fly-gui/refs/heads/main/reset.lua"))()
end)

CreateButton("Orbit universal", function()
		setclipboard("w5x6y7z8-a9b0-c1d2-e3f4")
loadstring(game:HttpGet("https://raw.githubusercontent.com/im-a-script-kiddie/orbit-hub/refs/heads/main/im_a_script_kiddie"))()
end)
