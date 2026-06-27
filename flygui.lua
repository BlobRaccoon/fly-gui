-- Delta Executor - Speed 70 + Walk Fling + ESP + TP to Player + Fullbright

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer

-- === AUTO FULLBRIGHT ===
Lighting.Ambient = Color3.new(1, 1, 1)
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.FogEnd = 100000
Lighting.GlobalShadows = false
Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
Lighting.ShadowSoftness = 0

spawn(function()
    while task.wait(1) do
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.FogEnd = 100000
    end
end)

-- === WALK FLING ===
local walkflingActive = false

local function startWalkFling(char)
    local root = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    hum.BreakJointsOnDeath = false
    RunService.Stepped:Connect(function()
        if hum and hum.Parent then
            hum.Health = math.huge
            hum.MaxHealth = math.huge
        end
    end)
    walkflingActive = true
    root.CanCollide = false
    spawn(function()
        local movel = 0.1
        while walkflingActive and root and root.Parent do
            RunService.Heartbeat:Wait()
            local vel = root.Velocity
            root.Velocity = vel * 99999999 + Vector3.new(0, 99999999, 0)
            RunService.RenderStepped:Wait()
            root.Velocity = vel
            RunService.Stepped:Wait()
            root.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end)
end

-- Manual jump override
spawn(function()
    while task.wait() do
        if walkflingActive and LP.Character then
            local hum = LP.Character:FindFirstChildWhichIsA("Humanoid")
            local root = LP.Character:FindFirstChild("HumanoidRootPart")
            if hum and root then
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    if root.Velocity.Y > -1 and root.Velocity.Y < 1 then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end
        task.wait(0.05)
    end
end)

if LP.Character then startWalkFling(LP.Character) end
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    startWalkFling(char)
end)

-- === SPEED 70 ===
spawn(function()
    while task.wait(0.2) do
        local char = LP.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = 70 end
        end
    end
end)

-- === ESP ===
local holder = CoreGui:FindFirstChild("ESP") or Instance.new("Folder", CoreGui)
holder.Name = "ESP"

local function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

local function setupPlayer(player)
    local function addESP(char)
        task.wait(0.3)
        if not char then return end
        local hl = char:FindFirstChild("_HL")
        if hl then hl:Destroy() end
        hl = Instance.new("Highlight", char)
        hl.Name = "_HL"
        hl.Adornee = char
        hl.FillColor = Color3.new(1, 0.2, 0.2)
        hl.OutlineColor = Color3.new(1, 0.2, 0.2)
        hl.FillTransparency = 0.85
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        local head = char:FindFirstChild("Head")
        if not head then return end
        local bg = Instance.new("BillboardGui", char)
        bg.Name = "_BD"
        bg.Adornee = head
        bg.Size = UDim2.new(0, 200, 0, 60)
        bg.StudsOffset = Vector3.new(0, 3.2, 0)
        bg.AlwaysOnTop = true

        local nameLbl = Instance.new("TextLabel", bg)
        nameLbl.Size = UDim2.new(1, 0, 0.5, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.TextColor3 = Color3.new(1, 1, 1)
        nameLbl.TextStrokeTransparency = 0.3
        nameLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLbl.TextScaled = true
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.Text = player.Name

        local distLbl = Instance.new("TextLabel", bg)
        distLbl.Size = UDim2.new(1, 0, 0.5, 0)
        distLbl.Position = UDim2.new(0, 0, 0.5, 0)
        distLbl.BackgroundTransparency = 1
        distLbl.TextColor3 = Color3.new(0.8, 0.8, 1)
        distLbl.TextStrokeTransparency = 0.3
        distLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        distLbl.TextScaled = true
        distLbl.Font = Enum.Font.Gotham
        distLbl.Name = "_Dist"

        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not char or not char.Parent then conn:Disconnect() return end
            local hrp = getRoot(char)
            local myChar = LP.Character
            local myHrp = myChar and getRoot(myChar)
            if hrp and myHrp and distLbl and distLbl.Parent then
                distLbl.Text = math.floor((myHrp.Position - hrp.Position).Magnitude + 0.5) .. " studs"
            end
        end)
    end

    if player.Character then addESP(player.Character) end
    player.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        addESP(char)
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LP then setupPlayer(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LP then setupPlayer(p) end
end)

-- === TP TO PLAYER GUI ===
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "TPGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 160)
frame.Position = UDim2.new(0, 20, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BorderSizePixel = 0
title.Text = "TP TO PLAYER"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- Player list
local playerList = Instance.new("ScrollingFrame", frame)
playerList.Size = UDim2.new(1, -10, 0, 75)
playerList.Position = UDim2.new(0, 5, 0, 28)
playerList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
playerList.BorderSizePixel = 0
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 4

local selectedPlayer = nil

local function refreshPlayerList()
    playerList:ClearAllChildren()
    local y = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local btn = Instance.new("TextButton", playerList)
            btn.Size = UDim2.new(1, -5, 0, 22)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.BorderSizePixel = 0
            btn.Text = p.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.Name = p.Name

            if selectedPlayer and selectedPlayer.Name == p.Name then
                btn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
            end

            btn.MouseButton1Click:Connect(function()
                selectedPlayer = p
                for _, b in ipairs(playerList:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    end
                end
                btn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
            end)

            y = y + 24
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, y)
end

refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- TP Button
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(1, -10, 0, 35)
tpBtn.Position = UDim2.new(0, 5, 0, 115)
tpBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 180)
tpBtn.BorderSizePixel = 0
tpBtn.Text = "TP"
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.TextScaled = true
tpBtn.Font = Enum.Font.GothamBold

tpBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character then
        local targetRoot = getRoot(selectedPlayer.Character)
        local myChar = LP.Character
        if targetRoot and myChar then
            local myRoot = getRoot(myChar)
            if myRoot then
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
            end
        end
    else
        tpBtn.Text = "NO TARGET"
        tpBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        task.wait(1)
        tpBtn.Text = "TP"
        tpBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 180)
    end
end)

print("=== Delta Executor Loaded ===")
print("Speed 70 | Walk Fling | ESP | Fullbright | TP to Player GUI")