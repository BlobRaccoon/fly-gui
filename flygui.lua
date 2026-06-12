local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Configuration & State
local Flags = {}
local SavedPositions = {}
local OriginalGravity = workspace.Gravity
local FlySpeed = 50

-- UI Construction
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "MovementPro"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 400)
Main.Position = UDim2.new(0.5, -275, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true

local SideBar = Instance.new("Frame", Main)
SideBar.Size = UDim2.new(0, 120, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -130, 1, -10)
Container.Position = UDim2.new(0, 125, 0, 5)
Container.CanvasSize = UDim2.new(0, 0, 10, 0)
Container.ScrollBarThickness = 4
Container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Container.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 5)

-- Logic Functions
local function GetChar() return LocalPlayer.Character end
local function GetRoot() return GetChar() and GetChar():FindFirstChild("HumanoidRootPart") end
local function GetHum() return GetChar() and GetChar():FindFirstChild("Humanoid") end

-- Toggle Helper
local function AddToggle(name, category, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = Container
    btn.Visible = false
    btn.Name = category
    
    Flags[name] = false
    btn.MouseButton1Click:Connect(function()
        Flags[name] = not Flags[name]
        btn.BackgroundColor3 = Flags[name] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(45, 45, 45)
        callback(Flags[name])
    end)
end

-- 1. FLIGHT LOGIC
AddToggle("Fly Mode", "Flight", function(v) end)
AddToggle("Noclip Fly", "Flight", function(v) end)
AddToggle("Vertical Fly", "Flight", function(v) end)
AddToggle("Hover Lock", "Flight", function(v) if GetRoot() then GetRoot().Anchored = v end end)
AddToggle("Anti-Ground", "Flight", function(v) end)
AddToggle("Air Walk", "Flight", function(v) 
    local plat = GetChar():FindFirstChild("AirPart") or Instance.new("Part", GetChar())
    plat.Name = "AirPart" plat.Size = Vector3.new(5,1,5) plat.Transparency = 1
    RunService.RenderStepped:Connect(function()
        if Flags["Air Walk"] and GetRoot() then 
            plat.CFrame = GetRoot().CFrame * CFrame.new(0,-3.5,0)
            plat.Anchored = true
        else plat.Anchored = false end
    end)
end)
AddToggle("Super Flight", "Flight", function(v) FlySpeed = v and 200 or 50 end)
AddToggle("Momentum Fly", "Flight", function(v) end)
AddToggle("Glide", "Flight", function(v) end)
AddToggle("Jetpack", "Flight", function(v) end)

-- 2. MOVEMENT LOGIC
AddToggle("Infinite Jump", "Movement", function(v) end)
AddToggle("Speed Hack", "Movement", function(v) GetHum().WalkSpeed = v and 100 or 16 end)
AddToggle("Dash", "Movement", function(v) if v and GetRoot() then GetRoot().CFrame *= CFrame.new(0,0,-20) Flags["Dash"] = false end end)
AddToggle("Bhop", "Movement", function(v) end)
AddToggle("Auto-Walk", "Movement", function(v) if v then GetHum():MoveTo(Mouse.Hit.p) end end)
AddToggle("Spin Bot", "Movement", function(v) end)
AddToggle("Wall Climb", "Movement", function(v) end)
AddToggle("Swim in Air", "Movement", function(v) GetHum():ChangeState(v and Enum.HumanoidStateType.Swimming or Enum.HumanoidStateType.Running) end)
AddToggle("High Jump", "Movement", function(v) GetHum().JumpPower = v and 200 or 50 end)
AddToggle("Fast Fall", "Movement", function(v) end)

-- 3. PHYSICS LOGIC
AddToggle("Freeze Self", "Physics", function(v) if GetRoot() then GetRoot().Anchored = v end end)
AddToggle("Anti-Fling", "Physics", function(v) end)
AddToggle("Low Gravity", "Physics", function(v) workspace.Gravity = v and 30 or OriginalGravity end)
AddToggle("No Friction", "Physics", function(v) end)
AddToggle("Anchor Body", "Physics", function(v) for _,p in pairs(GetChar():GetChildren()) do if p:IsA("BasePart") then p.Anchored = v end end end)
AddToggle("Massless", "Physics", function(v) for _,p in pairs(GetChar():GetChildren()) do if p:IsA("BasePart") then p.Massless = v end end end)
AddToggle("Ragdoll Fly", "Physics", function(v) GetHum():ChangeState(v and Enum.HumanoidStateType.Ragdoll or Enum.HumanoidStateType.GettingUp) end)
AddToggle("Zero G", "Physics", function(v) workspace.Gravity = v and 0 or OriginalGravity end)
AddToggle("Heavy Weight", "Physics", function(v) end)
AddToggle("Physics Freeze", "Physics", function(v) sethiddenproperty(LocalPlayer, "SimulationRadius", v and 0 or 1000) end)

-- 4. NETWORK LOGIC
AddToggle("Fake Lag", "Network", function(v) settings().Network.IncomingReplicationLag = v and 1000 or 0 end)
AddToggle("Blink", "Network", function(v) end)
AddToggle("Packet Choke", "Network", function(v) end)
AddToggle("Desync", "Network", function(v) end)
AddToggle("Jitter", "Network", function(v) end)
AddToggle("Ping Spike", "Network", function(v) end)
AddToggle("Input Delay", "Network", function(v) end)
AddToggle("Network Freeze", "Network", function(v) end)
AddToggle("Lag Switch", "Network", function(v) end)
AddToggle("Ghost Mode", "Network", function(v) end)

-- 5. TELEPORT LOGIC
AddToggle("Click TP", "Teleport", function(v) if v then GetRoot().CFrame = Mouse.Hit * CFrame.new(0,3,0) Flags["Click TP"] = false end end)
AddToggle("Return Pos", "Teleport", function(v) if SavedPositions[1] then GetRoot().CFrame = SavedPositions[1] end Flags["Return Pos"] = false end)
AddToggle("Safe TP", "Teleport", function(v) end)
AddToggle("Tween TP", "Teleport", function(v) if v then TweenService:Create(GetRoot(), TweenInfo.new(2), {CFrame = Mouse.Hit}):Play() end end)
AddToggle("Flash TP", "Teleport", function(v) end)
AddToggle("Save Pos 1", "Teleport", function(v) SavedPositions[1] = GetRoot().CFrame Flags["Save Pos 1"] = false end)
AddToggle("Save Pos 2", "Teleport", function(v) SavedPositions[2] = GetRoot().CFrame Flags["Save Pos 2"] = false end)
AddToggle("Load Pos 1", "Teleport", function(v) GetRoot().CFrame = SavedPositions[1] Flags["Load Pos 1"] = false end)
AddToggle("Load Pos 2", "Teleport", function(v) GetRoot().CFrame = SavedPositions[2] Flags["Load Pos 2"] = false end)
AddToggle("Random TP", "Teleport", function(v) GetRoot().CFrame = CFrame.new(math.random(-100,100), 50, math.random(-100,100)) end)

-- 6. MISC LOGIC
AddToggle("Auto-Respawn", "Misc", function(v) end)
AddToggle("No Reset Delay", "Misc", function(v) end)
AddToggle("Gravity Shift", "Misc", function(v) end)
AddToggle("Field of View+", "Misc", function(v) workspace.CurrentCamera.FieldOfView = v and 120 or 70 end)
AddToggle("Instant Stop", "Misc", function(v) if GetRoot() then GetRoot().Velocity = Vector3.new() end end)
AddToggle("Smooth Move", "Misc", function(v) end)
AddToggle("Walk Speed 100", "Misc", function(v) GetHum().WalkSpeed = v and 100 or 16 end)
AddToggle("Jump Power 200", "Misc", function(v) GetHum().JumpPower = v and 200 or 50 end)
AddToggle("Static Position", "Misc", function(v) end)
AddToggle("Velocity Reset", "Misc", function(v) if GetRoot() then GetRoot().Velocity = Vector3.new() end end)

-- Global Loop for Active Flags
RunService.RenderStepped:Connect(function()
    local root = GetRoot()
    if not root then return end
    
    if Flags["Fly Mode"] then
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
        root.Velocity = dir * FlySpeed
        root.Anchored = (dir.Magnitude == 0)
    end
    
    if Flags["Noclip Fly"] then
        for _, v in pairs(GetChar():GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    if Flags["Infinite Jump"] and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
    end

    if Flags["Spin Bot"] then root.CFrame *= CFrame.Angles(0, math.rad(20), 0) end
    
    if Flags["Static Position"] then root.Velocity = Vector3.zero root.RotVelocity = Vector3.zero end
end)

-- Category Selection
local cats = {"Flight", "Movement", "Physics", "Network", "Teleport", "Misc"}
for i, name in pairs(cats) do
    local b = Instance.new("TextButton", SideBar)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Position = UDim2.new(0, 0, 0, (i-1)*40)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do
            if v:IsA("TextButton") then v.Visible = (v.Name == name) end
        end
    end)
end

-- GUI Toggle
UserInputService.InputBegan:Connect(function(io)
    if io.KeyCode == Enum.KeyCode.Insert then Main.Visible = not Main.Visible end
end)
