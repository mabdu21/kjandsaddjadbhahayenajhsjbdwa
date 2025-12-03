if game.GameId ~= 7671049560 then
    warn("[DYHUB] Not in the correct game!")
    return
end

-- Powered by GPT 5 | v809
-- ======================
local version = "2.4.1"
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
    -- ✅ ตัวตรวจจับหลักจาก identifyexecutor()
    if identifyexecutor then
        local name, ver = identifyexecutor()
        executorName = ver and (name .. " (" .. ver .. ")") or name
        return
    end

    -- ✅ ตัวตรวจจับสำรองจาก getexecutorname()
    if getexecutorname then
        executorName = getexecutorname()
        return
    end

    -- ✅ ตรวจจาก global flags (สำหรับ executor ยอดนิยม)
    local globals = getgenv and getgenv() or _G
    local checkList = {
        { "Delta", "Delta successfully" },
        { "Xeno", "Xeno successfully" },
        { "Zenith", "Zenith successfully" },
        { "Wave", "Wave successfully" },
	    { "Volt", "Volt successfully" },
	    { "Volcano", "Volcano successfully" },
        { "Velocity", "Velocity successfully" },
        { "Seliware", "Seliware successfully" },
	    { "Valex", "Valex successfully" },
	    { "Potassium", "Potassium successfully" },
        { "Bunni", "Bunni successfully" },
        { "Sirhurt", "Sirhurt successfully" },
	    { "Delta", "Delta successfully" },
	    { "Codex", "Codex successfully" },
	    { "Solara", "Solara: Not Support" },
	    { "Cryptic", "Cryptic successfully" },
        { "Krnl", "Krnl successfully" },
    }

    for _, data in ipairs(checkList) do
        local key, name = unpack(data)
        if globals[key] ~= nil or getfenv()[key] ~= nil then
            executorName = name
            return
        end
    end

    -- ✅ ตรวจชื่อไฟล์ Lua Environment เผื่อบาง executor
    local info = debug.getinfo(1, "S")
    if info and info.source then
        local src = string.lower(info.source)
        if src:find("synapse") then executorName = "Synapse Z successfully" end
        if src:find("fluxus") then executorName = "Rip Fluxus successfully" end
        if src:find("krnl") then executorName = "Krnl successfully" end
        if src:find("delta") then executorName = "Delta successfully" end
    end
end)

-- ✅ แจ้งเตือนผ่าน WindUI
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
    Author = "The Forge | " .. userversion,
    Folder = "DYHUB_TF",
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
        Color = Color3.fromHex("#30ff6a")
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

local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local Main1Divider = Window:Divider()
local Maintab = Window:Tab({ Title = "Main", Icon = "rocket" })
local Playertab = Window:Tab({ Title = "Player", Icon = "user" })
local Teleporttab = Window:Tab({ Title = "Teleport", Icon = "map" })
local Autotab = Window:Tab({ Title = "Forge", Icon = "anvil" })
local Combattab = Window:Tab({ Title = "Combat", Icon = "sword" })


Maintab:Section({ Title = "Farming", Icon = "tractor" })
Maintab:Toggle({Title="Auto Mine", Value=Config.AutoMine, Callback=function(v) Config.AutoMine=v end})

local SeenRocks = {}
local RockList = {}

local Dropdown

task.spawn(function()
    while true do
        if ScriptAPI.GetRockTypes then
            for _, rockName in ipairs(ScriptAPI.GetRockTypes()) do
                if not SeenRocks[rockName] then
                    SeenRocks[rockName] = true
                    table.insert(RockList, rockName)

                    -- อัปเดต Dropdown ถ้ามีอยู่แล้ว
                    if Dropdown then
                        Dropdown:Refresh(RockList)
                    end
                end
            end

            -- ถ้ายังไม่ได้สร้าง Dropdown ให้สร้างตอนนี้
            if not Dropdown then
                Dropdown = Maintab:Dropdown({
                    Title = "Target Mine",
                    Values = RockList,
                    Multi = false,
                    Callback = function(value)
                        Config.MineTarget = value
                    end
                })
            end
        end

        task.wait(5)
    end
end)

Maintab:AddToggle("Auto Run", Config.AutoRun, function(state)
    UpdateSetting("AutoRun", state)
end)

Maintab:AddToggle("", Config., function(state)
    UpdateSetting("InfiniteFly", state)
end)

Maintab:AddToggle("Click TP (Ctrl + Click)", Config.ClickTeleport, function(state)
    UpdateSetting("ClickTeleport", state)
end)

Maintab:Section({ Title = "Player", Icon = "user" })
Maintab:Toggle({Title="Auto Run", Value=Config.AutoRun, Callback=function(v) Config.AutoRun=v end})
Maintab:Toggle({Title="Infinite Fly (PC ONLY)", Value=Config.InfiniteFly, Callback=function(v) Config.InfiniteFly=v end})
Maintab:Toggle({Title="Click TP (Ctrl + Click)", Value=Config.ClickTeleport, Callback=function(v) Config.ClickTeleport=v end})

Maintab:Section({ Title = "Code", Icon = "gift" })
Maintab:Button({
    Title = "Redeem Code All",
    Callback = function()
       RedeemAllCodes()
    end
})

Combattab:Section({ Title = "Combat", Icon = "swords" })
Combattab:Toggle({
    Title = "Auto Attack",
    Value = Config.AutoAttack,
    Callback = function(v)
        Config.AutoAttack = v
        if v and Config.AutoRun then
        end
    end
})

Combattab:Toggle({
    Title = "Auto Block",
    Value = Config.AutoParry,
    Callback = function(v)
        Config.AutoParry = v
    end
})

local CurrentMobList = {}
local DropdownMob

task.spawn(function()
    while true do
        if ScriptAPI.GetMobTypes then
            local mobTypes = ScriptAPI.GetMobTypes()

            -- ตรวจเช็คว่ารายชื่อ mob มีการเปลี่ยนแปลงไหม
            local changed = false
            if #mobTypes ~= #CurrentMobList then
                changed = true
            else
                for i, v in ipairs(mobTypes) do
                    if v ~= CurrentMobList[i] then
                        changed = true
                        break
                    end
                end
            end

            -- ถ้ามีการเปลี่ยนแปลง → อัปเดต Dropdown
            if changed then
                CurrentMobList = mobTypes

                if DropdownMob then
                    DropdownMob:SetValues(mobTypes)
                else
                    DropdownMob = Combattab:Dropdown({
                        Title = "Target Mob",
                        Values = mobTypes,
                        Multi = false,
                        Callback = function(value)
                            Config.AttackTarget = value
                        end
                    })
                end
            end
        end

        task.wait(5)
    end
end)

Autotab:Section({ Title = "Forge", Icon = "pickaxe" })
Autotab:Paragraph({
    Title = "WARNING (Instant Forge)",
    Desc = "• If you use Instant Forge, you MUST quit and reopen the game before using the forge manually! \n• Select ore quantities and forge instantly.",
    Image = "rbxassetid://104487529937663",
    ImageSize = 45,
    Locked = false
})

--========================================
--   VARIABLES
--========================================
local SelectedOre = nil
local SelectedOreAmount = 1
local OreDropdown = nil

local ForgeTypes = {"Weapon", "Armor"}
local ForgeTypeChecks = {}

--========================================
--   BUTTON: Instant Forge
--========================================
Autotab:Button({
    Title = "Instant Forge",
    Callback = function()
        if not SelectedOre then
            Window:Notify("Error", "Please select an ore first!", 3)
            return
        end

        if SelectedOreAmount < 3 then
            Window:Notify("Error", "Amount must be at least 3!", 3)
            return
        end

        local finalOres = {}
        finalOres[SelectedOre] = SelectedOreAmount

        if ScriptAPI.InstantForge then
            ScriptAPI.InstantForge(finalOres, Config.ForgeItemType, function(title, msg, time)
                Window:Notify(title, msg, time)
            end)
        end
    end
})

--========================================
--   FORGE ITEM TYPE (Weapon / Armor)
--========================================
for _, fType in ipairs(ForgeTypes) do
    local chk
    chk = InstantForgeSection:AddCheckmark("Type: " .. fType, Config.ForgeItemType == fType, function(state)
        if state then
            -- แทน UpdateSetting → ใช้แบบนี้แทน
            Config.ForgeItemType = fType 

            for name, box in pairs(ForgeTypeChecks) do
                if name ~= fType and box then 
                    box:Set(false)
                end
            end
        elseif Config.ForgeItemType == fType and chk then
            chk:Set(true)
        end
    end)
    ForgeTypeChecks[fType] = chk
end

--========================================
--   DROPDOWN: Select Ore
--========================================
OreDropdown = Autotab:Dropdown({
    Title = "Select Ore",
    Values = {},
    Multi = true,
    Callback = function(val)
        SelectedOre = val
    end
})

--========================================
--   INPUT: Set Amount
--========================================
Autotab:Input({
    Title = "Set Amount (Value)",
    Value = "1",
    Placeholder = "Amount",
    Callback = function(text)
        local num = tonumber(text)
        if num and num > 0 then
            SelectedOreAmount = num
        else
            warn("Entered an incorrect number!")
        end
    end
})

--========================================
--   AUTO UPDATE ORE LIST INTO DROPDOWN
--========================================
task.spawn(function()
    while true do
        local availOres = ScriptAPI.GetAvailableOres and ScriptAPI.GetAvailableOres() or {}
        local oreList = {}

        for oreName in pairs(availOres) do
            table.insert(oreList, oreName)
        end

        table.sort(oreList)

        if OreDropdown and OreDropdown.SetValues then
            OreDropdown:SetValues(oreList)
        end

        task.wait(1)
    end
end)

local SelectedTeleport = nil

-- สร้าง Section
Teleporttab:Section({
    Title = "Teleport Location",
    Icon = "map"
})

-- สร้าง Dropdown
local TeleportDropdown = Teleporttab:Dropdown({
    Title = "Select Teleport",
    Values = {},
    Multi = false,
    Callback = function(val)
        SelectedTeleport = val
    end
})

-- ฟังก์ชันเทเลพอร์ต
local function TeleportTo(name)
    local proxFolder = workspace:FindFirstChild("Proximity")
    if not proxFolder then return end

    local target = proxFolder:FindFirstChild(name)
    if not target then return end

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
    end
end

-- Auto update รายชื่อใน Dropdown
task.spawn(function()
    while true do
        local proxFolder = workspace:FindFirstChild("Proximity")
        local list = {}

        if proxFolder then
            for _, loc in ipairs(proxFolder:GetChildren()) do
                if loc:IsA("Model") or loc:IsA("BasePart") then
                    table.insert(list, loc.Name)
                end
            end

            table.sort(list)
        end

        if TeleportDropdown and TeleportDropdown.SetValues then
            TeleportDropdown:SetValues(list)
        end

        task.wait(1)
    end
end)

-- ปุ่ม Teleport จริง
Teleporttab:Button({
    Title = "Teleport Now",
    Callback = function()
        if not SelectedTeleport then
            Window:Notify("Error", "Please select a teleport location!", 3)
            return
        end
        TeleportTo(SelectedTeleport)
    end
})

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

Info = InfoTab

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
