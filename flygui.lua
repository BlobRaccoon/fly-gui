-- MOVEMENT UTILITY PRO (Press Insert to Toggle)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- State Management
local Flags = {}
local SavedPositions = {}
local OriginalGravity = workspace.Gravity

-- Character Helpers
local function GetChar() return LocalPlayer.Character end
local function GetRoot() return GetChar() and GetChar():FindFirstChild("HumanoidRootPart") end
local function GetHum() return GetChar() and GetChar():FindFirstChild("Humanoid") end

-- GUI Construction
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "MovementUtility"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 400)
Main.Position = UDim2.new(0.5, -275, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Top Bar (Minimize/Destroy)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Text = "  MOVEMENT UTILITY SUITE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local function CreateHeaderBtn(txt, xPos, color, cb)
    local b = Instance.new("TextButton", TopBar)
    b.Size = UDim2.new(0, 30, 0, 24)
    b.Position = UDim2.new(1, xPos, 0, 3)
    b.Text = txt
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(cb)
end

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, 0, 1, -30)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.BackgroundTransparency = 1

CreateHeaderBtn("X", -35, Color3.fromRGB(150, 50, 50), function() ScreenGui:Destroy() end)
CreateHeaderBtn("-", -70, Color3.fromRGB(70, 70, 70), function() 
    Content.Visible = not Content.Visible
    Main.Size = Content.Visible and UDim2.new(0, 550, 0, 400) or UDim2.new(0, 550, 0, 30)
end)

local Sidebar = Instance.new("Frame", Content)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local Container = Instance.new("ScrollingFrame", Content)
Container.Size = UDim2.new(1, -130, 1, -10)
Container.Position = UDim2.new(0, 125, 0, 5)
Container.CanvasSize = UDim2.new(0, 0, 12, 0)
Container.ScrollBarThickness = 4
Container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Container.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 4)

-- Logic Implementation
local Logic = {
    ["Fly Mode"] = function(v) if not v and GetRoot() then GetRoot().Anchored = false end end,
    ["Swim in Air"] = function(v) GetHum():ChangeState(v and 4 or 8) end,
    ["Freeze Self"] = function(v) if GetRoot() then GetRoot().Anchored = v end end,
    ["Infinite Jump"] = function(v) end,
    ["Speed Hack"] = function(v) GetHum().WalkSpeed = v and 100 or 16 end,
    ["High Jump"] = function(v) GetHum().JumpPower = v and 200 or 50 end,
    ["Zero G"] = function(v) workspace.Gravity = v and 0 or OriginalGravity end,
    ["Low Gravity"] = function(v) workspace.Gravity = v and 40 or OriginalGravity end,
    ["Massless"] = function(v) for _,p in pairs(GetChar():GetChildren()) do if p:IsA("BasePart") then p.Massless = v end end end,
    ["No Friction"] = function(v) end,
    ["Spin Bot"] = function(v) end,
    ["Field of View+"] = function(v) workspace.CurrentCamera.FieldOfView = v and 120 or 70 end,
    ["Fake Lag"] = function(v) end,
    ["Noclip Fly"] = function(v) end,
    ["Click TP"] = function(v) if v and GetRoot() then GetRoot().CFrame = Mouse.Hit * CFrame.new(0, 3, 0) Flags["Click TP"] = false end end,
    ["Save Pos"] = function(v) if v then SavedPositions[1] = GetRoot().CFrame Flags["Save Pos"] = false end end,
    ["Load Pos"] = function(v) if v and SavedPositions[1] then GetRoot().CFrame = SavedPositions[1] Flags["Load Pos"] = false end end,
    ["Instant Stop"] = function(v) if GetRoot() then GetRoot().Velocity = Vector3.zero end Flags["Instant Stop"] = false end
}

-- Populate Toggles
local Categories = {
    ["Flight"] = {"Fly Mode", "Noclip Fly", "Vertical Fly", "Hover Lock", "Anti-Ground", "Air Walk", "Super Flight", "Momentum Fly", "Glide", "Jetpack"},
    ["Movement"] = {"Infinite Jump", "Speed Hack", "Dash", "Bhop", "Auto-Walk", "Spin Bot", "Wall Climb", "Swim in Air", "High Jump", "Fast Fall"},
    ["Physics"] = {"Freeze Self", "Anti-Fling", "Low Gravity", "No Friction", "Anchor Body", "Massless", "Ragdoll Fly", "Zero G", "Heavy Weight", "Physics Freeze"},
    ["Network"] = {"Fake Lag", "Blink", "Packet Choke", "Desync", "Jitter", "Ping Spike", "Input Delay", "Network Freeze", "Lag Switch", "Ghost Mode"},
    ["Teleport"] = {"Click TP", "Return Pos", "Safe TP", "Tween TP", "Flash TP", "Save Pos", "Load Pos", "Save Pos 2", "Load Pos 2", "Random TP"},
    ["Misc"] = {"Auto-Respawn", "No Reset Delay", "Gravity Shift", "Field of View+", "Instant Stop", "Smooth Move", "Walk Speed 100", "Jump Power 200", "Static Position", "Velocity Reset"}
}

local function CreateToggle(name, cat)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, -10, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.Text = name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Name = cat
    b.Visible = (cat == "Flight")
    
    Flags[name] = false
    b.MouseButton1Click:Connect(function()
        Flags[name] = not Flags[name]
        b.BackgroundColor3 = Flags[name] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
        if Logic[name] then Logic[name](Flags[name]) end
    end)
end

-- Category Navigation
for catName, _ in pairs(Categories) do
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = catName
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.MouseButton1Click:Connect(function()
        for _, item in pairs(Container:GetChildren()) do
            if item:IsA("TextButton") then item.Visible = (item.Name == catName) end
        end
    end)
    for _, item in pairs(Categories[catName]) do CreateToggle(item, catName) end
end

-- Global Runtime Loop
RunService.RenderStepped:Connect(function()
    local root = GetRoot()
    if not root then return end

    if Flags["Fly Mode"] then
        local cam = workspace.CurrentCamera.CFrame
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
        root.Velocity = dir * (Flags["Super Flight"] and 200 or 60)
        root.Anchored = (dir.Magnitude == 0)
    end

    if Flags["Infinite Jump"] and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
    end

    if Flags["Fake Lag"] then
        root.Anchored = true
        task.wait(math.random(100, 500) / 1000)
        root.Anchored = false
    end

    if Flags["Spin Bot"] then
        root.CFrame *= CFrame.Angles(0, math.rad(25), 0)
    end

    if Flags["Noclip Fly"] then
        for _, v in pairs(GetChar():GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Toggle Menu Visibility
UserInputService.InputBegan:Connect(function(io)
    if io.KeyCode == Enum.KeyCode.Insert then Main.Visible = not Main.Visible end
end)
