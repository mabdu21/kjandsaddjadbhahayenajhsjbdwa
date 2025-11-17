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
local Main1Divider = Window:Divider()
local Main2Tab = Window:Tab({ Title = "Test", Icon = "award" })
local Main3Tab = Window:Tab({ Title = "Test", Icon = "baby" })
local Main4Tab = Window:Tab({ Title = "Test", Icon = "beef" })
local Main5Tab = Window:Tab({ Title = "Test", Icon = "church" })
Window:SelectTab(1)

-------------------------------------------------------
-------------------------------------------------------
-- Aimbot Config
-------------------------------------------------------
local DYHUB_AimbotEnabled=false
local DYHUB_LockedTarget=nil
local DYHUB_CloseDistance=10
local DYHUB_PredictionTime=0.14
local DYHUB_MIN_DISTANCE=1
local DYHUB_MAX_DISTANCE=250
local DYHUB_MIN_PITCH=-1
local DYHUB_MAX_PITCH=15
local DYHUB_LOW_HP_IGNORE=20
local DYHUB_ToughWall=false
local DYHUB_AimbotToggleGUIVisible2=false
local DYHUB_crosshair,DYHUB_mobileButton,DYHUB_guiFolder
local DYHUB_Settings={Aimbot={DragUI=false,MobileButtonPosition=UDim2.new(1,-40,1,-40),SetKeybindLock="Z"}}
-------------------------------------------------------
-- GUI Section
-------------------------------------------------------
MainTab:Section({Title="Killer: The Veil",Icon="target"})
MainTab:Toggle({Title="Enable Aimbot (The Veil)",Default=false,Callback=function(state)DYHUB_AimbotEnabled=state if not state then DYHUB_LockedTarget=nil end end})
MainTab:Section({Title="Killer: The Veil Setting",Icon="settings"})
MainTab:Input({Title="Set Pitch Min (Value)",Default=tostring(DYHUB_MIN_PITCH),Placeholder="Default (Ex: -1)",Callback=function(text)local num=tonumber(text) if num then DYHUB_MIN_PITCH=num end end})
MainTab:Input({Title="Set Pitch Max (Value)",Default=tostring(DYHUB_MAX_PITCH),Placeholder="Default (Ex: 15)",Callback=function(text)local num=tonumber(text) if num then DYHUB_MAX_PITCH=num end end})
MainTab:Toggle({Title="Tough Wall (The Veil)",Default=false,Callback=function(state)DYHUB_ToughWall=state end})
MainTab:Input({Title="Set Keybind Aimbot (PC ONLY)",Default=DYHUB_Settings.Aimbot.SetKeybindLock,Placeholder="Lock (Ex: Z)",Callback=function(text)if typeof(text)=="string" and #text==1 then DYHUB_Settings.Aimbot.SetKeybindLock=string.upper(text) end end})
-------------------------------------------------------
-- FUNCTIONS
-------------------------------------------------------
local function DYHUB_GetLocalRoot() local c=LocalPlayer.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function DYHUB_HP_OK(plr) local hum=plr.Character and plr.Character:FindFirstChild("Humanoid") return hum and hum.Health>DYHUB_LOW_HP_IGNORE end
local function DYHUB_GetClosestInScreen() local closest=nil local minDist=math.huge local mouse=UserInputService:GetMouseLocation() for _,plr in ipairs(Players:GetPlayers()) do if plr~=LocalPlayer and plr.Character and DYHUB_HP_OK(plr) then local head=plr.Character:FindFirstChild("Head") local pos,visible=Camera:WorldToViewportPoint(head.Position) if visible then local dist=(Vector2.new(pos.X,pos.Y)-mouse).Magnitude if dist<minDist then minDist=dist closest=plr end end end end return closest end
local function DYHUB_GetClosestByDistance() local root=DYHUB_GetLocalRoot() if not root then return nil end local closest,distMin=nil,math.huge for _,plr in ipairs(Players:GetPlayers()) do if plr~=LocalPlayer and plr.Character and DYHUB_HP_OK(plr) then local r=plr.Character:FindFirstChild("HumanoidRootPart") if r then local dist=(root.Position-r.Position).Magnitude if dist<distMin then distMin=dist closest=plr end end end end return closest,distMin end
local function DYHUB_TargetAlive() if not DYHUB_LockedTarget then return false end if not DYHUB_LockedTarget.Character then return false end local h=DYHUB_LockedTarget.Character:FindFirstChild("Humanoid") return h and h.Health>DYHUB_LOW_HP_IGNORE end
local function DYHUB_CanSeeTarget(target) if DYHUB_ToughWall then return true end if not target.Character then return false end local head=target.Character:FindFirstChild("Head") local root=DYHUB_GetLocalRoot() if not head or not root then return false end local params=RaycastParams.new() params.FilterType=Enum.RaycastFilterType.Blacklist params.FilterDescendantsInstances={LocalPlayer.Character,target.Character} local result=workspace:Raycast(root.Position,(head.Position-root.Position),params) if result then return false end return true end
local function DYHUB_AimAt(target) if not target.Character then return end local head=target.Character:FindFirstChild("Head") local hrp=target.Character:FindFirstChild("HumanoidRootPart") local localRoot=DYHUB_GetLocalRoot() if not head or not hrp or not localRoot then return end local velocity=hrp.Velocity local predictedPos=head.Position+(velocity*DYHUB_PredictionTime) local distance=(localRoot.Position-predictedPos).Magnitude local alpha=math.clamp((distance-DYHUB_MIN_DISTANCE)/(DYHUB_MAX_DISTANCE-DYHUB_MIN_DISTANCE),0,1) local pitch=DYHUB_MIN_PITCH+(DYHUB_MAX_PITCH-DYHUB_MIN_PITCH)*alpha local dir=(predictedPos-Camera.CFrame.Position).Unit local yaw=math.atan2(dir.X,dir.Z) local pitchRad=math.rad(pitch) local newLook=Vector3.new(math.sin(yaw)*math.cos(pitchRad),math.sin(pitchRad),math.cos(yaw)*math.cos(pitchRad)) Camera.CFrame=CFrame.new(Camera.CFrame.Position,Camera.CFrame.Position+newLook) end
-------------------------------------------------------
-- MOBILE GUI FUNCTIONS
-------------------------------------------------------
local DYHUB_dragging,DYHUB_dragStart,DYHUB_startPos,DYHUB_dragConn,DYHUB_dragMoveConn
local function DYHUB_CreateMobileButton() if DYHUB_mobileButton then DYHUB_mobileButton:Destroy() end DYHUB_mobileButton=Instance.new("TextButton") DYHUB_mobileButton.Name="AimbotBTNForVEIL" DYHUB_mobileButton.Size=UDim2.new(0,90,0,90) DYHUB_mobileButton.AnchorPoint=Vector2.new(1,1) DYHUB_mobileButton.Position=DYHUB_Settings.Aimbot.MobileButtonPosition DYHUB_mobileButton.BackgroundColor3=DYHUB_AimbotEnabled and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60) DYHUB_mobileButton.Text="🗡️" DYHUB_mobileButton.TextSize=36 DYHUB_mobileButton.TextColor3=Color3.new(1,1,1) DYHUB_mobileButton.Font=Enum.Font.GothamBold DYHUB_mobileButton.Visible=DYHUB_AimbotToggleGUIVisible2 DYHUB_mobileButton.ZIndex=999 DYHUB_mobileButton.Parent=DYHUB_guiFolder local corner=Instance.new("UICorner") corner.CornerRadius=UDim.new(0,20) corner.Parent=DYHUB_mobileButton DYHUB_mobileButton.MouseButton1Click:Connect(function() DYHUB_AimbotEnabled=not DYHUB_AimbotEnabled DYHUB_LockedTarget=DYHUB_AimbotEnabled and DYHUB_LockedTarget or nil DYHUB_mobileButton.BackgroundColor3=DYHUB_AimbotEnabled and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60) end) end
local function DYHUB_EnableDrag(state) if not DYHUB_mobileButton then return end if DYHUB_dragConn then DYHUB_dragConn:Disconnect() end if DYHUB_dragMoveConn then DYHUB_dragMoveConn:Disconnect() end DYHUB_dragging=false if state then DYHUB_dragConn=DYHUB_mobileButton.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then DYHUB_dragging=true DYHUB_dragStart=input.Position DYHUB_startPos=DYHUB_mobileButton.Position input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then DYHUB_dragging=false DYHUB_Settings.Aimbot.MobileButtonPosition=DYHUB_mobileButton.Position end end) end end) DYHUB_dragMoveConn=UserInputService.InputChanged:Connect(function(input) if DYHUB_dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then local delta=input.Position-DYHUB_dragStart DYHUB_mobileButton.Position=UDim2.new(DYHUB_startPos.X.Scale,DYHUB_startPos.X.Offset+delta.X,DYHUB_startPos.Y.Scale,DYHUB_startPos.Y.Offset+delta.Y) end end) else DYHUB_Settings.Aimbot.MobileButtonPosition=DYHUB_mobileButton.Position end end
local function DYHUB_EnsureGui() if PlayerGui:FindFirstChild("เขมรกาก") then DYHUB_guiFolder=PlayerGui:FindFirstChild("เขมรกาก") else DYHUB_guiFolder=Instance.new("ScreenGui") DYHUB_guiFolder.Name="เขมรกาก" DYHUB_guiFolder.ResetOnSpawn=false DYHUB_guiFolder.IgnoreGuiInset=true DYHUB_guiFolder.ZIndexBehavior=Enum.ZIndexBehavior.Sibling DYHUB_guiFolder.Parent=PlayerGui end DYHUB_CreateMobileButton() end
DYHUB_EnsureGui() DYHUB_EnableDrag(DYHUB_Settings.Aimbot.DragUI)
LocalPlayer.CharacterAdded:Connect(function() task.wait(1) DYHUB_EnsureGui() end)
task.spawn(function() while task.wait(1) do if not PlayerGui:FindFirstChild("เขมรกาก") then DYHUB_EnsureGui() end end end)
MainTab:Section({Title="Killer: The Veil GUI",Icon="settings"})
MainTab:Toggle({Title="Enable Aimbot (Toggle GUI)",Default=DYHUB_AimbotToggleGUIVisible2,Callback=function(state) DYHUB_AimbotToggleGUIVisible2=state if DYHUB_mobileButton then DYHUB_mobileButton.Visible=state end end})
MainTab:Toggle({Title="Custom Position Drag (Toggle GUI)",Default=DYHUB_Settings.Aimbot.DragUI,Callback=function(state) DYHUB_Settings.Aimbot.DragUI=state DYHUB_EnableDrag(state) end})
-------------------------------------------------------
-- Keybind Toggle (PC)
-------------------------------------------------------
UserInputService.InputBegan:Connect(function(input,gp) if gp then return end if input.UserInputType==Enum.UserInputType.Keyboard then if input.KeyCode.Name==DYHUB_Settings.Aimbot.SetKeybindLock then DYHUB_AimbotEnabled=not DYHUB_AimbotEnabled if not DYHUB_AimbotEnabled then DYHUB_LockedTarget=nil end if DYHUB_mobileButton then DYHUB_mobileButton.BackgroundColor3=DYHUB_AimbotEnabled and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60) end end end end)
-------------------------------------------------------
-- MAIN LOOP
-------------------------------------------------------
RunService.RenderStepped:Connect(function() if not DYHUB_AimbotEnabled then return end local root=DYHUB_GetLocalRoot() if not root then return end local closePlr,dist=DYHUB_GetClosestByDistance() if closePlr and dist<=DYHUB_CloseDistance then DYHUB_LockedTarget=closePlr end if not DYHUB_TargetAlive() then DYHUB_LockedTarget=DYHUB_GetClosestInScreen() end if DYHUB_LockedTarget and DYHUB_CanSeeTarget(DYHUB_LockedTarget) then DYHUB_AimAt(DYHUB_LockedTarget) end end)
