-- DYHUB Upgraded (Premium-ready)
-- Powered by GPT-5 Thinking mini | v2.4.1 -> upgraded to v2.5.0
-- Note: Save/load uses writefile/readfile (exploit-dependent). All network calls pcall'd.

local version = "2.5.0"
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- -----------------------
-- Executor detection (same logic, compacted)
-- -----------------------
local executorName = "Unknown"
pcall(function()
    if identifyexecutor then
        local name, ver = identifyexecutor()
        executorName = ver and (name .. " (" .. ver .. ")") or name
        return
    end
    if getexecutorname then executorName = getexecutorname(); return end

    local globals = getgenv and getgenv() or _G
    local checkList = { "Delta","Xeno","Zenith","Wave","Volt","Volcano","Velocity","Seliware","Valex","Potassium","Bunni","Sirhurt","Codex","Solara","Cryptic","Krnl" }
    for _,k in ipairs(checkList) do
        if globals[k] ~= nil or getfenv()[k] ~= nil then executorName = k .. " detected"; return end
    end

    local info = debug.getinfo(1,"S")
    if info and info.source then
        local src = string.lower(info.source)
        for _,token in ipairs({"synapse","fluxus","krnl","delta"}) do
            if src:find(token) then executorName = token .. " detected"; break end
        end
    end
end)

-- Attempt load WindUI safely
local WindUI
pcall(function()
    WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not WindUI then
    warn("[DYHUB] Failed to load WindUI. UI features will be disabled.")
end

if WindUI and WindUI.Notify then
    WindUI:Notify({ Title = "DYHUB", Content = "Executor: " .. executorName .. ".", Duration = 5, Image = "cpu" })
end

-- -----------------------
-- Version check for Premium
-- -----------------------
local FreeVersion = "Free Version"
local PremiumVersion = "Premium Version"

local function checkVersion(playerName)
    local url = "https://raw.githubusercontent.com/mabdu21/2askdkn21h3u21ddaa/refs/heads/main/Main/Premium/listpremium.lua"
    local success, response = pcall(function() return game:HttpGet(url, true) end)
    if not success or not response then return FreeVersion end
    local ok, func = pcall(loadstring, response)
    if not ok or type(func) ~= "function" then return FreeVersion end
    local ok2, data = pcall(func)
    if not ok2 or type(data) ~= "table" then return FreeVersion end
    if data[playerName] then return PremiumVersion else return FreeVersion end
end

local userversion = checkVersion(LocalPlayer.Name)

-- -----------------------
-- Config & Persistence
-- -----------------------
local ConfigFile = "DYHUB_config.json"
local Config = {
    AutoRun = false,
    AutoMine = false,
    MineTarget = "Pebble",
    AutoAttack = false,
    AutoParry = false,
    AttackTargets = {},
    ForgeItemType = "Weapon",
    InfiniteFly = false,
    ClickTeleport = false,
    FlySpeed = 50,
}
-- Save & Load (exploit dependent)
local function SaveConfig()
    if writefile then
        pcall(function()
            writefile(ConfigFile, HttpService:JSONEncode(Config))
        end)
    end
end
local function LoadConfig()
    if readfile then
        local ok, content = pcall(readfile, ConfigFile)
        if ok and content then
            local ok2, tbl = pcall(HttpService.JSONDecode, HttpService, content)
            if ok2 and type(tbl) == "table" then
                for k,v in pairs(tbl) do Config[k] = v end
            end
        end
    end
end
LoadConfig()

local function UpdateSetting(key, value)
    Config[key] = value
    SaveConfig()
end

-- -----------------------
-- Knit Remote helpers
-- -----------------------
local KnitServices = nil
pcall(function()
    KnitServices = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
end)

local function GetServiceRemote(serviceName, remoteName)
    if not KnitServices then return nil end
    local ok, result = pcall(function()
        return KnitServices:FindFirstChild(serviceName) and KnitServices:FindFirstChild(serviceName):FindFirstChild("RF") and KnitServices:FindFirstChild(serviceName).RF:FindFirstChild(remoteName)
    end)
    return ok and result or nil
end

local Remotes = {
    RedeemCode = GetServiceRemote("CodeService", "RedeemCode"),
    ToolActivated = GetServiceRemote("ToolService", "ToolActivated"),
    StartBlock = GetServiceRemote("ToolService", "StartBlock"),
    StopBlock = GetServiceRemote("ToolService", "StopBlock"),
    Run = GetServiceRemote("CharacterService", "Run"),
    ChangeSequence = GetServiceRemote("ForgeService", "ChangeSequence"),
    StartForge = GetServiceRemote("ForgeService", "StartForge"),
    Forge = GetServiceRemote("ProximityService", "Forge"),
}

-- -----------------------
-- Script API (exposed functions)
-- -----------------------
local ScriptAPI = {}

-- Redeem codes safe
function ScriptAPI.RedeemAllCodes()
    if not Remotes.RedeemCode then return end
    local codes = {"200K!","100K!","40KLIKES","20KLIKES","15KLIKES","10KLIKES","5KLIKES","BETARELEASE!","POSTRELEASEQNA"}
    for _,code in ipairs(codes) do
        task.spawn(function()
            pcall(function() Remotes.RedeemCode:InvokeServer(code) end)
        end)
        task.wait(0.2)
    end
end

-- AutoMine initialization
do
    local ActiveTargets = { Mining = nil, Combat = nil }
    function ScriptAPI.GetRockTypes()
        local rockTypes = {}
        local seen = {}
        local rocksFolder = Workspace:FindFirstChild("Rocks")
        if not rocksFolder then return {} end
        for _, category in ipairs(rocksFolder:GetChildren()) do
            for _, child in ipairs(category:GetChildren()) do
                if child.Name == "SpawnLocation" then
                    for _, model in ipairs(child:GetChildren()) do
                        if model:IsA("Model") and model:FindFirstChild("Hitbox") and not seen[model.Name] then
                            seen[model.Name] = true
                            table.insert(rockTypes, model.Name)
                        end
                    end
                elseif child:IsA("Model") and child:FindFirstChild("Hitbox") and not seen[child.Name] then
                    seen[child.Name] = true
                    table.insert(rockTypes, child.Name)
                end
            end
        end
        table.sort(rockTypes)
        return rockTypes
    end

    local function FindNearestRock(maxDist)
        local char = LocalPlayer.Character
        if not char then return nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local closest, best = nil, maxDist or 15
        for _,hit in ipairs(Workspace:GetDescendants()) do
            if hit.Name == "Hitbox" and hit:IsA("BasePart") and hit.Parent and hit.Parent.Name == Config.MineTarget then
                local valid = true
                local infoFrame = hit.Parent:FindFirstChild("infoFrame")
                local hpText = infoFrame and infoFrame:FindFirstChild("Frame") and infoFrame.Frame:FindFirstChild("rockHP") and infoFrame.Frame.rockHP.Text
                if hpText then
                    local hp = tonumber(hpText:match("^(%d+)"))
                    if not hp or hp <= 0 then valid = false end
                end
                if valid then
                    local dist = (hit.Position - root.Position).Magnitude
                    if dist < best then best = dist; closest = hit end
                end
            end
        end
        return closest
    end

    -- Main loop for AutoMine
    task.spawn(function()
        while true do
            task.wait(0.12)
            if Config.AutoMine and Remotes.ToolActivated then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local humanoid = char and char:FindFirstChild("Humanoid")
                if not (char and root and humanoid and humanoid.Health>0) then
                    task.wait(0.5)
                    continue
                end

                local pickaxe = char:FindFirstChild("Pickaxe") or LocalPlayer.Backpack:FindFirstChild("Pickaxe")
                if pickaxe and not pickaxe.Parent:IsA("Backpack") and not pickaxe.Parent:IsA("Tool") then
                    -- equip logic
                    pcall(function() humanoid:EquipTool(pickaxe) end)
                end

                local target = ActiveTargets.Mining
                if not (target and target.Parent and target.Parent.Name == Config.MineTarget) then
                    target = FindNearestRock(500)
                    ActiveTargets.Mining = target
                end

                if target and target.Parent and root and (root.Position - target.Position).Magnitude <= 15 then
                    pcall(function() Remotes.ToolActivated:InvokeServer("Pickaxe") end)
                end
            else
                task.wait(0.5)
            end
        end
    end)

    -- anchor & face smoothing
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if Config.AutoMine and ActiveTargets.Mining and ActiveTargets.Mining.Parent and root then
            pcall(function()
                root.Anchored = false
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                local targetPos = ActiveTargets.Mining.Position
                root.CFrame = CFrame.lookAt(targetPos + Vector3.new(5,0,0), targetPos)
            end)
        end
    end)
end

-- AutoRun
task.spawn(function()
    while true do
        task.wait(0.15)
        if Config.AutoRun and Remotes.Run then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                pcall(function() Remotes.Run:InvokeServer() end)
            end
        else
            task.wait(0.5)
        end
    end
end)

-- Combat (simplified & robust)
do
    local ActiveCombat = nil
    ScriptAPI.GetMobTypes = function()
        local mobs, seen = {}, {}
        local living = Workspace:FindFirstChild("Living")
        if not living then return {} end
        for _,m in ipairs(living:GetChildren()) do
            if m:IsA("Model") and m:FindFirstChild("Humanoid") and not m:FindFirstChild("RaceFolder") and not m:FindFirstChild("Animate") then
                local name = m.Name:gsub("%d+$","")
                if not seen[name] then seen[name] = true; table.insert(mobs, name) end
            end
        end
        table.sort(mobs)
        return mobs
    end

    local function FindTarget(maxDist)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local best, bestDist = nil, maxDist or 100
        local living = Workspace:FindFirstChild("Living")
        if not living then return nil end
        for _,mob in ipairs(living:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                local cleanName = mob.Name:gsub("%d+$","")
                if Config.AttackTargets[cleanName] and mob.Humanoid.Health > 0 then
                    local dist = (mob.HumanoidRootPart.Position - root.Position).Magnitude
                    if dist < bestDist then bestDist, best = dist, mob end
                end
            end
        end
        return best
    end

    task.spawn(function()
        while true do
            task.wait(0.12)
            if Config.AutoAttack and Remotes.ToolActivated then
                local char = LocalPlayer.Character
                if not (char and char:FindFirstChild("Humanoid") and char.Humanoid.Health>0) then task.wait(0.5); continue end

                local weapon = char:FindFirstChildWhichIsA("Tool")
                if not weapon or weapon.Name == "Pickaxe" or weapon.Name == "Hammer" then
                    for _,tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name ~= "Pickaxe" and tool.Name ~= "Hammer" then
                            pcall(function() char.Humanoid:EquipTool(tool) end)
                            weapon = tool
                            break
                        end
                    end
                end

                if not (ActiveCombat and ActiveCombat.Parent and ActiveCombat:FindFirstChild("Humanoid") and ActiveCombat.Humanoid.Health>0) then
                    ActiveCombat = FindTarget(500)
                end

                if ActiveCombat and weapon and char.Humanoid.Health>0 then
                    local shouldBlock = false
                    if Config.AutoParry then
                        local status = ActiveCombat:FindFirstChild("Status")
                        local attacking = status and status:FindFirstChild("Attacking")
                        if attacking and attacking.Value == true then shouldBlock = true end
                    end

                    if shouldBlock and Remotes.StartBlock and not Remotes.StopBlock then
                        pcall(function() Remotes.StartBlock:InvokeServer() end)
                    elseif Remotes.ToolActivated and ActiveCombat:FindFirstChild("HumanoidRootPart") then
                        local dist = (char.HumanoidRootPart.Position - ActiveCombat.HumanoidRootPart.Position).Magnitude
                        if dist <= 15 then pcall(function() Remotes.ToolActivated:InvokeServer("Weapon") end) end
                    end
                end
            else
                task.wait(0.5)
            end
        end
    end)

    -- follow/face target (heartbeat)
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if Config.AutoAttack and ActiveCombat and ActiveCombat.Parent and char and char:FindFirstChild("HumanoidRootPart") then
            local tRoot = ActiveCombat:FindFirstChild("HumanoidRootPart")
            if tRoot then
                local root = char.HumanoidRootPart
                pcall(function()
                    root.Anchored = false
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    root.CFrame = CFrame.lookAt((tRoot.CFrame * CFrame.new(0,0,3)).Position, tRoot.Position)
                end)
            end
        end
    end)
end

-- Forge functions
do
    local function InstantForge(ores, itemType, callback)
        local ok, forgeModel = pcall(function() return Workspace:WaitForChild("Proximity",5):WaitForChild("Forge",5) end)
        if not ok or not forgeModel then if callback then callback("Error","Forge model not found",5) end; return end
        if not Remotes.Forge or not Remotes.StartForge or not Remotes.ChangeSequence then if callback then callback("Error","Missing remotes",5) end; return end

        if not itemType then itemType = "Weapon" end
        if callback then callback("Forge","Starting Instant Forge...",5) end

        pcall(function() Remotes.Forge:InvokeServer(forgeModel) end)
        task.wait(0.12)
        pcall(function() Remotes.StartForge:InvokeServer(forgeModel) end)
        task.wait(0.12)
        pcall(function() Remotes.ChangeSequence:InvokeServer("Melt", { FastForge = false, ItemType = itemType, Ores = ores }) end)
        task.wait(0.8)
        pcall(function() Remotes.ChangeSequence:InvokeServer("Pour", { ClientTime = Workspace:GetServerTimeNow() }) end)
        task.wait(0.8)
        pcall(function() Remotes.ChangeSequence:InvokeServer("Hammer", { ClientTime = Workspace:GetServerTimeNow() }) end)
        task.wait(0.8)
        task.spawn(function()
            pcall(function() Remotes.ChangeSequence:InvokeServer("Water", { ClientTime = Workspace:GetServerTimeNow() }) end)
        end)
        task.wait(0.8)
        pcall(function() Remotes.ChangeSequence:InvokeServer("Showcase", {}) end)
        if callback then callback("Forge","Instant Forge Completed!",5) end
    end

    local function GetAvailableOres()
        local result = {}
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return result end
        local oreGui = playerGui:FindFirstChild("Forge") and playerGui.Forge:FindFirstChild("OreSelect") and playerGui.Forge.OreSelect:FindFirstChild("OresFrame")
        if not oreGui then return result end
        local container = oreGui:FindFirstChild("Frame") or oreGui
        for _,child in ipairs(container:GetChildren()) do
            local main = child:FindFirstChild("Main")
            local qtyLabel = main and main:FindFirstChild("Quantity")
            if qtyLabel then
                local txt = (qtyLabel:IsA("TextLabel") or qtyLabel:IsA("TextBox")) and qtyLabel.Text or (qtyLabel:FindFirstChild("Text") and qtyLabel.Text.Text)
                if txt then
                    local n = tonumber(txt:match("%d+"))
                    result[child.Name] = n or txt
                end
            end
        end
        return result
    end

    ScriptAPI.InstantForge = InstantForge
    ScriptAPI.GetAvailableOres = GetAvailableOres
end

-- Movement: Click TP & Fly
do
    local flying = false
    local bg, bv

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if Config.ClickTeleport and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local mouse = LocalPlayer:GetMouse()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and mouse and mouse.Hit then
                pcall(function() root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0)) end)
            end
        end
    end)

    local function stopFly()
        flying = false
        if bg then bg:Destroy(); bg = nil end
        if bv then bv:Destroy(); bv = nil end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end

    local function startFly()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChild("Humanoid")
        if not (root and humanoid) then return end
        flying = true
        humanoid.PlatformStand = true
        bg = Instance.new("BodyGyro", root); bg.P = 90000; bg.maxTorque = Vector3.new(9e9,9e9,9e9); bg.cframe = root.CFrame
        bv = Instance.new("BodyVelocity", root); bv.velocity = Vector3.zero; bv.maxForce = Vector3.new(9e9,9e9,9e9)
        task.spawn(function()
            while flying do
                local cam = Workspace.CurrentCamera
                if not cam then break end
                local direction = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
                if direction.Magnitude > 0 then bv.velocity = direction.Unit * (Config.FlySpeed or 50) else bv.velocity = Vector3.zero end
                bg.cframe = cam.CFrame
                RunService.RenderStepped:Wait()
            end
            stopFly()
        end)
    end

    task.spawn(function()
        while true do
            task.wait(0.25)
            if Config.InfiniteFly then
                if not flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    startFly()
                end
            else
                if flying then stopFly() end
            end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function() if flying then stopFly() end end)
end

-- -----------------------
-- UI (WindUI) - create only if available
-- -----------------------
local Window, Tabs = nil, {}
if WindUI and WindUI.CreateWindow then
    Window = WindUI:CreateWindow({
        Title = "DYHUB",
        IconThemed = true,
        Icon = "rbxassetid://104487529937663",
        Author = "The Forge | " .. userversion,
        Folder = "DYHUB_TF",
        Size = UDim2.fromOffset(520, 420),
        Transparent = true,
        Theme = "Dark",
        BackgroundImageTransparency = 0.8,
        HasOutline = false,
        HideSearchBar = true,
        ScrollBarEnabled = true,
        User = { Enabled = true, Anonymous = false },
    })
    Window:SetToggleKey(Enum.KeyCode.K)
    pcall(function() Window:Tag({ Title = version, Color = Color3.fromHex("#30ff6a") }) end)
    Window:EditOpenButton({ Title = "DYHUB - Open", Icon = "monitor", CornerRadius = UDim.new(0,6), StrokeThickness = 2, Draggable = true })

    -- Tabs
    Tabs.Info = Window:Tab({ Title = "Information", Icon = "info" })
    Tabs.Main = Window:Tab({ Title = "Main", Icon = "rocket" })
    Tabs.Player = Window:Tab({ Title = "Player", Icon = "user" })
    Tabs.Teleport = Window:Tab({ Title = "Teleport", Icon = "map" })
    Tabs.Forge = Window:Tab({ Title = "Forge", Icon = "anvil" })
    Tabs.Combat = Window:Tab({ Title = "Combat", Icon = "sword" })

    -- Info
    Tabs.Info:Section({ Title = "Info", Icon = "info" })
    Tabs.Info:Paragraph({ Title = "DYHUB Upgraded", Desc = "Version: "..version.."\nExecutor: "..executorName.."\nMode: "..userversion, Locked = false })

    -- Main / Farming
    Tabs.Main:Section({ Title = "Farming", Icon = "tractor" })
    Tabs.Main:Toggle({ Title = "Auto Mine", Value = Config.AutoMine, Callback = function(v) UpdateSetting("AutoMine", v) end })
    -- Dynamic rock dropdown (populated by scriptAPI)
    local rockDropdown
    Tabs.Main:Paragraph({ Title = "Target Mine", Desc = "Select which rock type to target." })
    rockDropdown = Tabs.Main:Dropdown({ Title = "Target Mine", Values = ScriptAPI.GetRockTypes(), Multi = false, Callback = function(v) UpdateSetting("MineTarget", v) end })

    -- keep dropdown updated
    task.spawn(function()
        local seenList = {}
        while true do
            task.wait(4)
            local ok, arr = pcall(function() return ScriptAPI.GetRockTypes() end)
            arr = ok and arr or {}
            table.sort(arr)
            if rockDropdown and rockDropdown.SetValues then
                pcall(function() rockDropdown:SetValues(arr) end)
            elseif rockDropdown and rockDropdown.Refresh then
                pcall(function() rockDropdown:Refresh(arr) end)
            end
        end
    end)

    -- Player controls
    Tabs.Player:Section({ Title = "Player", Icon = "user" })
    Tabs.Player:Toggle({ Title = "Auto Run", Value = Config.AutoRun, Callback = function(v) UpdateSetting("AutoRun", v) end })
    Tabs.Player:Toggle({ Title = "Infinite Fly (PC ONLY)", Value = Config.InfiniteFly, Callback = function(v) UpdateSetting("InfiniteFly", v) end })
    Tabs.Player:Input({ Title = "Fly Speed", Value = tostring(Config.FlySpeed), Placeholder = "e.g. 50", Callback = function(txt) local n=tonumber(txt); if n then UpdateSetting("FlySpeed", n) end end })
    Tabs.Player:Toggle({ Title = "Click TP (Ctrl + Click)", Value = Config.ClickTeleport, Callback = function(v) UpdateSetting("ClickTeleport", v) end })

    -- Teleport tab
    Tabs.Teleport:Section({ Title = "Teleport Location", Icon = "map" })
    local teleportDropdown = Tabs.Teleport:Dropdown({ Title = "Select Teleport", Values = {}, Multi = false, Callback = function(val) UpdateSetting("SelectedTeleport", val) end })
    task.spawn(function()
        while true do
            task.wait(1)
            local proxFolder = workspace:FindFirstChild("Proximity")
            local list = {}
            if proxFolder then
                for _, loc in ipairs(proxFolder:GetChildren()) do
                    if loc:IsA("Model") or loc:IsA("BasePart") then table.insert(list, loc.Name) end
                end
                table.sort(list)
            end
            if teleportDropdown and teleportDropdown.SetValues then
                pcall(function() teleportDropdown:SetValues(list) end)
            elseif teleportDropdown and teleportDropdown.Refresh then
                pcall(function() teleportDropdown:Refresh(list) end)
            end
        end
    end)
    Tabs.Teleport:Button({ Title = "Teleport Now", Callback = function()
        local name = Config.SelectedTeleport
        if not name then Window:Notify("Error","Please select a teleport location!",3); return end
        local proxFolder = workspace:FindFirstChild("Proximity")
        if not proxFolder then Window:Notify("Error","Proximity not found",3); return end
        local target = proxFolder:FindFirstChild(name)
        if not target then Window:Notify("Error","Target not found",3); return end
        local char = LocalPlayer.Character; local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then pcall(function() root.CFrame = (target:IsA("Model") and (target.PrimaryPart and target.PrimaryPart.CFrame or target:GetPivot()) or target.CFrame) + Vector3.new(0,3,0) end) end
    end })

    -- Combat tab
    Tabs.Combat:Section({ Title = "Combat", Icon = "swords" })
    Tabs.Combat:Toggle({ Title = "Auto Attack", Value = Config.AutoAttack, Callback = function(v) UpdateSetting("AutoAttack", v) end })
    Tabs.Combat:Toggle({ Title = "Auto Block (Parry)", Value = Config.AutoParry, Callback = function(v) UpdateSetting("AutoParry", v) end })

    -- Mob dropdown (dynamic)
    local mobDropdown = Tabs.Combat:Dropdown({ Title = "Target Mob", Values = ScriptAPI.GetMobTypes and ScriptAPI.GetMobTypes() or {}, Multi = false, Callback = function(val) UpdateSetting("SelectedMob", val); Config.AttackTargets = {}; Config.AttackTargets[val] = true; SaveConfig() end })
    task.spawn(function()
        while true do
            task.wait(4)
            local ok, arr = pcall(function() return ScriptAPI.GetMobTypes() end)
            arr = ok and arr or {}
            table.sort(arr)
            if mobDropdown and mobDropdown.SetValues then
                pcall(function() mobDropdown:SetValues(arr) end)
            elseif mobDropdown and mobDropdown.Refresh then
                pcall(function() mobDropdown:Refresh(arr) end)
            end
        end
    end)

    -- Forge tab
    Tabs.Forge:Section({ Title = "Forge", Icon = "pickaxe" })
    Tabs.Forge:Paragraph({ Title = "WARNING (Instant Forge)", Desc = "If you use Instant Forge, you MUST quit and reopen the game before using the forge manually!\nSelect ore quantities and forge instantly.", Image = "rbxassetid://104487529937663", ImageSize = 45 })
    local oreDropdown = Tabs.Forge:Dropdown({ Title = "Select Ore (Auto)", Values = {}, Multi = true, Callback = function(v) UpdateSetting("SelectedOre", v) end })
    Tabs.Forge:Input({ Title = "Amount (per ore)", Value = "3", Placeholder = "3", Callback = function(txt) local n=tonumber(txt); if n and n>0 then UpdateSetting("SelectedOreAmount", n) end end })
    Tabs.Forge:Dropdown({ Title = "Item Type", Values = {"Weapon","Armor"}, Multi = false, Callback = function(v) UpdateSetting("ForgeItemType", v) end })

    -- dynamically update ore values
    task.spawn(function()
        while true do
            task.wait(1)
            local ores = {}
            local ok, avail = pcall(function() return ScriptAPI.GetAvailableOres and ScriptAPI.GetAvailableOres() or {} end)
            if ok and type(avail) == "table" then
                for k,_ in pairs(avail) do table.insert(ores,k) end
            end
            table.sort(ores)
            if oreDropdown and oreDropdown.SetValues then
                pcall(function() oreDropdown:SetValues(ores) end)
            elseif oreDropdown and oreDropdown.Refresh then
                pcall(function() oreDropdown:Refresh(ores) end)
            end
        end
    end)

    Tabs.Forge:Button({ Title = "Instant Forge", Callback = function()
        local sel = Config.SelectedOre
        local amount = Config.SelectedOreAmount or 1
        if not sel or (type(sel)=="table" and #sel==0) then Window:Notify("Error","Please select at least one ore.",3); return end
        -- build ores table
        local ores = {}
        if type(sel) == "string" then ores[sel] = amount else for _,o in ipairs(sel) do ores[o] = amount end end
        if ScriptAPI.InstantForge then
            ScriptAPI.InstantForge(ores, Config.ForgeItemType, function(t,m,tm) Window:Notify(t,m,tm) end)
        else
            Window:Notify("Error","InstantForge not available",3)
        end
    end })

    -- Quick code redeem
    Tabs.Main:Section({ Title = "Code", Icon = "gift" })
    Tabs.Main:Button({ Title = "Redeem All Codes", Callback = function() ScriptAPI.RedeemAllCodes() Window:Notify("Codes","Redeeming codes...",3) end })
end

-- -----------------------
-- Library callback (safe)
-- -----------------------
pcall(function()
    if Library and Library.SetGameDataCallback then
        Library.SetGameDataCallback(function()
            local gui = LocalPlayer:FindFirstChild("PlayerGui")
            local level, gold, inventory = 0, 0, {}
            if gui then
                local hud = gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Screen") and gui.Main.Screen:FindFirstChild("Hud")
                if hud then
                    local lvlLbl = hud:FindFirstChild("Level")
                    if lvlLbl then level = tonumber(lvlLbl.Text:match("%d+")) or 0 end
                    local goldLbl = hud:FindFirstChild("Gold")
                    if goldLbl then gold = tonumber(goldLbl.Text:gsub("[$,]","")) or goldLbl.Text end
                end
                local stash = gui:FindFirstChild("Menu") and gui.Menu:FindFirstChild("Frame") and gui.Menu.Frame:FindFirstChild("Frame")
                stash = stash and stash:FindFirstChild("Menus") and stash.Menus:FindFirstChild("Stash") and stash.Menus.Stash:FindFirstChild("Background")
                if stash then
                    for _,itemFrame in ipairs(stash:GetChildren()) do
                        local main = itemFrame:FindFirstChild("Main")
                        if main then
                            local nameLbl = main:FindFirstChild("ItemName")
                            local qtyLbl = main:FindFirstChild("Quantity")
                            if nameLbl and qtyLbl then
                                inventory[nameLbl.Text] = tonumber((qtyLbl.Text):match("%d+")) or qtyLbl.Text
                            end
                        end
                    end
                end
            end
            local features = {}
            for k,v in pairs(Config) do features[k] = v end
            return { level = level, gold = gold, inventory = inventory, timestamp = os.time(), features = features }
        end)
    end
end)

-- final notify
if WindUI and WindUI.Notify then
    WindUI:Notify({ Title = "DYHUB", Content = "Loaded: " .. version .. " (" .. userversion .. ")", Duration = 5 })
end


Info = Tabs.Info

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
