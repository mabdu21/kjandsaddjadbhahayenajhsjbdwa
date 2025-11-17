-- Powered by GPT 5 | v799
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
        Mode = { "Normal", "The Veil" },
        SelectedMode = { "Normal" },
        SetKeybindLock = "V",
        MobileButtonPosition = UDim2.new(1, -40, 1, -40),
        Distance = 400,
        MIN_PITCH = -1,
        MAX_PITCH = 15,
    }
}

--// Variables
local AimbotEnabled = Settings.Aimbot.Enable
local CrosshairVisible = Settings.Aimbot.CrossHairUI
local AimbotToggleGUIVisible = Settings.Aimbot.EnableUI
local ToughWallEnabled = Settings.Aimbot.TWallUI
local LockedTarget = nil
local LockPart = "Head"
local KeybindLock = Enum.KeyCode.V
local guiFolder, crosshair, mobileButton
local dragging = false
local dragStart, startPos
local dragConn, dragMoveConn

--// GUI
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
        if not AimbotEnabled then LockedTarget = nil end
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
    if not crosshair or not crosshair.Parent then CreateCrosshair() end
    if not mobileButton or not mobileButton.Parent then CreateMobileButton() end
    if crosshair then crosshair.Visible = CrosshairVisible end
    if mobileButton then mobileButton.Visible = AimbotToggleGUIVisible end
end

EnsureGui()
LocalPlayer.CharacterAdded:Connect(function() task.wait(1); EnsureGui() end)
task.spawn(function() while task.wait(1) do if not PlayerGui:FindFirstChild("เขมรกาก") then EnsureGui() end end end)
RunService.Heartbeat:Connect(function() if crosshair and crosshair.Parent then crosshair.Position = UDim2.new(0.5,0,0.5,0) end end)

--// Keybind
local KEYBIND_ACTION_NAME = "AimbotPCKeybind"
local function UpdateKeybindAction()
    ContextActionService:UnbindAction(KEYBIND_ACTION_NAME)
    local keyCode = Enum.KeyCode[Settings.Aimbot.SetKeybindLock:upper()]
    if not keyCode then warn("Invalid keybind") return end
    KeybindLock = keyCode
    ContextActionService:BindAction(KEYBIND_ACTION_NAME, function(name, state)
        if state == Enum.UserInputState.Begin and AimbotEnabled then
            if LockedTarget then
                LockedTarget = nil
            else
                LockedTarget = FindNearestTarget()
            end
            return Enum.ContextActionResult.Sink
        end
        return Enum.ContextActionResult.Pass
    end, false, keyCode)
end
UpdateKeybindAction()

-- GUI Controls
MainTab:Dropdown({ Title = "Select Mode", Values = Settings.Aimbot.Mode, Multi=false, Callback=function(val) Settings.Aimbot.SelectedMode={val} end })
MainTab:Input({ Title = "Set Pitch Min (Value)", Default=tostring(Settings.Aimbot.MIN_PITCH), Placeholder="Ex: -1", Callback=function(txt) local n=tonumber(txt); if n then Settings.Aimbot.MIN_PITCH=n end end })
MainTab:Input({ Title = "Set Pitch Max (Value)", Default=tostring(Settings.Aimbot.MAX_PITCH), Placeholder="Ex: 15", Callback=function(txt) local n=tonumber(txt); if n then Settings.Aimbot.MAX_PITCH=n end end })

MainTab:Dropdown({ Title="Select Target", Values=Settings.Aimbot.Target, Multi=false, Callback=function(val) Settings.Aimbot.SelectedTargets={val} end })
MainTab:Dropdown({ Title="Select Part", Values=Settings.Aimbot.Part, Multi=false, Callback=function(val) Settings.Aimbot.SelectedParts={val} LockPart=val end })
MainTab:Input({ Title="Set Distance Aimbot (Value)", Default=tostring(Settings.Aimbot.Distance), Placeholder="Ex: 400", Callback=function(txt) local n=tonumber(txt); if n and n>0 then Settings.Aimbot.Distance=n end end })
MainTab:Toggle({ Title="Enable Aimbot", Default=Settings.Aimbot.Enable, Callback=function(state) AimbotEnabled=state; Settings.Aimbot.Enable=state; if not state then LockedTarget=nil end; if mobileButton then mobileButton.BackgroundColor3=state and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60) end end })
MainTab:Toggle({ Title="Enable Crosshair", Default=Settings.Aimbot.CrossHairUI, Callback=function(state) CrosshairVisible=state; Settings.Aimbot.CrossHairUI=state; if crosshair then crosshair.Visible=state end end })
MainTab:Toggle({ Title="Enable Aimbot (Toggle GUI)", Default=Settings.Aimbot.EnableUI, Callback=function(state) AimbotToggleGUIVisible=state; Settings.Aimbot.EnableUI=state; if mobileButton then mobileButton.Visible=state end end })
MainTab:Toggle({ Title="Tough Wall (Aimbot)", Default=Settings.Aimbot.TWallUI, Callback=function(state) ToughWallEnabled=state; Settings.Aimbot.TWallUI=state end })
MainTab:Toggle({ Title="Custom Position Drag (Toggle GUI)", Default=Settings.Aimbot.DragUI, Callback=function(state) Settings.Aimbot.DragUI=state; EnableDrag(state) end })

--// Drag
function EnableDrag(state)
    if not mobileButton then return end
    if dragConn then dragConn:Disconnect() end
    if dragMoveConn then dragMoveConn:Disconnect() end
    if state then
        dragConn = mobileButton.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging=true; dragStart=input.Position; startPos=mobileButton.Position
                input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false; Settings.Aimbot.MobileButtonPosition=mobileButton.Position end end)
            end
        end)
        dragMoveConn = UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                local delta=input.Position-dragStart
                mobileButton.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
            end
        end)
    else
        Settings.Aimbot.MobileButtonPosition=mobileButton.Position
    end
end

--// Core Functions
local function GetCameraPosition()
    if Workspace.CurrentCamera.CameraType==Enum.CameraType.Scriptable then
        return Workspace.CurrentCamera.CFrame.Position
    else
        local head = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Head") or LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
        return head and head.Position or Workspace.CurrentCamera.CFrame.Position
    end
end

local function IsTargetType(plr)
    if not plr.Character then return false end
    local hasWeapon=plr.Character:FindFirstChild("Weapon")~=nil
    local isKiller=table.find(Settings.Aimbot.SelectedTargets,"Killer") and hasWeapon
    local isSurvivor=table.find(Settings.Aimbot.SelectedTargets,"Survivor") and not hasWeapon
    return isKiller or isSurvivor
end

local function IsValidTarget(plr)
    if not plr or plr==LocalPlayer or not plr.Character then return false end
    if not IsTargetType(plr) then return false end
    local char=plr.Character
    if not char:FindFirstChild("Humanoid") or char.Humanoid.Health<=20 then return false end
    local root=LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
    if not root then return false end
    local targetPart=nil
    for _,p in ipairs(Settings.Aimbot.SelectedParts) do
        if char:FindFirstChild(p) then targetPart=char[p]; break end
    end
    if not targetPart then return false end
    local dist=(targetPart.Position-root.Position).Magnitude
    if dist>Settings.Aimbot.Distance then return false end
    if not ToughWallEnabled then
        local ray=RaycastParams.new()
        ray.FilterDescendantsInstances={LocalPlayer.Character,char}
        ray.FilterType=Enum.RaycastFilterType.Exclude
        local result=Workspace:Raycast(GetCameraPosition(),targetPart.Position-GetCameraPosition(),ray)
        if result and result.Instance and not result.Instance:IsDescendantOf(char) then return false end
    end
    return true,targetPart
end

function FindNearestTarget()
    local root=LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
    if not root then return nil end
    local closestPlayer=nil
    local closestDist=math.huge
    local bestPart=nil
    for _,plr in ipairs(Players:GetPlayers()) do
        local valid, part = IsValidTarget(plr)
        if valid then
            local dist=(part.Position-root.Position).Magnitude
            if dist<closestDist then closestDist=dist; closestPlayer=plr; bestPart=part.Name end
        end
    end
    if closestPlayer then LockPart=bestPart; return closestPlayer end
    return nil
end

-- The Veil Prediction + Pitch
local function PredictPosition(targetPart)
    local hrp=targetPart.Parent:FindFirstChild("HumanoidRootPart")
    if not hrp then return targetPart.Position end
    local velocity=hrp.Velocity
    local predicted=targetPart.Position+velocity*0.12
    local camPos=Workspace.CurrentCamera.CFrame.Position
    local dir=(predicted-camPos).Unit
    local distance=(predicted-camPos).Magnitude
    local pitch = math.clamp(-math.asin(dir.Y)*(180/math.pi),Settings.Aimbot.MIN_PITCH,Settings.Aimbot.MAX_PITCH)
    local predictedWithPitch=predicted+Vector3.new(0,pitch/10,0)
    return predictedWithPitch
end

--// Main Loop
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then LockedTarget=nil; return end
    local cam=Workspace.CurrentCamera
    if not cam then return end
    local target=LockedTarget
    if not target or not IsValidTarget(target) then
        target=FindNearestTarget()
        LockedTarget=target
    end
    if target and target.Character and target.Character:FindFirstChild(LockPart) then
        local aimPart=target.Character[LockPart]
        local mode=Settings.Aimbot.SelectedMode[1]
        if mode=="Normal" then
            cam.CFrame=CFrame.new(cam.CFrame.Position, aimPart.Position)
        elseif mode=="The Veil" then
            local predicted=PredictPosition(aimPart)
            cam.CFrame=CFrame.lookAt(cam.CFrame.Position, predicted)
        end
    end
end)
