-- skill
local function destroyObjectCache(parent)
    for _, obj in pairs(parent:GetChildren()) do
        if obj.Name == "ObjectCache" then
            obj:Destroy()
        else
            destroyObjectCache(obj)
        end
    end
end

destroyObjectCache(workspace.Terrain)

-- Hunty.lua (ปรับปรุงโดย Assistant)
local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ByteNetReliable = ReplicatedStorage:WaitForChild("ByteNetReliable")
local CoreGui = game:GetService("CoreGui")
local zombiesFolder = workspace:WaitForChild("Entities"):WaitForChild("Zombie")
local UIS = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local noclipTouchedParts = {}

-- ตั้งค่าเริ่มต้นเป็น false ทุกตัว
local AutoClearToggle = {Value = false}
local AutoAttackToggle = {Value = false}
local AutoSwapToggle = {Value = false}
local AutoCollectToggle = {Value = false}
local AutoSkillsToggle = {Value = false}
local UsePerkToggle = {Value = false}
local BringMobsToggle = {Value = false}
local AutoReplayToggle = {Value = false}
local offset = Vector3.new(1, 6, 0)

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    table.clear(noclipTouchedParts)
end)

local function enableNoclip(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            noclipTouchedParts[part] = true
            part.CanCollide = false
        end
    end
end

local function disableNoclip(character)
    for part in pairs(noclipTouchedParts) do
        if part and part.Parent then
            part.CanCollide = true
        end
    end
    table.clear(noclipTouchedParts)

    if hrp then
        local bv = hrp:FindFirstChild("Lock")
        if bv then bv:Destroy() end
    end
end

local function moveToTarget(targetHRP, offsetVec)
    if not (hrp and hrp.Parent) then return end
    if not (targetHRP and targetHRP.Parent) then return end

    offsetVec = offsetVec or Vector3.new(0,5,0)
    local speed = 100

    local bv = hrp:FindFirstChild("Lock")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "Lock"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = hrp
    end

    repeat
        if not (targetHRP and targetHRP.Parent) then break end
        if not (hrp and hrp.Parent) then break end
        local targetPos = targetHRP.Position + offsetVec
        local dir = targetPos - hrp.Position
        if dir.Magnitude > 0.5 then
            bv.Velocity = dir.Unit * speed
        else
            bv.Velocity = Vector3.zero
        end
        enableNoclip(char)
        RunService.Heartbeat:Wait()
    until not (targetHRP and targetHRP.Parent) or (hrp.Position - targetHRP.Position - offsetVec).Magnitude <= 0.5

    if bv and bv.Parent then
        bv.Velocity = Vector3.zero
    end
end

-- โหลด UI ใหม่ (x2zu Framework)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local FreeVersion = "Free Version"
local PremiumVersion = "Premium Version"

local function checkVersion(playerName)
    local url = "https://raw.githubusercontent.com/mabdu21/2askdkn21h3u21ddaa/refs/heads/main/Main/Premium/listpremium.lua"

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        return FreeVersion
    end

    local premiumData
    local func, err = loadstring(response)
    if func then
        premiumData = func()
    else
        return FreeVersion
    end

    if premiumData[playerName] then
        return PremiumVersion
    else
        return FreeVersion
    end
end

local player = Players.LocalPlayer
local userversion = checkVersion(player.Name)

local Window = Library:Window({
    Title = "DYHUB",
    Desc = "Hunty Zombies | " .. userversion,
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "DYHUB"
    }
})

-- Tab หลัก
local InfoTab = Window:Tab({Title = "Main", Icon = "rocket"})
local MainDivider = Window:Divider()
local MainTab = Window:Tab({Title = "Main", Icon = "rocket"})
local PlayerTab = Window:Tab({Title = "Player", Icon = "user"})
local EspTab = Window:Tab({Title = "ESP", Icon = "eye"})
EspTab:Section({Title = "Feature Esp"})

MainTab:Section({Title = "Clear Wave"})
MainTab:Toggle({
    Title = "Auto Farm",
    Value = false,
    Callback = function(state)
        AutoClearToggle.Value = state
        if state then
            task.spawn(function()
                enableNoclip(char)
                local spinAngle = 0

                while AutoClearToggle.Value do
                    if not (char and char.Parent and hrp and hrp.Parent) then
                        task.wait(0.5)
                        continue
                    end

                    -- เลือก Zombie เป้าหมายใกล้ที่สุด
                    local targetZombie = nil
                    for _, z in ipairs(zombiesFolder:GetChildren()) do
                        local zHRP = z:FindFirstChild("HumanoidRootPart")
                        if zHRP and zHRP.Position.Y > -20 then
                            targetZombie = zHRP
                            break
                        end
                    end

                    if targetZombie and targetZombie.Parent then
                        -- คำนวณ offset ตามตำแหน่งที่เลือก
                        local offset = Vector3.new(0, 6, 0)
                        if getgenv().setPositionMode then
                            if getgenv().setPositionMode == "Above" then
                                offset = Vector3.new(0, getgenv().DistanceValue or 3, 0)
                            elseif getgenv().setPositionMode == "Under" then
                                offset = Vector3.new(0, -(getgenv().DistanceValue or 3), 0)
                            elseif getgenv().setPositionMode == "Front" then
                                offset = targetZombie.CFrame.LookVector * (getgenv().DistanceValue or 3)
                            elseif getgenv().setPositionMode == "Back" then
                                offset = -targetZombie.CFrame.LookVector * (getgenv().DistanceValue or 3)
                            elseif getgenv().setPositionMode == "Spin" then
                                spinAngle += task.wait() * 2
                                local radius = getgenv().DistanceValue or 3
                                offset = Vector3.new(math.cos(spinAngle) * radius, 0, math.sin(spinAngle) * radius)
                            end
                        end

                        -- ล็อกตัวละครให้นิ่ง
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.Velocity = Vector3.zero
                        hrp.RotVelocity = Vector3.zero
                        hrp.CFrame = CFrame.new(targetZombie.Position + offset)

                    else
                        -- กรณีไม่มี Zombie → ตรวจ generator / boss / objective
                        local handled = false

                        -- BossRoom generator
                        local bossRoom = workspace:FindFirstChild("Sewers") 
                                         and workspace.Sewers:FindFirstChild("Rooms")
                                         and workspace.Sewers.Rooms:FindFirstChild("BossRoom")
                        if bossRoom and bossRoom:FindFirstChild("generator") and bossRoom.generator:FindFirstChild("gen") then
                            local gen = bossRoom.generator.gen
                            local pom = gen:FindFirstChild("pom")
                            if pom and pom:IsA("ProximityPrompt") and pom.Enabled then
                                hrp.CFrame = CFrame.new(gen.Position + Vector3.new(0,3,0))
                                task.wait(0.5)
                                pcall(function() fireproximityprompt(pom) end)
                                task.wait(1)
                                handled = true
                            end
                        end

                        -- School Rooftop radio → heli
                        local school = workspace:FindFirstChild("School")
                        if school and school:FindFirstChild("Rooms") then
                            local rooftop = school.Rooms:FindFirstChild("RooftopBoss")
                            if rooftop and rooftop:FindFirstChild("RadioObjective") then
                                local radioPrompt = rooftop.RadioObjective:FindFirstChildOfClass("ProximityPrompt")
                                if radioPrompt and radioPrompt.Enabled then
                                    hrp.CFrame = CFrame.new(rooftop.RadioObjective.Position + Vector3.new(0,3,0))
                                    task.wait(0.5)
                                    pcall(function() fireproximityprompt(radioPrompt) end)
                                    task.wait(10)

                                    local guiLabel = player.PlayerGui 
                                        and player.PlayerGui.MainScreen 
                                        and player.PlayerGui.MainScreen.ObjectiveDisplay
                                        and player.PlayerGui.MainScreen.ObjectiveDisplay.ObjectiveElement
                                        and player.PlayerGui.MainScreen.ObjectiveDisplay.ObjectiveElement.List
                                        and player.PlayerGui.MainScreen.ObjectiveDisplay.ObjectiveElement.List.Value
                                        and player.PlayerGui.MainScreen.ObjectiveDisplay.ObjectiveElement.List.Value.Label

                                    local timeout = 15
                                    local startTime = os.clock()
                                    repeat
                                        task.wait(1)
                                    until (guiLabel and guiLabel.ContentText == "0") or (os.clock() - startTime > timeout)

                                    local heliPrompt = rooftop:FindFirstChild("HeliObjective") 
                                                        and rooftop.HeliObjective:FindFirstChildOfClass("ProximityPrompt")
                                    if heliPrompt and heliPrompt.Enabled then
                                        hrp.CFrame = CFrame.new(rooftop.HeliObjective.Position + Vector3.new(0,3,0))
                                        task.wait(0.5)
                                        pcall(function() fireproximityprompt(heliPrompt) end)
                                    end
                                    handled = true
                                end
                            end
                        end

                        if not handled then
                            task.wait(1)
                        end
                    end
                end
                disableNoclip(char)
            end)
        else
            disableNoclip(char)
        end
    end
})

-- Dropdown & Slider สำหรับเลือกตำแหน่งและระยะ
MainTab:Dropdown({
    Title = "Set Position",
    Values = { "Spin", "Above", "Back", "Under", "Front" },
    Default = getgenv().setPositionMode or "Spin",
    Multi = false,
    Callback = function(value) getgenv().setPositionMode = value end
})

MainTab:Slider({
    Title = "Set Distance to NPC",
    Value = { Min = 0, Max = 30, Default = getgenv().DistanceValue or 5 },
    Step = 1,
    Callback = function(val) getgenv().DistanceValue = val end
})

-- Auto Attack
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local AutoAttackToggle = {Value = false}

local function isMobile()
    return UIS.TouchEnabled and not UIS.KeyboardEnabled
end

local function performClick()
    if isMobile() then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0,0,1,true,game,1)
            VirtualInputManager:SendMouseButtonEvent(0,0,1,false,game,1)
        end)
    else
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0,0,1,true,game,0)
            VirtualInputManager:SendMouseButtonEvent(0,0,1,false,game,0)
        end)
    end
end

local function startAutoAttack()
    task.spawn(function()
        while AutoAttackToggle.Value do
            performClick()
            task.wait(0.5)
        end
    end)
end

MainTab:Section({Title = "Farm Setting"})

MainTab:Toggle({
    Title = "Auto Attack",
    Value = false,
    Callback = function(state)
        AutoAttackToggle.Value = state
        if state then
            startAutoAttack()
        end
    end
})

-- Auto Swap Weapons
MainTab:Toggle({
    Title = "Auto Swap Weapons",
    Value = false,
    Callback = function(state)
        AutoSwapToggle.Value = state
        if state then
            task.spawn(function()
                local keys = { Enum.KeyCode.One, Enum.KeyCode.Two }
                local current = 1
                while AutoSwapToggle.Value do
                    if not (char and char.Parent) then break end
                    local key = keys[current]
                    pcall(function()
                        VirtualInputManager:SendKeyEvent(true, key, false, game)
                        VirtualInputManager:SendKeyEvent(false, key, false, game)
                    end)
                    current = current == 1 and 2 or 1
                    task.wait(2)
                end
            end)
        end
    end
})

-- Auto Collect
MainTab:Toggle({
    Title = "Auto Collect",
    Value = false,
    Callback = function(state)
        AutoCollectToggle.Value = state
        if state then
            task.spawn(function()
                -- try get dropitems folder safely
                local success, DropItemsFolder = pcall(function()
                    return workspace:WaitForChild("DropItems", 5)
                end)
                if not success or not DropItemsFolder then
                    task.wait(1)
                end
                while AutoCollectToggle.Value do
                    if hrp and hrp.Parent and DropItemsFolder then
                        for _, item in ipairs(DropItemsFolder:GetChildren()) do
                            local targetPos
                            if item:IsA("Model") and item.PrimaryPart then
                                targetPos = item.PrimaryPart.Position
                            elseif item:IsA("BasePart") then
                                targetPos = item.Position
                            end
                            if targetPos then
                                -- Move player near item
                                pcall(function()
                                    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                                end)
                                task.wait(0.1)
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

local Extra = Window:Tab({Title = "Auto", Icon = "crown"})
Extra:Section({Title = "Feature Auto"})

Extra:Toggle({
    Title = "Auto Skill",
    Value = false,
    Callback = function(state)
        AutoSkillsToggle.Value = state
        if state then
            task.spawn(function()
                local keys = { Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.G, Enum.KeyCode.E }
                while AutoSkillsToggle.Value do
                    if not (char and char.Parent) then break end
                    for _, key in ipairs(keys) do
                        pcall(function()
                            VirtualInputManager:SendKeyEvent(true, key, false, game)
                            VirtualInputManager:SendKeyEvent(false, key, false, game)
                        end)
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end
})

Extra:Toggle({
    Title = "Auto Perk",
    Value = false,
    Callback = function(state)
        UsePerkToggle.Value = state
        if state then
            task.spawn(function()
                local args = { buffer.fromstring("\f") }
                while UsePerkToggle.Value do
                    if not (char and char.Parent) then break end
                    pcall(function()
                        ByteNetReliable:FireServer(unpack(args))
                    end)
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end
})

Extra:Section({Title = "Feature Object"})

Extra2:Toggle({
    Title = "Auto Open Door",
    Value = false,
    Callback = function(state)
        BringMobsToggle.Value = state
        if state then
            task.spawn(function()
                while BringMobsToggle.Value do
                    if not (char and char.Parent) then break end
                    local sewers = workspace:FindFirstChild("Sewers")
                    if sewers and sewers:FindFirstChild("Doors") then
                        for _, door in ipairs(sewers.Doors:GetChildren()) do
                            pcall(function()
                                local args = { buffer.fromstring("\b\001"), {door} }
                                ByteNetReliable:FireServer(unpack(args))
                            end)
                            task.wait(0.1)
                        end
                    end
                    local school = workspace:FindFirstChild("School")
                    if school and school:FindFirstChild("Doors") then
                        for _, door in ipairs(school.Doors:GetChildren()) do
                            pcall(function()
                                local args = { buffer.fromstring("\b\001"), {door} }
                                ByteNetReliable:FireServer(unpack(args))
                            end)
                            task.wait(0.1)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- Auto Replay
Extra:Toggle({
    Title = "Auto Replay",
    Value = false,
    Callback = function(state)
        AutoReplayToggle.Value = state
        if state then
            task.spawn(function()
                local success, voteReplay = pcall(function()
                    return ReplicatedStorage:WaitForChild("external", 5):WaitForChild("Packets", 5):WaitForChild("voteReplay", 5)
      
          end)
                if not success or not voteReplay then
                    task.wait(1)
                end
                while AutoReplayToggle.Value do
                    if voteReplay then
                        pcall(function() voteReplay:FireServer() end)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})
