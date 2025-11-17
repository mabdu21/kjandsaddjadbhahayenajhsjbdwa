-- Powered by GPT 5 | v778
-- ======================
local version = "DEV"
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
local MainTab = Window:Tab({ Title = "Test", Icon = "crown" })

MainTab:Section({ Title = "Feature Aimbot", Icon = "target" })

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
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
        MobileButtonPosition = UDim2.new(1, -40, 1, -40),
        Mode = { "Normal", "The Veil" },
        SelectedMode = { "Normal" },
        MIN_PITCH = -1,
        MAX_PITCH = 15,
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
local ToughWallEnabled = Settings.Aimbot.TWallUI

-- GUI References
local guiFolder, crosshair, mobileButton

----------------------------------------------------------
-- GUI SYSTEM
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
    mobileButton.Position = Settings.Aimbot.MobileButtonPosition
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

    if crosshair then crosshair.Visible = CrosshairVisible end
    if mobileButton then mobileButton.Visible = AimbotToggleGUIVisible end
end

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

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    EnsureGui()
end)

task.spawn(function()
    while task.wait(1) do
        if not PlayerGui:FindFirstChild("เขมรกาก") then
            EnsureGui()
        end
    end
end)

----------------------------------------------------------
-- GUI SETUP (MainTab)
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

----------------------------------------------------------
-- MODE SYSTEM (Normal / The Veil)
----------------------------------------------------------
MainTab:Dropdown({
    Title = "Select Mode",
    Values = Settings.Aimbot.Mode,
    Multi = false,
    Callback = function(value)
        Settings.Aimbot.SelectedMode = {value}
    end
})

MainTab:Input({
    Title = "Set Pitch Min (Value)",
    Default = tostring(Settings.Aimbot.MIN_PITCH),
    Placeholder = "Default (Ex: -1)",
    Callback = function(text)
        local num = tonumber(text)
        if num then Settings.Aimbot.MIN_PITCH = num end
    end
})

MainTab:Input({
    Title = "Set Pitch Max (Value)",
    Default = tostring(Settings.Aimbot.MAX_PITCH),
    Placeholder = "Default (Ex: 15)",
    Callback = function(text)
        local num = tonumber(text)
        if num then Settings.Aimbot.MAX_PITCH = num end
    end
})

----------------------------------------------------------
-- KEYBIND SYSTEM
----------------------------------------------------------
local KEYBIND_ACTION_NAME = "AimbotPCKeybind"

local function UpdateKeybindAction()
    ContextActionService:UnbindAction(KEYBIND_ACTION_NAME)
    local keyName = Settings.Aimbot.SetKeybindLock:gsub("%s+", ""):upper()
    local keyCode = Enum.KeyCode[keyName]
    if not keyCode then return end
    KeybindLock = keyCode

    ContextActionService:BindAction(
        KEYBIND_ACTION_NAME,
        function(name, inputState, inputObject)
            if inputState == Enum.UserInputState.Begin and AimbotEnabled then
                if LockedTarget then
                    LockedTarget = nil
                    print("[Aimbot] Unlocked target.")
                else
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

UpdateKeybindAction()

MainTab:Input({
    Title = "Set Keybind Aimbot (PC ONLY)",
    Default = Settings.Aimbot.SetKeybindLock,
    Placeholder = "Lock (Ex: V)",
    Callback = function(text)
        local clean = text:gsub("%s+", ""):upper()
        if clean ~= "" and Enum.KeyCode[clean] then
            Settings.Aimbot.SetKeybindLock = clean
            UpdateKeybindAction()
            print("[Aimbot] Keybind updated to:", clean)
        else
            warn("[Aimbot] Invalid key:", text)
        end
    end
})

Players.LocalPlayer.AncestryChanged:Connect(function()
    if not Players.LocalPlayer.Parent then
        ContextActionService:UnbindAction(KEYBIND_ACTION_NAME)
    end
end)

----------------------------------------------------------
-- DRAG MOBILE BUTTON
----------------------------------------------------------
local dragging = false
local dragStart, startPos
local dragConn, dragMoveConn

local function EnableDrag(state)
    if not mobileButton then return end
    if dragConn then dragConn:Disconnect() end
    if dragMoveConn then dragMoveConn:Disconnect() end

    if state then
        dragConn = mobileButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = mobileButton.Position
                local function endDrag()
                    dragging = false
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
        Settings.Aimbot.MobileButtonPosition = mobileButton.Position
    end
end

MainTab:Toggle({
    Title = "Custom Position Drag (Toggle GUI)",
    Default = Settings.Aimbot.DragUI,
    Callback = function(state)
        Settings.Aimbot.DragUI = state
        EnableDrag(state)
    end
})

task.spawn(function()
    repeat task.wait() until mobileButton
    mobileButton.Position = Settings.Aimbot.MobileButtonPosition or UDim2.new(1, -40, 1, -40)
end)

----------------------------------------------------------
-- AIMBOT FUNCTIONS
----------------------------------------------------------
local function GetCameraPosition()
    if Workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        return Workspace.CurrentCamera.CFrame.Position
    else
        local head = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Head") or LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
        return head and head.Position or Workspace.CurrentCamera.CFrame.Position
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
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if humanoid.Health <= 20 then return false end
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

local function PredictPosition(targetPart, distance)
    local hrp = targetPart.Parent:FindFirstChild("HumanoidRootPart")
    if not hrp then return targetPart.Position end
    local velocity = hrp.Velocity
    local ping = 0.12
    local prediction = velocity * ping
    local pitchFactor = math.clamp(distance / 50, Settings.Aimbot.MIN_PITCH, Settings.Aimbot.MAX_PITCH)
    return targetPart.Position + Vector3.new(prediction.X, prediction.Y + pitchFactor, prediction.Z)
end

----------------------------------------------------------
-- MAIN AIMBOT LOOP
----------------------------------------------------------
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
        local mode = Settings.Aimbot.SelectedMode[1]

        if mode == "Normal" then
            cam.CFrame = CFrame.new(cam.CFrame.Position, targetPos)
        elseif mode == "The Veil" then
            local distance = (aimPart.Position - cam.CFrame.Position).Magnitude
            local predicted = PredictPosition(aimPart, distance)
            cam.CFrame = CFrame.new(cam.CFrame.Position, predicted)
        end
    end
end)

-- Auto-update crosshair position
RunService.Heartbeat:Connect(function()
    if crosshair and crosshair.Parent then
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
    end
end)
