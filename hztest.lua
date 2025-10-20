-- 4

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
local AutoClearToggle = {Value = false}
local AutoPerkToggle = {Value = false}
local AutoAttackToggle = {Value = false}
local AutoSwapToggle = {Value = false}
local AutoCollectToggle = {Value = false}
local AutoSkillsToggle = {Value = false}
local UsePerkToggle = {Value = false}
local BringMobsToggle = {Value = false}
local AutoReplayToggle = {Value = false}
local offset = Vector3.new(1, 6, 0)

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

local function moveToTarget(targetHRP, offset)
    if not (hrp and hrp.Parent) then return end
    if not (targetHRP and targetHRP.Parent) then return end

    offset = offset or Vector3.new(0,5,0)
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
        local targetPos = targetHRP.Position + offset
        local dir = targetPos - hrp.Position
        if dir.Magnitude > 0.5 then
            bv.Velocity = dir.Unit * speed
        else
            bv.Velocity = Vector3.zero
        end
        enableNoclip(char)
        RunService.Heartbeat:Wait()
    until not (targetHRP and targetHRP.Parent) or (hrp.Position - targetHRP.Position - offset).Magnitude <= 0.5

    bv.Velocity = Vector3.zero
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

-- สร้างหน้าต่างหลัก
local Window = Library:Window({
    Title = "DYHUB",
    Desc = "Hunty Zombies | " .. userversion,
    Icon = 104487529937663,
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
local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local MainTab = Window:Tab({Title = "Main", Icon = "star"})
local EspTab = Window:Tab({Title = "ESP", Icon = "eye"})
local Extra = Window:Tab({Title = "Auto", Icon = "crown"})

InfoTab:Section({Title = "📌 Please Read!!" })
InfoTab:Section({Title = "The script is under development and may contain bugs"})
InfoTab:Section({Title = "======================================================="})
InfoTab:Section({Title = "✅ Support Map: School, Sewers (Only)", Icon = "map" })
InfoTab:Section({Title = "======================================================="})
InfoTab:Section({Title = "🤍 Version: 2.7.9 | Reword by rhy", Icon = "star" })
InfoTab:Section({Title = "👑 Powered by dsc.gg/dyhub", Icon = "cpu" })

MainTab:Section({Title = "Feature Farm"})

MainTab:Toggle({
    Title = "Auto Farm (Fixed)",
    Desc = "Automatically kills zombies to farm resources or experience",
    Value = true,
    Callback = function(state)
        AutoClearToggle.Value = state
        if state then
            task.spawn(function()
                enableNoclip(char)
                while AutoClearToggle.Value do
                    local targetZombie = nil
                    -- หา zombie ตัวสูงกว่า -20
                    for _, z in ipairs(zombiesFolder:GetChildren()) do
                        local zHRP = z:FindFirstChild("HumanoidRootPart")
                        if zHRP and zHRP.Position.Y > -20 then
                            targetZombie = zHRP
                            break
                        end
                    end

                    if targetZombie and targetZombie.Parent then
                        moveToTarget(targetZombie, Vector3.new(0,5,0))
                        task.wait(0.1)
                    else
                        -- ถ้าไม่มี zombie → จัดการ generator / radio / heli
                        local handled = false

                        -- BossRoom generator
                        local bossRoom = workspace:FindFirstChild("Sewers") 
                                         and workspace.Sewers:FindFirstChild("Rooms") 
                                         and workspace.Sewers.Rooms:FindFirstChild("BossRoom")
                        if bossRoom and bossRoom:FindFirstChild("generator") and bossRoom.generator:FindFirstChild("gen") then
                            local gen = bossRoom.generator.gen
                            local pom = gen:FindFirstChild("pom")
                            if pom and pom:IsA("ProximityPrompt") and pom.Enabled then
                                moveToTarget(gen, Vector3.new(0,0,0))
                                task.wait(0.5)
                                fireproximityprompt(pom)
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
                                    moveToTarget(rooftop.RadioObjective, Vector3.new(0,0,0))
                                    task.wait(0.5)
                                    fireproximityprompt(radioPrompt)
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
                                    until (guiLabel and guiLabel.ContentText == "0") 
                                       or (os.clock() - startTime > timeout)

                                    local heliPrompt = rooftop:FindFirstChild("HeliObjective") 
                                                        and rooftop.HeliObjective:FindFirstChildOfClass("ProximityPrompt")
                                    if heliPrompt and heliPrompt.Enabled then
                                        moveToTarget(rooftop.HeliObjective, Vector3.new(0,0,0))
                                        task.wait(0.5)
                                        fireproximityprompt(heliPrompt)
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

MainTab:Section({Title = "Setting Exit"})

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Initial States
getgenv().AutoRadio = true
getgenv().AutoHeli = true
getgenv().AutoPower = true
getgenv().InstantInteract = true

local originalHoldDurations = {}

MainTab:Toggle({
    Title = "Auto Radio",
    Desc = "Automatically activates the radio in the game",
    Value = getgenv().AutoRadio,
    Callback = function(state)
        getgenv().AutoRadio = state
    end
})

MainTab:Toggle({
    Title = "Auto Helicopter",
    Desc = "Automatically activates the helicopter in the game",
    Value = getgenv().AutoHeli,
    Callback = function(state)
        getgenv().AutoHeli = state
    end
})

MainTab:Toggle({
    Title = "Auto Power Sewers",
    Desc = "Automatically activates power in the sewers",
    Value = getgenv().AutoPower,
    Callback = function(state)
        getgenv().AutoPower = state
    end
})

MainTab:Toggle({
    Title = "Instant Interact",
    Desc = "Instantly triggers interactions with prompts nodelay",
    Value = getgenv().InstantInteract,
    Callback = function(state)
        getgenv().InstantInteract = state
        if state then
            -- Enable instant interact
            task.spawn(function()
                while getgenv().InstantInteract do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            if originalHoldDurations[obj] == nil then
                                originalHoldDurations[obj] = obj.HoldDuration
                            end
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            -- Restore original hold durations
            for obj, value in pairs(originalHoldDurations) do
                if obj and obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = value
                end
            end
            originalHoldDurations = {}
        end
    end
})

-- Function to teleport to prompt safely and trigger it
local function activatePrompt(prompt)
    if not prompt or not prompt.Parent then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = prompt.Parent.CFrame + Vector3.new(0, 3, 0)
        fireproximityprompt(prompt)
    end
end

-- Auto tasks
spawn(function()
    while task.wait(0.2) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if getgenv().AutoRadio then
                local radioPrompt = workspace:FindFirstChild("School")
                    and workspace.School:FindFirstChild("Rooms")
                    and workspace.School.Rooms:FindFirstChild("RooftopBoss")
                    and workspace.School.Rooms.RooftopBoss:FindFirstChild("RadioObjective")
                    and workspace.School.Rooms.RooftopBoss.RadioObjective:FindFirstChild("ProximityPrompt")
                if radioPrompt then activatePrompt(radioPrompt) end
            end

            if getgenv().AutoHeli then
                local heliPrompt = workspace:FindFirstChild("School")
                    and workspace.School:FindFirstChild("Rooms")
                    and workspace.School.Rooms:FindFirstChild("RooftopBoss")
                    and workspace.School.Rooms.RooftopBoss:FindFirstChild("HeliObjective")
                    and workspace.School.Rooms.RooftopBoss.HeliObjective:FindFirstChild("ProximityPrompt")
                if heliPrompt then activatePrompt(heliPrompt) end
            end

            if getgenv().AutoPower then
                local powerPrompt = workspace:FindFirstChild("Sewers")
                    and workspace.Sewers:FindFirstChild("Rooms")
                    and workspace.Sewers.Rooms:FindFirstChild("BossRoom")
                    and workspace.Sewers.Rooms.BossRoom:FindFirstChild("generator")
                    and workspace.Sewers.Rooms.BossRoom.generator:FindFirstChild("gen")
                    and workspace.Sewers.Rooms.BossRoom.generator.gen:FindFirstChild("pom")
                if powerPrompt then activatePrompt(powerPrompt) end
            end
        end
    end
end)

MainTab:Section({Title = "Farm Setting"})

getgenv().AutoAttack = true
getgenv().AutoSwap = true
getgenv().AutoSkills = true
getgenv().AutoPerk = true

MainTab:Toggle({
    Title = "Auto Attack",
    Desc = "Enables automatic clicking for attacks",
    Value = getgenv().AutoAttack,
    Callback = function(state)
        getgenv().AutoAttack = state
        task.spawn(function()
            local player = game.Players.LocalPlayer
            local userInputService = game:GetService("UserInputService")
            local virtualUser = game:GetService("VirtualUser")

            while getgenv().AutoAttack do
                if userInputService.TouchEnabled then
                    -- Simulate touch input for mobile
                    virtualUser:Button1Down(Vector2.new(800, 500)) -- Adjust coordinates as needed
                    task.wait(0.05)
                    virtualUser:Button1Up(Vector2.new(800, 500))
                else
                    -- Simulate mouse click for PC
                    userInputService.InputBegan:Fire(Enum.UserInputType.MouseButton1, false)
                end
                task.wait(0.1) -- Adjust click speed
            end
        end)
    end
})

-- Auto Collect\
MainTab:Toggle({
    Title = "Auto Collect",
    Desc = "Automatically collects items in the ground",
    Value = true,
    Callback = function(state)
        AutoCollectToggle.Value = state
        if state then
            task.spawn(function()
                local DropItemsFolder = workspace:WaitForChild("DropItems")
                while AutoCollectToggle.Value do
                    if hrp then
                        for _, item in ipairs(DropItemsFolder:GetChildren()) do
                            local targetPos
                            if item:IsA("Model") and item.PrimaryPart then
                                targetPos = item.PrimaryPart.Position
                            elseif item:IsA("BasePart") then
                                targetPos = item.Position
                            end
                            if targetPos then
                                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
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

-- Auto Swap Weapons
MainTab:Toggle({
    Title = "Auto Swap Weapons",
    Desc = "Enables automatic weapon switching for combat",
    Value = false,
    Callback = function(state)
        getgenv().AutoSwap = state
        task.spawn(function()
            local keys = { Enum.KeyCode.One, Enum.KeyCode.Two }
            local current = 1
            while getgenv().AutoSwap do
                local key = keys[current]
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                VirtualInputManager:SendKeyEvent(false, key, false, game)
                current = current == 1 and 2 or 1
                task.wait(0.8) -- เว้นจังหวะนิดนึง
            end
        end)
    end
})

Extra:Section({Title = "Feature Auto"})

-- Auto Skills
Extra:Toggle({
    Title = "Auto Skills (Keybind)",
    Desc = "Automatically activates skills using assigned keybinds",
    Value = false,
    Callback = function(state)
        getgenv().AutoSkills = state
        task.spawn(function()
            local keys = { Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.G }
            while getgenv().AutoSkills do
                for _, key in ipairs(keys) do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                    task.wait(0.15) -- เพิ่มดีเลย์แต่ละปุ่ม
                end
                task.wait(0.5)
            end
        end)
    end
})

-- Auto Perk
Extra:Toggle({
    Title = "Auto Perk (Keybind)",
    Desc = "Automatically activates Perk using assigned keybinds",
    Value = false,
    Callback = function(state)
        getgenv().AutoPerk = state
        task.spawn(function()
            while getgenv().AutoPerk do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                task.wait(1)
            end
        end)
    end
})

Extra:Toggle({
    Title = "Auto Perk (Remote)",
    Desc = "Automatically activates Perk using assigned remote",
    Value = true,
    Callback = function(state)
        UsePerkToggle.Value = state

        if state then
            task.spawn(function()
                local args = { buffer.fromstring("\f") }
                while UsePerkToggle.Value do
                    ByteNetReliable:FireServer(unpack(args))
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end
})

Extra:Section({Title = "Object Auto"})

Extra:Toggle({
    Title = "Auto Open Door (All)",
    Desc = "Automatically opens all doors in the game",
    Value = true,
    Callback = function(state)
        BringMobsToggle.Value = state

        if state then
            task.spawn(function()
                while BringMobsToggle.Value do
                    local sewers = workspace:FindFirstChild("Sewers")
                    if sewers and sewers:FindFirstChild("Doors") then
                        for _, door in ipairs(sewers.Doors:GetChildren()) do
                            local args = { buffer.fromstring("\b\001"), {door} }
                            ByteNetReliable:FireServer(unpack(args))
                            task.wait(0.1)
                        end
                    end
                    local school = workspace:FindFirstChild("School")
                    if school and school:FindFirstChild("Doors") then
                        for _, door in ipairs(school.Doors:GetChildren()) do
                            local args = { buffer.fromstring("\b\001"), {door} }
                            ByteNetReliable:FireServer(unpack(args))
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
    Title = "Auto Replay (End)",
    Desc = "Automatically replays the game when it ends",
    Value = true,
    Callback = function(state)
        AutoReplayToggle.Value = state

        if state then
            task.spawn(function()
                local voteReplay = ReplicatedStorage:WaitForChild("external"):WaitForChild("Packets"):WaitForChild("voteReplay")
                while AutoReplayToggle.Value do
                    voteReplay:FireServer()
                    task.wait(0.5)
                end
            end)
        end
    end
})

EspTab:Section({Title = "⚠ Warning: In dev (Still Bugs)"})
EspTab:Section({Title = "Feature ESP"})
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

EspTab:Section({Title = "Setting ESP"})

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
