-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "DYHUB | Guts & Blackpowder",
    Icon = 104487529937663,
    LoadingTitle = "DYHUB Loaded! - G&B",
    LoadingSubtitle = "Join our community at dsc.gg/dyhub",
    ShowText = "DYHUB",
    Theme = "Dark Blue",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DYHUB",
        FileName = "DYHUB_GAB1"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Verification",
        Subtitle = "DYHUB Verification",
        Note = "Type 'No' to verify",
        FileName = "DYHUB_Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"No"}
    }
})

-- Create Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local EspTab = Window:CreateTab("ESP", 4483362458)
local AutoTab = Window:CreateTab("Auto", 4483362458)
local AntiTab = Window:CreateTab("Anti", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Notification
Rayfield:Notify({
    Title = "Guts & Blackpowder",
    Content = "Version: 2.0 - Upgraded by DYHUB",
    Duration = 3.5,
    Image = 104487529937663,
})

-- Variables
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
local Humanoid = character:WaitForChild("Humanoid", 5)

-- Handle Character Respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    character = newChar
    HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    Humanoid = character:WaitForChild("Humanoid", 5)
end)

-- Utility Functions
local function getMeleeTool()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") and item:FindFirstChild("RemoteEvent") then
            return item
        end
    end
    return nil
end

local function getClosestZombie(maxDistance)
    local folder = Workspace:FindFirstChild("Zombies")
    if not folder then return nil end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closestZombie, shortestDist = nil, maxDistance or 9999
    for _, zombie in ipairs(folder:GetChildren()) do
        local hum = zombie:FindFirstChildOfClass("Humanoid")
        local rootPart = zombie:FindFirstChild("HumanoidRootPart") or zombie:FindFirstChild("Head")
        if hum and rootPart and hum.Health > 0 then
            local dist = (rootPart.Position - root.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                closestZombie = zombie
            end
        end
    end
    return closestZombie
end

-- Main Tab: Combat Features
local CombatSection = MainTab:CreateSection("Combat")

-- Kill Aura
local killAuraEnabled = false
MainTab:CreateToggle({
    Name = "Kill Aura (Smart Focus)",
    CurrentValue = false,
    Callback = function(value)
        killAuraEnabled = value
    end
})

task.spawn(function()
    while true do
        task.wait(0.01)
        if killAuraEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = getMeleeTool()
                if char and tool then
                    local target = getClosestZombie(19)
                    if target then
                        local rootPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
                        if rootPart then
                            local distance = (rootPart.Position - char.HumanoidRootPart.Position).Magnitude
                            if distance <= 18 then
                                tool.RemoteEvent:FireServer("Swing", "Thrust")
                                tool.RemoteEvent:FireServer(
                                    "HitZombie",
                                    target,
                                    rootPart.Position,
                                    true,
                                    Vector3.new(0, 15, 0),
                                    "Head",
                                    Vector3.new(0, 1, 0)
                                )
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Headshot
local headshotEnabled = false
MainTab:CreateToggle({
    Name = "Auto Headshot",
    CurrentValue = false,
    Callback = function(value)
        headshotEnabled = value
        if headshotEnabled then
            local modules = {
                Workspace:FindFirstChild("Flintlock") and Workspace.Flintlock:FindFirstChild("BayonetHitCheck"),
                Workspace:FindFirstChild("MeleeBase") and Workspace.MeleeBase:FindFirstChild("MeleeHitCheck")
            }
            for _, module in pairs(modules) do
                if module and module:IsA("ModuleScript") then
                    local old = require(module)
                    old.Check = function(_, target)
                        local char = target.Parent
                        local head = char and char:FindFirstChild("Head")
                        return head or target
                    end
                end
            end
        end
    end
})

-- Bomber Aimbot
local bomberAimbotEnabled = false
local bomberAimbotDistance = 60
local bomberSmoothing = 0.18
local bomberHoldToAim = false
local rightHeld = false

MainTab:CreateToggle({
    Name = "Bomber Aimbot",
    CurrentValue = false,
    Callback = function(val) bomberAimbotEnabled = val end
})

MainTab:CreateSlider({
    Name = "Bomber Aim Distance",
    Range = {20, 200},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = bomberAimbotDistance,
    Callback = function(val) bomberAimbotDistance = val end
})

MainTab:CreateSlider({
    Name = "Bomber Aim Smoothing",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = bomberSmoothing,
    Callback = function(val) bomberSmoothing = val end
})

MainTab:CreateToggle({
    Name = "Hold Right Mouse To Aim",
    CurrentValue = false,
    Callback = function(val) bomberHoldToAim = val end
})

UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then rightHeld = true end
end)

UserInputService.InputEnded:Connect(function(inp, gpe)
    if gpe then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then rightHeld = false end
end)

local function getClosestTorchTarget(maxDist)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local bestTarget, bestDist = nil, maxDist + 0.0001
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            if obj:FindFirstChild("Torch", true) then
                local targetPart = obj:FindFirstChild("Head") or obj:FindFirstChild("HumanoidRootPart")
                if targetPart and targetPart.Position then
                    local d = (root.Position - targetPart.Position).Magnitude
                    if d <= maxDist and d < bestDist then
                        bestDist = d
                        bestTarget = targetPart
                    end
                end
            end
        end
    end
    return bestTarget
end

local aimConn
aimConn = RunService.RenderStepped:Connect(function(dt)
    if not bomberAimbotEnabled or (bomberHoldToAim and not rightHeld) then return end
    pcall(function()
        local targetPart = getClosestTorchTarget(bomberAimbotDistance)
        if targetPart then
            local camCFrame = Camera.CFrame
            local camPos = camCFrame.Position
            local targetPos = targetPart.Position
            local desiredCFrame = CFrame.new(camPos, targetPos)
            local alpha = math.clamp(bomberSmoothing, 0, 1)
            Camera.CFrame = camCFrame:Lerp(desiredCFrame, alpha)
        end
    end)
end)

-- Auto Tab: Auto Farm
local AutoFarmSection = AutoTab:CreateSection("Auto Farm")

local killAuraEnabled2 = false
local autoFarmConnection
local ESCAPE_DISTANCE = 8
local ESCAPE_SPEED = 1
local WARP_OFFSET = 3
local ATTACK_DISTANCE = 16

AutoTab:CreateToggle({
    Name = "Auto Farm (AFK)",
    CurrentValue = false,
    Callback = function(value)
        killAuraEnabled2 = value
        if value then
            if autoFarmConnection then return end
            autoFarmConnection = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    HumanoidRootPart = char:FindFirstChild("HumanoidRootPart")
                    if not HumanoidRootPart then return end

                    local tool = getMeleeTool()
                    local zombiesFolder = Workspace:FindFirstChild("Zombies")
                    if not zombiesFolder then return end

                    local closestZombie, shortestDist = nil, 9999
                    for _, zombie in ipairs(zombiesFolder:GetChildren()) do
                        local hum = zombie:FindFirstChildOfClass("Humanoid")
                        local root = zombie:FindFirstChild("HumanoidRootPart") or zombie:FindFirstChild("Head")
                        if hum and root and hum.Health > 0 then
                            local dist = (HumanoidRootPart.Position - root.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestZombie = root
                            end
                        end
                    end

                    if closestZombie then
                        local dist = (HumanoidRootPart.Position - closestZombie.Position).Magnitude
                        local forward = (closestZombie.Position - HumanoidRootPart.Position).Unit
                        HumanoidRootPart.CFrame = CFrame.new(closestZombie.Position - forward * WARP_OFFSET, closestZombie.Position)

                        if dist < ESCAPE_DISTANCE then
                            local escapeDir = (HumanoidRootPart.Position - closestZombie.Position).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + escapeDir * ESCAPE_SPEED
                        end

                        if tool and dist <= ATTACK_DISTANCE then
                            local event = tool:FindFirstChild("RemoteEvent")
                            if event then
                                event:FireServer("Swing", "Thrust")
                                event:FireServer("HitZombie", closestZombie.Parent, closestZombie.Position, true, Vector3.new(0, 15, 0), "Head", Vector3.new(0, 1, 0))
                            end
                        end
                    end
                end)
            end)
        else
            if autoFarmConnection then
                autoFarmConnection:Disconnect()
                autoFarmConnection = nil
            end
        end
    end
})

-- Anti Tab: Anti Mobs & Boss
local AntiMobSection = AntiTab:CreateSection("Anti Mobs")

local escapeLoopDeer
AntiTab:CreateToggle({
    Name = "Anti Zombie (All)",
    CurrentValue = false,
    Callback = function(value)
        if value then
            escapeLoopDeer = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    HumanoidRootPart = char:FindFirstChild("HumanoidRootPart")
                    if not HumanoidRootPart then return end

                    local zombiesFolder = Workspace:FindFirstChild("Zombies")
                    if not zombiesFolder then return end

                    local closestZombie, shortestDist = nil, 15
                    for _, deer in ipairs(zombiesFolder:GetChildren()) do
                        local hum = deer:FindFirstChildOfClass("Humanoid")
                        local root = deer:FindFirstChild("HumanoidRootPart") or deer:FindFirstChild("Head")
                        if hum and root and hum.Health > 0 then
                            local distance = (HumanoidRootPart.Position - root.Position).Magnitude
                            if distance < shortestDist then
                                shortestDist = distance
                                closestZombie = root
                            end
                        end
                    end

                    if closestZombie then
                        local direction = (HumanoidRootPart.Position - closestZombie.Position).Unit
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1
                    end
                end)
            end)
        else
            if escapeLoopDeer then
                escapeLoopDeer:Disconnect()
                escapeLoopDeer = nil
            end
        end
    end
})

local AntiBossSection = AntiTab:CreateSection("Anti Boss")

local escapeLoopBoss
local boss = Workspace:WaitForChild("Sleepy Hollow", 5) and Workspace.Sleepy Hollow.Modes.Boss:WaitForChild("HeadlessHorsemanBoss", 5) and Workspace.Sleepy Hollow.Modes.Boss.HeadlessHorsemanBoss:WaitForChild("HeadlessHorseman", 5)

AntiTab:CreateToggle({
    Name = "Anti Headless Horseman (Escape)",
    CurrentValue = false,
    Callback = function(value)
        if value then
            escapeLoopBoss = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    HumanoidRootPart = char:FindFirstChild("HumanoidRootPart")
                    if not HumanoidRootPart then return end

                    if boss and boss:FindFirstChild("HumanoidRootPart") then
                        local bossRoot = boss.HumanoidRootPart
                        local distance = (HumanoidRootPart.Position - bossRoot.Position).Magnitude
                        if distance < 20 then
                            local direction = (HumanoidRootPart.Position - bossRoot.Position).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 2
                        end
                    end
                end)
            end)
        else
            if escapeLoopBoss then
                escapeLoopBoss:Disconnect()
                escapeLoopBoss = nil
            end
        end
    end
})

-- ESP Tab: Enhanced ESP
local ESPSection = EspTab:CreateSection("Zombie ESP")

local espToggles = {
    Runner = false,
    Bomber = false,
    Igniter = false,
    Cuirassier = false
}

local colors = {
    Runner = Color3.fromRGB(0, 255, 0),
    Bomber = Color3.fromRGB(0, 0, 255),
    Igniter = Color3.fromRGB(255, 255, 0),
    Cuirassier = Color3.fromRGB(255, 0, 0)
}

local MAX_DISTANCE = 40
local UPDATE_INTERVAL = 0.5

local function getZombieType(zombie)
    if not zombie then return nil end
    if zombie:FindFirstChild("Barrel") then return "Bomber"
    elseif zombie:FindFirstChild("Whale Oil Lantern") then return "Igniter"
    elseif zombie:FindFirstChild("Sword") then return "Cuirassier"
    elseif zombie:FindFirstChild("Humanoid") and zombie.Humanoid.WalkSpeed > 16 then return "Runner"
    end
    return nil
end

local function updateESP()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, zombie in pairs(Workspace:GetChildren()) do
        local hrp = zombie:FindFirstChild("HumanoidRootPart")
        if hrp then
            local distance = (root.Position - hrp.Position).Magnitude
            if distance <= MAX_DISTANCE then
                local zType = getZombieType(zombie)
                if zType and espToggles[zType] then
                    local hl = zombie:FindFirstChild("ESP_Highlight")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "ESP_Highlight"
                        hl.Adornee = zombie
                        hl.FillColor = colors[zType]
                        hl.OutlineColor = Color3.new(0, 0, 0)
                        hl.FillTransparency = 0.3
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = zombie
                    else
                        hl.FillColor = colors[zType]
                    end
                elseif zombie:FindFirstChild("ESP_Highlight") then
                    zombie.ESP_Highlight:Destroy()
                end
            elseif zombie:FindFirstChild("ESP_Highlight") then
                zombie.ESP_Highlight:Destroy()
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(UPDATE_INTERVAL)
        pcall(updateESP)
    end
end)

for zType, _ in pairs(espToggles) do
    EspTab:CreateToggle({
        Name = zType .. " ESP",
        CurrentValue = false,
        Callback = function(value)
            espToggles[zType] = value
        end
    })
end

-- Player ESP with Health and Distance
local PlayerESPSection = EspTab:CreateSection("Player ESP")

local playerEspEnabled = false
local playerEspHealth = false
local playerEspDistance = false

EspTab:CreateToggle({
    Name = "Player ESP (Team Check)",
    CurrentValue = false,
    Callback = function(value)
        playerEspEnabled = value
    end
})

EspTab:CreateToggle({
    Name = "Show Health",
    CurrentValue = false,
    Callback = function(value)
        playerEspHealth = value
    end
})

EspTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = false,
    Callback = function(value)
        playerEspDistance = value
    end
})

local function updatePlayerESP()
    if not playerEspEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                local hl = player.Character:FindFirstChild("ESP_Highlight")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "ESP_Highlight"
                    hl.Adornee = player.Character
                    hl.FillColor = player.TeamColor.Color
                    hl.OutlineColor = Color3.new(0, 0, 0)
                    hl.FillTransparency = 0.5
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = player.Character
                end

                local billboard = player.Character:FindFirstChild("ESP_Billboard")
                if not billboard then
                    billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESP_Billboard"
                    billboard.Adornee = player.Character:FindFirstChild("Head")
                    billboard.Size = UDim2.new(0, 100, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = player.Character

                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.TextColor3 = Color3.new(1, 1, 1)
                    nameLabel.Text = player.Name
                    nameLabel.TextSize = 12
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.Parent = billboard

                    local infoLabel = Instance.new("TextLabel")
                    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
                    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
                    infoLabel.BackgroundTransparency = 1
                    infoLabel.TextColor3 = Color3.new(1, 1, 1)
                    infoLabel.TextSize = 10
                    infoLabel.Font = Enum.Font.Gotham
                    infoLabel.Parent = billboard
                end

                local infoText = ""
                if playerEspHealth then
                    infoText = infoText .. "Health: " .. math.floor(hum.Health) .. "/" .. hum.MaxHealth .. "\n"
                end
                if playerEspDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
                    infoText = infoText .. "Distance: " .. math.floor(dist) .. " studs"
                end
                billboard:FindFirstChild("TextLabel", true).Text = infoText
            elseif player.Character and player.Character:FindFirstChild("ESP_Highlight") then
                player.Character.ESP_Highlight:Destroy()
                if player.Character:FindFirstChild("ESP_Billboard") then
                    player.Character.ESP_Billboard:Destroy()
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(updatePlayerESP)
    end
end)

-- Misc Tab: Additional Features
local MiscSection = MiscTab:CreateSection("Miscellaneous")

MiscTab:CreateButton({
    Name = "Chaos Hub (Mobile Compatible)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cjbbth1-crypto/Chaos-Hub-GB/refs/heads/main/Chaos%20Hub"))()
    end
})

MiscTab:CreateButton({
    Name = "Boost FPS",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mabdu21/kjandsaddjadbhahayenajhsjbdwa/refs/heads/main/Nigga.lua"))()
    end
})

-- Anti-Cheat Bypass (Enhanced)
MiscTab:CreateButton({
    Name = "Anti-Cheat Bypass V2",
    Callback = function()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "NoclipFlyGUI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 5)

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 160, 0, 180)
        Frame.Position = UDim2.new(1, -170, 0, 10)
        Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Frame.BorderSizePixel = 0
        Frame.Active = true
        Frame.Draggable = true
        Frame.Parent = ScreenGui

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.BackgroundTransparency = 1
        Title.Text = "Anti-Cheat Bypass V2"
        Title.TextColor3 = Color3.fromRGB(200, 200, 200)
        Title.TextSize = 11
        Title.Font = Enum.Font.GothamBold
        Title.Parent = Frame

        local FlyButton = Instance.new("TextButton")
        FlyButton.Size = UDim2.new(0.85, 0, 0, 28)
        FlyButton.Position = UDim2.new(0.075, 0, 0.2, 0)
        FlyButton.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
        FlyButton.Text = "Fly: OFF"
        FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        FlyButton.TextSize = 11
        FlyButton.Font = Enum.Font.GothamBold
        FlyButton.Parent = Frame

        local NoclipButton = Instance.new("TextButton")
        NoclipButton.Size = UDim2.new(0.85, 0, 0, 28)
        NoclipButton.Position = UDim2.new(0.075, 0, 0.4, 0)
        NoclipButton.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
        NoclipButton.Text = "Noclip: OFF"
        NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        NoclipButton.TextSize = 11
        NoclipButton.Font = Enum.Font.GothamBold
        NoclipButton.Parent = Frame

        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(0.85, 0, 0, 25)
        StatusLabel.Position = UDim2.new(0.075, 0, 0.82, 0)
        StatusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        StatusLabel.Text = "Status: Ready"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        StatusLabel.TextSize = 9
        StatusLabel.Font = Enum.Font.Gotham
        StatusLabel.Parent = Frame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = Frame
        for _, btn in pairs({FlyButton, NoclipButton}) do
            corner:Clone().Parent = btn
        end
        corner:Clone().Parent = StatusLabel
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(70, 70, 70)
        stroke.Thickness = 1
        stroke.Parent = Frame

        local flying, noclipping = false, false
        local speed = 50
        local control = {forward = 0, backward = 0, left = 0, right = 0, up = 0, down = 0}
        local lastPosition = HumanoidRootPart.Position
        local positionHistory = {}
        local maxHistorySize = 30
        local pullbackThreshold = 1.5
        local stuckCounter = 0
        local lastSafePosition = HumanoidRootPart.CFrame

        local function resetHumanoidState()
            if not Humanoid or not HumanoidRootPart then return end
            Humanoid.PlatformStand = false
            Humanoid.Sit = false
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
        end

        local function startFly()
            if flying or not HumanoidRootPart or Humanoid.Health <= 0 then return end
            flying = true
            FlyButton.Text = "Fly: ON"
            FlyButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            StatusLabel.Text = noclipping and "Status: Fly + Noclip" or "Status: Flying"
            StatusLabel.TextColor3 = noclipping and Color3.fromRGB(255, 255, 100) or Color3.fromRGB(100, 200, 255)

            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.P = 3000
            bodyGyro.D = 500
            bodyGyro.Parent = HumanoidRootPart

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.P = 1250
            bodyVelocity.Parent = HumanoidRootPart

            local flyConnection = RunService.Heartbeat:Connect(function(deltaTime)
                if not flying or not HumanoidRootPart or Humanoid.Health <= 0 then return end
                local camera = Workspace.CurrentCamera
                if not camera then return end

                bodyGyro.CFrame = camera.CFrame
                local moveVector = Vector3.new(
                    control.right - control.left,
                    control.up - control.down,
                    control.forward - control.backward
                )

                if moveVector.Magnitude > 0 then
                    moveVector = moveVector.Unit
                    local lookDirection = camera.CFrame.LookVector
                    local rightDirection = camera.CFrame.RightVector
                    local upDirection = Vector3.new(0, 1, 0)
                    local direction = (lookDirection * moveVector.Z + rightDirection * moveVector.X + upDirection * moveVector.Y).Unit
                    bodyVelocity.Velocity = direction * speed
                else
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end

        local function stopFly()
            if not flying then return end
            flying = false
            FlyButton.Text = "Fly: OFF"
            FlyButton.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
            StatusLabel.Text = noclipping and "Status: Noclip Active" or "Status: Ready"
            StatusLabel.TextColor3 = noclipping and Color3.fromRGB(255, 150, 255) or Color3.fromRGB(100, 255, 100)

            for _, child in pairs(HumanoidRootPart:GetChildren()) do
                if child:IsA("BodyGyro") or child:IsA("BodyVelocity") then
                    child:Destroy()
                end
            end
            resetHumanoidState()
        end

        local function startNoclip()
            if noclipping then return end
            noclipping = true
            NoclipButton.Text = "Noclip: ON"
            NoclipButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            StatusLabel.Text = flying and "Status: Fly + Noclip" or "Status: Noclip Active"
            StatusLabel.TextColor3 = flying and Color3.fromRGB(255, 255, 100) or Color3.fromRGB(255, 150, 255)

            pcall(function() HumanoidRootPart:SetNetworkOwner(LocalPlayer) end)

            local noclipConnection = RunService.Stepped:Connect(function()
                if not noclipping or not character or not HumanoidRootPart then return end
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)

            local antiPullbackConnection = RunService.Heartbeat:Connect(function()
                if not noclipping or not HumanoidRootPart then return end
                local currentPos = HumanoidRootPart.Position
                local distance = (currentPos - lastPosition).Magnitude

                if distance > pullbackThreshold then
                    HumanoidRootPart.CFrame = lastSafePosition
                    HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    pcall(function() HumanoidRootPart:SetNetworkOwner(LocalPlayer) end)
                end
                lastPosition = currentPos
                lastSafePosition = HumanoidRootPart.CFrame
            end)
        end

        local function stopNoclip()
            if not noclipping then return end
            noclipping = false
            NoclipButton.Text = "Noclip: OFF"
            NoclipButton.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
            StatusLabel.Text = flying and "Status: Flying" or "Status: Ready"
            StatusLabel.TextColor3 = flying and Color3.fromRGB(100 binge_color_0:255,200,100,255 bingefetcher_0:0,0,0,0
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            resetHumanoidState()
        end

        FlyButton.MouseButton1Click:Connect(function()
            if flying then stopFly() else startFly() end
        end)

        NoclipButton.MouseButton1Click:Connect(function()
            if noclipping then stopNoclip() else startNoclip() end
        end)

        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            local key = input.KeyCode
            if key == Enum.KeyCode.W then control.forward = 1
            elseif key == Enum.KeyCode.S then control.backward = 1
            elseif key == Enum.KeyCode.A then control.left = 1
            elseif key == Enum.KeyCode.D then control.right = 1
            elseif key == Enum.KeyCode.E then control.up = 1
            elseif key == Enum.KeyCode.Q then control.down = 1
            elseif key == Enum.KeyCode.Space then control.up = 1
        end)

        UserInputService.InputEnded:Connect(function(input, processed)
            if processed then return end
            local key = input.KeyCode
            if key == Enum.KeyCode.W then control.forward = 0
            elseif key == Enum.KeyCode.S then control.backward = 0
            elseif key == Enum.KeyCode.A then control.left = 0
            elseif key == Enum.KeyCode.D then control.right = 0
            elseif key == Enum.KeyCode.E then control.up = 0
            elseif key == Enum.KeyCode.Q then control.down = 0
            elseif key == Enum.KeyCode.Space then control.up = 0
        end)
    end
})

-- Cleanup Function
local function cleanup()
    if aimConn then aimConn:Disconnect() end
    if autoFarmConnection then autoFarmConnection:Disconnect() end
    if escapeLoopDeer then escapeLoopDeer:Disconnect() end
    if escapeLoopBoss then escapeLoopBoss:Disconnect() end
end

return {
    cleanup = cleanup
}
