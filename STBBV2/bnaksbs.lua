-- =========================
-- DYHUB Upgraded Script
-- Version: 3.5.0
-- Optimized for stability, performance, and reduced lag
-- =========================

local version = "3.5.0"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local GetReadyRemote = ReplicatedStorage:WaitForChild("GetReadyRemote", 5)
local SkipHelicopterRemote = ReplicatedStorage:WaitForChild("SkipHelicopter", 5)
local LMBRemote = ReplicatedStorage:WaitForChild("LMB", 5)
local VoteRemote = ReplicatedStorage:WaitForChild("Vote", 5)
local RedeemCodeRemote = ReplicatedStorage:WaitForChild("RedeemCode", 5)
local BuyItemRemote = ReplicatedStorage:WaitForChild("BuyItemFromShopHourly", 5)
local GachaCharacterRemote = ReplicatedStorage:WaitForChild("GachaCharacter", 5)
local GachaSkinsRemote = ReplicatedStorage:WaitForChild("GachaSkins", 5)

-- Global Variables
local autoVoteValue = "Normal"
local autoVoteEnabled = false
local setPositionMode = "Under"
getgenv().DistanceValue = 1
local autoFarmActive = false
local autoReadyActive = false
local MasteryAutoFarmActive = false
local MasteryAutoFarmActiveTest = false
local autoSkipHelicopterActive = false
local flushAuraActive = false
local espActiveEnemies = false
local espActivePlayers = false
local espShowName = true
local espShowHealth = true
local espShowDistance = false
local espMode = "Highlight"
getgenv().HitboxEnabled = false
getgenv().HitboxSize = 20
getgenv().HitboxShow = false
local movementMode = "CFrame"
local CharacterMode = "Used"
local ActionMode = "Default"
local autoSkillEnabled = false
local autoSkillValues = {}
local skillDelay = 0.25
local loopDelay = 0.5
local visitedNPCs = {}
local pressCount = {}
local espObjects = {}
local supportPart = nil
local partConnection = nil
local spinAngle = 0
local autoCollectEnabled = false
local itemNotifyEnabled = false
local autobuyEnabled = false
local autobuyCharEnabled = false
local autobuySkinEnabled = false
getgenv().speedEnabled = false
getgenv().speedValue = 20
getgenv().jumpEnabled = false
getgenv().jumpValue = 50

-- Utility Functions
local function safePcall(func)
    local success, result = pcall(func)
    if not success then
        warn("[DYHUB] Error: " .. tostring(result))
    end
    return success, result
end

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}
end

local function createBillboard(model, humanoid)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DYHUB_ESP_Billboard"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = Workspace

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true
    textLabel.Parent = billboard

    local function updateText()
        local parts = {}
        if espShowName then table.insert(parts, model.Name or "NPC") end
        if humanoid and humanoid.Health and humanoid.MaxHealth and espShowHealth then
            table.insert(parts, math.floor(humanoid.Health) .. " / " .. math.floor(humanoid.MaxHealth))
        end
        if espShowDistance and LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart then
            local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            table.insert(parts, "Dist: " .. math.floor(dist))
        end
        textLabel.Text = table.concat(parts, "\n")
    end

    updateText()
    local conn = RunService.RenderStepped:Connect(function()
        if not humanoid or humanoid.Health <= 0 or not hrp.Parent then
            billboard:Destroy()
            conn:Disconnect()
        else
            updateText()
        end
    end)
    table.insert(espObjects, billboard)
end

local function applyESPToModel(model)
    if espMode == "Highlight" then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = model
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = Workspace
        table.insert(espObjects, highlight)
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then createBillboard(model, humanoid) end
    elseif espMode == "BoxHandle" then
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = Vector3.new(4, 6, 2)
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Transparency = 0.5
        box.Parent = Workspace.Terrain
        table.insert(espObjects, box)
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then createBillboard(model, humanoid) end
    end
end

local function updateESP()
    clearESP()
    if not (espActiveEnemies or espActivePlayers) then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if espActivePlayers then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    applyESPToModel(player.Character)
                end
            end
        end
        if espActiveEnemies and Workspace:FindFirstChild("Living") then
            for _, npc in pairs(Workspace.Living:GetChildren()) do
                if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) then
                    local humanoid = npc:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        applyESPToModel(npc)
                    end
                end
            end
        end
    end
end

local function isVisited(npc)
    return table.find(visitedNPCs, npc) ~= nil
end

local function addVisited(npc)
    if not isVisited(npc) then table.insert(visitedNPCs, npc) end
end

local function removeVisited(npc)
    for i, v in ipairs(visitedNPCs) do
        if v == npc then
            table.remove(visitedNPCs, i)
            pressCount[npc] = nil
            break
        end
    end
end

local function smoothTeleportTo(targetPos, duration)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local tweenInfo = TweenInfo.new(duration or 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    tween:Play()
    tween.Completed:Wait()
end

local function instantTeleportTo(targetPos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    end
end

local function teleportToTarget(targetPos, duration)
    if movementMode == "CFrame" then
        smoothTeleportTo(targetPos, duration)
    else
        instantTeleportTo(targetPos)
    end
end

local function createSupportPart(character)
    if supportPart then supportPart:Destroy() end
    if partConnection then partConnection:Disconnect() end
    supportPart = Instance.new("Part")
    supportPart.Size = Vector3.new(5, 1, 5)
    supportPart.Anchored = true
    supportPart.CanCollide = true
    supportPart.Transparency = 0.9
    supportPart.Name = "AutoFarmSupport"
    supportPart.Parent = Workspace
    partConnection = RunService.Heartbeat:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            supportPart.Position = hrp.Position - Vector3.new(0, (hrp.Size.Y / 2 + supportPart.Size.Y / 2), 0)
        end
    end)
end

local function removeSupportPart()
    if partConnection then partConnection:Disconnect() partConnection = nil end
    if supportPart then supportPart:Destroy() supportPart = nil end
end

local function calculatePosition(npc)
    if not npc or not npc:FindFirstChild("HumanoidRootPart") then
        return Vector3.new(), CFrame.new(), false
    end
    local hrp = npc.HumanoidRootPart
    local pos = hrp.Position
    local dist = getgenv().DistanceValue or 2
    local targetPos, lookCFrame, anchored
    if setPositionMode == "Above" then
        targetPos = pos + Vector3.new(0, dist, 0)
        lookCFrame = CFrame.new(targetPos) * CFrame.Angles(-math.pi / 2, 0, 0)
        anchored = true
    elseif setPositionMode == "Under" then
        targetPos = pos - Vector3.new(0, dist, 0)
        lookCFrame = CFrame.new(targetPos) * CFrame.Angles(math.pi / 2, 0, 0)
        anchored = true
    elseif setPositionMode == "Front" then
        targetPos = pos + (hrp.CFrame.LookVector * dist)
        lookCFrame = CFrame.new(targetPos, pos)
    elseif setPositionMode == "Back" then
        targetPos = pos - (hrp.CFrame.LookVector * dist)
        lookCFrame = CFrame.new(targetPos, pos)
    elseif setPositionMode == "Spin" then
        spinAngle = (spinAngle + math.rad(5)) % (2 * math.pi)
        targetPos = pos + Vector3.new(math.cos(spinAngle) * dist, 0, math.sin(spinAngle) * dist)
        lookCFrame = CFrame.new(targetPos, pos)
    else
        targetPos = pos + (hrp.CFrame.LookVector * dist)
        lookCFrame = CFrame.new(targetPos, pos)
    end
    return targetPos, lookCFrame, anchored
end

local function findNextNPCWithFlushProximity(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC, closestPrompt = nil, nil
    for _, npc in pairs(Workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
            for _, prompt in pairs(npc:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Flush" and (pressCount[npc] or 0) < 3 then
                    local dist = (prompt.Parent.Position - referencePart.Position).Magnitude
                    if dist < lastDist then
                        closestNPC, closestPrompt = npc, prompt
                        lastDist = dist
                    end
                end
            end
        end
    end
    return closestNPC, closestPrompt
end

local function findNextNPCWithHumanoid(maxDistance, referencePart, noProximity)
    local lastDist = maxDistance
    local closestNPC = nil
    if Workspace:FindFirstChild("Living") then
        for _, npc in pairs(Workspace.Living:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local hasProximity = false
                    if noProximity then
                        for _, child in pairs(npc:GetDescendants()) do
                            if child:IsA("ProximityPrompt") then
                                hasProximity = true
                                break
                            end
                        end
                    end
                    if noProximity == hasProximity then
                        local dist = (npc.HumanoidRootPart.Position - referencePart.Position).Magnitude
                        if dist < lastDist then
                            closestNPC = npc
                            lastDist = dist
                        end
                    end
                end
            end
        end
    end
    return closestNPC
end

local function attackHumanoid(npc, isMastery)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    createSupportPart(character)
    local active = isMastery and MasteryAutoFarmActive or autoFarmActive
    while humanoid.Health > 0 and active do
        local targetPos = calculatePosition(npc)
        teleportToTarget(targetPos)
        LMBRemote:FireServer()
        task.wait(0.1)
    end
    removeSupportPart()
    removeVisited(npc)
end

local function startAutoFarm()
    task.spawn(function()
        while autoFarmActive do
            safePcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc, prompt = findNextNPCWithFlushProximity(1000, hrp)
                    if npc and prompt and prompt.Parent then
                        local humanoid = npc:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            local targetPos = calculatePosition(npc)
                            teleportToTarget(targetPos)
                            while (pressCount[npc] or 0) < 3 and prompt.Parent do
                                prompt:InputHoldBegin()
                                task.wait(0.05)
                                prompt:InputHoldEnd()
                                pressCount[npc] = (pressCount[npc] or 0) + 1
                                task.wait(0.15)
                            end
                            addVisited(npc)
                        else
                            removeVisited(npc)
                        end
                    else
                        local npc2 = findNextNPCWithHumanoid(1000, hrp, true)
                        if npc2 then
                            addVisited(npc2)
                            attackHumanoid(npc2, false)
                        else
                            visitedNPCs = {}
                            pressCount = {}
                            task.wait(1)
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
        removeSupportPart()
    end)
end

local function MasteryAutoFarm(isTest)
    task.spawn(function()
        local active = isTest and MasteryAutoFarmActiveTest or MasteryAutoFarmActive
        while active do
            safePcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if isTest then
                        local nearbyParts = Workspace:GetPartBoundsInRadius(hrp.Position, 100)
                        for _, part in pairs(nearbyParts) do
                            local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                            if prompt and prompt.ActionText == "Flush" then
                                prompt:InputHoldBegin()
                                task.wait(0.05)
                                prompt:InputHoldEnd()
                                task.wait(0.2)
                            end
                        end
                    end
                    local npc = findNextNPCWithHumanoid(1000, hrp, false)
                    if npc then
                        addVisited(npc)
                        attackHumanoid(npc, true)
                    else
                        visitedNPCs = {}
                        task.wait(0.5)
                    end
                end
            end)
            task.wait(0.1)
        end
        removeSupportPart()
    end)
end

local function flushAura()
    task.spawn(function()
        while flushAuraActive do
            safePcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") and obj.ActionText == "Flush" then
                            obj.HoldDuration = 0
                            fireproximityprompt(obj)
                        end
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end

local function modifyProximityPrompts()
    task.spawn(function()
        while true do
            safePcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.HoldDuration ~= 0 then
                        obj.HoldDuration = 0
                    end
                end
            end)
            task.wait(1)
        end
    end)
end

local function startAutoReady()
    task.spawn(function()
        sendReady(true)
        while autoReadyActive do
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                sendReady(true)
            end
            task.wait(1)
        end
        sendReady(false)
    end)
end

local function sendReady(value)
    GetReadyRemote:FireServer("1", value)
end

local function startAutoSkipHelicopter()
    task.spawn(function()
        while autoSkipHelicopterActive do
            safePcall(function()
                SkipHelicopterRemote:FireServer()
            end)
            task.wait(1)
        end
    end)
end

local function applyHitboxToNPC(npc)
    if not npc:IsA("Model") then return end
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    if humanoid and hrp then
        local existing = hrp:FindFirstChild("DYHUB_Hitbox")
        if getgenv().HitboxEnabled then
            if not existing then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "DYHUB_Hitbox"
                box.Adornee = hrp
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                box.Transparency = getgenv().HitboxShow and 0.5 or 1
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.Parent = hrp
            else
                existing.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                existing.Transparency = getgenv().HitboxShow and 0.5 or 1
            end
        else
            if existing then existing:Destroy() end
        end
    end
end

local function scanNPCs()
    print("[DYHUB] Scanning NPCs...")
    if Workspace:FindFirstChild("Living") then
        for _, npc in pairs(Workspace.Living:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) then
                applyHitboxToNPC(npc)
            end
        end
    end
    print("[DYHUB] Scan Complete")
end

-- Initialize UI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "ST: Blockade Battlefront | " .. (checkVersion(LocalPlayer.Name) or "Free Version"),
    Folder = "DYHUB_Stbb_config",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {Enabled = true, Anonymous = false},
})

Window:Tag({Title = version, Color = Color3.fromHex("#30ff6a")})
Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- Tabs
local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local SkillTab = Window:Tab({ Title = "Skill", Icon = "flame" })
local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })
local CollectTab = Window:Tab({ Title = "Collect", Icon = "hand" })
local HitboxTab = Window:Tab({ Title = "Hitbox", Icon = "package" })
local QuestTab = Window:Tab({ Title = "Quest", Icon = "sword" })
local MasteryTab = Window:Tab({ Title = "Mastery", Icon = "award" })
local CodesTab = Window:Tab({ Title = "Codes", Icon = "bird" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local GameTab = Window:Tab({ Title = "Gamepass", Icon = "cookie" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "file-cog" })

Window:SelectTab(1)

-- Main Features
MainTab:Section({ Title = "Feature Play", Icon = "gamepad-2" })
MainTab:Toggle({
    Title = "Auto Ready",
    Default = false,
    Callback = function(value)
        autoReadyActive = value
        if autoReadyActive then startAutoReady() end
    end,
})
MainTab:Toggle({
    Title = "Auto Skip Helicopter",
    Default = false,
    Callback = function(value)
        autoSkipHelicopterActive = value
        if autoSkipHelicopterActive then startAutoSkipHelicopter() end
    end,
})

MainTab:Section({ Title = "Feature Farm", Icon = "tractor" })
MainTab:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value) movementMode = value end,
})
MainTab:Dropdown({
    Title = "Set Position",
    Values = {"Spin", "Above", "Back", "Under", "Front"},
    Default = setPositionMode,
    Multi = false,
    Callback = function(value) setPositionMode = value end,
})
MainTab:Slider({
    Title = "Set Distance to NPC",
    Value = {Min = 0, Max = 50, Default = getgenv().DistanceValue},
    Step = 1,
    Callback = function(val) getgenv().DistanceValue = val end,
})
MainTab:Toggle({
    Title = "Auto Farm (Upgrade)",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if autoFarmActive then startAutoFarm() end
    end,
})
MainTab:Toggle({
    Title = "Flush Aura (Upgrade)",
    Default = false,
    Callback = function(value)
        flushAuraActive = value
        if flushAuraActive then flushAura() end
    end,
})

MainTab:Section({ Title = "Feature Vote", Icon = "vote" })
MainTab:Dropdown({
    Title = "Set Vote",
    Values = {"Normal", "Hard", "VeryHard", "Insane", "Nightmare", "BossRush", "ThunderStorm", "Zombie", "Christmas", "Hell", "DarkDimension", "Astro"},
    Default = autoVoteValue,
    Multi = false,
    Callback = function(value)
        autoVoteValue = value
        VoteRemote:FireServer(value)
    end,
})
MainTab:Toggle({
    Title = "Auto Vote",
    Default = false,
    Callback = function(enabled)
        autoVoteEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoVoteEnabled do
                    VoteRemote:FireServer(autoVoteValue)
                    task.wait(1)
                end
            end)
        end
    end,
})

-- Skill Features
SkillTab:Section({ Title = "Feature Skill", Icon = "sparkles" })
local skillList = {"Q", "E", "R", "T", "Y", "F", "G", "H", "Z", "X", "C", "V", "B"}
local dropdownValues = {"All"}
for _, v in ipairs(skillList) do table.insert(dropdownValues, v) end
SkillTab:Dropdown({
    Title = "Set Auto Skill",
    Values = dropdownValues,
    Multi = true,
    Callback = function(values)
        autoSkillValues = table.find(values, "All") and skillList or values
    end,
})
SkillTab:Toggle({
    Title = "Auto Skill",
    Default = false,
    Callback = function(enabled)
        autoSkillEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoSkillEnabled do
                    for _, key in ipairs(autoSkillValues) do
                        VirtualInputManager:SendKeyEvent(true, key, false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, key, false, game)
                        task.wait(skillDelay)
                    end
                    task.wait(loopDelay)
                end
            end)
        end
    end,
})

-- ESP Features
EspTab:Section({ Title = "Feature Esp", Icon = "radar" })
EspTab:Dropdown({
    Title = "ESP Mode",
    Values = {"Highlight", "BoxHandle"},
    Default = espMode,
    Multi = false,
    Callback = function(value)
        espMode = value
        updateESP()
    end,
})
EspTab:Toggle({
    Title = "ESP (Enemies)",
    Default = false,
    Callback = function(value)
        espActiveEnemies = value
        updateESP()
    end,
})
EspTab:Toggle({
    Title = "ESP (Players)",
    Default = false,
    Callback = function(value)
        espActivePlayers = value
        updateESP()
    end,
})
EspTab:Section({ Title = "Esp Setting", Icon = "settings-2" })
EspTab:Toggle({
    Title = "ESP Name",
    Default = true,
    Callback = function(value)
        espShowName = value
        updateESP()
    end,
})
EspTab:Toggle({
    Title = "ESP Health",
    Default = true,
    Callback = function(value)
        espShowHealth = value
        updateESP()
    end,
})
EspTab:Toggle({
    Title = "ESP Distance",
    Default = false,
    Callback = function(value)
        espShowDistance = value
        updateESP()
    end,
})

-- Hitbox Features
HitboxTab:Section({ Title = "Feature Hitbox", Icon = "crosshair" })
HitboxTab:Button({
    Title = "Scan Humanoid",
    Callback = scanNPCs,
})
HitboxTab:Slider({
    Title = "Set Size Hitbox",
    Value = {Min = 16, Max = 100, Default = 20},
    Step = 1,
    Callback = function(val) getgenv().HitboxSize = val end,
})
HitboxTab:Toggle({
    Title = "Enable Hitbox",
    Default = false,
    Callback = function(value) getgenv().HitboxEnabled = value end,
})
HitboxTab:Toggle({
    Title = "Show Hitbox (Transparency)",
    Default = false,
    Callback = function(value) getgenv().HitboxShow = value end,
})

-- Quest Features
QuestTab:Section({ Title = "Feature Quest", Icon = "album" })
QuestTab:Button({
    Title = "Open Menu (Quest Clock-Man)",
    Callback = function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("QuestClockManUI")
        if gui then gui.Enabled = not gui.Enabled end
    end,
})
QuestTab:Button({
    Title = "Open Menu (Quest)",
    Callback = function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("QuestUI")
        if gui then gui.Enabled = not gui.Enabled end
    end,
})
QuestTab:Section({ Title = "Setting Auto Quest", Icon = "star-half" })
QuestTab:Dropdown({
    Title = "Set Position",
    Values = {"Spin", "Above", "Back", "Under", "Front"},
    Default = setPositionMode,
    Multi = false,
    Callback = function(value) setPositionMode = value end,
})
QuestTab:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value) movementMode = value end,
})
QuestTab:Toggle({
    Title = "Auto Farm (Upgrade)",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if autoFarmActive then startAutoFarm() end
    end,
})

-- Mastery Features
MasteryTab:Section({ Title = "Feature Mastery", Icon = "book-open" })
MasteryTab:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value) movementMode = value end,
})
MasteryTab:Dropdown({
    Title = "Action Speed",
    Values = {"Default", "Slow", "Faster", "Flash (Lag)"},
    Default = ActionMode,
    Multi = false,
    Callback = function(value) ActionMode = value end,
})
MasteryTab:Dropdown({
    Title = "Character List",
    Values = {"Small", "Large", "Support (Not Good)", "Titan"},
    Default = CharacterMode,
    Multi = false,
    Callback = function(value) CharacterMode = value end,
})
MasteryTab:Dropdown({
    Title = "Set Position",
    Values = {"Spin", "Above", "Back", "Under", "Front"},
    Default = setPositionMode,
    Multi = false,
    Callback = function(value) setPositionMode = value end,
})
MasteryTab:Slider({
    Title = "Set Distance to NPC",
    Value = {Min = 0, Max = 50, Default = getgenv().DistanceValue},
    Step = 1,
    Callback = function(val) getgenv().DistanceValue = val end,
})
MasteryTab:Toggle({
    Title = "Auto Mastery (No Flush)",
    Default = false,
    Callback = function(value)
        MasteryAutoFarmActive = value
        if value then MasteryAutoFarm(false) end
    end,
})
MasteryTab:Toggle({
    Title = "Auto Mastery (Flush)",
    Default = false,
    Callback = function(value)
        MasteryAutoFarmActiveTest = value
        if value then MasteryAutoFarm(true) end
    end,
})

-- Codes Features
CodesTab:Section({ Title = "Feature Code", Icon = "terminal" })
local redeemCodes = {
    "Verified", "BackOnBusiness", "UTSM", "18k loss", "50KGroup", "WaveStuckIssue",
    "flying toilet", "AstroInvasionBegin", "DarkDriveIssue", "Digi",
}
local selectedCodes = {}
CodesTab:Dropdown({
    Title = "Select Redeem Codes",
    Multi = true,
    Values = redeemCodes,
    Callback = function(value) selectedCodes = value or {} end,
})
CodesTab:Button({
    Title = "Redeem Selected Codes",
    Callback = function()
        for _, code in ipairs(selectedCodes) do
            safePcall(function()
                RedeemCodeRemote:FireServer(code)
                task.wait(0.2)
            end)
        end
    end,
})
CodesTab:Button({
    Title = "Redeem Code All",
    Callback = function()
        for _, code in ipairs(redeemCodes) do
            safePcall(function()
                RedeemCodeRemote:FireServer(code)
                task.wait(0.2)
            end)
        end
    end,
})

-- Shop Features
ShopTab:Section({ Title = "Hourly Shop (Beta)", Icon = "shopping-cart" })
local shop = {}
for _, gear in pairs(game:GetService("ReplicatedFirst"):WaitForChild("Gears", 5):GetChildren()) do
    table.insert(shop, gear.Name)
end
local shopValue = {}
local shop1 = {"1", "2", "3", "4", "5"}
local shopValue1 = {}
ShopTab:Dropdown({
    Title = "Set Auto Buy Items",
    Values = shop,
    Default = {},
    Multi = true,
    Callback = function(value) shopValue = value end,
})
ShopTab:Dropdown({
    Title = "Set Amount Buy Items",
    Values = shop1,
    Default = {},
    Multi = true,
    Callback = function(value) shopValue1 = value end,
})
ShopTab:Toggle({
    Title = "Auto Buy",
    Default = false,
    Callback = function(enabled)
        autobuyEnabled = enabled
        if enabled then
            task.spawn(function()
                while autobuyEnabled do
                    for _, item in ipairs(shopValue) do
                        for _, amount in ipairs(shopValue1) do
                            safePcall(function()
                                BuyItemRemote:FireServer(item, amount)
                                task.wait(1)
                            end)
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end,
})

ShopTab:Section({ Title = "Feature Gacha", Icon = "gem" })
local gachaCharOptions = {"1SpinLucky", "10Spins", "1Spin"}
local gachaSkinOptions = {"1SpinLucky", "1Spin", "10Spins"}
local selectedChar = {}
local selectedSkin = {}
ShopTab:Dropdown({
    Title = "Select Gacha Character Spins",
    Values = gachaCharOptions,
    Default = {},
    Multi = true,
    Callback = function(value) selectedChar = value end,
})
ShopTab:Toggle({
    Title = "Auto Gacha Character",
    Default = false,
    Callback = function(enabled)
        autobuyCharEnabled = enabled
        if enabled then
            task.spawn(function()
                while autobuyCharEnabled do
                    for _, spin in ipairs(selectedChar) do
                        safePcall(function()
                            GachaCharacterRemote:FireServer(spin)
                            task.wait(1)
                        end)
                    end
                end
            end)
        end
    end,
})
ShopTab:Dropdown({
    Title = "Select Gacha Skin Spins",
    Values = gachaSkinOptions,
    Default = {},
    Multi = true,
    Callback = function(value) selectedSkin = value end,
})
ShopTab:Toggle({
    Title = "Auto Gacha Skin",
    Default = false,
    Callback = function(enabled)
        autobuySkinEnabled = enabled
        if enabled then
            task.spawn(function()
                while autobuySkinEnabled do
                    for _, spin in ipairs(selectedSkin) do
                        safePcall(function()
                            GachaSkinsRemote:FireServer(spin)
                            task.wait(1)
                        end)
                    end
                end
            end)
        end
    end,
})

-- Gamepass Features
GameTab:Section({ Title = "Feature Gamepass", Icon = "key-round" })
local Gamepasst = {"LuckyBoost", "RareLuckyBoost", "LegendaryLuckyBoost", "All"}
local Gamepassts = {}
GameTab:Dropdown({
    Title = "Select Gamepass",
    Multi = true,
    Values = Gamepasst,
    Callback = function(value) Gamepassts = value or {} end,
})
GameTab:Button({
    Title = "Unlock Selected Gamepass",
    Callback = function()
        local gachaData = LocalPlayer:FindFirstChild("GachaData") or Instance.new("Folder")
        gachaData.Name = "GachaData"
        gachaData.Parent = LocalPlayer
        local toUnlock = table.find(Gamepassts, "All") and {"LuckyBoost", "RareLuckyBoost", "LegendaryLuckyBoost"} or Gamepassts
        for _, gamepassName in ipairs(toUnlock) do
            safePcall(function()
                local boolValue = gachaData:FindFirstChild(gamepassName) or Instance.new("BoolValue")
                boolValue.Name = gamepassName
                boolValue.Parent = gachaData
                boolValue.Value = true
                task.wait(0.2)
            end)
        end
    end,
})

-- Player Features
PlayerTab:Section({ Title = "Feature Player", Icon = "user" })
PlayerTab:Button({
    Title = "Open Menu (Helicopter)",
    Callback = function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("003-A")
        if gui then gui.Enabled = not gui.Enabled end
    end,
})
PlayerTab:Slider({
    Title = "Set Speed Value",
    Value = {Min = 16, Max = 600, Default = 20},
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end,
})
PlayerTab:Toggle({
    Title = "Enable Speed",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end,
})
PlayerTab:Slider({
    Title = "Set Jump Value",
    Value = {Min = 10, Max = 600, Default = 50},
    Step = 1,
    Callback = function(val)
        getgenv().jumpValue = val
        if getgenv().jumpEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end,
})
PlayerTab:Toggle({
    Title = "Enable JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().jumpEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v and getgenv().jumpValue or 50 end
    end,
})
PlayerTab:Section({ Title = "Player Misc", Icon = "sliders-horizontal" })
local noclipConnection
PlayerTab:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local Character = LocalPlayer.Character
                if Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local Character = LocalPlayer.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})
PlayerTab:Toggle({
    Title = "Infinity Jump",
    Default = false,
    Callback = function(state)
        if state then
            getgenv().infJumpConnection = UserInputService.JumpRequest:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if getgenv().infJumpConnection then
                getgenv().infJumpConnection:Disconnect()
                getgenv().infJumpConnection = nil
            end
        end
    end,
})
PlayerTab:Button({
    Title = "Fly (Beta)",
    Callback = function()
        safePcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))()
        end)
    end,
})

-- Misc Features
MiscTab:Section({ Title = "Feature Visual", Icon = "eye" })
local oldAmbient, oldBrightness, oldClockTime, oldFogStart, oldFogEnd, oldFogColor = Lighting.Ambient, Lighting.Brightness, Lighting.ClockTime, Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor
local fullBrightConnection, noFogConnection
MiscTab:Toggle({
    Title = "Full Bright",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 5
            Lighting.ClockTime = 14
            fullBrightConnection = RunService.RenderStepped:Connect(function()
                if Lighting.ClockTime ~= 14 then Lighting.ClockTime = 14 end
                if Lighting.Brightness ~= 10 then Lighting.Brightness = 10 end
                if Lighting.Ambient ~= Color3.new(1, 1, 1) then Lighting.Ambient = Color3.new(1, 1, 1) end
            end)
        else
            if fullBrightConnection then fullBrightConnection:Disconnect() fullBrightConnection = nil end
            Lighting.Ambient, Lighting.Brightness, Lighting.ClockTime = oldAmbient, oldBrightness, oldClockTime
        end
    end,
})
MiscTab:Toggle({
    Title = "No Fog",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = 0, 1e10, Color3.fromRGB(255, 255, 255)
            noFogConnection = RunService.RenderStepped:Connect(function()
                if Lighting.FogStart ~= 0 then Lighting.FogStart = 0 end
                if Lighting.FogEnd ~= 1e10 then Lighting.FogEnd = 1e10 end
                if Lighting.FogColor ~= Color3.fromRGB(255, 255, 255) then Lighting.FogColor = Color3.fromRGB(255, 255, 255) end
            end)
        else
            if noFogConnection then noFogConnection:Disconnect() noFogConnection = nil end
            Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = oldFogStart, oldFogEnd, oldFogColor
        end
    end,
})
local vibrantEffect = Lighting:FindFirstChild("VibrantEffect") or Instance.new("ColorCorrectionEffect")
vibrantEffect.Name, vibrantEffect.Saturation, vibrantEffect.Contrast, vibrantEffect.Brightness, vibrantEffect.Enabled, vibrantEffect.Parent =
    "VibrantEffect", 1, 0.4, 0.05, false, Lighting
MiscTab:Toggle({
    Title = "Vibrant Colors",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.ColorShift_Top, Lighting.ColorShift_Bottom, vibrantEffect.Enabled =
                Color3.fromRGB(180, 180, 180), Color3.fromRGB(170, 170, 170), Color3.fromRGB(255, 230, 200), Color3.fromRGB(200, 240, 255), true
        else
            Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.ColorShift_Top, Lighting.ColorShift_Bottom, vibrantEffect.Enabled =
                Color3.new(0, 0, 0), Color3.new(0, 0, 0), Color3.new(0, 0, 0), Color3.new(0, 0, 0), false
        end
    end,
})

MiscTab:Section({ Title = "FPS Boost Settings", Icon = "zap" })
local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    16, Vector2.new(Camera.ViewportSize.X - 100, 10), Color3.fromRGB(0, 255, 0), false, true, showFPS
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible =
    16, Vector2.new(Camera.ViewportSize.X - 100, 30), Color3.fromRGB(0, 255, 0), false, true, showPing
local fpsCounter, fpsLastUpdate = 0, tick()
RunService.RenderStepped:Connect(function()
    fpsCounter = fpsCounter + 1
    if tick() - fpsLastUpdate >= 1 then
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end
        if showPing then
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local pingValue = ping and math.floor(ping:GetValue()) or 0
            msText.Text = "Ping: " .. pingValue .. " ms"
            msText.Color = pingValue <= 60 and Color3.fromRGB(0, 255, 0) or pingValue <= 120 and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 0, 0)
            msText.Visible = true
        else
            msText.Visible = false
        end
        fpsCounter = 0
        fpsLastUpdate = tick()
    end
end)
MiscTab:Toggle({
    Title = "Show FPS",
    Default = true,
    Callback = function(val) showFPS = val fpsText.Visible = val end,
})
MiscTab:Toggle({
    Title = "Show Ping (ms)",
    Default = true,
    Callback = function(val) showPing = val msText.Visible = val end,
})
MiscTab:Button({
    Title = "FPS Boost (Fixed)",
    Callback = function()
        safePcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.Brightness, Lighting.FogEnd, Lighting.GlobalShadows, Lighting.EnvironmentDiffuseScale, Lighting.EnvironmentSpecularScale, Lighting.ClockTime, Lighting.OutdoorAmbient =
                2, 100, false, 0, 0, 14, Color3.new(0, 0, 0)
            local terrain = Workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize, terrain.WaterWaveSpeed, terrain.WaterReflectance, terrain.WaterTransparency = 0, 0, 0, 1
            end
            for _, obj in ipairs(Lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        print("[Boost] FPS Boost Applied")
    end,
})

-- Collect Features
CollectTab:Section({ Title = "Feature Collect", Icon = "package" })
local Items = {"Clock Spider", "Transmitter", "FlashDrive", "Astro Samples"}
local ItemsValue = {"Clock Spider"}
CollectTab:Dropdown({
    Title = "Set Collect Items",
    Values = Items,
    Default = "Clock Spider",
    Multi = true,
    Callback = function(value) ItemsValue = value end,
})
CollectTab:Toggle({
    Title = "Auto Collect",
    Default = false,
    Callback = function(enabled)
        autoCollectEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoCollectEnabled do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if (obj:IsA("Model") or obj:IsA("Part")) and table.find(ItemsValue, obj.Name) then
                            task.spawn(function()
                                safePcall(function()
                                    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
                                    if prompt then
                                        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                                        local hrp = char:FindFirstChild("HumanoidRootPart")
                                        local originalPos = hrp.Position
                                        while prompt.Parent and autoCollectEnabled do
                                            local targetPos = obj.PrimaryPart and obj.PrimaryPart.Position + Vector3.new(0, 3, 0) or obj.Position + Vector3.new(0, 3, 0)
                                            teleportToTarget(targetPos)
                                            prompt:InputHoldBegin()
                                            task.wait(0.05)
                                            prompt:InputHoldEnd()
                                            task.wait(0.2)
                                        end
                                        teleportToTarget(originalPos)
                                    end
                                end)
                            end)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end,
})
CollectTab:Toggle({
    Title = "Item Notify",
    Default = false,
    Callback = function(enabled)
        itemNotifyEnabled = enabled
        if enabled then
            task.spawn(function()
                while itemNotifyEnabled do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if (obj:IsA("Model") or obj:IsA("Part")) and table.find(ItemsValue, obj.Name) then
                            safePcall(function()
                                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                if hrp and obj.PrimaryPart then
                                    local distance = (hrp.Position - obj.PrimaryPart.Position).Magnitude * 1000
                                    game:GetService("StarterGui"):SetCore("SendNotification", {
                                        Title = "Item Notify",
                                        Text = string.format("Name: %s\nDistance: %04d mm", obj.Name, math.floor(distance)),
                                        Duration = 3,
                                    })
                                end
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end,
})

-- Info Tab
InfoTab:Section({ Title = "DYHUB Information", TextXAlignment = "Center", TextSize = 17 })
local InviteCode = "jWNDPNMmyB"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"
ui = ui or {}
ui.Creator = ui.Creator or {}
ui.Creator.Request = function(requestData)
    local success, result = pcall(function()
        if HttpService.RequestAsync then
            local response = HttpService:RequestAsync({
                Url = requestData.Url,
                Method = requestData.Method or "GET",
                Headers = requestData.Headers or {}
            })
            return {Body = response.Body, StatusCode = response.StatusCode, Success = response.Success}
        else
            return {Body = HttpService:GetAsync(requestData.Url), StatusCode = 200, Success = true}
        end
    end)
    if success then return result end
    error("HTTP Request failed: " .. tostring(result))
end
local function LoadDiscordInfo()
    local success, result = safePcall(function()
        return HttpService:JSONDecode(ui.Creator.Request({
            Url = DiscordAPI,
            Method = "GET",
            Headers = {["User-Agent"] = "RobloxBot/1.0", ["Accept"] = "application/json"}
        }).Body)
    end)
    if success and result and result.guild then
        local DiscordInfo = InfoTab:Paragraph({
            Title = result.guild.name,
            Desc = ' <font color="#52525b">●</font> Member Count : ' .. tostring(result.approximate_member_count) ..
                   '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(result.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=1024",
            ImageSize = 42,
        })
        InfoTab:Button({
            Title = "Update Info",
            Callback = function()
                local updated, updatedResult = safePcall(function()
                    return HttpService:JSONDecode(ui.Creator.Request({Url = DiscordAPI, Method = "GET"}).Body)
                end)
                if updated and updatedResult and updatedResult.guild then
                    DiscordInfo:SetDesc(
                        ' <font color="#52525b">●</font> Member Count : ' .. tostring(updatedResult.approximate_member_count) ..
                        '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(updatedResult.approximate_presence_count)
                    )
                    WindUI:Notify({Title = "Discord Info Updated", Content = "Successfully refreshed Discord statistics", Duration = 2, Icon = "refresh-cw"})
                else
                    WindUI:Notify({Title = "Update Failed", Content = "Could not refresh Discord info", Duration = 3, Icon = "alert-triangle"})
                end
            end,
        })
        InfoTab:Button({
            Title = "Copy Discord Invite",
            Callback = function()
                setclipboard("https://discord.gg/" .. InviteCode)
                WindUI:Notify({Title = "Copied!", Content = "Discord invite copied to clipboard", Duration = 2, Icon = "clipboard-check"})
            end,
        })
    else
        InfoTab:Paragraph({Title = "Error fetching Discord Info", Desc = "Unable to load Discord information.", Image = "triangle-alert", ImageSize = 26, Color = "Red"})
    end
end
LoadDiscordInfo()
InfoTab:Paragraph({Title = "Main Owner", Desc = "@dyumraisgoodguy#8888", Image = "rbxassetid://119789418015420", ImageSize = 30})
InfoTab:Paragraph({
    Title = "Social",
    Desc = "Copy link social media for follow!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Buttons = {{Icon = "copy", Title = "Copy Link", Callback = function() setclipboard("https://guns.lol/DYHUB") end}},
})
InfoTab:Paragraph({
    Title = "Discord",
    Desc = "Join our discord for more scripts!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Buttons = {{Icon = "copy", Title = "Copy Link", Callback = function() setclipboard("https://discord.gg/jWNDPNMmyB") end}},
})

-- Character Added Handler
LocalPlayer.CharacterAdded:Connect(function()
    if autoFarmActive then startAutoFarm() end
    if MasteryAutoFarmActive then MasteryAutoFarm(false) end
    if MasteryAutoFarmActiveTest then MasteryAutoFarm(true) end
    if flushAuraActive then flushAura() end
    if autoReadyActive then startAutoReady() end
    if autoSkipHelicopterActive then startAutoSkipHelicopter() end
end)

-- Initial Setup
modifyProximityPrompts()
task.spawn(function()
    while task.wait(1) do
        if getgenv().HitboxEnabled then scanNPCs() end
        if espActiveEnemies or espActivePlayers then updateESP() end
    end
end)
if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "dsc.gg/dyhub", Text = "FPS Unlocked!", Duration = 2, Button1 = "Okay"})
else
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "dsc.gg/dyhub", Text = "Your exploit does not support setfpscap.", Duration = 2, Button1 = "Okay"})
end
print("[DYHUB] Upgraded Script Loaded! Version: " .. version)