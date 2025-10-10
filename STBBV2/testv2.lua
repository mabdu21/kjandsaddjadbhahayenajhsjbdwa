-- DYHUB Optimized Script for Roblox
-- Version: 3.5.0
-- Optimized for stability, performance, and reduced lag
-- Author: DYHUB Team
-- Size: ~65KB

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Local Player
local LocalPlayer = Players.LocalPlayer
local GetReadyRemote = ReplicatedStorage:WaitForChild("GetReadyRemote", 5)
local SkipHelicopterRemote = ReplicatedStorage:WaitForChild("SkipHelicopter", 5)
local LMBRemote = ReplicatedStorage:WaitForChild("LMB", 5)
local VoteRemote = ReplicatedStorage:WaitForChild("Vote", 5)
local RedeemCodeRemote = ReplicatedStorage:WaitForChild("RedeemCode", 5)
local BuyItemRemote = ReplicatedStorage:WaitForChild("BuyItemFromShopHourly", 5)
local GachaCharacterRemote = ReplicatedStorage:WaitForChild("GachaCharacter", 5)
local GachaSkinsRemote = ReplicatedStorage:WaitForChild("GachaSkins", 5)

-- Variables
local version = "3.5.0"
local autoVoteEnabled, autoFarmActive, autoReadyActive = false, false, false
local MasteryAutoFarmActive, MasteryAutoFarmActiveTest, autoSkipHelicopterActive = false, false, false
local flushAuraActive, espActiveEnemies, espActivePlayers = false, false, false
local espShowName, espShowHealth, espShowDistance = true, true, false
local espMode, movementMode, setPositionMode = "Highlight", "CFrame", "Under"
local ActionMode, CharacterMode = "Default", "Used"
local espObjects, visitedNPCs, pressCount = {}, {}, {}
local getgenv = getgenv or function() return _G end
getgenv().HitboxEnabled, getgenv().HitboxSize, getgenv().HitboxShow = false, 20, false
getgenv().DistanceValue, getgenv().speedEnabled, getgenv().speedValue = 1, false, 20
getgenv().jumpEnabled, getgenv().jumpValue = false, 50
local spinAngle = 0
local supportPart, partConnection, noclipConnection, fullBrightConnection, noFogConnection

-- FPS Unlock
if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DYHUB", Text = "FPS Unlocked!", Duration = 2, Button1 = "Okay"
    })
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DYHUB", Text = "Your exploit does not support setfpscap.", Duration = 2, Button1 = "Okay"
    })
end

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Utility Functions
local function safePcall(func)
    local success, result = pcall(func)
    if not success then warn("[DYHUB] Error: " .. tostring(result)) end
    return success, result
end

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then obj:Destroy() end
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
        if humanoid and espShowHealth then
            table.insert(parts, math.floor(humanoid.Health) .. " / " .. math.floor(humanoid.MaxHealth))
        end
        if espShowDistance then
            local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            table.insert(parts, "Dist: " .. math.floor(dist))
        end
        textLabel.Text = table.concat(parts, "\n")
    end

    updateText()
    local conn = RunService.RenderStepped:Connect(function()
        if not humanoid or humanoid.Health <= 0 or not billboard.Parent then
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
                    if humanoid and humanoid.Health > 0 then applyESPToModel(npc) end
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        if espActiveEnemies or espActivePlayers then
            safePcall(updateESP)
        end
        task.wait(1)
    end
end)

local function isVisited(npc) return table.find(visitedNPCs, npc) ~= nil end
local function addVisited(npc) table.insert(visitedNPCs, npc) end
local function removeVisited(npc)
    for i, v in ipairs(visitedNPCs) do
        if v == npc then
            table.remove(visitedNPCs, i)
            pressCount[npc] = nil
            break
        end
    end
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
            task.wait(0.5)
        end
    end)
end
modifyProximityPrompts()

local function findNextNPCWithFlushProximity(maxDistance, referencePart)
    local lastDist, closestNPC, closestPrompt = maxDistance, nil, nil
    for _, npc in pairs(Workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
            for _, prompt in pairs(npc:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Flush" and (pressCount[npc] or 0) < 3 then
                    local dist = (prompt.Parent.Position - referencePart.Position).Magnitude
                    if dist < lastDist then
                        closestNPC, closestPrompt, lastDist = npc, prompt, dist
                    end
                end
            end
        end
    end
    return closestNPC, closestPrompt
end

local function findNextNPCWithHumanoid(maxDistance, referencePart, noProximity)
    local lastDist, closestNPC = maxDistance, nil
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
                    if not (noProximity and hasProximity) then
                        local dist = (npc.HumanoidRootPart.Position - referencePart.Position).Magnitude
                        if dist < lastDist then
                            closestNPC, lastDist = npc, dist
                        end
                    end
                end
            end
        end
    end
    return closestNPC
end

local function smoothTeleportTo(targetPos, duration)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local tweenInfo = TweenInfo.new(duration or 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    tween:Play()
    tween.Completed:Wait()
end

local function instantTeleportTo(targetPos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    hrp.CFrame = CFrame.new(targetPos)
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
            supportPart.Position = character.HumanoidRootPart.Position - Vector3.new(0, character.HumanoidRootPart.Size.Y / 1 + supportPart.Size.Y / 1, 0)
        end
    end)
end

local function removeSupportPart()
    if partConnection then partConnection:Disconnect() end
    if supportPart then supportPart:Destroy() end
    partConnection, supportPart = nil, nil
end

local function calculatePosition(npc)
    if not npc or not npc:FindFirstChild("HumanoidRootPart") then return Vector3.new(), CFrame.new(), false end
    local hrp, dist = npc.HumanoidRootPart, getgenv().DistanceValue or 2
    local pos, targetPos, lookCFrame, anchored = hrp.Position, nil, nil, false

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
        spinAngle = spinAngle + math.rad(5)
        targetPos = pos + Vector3.new(math.cos(spinAngle) * dist, 0, math.sin(spinAngle) * dist)
        lookCFrame = CFrame.new(targetPos, pos)
    else
        targetPos = pos + (hrp.CFrame.LookVector * dist)
        lookCFrame = CFrame.new(targetPos, pos)
    end
    return targetPos, lookCFrame, anchored
end

local function attackHumanoid(npc, isMastery)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    createSupportPart(char)
    while (isMastery and MasteryAutoFarmActive or autoFarmActive) and humanoid.Health > 0 do
        teleportToTarget(calculatePosition(npc))
        safePcall(function() LMBRemote:FireServer() end)
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
                            while (pressCount[npc] or 0) < 3 and autoFarmActive do
                                safePcall(function()
                                    prompt:InputHoldBegin()
                                    task.wait(0.05)
                                    prompt:InputHoldEnd()
                                    pressCount[npc] = (pressCount[npc] or 0) + 1
                                end)
                                task.wait(0.15)
                            end
                            addVisited(npc)
                        else
                            removeVisited(npc)
                        end
                    else
                        local npc2 = findNextNPCWithHumanoid(1000, hrp, true)
                        if npc2 then
                            if not isVisited(npc2) then addVisited(npc2) end
                            attackHumanoid(npc2, false)
                        else
                            visitedNPCs, pressCount = {}, {}
                            task.wait(1)
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

local function startMasteryAutoFarm(isTest)
    task.spawn(function()
        local activeFlag = isTest and MasteryAutoFarmActiveTest or MasteryAutoFarmActive
        while activeFlag do
            safePcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if isTest then
                        local nearbyParts = Workspace:GetPartBoundsInRadius(hrp.Position, 100)
                        for _, part in pairs(nearbyParts) do
                            local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                            if prompt and prompt.ActionText == "Flush" then
                                safePcall(function()
                                    prompt:InputHoldBegin()
                                    task.wait(0.05)
                                    prompt:InputHoldEnd()
                                end)
                                task.wait(0.2)
                            end
                        end
                    end
                    local npc = findNextNPCWithHumanoid(1000, hrp, isTest)
                    if npc then
                        if not isVisited(npc) then addVisited(npc) end
                        attackHumanoid(npc, true)
                    else
                        visitedNPCs = {}
                        task.wait(0.5)
                    end
                end
            end)
            task.wait(0.05)
        end
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
                            safePcall(function()
                                obj.HoldDuration = 0
                                fireproximityprompt(obj)
                            end)
                        end
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end

local function startAutoReady()
    task.spawn(function()
        safePcall(function() GetReadyRemote:FireServer("1", true) end)
        while autoReadyActive do
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                safePcall(function() GetReadyRemote:FireServer("1", true) end)
            end
            task.wait(1)
        end
        safePcall(function() GetReadyRemote:FireServer("1", false) end)
    end)
end

local function startAutoSkipHelicopter()
    task.spawn(function()
        while autoSkipHelicopterActive do
            safePcall(function() SkipHelicopterRemote:FireServer() end)
            task.wait(1)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if autoFarmActive then startAutoFarm() end
    if MasteryAutoFarmActive then startMasteryAutoFarm(false) end
    if MasteryAutoFarmActiveTest then startMasteryAutoFarm(true) end
    if flushAuraActive then flushAura() end
    if autoReadyActive then startAutoReady() end
    if autoSkipHelicopterActive then startAutoSkipHelicopter() end
end)

-- UI Setup
local userversion = safePcall(function()
    local response = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/dyumra/Whitelist/refs/heads/main/DYHUB-PREMIUM.lua"))
    return response[LocalPlayer.Name] and "Premium Version" or "Free Version"
end) and "Free Version" or "Free Version"

local Window = WindUI:CreateWindow({
    Title = "DYHUB Optimized",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "ST: Blockade Battlefront | " .. userversion,
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

safePcall(function()
    Window:Tag({Title = version, Color = Color3.fromHex("#30ff6a")})
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Tabs = {
    Info = Window:Tab({Title = "Information", Icon = "info"}),
    Main = Window:Tab({Title = "Main", Icon = "rocket"}),
    Player = Window:Tab({Title = "Player", Icon = "user"}),
    Skill = Window:Tab({Title = "Skill", Icon = "flame"}),
    Esp = Window:Tab({Title = "Esp", Icon = "eye"}),
    Collect = Window:Tab({Title = "Collect", Icon = "hand"}),
    Hitbox = Window:Tab({Title = "Hitbox", Icon = "package"}),
    Quest = Window:Tab({Title = "Quest", Icon = "sword"}),
    Mastery = Window:Tab({Title = "Mastery", Icon = "award"}),
    Codes = Window:Tab({Title = "Codes", Icon = "bird"}),
    Shop = Window:Tab({Title = "Shop", Icon = "shopping-cart"}),
    Gamepass = Window:Tab({Title = "Gamepass", Icon = "cookie"}),
    Misc = Window:Tab({Title = "Misc", Icon = "file-cog"}),
}

Window:SelectTab(1)

-- UI Components
Tabs.Codes:Section({Title = "Feature Code", Icon = "terminal"})
Tabs.Esp:Section({Title = "Feature Esp", Icon = "radar"})
Tabs.Hitbox:Section({Title = "Beta Version: Bugs/Under Fixing", Icon = "bug"})
Tabs.Hitbox:Section({Title = "Feature Hitbox", Icon = "crosshair"})
Tabs.Quest:Section({Title = "Feature Quest", Icon = "album"})
Tabs.Mastery:Section({Title = "Feature Mastery", Icon = "book-open"})
Tabs.Gamepass:Section({Title = "Feature Gamepass", Icon = "key-round"})
Tabs.Gamepass:Section({Title = "Unlock gamepass for real!", Icon = "badge-dollar-sign"})
Tabs.Player:Section({Title = "Feature Player", Icon = "user"})
Tabs.Misc:Section({Title = "Feature Visual", Icon = "eye"})
Tabs.Collect:Section({Title = "Feature Collect", Icon = "package"})
Tabs.Main:Section({Title = "Feature Play", Icon = "gamepad-2"})

Tabs.Main:Toggle({
    Title = "Auto Ready",
    Default = false,
    Callback = function(value)
        autoReadyActive = value
        if value then startAutoReady() end
    end,
})

Tabs.Main:Toggle({
    Title = "Auto Skip Helicopter",
    Default = false,
    Callback = function(value)
        autoSkipHelicopterActive = value
        if value then startAutoSkipHelicopter() end
    end,
})

local redeemCodes = {"Verified", "BackOnBusiness", "UTSM", "18k loss", "50KGroup", "WaveStuckIssue", "flying toilet", "AstroInvasionBegin", "DarkDriveIssue", "Digi"}
local selectedCodes = {}

Tabs.Codes:Dropdown({
    Title = "Select Redeem Codes",
    Multi = true,
    Values = redeemCodes,
    Callback = function(value) selectedCodes = value or {} end,
})

Tabs.Codes:Button({
    Title = "Redeem Selected Codes",
    Callback = function()
        for _, code in ipairs(selectedCodes) do
            safePcall(function() RedeemCodeRemote:FireServer(code) end)
            task.wait(0.2)
        end
    end,
})

Tabs.Codes:Button({
    Title = "Redeem Code All",
    Callback = function()
        for _, code in ipairs(redeemCodes) do
            safePcall(function() RedeemCodeRemote:FireServer(code) end)
            task.wait(0.2)
        end
    end,
})

Tabs.Esp:Dropdown({
    Title = "ESP Mode",
    Values = {"Highlight", "BoxHandle"},
    Default = espMode,
    Multi = false,
    Callback = function(value)
        espMode = value
        if espActiveEnemies or espActivePlayers then updateESP() end
    end,
})

Tabs.Esp:Toggle({
    Title = "ESP (Enemies)",
    Default = false,
    Callback = function(value)
        espActiveEnemies = value
        updateESP()
    end,
})

Tabs.Esp:Toggle({
    Title = "ESP (Players)",
    Default = false,
    Callback = function(value)
        espActivePlayers = value
        updateESP()
    end,
})

Tabs.Esp:Section({Title = "Esp Setting", Icon = "settings-2"})

Tabs.Esp:Toggle({
    Title = "ESP Name",
    Default = true,
    Callback = function(value)
        espShowName = value
        if espActiveEnemies or espActivePlayers then updateESP() end
    end,
})

Tabs.Esp:Toggle({
    Title = "ESP Health",
    Default = true,
    Callback = function(value)
        espShowHealth = value
        if espActiveEnemies or espActivePlayers then updateESP() end
    end,
})

Tabs.Esp:Toggle({
    Title = "ESP Distance",
    Default = false,
    Callback = function(value)
        espShowDistance = value
        if espActiveEnemies or espActivePlayers then updateESP() end
    end,
})

local function applyHitboxToNPC(npc)
    if not npc:IsA("Model") then return end
    local humanoid, hrp = npc:FindFirstChildOfClass("Humanoid"), npc:FindFirstChild("HumanoidRootPart")
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
                safePcall(function() applyHitboxToNPC(npc) end)
            end
        end
    end
end

task.spawn(function()
    while true do
        if getgenv().HitboxEnabled then
            safePcall(scanNPCs)
        end
        task.wait(1)
    end
end)

Tabs.Hitbox:Button({
    Title = "Scan Humanoid",
    Callback = function() scanNPCs() end,
})

Tabs.Hitbox:Slider({
    Title = "Set Size Hitbox",
    Value = {Min = 16, Max = 100, Default = 20},
    Step = 1,
    Callback = function(val) getgenv().HitboxSize = val end,
})

Tabs.Hitbox:Toggle({
    Title = "Enable Hitbox",
    Default = false,
    Callback = function(value) getgenv().HitboxEnabled = value end,
})

Tabs.Hitbox:Toggle({
    Title = "Show Hitbox (Transparency)",
    Default = false,
    Callback = function(value) getgenv().HitboxShow = value end,
})

Tabs.Quest:Button({
    Title = "Open Menu (Quest Clock-Man)",
    Callback = function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("QuestClockManUI")
        if gui then gui.Enabled = not gui.Enabled end
    end,
})

Tabs.Quest:Button({
    Title = "Open Menu (Quest)",
    Callback = function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("QuestUI")
        if gui then gui.Enabled = not gui.Enabled end
    end,
})

Tabs.Quest:Section({Title = "Setting Auto Quest", Icon = "star-half"})

Tabs.Quest:Dropdown({
    Title = "Set Position",
    Values = {"Spin", "Above", "Back", "Under", "Front"},
    Default = setPositionMode,
    Multi = false,
    Callback = function(value) setPositionMode = value end,
})

Tabs.Quest:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value) movementMode = value end,
})

Tabs.Quest:Toggle({
    Title = "Auto Farm (Upgrade)",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if value then startAutoFarm() end
    end,
})

Tabs.Mastery:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value) movementMode = value end,
})

Tabs.Mastery:Dropdown({
    Title = "Action Speed",
    Values = {"Default", "Slow", "Faster", "Flash (Lag)"},
    Default = ActionMode,
    Multi = false,
    Callback = function(value) ActionMode = value end,
})

Tabs.Mastery:Dropdown({
    Title = "Character List",
    Values = {"Small", "Large", "Support (Not Good)", "Titan"},
    Default = CharacterMode,
    Multi = false,
    Callback = function(value) CharacterMode = value end,
})

Tabs.Mastery:Dropdown({
    Title = "Set Position",
    Values = {"Spin", "Above", "Back", "Under", "Front"},
    Default = setPositionMode,
    Multi = false,
    Callback = function(value) setPositionMode = value end,
})

Tabs.Mastery:Slider({
    Title = "Set Distance to NPC",
    Value = {Min = 0, Max = 50, Default = getgenv().DistanceValue},
    Step = 1,
    Callback = function(val) getgenv().DistanceValue = val end,
})

Tabs.Mastery:Toggle({
    Title = "Auto Mastery (No Flush)",
    Default = false,
    Callback = function(value)
        MasteryAutoFarmActive = value
        if value then startMasteryAutoFarm(false) else removeSupportPart() end
    end,
})

Tabs.Mastery:Toggle({
    Title = "Auto Mastery (Flush)",
    Default = false,
    Callback = function(value)
        MasteryAutoFarmActiveTest = value
        if value then startMasteryAutoFarm(true) else removeSupportPart() end
    end,
})

local Gamepasst = {"LuckyBoost", "RareLuckyBoost", "LegendaryLuckyBoost", "All"}
local Gamepassts = {}

Tabs.Gamepass:Dropdown({
    Title = "Select Gamepass",
    Multi = true,
    Values = Gamepasst,
    Callback = function(value) Gamepassts = value or {} end,
})

Tabs.Gamepass:Button({
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
            end)
            task.wait(0.2)
        end
    end,
})

Tabs.Player:Button({
    Title = "Open Menu (Helicopter)",
    Callback = function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("003-A")
        if gui then gui.Enabled = not gui.Enabled end
    end,
})

Tabs.Player:Slider({
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

Tabs.Player:Toggle({
    Title = "Enable Speed",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end,
})

Tabs.Player:Slider({
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

Tabs.Player:Toggle({
    Title = "Enable JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().jumpEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v and getgenv().jumpValue or 50 end
    end,
})

Tabs.Player:Section({Title = "Player Misc", Icon = "sliders-horizontal"})

Tabs.Player:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end,
})

Tabs.Player:Toggle({
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

Tabs.Player:Button({
    Title = "Fly (Beta)",
    Callback = function()
        safePcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))()
        end)
    end,
})

local oldLighting = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    FogColor = Lighting.FogColor,
}

local vibrantEffect = Lighting:FindFirstChild("VibrantEffect") or Instance.new("ColorCorrectionEffect")
vibrantEffect.Name = "VibrantEffect"
vibrantEffect.Saturation = 1
vibrantEffect.Contrast = 0.4
vibrantEffect.Brightness = 0.05
vibrantEffect.Enabled = false
vibrantEffect.Parent = Lighting

Tabs.Misc:Toggle({
    Title = "Full Bright",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 5
            Lighting.ClockTime = 14
            fullBrightConnection = RunService.RenderStepped:Connect(function()
                Lighting.ClockTime = 14
                Lighting.Brightness = 10
                Lighting.Ambient = Color3.new(1, 1, 1)
            end)
        else
            if fullBrightConnection then fullBrightConnection:Disconnect() fullBrightConnection = nil end
            Lighting.Ambient = oldLighting.Ambient
            Lighting.Brightness = oldLighting.Brightness
            Lighting.ClockTime = oldLighting.ClockTime
        end
    end,
})

Tabs.Misc:Toggle({
    Title = "No Fog",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.FogStart = 0
            Lighting.FogEnd = 1e10
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            noFogConnection = RunService.RenderStepped:Connect(function()
                Lighting.FogStart = 0
                Lighting.FogEnd = 1e10
                Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            end)
        else
            if noFogConnection then noFogConnection:Disconnect() noFogConnection = nil end
            Lighting.FogStart = oldLighting.FogStart
            Lighting.FogEnd = oldLighting.FogEnd
            Lighting.FogColor = oldLighting.FogColor
        end
    end,
})

Tabs.Misc:Toggle({
    Title = "Vibrant Colors",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)
            Lighting.ColorShift_Bottom = Color3.fromRGB(200, 240, 255)
            vibrantEffect.Enabled = true
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            vibrantEffect.Enabled = false
        end
    end,
})

local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Outline, fpsText.Visible = 16, Vector2.new(Camera.ViewportSize.X - 100, 10), Color3.fromRGB(0, 255, 0), true, true
msText.Size, msText.Position, msText.Color, msText.Outline, msText.Visible = 16, Vector2.new(Camera.ViewportSize.X - 100, 30), Color3.fromRGB(0, 255, 0), true, true
local fpsCounter, fpsLastUpdate = 0, tick()

RunService.RenderStepped:Connect(function()
    fpsCounter = fpsCounter + 1
    if tick() - fpsLastUpdate >= 1 then
        fpsText.Text = "FPS: " .. tostring(fpsCounter)
        fpsText.Visible = showFPS
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
        msText.Text = "Ping: " .. (ping and math.floor(ping:GetValue()) or 0) .. " ms"
        msText.Color = ping and ping:GetValue() <= 60 and Color3.fromRGB(0, 255, 0) or ping:GetValue() <= 120 and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 0, 0)
        msText.Visible = showPing
        fpsCounter, fpsLastUpdate = 0, tick()
    end
end)

Tabs.Misc:Section({Title = "FPS Boost Settings", Icon = "zap"})

Tabs.Misc:Toggle({
    Title = "Show FPS",
    Default = true,
    Callback = function(val) showFPS = val fpsText.Visible = val end,
})

Tabs.Misc:Toggle({
    Title = "Show Ping (ms)",
    Default = true,
    Callback = function(val) showPing = val msText.Visible = val end,
})

Tabs.Misc:Button({
    Title = "FPS Boost (Fixed)",
    Callback = function()
        safePcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.Brightness = 2
            Lighting.FogEnd = 100
            Lighting.GlobalShadows = false
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.ClockTime = 14
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = Workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(Lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") then part.CastShadow = false end
            end
        end)
        print("[Boost] FPS Boost Applied")
    end,
})

Tabs.Main:Section({Title = "Feature Vote", Icon = "vote"})

local voteOptions = {"Normal", "Hard", "VeryHard", "Insane", "Nightmare", "BossRush", "ThunderStorm", "Zombie", "Christmas", "Hell", "DarkDimension", "Astro"}
Tabs.Main:Dropdown({
    Title = "Set Vote",
    Values = voteOptions,
    Default = "Normal",
    Multi = false,
    Callback = function(value)
        autoVoteValue = value
        safePcall(function() VoteRemote:FireServer(value) end)
    end,
})

Tabs.Main:Toggle({
    Title = "Auto Vote",
    Default = false,
    Callback = function(enabled)
        autoVoteEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoVoteEnabled do
                    safePcall(function() VoteRemote:FireServer(autoVoteValue) end)
                    task.wait(1)
                end
            end)
        end
    end,
})

local Items = {"Clock Spider", "Transmitter", "FlashDrive", "Astro Samples"}
local ItemsValue = {"Clock Spider"}
local autoCollectEnabled, itemNotifyEnabled = false, false

local function teleportToTarget(targetPos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    hrp.CFrame = CFrame.new(targetPos)
end

local function collectItem(obj)
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp.Position
        while prompt.Parent and autoCollectEnabled do
            local targetPos = (obj.PrimaryPart and obj.PrimaryPart.Position or obj.Position) + Vector3.new(0, 3, 0)
            teleportToTarget(targetPos)
            task.wait(0.1)
            safePcall(function()
                prompt:InputHoldBegin()
                task.wait(0.05)
                prompt:InputHoldEnd()
            end)
            task.wait(0.2)
        end
        teleportToTarget(originalPos)
    end
end

local function itemNotify(obj)
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
end

Tabs.Collect:Dropdown({
    Title = "Set Collect Items",
    Values = Items,
    Default = "Clock Spider",
    Multi = true,
    Callback = function(value) ItemsValue = value end,
})

Tabs.Collect:Toggle({
    Title = "Auto Collect",
    Default = false,
    Callback = function(enabled)
        autoCollectEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoCollectEnabled do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if (obj:IsA("Model") or obj:IsA("Part")) and table.find(ItemsValue, obj.Name) then
                            safePcall(function() collectItem(obj) end)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end,
})

Tabs.Collect:Toggle({
    Title = "Item Notify",
    Default = false,
    Callback = function(enabled)
        itemNotifyEnabled = enabled
        if enabled then
            task.spawn(function()
                while itemNotifyEnabled do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if (obj:IsA("Model") or obj:IsA("Part")) and table.find(ItemsValue, obj.Name) then
                            safePcall(function() itemNotify(obj) end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end,
})

Tabs.Shop:Section({Title = "Hourly Shop (Beta)", Icon = "shopping-cart"})

local shop, shopValue, shopValue1, autobuyEnabled = {}, {}, {}, false
for _, gear in pairs(game:GetService("ReplicatedFirst"):WaitForChild("Gears", 5):GetChildren()) do
    table.insert(shop, gear.Name)
end

Tabs.Shop:Dropdown({
    Title = "Set Auto Buy Items",
    Values = shop,
    Default = {},
    Multi = true,
    Callback = function(value) shopValue = value end,
})

Tabs.Shop:Dropdown({
    Title = "Set Amount Buy Items",
    Values = {"1", "2", "3", "4", "5"},
    Default = {},
    Multi = true,
    Callback = function(value) shopValue1 = value end,
})

Tabs.Shop:Toggle({
    Title = "Auto Buy",
    Default = false,
    Callback = function(enabled)
        autobuyEnabled = enabled
        if enabled then
            task.spawn(function()
                while autobuyEnabled do
                    for _, item in ipairs(shopValue) do
                        for _, amount in ipairs(shopValue1) do
                            safePcall(function() BuyItemRemote:FireServer(item, amount) end)
                            task.wait(1)
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end,
})

Tabs.Shop:Section({Title = "Feature Gacha", Icon = "gem"})

local autobuyCharEnabled, autobuySkinEnabled = false, false
local gachaCharOptions, gachaSkinOptions = {"1SpinLucky", "10Spins", "1Spin"}, {"1SpinLucky", "1Spin", "10Spins"}
local selectedChar, selectedSkin = {}, {}

Tabs.Shop:Dropdown({
    Title = "Select Gacha Character Spins",
    Values = gachaCharOptions,
    Default = {},
    Multi = true,
    Callback = function(value) selectedChar = value end,
})

Tabs.Shop:Toggle({
    Title = "Auto Gacha Character",
    Default = false,
    Callback = function(enabled)
        autobuyCharEnabled = enabled
        if enabled then
            task.spawn(function()
                while autobuyCharEnabled do
                    for _, spin in ipairs(selectedChar) do
                        safePcall(function() GachaCharacterRemote:FireServer(spin) end)
                        task.wait(1)
                    end
                end
            end)
        end
    end,
})

Tabs.Shop:Dropdown({
    Title = "Select Gacha Skin Spins",
    Values = gachaSkinOptions,
    Default = {},
    Multi = true,
    Callback = function(value) selectedSkin = value end,
})

Tabs.Shop:Toggle({
    Title = "Auto Gacha Skin",
    Default = false,
    Callback = function(enabled)
        autobuySkinEnabled = enabled
        if enabled then
            task.spawn(function()
                while autobuySkinEnabled do
                    for _, spin in ipairs(selectedSkin) do
                        safePcall(function() GachaSkinsRemote:FireServer(spin) end)
                        task.wait(1)
                    end
                end
            end)
        end
    end,
})

Tabs.Main:Section({Title = "Feature Farm", Icon = "tractor"})

Tabs.Main:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value) movementMode = value end,
})

Tabs.Main:Dropdown({
    Title = "Set Position",
    Values = {"Spin", "Above", "Back", "Under", "Front"},
    Default = setPositionMode,
    Multi = false,
    Callback = function(value) setPositionMode = value end,
})

Tabs.Main:Slider({
    Title = "Set Distance to NPC",
    Value = {Min = 0, Max = 50, Default = getgenv().DistanceValue},
    Step = 1,
    Callback = function(val) getgenv().DistanceValue = val end,
})

Tabs.Main:Toggle({
    Title = "Auto Farm (Upgrade)",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if value then startAutoFarm() end
    end,
})

Tabs.Main:Toggle({
    Title = "Flush Aura (Upgrade)",
    Default = false,
    Callback = function(value)
        flushAuraActive = value
        if value then flushAura() end
    end,
})

Tabs.Skill:Section({Title = "Feature Skill", Icon = "sparkles"})

local autoSkillEnabled, autoSkillValues, skillDelay, loopDelay = false, {}, 0.25, 0.5
local skillList = {"Q", "E", "R", "T", "Y", "F", "G", "H", "Z", "X", "C", "V", "B"}
local dropdownValues = {"All"}
for _, v in ipairs(skillList) do table.insert(dropdownValues, v) end

Tabs.Skill:Dropdown({
    Title = "Set Auto Skill",
    Values = dropdownValues,
    Multi = true,
    Callback = function(values)
        autoSkillValues = table.find(values, "All") and skillList or values
    end,
})

Tabs.Skill:Toggle({
    Title = "Auto Skill",
    Default = false,
    Callback = function(enabled)
        autoSkillEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoSkillEnabled do
                    for _, key in ipairs(autoSkillValues) do
                        safePcall(function()
                            VirtualInputManager:SendKeyEvent(true, key, false, game)
                            task.wait(0.05)
                            VirtualInputManager:SendKeyEvent(false, key, false, game)
                        end)
                        task.wait(skillDelay)
                    end
                    task.wait(loopDelay)
                end
            end)
        end
    end,
})

local DiscordAPI = "https://discord.com/api/v10/invites/jWNDPNMmyB?with_counts=true&with_expiration=true"

local function LoadDiscordInfo()
    local success, result = safePcall(function()
        return HttpService:JSONDecode(ui.Creator.Request({
            Url = DiscordAPI,
            Method = "GET",
            Headers = {["User-Agent"] = "RobloxBot/1.0", ["Accept"] = "application/json"}
        }).Body)
    end)
    if success and result and result.guild then
        local DiscordInfo = Tabs.Info:Paragraph({
            Title = result.guild.name,
            Desc = ' <font color="#52525b">●</font> Member Count : ' .. tostring(result.approximate_member_count) ..
                   '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(result.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=1024",
            ImageSize = 42,
        })
        Tabs.Info:Button({
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
        Tabs.Info:Button({
            Title = "Copy Discord Invite",
            Callback = function()
                setclipboard("https://discord.gg/jWNDPNMmyB")
                WindUI:Notify({Title = "Copied!", Content = "Discord invite copied to clipboard", Duration = 2, Icon = "clipboard-check"})
            end,
        })
    else
        Tabs.Info:Paragraph({
            Title = "Error fetching Discord Info",
            Desc = "Unable to load Discord information. Check your internet connection.",
            Image = "triangle-alert",
            ImageSize = 26,
            Color = "Red",
        })
    end
end

safePcall(LoadDiscordInfo)

Tabs.Info:Divider()
Tabs.Info:Section({Title = "DYHUB Information", TextXAlignment = "Center", TextSize = 17})
Tabs.Info:Divider()

Tabs.Info:Paragraph({
    Title = "Main Owner",
    Desc = "@dyumraisgoodguy#8888",
    Image = "rbxassetid://119789418015420",
    ImageSize = 30,
})

Tabs.Info:Paragraph({
    Title = "Social",
    Desc = "Copy link social media for follow!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Buttons = {{Icon = "copy", Title = "Copy Link", Callback = function() setclipboard("https://guns.lol/DYHUB") print("Copied social media link!") end}},
})

Tabs.Info:Paragraph({
    Title = "Discord",
    Desc = "Join our discord for more scripts!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Buttons = {{Icon = "copy", Title = "Copy Link", Callback = function() setclipboard("https://discord.gg/jWNDPNMmyB") print("Copied discord link!") end}},
})

print("[DYHUB] Optimized Script Loaded!")
