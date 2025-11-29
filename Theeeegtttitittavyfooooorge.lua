if game.GameId ~= 7671049560 then
    warn("[DYHUB] Not in the correct game!")
    return
end

if _G.HazePrivate then
    warn("[DYHUB] UI already initialized")
    return
end

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
    ClickTeleport = false,
}

local ScriptAPI = {}
local ActiveTargets = {
    Mining = nil,
    Combat = nil
}

local function RedeemAllCodes()
    if not Remotes.RedeemCode then return end
    
    local codes = {
        "200K!", "100K!", "40KLIKES", "20KLIKES", "15KLIKES", 
        "10KLIKES", "5KLIKES", "BETARELEASE!", "POSTRELEASEQNA"
    }

    for _, code in ipairs(codes) do
        task.spawn(function()
            Remotes.RedeemCode:InvokeServer(code)
        end)
        task.wait(0.2)
    end
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
            task.wait(0.1)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChild("Humanoid")

            if Config.AutoMine and Remotes.ToolActivated and root and humanoid then
                local pickaxe = char:FindFirstChild("Pickaxe")
                if not pickaxe then
                    local backpackPick = LocalPlayer.Backpack:FindFirstChild("Pickaxe")
                    if backpackPick then
                        humanoid:EquipTool(backpackPick)
                        pickaxe = backpackPick
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

    RunService.Heartbeat:Connect(function()
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
                
                if Config.AttackTargets and Config.AttackTargets[cleanName] 
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
            task.wait(0.1)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if Config.AutoAttack and Remotes.ToolActivated and root and char:FindFirstChild("Humanoid") then
                local weapon = char:FindFirstChildWhichIsA("Tool")
                if not weapon or weapon.Name == "Pickaxe" or weapon.Name == "Hammer" then
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name ~= "Pickaxe" and tool.Name ~= "Hammer" then
                            char.Humanoid:EquipTool(tool)
                            weapon = tool
                            break
                        end
                    end
                end

                local targetValid = false
                if ActiveTargets.Combat and ActiveTargets.Combat.Parent and ActiveTargets.Combat:FindFirstChild("Humanoid") then
                    local name = ActiveTargets.Combat.Name:gsub("%d+$", "")
                    if ActiveTargets.Combat.Humanoid.Health > 0 and Config.AttackTargets and Config.AttackTargets[name] then
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

    RunService.Heartbeat:Connect(function()
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
        task.wait()
        Remotes.StartForge:InvokeServer(forgeModel)
        task.wait(0.1)
        
        Remotes.ChangeSequence:InvokeServer(unpack({
            "Melt",
            {
                FastForge = false,
                ItemType = itemType,
                Ores = ores
            }
        }))
        
        task.wait(1)
        Remotes.ChangeSequence:InvokeServer("Pour", { ClientTime = Workspace:GetServerTimeNow() })
        
        task.wait(1)
        Remotes.ChangeSequence:InvokeServer("Hammer", { ClientTime = Workspace:GetServerTimeNow() })
        
        task.wait(1)
        task.spawn(function()
            Remotes.ChangeSequence:InvokeServer("Water", { ClientTime = Workspace:GetServerTimeNow() })
        end)
        
        task.wait(1)
        Remotes.ChangeSequence:InvokeServer("Showcase", {})
        
        if callback then callback("Forge", "Instant Forge Completed! You can close the window.", 5) end
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
                local text = nil
                if quantityLabel:IsA("TextLabel") or quantityLabel:IsA("TextBox") then
                    text = quantityLabel.Text
                elseif quantityLabel:FindFirstChild("Text") then
                    text = quantityLabel.Text.Text
                end

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
    local flySpeed = 50

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
        bg.cframe = root.CFrame
        
        bv = Instance.new("BodyVelocity", root)
        bv.velocity = Vector3.zero
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

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
                        bv.velocity = direction.Unit * flySpeed
                    else
                        bv.velocity = Vector3.zero
                    end
                    bg.cframe = cam.CFrame
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

local Library = loadstring(game:HttpGet("https://haze.wtf/api/ui"))()
task.wait(0.5)

if not Library or not Library.GetStatus or not _G.HazePrivate then
    warn("[Haze] Failed to load library!")
    return
end

local startTick = tick()
while not Library.GetStatus().verified do
    if tick() - startTick > 10 then break end
    task.wait(0.1)
end

if not Library.GetStatus().verified then
    warn("[Haze] Failed to verify library!")
    return
end

local Window = Library.new("Haze Script", MarketplaceService:GetProductInfo(game.PlaceId).Name or "Game Title", nil)
local ConfigName = "TheForge"

local SavedConfig = Library.InitializeConfig(ConfigName, Config)
for k, v in pairs(SavedConfig) do
    if Config[k] ~= nil then Config[k] = v end
end

if SavedConfig.AttackTarget and type(SavedConfig.AttackTarget) == "string" then
    if not Config.AttackTargets then Config.AttackTargets = {} end
    local count = 0
    for _ in pairs(Config.AttackTargets) do count = count + 1 end
    
    if count == 0 and SavedConfig.AttackTarget ~= "" then
        Config.AttackTargets[SavedConfig.AttackTarget] = true
    end
    Config.AttackTarget = nil
    Library.SaveConfig(ConfigName)
end

local function UpdateSetting(key, value)
    Config[key] = value
    Library.UpdateConfig(ConfigName, key, value)
end

local MainTab = Window:AddTab("Main", "rbxassetid://6026568198")
local FarmingSection = MainTab:AddSection("Farming")

FarmingSection:AddToggle("Auto Mine", Config.AutoMine, function(state)
    UpdateSetting("AutoMine", state)
end)

local RockCheckboxes = {}
local SeenRocks = {}

task.spawn(function()
    while true do
        if ScriptAPI.GetRockTypes then
            for _, rockName in ipairs(ScriptAPI.GetRockTypes()) do
                if not SeenRocks[rockName] then
                    SeenRocks[rockName] = true
                    
                    local checkbox
                    checkbox = FarmingSection:AddCheckmark("Target: " .. rockName, Config.MineTarget == rockName, function(state)
                        if state then
                            UpdateSetting("MineTarget", rockName)
                            for name, box in pairs(RockCheckboxes) do
                                if name ~= rockName and box then box:Set(false) end
                            end
                        elseif Config.MineTarget == rockName and checkbox then
                            checkbox:Set(true) 
                        end
                    end)
                    RockCheckboxes[rockName] = checkbox
                end
            end
        end
        task.wait(5)
    end
end)

local PlayerSection = MainTab:AddSection("Player")
PlayerSection:AddToggle("Auto Run", Config.AutoRun, function(state)
    UpdateSetting("AutoRun", state)
end)

PlayerSection:AddToggle("Infinite Fly", Config.InfiniteFly, function(state)
    UpdateSetting("InfiniteFly", state)
end)

PlayerSection:AddToggle("Click TP (Ctrl + Click)", Config.ClickTeleport, function(state)
    UpdateSetting("ClickTeleport", state)
end)

local CodesSection = MainTab:AddSection("Codes")
CodesSection:AddButton("Claim All Codes", function()
    RedeemAllCodes()
    Window:Notify("Codes", "Attempting to claim all codes...", 3)
end)

local CombatTab = Window:AddTab("Combat", "rbxassetid://4391741881")
local CombatSection = CombatTab:AddSection("Combat")

CombatSection:AddToggle("Auto Attack", Config.AutoAttack, function(state)
    UpdateSetting("AutoAttack", state)
    if state and Config.AutoRun then
    end
end)

CombatSection:AddCheckmark("Auto Block", Config.AutoParry, function(state)
    UpdateSetting("AutoParry", state)
end)

local MobCheckboxes = {}
task.spawn(function()
    while true do
        if ScriptAPI.GetMobTypes then
            for _, mobName in ipairs(ScriptAPI.GetMobTypes()) do
                if not MobCheckboxes[mobName] then
                    MobCheckboxes[mobName] = true
                    if Config.AttackTargets[mobName] == nil then Config.AttackTargets[mobName] = false end
                    
                    CombatSection:AddCheckmark("Target: " .. mobName, Config.AttackTargets[mobName], function(state)
                        Config.AttackTargets[mobName] = state
                        UpdateSetting("AttackTargets", Config.AttackTargets)
                    end)
                end
            end
        end
        task.wait(5)
    end
end)

local ForgeTab = Window:AddTab("Forge", "rbxassetid://132118792360603")
local InstantForgeSection = ForgeTab:AddSection("Instant Forge")

InstantForgeSection:SetDescription("⚠️ WARNING: If you use Instant Forge, you MUST quit and reopen the game before using the forge manually! \n\nSelect ore quantities and forge instantly.")

local OreSelections = {}
local OreSliders = {}

InstantForgeSection:AddButton("Instant Forge", function()
    if ScriptAPI.InstantForge then
        local finalOres = {}
        local totalQty = 0
        local typeCount = 0
        
        for name, qty in pairs(OreSelections) do
            if qty > 0 then
                finalOres[name] = qty
                totalQty = totalQty + qty
                typeCount = typeCount + 1
            end
        end
        
        if totalQty < 3 then
            Window:Notify("Error", "You must select at least 3 ores!", 3)
            return
        end
        if typeCount > 4 then
            Window:Notify("Error", "Too many ore types! Max 4 allowed.", 3)
            return
        end
        
        ScriptAPI.InstantForge(finalOres, Config.ForgeItemType, function(title, msg, time)
            Window:Notify(title, msg, time)
        end)
    end
end)

local ForgeTypes = {"Weapon", "Armor"}
local ForgeTypeChecks = {}

for _, fType in ipairs(ForgeTypes) do
    local chk
    chk = InstantForgeSection:AddCheckmark("Type: " .. fType, Config.ForgeItemType == fType, function(state)
        if state then
            UpdateSetting("ForgeItemType", fType)
            for name, box in pairs(ForgeTypeChecks) do
                if name ~= fType and box then box:Set(false) end
            end
        elseif Config.ForgeItemType == fType and chk then
            chk:Set(true)
        end
    end)
    ForgeTypeChecks[fType] = chk
end

task.spawn(function()
    while true do
        local availOres = ScriptAPI.GetAvailableOres and ScriptAPI.GetAvailableOres() or {}
        local sortedOres = {}
        
        for k in pairs(availOres) do table.insert(sortedOres, k) end
        table.sort(sortedOres)
        
        local currentOresInUI = {}

        for _, oreName in ipairs(sortedOres) do
            currentOresInUI[oreName] = true
            local maxQty = availOres[oreName]
            local currentSlider = OreSliders[oreName]
            
            if currentSlider then
                local currentVal = OreSelections[oreName] or 0
                if maxQty < currentVal then currentVal = maxQty end
                
                if currentVal ~= OreSelections[oreName] then
                    OreSelections[oreName] = currentVal
                end
                currentSlider:Set(currentVal, 0, maxQty)
            else
                local currentVal = OreSelections[oreName] or 0
                if maxQty < currentVal then currentVal = maxQty end
                
                OreSliders[oreName] = InstantForgeSection:AddSlider(oreName, 0, maxQty, currentVal, function(val)
                    OreSelections[oreName] = val
                end)
            end
        end

        for name, slider in pairs(OreSliders) do
            if not currentOresInUI[name] then
                if slider.Destroy then slider.Destroy() end
                OreSliders[name] = nil
                OreSelections[name] = 0
            end
        end
        task.wait(1)
    end
end)

local TeleportTab = Window:AddTab("Teleport", "rbxassetid://114223315914239")
local LocationsSection = TeleportTab:AddSection("Locations")

local function RefreshLocations()
    local proxFolder = Workspace:FindFirstChild("Proximity")
    if not proxFolder then
        LocationsSection:AddButton("No Proximity Folder Found", function() end)
        return
    end

    local children = proxFolder:GetChildren()
    table.sort(children, function(a, b) return a.Name < b.Name end)

    for _, loc in ipairs(children) do
        if loc:IsA("Model") or loc:IsA("BasePart") then
            LocationsSection:AddButton(loc.Name, function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local targetCFrame
                
                if loc:IsA("Model") then
                    targetCFrame = loc.PrimaryPart and loc.PrimaryPart.CFrame or loc:GetPivot()
                elseif loc:IsA("BasePart") then
                    targetCFrame = loc.CFrame
                end
                
                if root and targetCFrame then
                    root.CFrame = targetCFrame + Vector3.new(0, 3, 0)
                end
            end)
        end
    end
end
RefreshLocations()

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
