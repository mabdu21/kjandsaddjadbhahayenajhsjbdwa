-- Powered by GPT 5 v709
-- ======================
local version = "4.2.4"
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
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local Hitbox = Window:Tab({ Title = "Hitbox", Icon = "package" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })

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
local ShowPercent = true

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

-- ===== Generator Progress Functions =====
local function getGeneratorProgress(gen)
    local progress = 0
    if gen:GetAttribute("Progress") then
        progress = gen:GetAttribute("Progress")
    elseif gen:GetAttribute("RepairProgress") then
        progress = gen:GetAttribute("RepairProgress")
    else
        for _, child in ipairs(gen:GetDescendants()) do
            if child:IsA("NumberValue") or child:IsA("IntValue") then
                local n = child.Name:lower()
                if n:find("progress") or n:find("repair") or n:find("percent") then
                    progress = child.Value
                    break
                end
            end
        end
    end
    progress = (progress > 1) and progress / 100 or progress
    return math.clamp(progress, 0, 1)
end

-- สีแบบขาว -> เขียวอ่อน -> เขียวเข้ม
local function getProgressColor(percent)
    if percent < 0.5 then
        local t = percent / 0.5
        return Color3.fromRGB(255 - (255-153)*t, 255, 255 - (255-153)*t)
    else
        local t = (percent - 0.5) / 0.5
        return Color3.fromRGB(153 * (1-t), 255, 153 * (1-t))
    end
end

local function generatorFinished(gen)
    return getGeneratorProgress(gen) >= 0.99 or gen:FindFirstChild("Finished") or gen:FindFirstChild("Repaired")
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
						createESP(obj, COLOR_GENERATOR_DONE)
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

                    -- Generator Progress Display
                    if obj.Name == "Generator" and ShowPercent then
                        local progress = getGeneratorProgress(obj)
                        local percentText = string.format("%.0f%%", progress * 100)
                        data.nameLabel.Text = string.format("Generator | %s", percentText)
                        data.nameLabel.TextColor3 = getProgressColor(progress)
                    else
                        data.nameLabel.Text = obj.Name
                        data.nameLabel.TextColor3 = data.color
                    end
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
EspTab:Toggle({Title="Show Percent", Value=ShowPercent, Callback=function(v) ShowPercent=v end})

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
	    TWallUI = false,
		DragUI = false,
        Part = { "Head", "Torso", "HumanoidRootPart" },
        Target = { "Killer", "Survivor" },
        SelectedParts = { "Head" },
        SelectedTargets = { "Killer" },
        SetKeybindLock = "V",
        MobileButtonPosition = UDim2.new(1, -40, 1, -40)
    }
}

--// Variables
local AimbotEnabled = Settings.Aimbot.Enable
local CrosshairVisible = Settings.Aimbot.CrossHairUI
local AimbotToggleGUIVisible = Settings.Aimbot.EnableUI
local LockedTarget = nil
local LockPart = "Head"
local auraRange = 400
local KeybindLock = Enum.KeyCode.V

-- GUI References
local guiFolder, crosshair, mobileButton

--// Keybind Update
local function UpdateKeybind()
    local keyName = Settings.Aimbot.SetKeybindLock:gsub("%s+", ""):upper()
    local kc = Enum.KeyCode[keyName]
    if kc then
        KeybindLock = kc
        KeybindLockString = keyName
    end
end
UpdateKeybind()

----------------------------------------------------------
-- GUI SYSTEM (Auto Rebuild + Robust)
----------------------------------------------------------
local function CreateCrosshair()
    if crosshair then crosshair:Destroy() end
    crosshair = Instance.new("Frame")
    crosshair.Name = "Crosshair"
    crosshair.Size = UDim2.new(0, 5, 0, 5)
    crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
    crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
    crosshair.BackgroundColor3 = Color3.new(1, 1, 1)
    crosshair.BackgroundTransparency = 0.3
    crosshair.BorderSizePixel = 0
    crosshair.Visible = CrosshairVisible
    crosshair.ZIndex = 999
    crosshair.Parent = guiFolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = crosshair
end

local function CreateMobileButton()
    if mobileButton then mobileButton:Destroy() end
    mobileButton = Instance.new("TextButton")
    mobileButton.Name = "AimbotBTNForMB"
    mobileButton.Size = UDim2.new(0, 90, 0, 90)
    mobileButton.AnchorPoint = Vector2.new(1, 1)
    mobileButton.Position = UDim2.new(1, -40, 1, -40)
    mobileButton.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(60, 255, 60) or Color3.fromRGB(255, 60, 60)
    mobileButton.Text = "🎯"
    mobileButton.TextSize = 36
    mobileButton.TextColor3 = Color3.new(1, 1, 1)
    mobileButton.Font = Enum.Font.GothamBold
    mobileButton.Visible = AimbotToggleGUIVisible
    mobileButton.ZIndex = 999
    mobileButton.Parent = guiFolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mobileButton

    mobileButton.MouseButton1Click:Connect(function()
        AimbotEnabled = not AimbotEnabled
        Settings.Aimbot.Enable = AimbotEnabled
        if not AimbotEnabled then
            LockedTarget = nil
        else
            task.spawn(FindNearestTarget)
        end
        mobileButton.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(60, 255, 60) or Color3.fromRGB(255, 60, 60)
    end)
end

local function EnsureGui()
    if PlayerGui:FindFirstChild("เขมรกาก") then
        guiFolder = PlayerGui:FindFirstChild("เขมรกาก")
    else
        guiFolder = Instance.new("ScreenGui")
        guiFolder.Name = "เขมรกาก"
        guiFolder.ResetOnSpawn = false
        guiFolder.IgnoreGuiInset = true
        guiFolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        guiFolder.Parent = PlayerGui
    end

    if not crosshair or not crosshair.Parent then
        CreateCrosshair()
    end
    if not mobileButton or not mobileButton.Parent then
        CreateMobileButton()
    end

    -- Update visibility
    if crosshair then crosshair.Visible = CrosshairVisible end
    if mobileButton then mobileButton.Visible = AimbotToggleGUIVisible end
end

-- Initial GUI
EnsureGui()

task.spawn(function()
    while task.wait(1) do
        if guiFolder and guiFolder:IsA("ScreenGui") then
            if guiFolder.Enabled == false then
                guiFolder.Enabled = true
            end
        else
            EnsureGui()
        end
    end
end)

-- Auto-rebuild on character respawn or GUI deletion
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    EnsureGui()
end)

-- Monitor GUI deletion
task.spawn(function()
    while task.wait(1) do
        if not PlayerGui:FindFirstChild("เขมรกาก") then
            EnsureGui()
        end
    end
end)

----------------------------------------------------------
-- UI SETUP (ใช้กับ MainTab เดิม)
----------------------------------------------------------
MainTab:Dropdown({
    Title = "Select Target",
    Values = Settings.Aimbot.Target,
    Multi = false,
    Callback = function(value)
        Settings.Aimbot.SelectedTargets = {value}
    end
})

MainTab:Dropdown({
    Title = "Select Part",
    Values = Settings.Aimbot.Part,
    Multi = false,
    Callback = function(value)
        Settings.Aimbot.SelectedParts = {value}
        LockPart = value
    end
})

MainTab:Input({
    Title = "Set Distance Aimbot (Value)",
    Default = tostring(auraRange),
    Placeholder = "Distance (Ex: 400)",
    Callback = function(text)
        local num = tonumber(text)
        if num and num > 0 then
            auraRange = num
        else
            warn("Invalid distance!")
        end
    end
})

MainTab:Toggle({
    Title = "Enable Aimbot",
    Default = Settings.Aimbot.Enable,
    Callback = function(state)
        AimbotEnabled = state
        Settings.Aimbot.Enable = state
        if not state then
            LockedTarget = nil
        end
        if mobileButton then
            mobileButton.BackgroundColor3 = state and Color3.fromRGB(60, 255, 60) or Color3.fromRGB(255, 60, 60)
        end
    end
})

MainTab:Section({ Title = "Aimbot Setting", Icon = "settings" })

MainTab:Toggle({
    Title = "Enable Crosshair",
    Default = Settings.Aimbot.CrossHairUI,
    Callback = function(state)
        CrosshairVisible = state
        Settings.Aimbot.CrossHairUI = state
        if crosshair then crosshair.Visible = state end
    end
})

MainTab:Toggle({
    Title = "Enable Aimbot (Toggle GUI)",
    Default = Settings.Aimbot.EnableUI,
    Callback = function(state)
        AimbotToggleGUIVisible = state
        Settings.Aimbot.EnableUI = state
        if mobileButton then mobileButton.Visible = state end
    end
})

MainTab:Toggle({
    Title = "Tough Wall (Aimbot)",
    Default = Settings.Aimbot.TWallUI,
    Callback = function(state)
        ToughWallEnabled = state
        Settings.Aimbot.TWallUI = state
        print("[Aimbot] ToughWall set to", state)
    end
})

--// [FIXED & UPGRADED] PC Keybind System
local ContextActionService = game:GetService("ContextActionService")
local KEYBIND_ACTION_NAME = "AimbotPCKeybind"

local function UpdateKeybindAction()
    -- Remove old binding
    ContextActionService:UnbindAction(KEYBIND_ACTION_NAME)

    -- Get current key
    local keyName = Settings.Aimbot.SetKeybindLock:gsub("%s+", ""):upper()
    local keyCode = Enum.KeyCode[keyName]
    if not keyCode then
        warn("[Aimbot] Invalid keybind:", keyName)
        return
    end

    KeybindLock = keyCode

    -- Bind new key (works even in chat/UI)
    ContextActionService:BindAction(
        KEYBIND_ACTION_NAME,
        function(name, inputState, inputObject)
            if inputState == Enum.UserInputState.Begin and AimbotEnabled then
                if LockedTarget then
                    -- Already locked → unlock
                    LockedTarget = nil
                    print("[Aimbot] Unlocked target.")
                else
                    -- Find and lock nearest
                    local target = FindNearestTarget()
                    if target then
                        LockedTarget = target
                        print("[Aimbot] Locked onto:", target.DisplayName, "->", LockPart)
                    else
                        print("[Aimbot] No valid target in range.")
                    end
                end
                return Enum.ContextActionResult.Sink
            end
            return Enum.ContextActionResult.Pass
        end,
        false,
        keyCode
    )
end

-- Initial bind
UpdateKeybindAction()

MainTab:Input({
    Title = "Set Keybind Aimbot (PC ONLY)",
    Default = Settings.Aimbot.SetKeybindLock,
    Placeholder = "Lock (Ex: V)",
    Callback = function(text)
        local clean = text:gsub("%s+", ""):upper()
        if clean ~= "" and Enum.KeyCode[clean] then
            Settings.Aimbot.SetKeybindLock = clean
            UpdateKeybindAction()  -- Rebind immediately
            print("[Aimbot] Keybind updated to:", clean)
        else
            warn("[Aimbot] Invalid key:", text)
        end
    end
})

-- Optional: Auto-unbind on leave
Players.LocalPlayer.AncestryChanged:Connect(function()
    if not Players.LocalPlayer.Parent then
        ContextActionService:UnbindAction(KEYBIND_ACTION_NAME)
    end
end)

----------------------------------------------------------
-- AIMBOT CORE (1st & 3rd Person Support)
----------------------------------------------------------
local Camera = Workspace.CurrentCamera

local function GetCameraPosition()
    if Camera.CameraType == Enum.CameraType.Scriptable then
        return Camera.CFrame.Position
    else
        local head = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Head") or LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
        return head and head.Position or Camera.CFrame.Position
    end
end

local function IsTargetType(plr)
    if not plr.Character then return false end
    local hasWeapon = plr.Character:FindFirstChild("Weapon") ~= nil
    local isKiller = table.find(Settings.Aimbot.SelectedTargets, "Killer") and hasWeapon
    local isSurvivor = table.find(Settings.Aimbot.SelectedTargets, "Survivor") and not hasWeapon
    return isKiller or isSurvivor
end

local function IsValidTarget(plr)
    if not plr or plr == LocalPlayer or not plr.Character then return false end
    if not IsTargetType(plr) then return false end

    local char = plr.Character
    if not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then return false end

    -- skip low-health targets (do not aimbot if health <= 20)
    if char.Humanoid.Health <= 20 then
        return false
    end

    local root = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
    if not root then return false end

    local targetPart = nil
    for _, partName in ipairs(Settings.Aimbot.SelectedParts) do
        if char:FindFirstChild(partName) then
            targetPart = char[partName]
            break
        end
    end
    if not targetPart then return false end

    local distance = (targetPart.Position - root.Position).Magnitude
    if distance > auraRange then return false end

    -- Wall check
    if not ToughWallEnabled then
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, char}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = Workspace:Raycast(GetCameraPosition(), (targetPart.Position - GetCameraPosition()), rayParams)
        if result and result.Instance and not result.Instance:IsDescendantOf(char) then
            return false
        end
    end

    return true, targetPart
end

function FindNearestTarget()
    local root = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
    if not root then return nil end

    local closestPlayer = nil
    local closestDist = math.huge
    local bestPart = nil

    for _, plr in ipairs(Players:GetPlayers()) do
        local valid, part = IsValidTarget(plr)
        if valid then
            local dist = (part.Position - root.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestPlayer = plr
                bestPart = part.Name
            end
        end
    end

    if closestPlayer then
        LockPart = bestPart
        return closestPlayer
    end
    return nil
end

-- Main Aimbot Loop
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then
        LockedTarget = nil
        return
    end

    local cam = Workspace.CurrentCamera
    if not cam then return end

    local target = LockedTarget
    if not target or not IsValidTarget(target) then
        target = FindNearestTarget()
        LockedTarget = target
    end

    if target and target.Character and target.Character:FindFirstChild(LockPart) then
        local aimPart = target.Character[LockPart]
        local targetPos = aimPart.Position

        cam.CFrame = CFrame.new(cam.CFrame.Position, targetPos)
	end
end)

-- Auto-update crosshair position
RunService.Heartbeat:Connect(function()
    if crosshair and crosshair.Parent then
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
    end
end)

-- เพิ่มค่าใน Settings สำหรับบันทึกตำแหน่งล่าสุด
Settings.Aimbot.DragUI = false
Settings.Aimbot.MobileButtonPosition = UDim2.new(1, -40, 1, -40)

-- ตัวแปรสำหรับระบบลาก
local dragging = false
local dragStart, startPos
local dragConn, dragMoveConn

-- ฟังก์ชันเปิด/ปิดระบบลากปุ่ม
local function EnableDrag(state)
    if not mobileButton then return end

    -- ยกเลิกการเชื่อมต่อเดิมก่อน
    if dragConn then dragConn:Disconnect() end
    if dragMoveConn then dragMoveConn:Disconnect() end

    if state then
        -- เปิดระบบลาก
        dragConn = mobileButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = mobileButton.Position

                local function endDrag()
                    dragging = false
                    -- บันทึกตำแหน่งล่าสุดไว้ใน Settings
                    Settings.Aimbot.MobileButtonPosition = mobileButton.Position
                end

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        endDrag()
                    end
                end)
            end
        end)

        dragMoveConn = UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                local newPos = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
                mobileButton.Position = newPos
            end
        end)
    else
        -- ปิดโหมดลาก -> เก็บตำแหน่งล่าสุดไว้
        Settings.Aimbot.MobileButtonPosition = mobileButton.Position
    end
end

-- เมื่อ GUI ถูกสร้าง ให้ใช้ตำแหน่งที่ผู้ใช้ตั้งไว้ล่าสุด
task.spawn(function()
    repeat task.wait() until mobileButton
    mobileButton.Position = Settings.Aimbot.MobileButtonPosition or UDim2.new(1, -40, 1, -40)
end)

-- เพิ่ม Toggle เพื่อเปิด/ปิดระบบลาก
MainTab:Toggle({
    Title = "Custom Position Drag (Toggle GUI)",
    Default = Settings.Aimbot.DragUI,
    Callback = function(state)
        Settings.Aimbot.DragUI = state
        EnableDrag(state)
    end
})

-- ========== Auto-Collect =============

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- CONFIG
local SAFEZONE_HEIGHT = 500
local ACTION_DELAY = 1.55
local CHECK_INTERVAL = 5 -- วินาทีที่ใช้เช็ค Pumpkin ใหม่ตอนหมดแล้ว

local CPumkin = false
local collected = {}
local collecting = false

-- 🧱 สร้าง Safe Zone
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

local safeZone = Workspace:FindFirstChild("DYHUB | SAFEZONE") or createSafeZone()

-- 🧭 Helper Functions
local function getRoot()
	local character = LocalPlayer.Character
	if not character then return nil end
	return character:FindFirstChild("HumanoidRootPart")
end

local function waitForCharacter()
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.CharacterAdded:Wait()
		repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	end
end

local function getPumpkinPart(pumpkin)
	if not pumpkin then return nil end
	if pumpkin:IsA("BasePart") then return pumpkin end
	if pumpkin:IsA("Model") then
		return pumpkin.PrimaryPart or pumpkin:FindFirstChildWhichIsA("BasePart")
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

-- 🎃 ค้นหา Pumpkin ทั้งหมดใน Map และ Rooftop
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

-- 🔁 ระบบเก็บ Pumpkin อัตโนมัติ
local function autoCollectPumpkins()
	if collecting then return end
	collecting = true

	task.spawn(function()
		while CPumkin do
			waitForCharacter()

			local pumpkins = getPumpkins()
			if #pumpkins == 0 then
				print("[🎃] No pumpkins found. Waiting for respawn...")
				teleportTo(safeZone)
				task.wait(CHECK_INTERVAL)
			else
				for _, pumpkin in ipairs(pumpkins) do
					if not CPumkin then break end
					waitForCharacter()

					local pumpkinPart = getPumpkinPart(pumpkin)
					if pumpkinPart then
						teleportTo(pumpkinPart)
						task.wait(0.05)

						local HB = pumpkin:FindFirstChild("HB")
						if HB then
							ReplicatedStorage.Remotes.Events.Halloween.Crush:FireServer(HB)
						end

						collected[pumpkin] = true
						task.wait(ACTION_DELAY)
					end
				end
			end

			task.wait(0.3)
		end
		collecting = false
	end)
end

-- 🧠 GUI Integration (Toggle)
MainTab:Section({ Title = "Feature Farm", Icon = "candy" })
MainTab:Toggle({
	Title = "Auto Collect Pumpkin (Safe Zone)",
	Value = false,
	Callback = function(v)
		CPumkin = v
		if v then
			print("[🎃] Auto Pumpkin started. Will continue until stopped.")
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
    Title = "Bypass Gate (Open Gate)",
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
    Title = "Auto Parry (DONT USE IN DEV)",
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

SurTab:Section({ Title = "Feature Generator", Icon = "zap" })

local UserInputService = game:GetService("UserInputService")

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
                local player = Players.LocalPlayer
                local playerGui = player:WaitForChild("PlayerGui")

                local skillRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("SkillCheckResultEvent")
                local repairRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("RepairEvent")

                local lastGenPoint = nil
                local lastGenModel = nil
                local lastPosition = nil
                local stationaryThreshold = 2
                local cancelCooldown = 0.2

                -- 🧠 หา GeneratorPoint ที่ใกล้ที่สุด
                local function getClosestGeneratorPoint(root)
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
                    return closestGen, closestPoint, closestDist
                end

                -- 🔄 Loop หลัก
                while autoGeneratorEnabledtest do
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")

                    if root then
                        local genModel, genPoint, dist = getClosestGeneratorPoint(root)

                        if not lastGenPoint and genPoint and dist < 6 then
                            lastGenModel = genModel
                            lastGenPoint = genPoint
                        end

                        -- ตรวจการเคลื่อนที่
                        local moved = lastPosition and (root.Position - lastPosition).Magnitude or 0
                        local cancelDetected = false

if UserInputService.KeyboardEnabled then
    -- ตรวจจับปุ่มเดิน
    local keysPressed = {
        Enum.KeyCode.W, Enum.KeyCode.A,
        Enum.KeyCode.S, Enum.KeyCode.D
    }

    for _, key in ipairs(keysPressed) do
        if UserInputService:IsKeyDown(key) then
            cancelDetected = true
            break
        end
    end
end

-- ตรวจจับคลิกซ้าย ขวา (แทน MouseButton4/5)
if UserInputService.MouseEnabled then
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        cancelDetected = true
    end
								end
								

                        -- ถ้าเดินเกิน threshold หรือกด input ให้ cancel
                        if moved > stationaryThreshold or cancelDetected then
                            if lastGenPoint then
                                repairRemote:FireServer(lastGenPoint, false)
                                task.wait(cancelCooldown)
                                lastGenPoint = nil
                                lastGenModel = nil
                            end
                        end

                        lastPosition = root.Position

                        -- 🎯 Auto Perfect SkillCheck
                        local gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                        if gui then
                            local check = gui:FindFirstChild("Check")
                            if check and check.Visible and lastGenModel and lastGenPoint then
                                local args = { "success", 1, lastGenModel, lastGenPoint }
                                skillRemote:FireServer(unpack(args))
                                check.Visible = false
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})

-- ===============================================
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
                local player = Players.LocalPlayer
                local playerGui = player:WaitForChild("PlayerGui")

                local skillRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("SkillCheckResultEvent")
                local repairRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("RepairEvent")

                local lastGenPoint = nil
                local lastGenModel = nil
                local lastPosition = nil
                local stationaryThreshold = 2
                local cancelCooldown = 0.2

                local function getClosestGeneratorPoint(root)
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
                    return closestGen, closestPoint, closestDist
                end

                while autoGeneratorEnabled do
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")

                    if root then
                        local genModel, genPoint, dist = getClosestGeneratorPoint(root)

                        if not lastGenPoint and genPoint and dist < 6 then
                            lastGenModel = genModel
                            lastGenPoint = genPoint
                        end

                        local moved = lastPosition and (root.Position - lastPosition).Magnitude or 0
                        local cancelDetected = false

if UserInputService.KeyboardEnabled then
    -- ตรวจจับปุ่มเดิน
    local keysPressed = {
        Enum.KeyCode.W, Enum.KeyCode.A,
        Enum.KeyCode.S, Enum.KeyCode.D
    }

    for _, key in ipairs(keysPressed) do
        if UserInputService:IsKeyDown(key) then
            cancelDetected = true
            break
        end
    end
end

-- ตรวจจับคลิกซ้าย ขวา (แทน MouseButton4/5)
if UserInputService.MouseEnabled then
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        cancelDetected = true
    end
								end
								

                        if moved > stationaryThreshold or cancelDetected then
                            if lastGenPoint then
                                repairRemote:FireServer(lastGenPoint, false)
                                task.wait(cancelCooldown)
                                lastGenPoint = nil
                                lastGenModel = nil
                            end
                        end

                        lastPosition = root.Position

                        local gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                        if gui then
                            local check = gui:FindFirstChild("Check")
                            if check and check.Visible and lastGenModel and lastGenPoint then
                                local args = { "neutral", 0, lastGenModel, lastGenPoint }
                                skillRemote:FireServer(unpack(args))
                                check.Visible = false
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})

SurTab:Section({ Title = "Feature Exit", Icon = "door-open" })

local autoLeverEnabled = false

SurTab:Toggle({
    Title = "Auto Lever (No Hold)",
    Value = false,
    Callback = function(v)
        autoLeverEnabled = v
        if autoLeverEnabled then
            task.spawn(function()
                local Players = game:GetService("Players")
                local RunService = game:GetService("RunService")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Exit"):WaitForChild("LeverEvent")
                local player = Players.LocalPlayer
                local humanoid
                local root
                local lastPosition

                while autoLeverEnabled do
                    local char = player.Character
                    root = char and char:FindFirstChild("HumanoidRootPart")
                    humanoid = char and char:FindFirstChildOfClass("Humanoid")

                    if root and humanoid then
                        -- หา Gate ที่ใกล้ที่สุด
                        local closestGate, closestMain, shortestDist
                        local folders = getMapFolders()

                        for _, folder in ipairs(folders) do
                            local gate = folder:FindFirstChild("Gate")
                            if gate and gate:FindFirstChild("ExitLever") then
                                local main = gate.ExitLever:FindFirstChild("Main")
                                if main then
                                    local dist = (root.Position - main.Position).Magnitude
                                    if not shortestDist or dist < shortestDist then
                                        shortestDist = dist
                                        closestGate = gate
                                        closestMain = main
                                    end
                                end
                            end
                        end

                        -- ตรวจจับการเคลื่อนไหว
                        if lastPosition and (root.Position - lastPosition).Magnitude > 1 then
                            -- เดินหรือขยับ
                            if closestMain then
                                remote:FireServer(closestMain, false)
                            end
                        else
                            -- ถ้าอยู่ใกล้พอ และไม่ขยับ
                            if closestMain and shortestDist <= 10 then
                                remote:FireServer(closestMain, true)
                            end
                        end

                        lastPosition = root.Position
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

SurTab:Section({ Title = "Feature Heal", Icon = "cross" })

-- Auto Heal
local autoHealEnabled = false
SurTab:Toggle({
    Title = "Auto SkillCheck (DONT USE IT TESTING)",
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
                                SkillCheckResultEvent:FireServer("fail", 50, closestPlayer.Name or player.Name)
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

local destroyPalletwrong = false

local function removePalletwrong(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("Model") and child.Name == "Palletwrong" then
            child:Destroy()
        else
            removePalletwrong(child)
        end
    end
end

killerTab:Toggle({
    Title = "Remove Palletwrong (All)",
    Value = false,
    Callback = function(v)
        destroyPalletwrong = v
        if destroyPalletwrong then
            task.spawn(function()
                while destroyPalletwrong do
                    removePalletwrong(workspace)
                    task.wait(0.69)
                end
            end)
        end
    end
})

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

MainTab:Section({ Title = "Misc", Icon = "settings" })
local AntiAFK = false
MainTab:Toggle({
    Title = "Anti AFK",
    Default = false,
    Callback = function(state)
        AntiAFK = state
        task.spawn(function()
            local vu = game:GetService("VirtualUser")
            while AntiAFK do
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(math.random(150,270))
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(math.random(150,270))
            end
        end)
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


-- =============== IDK ===============

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Config
local LOBBY_POSITION = Vector3.new(653.552002, 684.317444, 1577.81934)
local SAFE_DISTANCE_FROM_LOBBY = 50 -- Pumpkin ใกล้ Lobby จะถูกละเว้น
local TELEPORT_OFFSET = 10 -- ระยะห่างจากวัตถุเวลา teleport

-- ==============================
-- Helper Functions
-- ==============================

-- หา Generator ทุกอันใน Workspace
local function getAllGenerators()
    local list = {}
    local nameCount = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "Generator" and (obj:IsA("Model") or obj:IsA("BasePart")) then
            local baseName = "Generator"
            nameCount[baseName] = (nameCount[baseName] or 0) + 1
            local displayName = baseName .. " " .. nameCount[baseName]
            table.insert(list, {Name = displayName, Object = obj})
        end
    end
    return list
end

-- หา Pumpkin ทุกอันใน Workspace แต่ละเว้นใกล้ Lobby และ Decorations
local function getAllPumpkins()
    local list = {}
    local nameCount = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsDescendantOf(Workspace.Lobby.Decorations) then
            continue
        end

        if obj.Name:match("^Pumpkin") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            local part
            if obj:IsA("Model") then
                part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            else
                part = obj
            end
            if part then
                local dist = (part.Position - LOBBY_POSITION).Magnitude
                if dist > SAFE_DISTANCE_FROM_LOBBY then
                    local baseName = "Pumpkin"
                    nameCount[baseName] = (nameCount[baseName] or 0) + 1
                    local displayName = baseName .. " " .. nameCount[baseName]
                    table.insert(list, {Name = displayName, Object = obj})
                end
            end
        end
    end
    return list
end

-- คืนค่า CFrame ของ object
local function getCFrame(obj)
    if obj:IsA("BasePart") then
        return obj.CFrame
    elseif obj:IsA("Model") then
        return obj.PrimaryPart and obj.PrimaryPart.CFrame or obj:FindFirstChildWhichIsA("BasePart") and obj:FindFirstChildWhichIsA("BasePart").CFrame
    end
    return nil
end

-- ตรวจสอบตำแหน่งก่อนวาร์ป (ไม่ชนสิ่งกีดขวาง)
local function safeCFrame(baseCFrame, directionVector)
    local offset = directionVector.Unit * TELEPORT_OFFSET
    local targetPos = baseCFrame.Position + offset

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local ray = Workspace:Raycast(baseCFrame.Position, offset, rayParams)
    if ray then
        -- มีสิ่งกีดขวาง → ปรับ Y ให้สูงขึ้น 5 studs
        return CFrame.new(targetPos.X, ray.Position.Y + 5, targetPos.Z)
    else
        return CFrame.new(targetPos)
    end
end

-- ==============================
-- Map Structure
-- ==============================
local map = {
    teleport = {
        Map = {
            Lobby = CFrame.new(653.552002, 684.317444, 1577.81934),
            Game = "PlayerWithWeapon"
        },
        Generator = {}, -- จะ fill ด้วย getAllGenerators()
        Pumpkin = {}   -- จะ fill ด้วย getAllPumpkins()
    }
}

-- ==============================
-- Teleport: Map
-- ==============================
TeleportTab:Section({ Title = "Teleport: Place", Icon = "map" })

local Teleport
TeleportTab:Dropdown({
    Title = "Select Place",
    Values = { "Lobby", "Game" },
    Multi = false,
    Callback = function(value)
        Teleport = value
    end
})

TeleportTab:Button({
    Title = "Teleport",
    Callback = function()
        if Teleport == "Lobby" then
            LocalPlayer.Character:PivotTo(map.teleport.Map.Lobby)
        elseif Teleport == "Game" then
            local targetPlayer
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Weapon") then
                    targetPlayer = p
                    break
                end
            end

            if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
                local targetCFrame = targetPlayer.Character.PrimaryPart.CFrame
                local offsetDistance = 200

                local direction = (LocalPlayer.Character.PrimaryPart.Position - targetCFrame.Position).Unit
                local desiredPos = targetCFrame.Position + direction * offsetDistance
                local desiredCFrame = CFrame.new(desiredPos.X, targetCFrame.Position.Y, desiredPos.Z)

                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                local ray = Workspace:Raycast(targetCFrame.Position, (desiredPos - targetCFrame.Position), rayParams)
                if ray then
                    desiredCFrame = CFrame.new(desiredPos.X, ray.Position.Y + 5, desiredPos.Z)
                end

                LocalPlayer.Character:PivotTo(desiredCFrame)
            else
                warn("[Teleport] No player with Weapon found!")
            end
        end
    end
})

-- ==============================
-- Teleport: Generator
-- ==============================
local generatorList = getAllGenerators()

local function refreshGenerators()
    generatorList = getAllGenerators()
    local values = {}
    for _, g in ipairs(generatorList) do
        table.insert(values, g.Name)
    end
    GeneratorDropdown:Update(values)
    Teleport = nil
end

TeleportTab:Section({ Title = "Teleport: Generator", Icon = "zap" })

local GeneratorDropdown = TeleportTab:Dropdown({
    Title = "Select Generator",
    Values = (function() local t={} for _,g in ipairs(generatorList) do table.insert(t,g.Name) end return t end)(),
    Multi = false,
    Callback = function(value)
        for _, g in ipairs(generatorList) do
            if g.Name == value then
                Teleport = g.Object
                break
            end
        end
    end
})

-- เลือกทิศทางวาร์ป
local TeleportDirection = "Front"
TeleportTab:Dropdown({
    Title = "Teleport Direction (D: Front)",
    Values = { "Front", "Back", "Left", "Right" },
    Multi = false,
    Callback = function(value)
        TeleportDirection = value
    end
})

TeleportTab:Button({
    Title = "Teleport",
    Callback = function()
        if Teleport then
            local cframe = getCFrame(Teleport)
            if cframe then
                local dirVector
                if TeleportDirection == "Front" then
                    dirVector = cframe.LookVector
                elseif TeleportDirection == "Back" then
                    dirVector = -cframe.LookVector
                elseif TeleportDirection == "Left" then
                    dirVector = -cframe.RightVector
                elseif TeleportDirection == "Right" then
                    dirVector = cframe.RightVector
                else
                    dirVector = cframe.LookVector
                end

                local safeCF = safeCFrame(cframe, dirVector)
                LocalPlayer.Character:PivotTo(safeCF)
            else
                warn("[Teleport] Cannot get CFrame from selected Generator!")
            end
        else
            warn("[Teleport] No Generator selected!")
        end
    end
})

TeleportTab:Button({
    Title = "Refresh Generators",
    Callback = refreshGenerators
})

-- ==============================
-- Teleport: Pumpkin
-- ==============================
local pumpkinList = getAllPumpkins()

local function refreshPumpkins()
    pumpkinList = getAllPumpkins()
    local values = {}
    for _, p in ipairs(pumpkinList) do
        table.insert(values, p.Name)
    end
    PumpkinDropdown:Update(values)
    Teleport = nil
end

TeleportTab:Section({ Title = "Teleport: Pumpkin", Icon = "candy" })

local PumpkinDropdown = TeleportTab:Dropdown({
    Title = "Select Pumpkin",
    Values = (function() local t={} for _,p in ipairs(pumpkinList) do table.insert(t,p.Name) end return t end)(),
    Multi = false,
    Callback = function(value)
        for _, p in ipairs(pumpkinList) do
            if p.Name == value then
                Teleport = p.Object
                break
            end
        end
    end
})

TeleportTab:Button({
    Title = "Teleport",
    Callback = function()
        if Teleport then
            local cframe = getCFrame(Teleport)
            if cframe then
                LocalPlayer.Character:PivotTo(cframe)
            else
                warn("[Teleport] Cannot get CFrame from selected Pumpkin!")
            end
        else
            warn("[Teleport] No Pumpkin selected!")
        end
    end
})

TeleportTab:Button({
    Title = "Refresh Pumpkins",
    Callback = refreshPumpkins
})

-- ==============================
-- Refresh All
-- ==============================
TeleportTab:Section({ Title = "Teleport Setting", Icon = "settings" })

TeleportTab:Button({
    Title = "Refresh All",
    Callback = function()
        refreshGenerators()
        refreshPumpkins()
    end
})

-- ============= DISCORD ================= 

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

-- hi
