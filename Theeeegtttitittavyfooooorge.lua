-- Powered by GPT 5 | v809
-- ======================
local version = "2.5.0" -- Fixed & Enhanced
-- ======================
repeat task.wait() until game:IsLoaded()

-- FPS Unlock
if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "FPS Unlocked!",
        Duration = 2,
    })
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Premium Check
local FreeVersion = "Free Version"
local PremiumVersion = "Premium Version"
local function checkVersion(name)
    local success, data = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/mabdu21/2askdkn21h3u21ddaa/refs/heads/main/Main/Premium/listpremium.lua"))()
    end)
    if success and data[name] then return PremiumVersion end
    return FreeVersion
end
local userversion = checkVersion(LocalPlayer.Name)

-- Window
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    Icon = "rbxassetid://104487529937663",
    Author = "The Forge | "..userversion.." | v"..version,
    Folder = "DYHUB_TF",
    Size = UDim2.fromOffset(580, 480),
    Theme = "Dark",
    Transparent = true,
})
Window:SetToggleKey(Enum.KeyCode.K)

-- Services & Remotes
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local KnitServices = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
local function GetRemote(s, t, n)
    local success, remote = pcall(function()
        return KnitServices[s]:WaitForChild(t):WaitForChild(n)
    end)
    return success and remote or nil
end

local Remotes = {
    RedeemCode     = GetRemote("CodeService", "RF", "RedeemCode"),
    ToolActivated  = GetRemote("ToolService", "RF", "ToolActivated"),
    StartBlock     = GetRemote("ToolService", "RF", "StartBlock"),
    StopBlock      = GetRemote("ToolService", "RF", "StopBlock"),
    Run            = GetRemote("CharacterService", "RF", "Run"),
    ChangeSequence = GetRemote("ForgeService", "RF", "ChangeSequence"),
    StartForge     = GetRemote("ForgeService", "RF", "StartForge"),
    Forge          = GetRemote("ProximityService", "RF", "Forge"),
}

-- Config
local Config = {
    AutoMine = false, MineTarget = "Pebble",
    AutoRun = false,
    AutoAttack = false, AutoParry = false, AttackTargets = {},
    InfiniteFly = false, FlySpeed = 80,
    ClickTeleport = false,
    ForgeItemType = "Weapon",
}

-- Tween Function (Smooth & Safe)
local function TweenTeleport(cframe, time)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    local tweenInfo = TweenInfo.new(
        time or 0.7,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0, false, 0
    )
    local tween = TweenService:Create(root, tweenInfo, {CFrame = cframe})
    tween:Play()
    tween.Completed:Wait()
end

-- Redeem All Codes
local function RedeemAllCodes()
    if not Remotes.RedeemCode then return Window:Notify("Error", "RedeemCode not found!") end
    local codes = {"200K!", "100K!", "40KLIKES", "20KLIKES", "15KLIKES", "10KLIKES", "5KLIKES", "BETARELEASE!", "POSTRELEASEQNA"}
    for _, code in ipairs(codes) do
        task.spawn(function()
            pcall(function() Remotes.RedeemCode:InvokeServer(code) end)
        end)
        task.wait(0.35)
    end
    Window:Notify("Success", "All codes redeemed!")
end

-- Auto Mine + Tween
local ActiveMineTarget = nil
local function FindNearestRock()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local closest, dist = nil, 500
    for _, hitbox in ipairs(Workspace.Rocks:GetDescendants()) do
        if hitbox.Name == "Hitbox" and hitbox.Parent.Name == Config.MineTarget and hitbox:IsA("BasePart") then
            local hp = hitbox.Parent:FindFirstChild("infoFrame") and hitbox.Parent.infoFrame.Frame.rockHP.Text:match("%d+")
            if hp and tonumber(hp) > 0 then
                local d = (hitbox.Position - root.Position).Magnitude
                if d < dist then
                    closest, dist = hitbox, d
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoMine then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                -- Equip Pickaxe
                if not char:FindFirstChild("Pickaxe") then
                    local tool = LocalPlayer.Backpack:FindFirstChild("Pickaxe")
                    if tool then char.Humanoid:EquipTool(tool) task.wait(0.3) end
                end

                if not ActiveMineTarget or not ActiveMineTarget.Parent then
                    ActiveMineTarget = FindNearestRock()
                end

                if ActiveMineTarget then
                    local root = char.HumanoidRootPart
                    if (root.Position - ActiveMineTarget.Position).Magnitude > 12 then
                        TweenTeleport(CFrame.new(ActiveMineTarget.Position + Vector3.new(6, 0, 0)), 0.6)
                    else
                        Remotes.ToolActivated:InvokeServer("Pickaxe")
                    end
                end
            end
        else
            ActiveMineTarget = nil
        end
    end
end)

-- Auto Combat + Auto Parry + Tween
local ActiveCombatTarget = nil
local Blocking = false

local function FindCombatTarget()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local closest, dist = nil, 999
    for _, mob in ipairs(Workspace.Living:GetChildren()) do
        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local name = mob.Name:gsub("%d+$", "")
            if Config.AttackTargets[name] and mob:FindFirstChild("HumanoidRootPart") then
                local d = (mob.HumanoidRootPart.Position - root.Position).Magnitude
                if d < dist then closest, dist = mob, d end
            end
        end
    end
    return closest
end

task.spawn(function()
    while task.wait(0.08) do
        if Config.AutoAttack then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                -- Equip Weapon
                local weapon = char:FindFirstChildWhichIsA("Tool")
                if not weapon or weapon.Name == "Pickaxe" or weapon.Name == "Hammer" then
                    for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if t:IsA("Tool") and t.Name ~= "Pickaxe" and t.Name ~= "Hammer" then
                            char.Humanoid:EquipTool(t)
                            task.wait(0.3)
                            break
                        end
                    end
                end

                if not ActiveCombatTarget or ActiveCombatTarget.Humanoid.Health <= 0 then
                    ActiveCombatTarget = FindCombatTarget()
                end

                if ActiveCombatTarget then
                    local root = char.HumanoidRootPart
                    local targetRoot = ActiveCombatTarget.HumanoidRootPart

                    -- Auto Parry
                    if Config.AutoParry then
                        local attacking = ActiveCombatTarget:FindFirstChild("Status") and ActiveCombatTarget.Status:FindFirstChild("Attacking")
                        if attacking and attacking.Value then
                            if not Blocking then
                                Remotes.StartBlock:InvokeServer()
                                Blocking = true
                            end
                        elseif Blocking then
                            Remotes.StopBlock:InvokeServer()
                            Blocking = false
                        end
                    end

                    if (root.Position - targetRoot.Position).Magnitude > 12 then
                        TweenTeleport(CFrame.lookAt(targetRoot.Position + Vector3.new(0,0,4), targetRoot.Position), 0.5)
                    else
                        if not Blocking or not Config.AutoParry then
                            Remotes.ToolActivated:InvokeServer("Weapon")
                        end
                    end
                end
            end
        else
            ActiveCombatTarget = nil
            if Blocking then Remotes.StopBlock:InvokeServer() Blocking = false end
        end
    end
end)

-- Instant Forge (Unchanged - Already Instant)
local function InstantForge(ores, itemType)
    local forge = Workspace:FindFirstChild("Proximity"):FindFirstChild("Forge")
    if not forge then return Window:Notify("Error", "Forge not found!") end
    Remotes.Forge:InvokeServer(forge)
    task.wait(0.15)
    Remotes.StartForge:InvokeServer(forge)
    task.wait(0.25)
    Remotes.ChangeSequence:InvokeServer("Melt", { FastForge = false, ItemType = itemType or "Weapon", Ores = ores })
    task.wait(0.6)
    Remotes.ChangeSequence:InvokeServer("Pour", { ClientTime = Workspace:GetServerTimeNow() })
    task.wait(0.6)
    Remotes.ChangeSequence:InvokeServer("Hammer", { ClientTime = Workspace:GetServerTimeNow() })
    task.wait(0.6)
    Remotes.ChangeSequence:InvokeServer("Water", { ClientTime = Workspace:GetServerTimeNow() })
    task.wait(0.6)
    Remotes.ChangeSequence:InvokeServer("Showcase", {})
    Window:Notify("Success", "Instant Forge Completed!")
end

-- Fly & Click TP
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if Config.ClickTeleport and i.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Hit then
            TweenTeleport(CFrame.new(mouse.Hit.Position + Vector3.new(0,5,0)), 0.8)
        end
    end
end)

-- Infinite Fly
local flying = false
local bv, bg
local function startFly()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if not root or not hum then return end
    flying = true
    hum.PlatformStand = true
    bg = Instance.new("BodyGyro", root); bg.P = 9e4; bg.maxTorque = Vector3.new(9e9,9e9,9e9); bg.CFrame = root.CFrame
    bv = Instance.new("BodyVelocity", root); bv.Velocity = Vector3.new(0,0,0); bv.maxForce = Vector3.new(9e9,9e9,9e9)
    task.spawn(function()
        while flying and task.wait() do
            local cam = workspace.CurrentCamera
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
            bv.Velocity = dir.Unit * Config.FlySpeed
            bg.CFrame = cam.CFrame
        end
    end)
end
task.spawn(function()
    while task.wait(0.2) do
        if Config.InfiniteFly then
            if not flying then startFly() end
        else
            if flying then flying = false; if bg then bg:Destroy() end; if bv then bv:Destroy() end
                LocalPlayer.Character:FindFirstChild("Humanoid").PlatformStand = false
            end
        end
    end
end)

-- GUI Tabs
local Main = Window:Tab({Title="Main", Icon="rocket"})
local Player = Window:Tab({Title="Player", Icon="user"})
local Combat = Window:Tab({Title="Combat", Icon="sword"})
local Forge = Window:Tab({Title="Forge", Icon="anvil"})
local Teleport = Window:Tab({Title="Teleport", Icon="map"})

-- Main Tab
Main:Button({Title="Redeem All Codes", Callback=RedeemAllCodes})
Main:Toggle({Title="Auto Mine", Callback=function(v) Config.AutoMine = v end})
local rocks = {"Pebble"}
Main:Dropdown({Title="Mine Target", Values=rocks, Multi=false, Callback=function(v) Config.MineTarget = v end})

-- Player Tab
Player:Toggle({Title="Auto Run", Callback=function(v) Config.AutoRun = v task.spawn(function() while Config.AutoRun do Remotes.Run:InvokeServer() task.wait(1) end end) end})
Player:Toggle({Title="Infinite Fly", Callback=function(v) Config.InfiniteFly = v end})
Player:Slider({Title="Fly Speed", Min=20, Max=300, Value=80, Callback=function(v) Config.FlySpeed = v end})
Player:Toggle({Title="Click TP (Ctrl+Click)", Callback=function(v) Config.ClickTeleport = v end})

-- Combat Tab
Combat:Toggle({Title="Auto Attack", Callback=function(v) Config.AutoAttack = v end})
Combat:Toggle({Title="Auto Parry", Callback=function(v) Config.AutoParry = v end})
local mobs = {}
Combat:Dropdown({Title="Target Mobs", Values=mobs, Multi=true, Callback=function(t)
    Config.AttackTargets = {}
    for _,m in ipairs(t) do Config.AttackTargets[m] = true end
end})

-- Forge Tab
local selectedOres = {}
local oreAmt = 3
Forge:Button({Title="Start Instant Forge", Callback=function()
    if next(selectedOres) == nil then return Window:Notify("Error","Select ores!") end
    if oreAmt < 3 then return Window:Notify("Error","Amount >= 3!") end
    local ores = {}
    for ore,_ in pairs(selectedOres) do ores[ore] = oreAmt end
    InstantForge(ores, Config.ForgeItemType)
end})
Forge:Dropdown({Title="Select Ores", Values={}, Multi=true, Callback=function(v)
    selectedOres = {}
    for _,o in ipairs(v) do selectedOres[o] = true end
end})
Forge:Slider({Title="Ore Amount", Min=3, Max=100, Value=3, Callback=function(v) oreAmt = v end})
Forge:Toggle({Title="Forge Weapon", Value=true, Callback=function(v) if v then Config.ForgeItemType="Weapon" end end})
Forge:Toggle({Title="Forge Armor", Callback=function(v) if v then Config.ForgeItemType="Armor" end end})

-- Teleport Tab
local locations = {}
local selectedLoc
Teleport:Dropdown({Title="Location", Values=locations, Callback=function(v) selectedLoc = v end})
Teleport:Button({Title="Teleport", Callback=function()
    if not selectedLoc then return end
    local obj = Workspace.Proximity:FindFirstChild(selectedLoc)
    if obj then
        local cf = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.CFrame or obj:GetPivot()) or obj.CFrame
        TweenTeleport(cf + Vector3.new(0,5,0), 1)
    end
end})

-- Auto Refresh Dropdowns
task.spawn(function()
    while task.wait(3) do
        -- Rocks
        local newRocks = {}
        pcall(function()
            for _,cat in ipairs(Workspace.Rocks:GetChildren()) do
                for _,rock in ipairs(cat:GetDescendants()) do
                    if rock:IsA("Model") and rock:FindFirstChild("Hitbox") then
                        table.insert(newRocks, rock.Name)
                    end
                end
            end
        end)
        if #newRocks > 0 then Main:FindFirstChild("Mine Target").Refresh(newRocks) end

        -- Mobs
        local newMobs = {}
        pcall(function()
            for _,m in ipairs(Workspace.Living:GetChildren()) do
                if m:IsA("Model") and m:FindFirstChild("Humanoid") then
                    local n = m.Name:gsub("%d+$","")
                    if not table.find(newMobs, n) then table.insert(newMobs, n) end
                end
            end
        end)
        if #newMobs > 0 then Combat:FindFirstChild("Target Mobs").Refresh(newMobs) end

        -- Teleports
        local newLocs = {}
        pcall(function()
            for _,loc in ipairs(Workspace.Proximity:GetChildren()) do
                table.insert(newLocs, loc.Name)
            end
        end)
        if #newLocs > 0 then Teleport:FindFirstChild("Location").Refresh(newLocs) end

        -- Forge Ores
        local ores = {}
        pcall(function()
            local gui = LocalPlayer.PlayerGui:FindFirstChild("Forge")
            if gui then
                for _,ore in ipairs(gui.OreSelect.OresFrame.Frame.Background:GetChildren()) do
                    if ore:FindFirstChild("Main") then table.insert(ores, ore.Name) end
                end
            end
        end)
        if #ores > 0 then Forge:FindFirstChild("Select Ores").Refresh(ores) end
    end
end)

Window:Notify("DYHUB Loaded!", "Version "..version.." | All features fixed & using Tween")
