-- Powered by GPT 5 | v717
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

-- // Aimbot FULL SYSTEM (Prediction + Distance Pitch + Tough Wall + Weapon Check)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-------------------------------------------------------
-- CONFIG
-------------------------------------------------------
local AimbotEnabled = false
local LockedTarget = nil
local CloseDistance = 10
local PredictionTime = 0.14

local MIN_DISTANCE = 1
local MAX_DISTANCE = 250
local MIN_PITCH = -1
local MAX_PITCH = 15

-- NEW SYSTEM
local ToughWall = false     -- aimlock ทะลุกำแพง
-------------------------------------------------------

-------------------------------------------------------
-- CHECK OUR WEAPON
-------------------------------------------------------
local function HasWeapon()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("Weapon") ~= nil
end

-------------------------------------------------------
-- GUI OPTIONS
-------------------------------------------------------
MainTab:Toggle({
    Title = "Tough Wall",
    Default = false,
    Callback = function(state)
        ToughWall = state
    end
})

MainTab:Toggle({
    Title = "Enable Aimbot (The Veil)",
    Default = false,
    Callback = function(state)
        AimbotEnabled = state
        if not AimbotEnabled then
            LockedTarget = nil
        end
    end
})

MainTab:Input({
    Title = "Set Pitch Min (Value)",
    Default = tostring(MIN_PITCH),
    Callback = function(text)
        local num = tonumber(text)
        if num then MIN_PITCH = num end
    end
})

MainTab:Input({
    Title = "Set Pitch Max (Value)",
    Default = tostring(MAX_PITCH),
    Callback = function(text)
        local num = tonumber(text)
        if num then MAX_PITCH = num end
    end
})

-------------------------------------------------------
-- FUNCTIONS
-------------------------------------------------------
local function GetLocalRoot()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- เช็คเลือด > 20 เท่านั้น
local function IsTargetValid(plr)
    if not plr or plr == LocalPlayer then return false end
    local c = plr.Character
    if not c then return false end
    local hum = c:FindFirstChild("Humanoid")
    return hum and hum.Health > 20
end

-- ตรวจสอบหลังกำแพง
local function IsVisible(head)
    if ToughWall then return true end

    local root = GetLocalRoot()
    if not root then return false end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}

    local result = workspace:Raycast(root.Position, (head.Position - root.Position), params)
    if not result then
        return true
    end

    return result.Instance:IsDescendantOf(head.Parent)
end

local function GetClosestInScreen()
    local closest = nil
    local minDist = math.huge
    local mouse = UserInputService:GetMouseLocation()

    for _, plr in ipairs(Players:GetPlayers()) do
        if IsTargetValid(plr) then
            local head = plr.Character:FindFirstChild("Head")
            if head and IsVisible(head) then
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
    end
    return closest
end

local function GetClosestByDistance()
    local root = GetLocalRoot()
    if not root then return nil end

    local closest = nil
    local distMin = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if IsTargetValid(plr) then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local head = plr.Character:FindFirstChild("Head")
            if hrp and head and IsVisible(head) then
                local dist = (root.Position - hrp.Position).Magnitude
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
    return IsTargetValid(LockedTarget)
end

local function AimAt(target)
    local c = target.Character
    if not c then return end
    local head = c:FindFirstChild("Head")
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local root = GetLocalRoot()
    if not head or not hrp or not root then return end

    local predictedPos = head.Position + (hrp.Velocity * PredictionTime)
    local distance = (root.Position - predictedPos).Magnitude

    local alpha = math.clamp((distance - MIN_DISTANCE) / (MAX_DISTANCE - MIN_DISTANCE), 0, 1)
    local pitch = MIN_PITCH + (MAX_PITCH - MIN_PITCH) * alpha

    local dir = (predictedPos - Camera.CFrame.Position).Unit
    local yaw = math.atan2(dir.X, dir.Z)
    local pitchRad = math.rad(pitch)

    local look = Vector3.new(
        math.sin(yaw) * math.cos(pitchRad),
        math.sin(pitchRad),
        math.cos(yaw) * math.cos(pitchRad)
    )
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + look)
end

-------------------------------------------------------
-- MAIN LOOP
-------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end
    if not HasWeapon() then return end   -- ต้องมี weapon เท่านั้น

    local root = GetLocalRoot()
    if not root then return end

    local closePlr, dist = GetClosestByDistance()
    if closePlr and dist <= CloseDistance then
        LockedTarget = closePlr
    end

    if not TargetAlive() then
        LockedTarget = GetClosestInScreen()
    end

    if LockedTarget then
        AimAt(LockedTarget)
    end
end)
