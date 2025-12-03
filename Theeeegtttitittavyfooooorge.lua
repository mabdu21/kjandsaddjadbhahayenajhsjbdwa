
-- Powered by GPT 5 | v809
-- ======================
local version = "2.5.0"  -- Upgraded version
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

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local executorName = "Unknown"
pcall(function()
    -- Primary executor detection from identifyexecutor()
    if identifyexecutor then
        local name, ver = identifyexecutor()
        executorName = ver and (name .. " (" .. ver .. ")") or name
        return
    end
    -- Fallback to getexecutorname()
    if getexecutorname then
        executorName = getexecutorname()
        return
    end
    -- Check global flags for popular executors
    local globals = getgenv and getgenv() or _G
    local checkList = {
        { "Delta", "Delta" },
        { "Xeno", "Xeno" },
        { "Zenith", "Zenith" },
        { "Wave", "Wave" },
        { "Volt", "Volt" },
        { "Volcano", "Volcano" },
        { "Velocity", "Velocity" },
        { "Seliware", "Seliware" },
        { "Valex", "Valex" },
        { "Potassium", "Potassium" },
        { "Bunni", "Bunni" },
        { "Sirhurt", "Sirhurt" },
        { "Codex", "Codex" },
        { "Solara", "Solara" },
        { "Cryptic", "Cryptic" },
        { "Krnl", "Krnl" },
    }
    for _, data in ipairs(checkList) do
        local key, name = unpack(data)
        if globals[key] ~= nil or getfenv()[key] ~= nil then
            executorName = name
            return
        end
    end
    -- Check Lua environment source for some executors
    local info = debug.getinfo(1, "S")
    if info and info.source then
        local src = string.lower(info.source)
        if src:find("synapse") then executorName = "Synapse Z" end
        if src:find("fluxus") then executorName = "Fluxus" end
        if src:find("krnl") then executorName = "Krnl" end
        if src:find("delta") then executorName = "Delta" end
    end
end)

-- Notify via WindUI
WindUI:Notify({
    Title = "DYHUB",
    Content = "Executor: " .. executorName .. ".",
    Duration = 6,
    Image = "cpu"
})

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
    Author = "The Forge | " .. userversion .. " | v" .. version,
    Folder = "DYHUB_TF",
    Size = UDim2.fromOffset(550, 450),  -- Slightly larger for premium feel
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.7,
    HasOutline = true,
    HideSearchBar = false,
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
    CornerRadius = UDim.new(0, 8),
    StrokeThickness = 1.5,
    Color = ColorSequence.new(Color3.fromRGB(20, 20, 20), Color3.fromRGB(100, 255, 100)),
    Draggable = true,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local KnitServices = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")

local function GetServiceRemote(serviceName, remoteType, remoteName)
    local success, result = pcall(function()
        return KnitServices:WaitForChild(serviceName):WaitForChild("RF"):WaitForChild(remoteName)
    end)
    return success and result or nil
end

local Remotes = {
    RedeemCode = GetServiceRemote("CodeService", "RF", "RedeemCode"),
    ToolActivated = GetServiceRemote("ToolService", "RF", "ToolActivated"),
    StartBlock = GetServiceRemote("ToolService", "RF", "StartBlock"),
    StopBlock = GetServiceRemote("ToolService", "RF", "StopBlock"),
    Run = GetServiceRemote("CharacterService", "RF", "Run"),
    ChangeSequence = GetServiceRemote("ForgeService", "RF", "ChangeSequence"),
    StartForge = GetServiceRemote("ForgeService", "RF", "StartForge"),
    Forge = GetServiceRemote("ProximityService", "RF", "Forge"),
}

local Config = {
    AutoRun = false,
    AutoMine = false,
    MineTarget = "Pebble",
    AutoAttack = false,
    AutoParry = false,
    AttackTargets = {},
    ForgeItemType = "Weapon",
    InfiniteFly = false,
    FlySpeed = 50,
    ClickTeleport = false,
}

local ScriptAPI = {}
local ActiveTargets = {
    Mining = nil,
    Combat = nil
}

local function RedeemAllCodes()
    if not Remotes.RedeemCode then 
        Window:Notify("Error", "RedeemCode remote not found!", 5)
        return 
    end
    
    local codes = {
        "200K!", "100K!", "40KLIKES", "20KLIKES", "15KLIKES",
        "10KLIKES", "5KLIKES", "BETARELEASE!", "POSTRELEASEQNA"
    }
    for _, code in ipairs(codes) do
        task.spawn(function()
            local success, err = pcall(function()
                Remotes.RedeemCode:InvokeServer(code)
            end)
            if not success then
                warn("Failed to redeem code: " .. code .. " - " .. err)
            end
        end)
        task.wait(0.3)  -- Slight delay for smoothness
    end
    Window:Notify("Success", "All codes redeemed!", 3)
end

local function InitializeAutoMine()
    ScriptAPI.GetRockTypes = function()
        local rockTypes = {}
        local seen = {}
        local rocksFolder = Workspace:FindFirstChild("Rocks")
        
        if rocksFolder then
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
        end
        table.sort(rockTypes)
        return rockTypes
    end

    local function FindNearestRock(maxDist)
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
        
        local root = char.HumanoidRootPart
        local closestRock = nil
        local bestDist = maxDist or 15
        local rocksFolder = Workspace:FindFirstChild("Rocks")
        if not rocksFolder then return nil end

        for _, descendant in ipairs(rocksFolder:GetDescendants()) do
            if descendant.Name == "Hitbox" and descendant:IsA("BasePart") and descendant.Parent and descendant.Parent.Name == Config.MineTarget then
                local infoFrame = descendant.Parent:FindFirstChild("infoFrame")
                local hpText = infoFrame and infoFrame:FindFirstChild("Frame") and infoFrame.Frame:FindFirstChild("rockHP") and infoFrame.Frame.rockHP.Text
                
                local isValid = true
                if hpText then
                    local hp = tonumber(hpText:match("^(%d+)"))
                    if not hp or hp <= 0 then isValid = false end
                end
                if isValid then
                    local dist = (descendant.Position - root.Position).Magnitude
                    if dist < bestDist then
                        closestRock = descendant
                        bestDist = dist
                    end
                end
            end
        end
        return closestRock
    end

    task.spawn(function()
        while true do
            task.wait(0.05)  -- Smoother loop
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChild("Humanoid")
            if Config.AutoMine and Remotes.ToolActivated and root and humanoid then
                local pickaxe = char:FindFirstChild("Pickaxe")
                if not pickaxe then
                    local backpackPick = LocalPlayer.Backpack:FindFirstChild("Pickaxe")
                    if backpackPick then
                        humanoid:EquipTool(backpackPick)
                        task.wait(0.2)  -- Delay for equip
                    end
                end
                local targetValid = false
                if ActiveTargets.Mining and ActiveTargets.Mining.Parent and ActiveTargets.Mining.Parent.Name == Config.MineTarget then
                    local infoFrame = ActiveTargets.Mining.Parent:FindFirstChild("infoFrame")
                    local hpText = infoFrame and infoFrame:FindFirstChild("Frame") and infoFrame.Frame:FindFirstChild("rockHP") and infoFrame.Frame.rockHP.Text
                    if hpText then
                        local hp = tonumber(hpText:match("^(%d+)"))
                        if hp and hp > 0 then targetValid = true end
                    else
                        targetValid = true
                    end
                end
                if not targetValid then ActiveTargets.Mining = nil end
                if not ActiveTargets.Mining then
                    ActiveTargets.Mining = FindNearestRock(500)
                end
                if pickaxe and ActiveTargets.Mining and humanoid.Health > 0 and ActiveTargets.Mining.Parent then
                    local dist = (root.Position - ActiveTargets.Mining.Position).Magnitude
                    if dist <= 15 then
                        Remotes.ToolActivated:InvokeServer("Pickaxe")
                    end
                end
            else
                ActiveTargets.Mining = nil
            end
        end
    end)

    RunService.Heartbeat:Connect(function(delta)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if Config.AutoMine and ActiveTargets.Mining and ActiveTargets.Mining.Parent and root then
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            
            local targetPos = ActiveTargets.Mining.Position
            root.CFrame = CFrame.lookAt(targetPos + Vector3.new(5, 0, 0), targetPos)
        end
    end)
end

local function InitializeAutoRun()
    task.spawn(function()
        while true do
            task.wait(0.1)
            if Config.AutoRun and Remotes.Run then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    Remotes.Run:InvokeServer()
                end
            end
        end
    end)
end

local function InitializeCombat()
    local isBlocking = false
    ScriptAPI.GetMobTypes = function()
        local mobs = {}
        local seen = {}
        local living = Workspace:FindFirstChild("Living")
        
        if living then
            for _, model in ipairs(living:GetChildren()) do
                if model:IsA("Model") and model:FindFirstChild("Humanoid") and not model:FindFirstChild("RaceFolder") and not model:FindFirstChild("Animate") then
                    local name = model.Name:gsub("%d+$", "")
                    if not seen[name] then
                        seen[name] = true
                        table.insert(mobs, name)
                    end
                end
            end
        end
        table.sort(mobs)
        return mobs
    end

    local function FindTarget(maxDist)
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
        
        local root = char.HumanoidRootPart
        local bestTarget = nil
        local bestDist = maxDist or 100
        
        local living = Workspace:FindFirstChild("Living")
        if not living then return nil end

        for _, mob in ipairs(living:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("Humanoid") then
                local cleanName = mob.Name:gsub("%d+$", "")
                
                if Config.AttackTargets[cleanName]
                   and not mob:FindFirstChild("RaceFolder")
                   and not mob:FindFirstChild("Animate")
                   and mob.Humanoid.Health > 0
                   and mob:FindFirstChild("HumanoidRootPart") then
                    
                    local mobRoot = mob.HumanoidRootPart
                    local dist = (mobRoot.Position - root.Position).Magnitude
                    if dist < bestDist then
                        bestTarget = mob
                        bestDist = dist
                    end
                end
            end
        end
        return bestTarget
    end

    task.spawn(function()
        while true do
            task.wait(0.05)  -- Smoother
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if Config.AutoAttack and Remotes.ToolActivated and root and char:FindFirstChild("Humanoid") then
                local weapon = char:FindFirstChildWhichIsA("Tool")
                if not weapon or weapon.Name == "Pickaxe" or weapon.Name == "Hammer" then
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name ~= "Pickaxe" and tool.Name ~= "Hammer" then
                            char.Humanoid:EquipTool(tool)
                            task.wait(0.2)
                            weapon = tool
                            break
                        end
                    end
                end
                local targetValid = false
                if ActiveTargets.Combat and ActiveTargets.Combat.Parent and ActiveTargets.Combat:FindFirstChild("Humanoid") then
                    local name = ActiveTargets.Combat.Name:gsub("%d+$", "")
                    if ActiveTargets.Combat.Humanoid.Health > 0 and Config.AttackTargets[name] then
                        targetValid = true
                    end
                end
                if not targetValid then
                    ActiveTargets.Combat = nil
                    if isBlocking then
                        Remotes.StopBlock:InvokeServer()
                        isBlocking = false
                    end
                end
                if not ActiveTargets.Combat then
                    ActiveTargets.Combat = FindTarget(500)
                end
                local target = ActiveTargets.Combat
                if weapon and target and char.Humanoid.Health > 0 and target.Parent then
                    local shouldBlock = false
                    if Config.AutoParry then
                        local status = target:FindFirstChild("Status")
                        local attacking = status and status:FindFirstChild("Attacking")
                        if attacking and attacking.Value == true then
                            shouldBlock = true
                        end
                    end
                    if shouldBlock then
                        if not isBlocking then
                            Remotes.StartBlock:InvokeServer()
                            isBlocking = true
                        end
                    else
                        if isBlocking then
                            Remotes.StopBlock:InvokeServer()
                            isBlocking = false
                        end
                        
                        local targetRoot = target:FindFirstChild("HumanoidRootPart")
                        if targetRoot and (root.Position - targetRoot.Position).Magnitude <= 15 then
                            Remotes.ToolActivated:InvokeServer("Weapon")
                        end
                    end
                end
            else
                ActiveTargets.Combat = nil
                if isBlocking then
                    pcall(function() Remotes.StopBlock:InvokeServer() end)
                    isBlocking = false
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function(delta)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if Config.AutoAttack and ActiveTargets.Combat and ActiveTargets.Combat.Parent and root then
            local targetRoot = ActiveTargets.Combat:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                root.Anchored = false
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.CFrame = CFrame.lookAt((targetRoot.CFrame * CFrame.new(0, 0, 3)).Position, targetRoot.Position)
            end
        end
    end)
end

local function InitializeForge()
    local function InstantForge(ores, itemType, callback)
        local forgeModel = Workspace:WaitForChild("Proximity"):WaitForChild("Forge")
        
        if not Remotes.ChangeSequence or not Remotes.StartForge or not Remotes.Forge or not forgeModel then
            if callback then callback("Error", "Failed to find necessary remotes or Forge model.", 5) end
            return
        end
        if not itemType then itemType = "Weapon" end
        if callback then callback("Forge", "Starting Instant Forge... Please do not close the window.", 5) end

        Remotes.Forge:InvokeServer(forgeModel)
        task.wait(0.1)
        Remotes.StartForge:InvokeServer(forgeModel)
        task.wait(0.2)
        
        Remotes.ChangeSequence:InvokeServer(unpack({
            "Melt",
            {
                FastForge = false,
                ItemType = itemType,
                Ores = ores
            }
        }))
        
        task.wait(0.5)
        Remotes.ChangeSequence:InvokeServer("Pour", { ClientTime = Workspace:GetServerTimeNow() })
        
        task.wait(0.5)
        Remotes.ChangeSequence:InvokeServer("Hammer", { ClientTime = Workspace:GetServerTimeNow() })
        
        task.wait(0.5)
        task.spawn(function()
            Remotes.ChangeSequence:InvokeServer("Water", { ClientTime = Workspace:GetServerTimeNow() })
        end)
        
        task.wait(0.5)
        Remotes.ChangeSequence:InvokeServer("Showcase", {})
        
        if callback then callback("Success", "Instant Forge Completed! You can close the window.", 5) end
    end

    local function GetAvailableOres()
        local oreData = {}
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return {} end
        local oreFrame = playerGui:FindFirstChild("Forge")
            and playerGui.Forge:FindFirstChild("OreSelect")
            and playerGui.Forge.OreSelect:FindFirstChild("OresFrame")
            and playerGui.Forge.OreSelect.OresFrame:FindFirstChild("Frame")
            and playerGui.Forge.OreSelect.OresFrame.Frame:FindFirstChild("Background")
        if not oreFrame then return {} end

        for _, child in ipairs(oreFrame:GetChildren()) do
            local main = child:FindFirstChild("Main")
            local quantityLabel = main and main:FindFirstChild("Quantity")
            
            if quantityLabel then
                local text = quantityLabel.Text or (quantityLabel:FindFirstChild("Text") and quantityLabel.Text.Text)
                if text then
                    local qty = tonumber(text:match("%d+"))
                    if qty then
                        oreData[child.Name] = qty
                    end
                end
            end
        end
        return oreData
    end

    ScriptAPI.InstantForge = InstantForge
    ScriptAPI.GetAvailableOres = GetAvailableOres
end

local function InitializeMovement()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if Config.ClickTeleport and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local mouse = LocalPlayer:GetMouse()
            
            if root and mouse.Hit then
                root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end
    end)

    local bg, bv
    local flying = false
    local function stopFly()
        flying = false
        if bg then bg:Destroy(); bg = nil end
        if bv then bv:Destroy(); bv = nil end
        
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end

    local function startFly()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChild("Humanoid")
        
        if not root or not humanoid then return end
        
        flying = true
        humanoid.PlatformStand = true
        
        bg = Instance.new("BodyGyro", root)
        bg.P = 90000
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = root.CFrame
        
        bv = Instance.new("BodyVelocity", root)
        bv.Velocity = Vector3.zero
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        task.spawn(function()
            while flying do
                local cam = Workspace.CurrentCamera
                if cam then
                    local direction = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
                    
                    if direction.Magnitude > 0 then
                        bv.Velocity = direction.Unit * Config.FlySpeed
                    else
                        bv.Velocity = Vector3.zero
                    end
                    bg.CFrame = cam.CFrame
                    RunService.RenderStepped:Wait()
                else
                    break
                end
            end
            stopFly()
        end)
    end

    task.spawn(function()
        while true do
            task.wait(0.2)
            if Config.InfiniteFly then
                if not flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    startFly()
                end
            else
                if flying then
                    stopFly()
                end
            end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        if flying then stopFly() end
    end)
end

InitializeAutoMine()
InitializeAutoRun()
InitializeCombat()
InitializeForge()
InitializeMovement()

-- GUI Setup with Premium Feel
local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
InfoTab:Paragraph({
    Title = "Welcome to DYHUB Premium",
    Desc = "Enhanced features for smooth gameplay. Auto Mine and Instant Forge preserved and optimized.",
    Image = "rbxassetid://104487529937663",
    ImageSize = 50,
    Locked = false
})

local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map" })
local ForgeTab = Window:Tab({ Title = "Forge", Icon = "anvil" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "sword" })

MainTab:Section({ Title = "Farming", Icon = "tractor" })
MainTab:Toggle({Title="Auto Mine", Value=Config.AutoMine, Callback=function(v) Config.AutoMine = v end})

local RockList = {}
local RockDropdown
task.spawn(function()
    while true do
        if ScriptAPI.GetRockTypes then
            local newRocks = ScriptAPI.GetRockTypes()
            if #newRocks > #RockList then
                RockList = newRocks
                if RockDropdown then
                    RockDropdown:Refresh(RockList)
                end
            end
        end
        task.wait(3)  -- Reduced frequency for performance
    end
end)

RockDropdown = MainTab:Dropdown({
    Title = "Target Mine",
    Values = RockList,
    Multi = false,
    Callback = function(value)
        Config.MineTarget = value
    end
})

MainTab:Section({ Title = "Codes", Icon = "gift" })
MainTab:Button({
    Title = "Redeem All Codes",
    Callback = RedeemAllCodes
})

PlayerTab:Section({ Title = "Movement", Icon = "running" })
PlayerTab:Toggle({Title="Auto Run", Value=Config.AutoRun, Callback=function(v) Config.AutoRun = v end})
PlayerTab:Toggle({Title="Infinite Fly (PC ONLY)", Value=Config.InfiniteFly, Callback=function(v) Config.InfiniteFly = v end})
PlayerTab:Slider({
    Title = "Fly Speed",
    Min = 10,
    Max = 200,
    Value = Config.FlySpeed,
    Callback = function(v) Config.FlySpeed = v end
})
PlayerTab:Toggle({Title="Click TP (Ctrl + Click)", Value=Config.ClickTeleport, Callback=function(v) Config.ClickTeleport = v end})

CombatTab:Section({ Title = "Combat Features", Icon = "swords" })
CombatTab:Toggle({
    Title = "Auto Attack",
    Value = Config.AutoAttack,
    Callback = function(v)
        Config.AutoAttack = v
    end
})
CombatTab:Toggle({
    Title = "Auto Parry/Block",
    Value = Config.AutoParry,
    Callback = function(v)
        Config.AutoParry = v
    end
})

local MobList = {}
local MobDropdown
task.spawn(function()
    while true do
        if ScriptAPI.GetMobTypes then
            local newMobs = ScriptAPI.GetMobTypes()
            if #newMobs > #MobList then
                MobList = newMobs
                if MobDropdown then
                    MobDropdown:Refresh(MobList)
                end
            end
        end
        task.wait(3)
    end
end)

MobDropdown = CombatTab:Dropdown({
    Title = "Target Mobs",
    Values = MobList,
    Multi = true,
    Callback = function(selected)
        Config.AttackTargets = {}
        for _, mob in ipairs(selected) do
            Config.AttackTargets[mob] = true
        end
    end
})

ForgeTab:Section({ Title = "Instant Forge", Icon = "pickaxe" })
ForgeTab:Paragraph({
    Title = "WARNING",
    Desc = "• Use Instant Forge responsibly. Quit and reopen before manual forging.\n• Select ores and amounts for instant creation.",
    Image = "rbxassetid://104487529937663",
    ImageSize = 45,
    Locked = false
})

local SelectedOres = {}
local SelectedAmount = 3
local OreDropdown
local ForgeTypes = {"Weapon", "Armor"}
local ForgeTypeChecks = {}

ForgeTab:Button({
    Title = "Start Instant Forge",
    Callback = function()
        if not next(SelectedOres) then
            Window:Notify("Error", "Please select at least one ore!", 3)
            return
        end
        if SelectedAmount < 3 then
            Window:Notify("Error", "Amount must be at least 3!", 3)
            return
        end
        local finalOres = {}
        for ore in pairs(SelectedOres) do
            finalOres[ore] = SelectedAmount
        end
        if ScriptAPI.InstantForge then
            ScriptAPI.InstantForge(finalOres, Config.ForgeItemType, function(title, msg, time)
                Window:Notify(title, msg, time)
            end)
        end
    end
})

for _, fType in ipairs(ForgeTypes) do
    ForgeTypeChecks[fType] = ForgeTab:Toggle({
        Title = "Forge Type: " .. fType,
        Value = Config.ForgeItemType == fType,
        Callback = function(state)
            if state then
                Config.ForgeItemType = fType
                for otherType, toggle in pairs(ForgeTypeChecks) do
                    if otherType ~= fType then
                        toggle:Set(false)
                    end
                end
            end
        end
    })
end

OreDropdown = ForgeTab:Dropdown({
    Title = "Select Ores",
    Values = {},
    Multi = true,
    Callback = function(selected)
        SelectedOres = {}
        for _, ore in ipairs(selected) do
            SelectedOres[ore] = true
        end
    end
})

ForgeTab:Slider({
    Title = "Ore Amount",
    Min = 3,
    Max = 100,
    Value = SelectedAmount,
    Callback = function(v)
        SelectedAmount = v
    end
})

task.spawn(function()
    while true do
        local availOres = ScriptAPI.GetAvailableOres() or {}
        local oreList = {}
        for oreName in pairs(availOres) do
            table.insert(oreList, oreName)
        end
        table.sort(oreList)
        if OreDropdown then
            OreDropdown:Refresh(oreList)
        end
        task.wait(2)  -- Optimized refresh
    end
end)

TeleportTab:Section({ Title = "Teleport Locations", Icon = "map" })

local TeleportLocations = {}
local TeleportDropdown = TeleportTab:Dropdown({
    Title = "Select Location",
    Values = {},
    Multi = false,
    Callback = function(val)
        SelectedTeleport = val
    end
})

local function TeleportTo(name)
    local proxFolder = Workspace:FindFirstChild("Proximity")
    if not proxFolder then 
        Window:Notify("Error", "Proximity folder not found!", 3)
        return 
    end
    local target = proxFolder:FindFirstChild(name)
    if not target then 
        Window:Notify("Error", "Location not found!", 3)
        return 
    end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local targetCFrame
    if target:IsA("Model") then
        targetCFrame = target.PrimaryPart and target.PrimaryPart.CFrame or target:GetPivot()
    elseif target:IsA("BasePart") then
        targetCFrame = target.CFrame
    end
    if targetCFrame then
        root.CFrame = targetCFrame + Vector3.new(0, 3, 0)
        Window:Notify("Success", "Teleported to " .. name .. "!", 3)
    end
end

task.spawn(function()
    while true do
        local proxFolder = Workspace:FindFirstChild("Proximity")
        local newList = {}
        if proxFolder then
            for _, loc in ipairs(proxFolder:GetChildren()) do
                if loc:IsA("Model") or loc:IsA("BasePart") then
                    table.insert(newList, loc.Name)
                end
            end
            table.sort(newList)
        end
        if #newList > #TeleportLocations then
            TeleportLocations = newList
            TeleportDropdown:Refresh(newList)
        end
        task.wait(2)
    end
end)

TeleportTab:Button({
    Title = "Teleport Now",
    Callback = function()
        if not SelectedTeleport then
            Window:Notify("Error", "Select a location first!", 3)
            return
        end
        TeleportTo(SelectedTeleport)
    end
})

-- Game Data Callback for WindUI
Library.SetGameDataCallback(function()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    local level = 0
    local gold = 0
    local inventory = {}
    if gui then
        local hud = gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Screen") and gui.Main.Screen:FindFirstChild("Hud")
        if hud then
            local lvlLbl = hud:FindFirstChild("Level")
            if lvlLbl then level = tonumber(lvlLbl.Text:match("%d+")) or 0 end
            
            local goldLbl = hud:FindFirstChild("Gold")
            if goldLbl then gold = tonumber(goldLbl.Text:gsub("[$,]", "")) or goldLbl.Text end
        end
        
        local stash = gui:FindFirstChild("Menu") and gui.Menu:FindFirstChild("Frame") and gui.Menu.Frame:FindFirstChild("Frame")
            and gui.Menu.Frame.Frame:FindFirstChild("Menus") and gui.Menu.Frame.Frame.Menus:FindFirstChild("Stash")
            and gui.Menu.Frame.Frame.Menus.Stash:FindFirstChild("Background")
            
        if stash then
            for _, itemFrame in ipairs(stash:GetChildren()) do
                local main = itemFrame:FindFirstChild("Main")
                if main then
                    local nameLbl = main:FindFirstChild("ItemName")
                    local qtyLbl = main:FindFirstChild("Quantity")
                    
                    if nameLbl and qtyLbl then
                        local iName = nameLbl.Text
                        local iQty = qtyLbl.Text
                        if iName ~= "" and iQty ~= "" then
                            inventory[iName] = tonumber(iQty:match("%d+")) or iQty
                        end
                    end
                end
            end
        end
    end
    local features = {}
    for k, v in pairs(Config) do features[k] = v end
    return {
        level = level,
        gold = gold,
        inventory = inventory,
        timestamp = os.time(),
        features = features,
    }
end)
