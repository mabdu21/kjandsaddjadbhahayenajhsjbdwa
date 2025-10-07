-- 3.1.9 beta

repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local workspace = game.Workspace
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local GetReadyRemote = ReplicatedStorage:WaitForChild("GetReadyRemote")
local SkipHelicopterRemote = ReplicatedStorage:WaitForChild("SkipHelicopter")
local LMBRemote = ReplicatedStorage:WaitForChild("LMB")

local normal = "Normal"
local autoVoteValue = normal
local autoVoteEnabled = false

local setPositionMode = "Under"
getgenv().DistanceValue = 1

local autoFarmActive = false
local autoReadyActive = false
local MasteryAutoFarmActive = false
local autoSkipHelicopterActive = false
local flushAuraActive = false
local espActive = false

local MMovementMode = "CFrame"

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

local visitedNPCs = {}
local pressCount = {}
local espObjects = {}

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
    billboard.Parent = workspace

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
            table.insert(parts, math.floor(humanoid.Health).." / "..math.floor(humanoid.MaxHealth))
        end
        if espShowDistance then
            local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            table.insert(parts, "Dist: "..math.floor(dist))
        end
        textLabel.Text = table.concat(parts, "\n")
    end

    updateText()

    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        if humanoid and humanoid.Health <= 0 then
            billboard:Destroy()
            if conn then
                conn:Disconnect()
                conn = nil
            end
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
        highlight.Parent = workspace
        table.insert(espObjects, highlight)
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then
            createBillboard(model, humanoid)
        end
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
        box.Parent = workspace.Terrain
        table.insert(espObjects, box)
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then
            createBillboard(model, humanoid)
        end
    end
end

local function updateESPmodel()
    clearESP()
    if not espActive then return end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        applyESPToModel(char)
    end

    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    applyESPToModel(npc)
                end
            end
        end
    end
end

-- แยกฟังก์ชัน update ESP
function updateESPPlayers()
    clearESP()
    if not espActivePlayers then return end
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            createBillboard(char, humanoid)
        end
    end
end

function updateESPEnemies()
    clearESP()
    if not espActiveEnemies then return end
    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    createBillboard(npc, humanoid)
                end
            end
        end
    end
end

-- Loop อัปเดต ESP
task.spawn(function()
    while true do
        if espActiveEnemies or espActivePlayers then
            pcall(updateESPmodel)
            pcall(updateESPPlayers)
            pcall(updateESPEnemies)
        else
            clearESP()
        end
        task.wait(1)
    end
end)

local function isVisited(npc)
    for _, v in ipairs(visitedNPCs) do
        if v == npc then return true end
    end
    return false
end

local function addVisited(npc)
    table.insert(visitedNPCs, npc)
end

local function removeVisited(npc)
    for i, v in ipairs(visitedNPCs) do
        if v == npc then
            table.remove(visitedNPCs, i)
            break
        end
    end
    pressCount[npc] = nil
end

-- ฟังก์ชันปรับ ProximityPrompt
local function keepModifyProximityPrompts()
    spawn(function()
        while true do
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.HoldDuration ~= 0 then
                        obj.HoldDuration = 0
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end
keepModifyProximityPrompts()

-- ฟังก์ชันหาตัว NPC
local function findNextNPCWithFlushProximity(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC, closestPrompt = nil, nil
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                for _, prompt in pairs(npc:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Flush" then
                        if (pressCount[npc] or 0) < 3 then
                            local dist = (prompt.Parent.Position - referencePart.Position).Magnitude
                            if dist < lastDist then
                                closestNPC, closestPrompt = npc, prompt
                                lastDist = dist
                            end
                        end
                    end
                end
            end
        end
    end
    return closestNPC, closestPrompt
end

local function findNextNPCWithHumanoidNoProximity(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC = nil
    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                    local humanoid = npc:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local hasProximity = false
                        for _, child in pairs(npc:GetDescendants()) do
                            if child:IsA("ProximityPrompt") then
                                hasProximity = true
                                break
                            end
                        end
                        if not hasProximity then
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
    end
    return closestNPC
end

local function findNextNPCWithHumanoid(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC = nil
    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                    local humanoid = npc:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
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

-- ฟังก์ชัน Teleport
local function smoothTeleportTo(targetPos, duration)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPos)}
    local tween = TweenService:Create(hrp, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
end

local function instantTeleportTo(targetPos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(targetPos)
end

local function teleportToTarget(targetPos, duration)
    if movementMode == "CFrame" then
        smoothTeleportTo(targetPos, duration or 0.5)
    else
        instantTeleportTo(targetPos)
    end
end

-- ฟังก์ชันสร้าง Support Part
local supportPart
local partConnection

local function createSupportPart(character)
    if supportPart then supportPart:Destroy() supportPart=nil end
    if partConnection then partConnection:Disconnect() partConnection=nil end
    supportPart = Instance.new("Part")
    supportPart.Size = Vector3.new(5,1,5)
    supportPart.Anchored = true
    supportPart.CanCollide = true
    supportPart.Transparency = 0.9
    supportPart.Name = "AutoFarmSupport"
    supportPart.Parent = workspace
    partConnection = RunService.Heartbeat:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            supportPart.Position = hrp.Position - Vector3.new(0,(hrp.Size.Y/1 + supportPart.Size.Y/1),0)
        end
    end)
end

local function removeSupportPart()
    if partConnection then partConnection:Disconnect() partConnection=nil end
    if supportPart then supportPart:Destroy() supportPart=nil end
end

local spinAngle = 0

local function calculatePosition(npc)
    if not npc or not npc:FindFirstChild("HumanoidRootPart") then 
        return Vector3.new() 
    end

    local hrp = npc.HumanoidRootPart
    local pos = hrp.Position
    local dist = getgenv().DistanceValue or 1

    if setPositionMode == "Above" then
        return pos + Vector3.new(0, dist, 0)
    elseif setPositionMode == "Under" then
        return pos - Vector3.new(0, dist, 0)
    elseif setPositionMode == "Back" then
        return pos - (hrp.CFrame.LookVector * dist)
    elseif setPositionMode == "Spin" then
        spinAngle = spinAngle + math.rad(5)
        return pos + Vector3.new(
            math.cos(spinAngle) * dist,
            0,
            math.sin(spinAngle) * dist
        )
    else
        return pos + (hrp.CFrame.LookVector * dist)
    end
end

-- ฟังก์ชันต่อย NPC
local function attackHumanoidNoProximity(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health<=0 then return end
    local character = LocalPlayer.Character
    createSupportPart(character)
    while humanoid.Health>0 and autoFarmActive do
        teleportToTarget(calculatePosition(npc),0.5)
        LMBRemote:FireServer()
        task.wait(0.1)
    end
    removeSupportPart()
    removeVisited(npc)
end

function attackHumanoid(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health<=0 then return end
    local character = LocalPlayer.Character
    createSupportPart(character)
    while humanoid.Health>0 and MasteryAutoFarmActive do
        teleportToTarget(calculatePosition(npc),0.5)
        LMBRemote:FireServer()
        task.wait(0.1)
    end
    removeSupportPart()
    removeVisited(npc)
end

-- AutoFarm
local function startAutoFarm()
    task.spawn(function()
        while autoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc,prompt = findNextNPCWithFlushProximity(1000,hrp)
                    if npc and prompt and prompt.Parent then
                        local humanoid = npc:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health>0 then
                            local targetPos = calculatePosition(npc)
                            teleportToTarget(targetPos,0.5)
                            while (pressCount[npc] or 0)<3 do
                                prompt:InputHoldBegin()
                                task.wait(0.05)
                                prompt:InputHoldEnd()
                                pressCount[npc]=(pressCount[npc] or 0)+1
                                task.wait(0.15)
                            end
                            addVisited(npc)
                        else
                            removeVisited(npc)
                        end
                    else
                        local npc2=findNextNPCWithHumanoidNoProximity(1000,hrp)
                        if npc2 then
                            if not isVisited(npc2) then addVisited(npc2) end
                            attackHumanoidNoProximity(npc2)
                        else
                            visitedNPCs={}
                            pressCount={}
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
        while MasteryAutoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Flush รอบตัว
                    local nearbyParts = workspace:GetPartBoundsInRadius(hrp.Position, 100, nil)
                    for _, part in pairs(nearbyParts) do
                        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and prompt.ActionText == "Flush" then
                            pcall(function()
                                prompt:InputHoldBegin()
                                task.wait(0.05)
                                prompt:InputHoldEnd()
                            end)
                            task.wait(0.2)
                        end
                    end

                    -- หา NPC ใกล้ที่สุด
                    local npc = findNextNPCWithHumanoid(1000, hrp)
                    if npc then
                        if not isVisited(npc) then
                            addVisited(npc)
                        end
                        attackHumanoid(npc)
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

-- Mastery AutoFarm
local function MasteryAutoFarm()
    task.spawn(function()
        while MasteryAutoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc=findNextNPCWithHumanoid(1000,hrp)
                    if npc then
                        if not isVisited(npc) then addVisited(npc) end
                        attackHumanoid(npc)
                    else
                        visitedNPCs={}
                        task.wait(0.5)
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

local function toggleMasteryAutoFarm(state)
    MasteryAutoFarmActive = state
    if not state then removeSupportPart() else MasteryAutoFarm() end
end

-- Flush Aura
local function flushAura()
    task.spawn(function()
        while flushAuraActive do
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local nearbyParts = workspace:GetPartBoundsInRadius(hrp.Position,100,nil)
                for _,part in pairs(nearbyParts) do
                    local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and prompt.ActionText=="Flush" then
                        pcall(function()
                            prompt:InputHoldBegin()
                            task.wait(0.05)
                            prompt:InputHoldEnd()
                        end)
                        task.wait(0.2)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end


local function sendReady(value)
    GetReadyRemote:FireServer("1", value)
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

local function startAutoSkipHelicopter()
    task.spawn(function()
        while autoSkipHelicopterActive do
            pcall(function()
                SkipHelicopterRemote:FireServer()
            end)
            task.wait(1)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if autoFarmActive then startAutoFarm() end
    if autoReadyActive then startAutoReady() end
    if autoSkipHelicopterActive then startAutoSkipHelicopter() end
    if flushAuraActive then flushAura() end
end)

local Window = WindUI:CreateWindow({
    Title = "DYHUB",                                                    -- ชื่อ Title บน UI
    Icon = "rbxassetid://104487529937663",                              -- ไอคอนที่จะแสดง (เช่น star)
    Author = "ST : Blockade Battlefront | Free Version",                -- แสดงข้อมูลเวอร์ชัน/ผู้เขียน
    Folder = "DYHUB_Stbb_config",
    Size = UDim2.fromOffset(600, 400),           -- ขนาดหน้าต่าง
    Transparent = true,                          -- โปร่งใส
    Theme = "Dark",                              -- ธีมมืด
    Resizable = true,                            -- ย่อ/ขยายได้
    SideBarWidth = 150,                          -- ความกว้าง sidebar
    BackgroundImageTransparency = 0.8,           -- ความโปร่งใสของ bg image
    HasOutline = false,                          -- ไม่มีเส้นขอบ
    HideSearchBar = true,                        -- ซ่อน search bar
    ScrollBarEnabled = false,                    -- ปิด scroll bar
    User = {
        Enabled = true,                          -- เปิดใช้งาน user widget
        Anonymous = false,                       -- ไม่ anonymous
        Callback = function()
            print("It's me")                     -- callback เมื่อกด user
        end,
    },
})


pcall(function()
    Window:Tag({
        Title = "3.1.8",
        Color = Color3.fromHex("#30ff6a") 
    })
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local InfoTab = Window:Tab({ Title = "Info", Icon = "info" })
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })
local VoteTab = Window:Tab({ Title="Vote", Icon="vote" })
local SkillTab = Window:Tab({ Title="Skill", Icon="flame" })
local CollectTab = Window:Tab({ Title="Collect", Icon="hand" })
local HitboxTab = Window:Tab({ Title = "Hitbox", Icon = "package" })
local QuestTab = Window:Tab({ Title = "Quest", Icon = "sword" })
local MasteryTab = Window:Tab({ Title = "Mastery", Icon = "award" })
local CodesTab = Window:Tab({ Title = "Codes", Icon = "bird" })
local GameTab = Window:Tab({ Title = "Gamepass", Icon = "cookie" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "file-cog" })

Window:SelectTab(1)

InfoTab:Section({ Title = "Info - Read before using this script", Icon = "info" })
InfoTab:Section({ Title = "This script is still under development." })
InfoTab:Section({ Title = "If there are any bugs or issues" })
InfoTab:Section({ Title = "you can report them to us on Discord" })

InfoTab:Button({
    Title = "DYHUB - Discord!",
    Callback = function()
        setclipboard("https://dsc.gg/dyhub")
    end
})

InfoTab:Section({ Title = "Use this script in SOLO mode only for safety", Icon = "triangle-alert" })
InfoTab:Section({ Title = "We appreciate your choice to use our script.", Icon = "heart" })

MainTab:Section({ Title = "Feature Farm", Icon = "tractor" }) 

CodesTab:Section({ Title = "Feature Code", Icon = "terminal" })

EspTab:Section({ Title = "Feature Esp", Icon = "radar" })

HitboxTab:Section({ Title = "Beta Version: Bugs or Etc", Icon = "bug" })
HitboxTab:Section({ Title = "Feature Hitbox", Icon = "crosshair" })

QuestTab:Section({ Title = "Feature Quest", Icon = "album" })

MasteryTab:Section({ Title = "Feature Mastery", Icon = "book-open" })

GameTab:Section({ Title = "Feature Gamepass", Icon = "key-round" })
GameTab:Section({ Title = "Unlock gamepass for real!", Icon = "badge-dollar-sign" })

PlayerTab:Section({ Title = "Feature Player", Icon = "user" })

MiscTab:Section({ Title = "Feature Visual", Icon = "eye" })
MiscTab:Section({ Title = "FPS Boost/Settings", Icon = "zap" })

CollectTab:Section({ Title = "Beta Version: Bugs or Etc", Icon = "bug" }) 
CollectTab:Section({ Title = "Feature Collect", Icon = "package" }) 

SkillTab:Section({ Title = "Beta Version: Bugs or Etc", Icon = "bug" }) 
SkillTab:Section({ Title = "Feature Skill", Icon = "sparkles" }) 

VoteTab:Section({ Title = "Feature Vote", Icon = "vote" }) 
VoteTab:Section({ Title = "Settings Difficulty mode", Icon = "book-check" }) 

MainTab:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value)
        movementMode = value
    end,
})

MainTab:Dropdown({
    Title="Set Position",
    Values={"Spin","Above","Back","Under","Front"},
    Default=setPositionMode,
    Multi=false,
    Callback=function(value) setPositionMode=value end
})

MainTab:Slider({
    Title="Set Distance to NPC",
    Value={Min=0, Max=50, Default=getgenv().DistanceValue},
    Step=1,
    Callback=function(val) getgenv().DistanceValue=val end
})

MainTab:Toggle({
    Title="Auto Farm (Upgrade)",
    Default=false,
    Callback=function(value) autoFarmActive=value if value then startAutoFarm() end end
})

MainTab:Toggle({
    Title = "Flush Aura (Upgrade)",
    Default = false,
    Callback = function(value)
        flushAuraActive = value
        if flushAuraActive then
            flushAura()
            task.spawn(function()
                while flushAuraActive do
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(2.5)
                end
            end)
        end
    end,
})

MainTab:Section({ Title = "Feature Play", Icon = "gamepad-2" })

MainTab:Toggle({
    Title = "Auto Ready",
    Default = false,
    Callback = function(value)
        autoReadyActive = value
        if autoReadyActive then
            startAutoReady()
        end
    end,
})

MainTab:Toggle({
    Title = "Auto Skip Helicopter",
    Default = false,
    Callback = function(value)
        autoSkipHelicopterActive = value
        if autoSkipHelicopterActive then
            startAutoSkipHelicopter()
        end
    end,
})

local redeemCodes = {
    "Verified",
    "BackOnBusiness",
    "UTSM", 
    "18k loss",
    "50KGroup",
    "WaveStuckIssue",
    "flying toilet",
    "AstroInvasionBegin",
    "WaveStuckIssue",
    "50KGroup",
    "DarkDriveIssue",
    "Digi",
}

local selectedCodes = {}

CodesTab:Dropdown({
    Title = "Select Redeem Codes",
    Multi = true,
    Values = redeemCodes,
    Callback = function(value)
        selectedCodes = value or {}
    end,
})

CodesTab:Button({
    Title = "Redeem Selected Codes",
    Callback = function()
        for _, codeKey in ipairs(selectedCodes) do
            local code = codeKey
            pcall(function()
                ReplicatedStorage:WaitForChild("RedeemCode"):FireServer(code)
                task.wait(0.2)
            end)
        end
    end,
})

CodesTab:Button({
    Title = "Redeem Code All",
    Callback = function()
        for _, codeKey in ipairs(redeemCodes) do
            local code = codeKey
            pcall(function()
                ReplicatedStorage:WaitForChild("RedeemCode"):FireServer(code)
                task.wait(0.2)
            end)
        end
    end,
})

EspTab:Dropdown({
    Title = "ESP Mode",
    Values = {"Highlight", "BoxHandle"},
    Default = espMode,
    Multi = false,
    Callback = function(value)
        espMode = value
        if espActiveEnemies or espActivePlayers then
            updateESPmodel()
            updateESPPlayers()
            updateESPEnemies()
        end
    end,
})

-- Toggle ESP Enemies
EspTab:Toggle({
    Title = "ESP (Enemies)",
    Default = false,
    Callback = function(value)
        espActiveEnemies = value
        if espActiveEnemies then
            updateESPmodel()
            updateESPEnemies()
        else
            clearESP()
        end
    end,
})

-- Toggle ESP Players
EspTab:Toggle({
    Title = "ESP (Players)",
    Default = false,
    Callback = function(value)
        espActivePlayers = value
        if espActivePlayers then
            updateESPmodel()
            updateESPPlayers()
        else
            clearESP()
        end
    end,
})

EspTab:Section({ Title = "Esp Setting", Icon = "settings-2" })

-- Toggle ESP Name
EspTab:Toggle({
    Title = "ESP Name",
    Default = true,
    Callback = function(value)
        espShowName = value
        if espActiveEnemies or espActivePlayers then
            updateESPPlayers()
            updateESPEnemies()
        end
    end,
})

-- Toggle ESP Health
EspTab:Toggle({
    Title = "ESP Health",
    Default = true,
    Callback = function(value)
        espShowHealth = value
        if espActiveEnemies or espActivePlayers then
            updateESPPlayers()
            updateESPEnemies()
        end
    end,
})

-- Toggle ESP Distance
EspTab:Toggle({
    Title = "ESP Distance",
    Default = false,
    Callback = function(value)
        espShowDistance = value
        if espActiveEnemies or espActivePlayers then
            updateESPPlayers()
            updateESPEnemies()
        end
    end,
})

-- 🌌 DYHUB - Hitbox System
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🧩 ฟังก์ชันปรับ Hitbox
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

-- 🔍 Scan NPC
local function scanNPCs()
    print("[DYHUB] Scan Loading...")
    task.wait(0.5)
    for i = 1, 3 do
        print("[DYHUB] Scan Loading... ["..i.."]")
        task.wait(0.3)
    end
    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(npc) then
                    applyHitboxToNPC(npc)
                end
            end
        end
    end
end

-- 🔄 Loop update
task.spawn(function()
    while task.wait(1) do
        if getgenv().HitboxEnabled then
            if workspace:FindFirstChild("Living") then
                for _, npc in pairs(workspace.Living:GetChildren()) do
                    if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                        if not Players:GetPlayerFromCharacter(npc) then
                            applyHitboxToNPC(npc)
                        end
                    end
                end
            end
        end
    end
end)


HitboxTab:Button({ 
    Title = "Scan Humanoid",  
    Callback = function()
        scanNPCs()
    end,
})

HitboxTab:Slider({
    Title = "Set Size Hitbox", 
    Value = {Min = 16, Max = 100, Default = 20}, 
    Step = 1,
    Callback = function(val)
        getgenv().HitboxSize = val
    end,
})

HitboxTab:Toggle({
    Title = "Enable Hitbox", 
    Default = false,
    Callback = function(value)
        getgenv().HitboxEnabled = value
    end,
})

HitboxTab:Toggle({
    Title = "Show Hitbox (Transparency)", 
    Default = false,
    Callback = function(value)
        getgenv().HitboxShow = value
    end,
})



local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

QuestTab:Button({
    Title = "Open Menu (Quest Clock-Man)",
    Callback = function()
        local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("QuestClockManUI")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end,
})

QuestTab:Button({
    Title = "Open Menu (Quest)",
    Callback = function()
        local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("QuestUI")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end,
})

QuestTab:Section({ Title = "Setting Auto Quest", Icon = "star-half" })

QuestTab:Dropdown({
    Title="Set Position",
    Values={"Spin","Above","Back","Under","Front"},
    Default=setPositionMode,
    Multi=false,
    Callback=function(value) setPositionMode=value end
})

QuestTab:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value)
        movementMode = value
    end,
})

QuestTab:Toggle({
    Title = "Auto Farm (Upgrade)",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if autoFarmActive then
            startAutoFarm()
        end
    end,
})


QuestTab:Toggle({
    Title = "Auto Quest Collect (Beta)",
    Default = false,
    Callback = function(value)
        autoFarm1Active = value
        print("[DYHUB] Collect Quest: " .. tostring(value))
    end,
})

QuestTab:Toggle({
    Title = "Auto Quest Skip (Need Robux)",
    Default = false,
    Callback = function(value)
        autoFarm2Active = value
        print("[DYHUB] Skip Quest: " .. tostring(value))
    end,
})

MasteryTab:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value)
        movementMode = value
    end,
})

MasteryTab:Dropdown({
    Title = "Action Speed",
    Values = {"Default", "Slow", "Faster", "Flash (Lag)"},
    Default = ActionMode,
    Multi = false,
    Callback = function(value)
        ActionMode = value
    end,
})

MasteryTab:Dropdown({
    Title = "Character List",
    Values = {"Small", "Large", "Support (Not Good)", "Titan"},
    Default = CharacterMode,
    Multi = false,
    Callback = function(value)
        CharacterMode = value
    end,
})

MasteryTab:Dropdown({
    Title="Set Position",
    Values={"Spin","Above","Back","Under","Front"},
    Default=setPositionMode,
    Multi=false,
    Callback=function(value) setPositionMode=value end
})

MasteryTab:Slider({
    Title="Set Distance to NPC",
    Value={Min=0, Max=50, Default=getgenv().DistanceValue},
    Step=1,
    Callback=function(val) getgenv().DistanceValue=val end
})

MasteryTab:Toggle({
    Title="Auto Mastery (ATK+Flush) (Beta)",
    Default=false,
    Callback=function(value)
        MasteryAutoFarmActive=value
        if value then MasteryAutoFarmTest() end
    end
})

MasteryTab:Toggle({
    Title="Auto Mastery (No Flush) (Beta)",
    Default=false,
    Callback=function(value) toggleMasteryAutoFarm(value) end
})


local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Gamepasst = {
    "LuckyBoost",
    "RareLuckyBoost",
    "LegendaryLuckyBoost",
    "All"
}

local Gamepassts = {}

GameTab:Dropdown({
    Title = "Select Gamepass",
    Multi = true,
    Values = Gamepasst,
    Callback = function(value)
        Gamepassts = value or {}
    end,
})

GameTab:Button({
    Title = "Unlock Selected Gamepass",
    Callback = function()
        local gachaData = player:FindFirstChild("GachaData")
        if not gachaData then
            gachaData = Instance.new("Folder")
            gachaData.Name = "GachaData"
            gachaData.Parent = player
        end

        local toUnlock = {}

        for _, v in ipairs(Gamepassts) do
            if v == "All" then
                toUnlock = {"LuckyBoost", "RareLuckyBoost", "LegendaryLuckyBoost"}
                break
            else
                table.insert(toUnlock, v)
            end
        end

        for _, gamepassName in ipairs(toUnlock) do
            pcall(function()
                local boolValue = gachaData:FindFirstChild(gamepassName)
                if not boolValue then
                    boolValue = Instance.new("BoolValue")
                    boolValue.Name = gamepassName
                    boolValue.Parent = gachaData
                end
                boolValue.Value = true
                task.wait(0.2)
            end)
        end
    end,
})


PlayerTab:Button({
    Title = "Open Menu (Helicopter)",
    Callback = function()
        local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("003-A")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end,
})

-- Player Tab Vars
getgenv().speedEnabled = false
getgenv().speedValue = 20

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
    end
})

PlayerTab:Toggle({
    Title = "Enable Speed",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})

getgenv().jumpEnabled = false
getgenv().jumpValue = 50

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
    end
})

PlayerTab:Toggle({
    Title = "Enable JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().jumpEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v and getgenv().jumpValue or 50 end
    end
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
    end
})

PlayerTab:Toggle({
    Title = "Infinity Jump",
    Default = false,
    Callback = function(state)
        local uis = game:GetService("UserInputService")
        local player = game.Players.LocalPlayer
        local infJumpConnection

        if state then
            infJumpConnection = uis.JumpRequest:Connect(function()
                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            getgenv().infJumpConnection = infJumpConnection
        else
            if getgenv().infJumpConnection then
                getgenv().infJumpConnection:Disconnect()
                getgenv().infJumpConnection = nil
            end
        end
    end
})

PlayerTab:Button({
    Title = "Fly (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))()
    end
})


-- Misc Tab Vars for Lighting Effects
local oldAmbient = Lighting.Ambient
local oldBrightness = Lighting.Brightness
local oldClockTime = Lighting.ClockTime
local oldFogStart = Lighting.FogStart
local oldFogEnd = Lighting.FogEnd
local oldFogColor = Lighting.FogColor

local fullBrightConnection
local noFogConnection

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
                if Lighting.Ambient ~= Color3.new(1,1,1) then Lighting.Ambient = Color3.new(1,1,1) end
            end)
        else
            if fullBrightConnection then
                fullBrightConnection:Disconnect()
                fullBrightConnection = nil
            end
            Lighting.Ambient = oldAmbient
            Lighting.Brightness = oldBrightness
            Lighting.ClockTime = oldClockTime
        end
    end
})

MiscTab:Toggle({
    Title = "No Fog",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.FogStart = 0
            Lighting.FogEnd = 1e10
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)

            noFogConnection = RunService.RenderStepped:Connect(function()
                if Lighting.FogStart ~= 0 then Lighting.FogStart = 0 end
                if Lighting.FogEnd ~= 1e10 then Lighting.FogEnd = 1e10 end
                if Lighting.FogColor ~= Color3.fromRGB(255, 255, 255) then Lighting.FogColor = Color3.fromRGB(255, 255, 255) end
            end)
        else
            if noFogConnection then
                noFogConnection:Disconnect()
                noFogConnection = nil
            end
            Lighting.FogStart = oldFogStart
            Lighting.FogEnd = oldFogEnd
            Lighting.FogColor = oldFogColor
        end
    end
})

local vibrantEffect = Lighting:FindFirstChild("VibrantEffect") or Instance.new("ColorCorrectionEffect")
vibrantEffect.Name = "VibrantEffect"
vibrantEffect.Saturation = 1
vibrantEffect.Contrast = 0.4
vibrantEffect.Brightness = 0.05
vibrantEffect.Enabled = false
vibrantEffect.Parent = Lighting

MiscTab:Toggle({
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
    end
})


local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    16, Vector2.new(Camera.ViewportSize.X - 100, 10), Color3.fromRGB(0, 255, 0), false, true, showFPS
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible =
    16, Vector2.new(Camera.ViewportSize.X - 100, 30), Color3.fromRGB(0, 255, 0), false, true, showPing
local fpsCounter, fpsLastUpdate = 0, tick()

RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end
        if showPing then
            local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            msText.Text = "Ping: " .. ping .. " ms"
            if ping <= 60 then
                msText.Color = Color3.fromRGB(0, 255, 0)
            elseif ping <= 120 then
                msText.Color = Color3.fromRGB(255, 165, 0)
            else
                msText.Color = Color3.fromRGB(255, 0, 0)
                msText.Text = "Ew Wifi Ping: " .. ping .. " ms"
            end
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
    Callback = function(val)
        showFPS = val
        fpsText.Visible = val
    end
})

MiscTab:Toggle({
    Title = "Show Ping (ms)",
    Default = true,
    Callback = function(val)
        showPing = val
        msText.Visible = val
    end
})

MiscTab:Button({
    Title = "FPS Boost (Fixed)",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 2
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
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
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        print("[Boost] FPS Boost Applied")
    end
})

local List = {
    "Normal",
    "Hard",
    "VeryHard",
    "Insane",
    "Nightmare",
    "BossRush",
    "ThunderStorm",
    "Zombie",
    "Christmas",
    "Hell",
    "Astro"
    "DarkDimension"
}

VoteTab:Dropdown({ 
    Title = "Set Vote", 
    Values = List, 
    Default = normal, 
    Multi = false,
    Callback = function(value) 
        autoVoteValue = value
        game:GetService("ReplicatedStorage"):WaitForChild("Vote"):FireServer(value)
    end 
})

VoteTab:Toggle({
    Title = "Auto Vote",
    Default = false,
    Callback = function(enabled)
        autoVoteEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoVoteEnabled do
                    game:GetService("ReplicatedStorage"):WaitForChild("Vote"):FireServer(autoVoteValue)
                    task.wait(1)
                end
            end)
        end
    end
})

local autoSkillEnabled = false
local Skillnormal = {"E"} -- ค่าเริ่มต้น
local autoSkillValues = Skillnormal
local Lists = {"Z","X","C","G","T","Y","U","E","R","F"}

SkillTab:Dropdown({ 
    Title = "Set Skill Auto", 
    Values = Lists, 
    Default = Skillnormal, 
    Multi = true, -- ✅ เลือกหลายปุ่มได้
    Callback = function(values) 
        autoSkillValues = values -- เก็บค่าที่เลือก (เป็นตาราง)
    end 
})

SkillTab:Toggle({
    Title = "Auto Skill",
    Default = false,
    Callback = function(enabled)
        autoSkillEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoSkillEnabled do
                    pcall(function()
                        local VirtualInputManager = game:GetService("VirtualInputManager")

                        -- ✅ วนตามลำดับที่เลือกไว้
                        for _, key in ipairs(autoSkillValues) do
                            -- กด
                            VirtualInputManager:SendKeyEvent(true, key, false, game)
                            task.wait(0.05)
                            -- ปล่อย
                            VirtualInputManager:SendKeyEvent(false, key, false, game)

                            -- หน่วงเวลานิดหน่อยก่อนกดปุ่มต่อไป
                            task.wait(0.3)
                        end
                    end)
                    task.wait(0.5) -- เวลาหน่วงก่อนเริ่มรอบใหม่
                end
            end)
        end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local Items = {"Clock Spider", "Transmitter", "FlashDrive", "Astro Samples"}
local ItemsNormal = "Clock Spider"
local ItemsValue = {ItemsNormal} 
local autoCollectEnabled = false

local function teleportToTarget(targetPos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(targetPos)
end

CollectTab:Dropdown({ 
    Title = "Set Collect Items", 
    Values = Items,  
    Default = ItemsNormal,  
    Multi = true, 
    Callback = function(value) 
        ItemsValue = value 
    end 
})

CollectTab:Toggle({
    Title = "Auto Collect", 
    Default = false,
    Callback = function(enabled)
        autoCollectEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoCollectEnabled do
                    pcall(function()
                        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            for _, obj in pairs(workspace:GetDescendants()) do
                                if (obj:IsA("Model") or obj:IsA("Part")) and table.find(ItemsValue, obj.Name) then
                                    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
                                    if prompt then
                                        local originalPos = hrp.Position
                                        teleportToTarget(prompt.Parent.Position + Vector3.new(0,3,0))
                                        task.wait(0.1)
                                        prompt:InputHoldBegin()
                                        task.wait(0.05)
                                        prompt:InputHoldEnd()
                                        task.wait(0.2)
                                        teleportToTarget(originalPos)
                                        task.wait(0.1)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

print("[DYHUB] DYHUB - Loaded! (Console Show)")









