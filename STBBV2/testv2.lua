local version = "3.4.9"
if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="dsc.gg/dyhub", Text="FPS Unlocked!", Duration=2, Button1="Okay"})
    warn("FPS Unlocked!")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="dsc.gg/dyhub", Text="Your exploit does not support setfpscap.", Duration=2, Button1="Okay"})
    warn("Your exploit does not support setfpscap.")
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players, ReplicatedStorage, TweenService, workspace, UserInputService, RunService, Lighting, HttpService, VirtualInputManager =
    game:GetService("Players"), game:GetService("ReplicatedStorage"), game:GetService("TweenService"), game.Workspace,
    game:GetService("UserInputService"), game:GetService("RunService"), game:GetService("Lighting"), game:GetService("HttpService"), game:GetService("VirtualInputManager")
local LocalPlayer, GetReadyRemote, SkipHelicopterRemote, LMBRemote = Players.LocalPlayer, ReplicatedStorage:WaitForChild("GetReadyRemote"), ReplicatedStorage:WaitForChild("SkipHelicopter"), ReplicatedStorage:WaitForChild("LMB")
local autoVoteValue, autoVoteEnabled, setPositionMode, movementMode, CharacterMode, ActionMode = "Normal", false, "Under", "CFrame", "Used", "Default"
getgenv().DistanceValue, getgenv().HitboxEnabled, getgenv().HitboxSize, getgenv().HitboxShow, getgenv().speedEnabled, getgenv().speedValue, getgenv().jumpEnabled, getgenv().jumpValue = 1, false, 20, false, false, 20, false, 50
local autoFarmActive, autoReadyActive, MasteryAutoFarmActive, MasteryAutoFarmActiveTest, autoSkipHelicopterActive, flushAuraActive, espActiveEnemies, espActivePlayers, espShowName, espShowHealth, espShowDistance, espMode = false, false, false, false, false, false, false, false, true, true, false, "Highlight"
local visitedNPCs, pressCount, espObjects, supportPart, partConnection, spinAngle, autoCollectEnabled, itemNotifyEnabled, autobuyEnabled, autobuyCharEnabled, autobuySkinEnabled, autoSkillEnabled, autoSkillValues, skillDelay, loopDelay = {}, {}, {}, nil, nil, 0, false, false, false, false, false, false, {}, 0.25, 0.5
local oldAmbient, oldBrightness, oldClockTime, oldFogStart, oldFogEnd, oldFogColor = Lighting.Ambient, Lighting.Brightness, Lighting.ClockTime, Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor

local function clearESP()
    for _, obj in pairs(espObjects) do pcall(function() if obj and obj.Parent then obj:Destroy() end end) end
    espObjects = {}
end

local function createBillboard(model, humanoid)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local billboard = Instance.new("BillboardGui", workspace)
    billboard.Name, billboard.Adornee, billboard.Size, billboard.AlwaysOnTop, billboard.StudsOffset = "DYHUB_ESP_Billboard", hrp, UDim2.new(0, 150, 0, 50), true, Vector3.new(0, 3, 0)
    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Size, textLabel.BackgroundTransparency, textLabel.TextColor3, textLabel.TextStrokeTransparency, textLabel.TextStrokeColor3, textLabel.Font, textLabel.TextScaled = UDim2.new(1, 0, 1, 0), 1, Color3.new(1, 0, 0), 0, Color3.new(0, 0, 0), Enum.Font.SourceSansBold, true
    local function updateText()
        local parts = {}
        if espShowName then table.insert(parts, model.Name or "NPC") end
        if humanoid and espShowHealth then table.insert(parts, math.floor(humanoid.Health).." / "..math.floor(humanoid.MaxHealth)) end
        if espShowDistance then table.insert(parts, "Dist: "..math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)) end
        textLabel.Text = table.concat(parts, "\n")
    end
    updateText()
    local conn = RunService.RenderStepped:Connect(function() if not humanoid or humanoid.Health <= 0 then billboard:Destroy() conn:Disconnect() else updateText() end end)
    table.insert(espObjects, billboard)
end

local function applyESPToModel(model)
    if espMode == "Highlight" then
        local highlight = Instance.new("Highlight", workspace)
        highlight.Adornee, highlight.FillColor, highlight.OutlineColor = model, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255)
        table.insert(espObjects, highlight)
        createBillboard(model, model:FindFirstChildOfClass("Humanoid"))
    elseif espMode == "BoxHandle" then
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local box = Instance.new("BoxHandleAdornment", workspace.Terrain)
        box.Adornee, box.AlwaysOnTop, box.ZIndex, box.Size, box.Color3, box.Transparency = hrp, true, 10, Vector3.new(4, 6, 2), Color3.fromRGB(255, 0, 0), 0.5
        table.insert(espObjects, box)
        createBillboard(model, model:FindFirstChildOfClass("Humanoid"))
    end
end

local function updateESP()
    clearESP()
    if not (espActiveEnemies or espActivePlayers) then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then applyESPToModel(char) end
    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and (espActiveEnemies or (espActivePlayers and Players:GetPlayerFromCharacter(npc))) then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then applyESPToModel(npc) end
            end
        end
    end
end

task.spawn(function() while true do if espActiveEnemies or espActivePlayers then pcall(updateESP) end task.wait(1) end end)

local function isVisited(npc) return table.find(visitedNPCs, npc) end
local function addVisited(npc) table.insert(visitedNPCs, npc) end
local function removeVisited(npc) for i, v in ipairs(visitedNPCs) do if v == npc then table.remove(visitedNPCs, i) pressCount[npc] = nil break end end end

local function keepModifyProximityPrompts()
    task.spawn(function() while true do pcall(function() for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 end end end) task.wait(0.5) end end)
end
keepModifyProximityPrompts()

local function findNextNPCWithFlushProximity(maxDistance, referencePart)
    local lastDist, closestNPC, closestPrompt = maxDistance, nil, nil
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
            for _, prompt in pairs(npc:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Flush" and (pressCount[npc] or 0) < 3 then
                    local dist = (prompt.Parent.Position - referencePart.Position).Magnitude
                    if dist < lastDist then closestNPC, closestPrompt, lastDist = npc, prompt, dist end
                end
            end
        end
    end
    return closestNPC, closestPrompt
end

local function findNextNPCWithHumanoid(maxDistance, referencePart, noProximity)
    local lastDist, closestNPC = maxDistance, nil
    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local hasProximity = false
                    if noProximity then for _, child in pairs(npc:GetDescendants()) do if child:IsA("ProximityPrompt") then hasProximity = true break end end end
                    if not (noProximity and hasProximity) then
                        local dist = (npc.HumanoidRootPart.Position - referencePart.Position).Magnitude
                        if dist < lastDist then closestNPC, lastDist = npc, dist end
                    end
                end
            end
        end
    end
    return closestNPC
end

local function smoothTeleportTo(targetPos, duration)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    tween:Play()
    tween.Completed:Wait()
end

local function instantTeleportTo(targetPos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(targetPos)
end

local function teleportToTarget(targetPos, duration)
    if movementMode == "CFrame" then smoothTeleportTo(targetPos, duration or 0.5) else instantTeleportTo(targetPos) end
end

local function createSupportPart(character)
    if supportPart then supportPart:Destroy() supportPart = nil end
    if partConnection then partConnection:Disconnect() partConnection = nil end
    supportPart = Instance.new("Part", workspace)
    supportPart.Size, supportPart.Anchored, supportPart.CanCollide, supportPart.Transparency, supportPart.Name = Vector3.new(5, 1, 5), true, true, 0.9, "AutoFarmSupport"
    partConnection = RunService.Heartbeat:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            supportPart.Position = character.HumanoidRootPart.Position - Vector3.new(0, (character.HumanoidRootPart.Size.Y / 1 + supportPart.Size.Y / 1), 0)
        end
    end)
end

local function removeSupportPart()
    if partConnection then partConnection:Disconnect() partConnection = nil end
    if supportPart then supportPart:Destroy() supportPart = nil end
end

local function calculatePosition(npc)
    if not npc or not npc:FindFirstChild("HumanoidRootPart") then return Vector3.new(), CFrame.new(), false end
    local hrp, pos, dist = npc.HumanoidRootPart, npc.HumanoidRootPart.Position, getgenv().DistanceValue or 2
    local targetPos, lookCFrame, anchored
    if setPositionMode == "Above" then
        targetPos, lookCFrame, anchored = pos + Vector3.new(0, dist, 0), CFrame.new(pos + Vector3.new(0, dist, 0)) * CFrame.Angles(-math.pi/2, 0, 0), true
    elseif setPositionMode == "Under" then
        targetPos, lookCFrame, anchored = pos - Vector3.new(0, dist, 0), CFrame.new(pos - Vector3.new(0, dist, 0)) * CFrame.Angles(math.pi/2, 0, 0), true
    elseif setPositionMode == "Front" then
        targetPos, lookCFrame = pos + (hrp.CFrame.LookVector * dist), CFrame.new(pos + (hrp.CFrame.LookVector * dist), pos)
    elseif setPositionMode == "Back" then
        targetPos, lookCFrame = pos - (hrp.CFrame.LookVector * dist), CFrame.new(pos - (hrp.CFrame.LookVector * dist), pos)
    elseif setPositionMode == "Spin" then
        spinAngle = spinAngle + math.rad(5)
        targetPos, lookCFrame = pos + Vector3.new(math.cos(spinAngle) * dist, 0, math.sin(spinAngle) * dist), CFrame.new(pos + Vector3.new(math.cos(spinAngle) * dist, 0, math.sin(spinAngle) * dist), pos)
    else
        targetPos, lookCFrame = pos + (hrp.CFrame.LookVector * dist), CFrame.new(pos + (hrp.CFrame.LookVector * dist), pos)
    end
    return targetPos, lookCFrame, anchored
end

local function attackHumanoid(npc, mode)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    local character = LocalPlayer.Character
    createSupportPart(character)
    while humanoid.Health > 0 and (mode == "autoFarm" and autoFarmActive or mode == "mastery" and MasteryAutoFarmActive or mode == "masteryTest" and MasteryAutoFarmActiveTest) do
        teleportToTarget(calculatePosition(npc), 0.5)
        LMBRemote:FireServer()
        task.wait(0.1)
    end
    removeSupportPart()
    removeVisited(npc)
end

local function startAutoFarm()
    task.spawn(function()
        while autoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc, prompt = findNextNPCWithFlushProximity(1000, hrp)
                    if npc and prompt and prompt.Parent then
                        local humanoid = npc:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            local targetPos = calculatePosition(npc)
                            teleportToTarget(targetPos, 0.5)
                            while (pressCount[npc] or 0) < 3 do
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
                            if not isVisited(npc2) then addVisited(npc2) end
                            attackHumanoid(npc2, "autoFarm")
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

local function MasteryAutoFarmTest()
    task.spawn(function()
        while MasteryAutoFarmActiveTest do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, part in pairs(workspace:GetPartBoundsInRadius(hrp.Position, 100)) do
                        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and prompt.ActionText == "Flush" then
                            pcall(function() prompt:InputHoldBegin() task.wait(0.05) prompt:InputHoldEnd() end)
                            task.wait(0.2)
                        end
                    end
                    local npc = findNextNPCWithHumanoid(1000, hrp)
                    if npc then
                        if not isVisited(npc) then addVisited(npc) end
                        attackHumanoid(npc, "masteryTest")
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

local function MasteryAutoFarm()
    task.spawn(function()
        while MasteryAutoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc = findNextNPCWithHumanoid(1000, hrp)
                    if npc then
                        if not isVisited(npc) then addVisited(npc) end
                        attackHumanoid(npc, "mastery")
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
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, part in pairs(workspace:GetPartBoundsInRadius(hrp.Position, 100)) do
                        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and prompt.ActionText == "Flush" then
                            pcall(function() prompt:InputHoldBegin() task.wait(0.05) prompt:InputHoldEnd() end)
                            task.wait(0.2)
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

local function sendReady(value) GetReadyRemote:FireServer("1", value) end

local function startAutoReady()
    task.spawn(function()
        sendReady(true)
        while autoReadyActive do
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then sendReady(true) end
            task.wait(1)
        end
        sendReady(false)
    end)
end

local function startAutoSkipHelicopter()
    task.spawn(function() while autoSkipHelicopterActive do pcall(function() SkipHelicopterRemote:FireServer() end) task.wait(1) end end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if autoFarmActive then startAutoFarm() end
    if MasteryAutoFarmActive then MasteryAutoFarm() end
    if MasteryAutoFarmActiveTest then MasteryAutoFarmTest() end
    if flushAuraActive then flushAura() end
    if autoReadyActive then startAutoReady() end
    if autoSkipHelicopterActive then startAutoSkipHelicopter() end
end)

local function checkVersion(playerName)
    local success, response = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/dyumra/Whitelist/refs/heads/main/DYHUB-PREMIUM.lua") end)
    if not success then return "Free Version" end
    local premiumData
    local func, err = loadstring(response)
    if func then premiumData = func() else return "Free Version" end
    return premiumData[playerName] and "Premium Version" or "Free Version"
end

local Window = WindUI:CreateWindow({
    Title = "DYHUB", IconThemed = true, Icon = "rbxassetid://104487529937663", Author = "ST : Blockade Battlefront | " .. checkVersion(LocalPlayer.Name),
    Folder = "DYHUB_Stbb_config", Size = UDim2.fromOffset(500, 350), Transparent = true, Theme = "Dark", BackgroundImageTransparency = 0.8, HasOutline = false, HideSearchBar = true, ScrollBarEnabled = false,
    User = {Enabled = true, Anonymous = false}
})
pcall(function() Window:Tag({Title = version, Color = Color3.fromHex("#30ff6a")}) end)
Window:EditOpenButton({Title = "DYHUB - Open", Icon = "monitor", CornerRadius = UDim.new(0, 6), StrokeThickness = 2, Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)), Draggable = true})

local InfoTab, MainTab, PlayerTab, SkillTab, EspTab, CollectTab, HitboxTab, QuestTab, MasteryTab, CodesTab, ShopTab, GameTab, MiscTab =
    Window:Tab({Title = "Information", Icon = "info"}), Window:Tab({Title = "Main", Icon = "rocket"}), Window:Tab({Title = "Player", Icon = "user"}),
    Window:Tab({Title = "Skill", Icon = "flame"}), Window:Tab({Title = "Esp", Icon = "eye"}), Window:Tab({Title = "Collect", Icon = "hand"}),
    Window:Tab({Title = "Hitbox", Icon = "package"}), Window:Tab({Title = "Quest", Icon = "sword"}), Window:Tab({Title = "Mastery", Icon = "award"}),
    Window:Tab({Title = "Codes", Icon = "bird"}), Window:Tab({Title = "Shop", Icon = "shopping-cart"}), Window:Tab({Title = "Gamepass", Icon = "cookie"}),
    Window:Tab({Title = "Misc", Icon = "file-cog"})
Window:SelectTab(1)

CodesTab:Section({Title = "Feature Code", Icon = "terminal"})
EspTab:Section({Title = "Feature Esp", Icon = "radar"})
HitboxTab:Section({Title = "Beta Version: Bugs/Under Fixing", Icon = "bug"}):Section({Title = "Feature Hitbox", Icon = "crosshair"})
QuestTab:Section({Title = "Feature Quest", Icon = "album"})
MasteryTab:Section({Title = "Feature Mastery", Icon = "book-open"})
GameTab:Section({Title = "Feature Gamepass", Icon = "key-round"}):Section({Title = "Unlock gamepass for real!", Icon = "badge-dollar-sign"})
PlayerTab:Section({Title = "Feature Player", Icon = "user"})
MiscTab:Section({Title = "Feature Visual", Icon = "eye"})
CollectTab:Section({Title = "Feature Collect", Icon = "package"})
MainTab:Section({Title = "Feature Play", Icon = "gamepad-2"})

MainTab:Toggle({Title = "Auto Ready", Default = false, Callback = function(value) autoReadyActive = value if value then startAutoReady() end end})
MainTab:Toggle({Title = "Auto Skip Helicopter", Default = false, Callback = function(value) autoSkipHelicopterActive = value if value then startAutoSkipHelicopter() end end})

local redeemCodes = {"Verified", "BackOnBusiness", "UTSM", "18k loss", "50KGroup", "WaveStuckIssue", "flying toilet", "AstroInvasionBegin", "DarkDriveIssue", "Digi"}
local selectedCodes = {}
CodesTab:Dropdown({Title = "Select Redeem Codes", Multi = true, Values = redeemCodes, Callback = function(value) selectedCodes = value or {} end})
CodesTab:Button({Title = "Redeem Selected Codes", Callback = function() for _, code in ipairs(selectedCodes) do pcall(function() ReplicatedStorage:WaitForChild("RedeemCode"):FireServer(code) task.wait(0.2) end) end end})
CodesTab:Button({Title = "Redeem Code All", Callback = function() for _, code in ipairs(redeemCodes) do pcall(function() ReplicatedStorage:WaitForChild("RedeemCode"):FireServer(code) task.wait(0.2) end) end end})

EspTab:Dropdown({Title = "ESP Mode", Values = {"Highlight", "BoxHandle"}, Default = espMode, Multi = false, Callback = function(value) espMode = value updateESP() end})
EspTab:Toggle({Title = "ESP (Enemies)", Default = false, Callback = function(value) espActiveEnemies = value updateESP() end})
EspTab:Toggle({Title = "ESP (Players)", Default = false, Callback = function(value) espActivePlayers = value updateESP() end})
EspTab:Section({Title = "Esp Setting", Icon = "settings-2"})
EspTab:Toggle({Title = "ESP Name", Default = true, Callback = function(value) espShowName = value updateESP() end})
EspTab:Toggle({Title = "ESP Health", Default = true, Callback = function(value) espShowHealth = value updateESP() end})
EspTab:Toggle({Title = "ESP Distance", Default = false, Callback = function(value) espShowDistance = value updateESP() end})

local function applyHitboxToNPC(npc)
    if not npc:IsA("Model") then return end
    local humanoid, hrp = npc:FindFirstChildOfClass("Humanoid"), npc:FindFirstChild("HumanoidRootPart")
    if humanoid and hrp then
        local existing = hrp:FindFirstChild("DYHUB_Hitbox")
        if getgenv().HitboxEnabled then
            if not existing then
                local box = Instance.new("BoxHandleAdornment", hrp)
                box.Name, box.Adornee, box.AlwaysOnTop, box.ZIndex, box.Size, box.Transparency, box.Color3 = "DYHUB_Hitbox", hrp, true, 10, Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize), getgenv().HitboxShow and 0.5 or 1, Color3.fromRGB(255, 0, 0)
            else
                existing.Size, existing.Transparency = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize), getgenv().HitboxShow and 0.5 or 1
            end
        elseif existing then existing:Destroy() end
    end
end

local function scanNPCs()
    print("[DYHUB] Scan Loading...")
    for i = 1, 3 do print("[DYHUB] Scan Loading... ["..i.."]") task.wait(0.3) end
    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) then
                applyHitboxToNPC(npc)
            end
        end
    end
end

task.spawn(function() while task.wait(1) do if getgenv().HitboxEnabled and workspace:FindFirstChild("Living") then for _, npc in pairs(workspace.Living:GetChildren()) do if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) then applyHitboxToNPC(npc) end end end end end)

HitboxTab:Button({Title = "Scan Humanoid", Callback = scanNPCs})
HitboxTab:Slider({Title = "Set Size Hitbox", Value = {Min = 16, Max = 100, Default = 20}, Step = 1, Callback = function(val) getgenv().HitboxSize = val end})
HitboxTab:Toggle({Title = "Enable Hitbox", Default = false, Callback = function(value) getgenv().HitboxEnabled = value end})
HitboxTab:Toggle({Title = "Show Hitbox (Transparency)", Default = false, Callback = function(value) getgenv().HitboxShow = value end})

QuestTab:Button({Title = "Open Menu (Quest Clock-Man)", Callback = function() local gui = LocalPlayer.PlayerGui:FindFirstChild("QuestClockManUI") if gui then gui.Enabled = not gui.Enabled end end})
QuestTab:Button({Title = "Open Menu (Quest)", Callback = function() local gui = LocalPlayer.PlayerGui:FindFirstChild("QuestUI") if gui then gui.Enabled = not gui.Enabled end end})
QuestTab:Section({Title = "Setting Auto Quest", Icon = "star-half"})
QuestTab:Dropdown({Title = "Set Position", Values = {"Spin", "Above", "Back", "Under", "Front"}, Default = setPositionMode, Multi = false, Callback = function(value) setPositionMode = value end})
QuestTab:Dropdown({Title = "Movement", Values = {"Teleport", "CFrame"}, Default = movementMode, Multi = false, Callback = function(value) movementMode = value end})
QuestTab:Toggle({Title = "Auto Farm (Upgrade)", Default = false, Callback = function(value) autoFarmActive = value if value then startAutoFarm() end end})
QuestTab:Toggle({Title = "Auto Quest Collect (Beta)", Default = false, Callback = function(value) print("[DYHUB] Collect Quest: "..tostring(value)) end})
QuestTab:Toggle({Title = "Auto Quest Skip (Need Robux)", Default = false, Callback = function(value) print("[DYHUB] Skip Quest: "..tostring(value)) end})

MasteryTab:Dropdown({Title = "Movement", Values = {"Teleport", "CFrame"}, Default = movementMode, Multi = false, Callback = function(value) movementMode = value end})
MasteryTab:Dropdown({Title = "Action Speed", Values = {"Default", "Slow", "Faster", "Flash (Lag)"}, Default = ActionMode, Multi = false, Callback = function(value) ActionMode = value end})
MasteryTab:Dropdown({Title = "Character List", Values = {"Small", "Large", "Support (Not Good)", "Titan"}, Default = CharacterMode, Multi = false, Callback = function(value) CharacterMode = value end})
MasteryTab:Dropdown({Title = "Set Position", Values = {"Spin", "Above", "Back", "Under", "Front"}, Default = setPositionMode, Multi = false, Callback = function(value) setPositionMode = value end})
MasteryTab:Slider({Title = "Set Distance to NPC", Value = {Min = 0, Max = 50, Default = getgenv().DistanceValue}, Step = 1, Callback = function(val) getgenv().DistanceValue = val end})
MasteryTab:Toggle({Title = "Auto Mastery (No Flush)", Default = false, Callback = function(value) MasteryAutoFarmActive = value if value then MasteryAutoFarm() else removeSupportPart() end end})
MasteryTab:Toggle({Title = "Auto Mastery (Flush)", Default = false, Callback = function(value) MasteryAutoFarmActiveTest = value if value then MasteryAutoFarmTest() else removeSupportPart() end end})

local Gamepasst, Gamepassts = {"LuckyBoost", "RareLuckyBoost", "LegendaryLuckyBoost", "All"}, {}
GameTab:Dropdown({Title = "Select Gamepass", Multi = true, Values = Gamepasst, Callback = function(value) Gamepassts = value or {} end})
GameTab:Button({Title = "Unlock Selected Gamepass", Callback = function()
    local gachaData = LocalPlayer:FindFirstChild("GachaData") or Instance.new("Folder", LocalPlayer)
    gachaData.Name = "GachaData"
    local toUnlock = {}
    for _, v in ipairs(Gamepassts) do if v == "All" then toUnlock = {"LuckyBoost", "RareLuckyBoost", "LegendaryLuckyBoost"} break else table.insert(toUnlock, v) end end
    for _, gamepassName in ipairs(toUnlock) do pcall(function() local boolValue = gachaData:FindFirstChild(gamepassName) or Instance.new("BoolValue", gachaData) boolValue.Name, boolValue.Value = gamepassName, true task.wait(0.2) end) end
end})

PlayerTab:Button({Title = "Open Menu (Helicopter)", Callback = function() local gui = LocalPlayer.PlayerGui:FindFirstChild("003-A") if gui then gui.Enabled = not gui.Enabled end end})
PlayerTab:Slider({Title = "Set Speed Value", Value = {Min = 16, Max = 600, Default = 20}, Step = 1, Callback = function(val) getgenv().speedValue = val if getgenv().speedEnabled then local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") if hum then hum.WalkSpeed = val end end end})
PlayerTab:Toggle({Title = "Enable Speed", Default = false, Callback = function(v) getgenv().speedEnabled = v local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() local hum = char:FindFirstChild("Humanoid") if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end end})
PlayerTab:Slider({Title = "Set Jump Value", Value = {Min = 10, Max = 600, Default = 50}, Step = 1, Callback = function(val) getgenv().jumpValue = val if getgenv().jumpEnabled then local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") if hum then hum.JumpPower = val end end end})
PlayerTab:Toggle({Title = "Enable JumpPower", Default = false, Callback = function(v) getgenv().jumpEnabled = v local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() local hum = char:FindFirstChild("Humanoid") if hum then hum.JumpPower = v and getgenv().jumpValue or 50 end end})
PlayerTab:Section({Title = "Player Misc", Icon = "sliders-horizontal"})
local noclipConnection
PlayerTab:Toggle({Title = "No Clip", Default = false, Callback = function(state)
    if state then
        noclipConnection = RunService.Stepped:Connect(function() local Character = LocalPlayer.Character if Character then for _, part in pairs(Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        local Character = LocalPlayer.Character if Character then for _, part in pairs(Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end
    end
end})
PlayerTab:Toggle({Title = "Infinity Jump", Default = false, Callback = function(state)
    if state then
        getgenv().infJumpConnection = UserInputService.JumpRequest:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)
    else
        if getgenv().infJumpConnection then getgenv().infJumpConnection:Disconnect() getgenv().infJumpConnection = nil end
    end
end})
PlayerTab:Button({Title = "Fly (Beta)", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))() end})

local vibrantEffect = Lighting:FindFirstChild("VibrantEffect") or Instance.new("ColorCorrectionEffect", Lighting)
vibrantEffect.Name, vibrantEffect.Saturation, vibrantEffect.Contrast, vibrantEffect.Brightness, vibrantEffect.Enabled = "VibrantEffect", 1, 0.4, 0.05, false
MiscTab:Toggle({Title = "Full Bright", Default = false, Callback = function(state)
    if state then
        Lighting.Ambient, Lighting.Brightness, Lighting.ClockTime = Color3.new(1, 1, 1), 5, 14
        fullBrightConnection = RunService.RenderStepped:Connect(function() if Lighting.ClockTime ~= 14 then Lighting.ClockTime = 14 end if Lighting.Brightness ~= 10 then Lighting.Brightness = 10 end if Lighting.Ambient ~= Color3.new(1,1,1) then Lighting.Ambient = Color3.new(1,1,1) end end)
    else
        if fullBrightConnection then fullBrightConnection:Disconnect() fullBrightConnection = nil end
        Lighting.Ambient, Lighting.Brightness, Lighting.ClockTime = oldAmbient, oldBrightness, oldClockTime
    end
end})
MiscTab:Toggle({Title = "No Fog", Default = false, Callback = function(state)
    if state then
        Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = 0, 1e10, Color3.fromRGB(255, 255, 255)
        noFogConnection = RunService.RenderStepped:Connect(function() if Lighting.FogStart ~= 0 then Lighting.FogStart = 0 end if Lighting.FogEnd ~= 1e10 then Lighting.FogEnd = 1e10 end if Lighting.FogColor ~= Color3.fromRGB(255, 255, 255) then Lighting.FogColor = Color3.fromRGB(255, 255, 255) end end)
    else
        if noFogConnection then noFogConnection:Disconnect() noFogConnection = nil end
        Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = oldFogStart, oldFogEnd, oldFogColor
    end
end})
MiscTab:Toggle({Title = "Vibrant Colors", Default = false, Callback = function(state)
    if state then
        Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.ColorShift_Top, Lighting.ColorShift_Bottom, vibrantEffect.Enabled = Color3.fromRGB(180, 180, 180), Color3.fromRGB(170, 170, 170), Color3.fromRGB(255, 230, 200), Color3.fromRGB(200, 240, 255), true
    else
        Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.ColorShift_Top, Lighting.ColorShift_Bottom, vibrantEffect.Enabled = Color3.new(0, 0, 0), Color3.new(0, 0, 0), Color3.new(0, 0, 0), Color3.new(0, 0, 0), false
    end
end})

local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible = 16, Vector2.new(workspace.CurrentCamera.ViewportSize.X - 100, 10), Color3.fromRGB(0, 255, 0), false, true, true
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible = 16, Vector2.new(workspace.CurrentCamera.ViewportSize.X - 100, 30), Color3.fromRGB(0, 255, 0), false, true, true
local fpsCounter, fpsLastUpdate = 0, tick()
RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        fpsText.Text, fpsText.Visible = "FPS: "..tostring(fpsCounter), showFPS
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"] and math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) or 0
        msText.Text = ping <= 60 and "Ping: "..ping.." ms" or ping <= 120 and "Ping: "..ping.." ms" or "Ew Wifi Ping: "..ping.." ms"
        msText.Color = ping <= 60 and Color3.fromRGB(0, 255, 0) or ping <= 120 and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 0, 0)
        msText.Visible = showPing
        fpsCounter, fpsLastUpdate = 0, tick()
    end
end)
MiscTab:Section({Title = "FPS Boost Settings", Icon = "zap"})
MiscTab:Toggle({Title = "Show FPS", Default = true, Callback = function(val) showFPS = val fpsText.Visible = val end})
MiscTab:Toggle({Title = "Show Ping (ms)", Default = true, Callback = function(val) showPing = val msText.Visible = val end})
MiscTab:Button({Title = "FPS Boost (Fixed)", Callback = function()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.Brightness, Lighting.FogEnd, Lighting.GlobalShadows, Lighting.EnvironmentDiffuseScale, Lighting.EnvironmentSpecularScale, Lighting.ClockTime, Lighting.OutdoorAmbient = 2, 100, false, 0, 0, 14, Color3.new(0, 0, 0)
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then terrain.WaterWaveSize, terrain.WaterWaveSpeed, terrain.WaterReflectance, terrain.WaterTransparency = 0, 0, 0, 1 end
        for _, obj in ipairs(Lighting:GetDescendants()) do if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then obj.Enabled = false end end
        for _, obj in ipairs(game:GetDescendants()) do if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled = false elseif obj:IsA("Texture") or obj:IsA("Decal") then obj.Transparency = 1 end end
        for _, part in ipairs(workspace:GetDescendants()) do if part:IsA("BasePart") then part.CastShadow = false end end
    end)
    print("[Boost] FPS Boost Applied")
end})

MainTab:Section({Title = "Feature Vote", Icon = "vote"})
MainTab:Dropdown({Title = "Set Vote", Values = {"Normal", "Hard", "VeryHard", "Insane", "Nightmare", "BossRush", "ThunderStorm", "Zombie", "Christmas", "Hell", "DarkDimension", "Astro"}, Default = "Normal", Multi = false, Callback = function(value) autoVoteValue = value ReplicatedStorage:WaitForChild("Vote"):FireServer(value) end})
MainTab:Toggle({Title = "Auto Vote", Default = false, Callback = function(enabled) autoVoteEnabled = enabled if enabled then task.spawn(function() while autoVoteEnabled do ReplicatedStorage:WaitForChild("Vote"):FireServer(autoVoteValue) task.wait(1) end end) end end})

local Items, ItemsValue = {"Clock Spider", "Transmitter", "FlashDrive", "Astro Samples"}, {"Clock Spider"}
local function teleportToTarget(targetPos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
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
            prompt:InputHoldBegin()
            task.wait(0.05)
            prompt:InputHoldEnd()
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
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Item Notify", Text = string.format("Name: %s\nDistance: %04d mm", obj.Name, math.floor(distance)), Duration = 3})
    end
end

CollectTab:Dropdown({Title = "Set Collect Items", Values = Items, Default = "Clock Spider", Multi = true, Callback = function(value) ItemsValue = value end})
CollectTab:Toggle({Title = "Auto Collect", Default = false, Callback = function(enabled)
    autoCollectEnabled = enabled
    if enabled then
        task.spawn(function() while autoCollectEnabled do for _, obj in pairs(workspace:GetDescendants()) do if (obj:IsA("Model") or obj:IsA("Part")) and table.find(ItemsValue, obj.Name) then task.spawn(function() pcall(collectItem, obj) end) end end task.wait(0.5) end end)
    end
end})
CollectTab:Toggle({Title = "Item Notify", Default = false, Callback = function(enabled)
    itemNotifyEnabled = enabled
    if enabled then
        task.spawn(function() while itemNotifyEnabled do for _, obj in pairs(workspace:GetDescendants()) do if (obj:IsA("Model") or obj:IsA("Part")) and table.find(ItemsValue, obj.Name) then pcall(itemNotify, obj) end end task.wait(1) end end)
    end
end})

local function modifyProximityPrompts()
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("Part")) and table.find(ItemsValue, obj.Name) then
            local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
            if prompt then prompt.HoldDuration = 0 end
        end
    end
end
modifyProximityPrompts()

ShopTab:Section({Title = "Hourly Shop (Beta)", Icon = "shopping-cart"})
local shop, shopValue, shop1, shopValue1 = {}, {}, {"1", "2", "3", "4", "5"}, {}
for _, gear in pairs(game:GetService("ReplicatedFirst"):WaitForChild("Gears"):GetChildren()) do table.insert(shop, gear.Name) end
ShopTab:Dropdown({Title = "Set Auto Buy Items", Values = shop, Default = {}, Multi = true, Callback = function(value) shopValue = value end})
ShopTab:Dropdown({Title = "Set Amount Buy Items", Values = shop1, Default = {}, Multi = true, Callback = function(value) shopValue1 = value end})
ShopTab:Toggle({Title = "Auto Buy", Default = false, Callback = function(enabled)
    autobuyEnabled = enabled
    if enabled then
        task.spawn(function() while autobuyEnabled do for _, item in ipairs(shopValue) do for _, amount in ipairs(shopValue1) do pcall(function() ReplicatedStorage:WaitForChild("BuyItemFromShopHourly"):FireServer(item, amount) task.wait(1) end) end end task.wait(2) end end)
    end
end})

ShopTab:Section({Title = "Featrue Gacha", Icon = "gem"})
local gachaCharOptions, gachaSkinOptions, selectedChar, selectedSkin = {"1SpinLucky", "10Spins", "1Spin"}, {"1SpinLucky", "1Spin", "10Spins"}, {}, {}
ShopTab:Dropdown({Title = "Select Gacha Character Spins", Values = gachaCharOptions, Default = {}, Multi = true, Callback = function(value) selectedChar = value end})
ShopTab:Toggle({Title = "Auto Gacha Character", Default = false, Callback = function(enabled)
    autobuyCharEnabled = enabled
    if enabled then
        task.spawn(function() while autobuyCharEnabled do for _, spin in ipairs(selectedChar) do pcall(function() ReplicatedStorage:WaitForChild("GachaCharacter"):FireServer(spin) task.wait(1) end) end end end)
    end
end})
ShopTab:Dropdown({Title = "Select Gacha Skin Spins", Values = gachaSkinOptions, Default = {}, Multi = true, Callback = function(value) selectedSkin = value end})
ShopTab:Toggle({Title = "Auto Gacha Skin", Default = false, Callback = function(enabled)
    autobuySkinEnabled = enabled
    if enabled then
        task.spawn(function() while autobuySkinEnabled do for _, spin in ipairs(selectedSkin) do pcall(function() ReplicatedStorage:WaitForChild("GachaSkins"):FireServer(spin) task.wait(1) end) end end end)
    end
end})

MainTab:Section({Title = "Feature Farm", Icon = "tractor"})
MainTab:Dropdown({Title = "Movement", Values = {"Teleport", "CFrame"}, Default = movementMode, Multi = false, Callback = function(value) movementMode = value end})
MainTab:Dropdown({Title = "Set Position", Values = {"Spin", "Above", "Back", "Under", "Front"}, Default = setPositionMode, Multi = false, Callback = function(value) setPositionMode = value end})
MainTab:Slider({Title = "Set Distance to NPC", Value = {Min = 0, Max = 50, Default = getgenv().DistanceValue}, Step = 1, Callback = function(val) getgenv().DistanceValue = val end})
MainTab:Toggle({Title = "Auto Farm (Upgrade)", Default = false, Callback = function(value) autoFarmActive = value if value then startAutoFarm() end end})
MainTab:Toggle({Title = "Flush Aura (Upgrade)", Default = false, Callback = function(value)
    flushAuraActive = value
    if value then
        task.spawn(function() while flushAuraActive do pcall(function() for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 fireproximityprompt(obj) end end end) task.wait(0.3) end end)
    end
end})

SkillTab:Section({Title = "Feature Skill", Icon = "sparkles"})
local skillList, dropdownValues = {"Q", "E", "R", "T", "Y", "F", "G", "H", "Z", "X", "C", "V", "B"}, {"All"}
for _, v in ipairs(skillList) do table.insert(dropdownValues, v) end
SkillTab:Dropdown({Title = "Set Auto Skill", Values = dropdownValues, Multi = true, Callback = function(values) autoSkillValues = table.find(values, "All") and skillList or values end})
SkillTab:Toggle({Title = "Auto Skill", Default = false, Callback = function(enabled)
    autoSkillEnabled = enabled
    if enabled then
        task.spawn(function() while autoSkillEnabled do pcall(function() for _, key in ipairs(autoSkillValues) do VirtualInputManager:SendKeyEvent(true, key, false, game) task.wait(0.05) VirtualInputManager:SendKeyEvent(false, key, false, game) task.wait(skillDelay) end end) task.wait(loopDelay) end end)
    end
end})

ui = ui or {}
ui.Creator = ui.Creator or {}
ui.Creator.Request = function(requestData)
    local success, result = pcall(function()
        if HttpService.RequestAsync then
            local response = HttpService:RequestAsync({Url = requestData.Url, Method = requestData.Method or "GET", Headers = requestData.Headers or {}})
            return {Body = response.Body, StatusCode = response.StatusCode, Success = response.Success}
        else
            return {Body = HttpService:GetAsync(requestData.Url), StatusCode = 200, Success = true}
        end
    end)
    if success then return result else error("HTTP Request failed: "..tostring(result)) end
end

local InviteCode, DiscordAPI = "jWNDPNMmyB", "https://discord.com/api/v10/invites/jWNDPNMmyB?with_counts=true&with_expiration=true"
local function LoadDiscordInfo()
    local success, result = pcall(function() return HttpService:JSONDecode(ui.Creator.Request({Url = DiscordAPI, Method = "GET", Headers = {["User-Agent"] = "RobloxBot/1.0", ["Accept"] = "application/json"}}).Body) end)
    if success and result and result.guild then
        local DiscordInfo = InfoTab:Paragraph({Title = result.guild.name, Desc = ' <font color="#52525b">●</font> Member Count : '..tostring(result.approximate_member_count)..'\n <font color="#16a34a">●</font> Online Count : '..tostring(result.approximate_presence_count), Image = "https://cdn.discordapp.com/icons/"..result.guild.id.."/"..result.guild.icon..".png?size=1024", ImageSize = 42})
        InfoTab:Button({Title = "Update Info", Callback = function()
            local updated, updatedResult = pcall(function() return HttpService:JSONDecode(ui.Creator.Request({Url = DiscordAPI, Method = "GET"}).Body) end)
            if updated and updatedResult and updatedResult.guild then
                DiscordInfo:SetDesc(' <font color="#52525b">●</font> Member Count : '..tostring(updatedResult.approximate_member_count)..'\n <font color="#16a34a">●</font> Online Count : '..tostring(updatedResult.approximate_presence_count))
                WindUI:Notify({Title = "Discord Info Updated", Content = "Successfully refreshed Discord statistics", Duration = 2, Icon = "refresh-cw"})
            else
                WindUI:Notify({Title = "Update Failed", Content = "Could not refresh Discord info", Duration = 3, Icon = "alert-triangle"})
            end
        end})
        InfoTab:Button({Title = "Copy Discord Invite", Callback = function() setclipboard("https://discord.gg/"..InviteCode) WindUI:Notify({Title = "Copied!", Content = "Discord invite copied to clipboard", Duration = 2, Icon = "clipboard-check"}) end})
    else
        InfoTab:Paragraph({Title = "Error fetching Discord Info", Desc = "Unable to load Discord information. Check your internet connection.", Image = "triangle-alert", ImageSize = 26, Color = "Red"})
        print("Discord API Error:", result)
    end
end
LoadDiscordInfo()

InfoTab:Divider()
InfoTab:Section({Title = "DYHUB Information", TextXAlignment = "Center", TextSize = 17})
InfoTab:Divider()
InfoTab:Paragraph({Title = "Main Owner", Desc = "@dyumraisgoodguy#8888", Image = "rbxassetid://119789418015420", ImageSize = 30})
InfoTab:Paragraph({Title = "Social", Desc = "Copy link social media for follow!", Image = "rbxassetid://104487529937663", ImageSize = 30, Buttons = {{Icon = "copy", Title = "Copy Link", Callback = function() setclipboard("https://guns.lol/DYHUB") print("Copied social media link to clipboard!") end}}})
InfoTab:Paragraph({Title = "Discord", Desc = "Join our discord for more scripts!", Image = "rbxassetid://104487529937663", ImageSize = 30, Buttons = {{Icon = "copy", Title = "Copy Link", Callback = function() setclipboard("https://discord.gg/jWNDPNMmyB") print("Copied discord link to clipboard!") end}}})

print("[DYHUB] DYHUB - Loaded! (Console Show)")
