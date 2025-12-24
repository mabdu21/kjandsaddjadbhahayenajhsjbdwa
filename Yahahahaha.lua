-- DYHUB | Evade - Upgraded Full Script (Version ni - Improved)
-- Author: dyumra (upgraded) - provides safer checks, proper toggles, and resource cleanup.
repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local InsertService = game:GetService("InsertService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- WindUI loader (safer)
local WindUI = nil
local ok, err = pcall(function()
    local success, scriptContent = pcall(function()
        return game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
    end)
    if success and scriptContent and scriptContent ~= "" then
        WindUI = loadstring(scriptContent)()
    else
        error("Failed to retrieve WindUI content.")
    end
end)
if not ok or not WindUI then
    warn("Failed to load WindUI: " .. tostring(err))
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB Error",
            Text = "The script does not support your executor or WindUI failed to load.",
            Duration = 8,
            Button1 = "OK"
        })
    end)
    return
end

-- Window
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Evade | Development Version",
    Size = UDim2.fromOffset(500, 300),
    Transparent = true,
    Theme = "Dark",
})

Window:SetToggleKey(Enum.KeyCode.K)

pcall(function()
    Window:Tag({
        Title = "EZZZZZ",
        Color = Color3.fromHex("#ff0000")
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

-- Tabs
local GameTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "file-cog" })
Window:SelectTab(1)

-- Feature state table (central)
local featureStates = {
    Setup = false,
    AutoWin = false,
    AutoFarmMoney = false,
    AutoFarmQuest = false,
    AutoTickets = false,
    AntiAfk = true,
}

-- Visual defaults (saved)
local originalLighting = {
    Brightness = Lighting.Brightness,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Ambient = Lighting.Ambient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    FogColor = Lighting.FogColor
}
-- ColorCorrection object safety
local colorCorrection = Lighting:FindFirstChildOfClass("ColorCorrection")
local originalCC = {}
if colorCorrection then
    originalCC.Enabled = colorCorrection.Enabled
    originalCC.Saturation = colorCorrection.Saturation
    originalCC.Contrast = colorCorrection.Contrast
else
    -- create a ColorCorrection if missing
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Parent = Lighting
    originalCC.Enabled = colorCorrection.Enabled
    originalCC.Saturation = colorCorrection.Saturation
    originalCC.Contrast = colorCorrection.Contrast
end

-- Lighting helper functions
local function applyFullBrightness()
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
    Lighting.Ambient = Color3.fromRGB(255,255,255)
    Lighting.GlobalShadows = false
end
local function removeFullBrightness()
    Lighting.Brightness = originalLighting.Brightness
    Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
    Lighting.Ambient = originalLighting.Ambient
    Lighting.GlobalShadows = originalLighting.GlobalShadows
end
local function applySuperFullBrightness()
    Lighting.Brightness = 15
    Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
    Lighting.Ambient = Color3.fromRGB(255,255,255)
    Lighting.GlobalShadows = false
end
local function applyNoFog()
    Lighting.FogEnd = 1000000
    Lighting.FogStart = 999999
end
local function removeNoFog()
    Lighting.FogEnd = originalLighting.FogEnd
    Lighting.FogStart = originalLighting.FogStart
end
local function applyVibrant()
    if colorCorrection then
        colorCorrection.Enabled = true
        colorCorrection.Saturation = 0.8
        colorCorrection.Contrast = 0.4
    end
end
local function removeVibrant()
    if colorCorrection then
        colorCorrection.Enabled = originalCC.Enabled
        colorCorrection.Saturation = originalCC.Saturation
        colorCorrection.Contrast = originalCC.Contrast
    end
end

-- Misc Tab
MiscTab:Section({ Title = "Feature Misc", Icon = "cog" })

do
    local afk = featureStates.AntiAfk
    MiscTab:Toggle({
        Title = "Anti-AFK",
        Default = afk,
        Callback = function(state)
            featureStates.AntiAfk = state
            afk = state
            if state then
                -- spawn anti-afk loop safely (single coroutine)
                spawn(function()
                    while afk do
                        if not LocalPlayer or not LocalPlayer.Parent then break end
                        -- simulate mouse button to avoid AFK kick
                        pcall(function()
                            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        end)
                        task.wait(60)
                    end
                end)
            else
                print("[DYHUB] Anti-AFK disabled.")
            end
        end
    })
end

MiscTab:Section({ Title = "Feature Visual", Icon = "lightbulb" })

do
    local fullbright = false
    MiscTab:Toggle({
        Title = "Full Brightness",
        Default = fullbright,
        Callback = function(state)
            fullbright = state
            if state then applyFullBrightness() else removeFullBrightness() end
        end
    })

    local superBright = false
    MiscTab:Toggle({
        Title = "Super Full Brightness",
        Default = superBright,
        Callback = function(state)
            superBright = state
            if state then applySuperFullBrightness() else removeFullBrightness() end
        end
    })

    local noFog = false
    MiscTab:Toggle({
        Title = "No Fog",
        Default = noFog,
        Callback = function(state)
            noFog = state
            if state then applyNoFog() else removeNoFog() end
        end
    })

    local vibrant = false
    MiscTab:Toggle({
        Title = "Vibrant +200%",
        Default = vibrant,
        Callback = function(state)
            vibrant = state
            if state then applyVibrant() else removeVibrant() end
        end
    })
end

MiscTab:Section({ Title = "Feature Boost", Icon = "rocket" })
do
    local fpsBoost = false
    MiscTab:Toggle({
        Title = "FPS Boost",
        Default = false,
        Callback = function(state)
            fpsBoost = state
            if state then
                -- reduce visuals safely
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Material = Enum.Material.SmoothPlastic
                        v.Reflectance = 0
                    elseif v:IsA("Decal") then
                        v.Transparency = 1
                    end
                end
                -- avoid forcing too low if not available
                pcall(function()
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                end)
                print("[DYHUB] FPS Boost applied.")
            else
                print("[DYHUB] FPS Boost disabled.")
            end
        end
    })
end

-- Initialize some visual states if needed (no override if false)
-- (kept commented — safer to let user toggle)
-- if featureStates.Fullbright then applyFullBrightness() end

-- Safely get remote events/functions (use FindFirstChild)
local remoteEvents = ReplicatedStorage:FindFirstChild("Events")
local customServerAdmin = nil
local vipCommand = nil
if remoteEvents then
    local customServers = remoteEvents:FindFirstChild("CustomServers")
    if customServers then
        customServerAdmin = customServers:FindFirstChild("Admin")
    end
    local adminFolder = remoteEvents:FindFirstChild("Admin")
    if adminFolder then
        vipCommand = adminFolder:FindFirstChild("VIPCommand")
    end
end

-- Small debounces and guards
local remoteFired = false
local mapInvoked = false
local loopHandles = {} -- keep track of spawned threads to stop them cleanly

GameTab:Section({ Title = "Private Server", TextSize = 40 })

-- Setup Toggle (VIP Farm)
do
    AutoWinToggle = GameTab:Toggle({
        Title = "Set Up (VIP Farm)",
        Value = false,
        Callback = function(state)
            featureStates.Setup = state
            if state then
                -- Fire server calls once with safety
                if not remoteFired and customServerAdmin and customServerAdmin:IsA("RemoteEvent") then
                    remoteFired = true
                    pcall(function()
                        customServerAdmin:FireServer("Gamemode", "Pro")
                        customServerAdmin:FireServer("AddMap", "DesertBus")
                    end)
                    task.wait(0.5)
                end
                -- Invoke VIP command once
                if not mapInvoked and vipCommand and vipCommand:IsA("RemoteFunction") then
                    mapInvoked = true
                    pcall(function() vipCommand:InvokeServer("!map DesertBus") end)
                end
                -- Start repeating special round every 30s
                if not loopHandles.Setup then
                    loopHandles.Setup = true
                    spawn(function()
                        while featureStates.Setup do
                            if vipCommand and vipCommand:IsA("RemoteFunction") then
                                pcall(function() vipCommand:InvokeServer("!specialround Plushie Hell") end)
                            end
                            task.wait(30)
                        end
                        loopHandles.Setup = nil
                    end)
                end
            else
                -- stopping handled by featureStates.Setup flag
                print("[DYHUB] VIP Setup disabled.")
            end
        end
    })
end

GameTab:Section({ Title = "Feature Farm", Icon = "dollar-sign" })

-- Helper to create and teleport to a temporary security part safely
local function teleportToSafeSpot(rootPart)
    if not rootPart then return end
    local securityPart = Instance.new("Part")
    securityPart.Name = "SecurityPartTemp"
    securityPart.Size = Vector3.new(10,1,10)
    securityPart.Position = Vector3.new(0,500,0)
    securityPart.Anchored = true
    securityPart.Transparency = 1
    securityPart.CanCollide = true
    securityPart.Parent = Workspace
    -- Teleport root there
    rootPart.CFrame = securityPart.CFrame + Vector3.new(0,3,0)
    -- clean up safely after short delay
    task.delay(0.6, function()
        if securityPart and securityPart.Parent then
            securityPart:Destroy()
        end
    end)
end

-- Auto Farm Win
GameTab:Toggle({
    Title = "Auto Farm Win",
    Callback = function(state)
        featureStates.AutoWin = state
        if state then
            print("[DYHUB] Auto Farm Win Enabled!")
            if not loopHandles.AutoWin then
                loopHandles.AutoWin = true
                spawn(function()
                    while featureStates.AutoWin do
                        local character = LocalPlayer and LocalPlayer.Character
                        if not character then
                            character = LocalPlayer and LocalPlayer.CharacterAdded:Wait()
                        end
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                        if character and rootPart then
                            if character:GetAttribute("Downed") then
                                pcall(function()
                                    local ev = ReplicatedStorage:FindFirstChild("Events")
                                    if ev and ev:FindFirstChild("Player") and ev.Player:FindFirstChild("ChangePlayerMode") then
                                        ev.Player.ChangePlayerMode:FireServer(true)
                                    end
                                end)
                                print("[DYHUB] Revived for Auto Win!")
                                task.wait(0.5)
                            end
                            if not character:GetAttribute("Downed") then
                                teleportToSafeSpot(rootPart)
                            end
                        else
                            -- wait for spawn
                            task.wait(0.5)
                        end
                        task.wait(0.1)
                    end
                    loopHandles.AutoWin = nil
                end)
            end
        else
            print("[DYHUB] Auto Farm Win Disabled!")
            featureStates.AutoWin = false
        end
    end
})

-- Auto Farm Money (revive other players)
GameTab:Toggle({
    Title = "Auto Farm Money",
    Callback = function(state)
        featureStates.AutoFarmMoney = state
        if state then
            print("[DYHUB] Auto Farm Money Enabled!")
            if not loopHandles.AutoFarmMoney then
                loopHandles.AutoFarmMoney = true
                spawn(function()
                    while featureStates.AutoFarmMoney do
                        local character = LocalPlayer and LocalPlayer.Character
                        if not character then character = LocalPlayer and LocalPlayer.CharacterAdded:Wait() end
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                        if character and rootPart then
                            if character:GetAttribute("Downed") then
                                pcall(function()
                                    local ev = ReplicatedStorage:FindFirstChild("Events")
                                    if ev and ev:FindFirstChild("Player") and ev.Player:FindFirstChild("ChangePlayerMode") then
                                        ev.Player.ChangePlayerMode:FireServer(true)
                                    end
                                end)
                                print("[DYHUB] Revived for Auto Farm-Money!")
                                task.wait(0.5)
                            end
                            local downedPlayerFound = false
                            local playersInGame = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                            if playersInGame then
                                for _, v in pairs(playersInGame:GetChildren()) do
                                    if typeof(v) == "Instance" and v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:GetAttribute("Downed") then
                                        local hrp = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                                        if hrp then
                                            rootPart.CFrame = hrp.CFrame + Vector3.new(0,3,0)
                                            pcall(function()
                                                local ev = ReplicatedStorage:FindFirstChild("Events")
                                                if ev and ev:FindFirstChild("Character") and ev.Character:FindFirstChild("Interact") then
                                                    ev.Character.Interact:FireServer("Revive", true, v)
                                                end
                                            end)
                                            print("[DYHUB] Reviving player for Farm Money!")
                                            task.wait(0.5)
                                            downedPlayerFound = true
                                            break
                                        end
                                    end
                                end
                            end
                            if not downedPlayerFound then
                                -- no one to revive; move to safe spot to avoid getting stuck
                                teleportToSafeSpot(rootPart)
                                print("[DYHUB] ⚠️ No downed player found; teleporting to safe spot.")
                            end
                        else
                            print("[DYHUB] Character/HumanoidRootPart not found, waiting for spawn.")
                        end
                        task.wait(1)
                    end
                    loopHandles.AutoFarmMoney = nil
                end)
            end
        else
            print("[DYHUB] Auto Farm Money Disabled!")
            featureStates.AutoFarmMoney = false
        end
    end
})

-- Auto Farm Quest (separate toggle but reuses logic)
GameTab:Toggle({
    Title = "Auto Farm Point",
    Callback = function(state)
        featureStates.AutoFarmQuest = state
        if state then
            print("[DYHUB] Auto Farm Quest Enabled!")
            if not loopHandles.AutoFarmQuest then
                loopHandles.AutoFarmQuest = true
                spawn(function()
                    while featureStates.AutoFarmQuest do
                        -- same logic as AutoFarmMoney for now (can be customized)
                        local character = LocalPlayer and LocalPlayer.Character
                        if not character then character = LocalPlayer and LocalPlayer.CharacterAdded:Wait() end
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                        if character and rootPart then
                            if character:GetAttribute("Downed") then
                                pcall(function()
                                    local ev = ReplicatedStorage:FindFirstChild("Events")
                                    if ev and ev:FindFirstChild("Player") and ev.Player:FindFirstChild("ChangePlayerMode") then
                                        ev.Player.ChangePlayerMode:FireServer(true)
                                    end
                                end)
                                print("[DYHUB] Revived for Auto Farm-Quest!")
                                task.wait(0.5)
                            end
                            local downedPlayerFound = false
                            local playersInGame = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                            if playersInGame then
                                for _, v in pairs(playersInGame:GetChildren()) do
                                    if typeof(v) == "Instance" and v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:GetAttribute("Downed") then
                                        local hrp = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                                        if hrp then
                                            rootPart.CFrame = hrp.CFrame + Vector3.new(0,3,0)
                                            pcall(function()
                                                local ev = ReplicatedStorage:FindFirstChild("Events")
                                                if ev and ev:FindFirstChild("Character") and ev.Character:FindFirstChild("Interact") then
                                                    ev.Character.Interact:FireServer("Revive", true, v)
                                                end
                                            end)
                                            print("[DYHUB] Reviving player for Farm Money!")
                                            task.wait(0.5)
                                            downedPlayerFound = true
                                            break
                                        end
                                    end
                                end
                            end
                            if not downedPlayerFound then
                                -- no one to revive; move to safe spot to avoid getting stuck
                                teleportToSafeSpot(rootPart)
                                print("[DYHUB] ⚠️ No downed player found; teleporting to safe spot.")
                            end
                        else
                            print("[DYHUB] Character/HumanoidRootPart not found, waiting for spawn.")
                        end
                        task.wait(1)
                    end
                    loopHandles.AutoFarmMoney = nil
                end)
            end
        else
            print("[DYHUB] Auto Farm Money Disabled!")
            featureStates.AutoFarmMoney = false
        end
    end
})

GameTab:Toggle({
    Title = "Auto Farm Quest",
    Callback = function(state)
        featureStates.AutoFarmQuest = state
        if state then
            print("[DYHUB] Auto Farm Quest Enabled!")
            if not loopHandles.AutoFarmQuest then
                loopHandles.AutoFarmQuest = true
                spawn(function()
                    while featureStates.AutoFarmQuest do
                        -- same logic as AutoFarmMoney for now (can be customized)
                        local character = LocalPlayer and LocalPlayer.Character
                        if not character then character = LocalPlayer and LocalPlayer.CharacterAdded:Wait() end
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                        if character and rootPart then
                            if character:GetAttribute("Downed") then
                                pcall(function()
                                    local ev = ReplicatedStorage:FindFirstChild("Events")
                                    if ev and ev:FindFirstChild("Player") and ev.Player:FindFirstChild("ChangePlayerMode") then
                                        ev.Player.ChangePlayerMode:FireServer(true)
                                    end
                                end)
                                print("[DYHUB] Revived for Auto Farm-Quest!")
                                task.wait(0.5)
                            end
                            local downedPlayerFound = false
                            local playersInGame = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                            if playersInGame then
                                for _, v in pairs(playersInGame:GetChildren()) do
                                    if typeof(v) == "Instance" and v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:GetAttribute("Downed") then
                                        local hrp = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                                        if hrp then
                                            rootPart.CFrame = hrp.CFrame + Vector3.new(0,3,0)
                                            pcall(function()
                                                local ev = ReplicatedStorage:FindFirstChild("Events")
                                                if ev and ev:FindFirstChild("Character") and ev.Character:FindFirstChild("Interact") then
                                                    ev.Character.Interact:FireServer("Revive", true, v)
                                                end
                                            end)
                                            print("[DYHUB] Reviving player for Farm Quest!")
                                            task.wait(0.5)
                                            downedPlayerFound = true
                                            break
                                        end
                                    end
                                end
                            end
                            if not downedPlayerFound then
                                teleportToSafeSpot(rootPart)
                                print("[DYHUB] ⚠️ No downed player found for Auto Farm Quest; teleporting to safe spot.")
                            end
                        else
                            print("[DYHUB] Character or HumanoidRootPart not found, waiting for spawn.")
                        end
                        task.wait(1)
                    end
                    loopHandles.AutoFarmQuest = nil
                end)
            end
        else
            print("[DYHUB] Auto Farm Quest Disabled!")
            featureStates.AutoFarmQuest = false
        end
    end
})

GameTab:Toggle({
    Title = "Auto Farm Ticket",
    Callback = function(state)
        featureStates.AutoTickets = state
        if state then
            print("[DYHUB] Auto Farm Ticket Enabled!")
            if not loopHandles.AutoTickets then
                loopHandles.AutoTickets = true
                spawn(function()
                    while featureStates.AutoTickets do
                        local tickets = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Effects") and Workspace.Game.Effects:FindFirstChild("Tickets")
                        if tickets then
                            local character = LocalPlayer and LocalPlayer.Character
                            if not character then character = LocalPlayer and LocalPlayer.CharacterAdded:Wait() end
                            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                            if character and rootPart then
                                if character:GetAttribute("Downed") then
                                    pcall(function()
                                        local ev = ReplicatedStorage:FindFirstChild("Events")
                                        if ev and ev:FindFirstChild("Player") and ev.Player:FindFirstChild("ChangePlayerMode") then
                                            ev.Player.ChangePlayerMode:FireServer(true)
                                        end
                                    end)
                                    print("[DYHUB] Revived for Tickets Event!")
                                    task.wait(0.5)
                                end
                                for _, ticket in ipairs(tickets:GetChildren()) do
                                    local ticketPart = ticket:FindFirstChild("HumanoidRootPart") or ticket.PrimaryPart
                                    if ticketPart then
                                        rootPart.CFrame = ticketPart.CFrame + Vector3.new(0,1.5,0)
                                        task.wait(1.11)
                                    end
                                end
                                teleportToSafeSpot(rootPart)
                            end
                        else
                            print("[DYHUB] ⚠️ Tickets not found for Tickets Event!")
                        end
                        task.wait(1)
                    end
                    loopHandles.AutoTickets = nil
                end)
            end
        else
            print("[DYHUB] Auto Farm Tickets Event Disabled!")
            featureStates.AutoTickets = false
        end
    end
})

local function cleanupAll()
    -- stop feature loops
    for k, _ in pairs(featureStates) do
        featureStates[k] = false
    end
    -- remove temporary objects if any
    for _, v in pairs(Workspace:GetChildren()) do
        if v.Name == "SecurityPartTemp" then
            pcall(function() v:Destroy() end)
        end
    end
    -- restore lighting
    removeFullBrightness()
    removeNoFog()
    removeVibrant()
    print("[DYHUB] Cleanup complete. All features stopped and visuals restored.")
end

-- Add a 'Cleanup' button for quick restore
GameTab:Button({
    Title = "Cleanup & Restore Visuals",
    Callback = function()
        cleanupAll()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = "Cleanup complete.",
            Duration = 3
        })
    end
})
