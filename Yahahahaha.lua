--666
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local InsertService = game:GetService("InsertService") -- Make sure InsertService is defined
local StarterGui = game:GetService("StarterGui")

local WindUI = nil
local success, errorMessage = pcall(function()
    local scriptContent = game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
    if scriptContent and scriptContent ~= "" then
        WindUI = loadstring(scriptContent)()
    else
        error("Failed to retrieve WindUI script content.")
    end
end)

if not success or not WindUI then
    warn("Failed to load WindUI: " .. (errorMessage or "Unknown error"))
    game.StarterGui:SetCore("SendNotification", {
        Title = "DYHUB Error",
        Text = "The script does not support your executor!",
        Duration = 10,
        Button1 = "OK"
    })
    return
end

local Window = WindUI:CreateWindow({
    Title = "DYHUB | Evade",
    IconThemed = true,
    Icon = "star",
    Author = "Version: 4.5",
    Size = UDim2.fromOffset(600, 400),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

--- Add UI Elements to GameTab ---
local GameTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "file-cog" })

Window:SelectTab(1)

local headlessEnabled = false
local korbloxEnabled = false

local FullbrightEnabled = false
local NoFogEnabled = false
local SuperFullBrightnessEnabled = false
local VibrantEnabled = false

local ActiveAutoWin = false
local ActiveAutoFarmMoney = false
local AutoFarmSummerEvent = false
local AntiAfkEnabled = true
local AntiTp = true
local AntiBypass = true



-- ปรับ Speed



-- Emotes



local originalBrightness = game.Lighting.Brightness
local originalOutdoorAmbient = game.Lighting.OutdoorAmbient
local originalAmbient = game.Lighting.Ambient
local originalGlobalShadows = game.Lighting.GlobalShadows
local originalFogEnd = game.Lighting.FogEnd
local originalFogStart = game.Lighting.FogStart
local originalFogColor = game.Lighting.FogColor
local originalColorCorrectionEnabled = game.Lighting.ColorCorrection.Enabled
local originalSaturation = game.Lighting.ColorCorrection.Saturation
local originalContrast = game.Lighting.ColorCorrection.Contrast

local function applyFullBrightness()
    game.Lighting.Brightness = 2
    game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    game.Lighting.GlobalShadows = false
end

local function removeFullBrightness()
    game.Lighting.Brightness = originalBrightness
    game.Lighting.OutdoorAmbient = originalOutdoorAmbient
    game.Lighting.Ambient = originalAmbient
    game.Lighting.GlobalShadows = originalGlobalShadows
end

local function applySuperFullBrightness()
    game.Lighting.Brightness = 15
    game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    game.Lighting.GlobalShadows = false
end

local function applyNoFog()
    game.Lighting.FogEnd = 1000000
    game.Lighting.FogStart = 999999
end

local function removeNoFog()
    game.Lighting.FogEnd = originalFogEnd
    game.Lighting.FogStart = originalFogStart
end

local function applyVibrant()
    game.Lighting.ColorCorrection.Enabled = true
    game.Lighting.ColorCorrection.Saturation = 0.8
    game.Lighting.ColorCorrection.Contrast = 0.4
end

local function removeVibrant()
    game.Lighting.ColorCorrection.Enabled = originalColorCorrectionEnabled
    game.Lighting.ColorCorrection.Saturation = originalSaturation
    game.Lighting.ColorCorrection.Contrast = originalContrast
end

MiscTab:Section({ Title = "Feature Misc", Icon = "cog" })

local afk = true

MiscTab:Toggle({
    Title = "Anti-AFK",
    Default = true,
    Callback = function(state)
        afk = state -- อัปเดตตัวแปรหลัก
        if state then
            task.spawn(function()
                while afk do
                    if not LocalPlayer then return end
                    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(60)
                end
            end)
        else
            print("[DYHUB] Anti-AFK disabled.")
        end
    end
})

MiscTab:Section({ Title = "Feature Visual", Icon = "lightbulb" })

MiscTab:Toggle({
    Title = "Full Brightness",
    Default = false,
    Callback = function(state)
        FullbrightEnabled = state
        if state then
            applyFullBrightness()
        else
            removeFullBrightness()
        end
    end
})

MiscTab:Toggle({
    Title = "Super Full Brightness",
    Default = false,
    Callback = function(state)
        SuperFullBrightnessEnabled = state
        if state then
            applySuperFullBrightness()
        else
            removeFullBrightness()
        end
    end
})

MiscTab:Toggle({
    Title = "No Fog",
    Default = false,
    Callback = function(state)
        NoFogEnabled = state
        if state then
            applyNoFog()
        else
            removeNoFog()
        end
    end
})

MiscTab:Toggle({
    Title = "Vibrant +200%",
    Default = false,
    Callback = function(state)
        VibrantEnabled = state
        if state then
            applyVibrant()
        else
            removeVibrant()
        end
    end
})

MiscTab:Section({ Title = "Feature Boost", Icon = "rocket" })

MiscTab:Toggle({
    Title = "FPS Boost",
    Default = false,
    Callback = function(state)
        if state then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") then
                    v.Transparency = 1
                end
            end
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        else
            print("[DYHUB] FPS Boost disabled. (by rhy)")
        end
    end
})

if FullbrightEnabled then
    applyFullBrightness()
end
if NoFogEnabled then
    applyNoFog()
end
if SuperFullBrightnessEnabled then
    applySuperFullBrightness()
end
if VibrantEnabled then
    applyVibrant()
end



local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Admin = ReplicatedStorage.Events.CustomServers.Admin
local VIPCommand = ReplicatedStorage.Events.Admin.VIPCommand

local remoteFired = false     -- กันยิง FireServer ซ้ำ
local mapInvoked = false      -- กัน invoke !map ซ้ำ
local loopRunning = false     -- กัน loop ซ้ำ

GameTab:Section({ Title = "Private Server", TextSize = 40 })

AutoWinToggle = GameTab:Toggle({
    Title = "Set Up (VIP Farm)",
    Value = false,
    Callback = function(state)

        featureStates.Setup = state

        if state == true then
            
            --------------------------
            -- ยิง RemoteEvent แค่ครั้งเดียว
            --------------------------
            if not remoteFired then
                remoteFired = true

                -- ยิงครั้งเดียวเท่านั้น
                Admin:FireServer("Gamemode", "Pro")
                Admin:FireServer("AddMap", "DesertBus")

                task.wait(0.5)
            end

            --------------------------
            -- ยิง "!map DesertBus" ครั้งเดียว
            --------------------------
            if not mapInvoked then
                mapInvoked = true
                VIPCommand:InvokeServer("!map DesertBus")
            end

            --------------------------
            -- เริ่ม Loop ยิงเฉพาะ specialround ทุก 30 วิ
            --------------------------
            if not loopRunning then
                loopRunning = true

                task.spawn(function()
                    while featureStates.Setup do
                        VIPCommand:InvokeServer("!specialround Plushie Hell")
                        task.wait(30)
                    end
                    loopRunning = false
                end)
            end

        else
            -- ปิด toggle = หยุด loop
            -- states จะทำให้ loop หยุดเอง
        end
    end
})


GameTab:Section({ Title = "Feature Farm", Icon = "dollar-sign" })

GameTab:Toggle({
    Title = "Auto Farm Win",
    Callback = function(state)
        ActiveAutoWin = state
        if ActiveAutoWin then
            print("[DYHUB] Auto Farm Win Enabled!")
            spawn(function()
                while ActiveAutoWin do
                    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local rootPart = character:FindFirstChild("HumanoidRootPart")

                    if character and rootPart then
                        if character:GetAttribute("Downed") then
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                            print("[DYHUB] Revived for Auto Win!")
                            task.wait(0.5)
                        end

                        if not character:GetAttribute("Downed") then
                            local securityPart = Instance.new("Part")
                            securityPart.Name = "SecurityPartTemp"
                            securityPart.Size = Vector3.new(10, 1, 10)
                            securityPart.Position = Vector3.new(0, 500, 0)
                            securityPart.Anchored = true
                            securityPart.Transparency = 1
                            securityPart.CanCollide = true
                            securityPart.Parent = Workspace

                            rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.5)
                            securityPart:Destroy()
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            print("[DYHUB] Auto Farm Win Disabled!")
        end
    end
})

GameTab:Toggle({
    Title = "Auto Farm Money",
    Callback = function(state)
        ActiveAutoFarmMoney = state
        if ActiveAutoFarmMoney then
            print("[DYHUB] Auto Farm Money Enabled!")
            spawn(function()
                while ActiveAutoFarmMoney do
                    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

                    if character and rootPart then
                        if character:GetAttribute("Downed") then
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                            print("[DYHUB] Revived for Auto Farm-Money!")
                            task.wait(0.5)
                        end

                        local downedPlayerFound = false
                        local playersInGame = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                        if playersInGame then
                            for _, v in pairs(playersInGame:GetChildren()) do
                                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:GetAttribute("Downed") then
                                    rootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                                    ReplicatedStorage.Events.Character.Interact:FireServer("Revive", true, v)
                                    print("[DYHUB] Reviving player for Farm Money!")
                                    task.wait(0.5)
                                    downedPlayerFound = true
                                    break
                                end
                            end
                        end

                        if not downedPlayerFound then
                            print("[DYHUB] ⚠️ No downed player found for Auto Farm Money, waiting...")
                        end

                        local securityPart = Instance.new("Part")
                        securityPart.Name = "SecurityPartTemp"
                        securityPart.Size = Vector3.new(10, 1, 10)
                        securityPart.Position = Vector3.new(0, 500, 0)
                        securityPart.Anchored = true
                        securityPart.Transparency = 1
                        securityPart.CanCollide = true
                        securityPart.Parent = Workspace
                        rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)

                    else
                        print("[DYHUB] Character or HumanoidRootPart not found, waiting for spawn.")
                    end
                    task.wait(1)
                end
            end)
        else
            print("[DYHUB] Auto Farm Money Disabled!")
        end
    end
})

GameTab:Toggle({
    Title = "Auto Farm Point & Quest",
    Callback = function(state)
        ActiveAutoFarmMoney = state
        if ActiveAutoFarmMoney then
            print("[DYHUB] Auto Farm Quest Enabled!")
            spawn(function()
                while ActiveAutoFarmMoney do
                    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

                    if character and rootPart then
                        if character:GetAttribute("Downed") then
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                            print("[DYHUB] Revived for Auto Farm-Quest!")
                            task.wait(0.5)
                        end

                        local downedPlayerFound = false
                        local playersInGame = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                        if playersInGame then
                            for _, v in pairs(playersInGame:GetChildren()) do
                                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:GetAttribute("Downed") then
                                    rootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                                    ReplicatedStorage.Events.Character.Interact:FireServer("Revive", true, v)
                                    print("[DYHUB] Reviving player for Farm Quest!")
                                    task.wait(0.5)
                                    downedPlayerFound = true
                                    break
                                end
                            end
                        end

                        if not downedPlayerFound then
                            print("[DYHUB] ⚠️ No downed player found for Auto Farm Quest, waiting...")
                        end

                        local securityPart = Instance.new("Part")
                        securityPart.Name = "SecurityPartTemp"
                        securityPart.Size = Vector3.new(10, 1, 10)
                        securityPart.Position = Vector3.new(0, 500, 0)
                        securityPart.Anchored = true
                        securityPart.Transparency = 1
                        securityPart.CanCollide = true
                        securityPart.Parent = Workspace
                        rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)

                    else
                        print("[DYHUB] Character or HumanoidRootPart not found, waiting for spawn.")
                    end
                    task.wait(1)
                end
            end)
        else
            print("[DYHUB] Auto Farm Quest Disabled!")
        end
    end
})

GameTab:Toggle({
    Title = "Auto Farm Ticket",
    Callback = function(state)
        AutoFarmSummerEvent = state
        if AutoFarmSummerEvent then
            print("[DYHUB] Auto Farm Ticket Enabled!")
            spawn(function()
                while AutoFarmSummerEvent do
                    local tickets = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Effects") and Workspace.Game.Effects:FindFirstChild("Tickets")
                    if tickets then
                        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

                        if character and rootPart then
                            if character:GetAttribute("Downed") then
                                ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                                print("[DYHUB] Revived for Tickets Event!")
                                task.wait(0.5)
                            end

                            for _, ticket in ipairs(tickets:GetChildren()) do
                                local ticketPart = ticket:FindFirstChild("HumanoidRootPart") or ticket.PrimaryPart
                                if ticketPart and rootPart then
                                    rootPart.CFrame = ticketPart.CFrame + Vector3.new(0, 2, 0)
                                    task.wait(0.2)
                                end
                            end

                            local securityPart = Instance.new("Part")
                            securityPart.Name = "SecurityPartTemp"
                            securityPart.Size = Vector3.new(10, 1, 10)
                            securityPart.Position = Vector3.new(0, 500, 0)
                            securityPart.Anchored = true
                            securityPart.Transparency = 1
                            securityPart.CanCollide = true
                            securityPart.Parent = Workspace
                            rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                        end
                    else
                        print("[DYHUB] ⚠️ Tickets not found for Tickets Event!")
                    end
                    task.wait(1)
                end
            end)
        else
            print("[DYHUB] Auto Farm Tickets Event Disabled!")
        end
    end
})
