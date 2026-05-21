-- ╔══════════════════════════════════════════════════════╗
-- ║           DYHUB | Violence District                  ║
-- ║           Powered by GPT-5 | v5.0.0                 ║
-- ║           Upgraded & Optimized Build                 ║
-- ╚══════════════════════════════════════════════════════╝

local version = "5.0.0"

repeat task.wait() until game:IsLoaded()

-- ══════════════════════════════════════════════
-- SERVICES
-- ══════════════════════════════════════════════
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting       = game:GetService("Lighting")
local StarterGui     = game:GetService("StarterGui")
local VirtualUser    = game:GetService("VirtualUser")
local HttpService    = game:GetService("HttpService")

local LocalPlayer    = Players.LocalPlayer
local Camera         = workspace.CurrentCamera
local PlayerGui      = LocalPlayer:WaitForChild("PlayerGui")
local Character      = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid       = Character:WaitForChild("Humanoid")
local HRP            = Character:WaitForChild("HumanoidRootPart")

-- ══════════════════════════════════════════════
-- FPS UNLOCK
-- ══════════════════════════════════════════════
local function notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = dur or 3, Button1 = "OK" })
    end)
end

if setfpscap then setfpscap(1000000); notify("DYHUB", "FPS Unlocked!", 2)
else notify("DYHUB", "Executor does not support setfpscap.", 2) end

-- ══════════════════════════════════════════════
-- WINDUI
-- ══════════════════════════════════════════════
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ══════════════════════════════════════════════
-- VERSION CHECK
-- ══════════════════════════════════════════════
local function checkVersion(name)
    local ok, res = pcall(game.HttpGet, game,
        "https://raw.githubusercontent.com/mabdu21/2askdkn21h3u21ddaa/refs/heads/main/Main/Premium/listpremium.lua")
    if not ok then return "Free Version" end
    local fn = loadstring(res)
    if not fn then return "Free Version" end
    local data = fn()
    return (data and data[name]) and "Premium Version" or "Free Version"
end

local userversion = checkVersion(LocalPlayer.Name)

-- ══════════════════════════════════════════════
-- WINDOW
-- ══════════════════════════════════════════════
local Window = WindUI:CreateWindow({
    Title       = "DYHUB",
    IconThemed  = true,
    Icon        = "rbxassetid://104487529937663",
    Author      = "Violence District | " .. userversion,
    Folder      = "DYHUB_VD_config",
    Size        = UDim2.fromOffset(500, 400),
    Transparent = true,
    Theme       = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline  = false,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User        = { Enabled = true, Anonymous = false },
})

Window:SetToggleKey(Enum.KeyCode.K)
pcall(function() Window:Tag({ Title = version, Color = Color3.fromHex("#30ff6a") }) end)
Window:EditOpenButton({
    Title         = "DYHUB - Open",
    Icon          = "monitor",
    CornerRadius  = UDim.new(0, 6),
    StrokeThickness = 2,
    Color         = ColorSequence.new(Color3.fromRGB(30,30,30), Color3.fromRGB(255,255,255)),
    Draggable     = true,
})

-- ══════════════════════════════════════════════
-- TABS
-- ══════════════════════════════════════════════
local InfoTab      = Window:Tab({ Title = "Information", Icon = "info" })
                     Window:Divider()
local SurTab       = Window:Tab({ Title = "Survivor",    Icon = "user-check" })
local KillerTab    = Window:Tab({ Title = "Killer",      Icon = "swords" })
                     Window:Divider()
local MainTab      = Window:Tab({ Title = "Main",        Icon = "rocket" })
local EspTab       = Window:Tab({ Title = "ESP",         Icon = "eye" })
local PlayerTab    = Window:Tab({ Title = "Player",      Icon = "user" })
local HitboxTab    = Window:Tab({ Title = "Hitbox",      Icon = "package" })
local TeleportTab  = Window:Tab({ Title = "Teleport",    Icon = "map-pin" })

Window:SelectTab(1)

-- ══════════════════════════════════════════════
-- CONFIG SAVE / LOAD  (WindUI native)
-- ══════════════════════════════════════════════
-- WindUI จัดการ SaveConfig/LoadConfig ผ่าน Folder = "DYHUB_VD_config"
-- เรียก Window:SaveConfig() / Window:LoadConfig() เพื่อบันทึก/โหลด
pcall(function() Window:LoadConfig() end)

-- ══════════════════════════════════════════════
-- WORKSPACE SCANNER  (ค้นหา model/folder อัตโนมัติ)
-- ══════════════════════════════════════════════

-- Cache ระยะสั้นเพื่อกันสแกนซ้ำถี่เกินไป
local _wsCache    = { gens = nil, mapFolders = nil, ts = 0 }
local CACHE_TTL   = 3   -- วินาที

local function wsTime() return tick() end

-- ค้นหาทุก Generator ใน workspace โดยไม่ระบุ path
local function getAllGenerators(forceRefresh)
    if not forceRefresh and _wsCache.gens and (wsTime()-_wsCache.ts) < CACHE_TTL then
        return _wsCache.gens
    end
    local list = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "Generator" and v:IsA("Model") then
            list[#list+1] = v
        end
    end
    _wsCache.gens = list
    _wsCache.ts   = wsTime()
    return list
end

-- ค้นหาทุก folder/container ที่มี object ของแมพ
local function getMapFolders(forceRefresh)
    if not forceRefresh and _wsCache.mapFolders and (wsTime()-_wsCache.ts) < CACHE_TTL then
        return _wsCache.mapFolders
    end
    local seen, list = {}, {}
    local function addUnique(f)
        if f and not seen[f] then seen[f]=true; list[#list+1]=f end
    end

    -- หา root container ที่น่าจะเป็นแมพ (มี Gate / Generator / Hook)
    local function scanRoot(root)
        if not root then return end
        addUnique(root)
        for _, child in ipairs(root:GetChildren()) do
            if child:IsA("Folder") or child:IsA("Model") then
                addUnique(child)
                -- หา children ลึกขึ้นหนึ่งชั้น
                for _, gc in ipairs(child:GetChildren()) do
                    if gc:IsA("Folder") or gc:IsA("Model") then
                        addUnique(gc)
                    end
                end
            end
        end
    end

    -- ลอง Map ก่อน
    local map = workspace:FindFirstChild("Map")
    if map then scanRoot(map) end

    -- ถ้าไม่มี Map ให้ scan workspace ชั้นเดียว
    if #list == 0 then
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("Folder") or v:IsA("Model") then addUnique(v) end
        end
    end

    _wsCache.mapFolders = list
    _wsCache.ts = wsTime()
    return list
end

local function clearWSCache()
    _wsCache.gens = nil
    _wsCache.mapFolders = nil
    _wsCache.ts = 0
end

-- ══════════════════════════════════════════════
-- ESP SYSTEM  (ปรับ performance: throttle + pool)
-- ══════════════════════════════════════════════
local ESP = {
    enabled       = false,
    survivor      = false,
    murder        = false,
    generator     = false,
    gate          = false,
    hook          = false,
    pallet        = false,
    window        = false,
    showName      = true,
    showDist      = true,
    showHP        = true,
    showHL        = true,
    showPercent   = true,
}

local C = {
    SURVIVOR      = Color3.fromRGB(0,120,255),
    MURDERER      = Color3.fromRGB(255,50,50),
    GENERATOR     = Color3.fromRGB(220,220,220),
    GEN_DONE      = Color3.fromRGB(50,255,80),
    GATE          = Color3.fromRGB(220,220,220),
    PALLET        = Color3.fromRGB(255,220,50),
    WINDOW        = Color3.fromRGB(175,215,230),
    HOOK          = Color3.fromRGB(255,60,60),
    OUTLINE       = Color3.fromRGB(0,0,0),
}

local espObjects = {}   -- obj -> { highlight, nameLabel, hpLabel, distLabel, color }

local function removeESP(obj)
    local d = espObjects[obj]
    if not d then return end
    if d.highlight then d.highlight:Destroy() end
    if d.bill then d.bill:Destroy() end
    espObjects[obj] = nil
end

local function createESP(obj, color)
    if not obj or not obj.Parent then return end
    if obj.Name == "Lobby" then return end

    -- อัปเดตสีถ้ามีอยู่แล้ว
    local d = espObjects[obj]
    if d then
        if d.color == color then return end
        d.color = color
        if d.highlight then d.highlight.FillColor = color; d.highlight.OutlineColor = color end
        return
    end

    -- Highlight
    local hl = Instance.new("Highlight")
    hl.Adornee              = obj
    hl.FillColor            = color
    hl.FillTransparency     = 0.75
    hl.OutlineColor         = color
    hl.OutlineTransparency  = 0.1
    hl.Enabled              = ESP.showHL
    hl.Parent               = obj

    -- BillboardGui
    local bill = Instance.new("BillboardGui")
    bill.Size        = UDim2.new(0,200,0,60)
    bill.Adornee     = obj
    bill.AlwaysOnTop = true
    bill.Parent      = obj

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 1
    frame.Parent = bill

    local function mkLabel(yPos)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,0,0.33,0)
        lbl.Position = UDim2.new(0,0,yPos,0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextColor3 = color
        lbl.TextStrokeColor3 = C.OUTLINE
        lbl.TextStrokeTransparency = 0
        lbl.Text = ""
        lbl.Parent = frame
        return lbl
    end

    espObjects[obj] = {
        highlight = hl,
        bill      = bill,
        nameLabel = mkLabel(0),
        hpLabel   = mkLabel(0.33),
        distLabel = mkLabel(0.66),
        color     = color,
    }
end

-- Generator progress helpers
local function getGenProgress(gen)
    local p = gen:GetAttribute("Progress") or gen:GetAttribute("RepairProgress") or 0
    if p == 0 then
        for _, c in ipairs(gen:GetDescendants()) do
            if (c:IsA("NumberValue") or c:IsA("IntValue")) then
                local n = c.Name:lower()
                if n:find("progress") or n:find("repair") or n:find("percent") then
                    p = c.Value; break
                end
            end
        end
    end
    return math.clamp(p > 1 and p/100 or p, 0, 1)
end

local function progressColor(t)
    local r = t < 0.5 and (255-(255-80)*t/0.5) or (80*(1-(t-0.5)/0.5))
    local g = 220
    return Color3.fromRGB(math.floor(r), math.floor(g), 60)
end

local function isGenDone(gen)
    return getGenProgress(gen) >= 0.99 or gen:FindFirstChild("Finished") or gen:FindFirstChild("Repaired")
end

-- Throttled ESP update
local espTimer = 0
local ESP_INTERVAL = 0.25   -- update ทุก 0.25s แทน 0.5s เพื่อลด lag ต่อ frame

RunService.RenderStepped:Connect(function(dt)
    espTimer += dt
    if espTimer < ESP_INTERVAL then return end
    espTimer = 0

    if not ESP.enabled then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- ── Players ──
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if not char or char == LocalPlayer.Character or char.Name == "Lobby" then continue end
        local isMurder = char:FindFirstChild("Weapon") ~= nil
        local want     = isMurder and ESP.murder or ESP.survivor
        local col      = isMurder and C.MURDERER or C.SURVIVOR
        if want then createESP(char, col) else removeESP(char) end
    end

    -- ── Map objects ──
    for _, folder in ipairs(getMapFolders()) do
        for _, obj in ipairs(folder:GetChildren()) do
            local n = obj.Name

            if n == "Generator" and obj:IsA("Model") then
                if ESP.generator then
                    local done  = isGenDone(obj)
                    local prog  = getGenProgress(obj)
                    local col   = done and C.GEN_DONE or progressColor(prog)
                    createESP(obj, col)
                    local d = espObjects[obj]
                    if d then
                        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local dist = math.floor((hrp.Position - part.Position).Magnitude)
                            d.nameLabel.Text    = ESP.showName and (obj.Name .. (ESP.showPercent and (" | "..math.floor(prog*100).."%") or "")) or ""
                            d.nameLabel.Visible = ESP.showName
                            d.nameLabel.TextColor3 = col
                            d.hpLabel.Visible   = false
                            d.distLabel.Text    = ESP.showDist and ("[ "..dist.." M ]") or ""
                            d.distLabel.Visible = ESP.showDist
                            d.distLabel.TextColor3 = col
                        end
                    end
                else removeESP(obj) end

            elseif n == "Gate" and obj:IsA("Model") then
                if ESP.gate then createESP(obj, C.GATE) else removeESP(obj) end

            elseif n == "Hook" and obj:IsA("Model") then
                local mdl = obj:FindFirstChild("Model")
                if mdl then
                    if ESP.hook then createESP(mdl, C.HOOK) else removeESP(mdl) end
                end

            elseif n == "Palletwrong" and obj:IsA("Model") then
                if ESP.pallet then createESP(obj, C.PALLET) else removeESP(obj) end

            elseif n == "Window" and obj:IsA("Model") then
                if ESP.window then createESP(obj, C.WINDOW) else removeESP(obj) end
            end
        end
    end

    -- ── Update shared labels (players + objects) ──
    for obj, d in pairs(espObjects) do
        if not obj or not obj.Parent then removeESP(obj); continue end
        if obj.Name == "Lobby" then continue end

        local part = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if not part then continue end

        local hum     = obj:FindFirstChildOfClass("Humanoid")
        local isChar  = hum ~= nil
        local dist    = math.floor((hrp.Position - part.Position).Magnitude)

        if d.highlight then d.highlight.Enabled = ESP.showHL end

        d.nameLabel.Visible = ESP.showName
        d.nameLabel.Position = UDim2.new(0,0,0,0)

        if isChar then
            -- HP
            if ESP.showHP and hum then
                d.hpLabel.Text    = "[ "..math.floor(hum.Health).." HP ]"
                d.hpLabel.Visible = true
            else
                d.hpLabel.Text    = ""; d.hpLabel.Visible = false
            end
            -- Dist
            d.distLabel.Text    = ESP.showDist and ("[ "..dist.." M ]") or ""
            d.distLabel.Visible = ESP.showDist
            -- Positions
            d.hpLabel.Position   = UDim2.new(0,0,0.33,0)
            d.distLabel.Position = UDim2.new(0,0,d.hpLabel.Visible and 0.66 or 0.33,0)
        else
            d.hpLabel.Text    = ""; d.hpLabel.Visible = false
            -- Generator labels handled above; skip here
            if obj.Name ~= "Generator" then
                d.distLabel.Text    = ESP.showDist and ("[ "..dist.." M ]") or ""
                d.distLabel.Visible = ESP.showDist
                d.distLabel.Position = UDim2.new(0,0,0.33,0)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr.Character then removeESP(plr.Character) end
end)

-- ══════════════════════════════════════════════
-- ESP TAB UI
-- ══════════════════════════════════════════════
EspTab:Section({ Title = "Feature ESP", Icon = "eye" })
EspTab:Toggle({ Title = "Enable ESP", Value = false, Callback = function(v)
    ESP.enabled = v
    if not v then for obj in pairs(espObjects) do removeESP(obj) end end
end })

EspTab:Section({ Title = "ESP Role", Icon = "user" })
EspTab:Toggle({ Title = "ESP Survivor", Value = false, Callback = function(v) ESP.survivor = v end })
EspTab:Toggle({ Title = "ESP Killer",   Value = false, Callback = function(v) ESP.murder   = v end })

EspTab:Section({ Title = "ESP Engine", Icon = "biceps-flexed" })
EspTab:Toggle({ Title = "ESP Generator", Value = false, Callback = function(v) ESP.generator = v end })
EspTab:Toggle({ Title = "ESP Gate",      Value = false, Callback = function(v) ESP.gate      = v end })

EspTab:Section({ Title = "ESP Object", Icon = "package" })
EspTab:Toggle({ Title = "ESP Pallet", Value = false, Callback = function(v) ESP.pallet = v end })
EspTab:Toggle({ Title = "ESP Hook",   Value = false, Callback = function(v) ESP.hook   = v end })
EspTab:Toggle({ Title = "ESP Window", Value = false, Callback = function(v) ESP.window = v end })

EspTab:Section({ Title = "ESP Settings", Icon = "settings" })
EspTab:Toggle({ Title = "Show Name",     Value = true,  Callback = function(v) ESP.showName    = v end })
EspTab:Toggle({ Title = "Show Distance", Value = true,  Callback = function(v) ESP.showDist    = v end })
EspTab:Toggle({ Title = "Show Health",   Value = true,  Callback = function(v) ESP.showHP      = v end })
EspTab:Toggle({ Title = "Show Highlight",Value = true,  Callback = function(v) ESP.showHL      = v end })
EspTab:Toggle({ Title = "Show Percent",  Value = true,  Callback = function(v) ESP.showPercent = v end })

-- ══════════════════════════════════════════════
-- BYPASS GATE
-- ══════════════════════════════════════════════
local function gatherGates()
    local gates = {}
    for _, folder in ipairs(getMapFolders()) do
        for _, obj in ipairs(folder:GetChildren()) do
            if obj.Name == "Gate" and obj:IsA("Model") then gates[#gates+1] = obj end
        end
    end
    return gates
end

local function setGateState(on)
    for _, gate in ipairs(gatherGates()) do
        for _, name in ipairs({"LeftGate","RightGate"}) do
            local p = gate:FindFirstChild(name)
            if p then p.Transparency = on and 1 or 0; p.CanCollide = not on end
        end
        for _, name in ipairs({"LeftGate-end","RightGate-end"}) do
            local p = gate:FindFirstChild(name)
            if p then p.Transparency = on and 0 or 1; p.CanCollide = true end
        end
        local box = gate:FindFirstChild("Box")
        if box then box.CanCollide = not on end
    end
end

-- ══════════════════════════════════════════════
-- CROSSHAIR
-- ══════════════════════════════════════════════
local crosshairEnabled = false
local function createCrosshair()
    if PlayerGui:FindFirstChild("DYHUB_Crosshair") then return end
    local sg = Instance.new("ScreenGui"); sg.Name = "DYHUB_Crosshair"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true; sg.Parent = PlayerGui
    local f  = Instance.new("Frame"); f.Size = UDim2.new(0,5,0,5); f.AnchorPoint = Vector2.new(0.5,0.5); f.Position = UDim2.new(0.5,0,0.5,0); f.BackgroundColor3 = Color3.new(1,1,1); f.BackgroundTransparency = 0.3; f.BorderSizePixel = 0; f.ZIndex = 999; f.Parent = sg
    local c  = Instance.new("UICorner"); c.CornerRadius = UDim.new(1,0); c.Parent = f
    f:GetPropertyChangedSignal("Visible"):Connect(function() if crosshairEnabled and not f.Visible then f.Visible = true end end)
end
local function removeCrosshair() local g = PlayerGui:FindFirstChild("DYHUB_Crosshair"); if g then g:Destroy() end end
PlayerGui.ChildRemoved:Connect(function(c) if c.Name == "DYHUB_Crosshair" and crosshairEnabled then task.defer(createCrosshair) end end)

-- ══════════════════════════════════════════════
-- MAIN TAB UI
-- ══════════════════════════════════════════════
MainTab:Section({ Title = "Feature Gameplay", Icon = "target" })
MainTab:Button({ Title = "Aimbot (NEW)", Callback = function()
    loadstring(game:HttpGet("https://pastefy.app/Y6ui9r3d/raw"))()
end })
MainTab:Toggle({ Title = "Enable Cursor (Recommended)", Value = false, Callback = function(v)
    crosshairEnabled = v
    if v then createCrosshair() else removeCrosshair() end
end })

MainTab:Section({ Title = "Feature Bypass", Icon = "lock-open" })
MainTab:Toggle({ Title = "Bypass Gate (Open Gate)", Value = false, Callback = function(v) setGateState(v) end })

MainTab:Section({ Title = "Feature Visual", Icon = "lightbulb" })

-- Full Bright
local fullBrightEnabled = false
MainTab:Toggle({ Title = "Full Bright", Value = false, Callback = function(v)
    fullBrightEnabled = v
    if v then
        task.spawn(function()
            while fullBrightEnabled do
                Lighting.Brightness = 2; Lighting.ClockTime = 14
                Lighting.Ambient = Color3.fromRGB(255,255,255)
                task.wait(0.5)
            end
        end)
    else
        Lighting.Brightness = 1; Lighting.ClockTime = 12
        Lighting.Ambient = Color3.fromRGB(128,128,128)
    end
end })

-- No Fog
local noFogEnabled = false
MainTab:Toggle({ Title = "No Fog", Value = false, Callback = function(v)
    noFogEnabled = v
    if v then
        task.spawn(function()
            while noFogEnabled do
                local atm = Lighting:FindFirstChild("Atmosphere")
                if atm and atm.Density ~= 0 then atm.Density = 0 end
                task.wait(0.5)
            end
        end)
    else
        local atm = Lighting:FindFirstChild("Atmosphere")
        if atm then atm.Density = 0.5 end
    end
end })

MainTab:Section({ Title = "Misc", Icon = "settings" })
local AntiAFK = true
MainTab:Toggle({ Title = "Anti AFK", Value = true, Callback = function(v)
    AntiAFK = v
    task.spawn(function()
        while AntiAFK do
            VirtualUser:Button2Down(Vector2.zero, Camera.CFrame)
            task.wait(math.random(150,270))
            VirtualUser:Button2Up(Vector2.zero, Camera.CFrame)
            task.wait(math.random(150,270))
        end
    end)
end })

-- ══════════════════════════════════════════════
-- SURVIVOR TAB
-- ══════════════════════════════════════════════
SurTab:Section({ Title = "Feature Survivor", Icon = "user" })

local autoShoot  = false
local autoParry  = false

-- Auto Shoot / Parry (shared logic)
local function makeParryLoop(flag)
    task.spawn(function()
        local remote = ReplicatedStorage:WaitForChild("Remotes")
            :WaitForChild("Items"):WaitForChild("Parrying Dagger"):WaitForChild("parry")
        while flag() do
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Weapon") then
                        local tr = plr.Character:FindFirstChild("HumanoidRootPart")
                        if tr and (root.Position-tr.Position).Magnitude <= 10 then remote:FireServer() end
                    end
                end
            end
            task.wait(0.001)
        end
    end)
end

SurTab:Toggle({ Title = "Auto Shoot (STILL BUG)", Value = false, Callback = function(v) autoShoot = v; if v then makeParryLoop(function() return autoShoot end) end end })
SurTab:Toggle({ Title = "Auto Parry (STILL BUG)",  Value = false, Callback = function(v) autoParry = v; if v then makeParryLoop(function() return autoParry end) end end })

-- ══════════════════════════════════════════════
-- AUTO GENERATOR (shared helper)
-- ══════════════════════════════════════════════
SurTab:Section({ Title = "Feature Generator", Icon = "zap" })

local function makeAutoGen(result)
    return function(v)
        if not v then return end
        task.spawn(function()
            local plr     = Players.LocalPlayer
            local plrGui  = plr:WaitForChild("PlayerGui")
            local skillR  = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("SkillCheckResultEvent")
            local repairR = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("RepairEvent")

            local lastGen, lastPoint = nil, nil

            local function nearestGenPoint(root)
                local bestGen, bestPt, bestDist = nil, nil, 10
                for _, gen in ipairs(getAllGenerators()) do
                    for i = 1, 4 do
                        local pt = gen:FindFirstChild("GeneratorPoint"..i)
                        if pt then
                            local d = (root.Position - pt.Position).Magnitude
                            if d < bestDist then bestDist=d; bestGen=gen; bestPt=pt end
                        end
                    end
                end
                return bestGen, bestPt, bestDist
            end

            while (result == "success" and v) or (result == "neutral" and v) do
                local char = plr.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum  = char and char:FindFirstChild("Humanoid")
                if root and hum then
                    local gm, gp, dist = nearestGenPoint(root)
                    if not lastPoint and gp and dist < 6 then lastGen=gm; lastPoint=gp end
                    if hum.MoveDirection.Magnitude > 0.05 and lastPoint then
                        repairR:FireServer(lastPoint, false)
                        task.wait(0.2); lastGen=nil; lastPoint=nil
                    end
                    local gui = plrGui:FindFirstChild("SkillCheckPromptGui")
                    if gui then
                        local check = gui:FindFirstChild("Check")
                        if check and check.Visible and lastPoint and (root.Position-lastPoint.Position).Magnitude < 6 then
                            skillR:FireServer(result, result=="success" and 1 or 0, lastGen, lastPoint)
                            check.Visible = false
                        end
                    end
                end
                task.wait(0.15)
            end
        end)
    end
end

local agPerfect = false; local agNormal = false
SurTab:Toggle({ Title = "Auto SkillCheck (Perfect)",     Value = false, Callback = function(v) agPerfect = v; makeAutoGen("success")(v) end })
SurTab:Toggle({ Title = "Auto SkillCheck (Not Perfect)", Value = false, Callback = function(v) agNormal  = v; makeAutoGen("neutral")(v) end })

-- ══════════════════════════════════════════════
-- AUTO LEVER
-- ══════════════════════════════════════════════
SurTab:Section({ Title = "Feature Exit", Icon = "door-open" })

local autoLever = false
SurTab:Toggle({ Title = "Auto Lever (No Hold)", Value = false, Callback = function(v)
    autoLever = v
    if not v then return end
    task.spawn(function()
        local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Exit"):WaitForChild("LeverEvent")
        local isTouching = false
        UserInputService.TouchStarted:Connect(function() isTouching = true end)
        UserInputService.TouchEnded:Connect(function()   isTouching = false end)

        local lastPos
        while autoLever do
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if root and hum then
                -- หา Gate ที่ใกล้สุด
                local closestMain, shortestDist
                for _, folder in ipairs(getMapFolders()) do
                    local gate = folder:FindFirstChild("Gate")
                    if gate and gate:FindFirstChild("ExitLever") then
                        local main = gate.ExitLever:FindFirstChild("Main")
                        if main then
                            local d = (root.Position - main.Position).Magnitude
                            if not shortestDist or d < shortestDist then shortestDist=d; closestMain=main end
                        end
                    end
                end
                local moved = lastPos and (root.Position-lastPos).Magnitude > 0.5
                local moving = isTouching
                if UserInputService.KeyboardEnabled then
                    for _, k in ipairs({Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Space}) do
                        if UserInputService:IsKeyDown(k) then moving=true; break end
                    end
                end
                if closestMain then
                    if moved or moving then remote:FireServer(closestMain, false)
                    elseif shortestDist and shortestDist <= 10 then remote:FireServer(closestMain, true) end
                end
                lastPos = root.Position
            end
            task.wait(0.2)
        end
    end)
end })

-- ══════════════════════════════════════════════
-- SURVIVOR CHEAT
-- ══════════════════════════════════════════════
SurTab:Section({ Title = "Feature Cheat", Icon = "bug" })

SurTab:Button({ Title = "Fling Killer (Spam if killer doesn't fling)", Callback = function()
    local targets = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Weapon") then
            targets[#targets+1] = plr
        end
    end
    local msg = function(t,tx) StarterGui:SetCore("SendNotification",{Title=t,Text=tx,Duration=5}) end
    local function skidFling(tp)
        local char = LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local root = hum and hum.RootPart
        local tc   = tp.Character
        local thum = tc and tc:FindFirstChildOfClass("Humanoid")
        local tr   = thum and thum.RootPart
        local th   = tc and tc:FindFirstChild("Head")
        if not root or not tr then return end
        if root.Velocity.Magnitude < 50 then getgenv().OldPos = root.CFrame end
        workspace.CurrentCamera.CameraSubject = th or thum
        if not tc:FindFirstChildWhichIsA("BasePart") then return end
        local function fpos(bp, pos, ang)
            root.CFrame = CFrame.new(bp.Position)*pos*ang
            char:SetPrimaryPartCFrame(CFrame.new(bp.Position)*pos*ang)
            root.Velocity = Vector3.new(9e7,9e7*10,9e7)
            root.RotVelocity = Vector3.new(9e8,9e8,9e8)
        end
        local function sfbp(bp)
            local t0, ang = tick(), 0
            repeat
                if bp.Velocity.Magnitude < 50 then ang+=100
                    fpos(bp,CFrame.new(0,1.5,0)+thum.MoveDirection*bp.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(ang),0,0)); task.wait()
                    fpos(bp,CFrame.new(0,-1.5,0)+thum.MoveDirection*bp.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(ang),0,0)); task.wait()
                else fpos(bp,CFrame.new(0,1.5,tr.Velocity.Magnitude/1.25),CFrame.Angles(math.rad(90),0,0)); task.wait() end
            until bp.Velocity.Magnitude>500 or bp.Parent~=tc or tp.Parent~=Players or thum.Sit or hum.Health<=0 or tick()>t0+2
        end
        workspace.FallenPartsDestroyHeight = 0/0
        local bv = Instance.new("BodyVelocity"); bv.Name="DYHUB-FLING"; bv.Parent=root; bv.Velocity=Vector3.new(9e9,9e9,9e9); bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
        sfbp(tr); bv:Destroy(); hum:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
        workspace.CurrentCamera.CameraSubject = hum
        repeat root.CFrame=getgenv().OldPos*CFrame.new(0,0.5,0); char:SetPrimaryPartCFrame(getgenv().OldPos*CFrame.new(0,0.5,0)); hum:ChangeState("GettingUp"); for _,x in ipairs(char:GetChildren()) do if x:IsA("BasePart") then x.Velocity=Vector3.zero; x.RotVelocity=Vector3.zero end end; task.wait() until (root.Position-getgenv().OldPos.p).Magnitude<25
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    end
    if not getgenv().DYHUBWelcome then msg("DYHUB | FLING","Thank for using!"); getgenv().DYHUBWelcome=true end
    for _, tp in ipairs(targets) do
        if tp.UserId ~= 4340578793 then skidFling(tp) else msg("ERROR","Cannot fling owner") end
    end
end })

SurTab:Button({ Title = "Invisible (Not Visual)", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/mabdu21/kjandsaddjadbhahayenajhsjbdwa/refs/heads/main/INV.lua"))()
end })

SurTab:Button({ Title = "Self UnHook (Not 100%)", Callback = function()
    pcall(function() ReplicatedStorage.Remotes.Carry.SelfUnHookEvent:FireServer() end)
end })

-- ══════════════════════════════════════════════
-- KILLER TAB  (Aimbot)
-- ══════════════════════════════════════════════
local DYHUB = {
    AimbotOn    = false,
    Aim28On     = false,
    Target      = nil,
    PredTime    = 0.14,
    MinDist     = 1,
    MaxDist     = 250,
    MinPitch    = -1,
    MaxPitch    = 30,
    LowHP       = 20,
    ToughWall   = true,
    MobBtn      = nil,
    MobBtn28    = nil,
    GuiFolder   = nil,
    DragUI      = false,
    BtnPos      = UDim2.new(1,-40,1,-40),
    Btn28Pos    = UDim2.new(1,-140,1,-40),
    KeyA        = "Z",
    KeyA28      = "X",
}

local function DYHUB_Root() local c=LocalPlayer.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function DYHUB_HPok(plr) local h=plr.Character and plr.Character:FindFirstChild("Humanoid"); return h and h.Health>DYHUB.LowHP end
local function DYHUB_CanSee(t)
    if DYHUB.ToughWall then return true end
    local h=t.Character and t.Character:FindFirstChild("Head"); local r=DYHUB_Root(); if not h or not r then return false end
    local p=RaycastParams.new(); p.FilterType=Enum.RaycastFilterType.Blacklist; p.FilterDescendantsInstances={LocalPlayer.Character,t.Character}
    return not workspace:Raycast(r.Position+Vector3.new(0,2,0),h.Position-r.Position,p)
end
local function DYHUB_ClosestScreen()
    local best,minD=nil,math.huge; local m=UserInputService:GetMouseLocation()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and DYHUB_HPok(p) then
            local h=p.Character:FindFirstChild("Head")
            if h then local pos,on=Camera:WorldToViewportPoint(h.Position); if on then local d=(Vector2.new(pos.X,pos.Y)-m).Magnitude; if d<minD then minD=d; best=p end end end
        end
    end; return best
end
local function DYHUB_ClosestWorld()
    local root=DYHUB_Root(); if not root then return nil end
    local best,minD=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and DYHUB_HPok(p) then
            local r=p.Character:FindFirstChild("HumanoidRootPart"); if r then local d=(root.Position-r.Position).Magnitude; if d<minD then minD=d; best=p end end
        end
    end; return best,minD
end
local function DYHUB_AutoPitchMax(d) return d>=190 and 45.5 or d>=150 and 40.5 or d>=90 and 36.5 or 30.5 end
local function DYHUB_AimNormal(t)
    local h=t.Character and t.Character:FindFirstChild("Head"); local hrp=t.Character and t.Character:FindFirstChild("HumanoidRootPart"); local lr=DYHUB_Root(); if not h or not hrp or not lr then return end
    local pred=h.Position+hrp.Velocity*DYHUB.PredTime; local dist=(lr.Position-pred).Magnitude
    local pitch=DYHUB.MinPitch+(DYHUB_AutoPitchMax(dist)-DYHUB.MinPitch)*math.clamp((dist-DYHUB.MinDist)/(DYHUB.MaxDist-DYHUB.MinDist),0,1)
    local dir=(pred-Camera.CFrame.Position).Unit; local yaw=math.atan2(dir.X,dir.Z); local pr=math.rad(pitch)
    Camera.CFrame=CFrame.new(Camera.CFrame.Position,Camera.CFrame.Position+Vector3.new(math.sin(yaw)*math.cos(pr),math.sin(pr),math.cos(yaw)*math.cos(pr)))
end
local pitchTable = {1,0.09,10,0.90,20,1.9,30,2.9,40,3.9,50,4.9,60,5.9,70,6.9,80,7.9,90,8.9,100,10.9,110,11.9,120,12.9,130,13.9,140,14.9,150,15.9,160,16.9,170,17.9,180,18.9,190,20.3,200,22.3}
local function DYHUB_Pitch28(d)
    for i=1,#pitchTable-2,2 do if d<pitchTable[i+2] then return pitchTable[i+1] end end; return 23.3
end
local function DYHUB_Aim28(t)
    local h=t.Character and t.Character:FindFirstChild("Head"); local hrp=t.Character and t.Character:FindFirstChild("HumanoidRootPart"); if not h or not hrp then return end
    local pred=h.Position+hrp.Velocity*DYHUB.PredTime; local d=(pred-Camera.CFrame.Position).Magnitude
    local pitch=DYHUB_Pitch28(d); local dir=(pred-Camera.CFrame.Position).Unit; local yaw=math.atan2(dir.X,dir.Z); local pr=math.rad(pitch)
    Camera.CFrame=CFrame.new(Camera.CFrame.Position,Camera.CFrame.Position+Vector3.new(math.sin(yaw)*math.cos(pr),math.sin(pr),math.cos(yaw)*math.cos(pr)))
end

RunService.RenderStepped:Connect(function()
    if DYHUB.AimbotOn then
        DYHUB.Target = DYHUB_ClosestScreen()
        if DYHUB.Target and DYHUB_CanSee(DYHUB.Target) then DYHUB_AimNormal(DYHUB.Target) end
    elseif DYHUB.Aim28On then
        DYHUB.Target = DYHUB_ClosestWorld()
        if DYHUB.Target and DYHUB_CanSee(DYHUB.Target) then DYHUB_Aim28(DYHUB.Target) end
    end
end)

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp or inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local k = inp.KeyCode.Name
    if k == DYHUB.KeyA then
        DYHUB.AimbotOn = not DYHUB.AimbotOn
        if DYHUB.AimbotOn then DYHUB.Aim28On = false end
        if DYHUB.MobBtn then DYHUB.MobBtn.BackgroundColor3 = DYHUB.AimbotOn and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60) end
    elseif k == DYHUB.KeyA28 then
        DYHUB.Aim28On = not DYHUB.Aim28On
        if DYHUB.Aim28On then DYHUB.AimbotOn = false end
        if DYHUB.MobBtn28 then DYHUB.MobBtn28.BackgroundColor3 = DYHUB.Aim28On and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60) end
    end
end)

-- Mobile Buttons
local function ensureGUI()
    if not DYHUB.GuiFolder or not DYHUB.GuiFolder.Parent then
        local sg = Instance.new("ScreenGui"); sg.Name = "DYHUB_Aimbot"; sg.ResetOnSpawn = false; sg.Parent = PlayerGui
        DYHUB.GuiFolder = sg
    end
end
local function mkBtn(text, posKey, activeKey, otherKey, otherBtn)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,90,0,90); btn.AnchorPoint = Vector2.new(1,1)
    btn.Position = DYHUB[posKey]; btn.Text = text; btn.TextSize = 36; btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1); btn.BackgroundColor3 = Color3.fromRGB(255,60,60)
    btn.Visible = false; btn.Parent = DYHUB.GuiFolder
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,45); c.Parent = btn
    btn.MouseButton1Click:Connect(function()
        DYHUB[activeKey] = not DYHUB[activeKey]
        if DYHUB[activeKey] then DYHUB[otherKey] = false; if otherBtn and otherBtn() then otherBtn().BackgroundColor3=Color3.fromRGB(255,60,60) end end
        btn.BackgroundColor3 = DYHUB[activeKey] and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60)
    end)
    return btn
end
task.spawn(function()
    while true do
        task.wait(2)
        ensureGUI()
        if not DYHUB.MobBtn or not DYHUB.MobBtn.Parent then
            DYHUB.MobBtn   = mkBtn("🗡️","BtnPos",  "AimbotOn","Aim28On", function() return DYHUB.MobBtn28 end)
            DYHUB.MobBtn28 = mkBtn("⚔️","Btn28Pos","Aim28On", "AimbotOn",function() return DYHUB.MobBtn   end)
        end
        local g = PlayerGui:FindFirstChild("DYHUB_Aimbot")
        if g and not g.Enabled then g.Enabled = true end
    end
end)

-- Killer UI
KillerTab:Section({ Title = "Killer: The Veil", Icon = "target" })
KillerTab:Paragraph({ Title = "Info: The Veil", Desc = "• Aimbot BETA\n• May miss at high ground", Image = "rbxassetid://104487529937663", ImageSize = 45 })
KillerTab:Toggle({ Title = "Enable Aimbot (The Veil)", Default = false, Callback = function(v)
    if v then DYHUB.Aim28On=false end; DYHUB.AimbotOn=v
    if DYHUB.MobBtn then DYHUB.MobBtn.BackgroundColor3 = v and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60) end
end })
KillerTab:Toggle({ Title = "Enable Aimbot Charge (The Veil)", Default = false, Callback = function(v)
    if v then DYHUB.AimbotOn=false end; DYHUB.Aim28On=v
    if DYHUB.MobBtn28 then DYHUB.MobBtn28.BackgroundColor3 = v and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60) end
end })

KillerTab:Section({ Title = "Killer: The Veil Settings", Icon = "settings" })
KillerTab:Input({ Title = "Pitch Min",           Default = tostring(DYHUB.MinPitch), Placeholder = "Ex: -1", Callback = function(v) local n=tonumber(v); if n then DYHUB.MinPitch=n end end })
KillerTab:Input({ Title = "Pitch Max",           Default = tostring(DYHUB.MaxPitch), Placeholder = "Ex: 30", Callback = function(v) local n=tonumber(v); if n then DYHUB.MaxPitch=n end end })
KillerTab:Toggle({ Title = "Tough Wall",         Value = true, Callback = function(v) DYHUB.ToughWall=v end })
KillerTab:Input({ Title = "Keybind Aimbot",      Default = DYHUB.KeyA,   Placeholder = "Z", Callback = function(v) if #v==1 then DYHUB.KeyA=v:upper() end end })
KillerTab:Input({ Title = "Keybind Aimbot Charge", Default = DYHUB.KeyA28, Placeholder = "X", Callback = function(v) if #v==1 then DYHUB.KeyA28=v:upper() end end })

KillerTab:Section({ Title = "Killer: GUI Toggle", Icon = "layout" })
KillerTab:Toggle({ Title = "Show Aimbot Button",        Default = false, Callback = function(v) if DYHUB.MobBtn   then DYHUB.MobBtn.Visible   = v end end })
KillerTab:Toggle({ Title = "Show Aimbot Charge Button", Default = false, Callback = function(v) if DYHUB.MobBtn28 then DYHUB.MobBtn28.Visible = v end end })

-- The Masked
KillerTab:Section({ Title = "Killer: The Masked", Icon = "venetian-mask" })
KillerTab:Paragraph({ Title = "Masks", Desc = "Richard / Tony / Brandon / Jake / Richter / Graham / Alex", Image = "rbxassetid://104487529937663", ImageSize = 45 })
local MaskList = {"Richard","Tony","Brandon","Jake","Richter","Graham","Alex"}
local selMask
KillerTab:Dropdown({ Title = "Select Mask", Values = MaskList, Multi = false, Callback = function(v) selMask=v end })
KillerTab:Button({ Title = "Choose Mask", Callback = function()
    pcall(function() ReplicatedStorage.Remotes.Killers.Masked.Activatepower:FireServer(selMask) end)
end })
KillerTab:Button({ Title = "Random Mask", Callback = function()
    pcall(function() ReplicatedStorage.Remotes.Killers.Masked.Activatepower:FireServer(MaskList[math.random(#MaskList)]) end)
end })

-- The Stalker
KillerTab:Section({ Title = "Killer: The Stalker", Icon = "eye-off" })
local stalkerOn = false
KillerTab:Toggle({ Title = "Start Stalking", Value = false, Callback = function(v)
    stalkerOn = v
    task.spawn(function()
        while stalkerOn do
            task.wait(0.2)
            local lp=LocalPlayer; local char=lp.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            if not (char:FindFirstChild("Weapon")) then continue end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr~=lp and plr.Character then
                    local h=plr.Character:FindFirstChild("Humanoid"); local r=plr.Character:FindFirstChild("HumanoidRootPart")
                    if h and r then
                        local d=(root.Position-r.Position).Magnitude
                        if d>=30 and d<=70 and h.Health>20 then
                            pcall(function() ReplicatedStorage.Remotes.Killers.Stalker.StartStalking:FireServer(plr) end)
                        end
                    end
                end
            end
        end
    end)
end })

-- Killer Features
KillerTab:Section({ Title = "Feature Killer", Icon = "swords" })

local killAllOn = false
KillerTab:Toggle({ Title = "Kill All (Warning: Bannable)", Value = false, Callback = function(v)
    killAllOn = v
    if not v then return end
    task.spawn(function()
        local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack")
        local startCF
        while killAllOn do
            local char=LocalPlayer.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
            if root then
                if not startCF then startCF=root.CFrame end
                local targets={}
                for _,plr in ipairs(Players:GetPlayers()) do
                    if plr~=LocalPlayer and plr.Character then
                        local tr=plr.Character:FindFirstChild("HumanoidRootPart"); local hum=plr.Character:FindFirstChildOfClass("Humanoid")
                        if tr and hum then targets[#targets+1]={root=tr,hum=hum} end
                    end
                end
                for _,e in ipairs(targets) do
                    if not killAllOn then break end
                    if e.hum.Health>20 then pcall(function() root.CFrame=e.root.CFrame*CFrame.new(0,0,2); remote:FireServer() end); task.wait(0.15) end
                end
                local allLow=true; for _,e in ipairs(targets) do if e.hum.Health>20 then allLow=false; break end end
                if allLow and startCF then root.CFrame=startCF; task.wait(1) else task.wait(0.2) end
            else task.wait(0.2) end
        end
    end)
end })

local autoCarry = false
KillerTab:Toggle({ Title = "Auto Carry (Nearby / 2.5s)", Value = false, Callback = function(v)
    autoCarry = v
    task.spawn(function()
        while autoCarry do
            task.wait(2.5)
            local char=LocalPlayer.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
            local cands={}
            for _,plr in ipairs(Players:GetPlayers()) do
                if plr~=LocalPlayer and plr.Character then
                    local h=plr.Character:FindFirstChild("Humanoid"); local r=plr.Character:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health==20 and (hrp.Position-r.Position).Magnitude<=10 then cands[#cands+1]=plr end
                end
            end
            if #cands~=1 then continue end
            local t=cands[1]; if t.Character:FindFirstChild("Humanoid").Health==20 then
                pcall(function() ReplicatedStorage.Remotes.Carry.CarrySurvivorEvent:FireServer(t.Character) end)
                task.wait(5)
            end
        end
    end)
end })

local autoHook = false
KillerTab:Toggle({ Title = "Auto Hook (Nearby / 2.5s)", Value = false, Callback = function(v)
    autoHook = v
    task.spawn(function()
        while autoHook do
            task.wait(2.5)
            local char=LocalPlayer.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
            local cands={}
            for _,plr in ipairs(Players:GetPlayers()) do
                if plr~=LocalPlayer and plr.Character then
                    local h=plr.Character:FindFirstChild("Humanoid"); local r=plr.Character:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health==20 and (hrp.Position-r.Position).Magnitude<=10 then cands[#cands+1]=plr end
                end
            end
            if #cands~=1 then continue end
            -- หา Hook ใกล้สุด
            local bestHook, bestDist = nil, 10
            for _, folder in ipairs(getMapFolders()) do
                for _, obj in ipairs(folder:GetDescendants()) do
                    if obj.Name == "HookPoint" then
                        local d=(hrp.Position-obj.Position).Magnitude
                        if d<=bestDist then bestDist=d; bestHook=obj end
                    end
                end
            end
            if bestHook then pcall(function() ReplicatedStorage.Remotes.Carry.HookEvent:FireServer(bestHook) end); task.wait(5) end
        end
    end)
end })

KillerTab:Section({ Title = "Feature Fun", Icon = "crown" })
local grabKey = "C"
KillerTab:Input({ Title = "Keybind Grab (PC)", Default = grabKey, Placeholder = "C", Callback = function(v) if #v>0 then grabKey=v:upper() end end })

local function doGrab()
    local char=LocalPlayer.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local cands={}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LocalPlayer and plr.Character then
            local h=plr.Character:FindFirstChild("Humanoid"); local r=plr.Character:FindFirstChild("HumanoidRootPart")
            if h and r and (hrp.Position-r.Position).Magnitude<=20 and h.Health~=20 then cands[#cands+1]=plr end
        end
    end
    if #cands~=1 then return end
    pcall(function() ReplicatedStorage.Remotes.Killers.Stalker.grab:FireServer(cands[1].Character) end)
end

KillerTab:Button({ Title = "Grab (Nearby)", Callback = doGrab })
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputType == Enum.UserInputType.Keyboard then
        pcall(function() if inp.KeyCode == Enum.KeyCode[grabKey] then doGrab() end end)
    end
end)

local autoAttack = false
KillerTab:Toggle({ Title = "Auto Attack (No Animation)", Value = false, Callback = function(v)
    autoAttack = v
    if not v then return end
    task.spawn(function()
        local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack")
        while autoAttack do
            local char=LocalPlayer.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local best, bestD = nil, 10
                for _,plr in ipairs(Players:GetPlayers()) do
                    if plr~=LocalPlayer and plr.Character then
                        local r=plr.Character:FindFirstChild("HumanoidRootPart"); local h=plr.Character:FindFirstChildOfClass("Humanoid")
                        if r and h and h.Health>20 then local d=(root.Position-r.Position).Magnitude; if d<bestD then bestD=d; best=plr.Character end end
                    end
                end
                if best then pcall(function() remote:FireServer() end) end
            end
            task.wait(0.1)
        end
    end)
end })

KillerTab:Section({ Title = "Feature Cheat", Icon = "bug" })

local noFlashlight = false
KillerTab:Toggle({ Title = "No Flashlight", Value = false, Callback = function(v) noFlashlight=v end })
task.spawn(function()
    while true do task.wait(0.5)
        if noFlashlight then
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then for _,d in ipairs(pg:GetDescendants()) do if d:IsA("GuiObject") and d.Name=="Blind" then d:Destroy() end end end
        end
    end
end)

local removePallet = false
KillerTab:Toggle({ Title = "Remove Palletwrong (All)", Value = false, Callback = function(v)
    removePallet = v
    if not v then return end
    task.spawn(function()
        while removePallet do
            for _,d in ipairs(workspace:GetDescendants()) do
                if d:IsA("Model") and d.Name=="Palletwrong" then d:Destroy() end
            end
            task.wait(0.69)
        end
    end)
end })

KillerTab:Button({ Title = "Fix Camera (3rd Person)", Callback = function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if hum then
        Camera.CameraType = Enum.CameraType.Custom; Camera.CameraSubject = hum
        LocalPlayer.CameraMinZoomDistance = 0.5; LocalPlayer.CameraMaxZoomDistance = 400
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        local h=char:FindFirstChild("Head"); if h then h.Anchored=false end
    end
end })

-- ══════════════════════════════════════════════
-- PLAYER TAB
-- ══════════════════════════════════════════════
local moveSpeed = 5
local speedOn   = false
local speedConn, noclipConn

PlayerTab:Section({ Title = "Feature Player", Icon = "rabbit" })
PlayerTab:Slider({ Title = "Set Speed (Legit=3)", Value={Min=1,Max=999,Default=5}, Step=1, Callback=function(v) moveSpeed=v end })
PlayerTab:Toggle({ Title = "Enable Speed", Value = false, Callback = function(v)
    speedOn = v
    if speedConn then speedConn:Disconnect(); speedConn=nil end
    if v then speedConn = RunService.RenderStepped:Connect(function()
        local c=LocalPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart") and c.Humanoid.MoveDirection.Magnitude>0 then
            c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame + c.Humanoid.MoveDirection*moveSpeed*0.004
        end
    end) end
end })

PlayerTab:Section({ Title = "Feature Power", Icon = "flame" })
PlayerTab:Toggle({ Title = "No Clip", Value = false, Callback = function(v)
    if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
    if v then
        noclipConn = RunService.Stepped:Connect(function()
            local c=LocalPlayer.Character
            if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
        end)
    else
        local c=LocalPlayer.Character
        if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
    end
end })

-- No Fall
local NoFallEnabled = false
local FallRemote = pcall(function()
    FallRemote = ReplicatedStorage:WaitForChild("Remotes",3):WaitForChild("Mechanics",3):WaitForChild("Fall",3)
end)

pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        if NoFallEnabled and self==FallRemote and getnamecallmethod()=="FireServer" then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)

PlayerTab:Toggle({ Title = "No Fall (Beta)", Value = false, Callback = function(v) NoFallEnabled=v end })

-- ══════════════════════════════════════════════
-- HITBOX TAB
-- ══════════════════════════════════════════════
local hitTrans = 0.95
local hitSize  = 10
local hitOn    = false
local hitConn

HitboxTab:Paragraph({ Title = "Hitbox System", Desc = "• Universal Support\n• Precision Range Handler", Image = "rbxassetid://104487529937663", ImageSize = 45 })
HitboxTab:Section({ Title = "Feature Hitbox", Icon = "package" })
HitboxTab:Input({ Title = "Transparency", Value = tostring(hitTrans), Placeholder = "0.95", Callback = function(v) local n=tonumber(v); if n then hitTrans=math.clamp(n,0,1) end end })
HitboxTab:Input({ Title = "Size",         Value = tostring(hitSize),  Placeholder = "10",   Callback = function(v) local n=tonumber(v); if n then hitSize=n end end })
HitboxTab:Toggle({ Title = "Enable Hitbox", Value = false, Callback = function(v)
    hitOn = v
    if hitConn then hitConn:Disconnect(); hitConn=nil end
    if v then
        hitConn = RunService.RenderStepped:Connect(function()
            for _,plr in ipairs(Players:GetPlayers()) do
                if plr~=LocalPlayer and plr.Character then
                    local p=plr.Character:FindFirstChild("HumanoidRootPart")
                    if p then pcall(function()
                        p.Size=Vector3.new(hitSize,hitSize,hitSize); p.Transparency=hitTrans
                        p.BrickColor=BrickColor.new("Really red"); p.Material=Enum.Material.Neon; p.CanCollide=false
                    end) end
                end
            end
        end)
    else
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr.Character then local p=plr.Character:FindFirstChild("HumanoidRootPart"); if p then pcall(function()
                p.Size=Vector3.new(2,2,1); p.Transparency=1; p.Material=Enum.Material.Plastic
            end) end end
        end
    end
end })

-- ══════════════════════════════════════════════
-- TELEPORT TAB  (Auto scan workspace)
-- ══════════════════════════════════════════════
local function getCF(obj)
    if obj:IsA("BasePart") then return obj.CFrame end
    local p = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    return p and p.CFrame
end

-- Auto Generator list (ค้นหาทั้ง workspace)
local function buildGenList()
    local list, n = {}, 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name=="Generator" and v:IsA("Model") then n+=1; list[#list+1]={Name="Generator "..n, Object=v} end
    end
    return list
end

TeleportTab:Section({ Title = "Teleport: Place", Icon = "map" })
local tpPlace
TeleportTab:Dropdown({ Title = "Select Place", Values = {"Lobby","Game"}, Callback = function(v) tpPlace=v end })
TeleportTab:Button({ Title = "Teleport", Callback = function()
    if tpPlace=="Lobby" then
        local sp=workspace:FindFirstChild("SpawnLocation"); if sp and LocalPlayer.Character then LocalPlayer.Character:PivotTo(sp.CFrame+Vector3.new(0,1,0)) end
    elseif tpPlace=="Game" then
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Weapon") then
                LocalPlayer.Character:PivotTo(p.Character.PrimaryPart.CFrame*CFrame.new(0,0,200)); break
            end
        end
    end
end })

TeleportTab:Section({ Title = "Teleport: Generator", Icon = "zap" })
local genList = buildGenList()
local genTarget
local GenDD = TeleportTab:Dropdown({
    Title  = "Select Generator",
    Values = (function() local t={} for _,g in ipairs(genList) do t[#t+1]=g.Name end return t end)(),
    Callback = function(v) for _,g in ipairs(genList) do if g.Name==v then genTarget=g.Object end end end
})
TeleportTab:Button({ Title = "Teleport to Generator", Callback = function()
    if genTarget then pcall(function() LocalPlayer.Character:PivotTo(getCF(genTarget)) end) end
end })
TeleportTab:Button({ Title = "Refresh Generator List", Callback = function()
    clearWSCache(); genList=buildGenList()
    local t={} for _,g in ipairs(genList) do t[#t+1]=g.Name end
    GenDD:Update(t); genTarget=nil
end })

TeleportTab:Section({ Title = "Teleport: Refresh All", Icon = "loader" })
TeleportTab:Button({ Title = "Refresh All", Callback = function()
    clearWSCache(); genList=buildGenList()
    local t={} for _,g in ipairs(genList) do t[#t+1]=g.Name end
    GenDD:Update(t); genTarget=nil
    WindUI:Notify({ Title="Teleport", Content="All lists refreshed!", Duration=2, Icon="check" })
end })

-- ══════════════════════════════════════════════
-- INFO TAB  (Discord)
-- ══════════════════════════════════════════════
local Info = InfoTab
local InviteCode = "jWNDPNMmyB"
local DiscordAPI = "https://discord.com/api/v10/invites/"..InviteCode.."?with_counts=true&with_expiration=true"

local function httpReq(url)
    if game.HttpService.RequestAsync then
        local r=game.HttpService:RequestAsync({Url=url,Method="GET",Headers={["User-Agent"]="RobloxBot/1.0",["Accept"]="application/json"}})
        return r.Body
    end
    return game.HttpService:GetAsync(url)
end

local function loadDiscord()
    local ok, res = pcall(function() return HttpService:JSONDecode(httpReq(DiscordAPI)) end)
    if ok and res and res.guild then
        local para = Info:Paragraph({
            Title = res.guild.name,
            Desc  = ' <font color="#52525b">●</font> Members : '..res.approximate_member_count..'\n <font color="#16a34a">●</font> Online : '..res.approximate_presence_count,
            Image = "https://cdn.discordapp.com/icons/"..res.guild.id.."/"..res.guild.icon..".png?size=1024",
            ImageSize = 42,
        })
        Info:Button({ Title = "Refresh Info", Callback = function()
            local ok2,r2 = pcall(function() return HttpService:JSONDecode(httpReq(DiscordAPI)) end)
            if ok2 and r2 and r2.guild then
                para:SetDesc(' <font color="#52525b">●</font> Members : '..r2.approximate_member_count..'\n <font color="#16a34a">●</font> Online : '..r2.approximate_presence_count)
                WindUI:Notify({ Title="Updated!", Content="Discord stats refreshed", Duration=2, Icon="refresh-cw" })
            end
        end })
        Info:Button({ Title = "Copy Discord Invite", Callback = function()
            pcall(setclipboard, "https://discord.gg/"..InviteCode)
            WindUI:Notify({ Title="Copied!", Content="Discord invite copied", Duration=2, Icon="clipboard-check" })
        end })
    else
        Info:Paragraph({ Title = "Discord Error", Desc = "Could not load Discord info.", Image = "triangle-alert", ImageSize = 26 })
    end
end

loadDiscord()

Info:Divider()
Info:Section({ Title = "DYHUB Information", TextXAlignment = "Center", TextSize = 17 })
Info:Divider()

Info:Paragraph({ Title = "Main Owner", Desc = "@dyumraisgoodguy#8888", Image = "rbxassetid://119789418015420", ImageSize = 30 })
Info:Paragraph({ Title = "Social", Desc = "guns.lol/DYHUB", Image = "rbxassetid://104487529937663", ImageSize = 30,
    Buttons = {{ Icon="copy", Title="Copy Link", Callback=function() pcall(setclipboard,"https://guns.lol/DYHUB") end }}
})
Info:Paragraph({ Title = "Discord", Desc = "discord.gg/jWNDPNMmyB", Image = "rbxassetid://104487529937663", ImageSize = 30,
    Buttons = {{ Icon="copy", Title="Copy Link", Callback=function() pcall(setclipboard,"https://discord.gg/jWNDPNMmyB") end }}
})

-- ══════════════════════════════════════════════
-- SAVE CONFIG  (auto-save ทุก 30 วินาที)
-- ══════════════════════════════════════════════
task.spawn(function()
    while true do
        task.wait(30)
        pcall(function() Window:SaveConfig() end)
    end
end)

WindUI:Notify({ Title = "DYHUB v"..version, Content = "Script loaded! Press K to toggle.", Duration = 5, Icon = "rocket" })
