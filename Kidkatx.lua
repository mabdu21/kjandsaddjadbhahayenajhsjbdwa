-- ==== Load Obsidian Library & Setup ====
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
Library:SetDPIScale(85)
Library:SetWatermarkVisibility(true)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Watermark FPS + Ping update
local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
local Stats = game:GetService("Stats")

RunService.RenderStepped:Connect(function()
    FrameCounter += 1
    if tick() - FrameTimer >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    Library:SetWatermark(('DYHUB | %s fps | %s ms | Game: KAT X'):format(
        math.floor(FPS),
        math.floor(Stats.Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

Library:Notify({ Title = "Success", Description = "Script Executed successfully", Time = 5 })

-- Load addons
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

-- Create Window
local Window = Library:CreateWindow({
    Title = "DYHUB",
    Footer = "Premium @ Kat X | V2.0",
    Icon = 104487529937663,
    NotifySide = "Right",
    ShowCustomCursor = false,
})

-- Tabs
local Tabs = {
    Main = Window:AddTab("Main", "user"),
    Esp = Window:AddTab({Name = "Visuals", Description = "Visuals & Players & World Options", Icon = "eye"}),
    AutoFarm = Window:AddTab({Name = "Auto Farm", Description = "Automatically Farm", Icon = "axe"}),
 
}-- ==== Silent Aim Group ====
local SAGroup = Tabs.Main:AddLeftGroupbox("Silent Aim", "crosshair")
local SAFOV = 100
local FOVColor = Color3.fromRGB(255,255,255)
local SAFOVFilled = true
local SAFOVOutline = true
local C1, C2 = nil, nil
local SAConnections = {}
local SAHook = nil
local HitPart = "HumanoidRootPart"
local SAHitChance = 100 -- default 100%
local SASnaplines = false
local SnaplineDrawing = nil
local CircleMode = "Center" -- "Center" or "Follow Crosshair"

local SAToggle = SAGroup:AddToggle("SilentAimToggle", {
    Text = "Enable Silent Aim",
    Default = false,
    Callback = function(Value)
        if Value then
            local CC = Workspace.CurrentCamera
            local SA = {fov = SAFOV, fovcircle = true}
            local Tgt = nil
            C1 = Drawing.new("Circle")
            C2 = Drawing.new("Circle")

            SAConnections.RenderStepped = RunService.Stepped:Connect(function()
                local sc
if CircleMode == "Center" then
    sc = Vector2.new(CC.ViewportSize.X/2, CC.ViewportSize.Y/2)
else
    local mouse = LP:GetMouse()
    sc = Vector2.new(mouse.X, mouse.Y)
end

C1.Position = sc
C2.Position = sc
                SA.fov = SAFOV

                C1.Position = sc
                C1.Radius = SA.fov
                C1.Color = FOVColor
                C1.Filled = SAFOVFilled
                C1.Transparency = SAFOVFilled and 0.3 or 0
                C1.Visible = SAFOVFilled

                C2.Position = sc
                C2.Radius = SA.fov
                C2.Color = FOVColor
                C2.Thickness = SAFOVOutline and 2 or 0
                C2.Filled = false
                C2.Visible = SAFOVOutline

                -- Find closest target
                local closest, dist = nil, SA.fov
                for _, v in ipairs(Players:GetPlayers()) do
                    local h = v.Character and v.Character:FindFirstChild(HitPart)
                    if v ~= LP and h then
                        local hum = v.Character:FindFirstChildOfClass("Humanoid")
                        local pos, on = CC:WorldToViewportPoint(h.Position + Vector3.new(0,0.2,0))
                        if on and hum and hum.Health > 0 then
                            local canTarget = true
                            if Toggles.SAWallCheck.Value then
                                local rayParams = RaycastParams.new()
                                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                                rayParams.FilterDescendantsInstances = {LP.Character}
                                local result = Workspace:Raycast(CC.CFrame.Position, (h.Position - CC.CFrame.Position).Unit * 1000, rayParams)
                                canTarget = not result or result.Instance:IsDescendantOf(v.Character)
                            end
                            if canTarget then
                                local m = (Vector2.new(pos.X,pos.Y)-sc).Magnitude
                                if m < dist then
                                    dist, closest = m, v
                                end
                            end
                        end
                    end
                end
                Tgt = closest

                -- Snapline drawing
                if SASnaplines then
                    if not SnaplineDrawing then
                        SnaplineDrawing = Drawing.new("Line")
                        SnaplineDrawing.Color = Color3.fromRGB(255, 0, 0)
                        SnaplineDrawing.Thickness = 2
                        SnaplineDrawing.Visible = true
                    end
                    if Tgt and Tgt.Character and Tgt.Character:FindFirstChild(HitPart) then
                        local tgtPos, onScreen = CC:WorldToViewportPoint(Tgt.Character[HitPart].Position)
                        if onScreen then
                            SnaplineDrawing.From = Vector2.new(CC.ViewportSize.X/2, CC.ViewportSize.Y/2)
                            SnaplineDrawing.To = Vector2.new(tgtPos.X, tgtPos.Y)
                            SnaplineDrawing.Visible = true
                        else
                            SnaplineDrawing.Visible = false
                        end
                    else
                        SnaplineDrawing.Visible = false
                    end
                else
                    if SnaplineDrawing then
                        SnaplineDrawing.Visible = false
                    end
                end
            end)

            SAHook = hookmetamethod(game, "__namecall", function(self,...)
                local a={...}
                if not checkcaller() and getnamecallmethod()=="FindPartOnRayWithIgnoreList" and Tgt and Tgt.Character then
                    if math.random(1,100) <= SAHitChance then
                        local o = a[1].Origin
                        a[1] = Ray.new(o, Tgt.Character[HitPart].Position-o)
                    end
                end
                return SAHook(self, unpack(a))
            end)
        else
            for _, conn in pairs(SAConnections) do conn:Disconnect() end
            SAConnections = {}
            if C1 then C1:Remove() end
            if C2 then C2:Remove() end
            if SnaplineDrawing then SnaplineDrawing:Remove() SnaplineDrawing=nil end
            if SAHook then hookmetamethod(game, "__namecall", SAHook) end
        end
    end
})

-- Snaplines toggle
SAGroup:AddToggle("SASnaplinesToggle", {
    Text = "Enable Snaplines",
    Default = false,
    Callback = function(Value)
        SASnaplines = Value
        if not Value and SnaplineDrawing then
            SnaplineDrawing:Remove()
            SnaplineDrawing = nil
        end
    end
})

-- FOV Slider
SAGroup:AddSlider("SAFOVSlider", {
    Text = "FOV Size",
    Default = SAFOV,
    Min = 10,
    Max = 500,
    Rounding = 1,
    Callback = function(Value) SAFOV = Value end
})

-- FOV Color
SAToggle:AddColorPicker("SAFOVColor", {
    Default = FOVColor,
    Title = "FOV Color",
    Callback = function(Value) FOVColor = Value end
})

SAGroup:AddDropdown("SAFOVModeDropdown", {
    Text = "FOV Circle Mode",
    Values = {"Center", "Follow Crosshair"},
    Default = "Center",
    Callback = function(Value)
        CircleMode = Value
    end
})

-- Filled/Outline toggles
SAGroup:AddToggle("SAFOVFilledToggle",{Text="Filled FOV",Default=true,Callback=function(Value) SAFOVFilled=Value end})
SAGroup:AddToggle("SAFOVOutlineToggle",{Text="Outline FOV",Default=true,Callback=function(Value) SAFOVOutline=Value end})

-- Wall Check
local SAOptionsGroup = Tabs.Main:AddRightGroupbox("Silent Aim Options", "eye")
SAOptionsGroup:AddToggle("SAWallCheck", { Text = "Wall Check", Default = false })

-- Hit Part Dropdown
SAGroup:AddDropdown("SAHitPartDropdown",{
    Text="Hit Part",
    Values={"Head","Torso","HumanoidRootPart"},
    Default="HumanoidRootPart",
    Callback=function(Value) HitPart=Value end
})

-- Hit Chance Slider
SAGroup:AddSlider("SAHitChanceSlider",{
    Text="Hit Chance %",
    Default=100,
    Min=1,
    Max=100,
    Rounding=1,
    Callback=function(Value) SAHitChance=Value end
})

local SAOptionsGroup = Tabs.Main:AddRightGroupbox("Miscellaneous", "brush")
SAOptionsGroup:AddToggle("CrosshairToggle", {
    Text = "Crosshair",
    Default = false,
}):OnChanged(function(Value)
    if Value then
        -- === CREATE CROSSHAIR ===
        local RunService = game:GetService("RunService")
        local Camera = workspace.CurrentCamera

        local Center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        local CrosshairLines, LineCount, Radius, LineLength, LineColor = {}, 4, 7, 15, Color3.fromRGB(255,0,0)

        for i = 1, LineCount do
            local line = Drawing.new("Line")
            line.Color = LineColor
            line.Thickness = 2
            line.Visible = true
            table.insert(CrosshairLines, line)
        end

        local Dot = Drawing.new("Circle")
        Dot.Radius = 2
        Dot.Position = Center
        Dot.Color = LineColor
        Dot.Filled = true
        Dot.Visible = true

        local VelocityText = Drawing.new("Text")
        VelocityText.Text = "Velocity"
        VelocityText.Position = Vector2.new(Center.X - 20, Center.Y + 20)
        VelocityText.Size = 16
        VelocityText.Center = true
        VelocityText.Outline = true
        VelocityText.Color = Color3.new(1,1,1)
        VelocityText.Visible = true
        VelocityText.Font = 2

        local LOLText = Drawing.new("Text")
        LOLText.Text = ".lol"
        LOLText.Position = Vector2.new(Center.X + 35, Center.Y + 20)
        LOLText.Size = 16
        LOLText.Center = true
        LOLText.Outline = true
        LOLText.Color = Color3.fromRGB(255,0,0)
        LOLText.Visible = true
        LOLText.Font = 2

        local angle = 0
        CrosshairConnection = RunService.RenderStepped:Connect(function()
            Center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            for i, line in ipairs(CrosshairLines) do
                local a = angle + (math.pi*2/LineCount)*(i-1)
                local from = Vector2.new(Center.X + math.cos(a) * Radius, Center.Y + math.sin(a) * Radius)
                local to = Vector2.new(Center.X + math.cos(a) * (Radius + LineLength), Center.Y + math.sin(a) * (Radius + LineLength))
                line.From = from
                line.To = to
            end
            Dot.Position = Center
            VelocityText.Position = Vector2.new(Center.X - 20, Center.Y + 20)
            LOLText.Position = Vector2.new(Center.X + 35, Center.Y + 20)
            angle = angle + 0.05
        end)

        CrosshairObjects = {Dot, VelocityText, LOLText}
        for _, line in ipairs(CrosshairLines) do
            table.insert(CrosshairObjects, line)
        end

    else
        -- === REMOVE CROSSHAIR ===
        if CrosshairConnection then
            CrosshairConnection:Disconnect()
            CrosshairConnection = nil
        end
        if CrosshairObjects then
            for _, obj in ipairs(CrosshairObjects) do
                obj:Remove()
            end
            CrosshairObjects = nil
        end
    end
end)

-- ==== ESP / Visuals ====
local ESPGroup = Tabs.Esp:AddLeftGroupbox("Player Visuals", "eye")

-- Highlight toggle (chams)
local ESPHighlightToggle = ESPGroup:AddToggle("ESPEnabled", {
    Text = "Enable Highlight",
    Default = false,
    Tooltip = "Enable player highlights (chams)"
})

-- Highlight color variable
local HighlightColor = Color3.fromRGB(0,0,255) -- default blue

-- Color picker for highlight
ESPHighlightToggle:AddColorPicker("ESPHighlightColor", {
    Default = Color3.fromRGB(255, 0, 0),    Title = "Highlight Color",
    Callback = function(Value)
        HighlightColor = Value
        -- Update existing highlights if any
        for _, h in pairs(Highlights) do
            if h then
                h.FillColor = HighlightColor
            end
        end
    end
})

-- Sub-toggles
local ESPNameToggle = ESPGroup:AddToggle("ESPName", {Text = "Show Names", Default = false})
local ESPHealthToggle = ESPGroup:AddToggle("ESPHealthBar", {Text = "Show Health Bars", Default = false})
local ESPDistanceToggle = ESPGroup:AddToggle("ESPDistance", {Text = "Show Distance", Default = false})
local ESPCornersToggle = ESPGroup:AddToggle("ESPCorners", {Text = "Show Outline Box", Default = false})
local ESPWeaponToggle = ESPGroup:AddToggle("ESPWeapon", {Text = "Show Weapon/Tool", Default = false})

-- Storage for drawings and highlights
local Drawings = {}
local Highlights = {}

-- Health color gradient
local function getHealthColor(p)
    return Color3.fromHSV(p * 0.33, 1, 1)
end

-- Cleanup ESP for a player
local function removeESP(plr)
    if Drawings[plr] then
        for _, obj in pairs(Drawings[plr]) do
            if typeof(obj)=="table" then
                for _, d in pairs(obj) do if d.Remove then d:Remove() end end
            elseif obj.Remove then obj:Remove() end
        end
        Drawings[plr]=nil
    end
    if Highlights[plr] then
        Highlights[plr]:Destroy()
        Highlights[plr]=nil
    end
end

-- Corner lines
local function createCorners()
    local lines = {}
    for _=1,8 do
        local l = Drawing.new("Line")
        l.Color = Color3.new(1,1,1)
        l.Thickness = 2
        l.Visible = false
        table.insert(lines,l)
    end
    return lines
end

-- Initialize ESP for a player
local function createESP(plr)
    if plr==LP then return end
    Drawings[plr]={
        DisplayName=Drawing.new("Text"),
        Username=Drawing.new("Text"),
        Distance=Drawing.new("Text"),
        HealthBar=Drawing.new("Line"),
        HealthText=Drawing.new("Text"),
        Corners=createCorners(),
        Weapon=Drawing.new("Text")
    }
    for _, obj in pairs({Drawings[plr].DisplayName,Drawings[plr].Username,Drawings[plr].Distance,Drawings[plr].HealthText,Drawings[plr].Weapon}) do
        obj.Visible=false
        obj.Center=true
        obj.Outline=true
        obj.Font=2
        obj.Size=13
        obj.Color=Color3.new(1,1,1)
    end
    Drawings[plr].HealthBar.Thickness=4
    Drawings[plr].HealthBar.Visible=false

    if ESPHighlightToggle.Value then
        local h = Instance.new("Highlight")
        h.FillColor = Color3.fromRGB(255, 0, 0) -- default red
h.OutlineColor = Color3.new(1,1,1)
        h.FillTransparency = 0.25
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = game.CoreGui
        Highlights[plr] = h
    end
end

-- ESP Render Loop
RunService.RenderStepped:Connect(function()
    if not ESPHighlightToggle.Value and not ESPNameToggle.Value and not ESPHealthToggle.Value and not ESPDistanceToggle.Value and not ESPCornersToggle.Value and not ESPWeaponToggle.Value then
        for _, plr in pairs(Players:GetPlayers()) do removeESP(plr) end
        return
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local char=plr.Character
            local hrp=char:FindFirstChild("HumanoidRootPart")
            local hum=char:FindFirstChildOfClass("Humanoid")
            local pos,vis = Camera:WorldToViewportPoint(hrp.Position)
            local dist = (Camera.CFrame.Position-hrp.Position).Magnitude

            if not Drawings[plr] then createESP(plr) end
            local obj=Drawings[plr]

            if vis and dist<=1000 then
                local scale=1/(dist/100)
                local boxW=30*scale
                local boxH=30*scale
                local size=Vector2.new(boxW,boxH)
                local tl=Vector2.new(pos.X-size.X/2,pos.Y-size.Y/2)
                local tr=tl+Vector2.new(size.X,0)
                local bl=tl+Vector2.new(0,size.Y)
                local br=tl+size
                local len=8*scale
                local c=obj.Corners
                for i=1,8 do c[i].Visible=ESPCornersToggle.Value end
                c[1].From=tl;c[1].To=tl+Vector2.new(len,0)
                c[2].From=tl;c[2].To=tl+Vector2.new(0,len)
                c[3].From=tr;c[3].To=tr-Vector2.new(len,0)
                c[4].From=tr;c[4].To=tr+Vector2.new(0,len)
                c[5].From=bl;c[5].To=bl+Vector2.new(len,0)
                c[6].From=bl;c[6].To=bl-Vector2.new(0,len)
                c[7].From=br;c[7].To=br-Vector2.new(0,len)
                c[8].From=br;c[8].To=br-Vector2.new(0,len)

                obj.DisplayName.Position=Vector2.new(pos.X,tl.Y-35)
                obj.DisplayName.Text=plr.DisplayName
                obj.DisplayName.Visible=ESPNameToggle.Value

                obj.Username.Position=Vector2.new(pos.X,tl.Y-23)
                obj.Username.Text=plr.Name
                obj.Username.Visible=ESPNameToggle.Value

                obj.Distance.Position=Vector2.new(pos.X,br.Y+4)
                obj.Distance.Text=math.floor(dist).." Studs"
                obj.Distance.Visible=ESPDistanceToggle.Value

                if hum then
                    local hpPercent=math.clamp(hum.Health/hum.MaxHealth,0,1)
                    local barHeight=size.Y*hpPercent
                    local from=Vector2.new(tl.X-6,br.Y)
                    local to=Vector2.new(tl.X-6,br.Y-barHeight)
                    obj.HealthBar.From=from
                    obj.HealthBar.To=to
                    obj.HealthBar.Color=getHealthColor(hpPercent)
                    obj.HealthBar.Visible=ESPHealthToggle.Value

                    obj.HealthText.Position=Vector2.new(from.X-10,to.Y-6)
                    obj.HealthText.Text=tostring(math.floor(hum.Health))
                    obj.HealthText.Color=getHealthColor(hpPercent)
                    obj.HealthText.Visible=ESPHealthToggle.Value
                end

                if ESPWeaponToggle.Value then
                    local tool=nil
                    for _, child in ipairs(char:GetChildren()) do
                        if child:IsA("Tool") then
                            tool=child
                            break
                        end
                    end
                    if tool then
                        obj.Weapon.Text=tool.Name
                        obj.Weapon.Position=Vector2.new(pos.X,tl.Y-50)
                        obj.Weapon.Visible=true
                    else
                        obj.Weapon.Visible=false
                    end
                else obj.Weapon.Visible=false end

                if Highlights[plr] then
                    Highlights[plr].Adornee=char
                    Highlights[plr].Enabled=ESPHighlightToggle.Value
                end
            else
                for _, obj2 in pairs(obj) do
                    if typeof(obj2)=="table" then
                        for _, x in pairs(obj2) do x.Visible=false end
                    elseif obj2.Visible then obj2.Visible=false end
                end
                if Highlights[plr] then Highlights[plr].Enabled=false end
            end
        else removeESP(plr) end
    end
end)

Players.PlayerRemoving:Connect(removeESP)

-- ==== World Groupbox ====
local WorldGroup = Tabs.Esp:AddRightGroupbox("World", "globe")

local CameraFOV = 70
WorldGroup:AddSlider("CameraFOVSlider",{
    Text="Camera Field Of View",
    Default=CameraFOV,
    Min=50,
    Max=120,
    Rounding=1,
    Callback=function(Value)
        CameraFOV=Value
        Camera.FieldOfView=CameraFOV
    end
})

local VisualSaturation = 100
local VisualBrightness = 1
local Lighting = game:GetService("Lighting")
local ColorEffect = Instance.new("ColorCorrectionEffect")
ColorEffect.Parent = Lighting
ColorEffect.Saturation=VisualSaturation/100
ColorEffect.Brightness=VisualBrightness/35
ColorEffect.TintColor=Color3.new(1,1,1)

WorldGroup:AddSlider("VisualSaturationSlider",{Text="Saturation",Default=VisualSaturation,Min=0,Max=100,Rounding=1,Callback=function(Value)
    VisualSaturation=Value
    ColorEffect.Saturation=VisualSaturation/100
end})

WorldGroup:AddSlider("VisualBrightnessSlider",{Text="Brightness",Default=VisualBrightness,Min=1,Max=10,Rounding=1,Callback=function(Value)
    VisualBrightness=Value
    ColorEffect.Brightness=VisualBrightness/10
end})

WorldGroup:AddButton("Stretched Resolution",function()
    getgenv().Resolution={[".gg/dyhub"]=0.65}
    local Camera=workspace.CurrentCamera
    if getgenv().gg_scripters==nil then
        game:GetService("RunService").RenderStepped:Connect(function()
            Camera.CFrame=Camera.CFrame*CFrame.new(0,0,0,1,0,0,0,getgenv().Resolution[".gg/dyhub"],0,0,0,1)
        end)
    end
    getgenv().gg_scripters="dyhub"
end)

WorldGroup:AddButton("FPS Boost (BloxStrap)",function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/qwertyui-is-back/Bloxstrap/main/Initiate.lua', true))()
end)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local followDistance = 2
local sideOffset = 1
local followTime = 1.5
local knifeName = "Knife"
local equipInterval = 0.5

-- Current character reference
local currentChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
LocalPlayer.CharacterAdded:Connect(function(char)
    currentChar = char
end)

local autoFarmGroup = Tabs.AutoFarm:AddLeftGroupbox("AutoFarm Settings", "axe")

-- AutoFarm toggle
local autoFarmToggle = autoFarmGroup:AddToggle("AutoFarmToggle", {
    Text = "AutoFarm",        -- visible label
    Default = false
})

-- Auto Equip Knife toggle
local autoEquipToggle = autoFarmGroup:AddToggle("AutoEquipKnifeToggle", {
    Text = "Auto Equip Knife", -- visible label
    Default = false
})

-- Helper: get next player
local function getNextPlayer(currentIndex)
    local all = Players:GetPlayers()
    if #all <= 1 then return nil, 0 end

    local index = currentIndex or 0
    local tries = 0
    repeat
        index = index + 1
        if index > #all then index = 1 end
        tries = tries + 1
    until all[index] ~= LocalPlayer or tries > #all

    return all[index] ~= LocalPlayer and all[index] or nil, index
end

-- Combined AutoFarm + Auto Equip Knife loop
task.spawn(function()
    local currentIndex = 0
    while true do
        -- AUTO FARM LOGIC
        if autoFarmToggle.Value then
            local target
            target, currentIndex = getNextPlayer(currentIndex)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local startTime = tick()
                while tick() - startTime < followTime and autoFarmToggle.Value do
                    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                    if currentChar and hrp and currentChar:FindFirstChild("HumanoidRootPart") then
                        local backPos = hrp.Position - hrp.CFrame.LookVector * followDistance
                        local sidePos = backPos + hrp.CFrame.RightVector * sideOffset
                        currentChar.HumanoidRootPart.CFrame = CFrame.new(sidePos, hrp.Position)
                    end
                    RunService.RenderStepped:Wait()
                end
            else
                task.wait(0.2)
            end
        else
            task.wait(0.2)
        end

        -- AUTO EQUIP KNIFE LOGIC
        if autoEquipToggle.Value then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack and currentChar then
                local knife = backpack:FindFirstChild(knifeName)
                if knife then
                    currentChar.Humanoid:EquipTool(knife)
                end
            end
        end

        task.wait(equipInterval)
    end
end)

-- Configuration Tab
local Configuration = Window:AddTab({
    Name = "Configuration",
    Description = "Settings & Configs",
    Icon = "file"
})

-- =========================
-- Left Groupbox: Menu / UI
-- =========================
local MenuGroup = Configuration:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind


-- =========================
-- Right Groupbox: Configs
-- =========================
local ConfigGroup = Configuration:AddRightGroupbox("Config Manager", "cog")

-- Hook managers into library
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore theme + menu keybind in configs
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- Folder structure
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place")

-- Force managers into RIGHT groupbox
SaveManager:BuildConfigSection(ConfigGroup)   -- ✅ Build config list, save/load, etc
ThemeManager:ApplyToGroupbox(ConfigGroup)     -- ✅ Add theme dropdowns here

-- Auto-load if marked
SaveManager:LoadAutoloadConfig()

-- ==== Finish Setup ====
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("MyScriptHub")
SaveManager:SetSubFolder("specific-place")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
