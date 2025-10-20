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
    local url = "https://raw.githubusercontent.com/dyumra/Whitelist/refs/heads/main/DYHUB-PREMIUM.lua"

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

PlayerTab:Section({ Title = "Player" })

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

PlayerTab:Section({ Title = "Player Misc"})

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


local MiscTab = Window:Tab({Title = "Misc", Icon = "cog"})
MiscTab:Section({ Title = "World Visual" })

local Lighting = game:GetService("Lighting")
local oldAmbient = Lighting.Ambient
local oldBrightness = Lighting.Brightness
local oldClockTime = Lighting.ClockTime
local oldFogStart = Lighting.FogStart
local oldFogEnd = Lighting.FogEnd
local oldFogColor = Lighting.FogColor

local fullBrightConnection
local noFogConnection

MiscTab:Toggle({
    Title = "FullBright",
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

-- ESP Module Upgraded
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Default Global Settings
getgenv().ESPType = getgenv().ESPType or "Highlight"
getgenv().ESPEnabled = getgenv().ESPEnabled or false
getgenv().ESPShowName = getgenv().ESPShowName or true
getgenv().ESPShowDistance = getgenv().ESPShowDistance or true
getgenv().ESPDistance = getgenv().ESPDistance or 50
getgenv().ESPName = getgenv().ESPName or "Zombie"

-- ESP Tab

-- ประเภท ESP
EspTab:Dropdown({
    Title = "ESP Type",
    Values = { "Highlight", "BoxHandleAdornment" },
    Default = getgenv().ESPType or "Highlight",
    Multi = false,
    Callback = function(value)
        getgenv().ESPType = value
    end
})

-- เปิด / ปิด ESP
EspTab:Toggle({
    Title = "Enable ESP",
    Default = getgenv().ESPEnabled or false,
    Callback = function(value)
        getgenv().ESPEnabled = value
    end
})

EspTab:Section({Title = "Settings ESP", Icon = "settings"})

-- แสดงชื่อ NPC
EspTab:Toggle({
    Title = "Show Name",
    Default = getgenv().ESPShowName or true,
    Callback = function(value)
        getgenv().ESPShowName = value
    end
})

-- แสดงระยะห่าง NPC
EspTab:Toggle({
    Title = "Show Distance",
    Default = getgenv().ESPShowDistance or true,
    Callback = function(value)
        getgenv().ESPShowDistance = value
    end
})

-- ระยะสูงสุดที่จะแสดง ESP
EspTab:Slider({
    Title = "Max Distance",
    Value = { Min = 1, Max = 100, Default = getgenv().ESPDistance or 50 },
    Step = 1,
    Callback = function(val)
        getgenv().ESPDistance = val
    end
})

-- ESP Update Function
local function updateESP()
    if not getgenv().ESPEnabled then return end
    local entitiesFolder = workspace:FindFirstChild("Entities")
    if not entitiesFolder then return end

    for _, group in ipairs(entitiesFolder:GetChildren()) do
        if group:IsA("Folder") then
            for _, npc in ipairs(group:GetChildren()) do
                local hrp = npc:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Remove old ESP if type changed
                    if getgenv().ESPType == "Highlight" and hrp:FindFirstChild("ESP_Box") then
                        hrp.ESP_Box:Destroy()
                    elseif getgenv().ESPType == "BoxHandleAdornment" and hrp:FindFirstChild("ESP_Highlight") then
                        hrp.ESP_Highlight:Destroy()
                    end

                    -- Create Highlight / Box
                    if getgenv().ESPType == "Highlight" and not hrp:FindFirstChild("ESP_Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESP_Highlight"
                        highlight.Adornee = npc
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Parent = hrp
                    elseif getgenv().ESPType == "BoxHandleAdornment" and not hrp:FindFirstChild("ESP_Box") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "ESP_Box"
                        box.Adornee = hrp
                        box.Size = hrp.Size or Vector3.new(2,2,1)
                        box.Color3 = Color3.fromRGB(255, 0, 0)
                        box.AlwaysOnTop = true
                        box.ZIndex = 5
                        box.Parent = hrp
                    end

                    -- Name + Distance
                    if getgenv().ESPShowName then
                        local bill = hrp:FindFirstChild("ESP_NameTag")
                        if not bill then
                            bill = Instance.new("BillboardGui")
                            bill.Name = "ESP_NameTag"
                            bill.Adornee = hrp
                            bill.Size = UDim2.new(0, 120, 0, 50)
                            bill.AlwaysOnTop = true
                            bill.StudsOffset = Vector3.new(0,3,0)
                            bill.Parent = hrp

                            local text = Instance.new("TextLabel")
                            text.Size = UDim2.new(1,0,1,0)
                            text.BackgroundTransparency = 1
                            text.TextColor3 = Color3.fromRGB(255,0,0)
                            text.TextStrokeTransparency = 0
                            text.TextScaled = true
                            text.Text = getgenv().ESPName
                            text.Parent = bill
                        end

                        local label = bill:FindFirstChildOfClass("TextLabel")
                        if label and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                            if dist <= getgenv().ESPDistance then
                                if getgenv().ESPShowDistance then
                                    label.Text = getgenv().ESPName .. " - [" .. math.floor(dist) .. "m]"
                                else
                                    label.Text = getgenv().ESPName
                                end
                                label.Visible = true
                            else
                                label.Visible = false
                            end
                        end
                    else
                        if hrp:FindFirstChild("ESP_NameTag") then
                            hrp.ESP_NameTag:Destroy()
                        end
                    end
                end
            end
        end
    end
end

-- Cleanup function for removed NPCs
local function cleanESP()
    local entitiesFolder = workspace:FindFirstChild("Entities")
    if not entitiesFolder then return end
    for _, group in ipairs(entitiesFolder:GetChildren()) do
        if group:IsA("Folder") then
            for _, npc in ipairs(group:GetChildren()) do
                if not npc or not npc.Parent then
                    local hrp = npc and npc:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, child in ipairs(hrp:GetChildren()) do
                            if child.Name:find("ESP_") then
                                child:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Connect to RenderStepped
RunService.RenderStepped:Connect(function()
    if getgenv().ESPEnabled then
        updateESP()
        cleanESP()
    end
end)

Info = InfoTab

if not ui then ui = {} end
if not ui.Creator then ui.Creator = {} end

-- Define the Request function that mimics ui.Creator.Request
ui.Creator.Request = function(requestData)
    local HttpService = game:GetService("HttpService")
    
    -- Try different HTTP methods
    local success, result = pcall(function()
        if HttpService.RequestAsync then
            -- Method 1: Use RequestAsync if available
            local response = HttpService:RequestAsync({
                Url = requestData.Url,
                Method = requestData.Method or "GET",
                Headers = requestData.Headers or {}
            })
            return {
                Body = response.Body,
                StatusCode = response.StatusCode,
                Success = response.Success
            }
        else
            -- Method 2: Fallback to GetAsync
            local body = HttpService:GetAsync(requestData.Url)
            return {
                Body = body,
                StatusCode = 200,
                Success = true
            }
        end
    end)
    
    if success then
        return result
    else
        error("HTTP Request failed: " .. tostring(result))
    end
end

-- Remove this line completely: Info = InfoTab
-- The Info variable is already correctly set above

local InviteCode = "jWNDPNMmyB"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local function LoadDiscordInfo()
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
            Url = DiscordAPI,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "RobloxBot/1.0",
                ["Accept"] = "application/json"
            }
        }).Body)
    end)

    if success and result and result.guild then
        local DiscordInfo = Info:Paragraph({
            Title = result.guild.name,
            Desc = ' <font color="#52525b">●</font> Member Count : ' .. tostring(result.approximate_member_count) ..
                '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(result.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=1024",
            ImageSize = 42,
        })

        Info:Button({
            Title = "Update Info",
            Callback = function()
                local updated, updatedResult = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
                        Url = DiscordAPI,
                        Method = "GET",
                    }).Body)
                end)

                if updated and updatedResult and updatedResult.guild then
                    DiscordInfo:SetDesc(
                        ' <font color="#52525b">●</font> Member Count : ' .. tostring(updatedResult.approximate_member_count) ..
                        '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(updatedResult.approximate_presence_count)
                    )
                    
                    WindUI:Notify({
                        Title = "Discord Info Updated",
                        Content = "Successfully refreshed Discord statistics",
                        Duration = 2,
                        Icon = "refresh-cw",
                    })
                else
                    WindUI:Notify({
                        Title = "Update Failed",
                        Content = "Could not refresh Discord info",
                        Duration = 3,
                        Icon = "alert-triangle",
                    })
                end
            end
        })

        Info:Button({
            Title = "Copy Discord Invite",
            Callback = function()
                setclipboard("https://discord.gg/" .. InviteCode)
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Discord invite copied to clipboard",
                    Duration = 2,
                    Icon = "clipboard-check",
                })
            end
        })
    else
        Info:Paragraph({
            Title = "Error fetching Discord Info",
            Desc = "Unable to load Discord information. Check your internet connection.",
            Image = "triangle-alert",
            ImageSize = 26,
            Color = "Red",
        })
        print("Discord API Error:", result) -- Debug print
    end
end

LoadDiscordInfo()

Info:Divider()
Info:Section({ 
    Title = "DYHUB Information",
    TextXAlignment = "Center",
    TextSize = 17,
})
Info:Divider()

local Owner = Info:Paragraph({
    Title = "Main Owner",
    Desc = "@dyumraisgoodguy#8888",
    Image = "rbxassetid://119789418015420",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
})

local Social = Info:Paragraph({
    Title = "Social",
    Desc = "Copy link social media for follow!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://guns.lol/DYHUB")
                print("Copied social media link to clipboard!")
            end,
        }
    }
})

local Discord = Info:Paragraph({
    Title = "Discord",
    Desc = "Join our discord for more scripts!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://discord.gg/jWNDPNMmyB")
                print("Copied discord link to clipboard!")
            end,
        }
    }
})
