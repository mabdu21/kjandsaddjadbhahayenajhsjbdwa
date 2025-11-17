-- Powered by GPT 5 | v791
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
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ====================== WINDOW ======================
local FreeVersion = "Free Version"
local PremiumVersion = "Premium Version"

local function checkVersion(playerName)
    local url = "https://raw.githubusercontent.com/mabdu21/2askdkn21h3u21ddaa/refs/heads/main/Main/Premium/listpremium.lua"
    local success, response = pcall(function() return game:HttpGet(url) end)
    if not success then return FreeVersion end
    local premiumData
    local func, err = loadstring(response)
    if func then premiumData = func() else return FreeVersion end
    if premiumData[playerName] then return PremiumVersion else return FreeVersion end
end

local userversion = checkVersion(LocalPlayer.Name)

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

-------------------------------------------------------
-- Aimbot Config
-------------------------------------------------------
local AimbotEnabled = false
local LockedTarget = nil
local CloseDistance = 10
local PredictionTime = 0.14
local MIN_DISTANCE = 1
local MAX_DISTANCE = 250
local MIN_PITCH = -1
local MAX_PITCH = 15
local LOW_HP_IGNORE = 20
local ToughWall = false

local AimbotToggleGUIVisible2 = false
local crosshair, mobileButton, guiFolder

-- PC Keybind
local Settings = {
    Aimbot = { 
        DragUI = false, 
        MobileButtonPosition = UDim2.new(1, -40, 1, -40),
        SetKeybindLock = "Z"
    }
}

-------------------------------------------------------
-- GUI Section
-------------------------------------------------------
MainTab:Section({ Title = "Killer: The Veil", Icon = "target" })
MainTab:Toggle({
    Title = "Enable Aimbot (The Veil)",
    Default = false,
    Callback = function(state)
        AimbotEnabled = state
        if not state then LockedTarget = nil end
    end
})

MainTab:Section({ Title = "Killer: The Veil Setting", Icon = "settings" })
MainTab:Input({
    Title = "Set Pitch Min (Value)",
    Default = tostring(MIN_PITCH),
    Placeholder = "Default (Ex: -1)",
    Callback = function(text)
        local num = tonumber(text)
        if num then MIN_PITCH = num end
    end
})
MainTab:Input({
    Title = "Set Pitch Max (Value)",
    Default = tostring(MAX_PITCH),
    Placeholder = "Default (Ex: 15)",
    Callback = function(text)
        local num = tonumber(text)
        if num then MAX_PITCH = num end
    end
})

MainTab:Toggle({
    Title = "Enable Aimbot (Toggle GUI)",
    Default = AimbotToggleGUIVisible2,
    Callback = function(state)
        AimbotToggleGUIVisible2 = state
    end
})

-- NEW: Toggle Tough Wall
MainTab:Toggle({
    Title = "Tough Wall (The Veil)",
    Default = false,
    Callback = function(state)
        ToughWall = state
    end
})

-- NEW: PC Keybind
MainTab:Input({
    Title = "Set Keybind Aimbot (PC ONLY)",
    Default = Settings.Aimbot.SetKeybindLock,
    Placeholder = "Lock (Ex: Z)",
    Callback = function(text)
        if typeof(text) == "string" and #text == 1 then
            Settings.Aimbot.SetKeybindLock = string.upper(text)
        end
    end
})

-------------------------------------------------------
-- FUNCTIONS
-------------------------------------------------------
local function GetLocalRoot()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function HP_OK(plr)
    local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
    return hum and hum.Health > LOW_HP_IGNORE
end

local function GetClosestInScreen()
    local closest = nil
    local minDist = math.huge
    local mouse = UserInputService:GetMouseLocation()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and HP_OK(plr) then
            local head = plr.Character:FindFirstChild("Head")
            local pos, visible = Camera:WorldToViewportPoint(head.Position)
            if visible then
                local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

local function GetClosestByDistance()
    local root = GetLocalRoot()
    if not root then return nil end
    local closest, distMin = nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and HP_OK(plr) then
            local r = plr.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local dist = (root.Position - r.Position).Magnitude
                if dist < distMin then
                    distMin = dist
                    closest = plr
                end
            end
        end
    end
    return closest, distMin
end

local function TargetAlive()
    if not LockedTarget then return false end
    if not LockedTarget.Character then return false end
    local h = LockedTarget.Character:FindFirstChild("Humanoid")
    return h and h.Health > LOW_HP_IGNORE
end

-- NEW: Raycast Check for Tough Wall
local function CanSeeTarget(target)
    if ToughWall then
        return true
    end

    if not target.Character then return false end
    local head = target.Character:FindFirstChild("Head")
    local root = GetLocalRoot()
    if not head or not root then return false end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { LocalPlayer.Character, target.Character }

    local result = workspace:Raycast(root.Position, (head.Position - root.Position), params)

    if result then
        return false
    end

    return true
end

local function AimAt(target)
    if not target.Character then return end
    local head = target.Character:FindFirstChild("Head")
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    local localRoot = GetLocalRoot()
    if not head or not hrp or not localRoot then return end

    local velocity = hrp.Velocity
    local predictedPos = head.Position + (velocity * PredictionTime)

    local distance = (localRoot.Position - predictedPos).Magnitude
    local alpha = math.clamp((distance - MIN_DISTANCE) / (MAX_DISTANCE - MIN_DISTANCE), 0, 1)
    local pitch = MIN_PITCH + (MAX_PITCH - MIN_PITCH) * alpha

    local dir = (predictedPos - Camera.CFrame.Position).Unit
    local yaw = math.atan2(dir.X, dir.Z)
    local pitchRad = math.rad(pitch)
    local newLook = Vector3.new(
        math.sin(yaw) * math.cos(pitchRad),
        math.sin(pitchRad),
        math.cos(yaw) * math.cos(pitchRad)
    )

    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + newLook)
end

-------------------------------------------------------
-- MOBILE GUI FUNCTIONS
-------------------------------------------------------
local dragging, dragStart, startPos, dragConn, dragMoveConn

local function CreateMobileButton()
    if mobileButton then mobileButton:Destroy() end
    mobileButton = Instance.new("TextButton")
    mobileButton.Name = "AimbotBTNForVEIL"
    mobileButton.Size = UDim2.new(0, 90, 0, 90)
    mobileButton.AnchorPoint = Vector2.new(1,1)
    mobileButton.Position = Settings.Aimbot.MobileButtonPosition
    mobileButton.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60)
    mobileButton.Text = "🗡️"
    mobileButton.TextSize = 36
    mobileButton.TextColor3 = Color3.new(1,1,1)
    mobileButton.Font = Enum.Font.GothamBold
    mobileButton.Visible = AimbotToggleGUIVisible2
    mobileButton.ZIndex = 999
    mobileButton.Parent = guiFolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,20)
    corner.Parent = mobileButton

    mobileButton.MouseButton1Click:Connect(function()
        AimbotEnabled = not AimbotEnabled
        LockedTarget = AimbotEnabled and LockedTarget or nil
        mobileButton.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60)
    end)
end

local function EnableDrag(state)
    if not mobileButton then return end
    if dragConn then dragConn:Disconnect() end
    if dragMoveConn then dragMoveConn:Disconnect() end
    dragging = false

    if state then
        dragConn = mobileButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = mobileButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        Settings.Aimbot.MobileButtonPosition = mobileButton.Position
                    end
                end)
            end
        end)

        dragMoveConn = UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                mobileButton.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    else
        Settings.Aimbot.MobileButtonPosition = mobileButton.Position
    end
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
    CreateMobileButton()
end

EnsureGui()
EnableDrag(Settings.Aimbot.DragUI)

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

MainTab:Toggle({
    Title = "Custom Position Drag (Toggle GUI)",
    Default = Settings.Aimbot.DragUI,
    Callback = function(state)
        Settings.Aimbot.DragUI = state
        EnableDrag(state)
    end
})

-------------------------------------------------------
-- Keybind Toggle (PC)
-------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode.Name == Settings.Aimbot.SetKeybindLock then
            AimbotEnabled = not AimbotEnabled
            if not AimbotEnabled then
                LockedTarget = nil
            end

            if mobileButton then
                mobileButton.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60)
            end
        end
    end
end)

-------------------------------------------------------
-- MAIN LOOP
-------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end

    local root = GetLocalRoot()
    if not root then return end

    local closePlr, dist = GetClosestByDistance()
    if closePlr and dist <= CloseDistance then
        LockedTarget = closePlr
    end

    if not TargetAlive() then
        LockedTarget = GetClosestInScreen()
    end

    if LockedTarget and CanSeeTarget(LockedTarget) then
        AimAt(LockedTarget)
    end
end)
