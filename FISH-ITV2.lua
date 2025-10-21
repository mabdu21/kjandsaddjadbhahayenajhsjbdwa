-- =========================
local version = "5.6.2"
-- =========================

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

WindUI:AddTheme({
    Name = "DYHUB Exploit", 
    Accent = WindUI:Gradient({                                                  
        ["0"] = { Color = Color3.fromHex("#1f1f23"), Transparency = 0 },        
        ["100"]   = { Color = Color3.fromHex("#18181b"), Transparency = 0 },    
    }, {                                                                        
        Rotation = 0,                                                           
    }),                                                                         
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa")
})

local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Fish It | " .. userversion,
    Folder = "DYHUB_FIT",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
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

-- TAB VARIABLES
local InfoTab = Window:Tab({ Title = "information", Icon = "info" })
local Main1Divider = Window:Divider()
local Auto = Window:Tab({ Title = "Main", Icon = "rocket" })
local Player = Window:Tab({ Title = "Player", Icon = "user" })
local Shop = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local Main2Divider = Window:Divider()
local Teleport = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local Quest = Window:Tab({ Title = "Quest", Icon = "loader" })
local Enchant = Window:Tab({ Title = "Enchants", Icon = "star" })
local MainDivider = Window:Divider()
local Discord = Window:Tab({ Title = "Webhook", Icon = "megaphone" })
local Setting = Window:Tab({ Title = "Settings", Icon = "settings" })
Window:SelectTab(1)

----------- END OF TAB VARIABLES -------------

-- GLOBAL DEPENDENCIES
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- ====================================================================
-- 2. LOGIC INFOS
-- ====================================================================

-- ====================================================================
-- 3. LOGIC PLAYER
-- ====================================================================

local Section = Player:Section({ 
    Title = "Player Feature",
})

local WalkSpeedInput = Player:Input({
    Title = "Set WalkSpeed",
    Placeholder = "Masukkan angka, contoh: 50",
    Callback = function(value)
        WalkSpeedInput.Value = tonumber(value) or 16
    end
})


local WalkSpeedToggle = Player:Toggle({
    Title = "WalkSpeed",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        if state then
           
            humanoid.WalkSpeed = WalkSpeedInput.Value or 16
        else
           
            humanoid.WalkSpeed = 16
        end
    end
})

Player:Space()
Player:Divider()

local InfiniteJumpConnection = nil

local InfiniteJumpToggle = Player:Toggle({
    Title = "Infinite Jump",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        
        if state then
            InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                local character = player.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if InfiniteJumpConnection then
                InfiniteJumpConnection:Disconnect()
                InfiniteJumpConnection = nil
            end
        end
    end
})

local NoClipConnection = nil

local NoClipToggle = Player:Toggle({
    Title = "NoClip",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        
        if state then
            NoClipConnection = game:GetService("RunService").Stepped:Connect(function()
                local character = player.Character
                if character then
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if NoClipConnection then
                NoClipConnection:Disconnect()
                NoClipConnection = nil
            end
            
            local character = player.Character
            if character then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

local walkOnWater = false
local waterPlatform = nil
local player = game.Players.LocalPlayer

local waterToggle = Player:Toggle({
    Title = "Walk On Water", 
    Default = false,
    Callback = function(state)
        walkOnWater = state
        local character = player.Character
        
        if state and character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                if waterPlatform then waterPlatform:Destroy() end
                
                waterPlatform = Instance.new("Part")
                waterPlatform.Name = "WaterPlatform"
                waterPlatform.Anchored = true
                waterPlatform.CanCollide = true
                waterPlatform.Size = Vector3.new(20, 1, 20)
                waterPlatform.Transparency = 1
                waterPlatform.Material = Enum.Material.Plastic
                
                local currentPos = humanoidRootPart.Position
                waterPlatform.Position = Vector3.new(currentPos.X, 0, currentPos.Z)
                waterPlatform.Parent = workspace
            end
        elseif waterPlatform then
            waterPlatform:Destroy()
            waterPlatform = nil
        end
    end
})

player.CharacterAdded:Connect(function(character)
    task.wait(1)
    if walkOnWater and waterPlatform and character:FindFirstChild("HumanoidRootPart") then
        local currentPos = character.HumanoidRootPart.Position
        waterPlatform.Position = Vector3.new(currentPos.X, 0, currentPos.Z)
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if walkOnWater and waterPlatform and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPos = player.Character.HumanoidRootPart.Position
        waterPlatform.Position = Vector3.new(rootPos.X, 0, rootPos.Z)
    end
end)


local respawnButton = Player:Button({
    Title = "Respawned at current position",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local currentPosition = character:GetPivot().Position            
            if humanoid then
                local savedPosition = currentPosition               
                humanoid.Health = 0               
                player.CharacterAdded:Connect(function(newCharacter)
                    task.wait(1)  
                    local newHumanoidRootPart = newCharacter:FindFirstChild("HumanoidRootPart")
                    if newHumanoidRootPart then
                        newHumanoidRootPart.CFrame = CFrame.new(savedPosition)
                    end
                end)
            end
        end
    end
})

Player:Space()
Player:Divider()

local Section = Player:Section({
    Title = "Gui External",
    Opened = true,
})

local FlyButton = Player:Button({
    Title = "Fly GUI",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()

        WindUI:Notify({
            Title = "Fly",
            Content = "Fly GUI by dyhub ✅",
            Duration = 3,
            Icon = "bell"
        })
    end
})

---------------- END OF PLAYER LOGIC ------------------

-- ====================================================================
-- 4. LOGIC AUTO (MAIN)
-- ====================================================================

local VirtualInputManager = game:GetService("VirtualInputManager")

task.spawn(function()
    local cycle = 0
    while true do
        cycle += 1
        
        local waitTime = math.random(600, 700)
        task.wait(waitTime)
        local keyCombos = {
            {Enum.KeyCode.LeftShift, Enum.KeyCode.E},    
            {Enum.KeyCode.LeftControl, Enum.KeyCode.F},     
            {Enum.KeyCode.Q, Enum.KeyCode.Tab},           
            {Enum.KeyCode.LeftShift, Enum.KeyCode.Q},     
            {Enum.KeyCode.E, Enum.KeyCode.F},             
        }
        
        local chosenCombo = keyCombos[math.random(1, #keyCombos)]
        pcall(function()
            for _, key in pairs(chosenCombo) do
                VirtualInputManager:SendKeyEvent(true, key, false, nil)
            end
            
            task.wait(0.1) 
                for _, key in pairs(chosenCombo) do
                VirtualInputManager:SendKeyEvent(false, key, false, nil)
            end
        end)        
    end
end)
print("ANTI-AFK : ON By HellZone")

local Section = Auto:Section({ 
    Title = "Main Feature",
})

local autoFishingRunning = false
local autoFishingToggle

local REEquipToolFromHotbar = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipToolFromHotbar"]
local RFChargeFishingRod = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]
local RFRequestFishingMinigameStarted = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/RequestFishingMinigameStarted"]
local REFishingCompleted = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishingCompleted"]
local REUnequipToolFromHotbar = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/UnequipToolFromHotbar"]
local RFCancelFishingInputs = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/CancelFishingInputs"]
local REFishCaught = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishCaught"]

local lastFishTime = 0
local running = false
local equipped = false
local lastResetTime = 0
local fishCheckEnabled = false
local initialSetupDone = false 

local function safeFire(remote, arg)
	if not remote then
		return false
	end
	local ok, err = pcall(function()
		if arg ~= nil then
			remote:FireServer(arg)
		else
			remote:FireServer()
		end
	end)
	if not ok then
		return false
	end
	return true
end

local function safeInvoke(remote, arg1, arg2)
	if not remote then
		return nil
	end
	local ok, res = pcall(function()
		if arg1 ~= nil and arg2 ~= nil then
			return remote:InvokeServer(arg1, arg2)
		elseif arg1 ~= nil then
			return remote:InvokeServer(arg1)
		else
			return remote:InvokeServer()
		end
	end)
	if not ok then
		return nil
	end
	return res
end

local function showNotification(title, content)
    if WindUI and WindUI.Notify then
        WindUI:Notify({
            Title = title,
            Content = content,
            Duration = 3,
        })
    elseif Auto and Auto.Notify then
        Auto:Notify({
            Title = title,
            Content = content,
            Duration = 3,
        })
    end
end

local function equipToolOnce()
    if not equipped then
        for i = 1, 3 do
            safeFire(REEquipToolFromHotbar, 1)
        end
        equipped = true
    end
end

local function resetTool()
    safeFire(REUnequipToolFromHotbar)
    equipped = false
    equipToolOnce()
end

local function doChargeAndRequest()
    safeInvoke(RFChargeFishingRod, 2)
    

    for i = 1, 1 do
        safeInvoke(RFRequestFishingMinigameStarted, -1.25, 1)
        task.wait() 
    end
end

local function doRequestOnly()
    for i = 1, 2 do
        safeInvoke(RFRequestFishingMinigameStarted, -1.25, 1)
        task.wait() 
    end
end

local function forceResetFishing()
    
    for i = 1, 2 do
        safeInvoke(RFCancelFishingInputs)
    end
    
    resetTool()
    task.wait(0.5) 
    doChargeAndRequest()  
    lastFishTime = tick() 
end

local function fishCheckLoop()
    local retryCount = 0
    local maxRetries = 10
    
    while running and fishCheckEnabled do
        local currentTime = tick()
        if currentTime - lastFishTime >= 8 and lastFishTime > 0 then
            retryCount = retryCount + 1
            forceResetFishing()
            
            if retryCount >= maxRetries then
                retryCount = 0
            end
        else
            retryCount = 0
        end
        task.wait(1)
    end
end

local function spamCompletedLoop()
    while running do
        safeFire(REFishingCompleted)
        task.wait()
    end
end

local function equipToolLoop()
    while running do
        safeFire(REEquipToolFromHotbar, 1)
        task.wait(2)
    end
end

local function periodicResetLoop()
    while running do
        task.wait(300)
        if running then
            resetTool()
            lastResetTime = tick()
        end
    end
end

local function setupFishCaughtHandler()
    REFishCaught.OnClientEvent:Connect(function(fishName, fishData)
        lastFishTime = tick()
        
        if running then
            task.wait(0.08)
            doChargeAndRequest() 
        end
    end)
end

local function fishingCycle()
    lastResetTime = tick()
    lastFishTime = tick()
    fishCheckEnabled = true
    
    setupFishCaughtHandler()
    
    task.spawn(spamCompletedLoop)
    task.spawn(equipToolLoop)
    task.spawn(fishCheckLoop)
    task.spawn(periodicResetLoop)
    
    task.wait(0.5)  
    doChargeAndRequest()  
    initialSetupDone = true
    
    
    while running do
        task.wait()
    end
    
    fishCheckEnabled = false
    initialSetupDone = false
end

autoFishingToggle = Auto:Toggle({
    Title = "Auto Fishing", 
    Type = "Toggle",
    Desc = "INSTANT FISHING - WITH ANTI STUCK SYSTEM",
    Default = false,
    Callback = function(state) 
        running = state
        autoFishingRunning = state 
        if running then
            task.spawn(fishingCycle)
        else
            safeInvoke(RFCancelFishingInputs)
            equipped = false
            fishCheckEnabled = false
            initialSetupDone = false
        end
    end
})

Auto:Space()
Auto:Divider()


local Section = Auto:Section({ 
    Title = "Teleport Feature",
})

local teleportLocations = {
    ["Fisherman Island"] = CFrame.new(77, 9, 2706),
    ["Kohana Volcano"] = CFrame.new(-628.758911, 35.710186, 104.373764, 0.482912123, 1.81591773e-08, 0.875668824, 3.01732896e-08, 1, -3.73774007e-08, -0.875668824, 4.44718076e-08, 0.482912123),
    ["Kohana"] = CFrame.new(-725.013306, 3.03549194, 800.079651, -0.999999285, -5.38041718e-08, -0.00118542486, -5.379977e-08, 1, -3.74458198e-09, 0.00118542486, -3.68080366e-09, -0.999999285),
    ["Esotric Islands"] = CFrame.new(2113, 10, 1229),
    ["Coral Reefs"] = CFrame.new(-3063.54248, 4.04500151, 2325.85278, 0.999428809, 2.02288568e-08, 0.033794228, -1.96206607e-08, 1, -1.83286453e-08, -0.033794228, 1.76551112e-08, 0.999428809),
    ["Crater Island"] = CFrame.new(984.003296, 2.87008905, 5144.92627, 0.999932885, 1.19231975e-08, 0.0115857301, -1.04685522e-08, 1, -1.25615529e-07, -0.0115857301, 1.25485812e-07, 0.999932885),
    ["Sisyphus Statue"] = CFrame.new(-3737, -136, -881),
    ["Treasure Room"] = CFrame.new(-3650.4873, -269.269318, -1652.68323, -0.147814155, -2.75628675e-08, -0.989015162, -1.74189818e-08, 1, -2.52656349e-08, 0.989015162, 1.34930183e-08, -0.147814155),
    ["Lost Isle"] = CFrame.new(-3649.0813, 5.42584181, -1052.88745, 0.986230493, 3.9997154e-08, -0.165376455, -3.81513914e-08, 1, 1.43375187e-08, 0.165376455, -7.83075649e-09, 0.986230493),
    ["Tropical Grove"] = CFrame.new(-2151.29248, 15.8166971, 3628.10669, -0.997403979, 4.56146232e-09, -0.0720091537, 4.62302685e-09, 1, -6.88285429e-10, 0.0720091537, -1.0193989e-09, -0.997403979),
    ["Weater Machine"] = CFrame.new(-1518.05042, 2.87499976, 1909.78125, -0.995625556, -1.82757487e-09, -0.0934334621, 2.24076646e-09, 1, -4.34377512e-08, 0.0934334621, -4.34570957e-08, -0.995625556),
    ["Enchant Room"] = CFrame.new(3180.14502, -1302.85486, 1387.9563, 0.338028163, 9.92235272e-08, -0.941136003, 1.90291747e-08, 1, 1.12264253e-07, 0.941136003, -5.58575195e-08, 0.338028163),  
    ["Seconds Enchant"] = CFrame.new(1487, 128, -590),
    ["Ancient Jungle"] = CFrame.new(1519.33215, 2.08891273, -307.090668, 0.632470906, -1.48247699e-08, 0.774584115, -2.24899335e-08, 1, 3.75027014e-08, -0.774584115, -4.11397139e-08, 0.632470906),
    ["Sacred Temple"] = CFrame.new(1413.84277, 4.375, -587.298279, 0.261966974, 5.50031594e-08, -0.965076864, -8.19077872e-09, 1, 5.47701973e-08, 0.965076864, -6.44325127e-09, 0.261966974),
    ["Underground Cellar"] = CFrame.new(2103.14673, -91.1976471, -717.124939, -0.226165071, -1.71397723e-08, -0.974088967, -2.1650266e-09, 1, -1.70930168e-08, 0.974088967, -1.75691484e-09, -0.226165071),
    ["Arrow Artifact"] = CFrame.new(883.135437, 6.62499952, -350.10025, -0.480593145, 2.676836e-08, 0.876943707, -4.66245069e-08, 1, -5.6076324e-08, -0.876943707, -6.78369645e-08, -0.480593145),
    ["Crescent Artifact"] = CFrame.new(1409.40747, 6.62499952, 115.430603, -0.967555583, -5.63477229e-08, 0.252658188, -7.82660337e-08, 1, -7.67005233e-08, -0.252658188, -9.39865714e-08, -0.967555583),
    ["Hourglass Diamond Artifact"] = CFrame.new(1480.98645, 6.27569771, -847.142029, -0.967326343, -5.985531e-08, 0.253534466, -6.16077926e-08, 1, 1.02735098e-09, -0.253534466, -1.46259147e-08, -0.967326343),
    ["Diamond Artifact"] = CFrame.new(1836.31604, 6.34277105, -298.546265, 0.545851529, -2.36059989e-08, -0.837881923, -4.70848498e-08, 1, -5.8847597e-08, 0.837881923, 7.15735951e-08, 0.545851529),
}

local selectedLocation = ""
local freezeLoop = nil
local lastCFrame = nil

local function startFreeze()
    if freezeLoop then return end
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        lastCFrame = player.Character.HumanoidRootPart.CFrame
    end
    
    freezeLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local targetCFrame = teleportLocations[selectedLocation]
            
            if rootPart and targetCFrame then
                local currentCFrame = rootPart.CFrame
                local distanceFromStart = (currentCFrame.Position - lastCFrame.Position).Magnitude
                
                if distanceFromStart > 0.1 then
                    rootPart.CFrame = targetCFrame
                    lastCFrame = targetCFrame
                end
            end
        end
    end)
end

local function stopFreeze()
    if freezeLoop then
        freezeLoop:Disconnect()
        freezeLoop = nil
    end
end

local LocationDropdown = Auto:Dropdown({
    Title = "Teleport Location",
    Values = {"Fisherman Island", "Kohana Volcano", "Kohana", "Esotric Islands", "Coral Reefs", "Crater Island", "Sisyphus Statue", "Treasure Room", "Lost Isle", "Tropical Grove", "Weater Machine", "Enchant Room","Seconds Enchant", "Ancient Jungle", "Sacred Temple", "Underground Cellar", "Arrow Artifact", "Crescent Artifact", "Hourglass Diamond Artifact", "Diamond Artifact"},
    Value = "",
    Callback = function(option)
        if option and option ~= "" then
            selectedLocation = option
        end
    end
})

local TeleportToggle = Auto:Toggle({
    Title = "Teleport & Freeze to Position",
    Default = false,
    Callback = function(state)
        if state then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local targetCFrame = teleportLocations[selectedLocation]
                
                if rootPart and targetCFrame then
                    rootPart.CFrame = targetCFrame
                    task.wait(0.1)
                    startFreeze()
                end
            end
        else
            stopFreeze()
        end
    end
})

Auto:Divider()

local savedCFrame = nil

local function saveCurrentPosition()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        savedCFrame = rootPart.CFrame
        
        showNotification("Position Saved")
        return true
    end
    return false
end

local SaveButton = Auto:Button({
    Title = "Save Your Position",
    Callback = saveCurrentPosition
})

local TeleportToggle = Auto:Toggle({
    Title = "Teleport & Freeze to Position",
    Default = false,
    Callback = function(state)
        teleportEnabled = state
        
        if teleportEnabled then
            if not savedCFrame then
                showNotification("❌ Teleport", "Save position first!")
                teleportEnabled = false
                TeleportToggle:Set(false)
                return
            end
            
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                rootPart.CFrame = savedCFrame
                task.wait(0.1)
                startFreeze()
            end
        else
            stopFreeze()
        end
    end
})

Auto:Space()
Auto:Divider()
local Section = Auto:Section({ 
    Title = "Auto Sell Feature",
})

local autoSellEnabled = false
local autoSellInterval = 5 

local AutoSellSlider = Auto:Slider({
    Title = "Auto Sell Timer (Minutes)",
    Step = 1,
    Value = {Min = 1, Max = 30, Default = 5},
    Callback = function(value)
        autoSellInterval = value
    end
})

local function sellAllItems()
    local RFSellAllItems = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]
    
    pcall(function()
        RFSellAllItems:InvokeServer()
    end)
end

local function startAutoSell()
    task.spawn(function()
        while autoSellEnabled do
            local secondsToWait = autoSellInterval * 60
            for i = 1, secondsToWait do
                if not autoSellEnabled then break end
                task.wait(1)
            end
            if autoSellEnabled then
                sellAllItems()
            end
        end
    end)
end

local AutoSellToggle = Auto:Toggle({
    Title = "Enable Auto Sell",
    Default = false,
    Callback = function(state)
        autoSellEnabled = state
        if autoSellEnabled then
            startAutoSell()
        else
        end
    end
})

local ManualSellButton = Auto:Button({
    Title = "Sell All Items Now",
    Callback = sellAllItems
})

local Section = Auto:Section({ 
    Title = "Auto Favorite Feature",
})

local REFavoriteItem = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FavoriteItem"]
local REObtainedNewFishNotification = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ObtainedNewFishNotification"]

-- MANUAL FISH IDs (PASTI WORK!)
local fishTiers = {
    Common = {43, 20, 66, 45, 64, 31, 46, 116, 32, 63, 33, 65, 62, 51, 61, 92, 91, 90, 108, 109, 111, 112, 113, 114, 115, 135, 154, 151, 166, 165, 198, 234, 281, 279, 290},
    Uncommon = {44, 59, 19, 67, 41, 68, 60, 50, 117, 29, 42, 30, 58, 28, 69, 190, 87, 86, 94, 106, 107, 121, 120, 139, 140, 144, 142, 163, 161, 153, 164, 189, 182, 186, 188, 197, 202, 203, 204, 211, 232, 237, 242, 280, 287, 289, 275, 285, 262, 288},
    Rare = {18, 71, 40, 72, 23, 89, 88, 93, 119, 157, 191, 183, 184, 194, 196, 210, 209, 239, 238, 235, 241, 278, 282, 277, 284},
    Epic = {17, 22, 37, 53, 57, 26, 70, 14, 49, 25, 24, 48, 36, 38, 16, 56, 55, 27, 39, 74, 73, 95, 96, 138, 143, 160, 155, 162, 149, 207, 227, 233, 266, 267, 271, 265, 276, 268, 270},
    Legendary = {15, 47, 75, 52, 21, 34, 54, 35, 97, 110, 137, 146, 147, 152, 199, 208, 224, 236, 243, 286, 283, 274, 296},
    Mythic = {98, 122, 158, 150, 185, 205, 215, 240, 247, 249, 248, 273, 264, 263},
    SECRET = {82, 99, 136, 141, 159, 156, 145, 187, 200, 195, 206, 201, 225, 218, 228, 226, 83, 176, 292, 293, 272, 269, 295}
}

local allMutations = {"Albino", "Color Burn", "Corrupt", "Fairy Dust", "Festive", "Frozen", "Galaxy", "Gemstone", "Ghost", "Gold", "Holographic", "Lightning", "Midnight", "Radioactive", "Stone"}
local connection = nil
local selectedTiers = {}
local selectedMutations = {}

-- GET MUTATION
local function getMutation(weightData, itemData)
    return (weightData and weightData.VariantId) or (itemData and itemData.InventoryItem and itemData.InventoryItem.Metadata and itemData.InventoryItem.Metadata.VariantId)
end

-- MAIN HANDLER
local function handleFish(fishId, weightData, itemData, isNew)
    local mutation = getMutation(weightData, itemData)
    
    -- Check Rarity
    for _, tier in pairs(selectedTiers) do
        if fishTiers[tier] and table.find(fishTiers[tier], fishId) then
            REFavoriteItem:FireServer(itemData and itemData.InventoryItem and itemData.InventoryItem.UUID or fishId)
            return
        end
    end
    
    -- Check Mutation
    if mutation and table.find(selectedMutations, mutation) then
        REFavoriteItem:FireServer(itemData and itemData.InventoryItem and itemData.InventoryItem.UUID or fishId)
    end
end

-- UI
Auto:Dropdown({
    Title = "Rarity",
    Values = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET"},
    Value = {},
    Multi = true,
    Callback = function(v) selectedTiers = v end
})

Auto:Dropdown({
    Title = "Mutation", 
    Values = allMutations,
    Value = {},
    Multi = true,
    Callback = function(v) selectedMutations = v end
})

Auto:Toggle({
    Title = "Enable Auto Favorite",
    Default = false,
    Callback = function(state)
        if state then
            connection = REObtainedNewFishNotification.OnClientEvent:Connect(handleFish)
        elseif connection then
            connection:Disconnect()
            connection = nil
        end
    end
})

------------ END OF AUTO LOGIC -------------------

-- ====================================================================
-- 5. LOGIC SHOP
-- ====================================================================

local Section = Shop:Section({ 
    Title = "Fishing Rod Shop",
})

local currentRod = ""

local RodDropdown = Shop:Dropdown({
    Title = "Select Fishing Rod",
    Values = {
        "Starter Rod (50$)",
        "Luck Rod (350$)", 
        "Carbon Rod (900$)",
        "Grass Rod (1500$)",
        "Desmascus Rod (3000$)",
        "Ice Rod (5000$)",
        "Lucky Rod (15000$)",
        "Midnight Rod (50000$)",
        "SteamPunk Rod (215000$)",
        "Chrome Rod (437000$)",
        "Fluorescent Rod (715000$)",
        "Astral Rod (1M$)",
        "Ares Rod (3M$)",
        "Angler Rod (8M$)",
        "Bambo Rod (12M$)"
    },
    Value = "",
    Callback = function(option)
        currentRod = option
    end
})

local PurchaseButton = Shop:Button({
    Title = "Purchase Fishing Rod",
    Callback = function()
        local RFPurchaseFishingRod = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]
        
        if currentRod == "Starter Rod (50$)" then
            RFPurchaseFishingRod:InvokeServer(1)
        elseif currentRod == "Luck Rod (350$)" then
            RFPurchaseFishingRod:InvokeServer(79)
        elseif currentRod == "Carbon Rod (900$)" then
            RFPurchaseFishingRod:InvokeServer(76)
        elseif currentRod == "Grass Rod (1500$)" then
            RFPurchaseFishingRod:InvokeServer(85)
        elseif currentRod == "Desmascus Rod (3000$)" then
            RFPurchaseFishingRod:InvokeServer(77)
        elseif currentRod == "Ice Rod (5000$)" then
            RFPurchaseFishingRod:InvokeServer(78)
        elseif currentRod == "Lucky Rod (15000$)" then
            RFPurchaseFishingRod:InvokeServer(4)
        elseif currentRod == "Midnight Rod (50000$)" then
            RFPurchaseFishingRod:InvokeServer(80)
        elseif currentRod == "SteamPunk Rod (215000$)" then
            RFPurchaseFishingRod:InvokeServer(6)
        elseif currentRod == "Chrome Rod (437000$)" then
            RFPurchaseFishingRod:InvokeServer(7)
        elseif currentRod == "Fluorescent Rod (715000$)" then
            RFPurchaseFishingRod:InvokeServer(255)
        elseif currentRod == "Astral Rod (1M$)" then
            RFPurchaseFishingRod:InvokeServer(5)
        elseif currentRod == "Ares Rod (3M$)" then
            RFPurchaseFishingRod:InvokeServer(126)
        elseif currentRod == "Angler Rod (8M$)" then
            RFPurchaseFishingRod:InvokeServer(168)
        elseif currentRod == "Bambo Rod (12M$)" then
            RFPurchaseFishingRod:InvokeServer(258)
        end
    end
})

local Section = Shop:Section({ 
    Title = "Purchase Bait",
})

local currentBait = ""

local BaitDropdown = Shop:Dropdown({
    Title = "Select Bobbers",
    Values = {
        "TopWater Bait (100$)",
        "Luck Bait (1000$)", 
        "Midnight Bait (3000$)",
        "Nature Bait (83500$)",
        "Chroma Bait (290000$)",
        "Dark Matter Bait (630000$)",
        "Corrupt Bait (1.15M$)",
        "Aether Bait (3.70M$)",
        "Floral Bait (4M$)"
    },
    Value = "",
    Callback = function(option)
        currentBait = option
    end
})

local PurchaseBaitButton = Shop:Button({
    Title = "Purchase Bobbers",
    Callback = function()
        local RFPurchaseBait = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]
        
        if currentBait == "TopWater Bait (100$)" then
            RFPurchaseBait:InvokeServer(10)
        elseif currentBait == "Luck Bait (1000$)" then
            RFPurchaseBait:InvokeServer(2)
        elseif currentBait == "Midnight Bait (3000$)" then
            RFPurchaseBait:InvokeServer(3)
        elseif currentBait == "Nature Bait (83500$)" then
            RFPurchaseBait:InvokeServer(17)
        elseif currentBait == "Chroma Bait (290000$)" then
            RFPurchaseBait:InvokeServer(6)
        elseif currentBait == "Dark Matter Bait (630000$)" then
            RFPurchaseBait:InvokeServer(8)
        elseif currentBait == "Corrupt Bait (1.15M$)" then
            RFPurchaseBait:InvokeServer(15)
        elseif currentBait == "Aether Bait (3.70M$)" then
            RFPurchaseBait:InvokeServer(16)
        elseif currentBait == "Floral Bait (4M$)" then
            RFPurchaseBait:InvokeServer(20)
        end
    end
})


local Section = Shop:Section({ 
    Title = "Purchase Weather",
})

local selectedWeathers = {"Wind (10000)"}
local autoBuyWeather = false
local weatherLoop = nil

local WeatherDropdown = Shop:Dropdown({
    Title = "Select Weather",
    Values = {
        "Wind (10000)",
        "Cloudy (20000)", 
        "Snow (15000)",
        "Storm (35000)",
        "Radiant (50000)",
        "Shark Hunt (300000)"
    },
    Value = {"Wind (10000)"},
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        selectedWeathers = option
    end
})

local function purchaseWeather(weatherName)
    local RFPurchaseWeatherEvent = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]
    
    if weatherName == "Wind (10000)" then
        RFPurchaseWeatherEvent:InvokeServer("Wind")
    elseif weatherName == "Cloudy (20000)" then
        RFPurchaseWeatherEvent:InvokeServer("Cloudy")
    elseif weatherName == "Snow (15000)" then
        RFPurchaseWeatherEvent:InvokeServer("Snow")
    elseif weatherName == "Storm (35000)" then
        RFPurchaseWeatherEvent:InvokeServer("Storm")
    elseif weatherName == "Radiant (50000)" then
        RFPurchaseWeatherEvent:InvokeServer("Radiant")
    elseif weatherName == "Shark Hunt (300000)" then
        RFPurchaseWeatherEvent:InvokeServer("Shark Hunt")
    end
end

local PurchaseWeatherButton = Shop:Button({
    Title = "Purchase Weather",
    Callback = function()
        for _, weather in pairs(selectedWeathers) do
            purchaseWeather(weather)
        end
    end
})

local AutoWeatherToggle = Shop:Toggle({
    Title = "Auto Buy Weather",
    Default = false,
    Callback = function(state)
        autoBuyWeather = state
        
        if state then
            weatherLoop = game:GetService("RunService").Heartbeat:Connect(function()
                task.wait(60) 
                
                if autoBuyWeather then
                    for _, weather in pairs(selectedWeathers) do
                        purchaseWeather(weather)
                    end
                end
            end)
        else
            if weatherLoop then
                weatherLoop:Disconnect()
                weatherLoop = nil
            end
        end
    end
})

------------ END OF SHOP LOGIC -------------------

-- ====================================================================
-- 6. LOGIC TELEPORT
-- ====================================================================

local section = Teleport:Section({ 
    Title = "Teleport To Players",
})

local function refreshPlayerList()
    local playerNames = {}
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(playerNames, p.Name)
        end
    end
    
    return playerNames
end

local selectedPlayer = ""

local PlayerDropdown = Teleport:Dropdown({
    Title = "Select Player",
    Values = refreshPlayerList(),
    Value = "",
    Callback = function(option)
        selectedPlayer = option
    end
})

local TeleportButton = Teleport:Button({
    Title = "Teleport to Player",
    Callback = function()
        if selectedPlayer and selectedPlayer ~= "" then
            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = targetCFrame
                end
            end
        end
    end
})

task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            local currentPlayers = refreshPlayerList()
            PlayerDropdown:SetValues(currentPlayers)
        end)
    end
end)

local Section = Teleport:Section({ 
    Title = "Teleport To Island Locations",
})

local teleportLocations = {
    ["Fisherman Island"] = CFrame.new(77, 9, 2706),
    ["Kohana Volcano"] = CFrame.new(-628.758911, 35.710186, 104.373764, 0.482912123, 1.81591773e-08, 0.875668824, 3.01732896e-08, 1, -3.73774007e-08, -0.875668824, 4.44718076e-08, 0.482912123),
    ["Kohana"] = CFrame.new(-725.013306, 3.03549194, 800.079651, -0.999999285, -5.38041718e-08, -0.00118542486, -5.379977e-08, 1, -3.74458198e-09, 0.00118542486, -3.68080366e-09, -0.999999285),
    ["Esotric Islands"] = CFrame.new(2113, 10, 1229),
    ["Coral Reefs"] = CFrame.new(-3063.54248, 4.04500151, 2325.85278, 0.999428809, 2.02288568e-08, 0.033794228, -1.96206607e-08, 1, -1.83286453e-08, -0.033794228, 1.76551112e-08, 0.999428809),
    ["Crater Island"] = CFrame.new(984.003296, 2.87008905, 5144.92627, 0.999932885, 1.19231975e-08, 0.0115857301, -1.04685522e-08, 1, -1.25615529e-07, -0.0115857301, 1.25485812e-07, 0.999932885),
    ["Sisyphus Statue"] = CFrame.new(-3737, -136, -881),
    ["Treasure Room"] = CFrame.new(-3650.4873, -269.269318, -1652.68323, -0.147814155, -2.75628675e-08, -0.989015162, -1.74189818e-08, 1, -2.52656349e-08, 0.989015162, 1.34930183e-08, -0.147814155),
    ["Lost Isle"] = CFrame.new(-3649.0813, 5.42584181, -1052.88745, 0.986230493, 3.9997154e-08, -0.165376455, -3.81513914e-08, 1, 1.43375187e-08, 0.165376455, -7.83075649e-09, 0.986230493),
    ["Tropical Grove"] = CFrame.new(-2151.29248, 15.8166971, 3628.10669, -0.997403979, 4.56146232e-09, -0.0720091537, 4.62302685e-09, 1, -6.88285429e-10, 0.0720091537, -1.0193989e-09, -0.997403979),
    ["Weater Machine"] = CFrame.new(-1518.05042, 2.87499976, 1909.78125, -0.995625556, -1.82757487e-09, -0.0934334621, 2.24076646e-09, 1, -4.34377512e-08, 0.0934334621, -4.34570957e-08, -0.995625556),
    ["Enchant Room"] = CFrame.new(3180.14502, -1302.85486, 1387.9563, 0.338028163, 9.92235272e-08, -0.941136003, 1.90291747e-08, 1, 1.12264253e-07, 0.941136003, -5.58575195e-08, 0.338028163),  
    ["Seconds Enchant"] = CFrame.new(1487, 128, -590),  
    ["Ancient Jungle"] = CFrame.new(1519.33215, 2.08891273, -307.090668, 0.632470906, -1.48247699e-08, 0.774584115, -2.24899335e-08, 1, 3.75027014e-08, -0.774584115, -4.11397139e-08, 0.632470906),
    ["Sacred Temple"] = CFrame.new(1413.84277, 4.375, -587.298279, 0.261966974, 5.50031594e-08, -0.965076864, -8.19077872e-09, 1, 5.47701973e-08, 0.965076864, -6.44325127e-09, 0.261966974),
    ["Underground Cellar"] = CFrame.new(2103.14673, -91.1976471, -717.124939, -0.226165071, -1.71397723e-08, -0.974088967, -2.1650266e-09, 1, -1.70930168e-08, 0.974088967, -1.75691484e-09, -0.226165071),
    ["Arrow Artifact"] = CFrame.new(883.135437, 6.62499952, -350.10025, -0.480593145, 2.676836e-08, 0.876943707, -4.66245069e-08, 1, -5.6076324e-08, -0.876943707, -6.78369645e-08, -0.480593145),
    ["Crescent Artifact"] = CFrame.new(1409.40747, 6.62499952, 115.430603, -0.967555583, -5.63477229e-08, 0.252658188, -7.82660337e-08, 1, -7.67005233e-08, -0.252658188, -9.39865714e-08, -0.967555583),
    ["Hourglass Diamond Artifact"] = CFrame.new(1480.98645, 6.27569771, -847.142029, -0.967326343, -5.985531e-08, 0.253534466, -6.16077926e-08, 1, 1.02735098e-09, -0.253534466, -1.46259147e-08, -0.967326343),
    ["Diamond Artifact"] = CFrame.new(1836.31604, 6.34277105, -298.546265, 0.545851529, -2.36059989e-08, -0.837881923, -4.70848498e-08, 1, -5.8847597e-08, 0.837881923, 7.15735951e-08, 0.545851529),
}

local selectedLocation = ""

local LocationDropdown = Teleport:Dropdown({
    Title = "Teleport To Island",
    Values = {"Fisherman Island", "Kohana Volcano", "Kohana", "Esotric Islands", "Coral Reefs", "Crater Island", "Sisyphus Statue", "Treasure Room", "Lost Isle", "Tropical Grove", "Weater Machine", "Enchant Room","Seconds Enchant", "Ancient Jungle", "Sacred Temple", "Underground Cellar", "Arrow Artifact", "Crescent Artifact", "Hourglass Diamond Artifact", "Diamond Artifact"},
    Value = "",
    Callback = function(option)
        if option and option ~= "" then
            selectedLocation = option
        end
    end
})

local TeleportButton = Teleport:Button({
    Title = "Teleport to Island",
    Callback = function()
        if selectedLocation and selectedLocation ~= "" then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local targetCFrame = teleportLocations[selectedLocation]
                
                if rootPart and targetCFrame then
                    rootPart.CFrame = targetCFrame
                end
            end
        end
    end
})

local Section = Teleport:Section({ 
    Title = "Teleport To Game Event",
})

local currentLocation = "Megalodon Hunt"

local function findLocationPart(locationName)
    local menuRings = workspace:FindFirstChild("!!! MENU RINGS")
    if not menuRings then return nil end
    
    -- Mencoba menemukan model event berdasarkan nama yang mendekati
    for _, child in pairs(menuRings:GetDescendants()) do
        if child:IsA("BasePart") and string.find(string.lower(child.Name), string.lower(locationName)) then
            return child
        end
    end
    
    -- Mencoba mencari model event utama yang memiliki PrimaryPart
    if locationName == "Megalodon Hunt" then return workspace:FindFirstChild("Megalodon Hunt") or workspace:FindFirstChild("!!! MEGA SHARK") end
    -- Tambahkan pengecekan spesifik lainnya jika diperlukan
    
    return nil
end

teleportToggle = Teleport:Toggle({
    Title = "Teleport To Game Event",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        -- Logika auto teleport di sini
    end
})


local Section = Teleport:Section({ 
    Title = "Teleport To NPC Locations",
})

local npcLocations = {
    ["Alex"] = CFrame.new(49, 17, 2880),
    ["Alien Merchant"] = CFrame.new(-134, 2, 2762),
    ["Aura Kid"] = CFrame.new(71, 17, 2830),
    ["Billy Bob"] = CFrame.new(80, 17, 2876),
    ["Boat Expert"] = CFrame.new(33, 10, 2783),
    ["Joe"] = CFrame.new(144, 20, 2862),
    ["Ron"] = CFrame.new(-52, 17, 2859),
    ["Scientist"] = CFrame.new(-7, 18, 2886),
    ["Scott"] = CFrame.new(-17, 10, 2703),
    ["Seth"] = CFrame.new(111, 17, 2877),
    ["Silly Fisherman"] = CFrame.new(102, 10, 2690)
}

local selectedNPC = ""

local NPCDropdown = Teleport:Dropdown({
    Title = "Teleport to NPC",
    Values = {"Alex", "Alien Merchant", "Aura Kid", "Billy Bob", "Boat Expert", "Joe", "Ron", "Scientist", "Scott", "Seth", "Silly Fisherman"},
    Value = "",
    Callback = function(option)
        if option and option ~= "" then
            selectedNPC = option
        end
    end
})

local TeleportNPCButton = Teleport:Button({
    Title = "Teleport to NPC",
    Callback = function()
        if selectedNPC and selectedNPC ~= "" then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local targetCFrame = npcLocations[selectedNPC]
                
                if rootPart and targetCFrame then
                    rootPart.CFrame = targetCFrame
                end
            end
        end
    end
})

--------------- END OF TELEPORT LOGIC -------------------

-- ====================================================================
-- 7. LOGIC QUEST
-- ====================================================================

local Button = Quest:Button({
    Title = "Check Quest DeepSea",
    Callback = function()
        local questData = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data")
        local deepSeaData = questData:Get({"DeepSea", "Available", "Forever"})
        
        if not deepSeaData then return end
        
        local progressText = ""
        local quests = require(ReplicatedStorage.Shared.Quests.QuestList).DeepSea.Forever
        
        for i, questInfo in ipairs(quests) do
            local questProgress = deepSeaData.Quests[i]
            local target = questInfo.Arguments.value
            local current = questProgress and questProgress.Progress or 0
            local percent = math.floor((current / target) * 100)
            
            progressText = progressText .. i .. ". " .. questInfo.DisplayName .. " : " .. current .. "/" .. target .. " (" .. percent .. "%)\n"
        end
        
        WindUI:Notify({
            Title = "Deep Sea Quest",
            Content = progressText,
            Duration = 10,
        })
    end
})

local runningDeepSea = false

local function getDeepSeaProgress()
    local Replion = require(ReplicatedStorage.Packages.Replion)
    local QuestList = require(ReplicatedStorage.Shared.Quests.QuestList)
    local questData = Replion.Client:WaitReplion("Data")
    
    local deepSeaData = questData:Get({"DeepSea", "Available", "Forever"})
    
    if not deepSeaData or not deepSeaData.Quests then
        return nil
    end
    
    local progress = {}
    local deepSeaQuests = QuestList.DeepSea.Forever
    
    for i, questInfo in ipairs(deepSeaQuests) do
        local questProgress = deepSeaData.Quests[i]
        local target = questInfo.Arguments.value
        local current = questProgress and questProgress.Progress or 0
        local completed = current >= target
        
        progress[i] = {
            name = questInfo.DisplayName,
            current = current,
            target = target,
            completed = completed,
            redeemed = questProgress and questProgress.Redeemed or false
        }
    end
    
    return progress
end

local function startDeepSeaQuest()
    local quest234Location = CFrame.new(-3737, -136, -881)
    local quest1Location = CFrame.new(-3650.4873, -269.269318, -1652.68323, -0.147814155, -2.75628675e-08, -0.989015162, -1.74189818e-08, 1, -2.52656349e-08, 0.989015162, 1.34930183e-08, -0.147814155)
    
    local currentTargetLocation = nil
    
    while runningDeepSea do
        local success, progress = pcall(getDeepSeaProgress)
        
        if not success or not progress then
            task.wait(60)
            continue
        end
        
        local allCompleted = true
        for i = 1, 4 do
            if progress[i] and not progress[i].completed then
                allCompleted = false
                break
            end
        end
        
        if allCompleted then
            runningDeepSea = false
            DeepSeaToggle:Set(false)
            break
        end
        
        local quest234Completed = true
        for i = 2, 4 do
            if progress[i] and not progress[i].completed then
                quest234Completed = false
                break
            end
        end
        
        if not quest234Completed then
            currentTargetLocation = quest234Location
        else
            currentTargetLocation = quest1Location
        end
        
        if currentTargetLocation and isPlayerFarFromTarget(currentTargetLocation, 10) then
            teleportToLocation(currentTargetLocation)
        end
        
        task.wait(1)
    end
end

local function stopDeepSeaQuest()
    runningDeepSea = false
end

local DeepSeaToggle = Quest:Toggle({
    Title = "Auto Complete Deep Sea",
    Default = false,
    Callback = function(state)
        runningDeepSea = state
        if state then
            if not autoFishingRunning then
                autoFishingToggle:Set(true)
            end
            task.spawn(function()
                startDeepSeaQuest()
            end)
        else
            stopDeepSeaQuest()
        end
    end
})

Divider = Quest:Divider()
Space = Quest:Space()

local Button = Quest:Button({
    Title = "Check Element Jungle",
    Callback = function()
        local questData = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data")
        local jungleData = questData:Get({"ElementJungle", "Available", "Forever"})
        
        if not jungleData then return end
        
        local progressText = ""
        local quests = require(ReplicatedStorage.Shared.Quests.QuestList).ElementJungle.Forever
        
        for i, questInfo in ipairs(quests) do
            local questProgress = jungleData.Quests[i]
            local target = questInfo.Arguments.value
            local current = questProgress and questProgress.Progress or 0
            local percent = math.floor((current / target) * 100)
            
            progressText = progressText .. i .. ". " .. questInfo.DisplayName .. " : " .. current .. "/" .. target .. " (" .. percent .. "%)\n"
        end
        
        WindUI:Notify({
            Title = "Element Jungle",
            Content = progressText,
            Duration = 10,
        })
    end
})

local runningElementJungle = false

local function getElementJungleProgress()
    local Replion = require(ReplicatedStorage.Packages.Replion)
    local QuestList = require(ReplicatedStorage.Shared.Quests.QuestList)
    local questData = Replion.Client:WaitReplion("Data")
    
    local elementJungleData = questData:Get({"ElementJungle", "Available", "Forever"})
    
    if not elementJungleData or not elementJungleData.Quests then
        return nil
    end
    
    local progress = {}
    local elementJungleQuests = QuestList.ElementJungle.Forever
    
    for i, questInfo in ipairs(elementJungleQuests) do
        local questProgress = elementJungleData.Quests[i]
        local target = questInfo.Arguments.value
        local current = questProgress and questProgress.Progress or 0
        local completed = current >= target
        
        progress[i] = {
            name = questInfo.DisplayName,
            current = current,
            target = target,
            completed = completed
        }
    end
    
    return progress
end

local function startElementJungleQuest()
    local quest2Location = CFrame.new(1519.33215, 2.08891273, -307.090668, 0.632470906, -1.48247699e-08, 0.774584115, -2.24899335e-08, 1, 3.75027014e-08, -0.774584115, -4.11397139e-08, 0.632470906)
    local quest3Location = CFrame.new(1413.84277, 4.375, -587.298279, 0.261966974, 5.50031594e-08, -0.965076864, -8.19077872e-09, 1, 5.47701973e-08, 0.965076864, -6.44325127e-09, 0.261966974)
    
    while runningElementJungle do
        local success, progress = pcall(getElementJungleProgress)
        
        if not success or not progress then
            task.wait(5)
            continue
        end
        
        if progress[1] and not progress[1].completed then
            WindUI:Notify({
                Title = "Element Jungle Quest",
                Content = "Selesaikan Quest Deep Sea dulu!",
                Duration = 5,
            })
            runningElementJungle = false
            ElementJungleToggle:Set(false)
            break
        end
        
        if progress[1] and progress[1].completed and 
           progress[2] and progress[2].completed and 
           progress[3] and progress[3].completed then
            runningElementJungle = false
            ElementJungleToggle:Set(false)
            break
        end
        
        if progress[2] and not progress[2].completed then
            teleportToLocation(quest2Location)
        end
        
        if progress[3] and not progress[3].completed then
            teleportToLocation(quest3Location)
        end
        
        task.wait(5)
    end
end

local ElementJungleToggle = Quest:Toggle({
    Title = "Auto Element Jungle Quest",
    Default = false,
    Callback = function(state)
        runningElementJungle = state
        if state then
            -- Auto nyalain Auto Fishing
            if not autoFishingRunning then
                autoFishingToggle:Set(true)
            end
            task.spawn(function()
                startElementJungleQuest()
            end)
        end
    end
})

--------------- END OF QUEST LOGIC -------------------


-- ====================================================================
-- 8. LOGIC WEBHOOK & ENCHANTS (Dipanggil di bawah)
-- ====================================================================

local _G = _G or {}
_G.WebhookURL = _G.WebhookURL or "YOUR_WEBHOOK_URL_HERE"
_G.DetectNewFishActive = _G.DetectNewFishActive or false
_G.WebhookRarities = _G.WebhookRarities or {}

local function SaveConfig()
    -- Sinkronisasi ke _G
    _G.WebhookURL = Settings.WebhookURL
    _G.DetectNewFishActive = Settings.DetectNewFishActive
    _G.WebhookRarities = Settings.WebhookRarities
end

-- LOGIC WEBHOOK
local function WebhookLogic()
    local fishDB = {}
    local knownFishUUIDs = {}
    local rarityList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET"}
    local rarityToEmoji = { Common="⚪", Uncommon="🟢", Rare="🔵", Epic="🟣", Legendary="🟡", Mythic="🔴", SECRET="💠" }
    local tierToRarity = { [1]="Common", [2]="Uncommon", [3]="Rare", [4]="Epic", [5]="Legendary", [6]="Mythic", [7]="SECRET" }
    local ItemUtility, DataService
    
    pcall(function() 
        ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
        local Replion = require(ReplicatedStorage.Packages.Replion)
        DataService = Replion.Client:WaitReplion("Data")
    end)
    
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    
    local function getInventoryFish()
        if not (DataService and ItemUtility) then return {} end
        local inventoryItems = DataService:GetExpect({"Inventory","Items"})
        local fishes = {}
        for _, v in pairs(inventoryItems) do
            local itemData = ItemUtility.GetItemDataFromItemType("Items", v.Id)
            if itemData and itemData.Data.Type == "Fishes" then
                table.insert(fishes, {Id=v.Id, UUID=v.UUID, Metadata=v.Metadata})
            end
        end
        return fishes
    end
    
    local function getPlayerCoins()
        if not DataService then return "N/A" end
        local success, coins = pcall(function() return DataService:Get("Coins") end)
        if success and coins then
            return string.format("%d", coins):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
        end
        return "N/A"
    end
    
    -- Fungsi ini rentan, menggunakan pcall dan fallback
    local function getThumbnailURL(assetString)
        if not assetString then return nil end
        local assetId = assetString:match("rbxassetid://(%d+)")
        if not assetId then return nil end
        local api = string.format("https://thumbnails.roblox.com/v1/assets?assetIds=%s&type=Asset&size=420x420&format=Png", assetId)
        
        local success, response = pcall(function()
            local result, headers, status = req({ Url = api, Method = "GET" })
            if status == 200 and result then
                return HttpService:JSONDecode(result)
            end
            return nil
        end)
        
        return success and response and response.data and response.data[1] and response.data.data[1].imageUrl
    end

    local function sendNewFishWebhook(newlyCaughtFish)
        local Settings = { WebhookURL = _G.WebhookURL, WebhookRarities = _G.WebhookRarities }
        if not req or not Settings.WebhookURL or not Settings.WebhookURL:match("discord.com/api/webhooks") then return end

        local fishData = fishDB[newlyCaughtFish.Id]
        if not fishData then return end

        local rarity = tierToRarity[fishData.Tier] or "Unknown"
        if #Settings.WebhookRarities > 0 and not table.find(Settings.WebhookRarities, rarity) then return end

        local weight = (newlyCaughtFish.Metadata and newlyCaughtFish.Metadata.Weight) and string.format("%.2f kg", newlyCaughtFish.Metadata.Weight) or "N/A"
        local mutation = (newlyCaughtFish.Metadata and newlyCaughtFish.Metadata.VariantId) and tostring(newlyCaughtFish.Metadata.VariantId) or "None"
        local price = (fishData.SellPrice) and string.format("%d", fishData.SellPrice):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","").." Coins" or "N/A"
        local coins = getPlayerCoins()
        local backpack = string.format("%d/5000", #getInventoryFish())

        local content = table.find(Settings.WebhookRarities, rarity) and "@everyone" or ""
        
        local iconUrl
        local success, url = pcall(function() return getThumbnailURL(fishData.Icon) end)
        if success and url then iconUrl = url end

        local payload = {
            username = "DYHUB | Fish It",
            avatar_url = "https://cdn.discordapp.com/attachments/1388623461777150023/1406681697977892884/image.png?ex=68f862ab&is=68f7112b&hm=bd1b48d1729fd73e1dcb520d88575a1a8e706ad834100d4606a6d71423364775&",
            content = content,
            embeds = {{
                title = rarity == "SECRET" and "🚨 ULTRA RARE FISH CAUGHT! 🚨" or "🎣 New Fish Caught!",
                color = ({Common=0x7289DA, Uncommon=0x57F287, Rare=0x3498DB, Epic=0x9B59B6, Legendary=0xF1C40F, Mythic=0xE91E63, SECRET=0xFF00FF})[rarity] or 0x3498DB,
                fields = {
                    {name="User", value=tostring(LocalPlayer.Name), inline=true},
                    {name="Fish Name", value="**"..fishData.Name.."**", inline=false},
                    {name="Rarity", value=rarityToEmoji[rarity].." "..rarity, inline=true},
                    {name="Weight", value=weight, inline=true},
                    {name="Mutation", value=mutation, inline=true},
                    {name="Sell Price", value=price, inline=true},
                    {name="Backpack", value=backpack, inline=true}
                },
                thumbnail = iconUrl and { url = iconUrl } or nil,
                image = iconUrl and { url = iconUrl } or nil,
                footer = { text = "Current Coins: "..coins.." | "..os.date("%d %B %Y, %H:%M:%S") }
            }}
        }

        pcall(function()
            req({
                Url = Settings.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"]="application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end
    
    -- Inisialisasi Database
    task.spawn(function()
        task.wait(3)
        pcall(buildFishDatabase)
        for _, fish in ipairs(getInventoryFish()) do
            if fish.UUID then knownFishUUIDs[fish.UUID] = true end
        end
    end)
    
    -- Monitoring Loop
    task.spawn(function()
        while true do
            task.wait(Settings.ScanInterval)
            if _G.DetectNewFishActive then
                local currentFish = getInventoryFish()
                for _, fish in ipairs(currentFish) do
                    if fish.UUID and not knownFishUUIDs[fish.UUID] then
                        knownFishUUIDs[fish.UUID] = true
                        sendNewFishWebhook(fish)
                    end
                end
            end
        end
    end)
end

local function EnchantLogic()
    local enchantMapping = {
        ["Big Hunter I"] = 3, ["Cursed I"] = 12, ["Empowered I"] = 9,  ["Glistening I"] = 1,
        ["Gold Digger I"] = 4, ["Leprechaun I"] = 5, ["Leprechaun II"] = 6, ["Mutation Hunter I"] = 7,
        ["Mutation Hunter II"] = 14, ["Perfection"] = 15, ["Prismatic I"] = 13, ["Reeler I"] = 2,
        ["Stargazer I"] = 8, ["Stormhunter I"] = 11, ["XPerienced I"] = 10
    }

    local autoRerollEnabled = false
    local targetEnchantId = 10
    local rollCount = 0
    local waitingForUpdate = false
    local currentCycleRunning = false
    
    local function getRemotes()
        local r = {}
        r.REEquipItem = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipItem"]
        r.REEquipToolFromHotbar = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipToolFromHotbar"]
        r.REActivateEnchantingAltar = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ActivateEnchantingAltar"]
        r.RERollEnchant = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/RollEnchant"]
        r.UpdateRemote = ReplicatedStorage.Packages._Index["ytrev_replion@2.0.0-rc.3"].replion.Remotes.Update
        local success = true
        for _, remote in pairs(r) do if not remote then success = false break end end
        return success and r or nil
    end

    local remotes = getRemotes()
    local Client, dataStore
    pcall(function() 
        Client = require(ReplicatedStorage.Packages.Replion).Client
        dataStore = Client:WaitReplion("Data")
    end)

    local function scanEnchantStones()
        if not dataStore then return {} end
        local inventoryData = dataStore:Get("Inventory")
        local enchantStones = {}
        if inventoryData then
            for category, items in pairs(inventoryData) do
                if type(items) == "table" and #items > 0 then
                    for _, item in ipairs(items) do
                        if item.Id == 10 then table.insert(enchantStones, { uuid = item.UUID, category = category }) end
                    end
                end
            end
        end
        return enchantStones
    end

    local function teleportToEnchant()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(3245, -1301, 1394)
            return true
        end
        return false
    end

    local function equipEnchantStoneSimple()
        if not remotes then return false end
        local allEnchantStones = scanEnchantStones()
        if #allEnchantStones > 0 then
            local selectedStone = allEnchantStones[math.random(1, #allEnchantStones)]
            for i = 1, 3 do remotes.REEquipItem:FireServer(selectedStone.uuid, "EnchantStones"); task.wait(1) end
            return true
        end
        return false
    end

    local function startNewEnchantCycle()
        if not remotes or not autoRerollEnabled or currentCycleRunning then return end
        currentCycleRunning = true
        
        if not teleportToEnchant() then currentCycleRunning = false; return end
        task.wait(2)

        if not equipEnchantStoneSimple() then currentCycleRunning = false; return end
        task.wait(2)
        
        -- Equip Tool & Activate Altar
        for i = 1, 3 do remotes.REEquipToolFromHotbar:FireServer(6); task.wait(1) end
        for i = 1, 3 do remotes.REActivateEnchantingAltar:FireServer(); task.wait(0.5) end
        
        waitingForUpdate = true
        remotes.RERollEnchant:FireServer()
        
        -- Logic Timeout Checker
        local startTime = tick()
        while waitingForUpdate and tick() - startTime < 3.5 do task.wait(0.1) end
        
        if waitingForUpdate and autoRerollEnabled then
            -- Timeout terjadi, coba mulai ulang
            waitingForUpdate = false
            currentCycleRunning = false
            task.wait(1)
            startNewEnchantCycle()
        end
    end

    if remotes then
        remotes.UpdateRemote.OnClientEvent:Connect(function(dataString, path, data)
            if not autoRerollEnabled or not waitingForUpdate then return end
            waitingForUpdate = false; currentCycleRunning = false;
            if path and type(path) == "table" and #path >= 4 and path[1] == "Inventory" and path[2] == "Fishing Rods" and path[4] == "Metadata" then
                if data and data.EnchantId then
                    local enchantId = data.EnchantId
                    rollCount = rollCount + 1
                    
                    if enchantId == targetEnchantId then
                        autoRerollEnabled = false
                        WindUI:Notify({ Title="Enchant Selesai!", Content="Berhasil mendapatkan target Enchant! Roll: "..rollCount, Duration=5, Icon="star" })
                    else
                        task.wait(8)
                        if autoRerollEnabled then startNewEnchantCycle() end
                    end
                end
            end
        end
    end)
    
    -- UI ENCHANTS
    Enchant:Section({ Title = "Auto Enchant Reroll", Opened = true })
    
    Enchant:Dropdown({
        Title = "Target Enchant",
        Values = {"Big Hunter I", "Cursed I", "Empowered I", "Glistening I", "Gold Digger I", "Leprechaun I", "Leprechaun II", "Mutation Hunter I", "Mutation Hunter II", "Perfection", "Prismatic I", "Reeler I", "Stargazer I", "Stormhunter I", "XPerienced I"},
        Value = "XPerienced I",
        Callback = function(selected) targetEnchantId = enchantMapping[selected] or 10 end
    })

    Enchant:Toggle({
        Title = "Auto Enchant",
        Value = false,
        Callback = function(state)
            autoRerollEnabled = state
            if state then rollCount = 0; startNewEnchantCycle() end
        end
    })
end

local function SettingsLogic()
    -- UI Settings (Dipindahkan ke sini agar tidak konflik)
    Setting:Section({ Title = "Game Optimization", Opened = true })

    Setting:Button({
        Title = "Apply Anti Lag",
        Desc = "Optimize the game to reduce lag",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/C7W8GSu4"))()
        end
    })
    
    local localPlayer = Players.LocalPlayer
    local playerName = localPlayer.Name  
    local originalAnimator = nil
    local animatorRemoved = false
    
    Setting:Toggle({
        Title = "Remove Animation Catch Fishing",
        Default = false,
        Callback = function(state)
            local character = workspace.Characters:FindFirstChild(playerName)
            
            if state then
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        local animator = humanoid:FindFirstChildOfClass("Animator")
                        if animator then
                            originalAnimator = animator:Clone()  
                            animator:Destroy()
                            animatorRemoved = true
                        else
                        end
                    else
                    end
                else
                end
            else
                if character and animatorRemoved then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid and originalAnimator then
                        local currentAnimator = humanoid:FindFirstChildOfClass("Animator")
                        if not currentAnimator then
                            local newAnimator = originalAnimator:Clone()
                            newAnimator.Parent = humanoid
                        end
                        animatorRemoved = false
                    end
                end
            end
        end
    })
    
    Setting:Toggle({
        Title = "Remove Notification", 
        Value = false, 
        Callback = function(state)
            local playerGui = localPlayer:WaitForChild("PlayerGui")
            local smallNotification = playerGui:FindFirstChild("Small Notification")
            
            if state then
                if smallNotification then
                    originalSmallNotification = smallNotification:Clone()
                    smallNotification:Destroy()
                end
            else
                if originalSmallNotification and not playerGui:FindFirstChild("Small Notification") then
                    local smallNotification = originalSmallNotification:Clone()
                    smallNotification.Parent = playerGui
                    originalSmallNotification = nil
                end
            end
        end
    })
end

-- ====================================================================
-- 9. EKSEKUSI LOGIC
-- ====================================================================

-- Memindahkan UI Webhook ke tab Discord dan menggunakan Settings
Discord:Section({ Title = "Discord Webhook Settings", Opened = true })

Discord:Input({
    Title="Webhook URL",
    Placeholder="Paste Discord Webhook URL",
    Value=_G.WebhookURL,
    Callback=function(val) 
        _G.WebhookURL = val
        -- Tidak perlu SaveConfig di sini jika Anda tidak punya sistem saving ke file.
    end
})

Discord:Toggle({
    Title="Enable Webhook",
    Value=_G.DetectNewFishActive,
    Callback=function(state) 
        _G.DetectNewFishActive = state
    end
})

Discord:Dropdown({
    Title="Rarity Filter",
    Values={"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET"},
    Multi=true,
    AllowNone=true,
    Value=_G.WebhookRarities,
    Callback=function(selected) 
        _G.WebhookRarities = selected
    end
})

Discord:Button({
    Title="Test Webhook",
    Callback=function()
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        local payload = {embeds={{title="✅ Test Webhook Connected", description="Webhook connection successful!", color=0x00FF00}}}
        pcall(function()
            req({
                Url=_G.WebhookURL,
                Method="POST",
                Headers={["Content-Type"]="application/json"},
                Body=HttpService:JSONEncode(payload)
            })
        end)
    end
})


pcall(WebhookLogic)
pcall(EnchantLogic)
pcall(SettingsLogic)

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
