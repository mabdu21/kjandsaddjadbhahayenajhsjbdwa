-- Powered by GPT 5
-- ======================
local version = "Pre-4.0.9"
-- ======================

repeat task.wait() until game:IsLoaded()

-- FPS Unlock
if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "FPS Unlocked!",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("FPS Unlocked!")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "Your exploit does not support setfpscap.",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("Your exploit does not support setfpscap.")
end

-- Services
local RunService = game:GetService("RunService")
local Workspace = game.Workspace
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ====================== WINDOW ======================
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

local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Violence District | " .. userversion,
    Folder = "DYHUB_VD_config",
    Size = UDim2.fromOffset(500, 400),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = { Enabled = true, Anonymous = false },
})

Window:SetToggleKey(Enum.KeyCode.K)

pcall(function()
    Window:Tag({
        Title = version,
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

-- Tabs
local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local Main1Divider = Window:Divider()
local SurTab = Window:Tab({ Title = "Survivor", Icon = "user-check" })
local killerTab = Window:Tab({ Title = "Killer", Icon = "swords" })
local Main2Divider = Window:Divider()
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })
local Hitbox = Window:Tab({ Title = "Hitbox", Icon = "package" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })

Window:SelectTab(1)

-- ====================== ESP SYSTEM ======================
-- Toggle values
local ESPSURVIVOR  = false
local ESPMURDER    = false
local ESPGENERATOR = false
local ESPGATE      = false
local ESPPALLET    = false
local ESPWINDOW    = false
local ESPPUMKIN    = false
local ESPHOOK      = false

-- Color config
local COLOR_SURVIVOR       = Color3.fromRGB(0,0,255)
local COLOR_MURDERER       = Color3.fromRGB(255,0,0)
local COLOR_GENERATOR      = Color3.fromRGB(255,255,255)
local COLOR_GENERATOR_DONE = Color3.fromRGB(0,255,0)
local COLOR_GATE           = Color3.fromRGB(255,255,255)
local COLOR_PALLET         = Color3.fromRGB(255,255,0)
local COLOR_PUMKIN         = Color3.fromRGB(255, 165, 0)
local COLOR_OUTLINE        = Color3.fromRGB(0,0,0)
local COLOR_WINDOW         = Color3.fromRGB(175, 215, 230)
local COLOR_HOOK           = Color3.fromRGB(255,0,0)

-- State flags
local espEnabled = false
local espSurvivor = false
local espMurder = false
local espGenerator = false
local espGate = false
local espHook = false
local espPallet = false
local espWindowEnabled = false
local espPumkin = false

-- Label toggles
local ShowName = true
local ShowDistance = true
local ShowHP = true
local ShowHighlight = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local espObjects = {}

-- Remove ESP from object
local function removeESP(obj)
    if espObjects[obj] then
        local data = espObjects[obj]
        if data.highlight then data.highlight:Destroy() end
        if data.nameLabel and data.nameLabel.Parent then
            data.nameLabel.Parent.Parent:Destroy()
        end
        espObjects[obj] = nil
    end
end

-- Create ESP
local function createESP(obj, baseColor)
    if not obj or obj.Name == "Lobby" then return end
    if espObjects[obj] then
        local data = espObjects[obj]
        if data.highlight then
            data.highlight.FillColor = baseColor
            data.highlight.OutlineColor = baseColor
            data.highlight.Enabled = ShowHighlight
        end
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = obj
    highlight.FillColor = baseColor
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = baseColor
    highlight.OutlineTransparency = 0.1
    highlight.Enabled = ShowHighlight
    highlight.Parent = obj

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 200, 0, 50)
    bill.Adornee = obj
    bill.AlwaysOnTop = true
    bill.Parent = obj

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 1
    frame.Parent = bill

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0.33,0)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = baseColor
    nameLabel.TextStrokeColor3 = COLOR_OUTLINE
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = obj.Name
    nameLabel.Visible = ShowName
    nameLabel.Parent = frame

    local hpLabel = Instance.new("TextLabel")
    hpLabel.Size = UDim2.new(1,0,0.33,0)
    hpLabel.Position = UDim2.new(0,0,0.33,0)
    hpLabel.BackgroundTransparency = 1
    hpLabel.Font = Enum.Font.SourceSansBold
    hpLabel.TextSize = 14
    hpLabel.TextColor3 = baseColor
    hpLabel.TextStrokeColor3 = COLOR_OUTLINE
    hpLabel.TextStrokeTransparency = 0
    hpLabel.Text = ""
    hpLabel.Parent = frame

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1,0,0.33,0)
    distLabel.Position = UDim2.new(0,0,0.66,0)
    distLabel.BackgroundTransparency = 1
    distLabel.Font = Enum.Font.SourceSansBold
    distLabel.TextSize = 14
    distLabel.TextColor3 = baseColor
    distLabel.TextStrokeColor3 = COLOR_OUTLINE
    distLabel.TextStrokeTransparency = 0
    distLabel.Text = ""
    distLabel.Parent = frame

    espObjects[obj] = {
        highlight = highlight,
        nameLabel = nameLabel,
        hpLabel = hpLabel,
        distLabel = distLabel,
        color = baseColor
    }
end

-- Get generator all location
local function getFolderGenerator()
    local folders = {}
    local map = workspace:FindFirstChild("Map")
    if not map then return folders end

    -- Map.Generator
    for _, child in ipairs(map:GetChildren()) do
        if child.Name == "Generator" and child:IsA("Model") then
            table.insert(folders, child)
        end
    end

    -- Map.Model.Generator
    local model = map:FindFirstChild("Model")
    if model then
        for _, child in ipairs(model:GetChildren()) do
            if child.Name == "Generator" and child:IsA("Model") then
                table.insert(folders, child)
            end
        end
    end

    -- Map.Maze2.Generator
    local Maze2 = map:FindFirstChild("Maze2")
    if Maze2 then
        for _, child in ipairs(Maze2:GetChildren()) do
            if child.Name == "Generator" and child:IsA("Model") then
                table.insert(folders, child)
            end
        end
    end

    -- Rooftop.Generator
    local rooftop = map:FindFirstChild("Rooftop")
    if rooftop then
        for _, child in ipairs(rooftop:GetChildren()) do
            if child.Name == "Generator" and child:IsA("Model") then
                table.insert(folders, child)
            end
        end

        -- Rooftop.Model.Generator
        local rooftopModel = rooftop:FindFirstChild("Model")
        if rooftopModel then
            for _, child in ipairs(rooftopModel:GetChildren()) do
                if child.Name == "Generator" and child:IsA("Model") then
                    table.insert(folders, child)
                end
            end
        end
    end

    return folders
end

-- Get map folders
local function getMapFolders()
    local folders = {}
    local mainMap = workspace:FindFirstChild("Map")
    if not mainMap then return folders end

    -- Map (หลัก)
    table.insert(folders, mainMap)

    -- Map.Rooftop
    local rooftop = mainMap:FindFirstChild("Rooftop")
    if rooftop then
        table.insert(folders, rooftop)

        -- Rooftop.Model
        local rooftopModel = rooftop:FindFirstChild("Model")
        if rooftopModel then
            table.insert(folders, rooftopModel)
        end
    end

    -- Map.Maze2
    local maze2 = mainMap:FindFirstChild("Maze2")
    if maze2 then
        table.insert(folders, maze2)
    end

    -- Map.Model (ถ้ามี)
    local model = mainMap:FindFirstChild("Model")
    if model then
        table.insert(folders, model)
    end

    return folders
end

-- Update Window ESP
local function updateWindowESP()
    if not espEnabled then return end
    for _, folder in pairs(getMapFolders()) do
        for _, windowModel in pairs(folder:GetChildren()) do
            if windowModel:IsA("Model") and windowModel.Name == "Window" then
                if espWindowEnabled then
                    createESP(windowModel, COLOR_WINDOW)
                else
                    removeESP(windowModel)
                end
            end
        end
    end
end

local function getPumkinFolders()
    local folders = {}
    -- ค้นหา Map และ Rooftop
    local mainMap = workspace:FindFirstChild("Map")
    local rooftop = workspace:FindFirstChild("Rooftop")

    -- ถ้ามี Map และในนั้นมีโฟลเดอร์ชื่อ Pumkin
    if mainMap and mainMap:FindFirstChild("Pumpkins") then
        table.insert(folders, mainMap.Pumpkins)
    end

    -- ถ้ามี Rooftop และในนั้นมีโฟลเดอร์ชื่อ Pumkin
    if rooftop and rooftop:FindFirstChild("Pumpkins") then
        table.insert(folders, rooftop.Pumpkins)
    end

    return folders
end

local function updatePumkinESP()
    if not espEnabled then return end
    for _, folder in pairs(getPumkinFolders()) do
        for _, pumkin in pairs(folder:GetChildren()) do
            -- ตรวจชื่อ Pumkin1, Pumkin2, Pumkin3, ...
            if pumkin:IsA("Model") and pumkin.Name:match("^Pumpkin%d+$") then
                if espPumkin then
                    createESP(pumkin, COLOR_PUMKIN)
                else
                    removeESP(pumkin)
                end
            end
        end
    end
end

-- Main update function
local lastUpdate = 0
local updateInterval = 0.5

local function updateESP(dt)
    if not espEnabled then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Player loop
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character ~= LocalPlayer.Character and player.Character.Name ~= "Lobby" then
            local isMurderer = player.Character:FindFirstChild("Weapon") ~= nil
            local currentESP = espObjects[player.Character]

            if isMurderer then
                if espMurder then
                    if currentESP and currentESP.color ~= COLOR_MURDERER then removeESP(player.Character) end
                    createESP(player.Character, COLOR_MURDERER)
                else
                    removeESP(player.Character)
                end
            else
                if espSurvivor then
                    if currentESP and currentESP.color ~= COLOR_SURVIVOR then removeESP(player.Character) end
                    createESP(player.Character, COLOR_SURVIVOR)
                else
                    removeESP(player.Character)
                end
            end
        end
    end

    -- Object loop
    for _, folder in pairs(getMapFolders()) do
        for _, obj in pairs(folder:GetChildren()) do
            if obj.Name == "Generator" then
                if espGenerator then
                    local hitbox = obj:FindFirstChild("HitBox")
                    local pointLight = hitbox and hitbox:FindFirstChildOfClass("PointLight")
                    local color = COLOR_GENERATOR
                    if pointLight and pointLight.Color == Color3.fromRGB(126,255,126) then
                        color = COLOR_GENERATOR_DONE
                    end
                    createESP(obj, color)
                else
                    removeESP(obj)
                end

            elseif obj.Name == "Gate" then
                if espGate then
                    createESP(obj, COLOR_GATE)
                else
                    removeESP(obj)
                end

            elseif obj.Name == "Hook" then
                local mdl = obj:FindFirstChild("Model")
                if mdl then
                    if espHook then
                        createESP(mdl, COLOR_HOOK)
                    else
                        removeESP(mdl)
                    end
                end

            elseif obj.Name == "Palletwrong" then
                if espPallet then
                    createESP(obj, COLOR_PALLET)
                else
                    removeESP(obj)
                end

            else
                if espObjects[obj] then
                    removeESP(obj)
                end
            end
        end
    end

    updateWindowESP()
    updatePumkinESP()

    -- Update labels
    for obj, data in pairs(espObjects) do
        if obj and obj.Parent and obj.Name ~= "Lobby" then
            local targetPart = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if targetPart then
                local humanoid = obj:FindFirstChildOfClass("Humanoid")
                local isPlayer = humanoid ~= nil

                -- Name label
                data.nameLabel.Position = UDim2.new(0,0,0,0)
                data.nameLabel.Visible = ShowName

                if isPlayer then
                    -- Player case

                    -- HP label
                    if ShowHP and humanoid then
                        data.hpLabel.Text = "[ "..math.floor(humanoid.Health).." HP ]"
                        data.hpLabel.Visible = true
                    else
                        data.hpLabel.Text = ""
                        data.hpLabel.Visible = false
                    end

                    -- Distance label
                    if ShowDistance then
                        local dist = math.floor((hrp.Position - targetPart.Position).Magnitude)
                        data.distLabel.Text = "[ "..dist.." MM ]"
                        data.distLabel.Visible = true
                    else
                        data.distLabel.Text = ""
                        data.distLabel.Visible = false
                    end

                    -- Adjust positions based on visibility
                    if data.hpLabel.Visible then
                        data.hpLabel.Position = UDim2.new(0,0,0.33,0)
                        data.distLabel.Position = UDim2.new(0,0,0.66,0)
                    else
                        data.distLabel.Position = UDim2.new(0,0,0.33,0)
                    end

                else
                    -- Object case (no HP)

                    data.hpLabel.Text = ""
                    data.hpLabel.Visible = false

                    if ShowDistance then
                        local dist = math.floor((hrp.Position - targetPart.Position).Magnitude)
                        data.distLabel.Text = "[ "..dist.." MM ]"
                        data.distLabel.Visible = true
                        data.distLabel.Position = UDim2.new(0,0,0.33,0)
                    else
                        data.distLabel.Text = ""
                        data.distLabel.Visible = false
                    end
                end

                -- Highlight
                if data.highlight then
                    data.highlight.Enabled = ShowHighlight
                end
            end
        else
            removeESP(obj)
        end
    end
end

-- Run every frame
RunService.RenderStepped:Connect(function(dt)
    lastUpdate = lastUpdate + dt
    if lastUpdate >= updateInterval then
        lastUpdate = 0
        updateESP(dt)
    end
end)

-- Clean up on player leave
Players.PlayerRemoving:Connect(function(player)
    if player.Character then removeESP(player.Character) end
end)

-- GUI toggle callbacks (example, replace with your actual GUI lib if needed)
EspTab:Section({ Title = "Feature Esp", Icon = "eye" })
EspTab:Toggle({Title="Enable ESP", Value=false, Callback=function(v)
    espEnabled = v
    if not espEnabled then
        for obj,_ in pairs(espObjects) do removeESP(obj) end
    else
        updateESP(0)
        updateWindowESP()
        updatePumkinESP()
    end
end})

EspTab:Section({ Title = "Esp Role", Icon = "user" })
EspTab:Toggle({Title="ESP Survivor", Value=false, Callback=function(v) espSurvivor=v end})
EspTab:Toggle({Title="ESP Killer", Value=false, Callback=function(v) espMurder=v end})

EspTab:Section({ Title = "Esp Engine", Icon = "biceps-flexed" })
EspTab:Toggle({Title="ESP Generator", Value=false, Callback=function(v) espGenerator=v end})
EspTab:Toggle({Title="ESP Gate", Value=false, Callback=function(v) espGate=v end})

EspTab:Section({ Title = "Esp Object", Icon = "package" })
EspTab:Toggle({Title="ESP Pallet", Value=false, Callback=function(v) espPallet=v end})
EspTab:Toggle({Title="ESP Hook", Value=false, Callback=function(v) espHook=v end})
EspTab:Toggle({Title="ESP Window", Value=false, Callback=function(v)
    espWindowEnabled=v
    updateWindowESP()
end})

EspTab:Section({ Title = "Esp Event", Icon = "candy" })
EspTab:Toggle({Title="ESP Pumpkin", Value=false, Callback=function(v)
    espPumkin=v
    updatePumkinESP()
end})

EspTab:Section({ Title = "Esp Settings", Icon = "settings" })
EspTab:Toggle({Title="Show Name", Value=ShowName, Callback=function(v) ShowName=v end})
EspTab:Toggle({Title="Show Distance", Value=ShowDistance, Callback=function(v) ShowDistance=v end})
EspTab:Toggle({Title="Show Health", Value=ShowHP, Callback=function(v) ShowHP=v end})
EspTab:Toggle({Title="Show Highlight", Value=ShowHighlight, Callback=function(v) ShowHighlight=v end})


-- ====================== BYPASS GATE ======================
local bypassGateEnabled = false

-- ฟังก์ชันรวบรวมเกตทั้งหมด
local function gatherGates()
    local gates = {}
    for _, folder in pairs(getMapFolders()) do
        for _, gate in pairs(folder:GetChildren()) do
            if gate.Name == "Gate" then
                table.insert(gates, gate)
            end
        end
    end
    return gates
end

-- ฟังก์ชันตั้งค่าเกต
local function setGateState(enabled)
    local gates = gatherGates()
    for _, gate in pairs(gates) do
        local leftGate = gate:FindFirstChild("LeftGate")
        local rightGate = gate:FindFirstChild("RightGate")
        local leftEnd = gate:FindFirstChild("LeftGate-end")
        local rightEnd = gate:FindFirstChild("RightGate-end")
        local box = gate:FindFirstChild("Box")

        if enabled then
            -- เปิดฟีเจอร์: Left/Right Gate โปร่งใส + ทะลุได้
            if leftGate then
                leftGate.Transparency = 1
                leftGate.CanCollide = false
            end
            if rightGate then
                rightGate.Transparency = 1
                rightGate.CanCollide = false
            end

            -- Left/Right End ไม่โปร่งใส + ชนได้
            if leftEnd then
                leftEnd.Transparency = 0
                leftEnd.CanCollide = true
            end
            if rightEnd then
                rightEnd.Transparency = 0
                rightEnd.CanCollide = true
            end

            -- Box สามารถทะลุได้
            if box then
                box.CanCollide = false
            end
        else
            -- ปิดฟีเจอร์: คืนค่าเดิม
            if leftGate then
                leftGate.Transparency = 0
                leftGate.CanCollide = true
            end
            if rightGate then
                rightGate.Transparency = 0
                rightGate.CanCollide = true
            end
            if leftEnd then
                leftEnd.Transparency = 1
                leftEnd.CanCollide = true
            end
            if rightEnd then
                rightEnd.Transparency = 1
                rightEnd.CanCollide = true
            end
            if box then
                box.CanCollide = true
            end
        end
    end
end

-- ============= Aim bot ===============
MainTab:Section({ Title = "Feature Aimbot", Icon = "target" })

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()

--// Settings
local Settings = {
    Aimbot = {
        Enable = false,
        EnableUI = false,
        CrossHairUI = false,
        Part = { "Head", "Torso" },
        Target = { "Killer", "Survivor" },
        SelectedParts = { "Head" },      -- default selected
        SelectedTargets = { "Killer" },  -- default selected
        SetKeybindLock = "V"             -- default keybind (string)
    }
}

--// Variables
local AimbotEnabled = Settings.Aimbot.Enable
local CrosshairVisible = Settings.Aimbot.CrossHairUI
local AimbotToggleGUIVisible = Settings.Aimbot.EnableUI
local LockedTarget = nil
local LockPart = "Head"

-- Keybind handling
local KeybindLockString = Settings.Aimbot.SetKeybindLock or "V"
local KeybindLock = Enum.KeyCode[KeybindLockString:upper()] or Enum.KeyCode.V

--// GUI: Crosshair
local guiFolder = Instance.new("ScreenGui")
guiFolder.Name = "AimbotUI"
guiFolder.ResetOnSpawn = false
guiFolder.IgnoreGuiInset = true
guiFolder.Parent = PlayerGui

--// Crosshair GUI
local crosshair = Instance.new("Frame")
crosshair.Size = UDim2.new(0, 8, 0, 8)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
crosshair.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
crosshair.BorderSizePixel = 0
crosshair.Visible = false
crosshair.ZIndex = 10
crosshair.Parent = guiFolder

--// Mobile Button GUI
local mobileButton = Instance.new("TextButton")
mobileButton.Size = UDim2.new(0, 90, 0, 90)
mobileButton.AnchorPoint = Vector2.new(1, 1)
mobileButton.Position = UDim2.new(1, -25, 1, -25)
mobileButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
mobileButton.Text = "🎯"
mobileButton.TextSize = 30
mobileButton.TextColor3 = Color3.new(1, 1, 1)
mobileButton.Visible = false
mobileButton.ZIndex = 10
mobileButton.Parent = guiFolder

-- update mobileButton color according to enabled state
local function updateMobileButtonColor()
    if AimbotEnabled then
        mobileButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    else
        mobileButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end
updateMobileButtonColor()

--// UI Dropdowns and Toggles (use your existing Main API)
MainTab:Dropdown({
    Title = "Select Target",
    Values = Settings.Aimbot.Target,
    Multi = true,
    Callback = function(values)
        Settings.Aimbot.SelectedTargets = values or {}
    end
})

MainTab:Dropdown({
    Title = "Select Part",
    Values = Settings.Aimbot.Part,
    Multi = true,
    Callback = function(values)
        Settings.Aimbot.SelectedParts = values or {}
        -- ensure we have a default lock part if available
        if #Settings.Aimbot.SelectedParts > 0 then
            LockPart = Settings.Aimbot.SelectedParts[1]
        end
    end
})

local auraRange = 400

MainTab:Input({
    Title = "Set Distance Aimbot (Value)",
    Default = tostring(auraRange),
    Placeholder = "Distance (Ex: 400)",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            auraRange = num
        else
            warn("Entered an incorrect number!")
        end
    end
})

MainTab:Toggle({
    Title = "Enable Aimbot",
    Default = Settings.Aimbot.Enable,
    Callback = function(state)
        Settings.Aimbot.Enable = state
        AimbotEnabled = state
        if not state then
            LockedTarget = nil
        end
        updateMobileButtonColor()
    end
})

MainTab:Section({ Title = "Aimbot Setting", Icon = "settings" })

MainTab:Toggle({
    Title = "Enable Crosshair",
    Default = Settings.Aimbot.CrossHairUI,
    Callback = function(state)
        Settings.Aimbot.CrossHairUI = state
        crosshair.Visible = state
        CrosshairVisible = state
    end
})

MainTab:Toggle({
    Title = "Enable Aimbot (Toggle GUI)",
    Default = Settings.Aimbot.EnableUI,
    Callback = function(state)
        Settings.Aimbot.EnableUI = state
        AimbotToggleGUIVisible = state
        mobileButton.Visible = state
    end
})

-- Input for Keybind
MainTab:Input({
    Title = "Set Aimbot (Keybind)",
    Default = Settings.Aimbot.SetKeybindLock,
    Placeholder = "Lock (Ex: V)",
    Callback = function(text)
        if type(text) ~= "string" or #text == 0 then
            -- ignore invalid
            return
        end

        -- normalize
        local keyName = text:gsub("%s+", ""):gsub("^%l", string.upper) -- e.g. "v" -> "V", "space" -> "Space"
        -- attempt to find matching Enum.KeyCode
        local kc = Enum.KeyCode[keyName:upper()] or Enum.KeyCode[keyName]
        if not kc then
            -- try a few friendly name mappings
            local friendly = {
                ["SPACE"] = Enum.KeyCode.Space,
                ["LEFTSHIFT"] = Enum.KeyCode.LeftShift,
                ["RIGHTSHIFT"] = Enum.KeyCode.RightShift,
                ["LSHIFT"] = Enum.KeyCode.LeftShift,
                ["RSHIFT"] = Enum.KeyCode.RightShift,
                ["CTRL"] = Enum.KeyCode.LeftControl,
                ["CONTROL"] = Enum.KeyCode.LeftControl,
                ["ALT"] = Enum.KeyCode.LeftAlt,
                ["ENTER"] = Enum.KeyCode.Return,
                ["RETURN"] = Enum.KeyCode.Return,
                ["ESC"] = Enum.KeyCode.Escape,
                ["ESCAPE"] = Enum.KeyCode.Escape
            }
            kc = friendly[keyName:upper()]
        end

        if kc then
            KeybindLock = kc
            Settings.Aimbot.SetKeybindLock = keyName
            KeybindLockString = keyName
            print("[Aimbot] Keybind set to:", KeybindLock.Name)
        else
            -- invalid key string: keep previous
            warn("[Aimbot] Invalid keybind:", text, " — keeping previous:", KeybindLock.Name)
        end
    end
})

--// Function: Check if player is Killer or Survivor
local function IsTargetType(plr)
    local isKiller = plr.Character and plr.Character:FindFirstChild("Weapon")
    if table.find(Settings.Aimbot.SelectedTargets, "Killer") and isKiller then
        return true
    end
    if table.find(Settings.Aimbot.SelectedTargets, "Survivor") and not isKiller then
        return true
    end
    return false
end

--// Function: Validate target
local function IsValidTarget(plr)
    if not plr or plr == LocalPlayer then return false end
    if not IsTargetType(plr) then return false end
    local char = plr.Character
    if not char or not char:FindFirstChild("Humanoid") then return false end
    local part = nil
    for _, p in ipairs(Settings.Aimbot.SelectedParts) do
        if char:FindFirstChild(p) then
            part = char:FindFirstChild(p)
            break
        end
    end
    if not part then return false end
    local root = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
    if not root then return false end
    local dist = (part.Position - root.Position).Magnitude
    if dist > auraRange then return false end

    if not (root and part) then return false end
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, char}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    local res = Workspace:Raycast(root.Position, part.Position - root.Position, rayParams)
    if res and res.Instance and not res.Instance:IsDescendantOf(char) then
        return false
    end
    return true
end

--// Function: Find closest target
local function FindNearestTarget()
    local root = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
    if not root then return nil end
    local closest, closestDist = nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if IsValidTarget(plr) then
            local char = plr.Character
            for _, p in ipairs(Settings.Aimbot.SelectedParts) do
                local part = char and char:FindFirstChild(p)
                if part then
                    local d = (part.Position - root.Position).Magnitude
                    if d < closestDist then
                        closest = plr
                        closestDist = d
                        LockPart = p
                    end
                end
            end
        end
    end
    return closest
end

--// Aimbot Logic (use LockedTarget if set; otherwise use nearest)
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end

    local camera = Workspace.CurrentCamera
    if LockedTarget and LockedTarget.Character and LockedTarget.Character:FindFirstChild(LockPart) and IsValidTarget(LockedTarget) then
        local aimPart = LockedTarget.Character[LockPart]
        camera.CFrame = CFrame.new(camera.CFrame.Position, aimPart.Position)
        return
    end

    -- if no locked target, find nearest and aim to it
    local target = FindNearestTarget()
    if target and target.Character and target.Character:FindFirstChild(LockPart) then
        local aimPart = target.Character[LockPart]
        camera.CFrame = CFrame.new(camera.CFrame.Position, aimPart.Position)
    end
end)

--// Mobile Button Action (toggle Aimbot)
mobileButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    Settings.Aimbot.Enable = AimbotEnabled
    if not AimbotEnabled then
        LockedTarget = nil
    else
        -- when enabling, try lock nearest
        LockedTarget = FindNearestTarget()
    end
    updateMobileButtonColor()
end)

--// Keyboard Keybind - toggle Aimbot + lock nearest when enabling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == KeybindLock then
            AimbotEnabled = not AimbotEnabled
            Settings.Aimbot.Enable = AimbotEnabled
            if AimbotEnabled then
                LockedTarget = FindNearestTarget()
                if LockedTarget then
                    print("[Aimbot] Locked to:", LockedTarget.Name)
                else
                    print("[Aimbot] No valid target to lock.")
                end
            else
                LockedTarget = nil
                print("[Aimbot] Unlocked.")
            end
            updateMobileButtonColor()
        end
    end
end)

--// Cleanup when target leaves
Players.PlayerRemoving:Connect(function(plr)
    if LockedTarget == plr then
        LockedTarget = nil
    end
end)

-- ========== Auto-Collect =============

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- ===============================
-- ⚙️ CONFIG
-- ===============================
local SAFEZONE_HEIGHT = 500
local ACTION_DELAY = 1.69 -- Delay between pumpkin collection
local CPumkin = false

-- ===============================
-- 🧱 Safe Zone Setup
-- ===============================
local function createSafeZone()
	local part = Instance.new("Part")
	part.Name = "DYHUB | SAFEZONE"
	part.Anchored = true
	part.CanCollide = true
	part.Size = Vector3.new(10, 1, 10)
	part.Position = Vector3.new(0, SAFEZONE_HEIGHT, 0)
	part.Transparency = 0.5
	part.Color = Color3.fromRGB(255, 0, 0)
	part.Parent = Workspace
	return part
end

local safeZone = Workspace:FindFirstChild("SafeZone") or createSafeZone()

-- ===============================
-- 🧭 Helper Functions
-- ===============================
local function getRoot()
	local character = LocalPlayer.Character
	if not character then return nil end
	return character:FindFirstChild("HumanoidRootPart")
end

local function getPumpkinPart(pumpkin)
	if not pumpkin then return nil end
	if pumpkin:IsA("BasePart") then return pumpkin end
	if pumpkin:IsA("Model") then
		if pumpkin.PrimaryPart then
			return pumpkin.PrimaryPart
		end
		return pumpkin:FindFirstChildWhichIsA("BasePart")
	end
	return nil
end

local function teleportTo(target)
	local root = getRoot()
	local targetPart = getPumpkinPart(target)
	if root and targetPart then
		root.CFrame = targetPart.CFrame + Vector3.new(0, 1.11, 0)
	end
end

-- ===============================
-- 🖱️ Simulate Left Click (PC + Mobile)
-- ===============================
local function simulateClick()
	local viewportSize = Workspace.CurrentCamera.ViewportSize
	local centerX = viewportSize.X / 2
	local centerY = viewportSize.Y / 2

	-- Press down
	VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
	task.wait(0.05)
	-- Release
	VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
	task.wait(0.05)
end

-- ===============================
-- 🎃 Pumpkin Finder
-- ===============================
local function getPumpkins()
	local pumpkins = {}
	local paths = {
		Workspace:FindFirstChild("Map"),
		Workspace:FindFirstChild("Rooftop"),
	}

	for _, area in ipairs(paths) do
		if area and area:FindFirstChild("Pumpkins") then
			for _, p in ipairs(area.Pumpkins:GetChildren()) do
				if (p:IsA("Model") or p:IsA("BasePart")) and p.Name:match("^Pumpkin%d+$") then
					table.insert(pumpkins, p)
				end
			end
		end
	end

	return pumpkins
end

-- ===============================
-- 🔁 Auto Collect Loop
-- ===============================
local collecting = false
local collected = {}

local function autoCollectPumpkins()
	if collecting then return end
	collecting = true

	task.spawn(function()
		while CPumkin do
			local pumpkins = getPumpkins()
			local newPumpkins = {}

			for _, p in ipairs(pumpkins) do
				if not collected[p] then
					table.insert(newPumpkins, p)
				end
			end

			if #newPumpkins == 0 then
				print("[✅] No pumpkins left to collect. Auto-collect stopped.")
				teleportTo(safeZone)
				CPumkin = false
				break
			end

			for _, pumpkin in ipairs(newPumpkins) do
				if not CPumkin then break end

				local pumpkinPart = getPumpkinPart(pumpkin)
				if pumpkinPart then
					teleportTo(pumpkinPart)
					task.wait(0.3)
					simulateClick() -- simulate left click instead of key press
					collected[pumpkin] = true
					task.wait(ACTION_DELAY)
				end
			end

			task.wait(0.4) -- small delay to avoid freezing
		end

		collecting = false
	end)
end

-- ===============================
-- 🧠 Toggle GUI Integration
-- ===============================
MainTab:Section({ Title = "Feature Farm", Icon = "candy" })
MainTab:Toggle({
	Title = "Auto Collect Pumpkin (Safe Zone)",
	Value = false,
	Callback = function(v)
		CPumkin = v
		if v then
			print("[🎃] Starting auto pumpkin collection...")
			collected = {}
			autoCollectPumpkins()
		else
			print("[🛑] Auto collect stopped.")
			teleportTo(safeZone)
		end
	end
})
MainTab:Toggle({
	Title = "Auto Collect Pumpkin (No Safe Zone)",
	Value = false,
	Callback = function(v)
		CPumkin = v
		if v then
			print("[🎃] Starting auto pumpkin collection...")
			collected = {}
			autoCollectPumpkins()
		else
			print("[🛑] Auto collect stopped.")
		end
	end
})


MainTab:Section({ Title = "Feature Bypass", Icon = "lock-open" })
MainTab:Toggle({
    Title = "Bypass Gate (Fixed)",
    Value = false,
    Callback = function(state)
        bypassGateEnabled = state
        setGateState(state)
    end
})

-- ====================== AUTO GENERATOR ======================
SurTab:Section({ Title = "Feature Survivor", Icon = "user" })

local autoparry = false

SurTab:Toggle({
    Title = "Auto Parry (Under Fixing)",
    Value = false,
    Callback = function(v)
        autoparry = v
        if autoparry then
            task.spawn(function()
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Items"):WaitForChild("Parrying Dagger"):WaitForChild("parry")

                while autoparry do
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character then
                                if plr.Character:FindFirstChild("Weapon") then
                                    local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                                    if targetRoot then
                                        local dist = (root.Position - targetRoot.Position).Magnitude
                                        if dist <= 10 then
                                            remote:FireServer()
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.001)
                end
            end)
        end
    end
})

SurTab:Section({ Title = "Feature Object", Icon = "zap" })

local autoGeneratorEnabledtest = false

SurTab:Toggle({
    Title = "Auto SkillCheck (Perfect)",
    Value = false,
    Callback = function(v)
        autoGeneratorEnabledtest = v
        if autoGeneratorEnabledtest then
            task.spawn(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("SkillCheckResultEvent")
                local repairRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("RepairEvent")
                local player = Players.LocalPlayer
                local playerGui = player:WaitForChild("PlayerGui")

                local lastPosition = nil
                local stationaryThreshold = 2
                local cancelCooldown = 1
                local repairCooldown = 2

                local repairing = false
                local lastGenPoint = nil

                while autoGeneratorEnabledtest do
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")

                    if root then
                        -- หา generator ที่ใกล้ที่สุด
                        local generators = getFolderGenerator()
                        local closestGen, closestPoint, closestDist = nil, nil, 10

                        for _, gen in ipairs(generators) do
                            for i = 1, 4 do
                                local point = gen:FindFirstChild("GeneratorPoint" .. i)
                                if point then
                                    local dist = (root.Position - point.Position).Magnitude
                                    if dist < closestDist then
                                        closestDist = dist
                                        closestGen = gen
                                        closestPoint = point
                                    end
                                end
                            end
                        end

                        -- 🧍 ตรวจจับการขยับ
                        if lastPosition then
                            local moved = (root.Position - lastPosition).Magnitude
                            if moved > stationaryThreshold then
                                if repairing then
                                    repairing = false
                                    lastGenPoint = closestPoint
                                    task.wait(cancelCooldown)
                                    if lastGenPoint then
                                        local args = {lastGenPoint, false}
                                        repairRemote:FireServer(unpack(args))
                                    end
                                end
                            else
                                if not repairing and lastGenPoint and closestPoint == lastGenPoint then
                                    repairing = true
                                    task.wait(repairCooldown)
                                    local args = {lastGenPoint, true}
                                    repairRemote:FireServer(unpack(args))
                                end
                            end
                        else
                            repairing = true
                        end
                        lastPosition = root.Position

                        -- 🎯 รอจนกว่า GUI SkillCheckPromptGui.Check จะปรากฏ
                        local gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                        if gui then
                            local check = gui:FindFirstChild("Check")
                            if not check then
                                -- loop รอ GUI โผล่ขึ้น
                                local timeout = 0
                                while autoGeneratorEnabledtest and timeout < 5 do
                                    gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                                    check = gui and gui:FindFirstChild("Check")
                                    if check and check.Visible then break end
                                    timeout += 0.05
                                    task.wait(0.05)
                                end
                            end

                            -- ถ้า GUI Check โผล่ขึ้นแล้ว -> ยิง remote
                            if check and check.Visible and closestGen and closestPoint then
                                local args = {"success", 1, closestGen, closestPoint}
                                remote:FireServer(unpack(args))

                                -- ซ่อน GUI ทันที
                                check.Visible = false
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local autoGeneratorEnabled = false

SurTab:Toggle({
    Title = "Auto SkillCheck (Not Perfect)",
    Value = false,
    Callback = function(v)
        autoGeneratorEnabled = v
        if autoGeneratorEnabled then
            task.spawn(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("SkillCheckResultEvent")
                local repairRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("RepairEvent")
                local player = Players.LocalPlayer
                local playerGui = player:WaitForChild("PlayerGui")

                local lastPosition = nil
                local stationaryThreshold = 2
                local cancelCooldown = 1
                local repairCooldown = 2

                local repairing = false
                local lastGenPoint = nil

                while autoGeneratorEnabled do
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")

                    if root then
                        -- หา generator ที่ใกล้ที่สุด
                        local generators = getFolderGenerator()
                        local closestGen, closestPoint, closestDist = nil, nil, 10

                        for _, gen in ipairs(generators) do
                            for i = 1, 4 do
                                local point = gen:FindFirstChild("GeneratorPoint" .. i)
                                if point then
                                    local dist = (root.Position - point.Position).Magnitude
                                    if dist < closestDist then
                                        closestDist = dist
                                        closestGen = gen
                                        closestPoint = point
                                    end
                                end
                            end
                        end

                        -- 🧍 ตรวจจับการขยับ
                        if lastPosition then
                            local moved = (root.Position - lastPosition).Magnitude
                            if moved > stationaryThreshold then
                                if repairing then
                                    repairing = false
                                    lastGenPoint = closestPoint
                                    task.wait(cancelCooldown)
                                    if lastGenPoint then
                                        local args = {lastGenPoint, false}
                                        repairRemote:FireServer(unpack(args))
                                    end
                                end
                            else
                                if not repairing and lastGenPoint and closestPoint == lastGenPoint then
                                    repairing = true
                                    task.wait(repairCooldown)
                                    local args = {lastGenPoint, true}
                                    repairRemote:FireServer(unpack(args))
                                end
                            end
                        else
                            repairing = true
                        end
                        lastPosition = root.Position

                        -- 🎯 รอจนกว่า GUI SkillCheckPromptGui.Check จะปรากฏ
                        local gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                        if gui then
                            local check = gui:FindFirstChild("Check")
                            if not check then
                                -- loop รอ GUI โผล่ขึ้น
                                local timeout = 0
                                while autoGeneratorEnabled and timeout < 5 do
                                    gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                                    check = gui and gui:FindFirstChild("Check")
                                    if check and check.Visible then break end
                                    timeout += 0.05
                                    task.wait(0.05)
                                end
                            end

                            -- ถ้า GUI Check โผล่ขึ้นแล้ว -> ยิง remote
                            if check and check.Visible and closestGen and closestPoint then
                                local args = {"success", 1, closestGen, closestPoint}
                                remote:FireServer(unpack(args))

                                -- ซ่อน GUI ทันที
                                check.Visible = false
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local autoLeverEnabled = false

SurTab:Toggle({
    Title = "Auto Lever (No Hold)",
    Value = false,
    Callback = function(v)
        autoLeverEnabled = v
        if autoLeverEnabled then
            task.spawn(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Exit"):WaitForChild("LeverEvent")
                local player = Players.LocalPlayer

                while autoLeverEnabled do
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local folders = getMapFolders()
                        for _, folder in ipairs(folders) do
                            local gate = folder:FindFirstChild("Gate")
                            if gate and gate:FindFirstChild("ExitLever") then
                                local main = gate.ExitLever:FindFirstChild("Main")
                                if main then
                                    local dist = (root.Position - main.Position).Magnitude
                                    if dist <= 10 then
                                        remote:FireServer(main, true)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

SurTab:Section({ Title = "Feature Heal", Icon = "cross" })

-- Auto Heal
local autoHealEnabled = false
SurTab:Toggle({
    Title = "Auto SkillCheck (Test)",
    Value = false,
    Callback = function(v)
        autoHealEnabled = v
        if autoHealEnabled then
            task.spawn(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local SkillCheckResultEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("SkillCheckResultEvent")
                local player = Players.LocalPlayer
                local playerGui = player:WaitForChild("PlayerGui")

                print("[AutoSkillCheck] Enabled")

                while autoHealEnabled do
                    local char = player.Character or player.CharacterAdded:Wait()
                    local root = char:WaitForChild("HumanoidRootPart", 2)

                    if root then
                        -- 🔍 หา “ผู้เล่นที่ใกล้ที่สุด”
                        local closestPlayer
                        local closestDist = math.huge

                        for _, other in ipairs(Players:GetPlayers()) do
                            if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (root.Position - other.Character.HumanoidRootPart.Position).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closestPlayer = other
                                end
                            end
                        end

                        if closestPlayer then
                            print("[AutoSkillCheck] Closest player:", closestPlayer.Name)
                        else
                            print("[AutoSkillCheck] No nearby player found.")
                        end

                        -- 🎯 ตรวจจับ SkillCheck GUI
                        local gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                        if gui then
                            local check = gui:FindFirstChild("Check")
                            if check and check.Visible then
                                print("[AutoSkillCheck] SkillCheck visible — firing remote...")
                                -- 🔥 ยิง remote
                                SkillCheckResultEvent:FireServer("fail", 50, closestPlayer and closestPlayer.Name or player.Name)
                                task.wait(0.1)
                            end
                        end
                    end

                    task.wait(0.25)
                end
            end)
        else
            print("[AutoSkillCheck] Disabled")
        end
    end
})


SurTab:Section({ Title = "Feature Cheat", Icon = "bug" })

SurTab:Button({ 
    Title = "Fling Killer (Spam if killer doesn't fling)",  
    Callback = function(state)

        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer

        local Targets = {}

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                if plr.Character:FindFirstChild("Weapon") then
                    table.insert(Targets, plr.Name)
                end
            end
        end

        local AllBool = false

        local GetPlayer = function(Name)
            Name = Name:lower()
            if Name == "all" or Name == "others" then
                AllBool = true
                return
            elseif Name == "random" then
                local GetPlayers = Players:GetPlayers()
                if table.find(GetPlayers, Player) then
                    table.remove(GetPlayers, table.find(GetPlayers, Player))
                end
                return GetPlayers[math.random(#GetPlayers)]
            else
                for _,x in next, Players:GetPlayers() do
                    if x ~= Player then
                        if x.Name:lower():match("^"..Name) or x.DisplayName:lower():match("^"..Name) then
                            return x
                        end
                    end
                end
            end
        end

        local Message = function(_Title, _Text, Time)
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
        end

        local SkidFling = function(TargetPlayer)
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local RootPart = Humanoid and Humanoid.RootPart

            local TCharacter = TargetPlayer.Character
            local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
            local TRootPart = THumanoid and THumanoid.RootPart
            local THead = TCharacter and TCharacter:FindFirstChild("Head")
            local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
            local Handle = Accessory and Accessory:FindFirstChild("Handle")

            if Character and Humanoid and RootPart then
                if RootPart.Velocity.Magnitude < 50 then
                    getgenv().OldPos = RootPart.CFrame
                end

                if THumanoid and THumanoid.Sit and not AllBool then
                    return Message("Error Occurred", "Targeting is sitting", 5)
                end

                if THead then
                    workspace.CurrentCamera.CameraSubject = THead
                elseif Handle then
                    workspace.CurrentCamera.CameraSubject = Handle
                elseif THumanoid and TRootPart then
                    workspace.CurrentCamera.CameraSubject = THumanoid
                end

                if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

                local FPos = function(BasePart, Pos, Ang)
                    RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                    Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                    RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                    RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                end

                local SFBasePart = function(BasePart)
                    local TimeToWait = 2
                    local Time = tick()
                    local Angle = 0

                    repeat
                        if RootPart and THumanoid then
                            if BasePart.Velocity.Magnitude < 50 then
                                Angle += 100
                                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                            else
                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                            end
                        else
                            break
                        end
                    until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
                end

                workspace.FallenPartsDestroyHeight = 0/0

                local BV = Instance.new("BodyVelocity")
                BV.Name = "DYHUB-YES"
                BV.Parent = RootPart
                BV.Velocity = Vector3.new(9e9, 9e9, 9e9)
                BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

                if TRootPart and THead then
                    if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                        SFBasePart(THead)
                    else
                        SFBasePart(TRootPart)
                    end
                elseif TRootPart then
                    SFBasePart(TRootPart)
                elseif THead then
                    SFBasePart(THead)
                elseif Handle then
                    SFBasePart(Handle)
                else
                    return Message("Error Occurred", "Target is missing everything", 5)
                end

                BV:Destroy()
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                workspace.CurrentCamera.CameraSubject = Humanoid

                repeat
                    RootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
                    Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
                    Humanoid:ChangeState("GettingUp")
                    for _, x in ipairs(Character:GetChildren()) do
                        if x:IsA("BasePart") then
                            x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                        end
                    end
                    task.wait()
                until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25

                workspace.FallenPartsDestroyHeight = getgenv().FPDH
            else
                return Message("Error Ocurrido", "El Script A Fallado", 5)
            end
        end

        if not Welcome then Message("DYHUB | FLING", "THANK FOR USING", 6) end
        getgenv().Welcome = true

        if AllBool then
            for _, x in next, Players:GetPlayers() do
                SkidFling(x)
            end
        end

        for _, x in next, Targets do
            local TPlayer = GetPlayer(x)
            if TPlayer and TPlayer ~= Player then
                if TPlayer.UserId ~= 4340578793 then
                    SkidFling(TPlayer)
                else
                    Message("ERROR FLING OWNER", "", 8)
                end
            elseif not TPlayer and not AllBool then
                Message("ERROR OWNER", "YOU CANT FLING OWNER", 8)
            end
        end
    end
})

SurTab:Button({
    Title = "Invisible (Not Visual)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mabdu21/kjandsaddjadbhahayenajhsjbdwa/refs/heads/main/INV.lua"))()
    end
})

SurTab:Button({
    Title = "Self UnHook (Not 100%)",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local SelfUnHookEvent = ReplicatedStorage.Remotes.Carry.SelfUnHookEvent -- RemoteEvent

        SelfUnHookEvent:FireServer()
    end
})

-- ====================== KILLER ======================
killerTab:Paragraph({
    Title = "Information: The Masked",
    Desc = "• Richard (No Abilities)\n• Tony (One Shot, No hold)\n• Brandon (Speed Boost)\n• Jake (Lunge Range)\n• Richter (Removes terror radius)\n• Graham (Faster Vault)\n• Alex (Chainsaw, One Shot)",
    Image = "rbxassetid://104487529937663",
    ImageSize = 50,
    Locked = false
})

killerTab:Section({ Title = "Killer: The Masked", Icon = "venetian-mask" })

local Killer = {
    TheMasked = {
        Mask = {
            "Richard",
            "Tony",
            "Brandon",
            "Jake",
            "Richter",
            "Graham",
            "Alex"
        }
    }
}

local selectedMasks = {}

killerTab:Dropdown({
    Title = "Select Mask",
    Values = Killer.TheMasked.Mask,
    Multi = false,
    Callback = function(values)
        selectedMasks = values
    end
})

killerTab:Button({ 
    Title = "Choose Mask (Selected)",  
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local ActivatePower = ReplicatedStorage.Remotes.Killers.Masked.Activatepower -- RemoteEvent

        ActivatePower:FireServer(selectedMasks)
    end
})

killerTab:Button({ 
    Title = "Random Mask (Legit Mode)",  
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local ActivatePower = ReplicatedStorage.Remotes.Killers.Masked.Activatepower -- RemoteEvent

        local masks = {
            "Richard",
            "Tony",
            "Brandon",
            "Jake",
            "Richter",
            "Graham",
            "Alex"
        }

        local randomMask = masks[math.random(1, #masks)]

        ActivatePower:FireServer(randomMask)
    end
})

killerTab:Section({ Title = "Feature Killer", Icon = "swords" })

local killallEnabled = false

killerTab:Toggle({
    Title = "Kill All (Warning: Get Ban)",
    Value = false,
    Callback = function(v)
        killallEnabled = v
        if killallEnabled then
            task.spawn(function()
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack")

                -- บันทึกตำแหน่งเริ่มต้นของเรา
                local startCFrame = nil
                local index = 1

                while killallEnabled do
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- บันทึกตำแหน่งก่อนเริ่มครั้งแรก
                        if not startCFrame then
                            startCFrame = root.CFrame
                        end

                        -- รวมเป้าหมายทุกคนยกเว้นตัวเอง
                        local targets = {}
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character then
                                local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                                if targetRoot and humanoid then
                                    table.insert(targets, {player = plr, root = targetRoot, humanoid = humanoid})
                                end
                            end
                        end

                        -- ถ้ามีเป้าหมาย
                        if #targets > 0 then
                            -- ยิงใส่ทุกคนทีละคน
                            for _, entry in ipairs(targets) do
                                if not killallEnabled then break end
                                local targetRoot = entry.root
                                if targetRoot and targetRoot.Parent then
                                    -- วาร์ปไปใกล้เป้าหมาย
                                    root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
                                    -- ยิง Remote
                                    pcall(function()
                                        remote:FireServer()
                                    end)
                                    task.wait(0.15)
                                end
                            end

                            -- เช็คว่าผู้เล่นทุกคนเลือด <= 20 หรือไม่
                            local allLowHealth = true
                            for _, entry in ipairs(targets) do
                                if entry.humanoid.Health > 20 then
                                    allLowHealth = false
                                    break
                                end
                            end

                            -- ถ้าทุกคนเลือด <= 20 ให้กลับไปตำแหน่งเดิม
                            if allLowHealth and startCFrame then
                                root.CFrame = startCFrame
                                task.wait(1)
                            else
                                task.wait(0.2)
                            end
                        else
                            task.wait(0.5)
                        end
                    else
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
})

killerTab:Toggle({Title="Anti Parry (In development)", Value=false, Callback=function(v) noFlashlightEnabled=v end})

killerTab:Section({ Title = "Feature No-Cooldown", Icon = "crown" })

local nocooldownskillEnabled = false

killerTab:Toggle({
    Title = "Auto Attack (No Animation)",
    Value = false,
    Callback = function(v)
        nocooldownskillEnabled = v
        if nocooldownskillEnabled then
            task.spawn(function()
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack")

                while nocooldownskillEnabled do
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local closestTarget = nil
                        local closestDist = 10

                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character then
                                local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                                if targetRoot then
                                    local dist = (root.Position - targetRoot.Position).Magnitude
                                    if dist <= closestDist then
                                        closestDist = dist
                                        closestTarget = plr.Character
                                    end
                                end
                            end
                        end

                        if closestTarget then
                            remote:FireServer()
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

killerTab:Section({ Title = "Feature Cheat", Icon = "bug" })

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local noFlashlightEnabled = false

-- Toggle ของคุณ (ถ้ามี)
killerTab:Toggle({
    Title = "No Flashlight",
    Value = false,
    Callback = function(state)
        noFlashlightEnabled = state
    end
})

-- ฟังก์ชันสแกนทุก Descendant ที่ชื่อ "Blind"
local function removeBlindGui()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    -- สแกนทุก Descendant
    for _, descendant in pairs(playerGui:GetDescendants()) do
        if descendant:IsA("GuiObject") and descendant.Name == "Blind" then
            descendant:Destroy()
        end
    end
end

-- วน loop ทุก 0.5 วินาที
task.spawn(function()
    while true do
        task.wait(0.5)
        if noFlashlightEnabled then
            removeBlindGui()
        end
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ปุ่มใน Killer Tab สำหรับ Reset กล้อง
killerTab:Button({ 
    Title = "Fix Cam (3rd Person Camera)", 
    Callback = function()
        -- รีเซ็ตกล้อง
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = humanoid

            player.CameraMinZoomDistance = 0.5
            player.CameraMaxZoomDistance = 400
            player.CameraMode = Enum.CameraMode.Classic

            -- เผื่อโดน Anchor หัวไว้
            local head = character:FindFirstChild("Head")
            if head then
                head.Anchored = false
            end
        end
    end
})

-- ====================== VISUAL ======================
local Lighting = game:GetService("Lighting")

local fullBrightEnabled = false
local noFogEnabled = false

MainTab:Section({ Title = "Feature Visual", Icon = "lightbulb" })

-- Full Bright
MainTab:Toggle({
    Title = "Full Bright",
    Value = false,
    Callback = function(v)
        fullBrightEnabled = v
        if v then
            task.spawn(function()
                while fullBrightEnabled do
                    if Lighting.Brightness ~= 2 then
                        Lighting.Brightness = 2
                    end
                    if Lighting.ClockTime ~= 14 then
                        Lighting.ClockTime = 14
                    end
                    if Lighting.Ambient ~= Color3.fromRGB(255,255,255) then
                        Lighting.Ambient = Color3.fromRGB(255,255,255)
                    end
                    task.wait(0.5)
                end
            end)
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.Ambient = Color3.fromRGB(128,128,128)
        end
    end
})

-- No Fog
MainTab:Toggle({
    Title = "No Fog",
    Value = false,
    Callback = function(v)
        noFogEnabled = v
        if v then
            task.spawn(function()
                while noFogEnabled do
                    if Lighting:FindFirstChild("Atmosphere") then
                        if Lighting.Atmosphere.Density ~= 0 then
                            Lighting.Atmosphere.Density = 0
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            if Lighting:FindFirstChild("Atmosphere") then
                Lighting.Atmosphere.Density = 0.5
            end
        end
    end
})

-- ====================== PLAYER ======================
local speedEnabled, flyNoclipSpeed = false, 3
local speedConnection, noclipConnection

PlayerTab:Section({ Title = "Feature Player", Icon = "rabbit" })
PlayerTab:Slider({ Title = "Set Speed Value", Value={Min=1,Max=100,Default=4}, Step=1, Callback=function(val) flyNoclipSpeed=val end })

PlayerTab:Toggle({ Title = "Enable Speed", Value=false, Callback=function(v)
    speedEnabled=v
    if speedEnabled then
        if speedConnection then speedConnection:Disconnect() end
        speedConnection=RunService.RenderStepped:Connect(function()
            local char=LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.MoveDirection.Magnitude>0 then
                char.HumanoidRootPart.CFrame=char.HumanoidRootPart.CFrame+char.Humanoid.MoveDirection*flyNoclipSpeed*0.004
            end
        end)
    else
        if speedConnection then speedConnection:Disconnect() speedConnection=nil end
    end
end })

PlayerTab:Section({ Title = "Feature Power", Icon = "flame" })
PlayerTab:Toggle({ Title = "No Clip", Value=false, Callback=function(state)
    if state then
        noclipConnection=RunService.Stepped:Connect(function()
            local char=LocalPlayer.Character
            if char then
                for _,part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide=false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection=nil end
        local char=LocalPlayer.Character
        if char then
            for _,part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide=true end
            end
        end
    end
end })

local NoFallEnabled = false

PlayerTab:Toggle({
    Title = "No Fall (Beta)",
    Value = false,
    Callback = function(v)
        NoFallEnabled = v

        if NoFallEnabled then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local FallRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Fall")

                while NoFallEnabled do
                    local args = { -100 }
                    pcall(function()
                        FallRemote:FireServer(unpack(args))
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

-- 🔧 ตั้งค่าพื้นฐาน
local transparency = 0.95
local hitboxSize = 10
local hitboxEnabled = false
local hitboxConnection

Hitbox:Paragraph({
    Title = "Hitbox System (Killer Only)",
    Desc = "• Universal Killer Support\n• Precision Slash Modules\n• Optimized Range Handler",
    Image = "rbxassetid://104487529937663",
    ImageSize = 45,
    Locked = false
})

Hitbox:Section({ Title = "Feature Hitbox", Icon = "package" })

-- ⚙️ Input สำหรับ Transparency
Hitbox:Input({
    Title = "Set Transparency (Visible)",
    Value = tostring(transparency),
    Placeholder = "Transparency (Ex: 0.95)",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            transparency = math.clamp(num, 0, 1)
        else
            warn("Entered an incorrect number!")
        end
    end
})

-- ⚙️ Input สำหรับขนาด Hitbox
Hitbox:Input({
    Title = "Set Hitbox (Size)",
    Value = tostring(hitboxSize),
    Placeholder = "Range (Ex: 10)",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            hitboxSize = num
        else
            warn("Entered an incorrect number!")
        end
    end
})

-- 🟢 Toggle เปิด/ปิด Hitbox
Hitbox:Toggle({
    Title = "Enable Hitbox",
    Value = false,
    Callback = function(v)
        hitboxEnabled = v

        -- ถ้ามีการเชื่อมต่ออยู่แล้ว ให้หยุดก่อน
        if hitboxConnection then
            hitboxConnection:Disconnect()
            hitboxConnection = nil
        end

        if hitboxEnabled then
            hitboxConnection = game:GetService("RunService").RenderStepped:Connect(function()
                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local part = player.Character.HumanoidRootPart
                        pcall(function()
                            part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                            part.Transparency = transparency
                            part.BrickColor = BrickColor.new("Really red") -- 🔴 เปลี่ยนสีเป็นแดง
                            part.Material = Enum.Material.Neon
                            part.CanCollide = false
                        end)
                    end
                end
            end)
        else
            -- ปิด Hitbox คืนค่าปกติ
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local part = player.Character.HumanoidRootPart
                    pcall(function()
                        part.Size = Vector3.new(2, 2, 1)
                        part.Transparency = 1
                        part.Material = Enum.Material.Plastic
                    end)
                end
            end
        end
    end
})

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
