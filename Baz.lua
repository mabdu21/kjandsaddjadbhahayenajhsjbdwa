-- =========================
local version = "3.8.7"
-- =========================

repeat task.wait() until game:IsLoaded()

-- ====================== FPS UNLOCK ======================
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

-- ====================== LOAD UI ======================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ====================== SERVICES ======================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- ====================== UTILITY FUNCTIONS ======================
local function SafeCall(fn, ...)
    local args = {...}
    local ok, result = pcall(fn, unpack(args))
    if not ok then warn("[DYHUB] Error: " .. tostring(result)) end
    return ok, result
end

local function SafeFire(remote, ...)
    if not remote then return false end
    local args = {...}  -- ✅ จับ ... ลงใน variable ก่อน
    return SafeCall(function()
        if typeof(remote) == "Instance" and remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))  -- ✅ unpack args ให้ RemoteEvent
        elseif typeof(remote) == "Instance" and remote:IsA("RemoteFunction") then
            return remote:InvokeServer(unpack(args))  -- ✅ unpack args ให้ RemoteFunction
        end
    end)
end

local function FindRemote(name, timeout)
    timeout = timeout or 5
    local ok, result = pcall(function()
        return ReplicatedStorage:WaitForChild("Remote", timeout):WaitForChild(name, timeout)
    end)
    if ok then return result end
    return nil
end

-- ====================== SETTINGS ======================
local Settings = {
    AutoHatch = false,
    AutoPlace = false,
    AutoPickup = false,
    AutoEquip = false,
    AutoPotion = false,
    AutoCollectCoin = false,
    AutoCollectDino = false,
    AutoBuyConveyor = false,
    AutoBuyEgg = false,
    AutoBait = false,
    AutoFood = false,
    AutoFish = false,
    AutoSpin1 = false,
    AutoSpin2 = false,
    AutoSpin3 = false,
    AutoQuest = false,
    AntiAFK = false,
}

local ActionDelays = {
    Hatch = 0.1,
    Place = 0.15,
    Pickup = 0.5,
    BuyEgg = 0.2,
    BuyConveyor = 2,
    SwitchConveyor = 1.5,
    Potion = 1,
    Bait = 0.5,
    Food = 0.5,
    Coin = 10,
    DinoClaim = 2.5,
    DinoCollect = 5,
    Fish = 0.5,
    Spin = 1,
    Quest = 2,
}

local Dropdowns = {
    SelectedCode = nil,
    SelectedBait = "FishingBait1",
    SelectedFood = "Strawberry",
    SelectedQuest = "Task_1",
    BuyIndex = 1,
    EquipIndex = 1,
    SelectedPotions = {},
    SelectedEggs = {},
}

-- ====================== LISTS ======================
local FoodList = {
    "Strawberry","Blueberry","Watermelon","Apple",
    "Orange","Corn","Banana","Grape","Pear","PineApple",
    "Dargon Fruit","Gold Mango","Bloodstone Cycad","Colossal Pinecone",
    "Volt Ginkgo","Deepsea Pearl Fruit","Durian","Pumpkin","Franken Kiwi",
    "Acorn","Cranberry","Gingerbread","Candy Cane","Cherry","Yogurt Ice Cream",
    "Mint Jelly","Macaron Jely"
}

local PotionList = {"Potion_Coin","Potion_Luck","Potion_Hatch","Potion_3in1"}
local PotionDisplayList = {"All", "Potion_Coin","Potion_Luck","Potion_Hatch","Potion_3in1"}
local BaitList = {"FishingBait1","FishingBait2","FishingBait3"}
local BaitDisplayList = {"All", "FishingBait1","FishingBait2","FishingBait3"}
local ConveyorList = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14"}
local CodeList = {
    "RABBITHAT30","MERRYTIMES2026","4XW5RG4CHRY","N7A68Q82H83",
    "3XKK8Z2WB6G","DS5523YSQ3C","SANTASWORKS","ZooFish829",
    "U2CA518SC5","FIXERROR819","A38JBJ3TSSE","TUESDAYFUN1",
    "ROMANCEBLOOMS","50KCCU0912","MagicFruit"
}

local EggTypes = {
    "BasicEgg","RareEgg","SuperRareEgg","EpicEgg","LegendEgg","HyperEgg",
    "BowserEgg","VoidEgg","CornEgg","BoneDragonEgg","DemonEgg","PrismaticEgg",
    "DarkGoatyEgg","LionfishEgg","OctopusEgg","UltraEgg","UnicornEgg","UnicornProEgg",
    "AnglerfishEgg","RhinoRockEgg","SaberCubEgg","SeaweedEgg","SharkEgg","SnowbunnyEgg",
    "GeneralKongEgg","SailfishEgg","SeaDragonEgg","PegasusEgg","ClownfishEgg","AncientEgg",
    "DinoEgg","FlyEgg","OceanEgg","MetroGiraffeEgg","GodzillaEgg","CapyEgg","HalloweenEgg",
    "WarmLittleRabbitEgg","WendigoEgg","WhiteTigerEgg","WoollyRhinocerosEgg","YILANDDragonEgg",
    "ToyDragonEgg","SwanEgg","StoneLionEgg","SiriusEgg","SpaceMouseEgg","SteampunkTurtleEgg",
    "ShadowKingEgg","SeaPlugEgg","Seahorse","RedPandaEgg","RcckChickenEgg",
    "OceanSunfishEgg","PinkUnicorn","PirateCrabEgg","PurpleButterflyEgg","OakenEgg","NinjaDogEgg",
    "NarwhalEgg","NanoRamEgg","LobsterEgg","MagicRabbitEgg","LittieMonsterEgg","KnightHorse",
    "GreenStormEgg","GlassesRabbitEgg","FlyingsquirrelEgg","GingerCatEgg","FlowerWhaleEgg","FlowerBatEgg",
    "FennecFoxEgg","EggshellDinosaurEgg","DrakespineEgg","DivineDeerEgg","CyberDragonEgg","BullDemonEgg","ArowanaEgg","PetalwingEgg"
}

local eggBuyMap = {}
for _, egg in ipairs(EggTypes) do eggBuyMap[egg] = false end

local QuestList = {"All"}
for i = 1, 20 do table.insert(QuestList, "Task_"..i) end

-- ====================== CHARACTER CACHE ======================
local Character = player.Character or player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local function refreshCharacter(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
end

player.CharacterAdded:Connect(function(char)
    refreshCharacter(char)
    task.wait(0.5)
    -- Re-apply speed/jump
    if _G.DYHUB_WalkSpeed then pcall(function() Humanoid.WalkSpeed = _G.DYHUB_WalkSpeed end) end
    if _G.DYHUB_JumpPower then pcall(function() Humanoid.JumpPower = _G.DYHUB_JumpPower end) end
end)

-- ====================== WINDOW ======================
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Build a Zoo | Premium Version",
    Folder = "DYHUB_BAZ",
    Size = UDim2.fromOffset(550,380),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = { Enabled = true, Anonymous = false },
})
Window:SetToggleKey(Enum.KeyCode.K)
pcall(function() Window:Tag({Title=version, Color=Color3.fromHex("#30ff6a")}) end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0,6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30,30,30), Color3.fromRGB(255,255,255)),
    Draggable = true
})

-- ====================== TABS ======================
local InfoTab = Window:Tab({Title="Information", Icon="info"})
local MainDivider = Window:Divider()
local Main = Window:Tab({Title="Main", Icon="rocket"})
local Egg = Window:Tab({Title="Egg", Icon="egg"})
local Auto = Window:Tab({Title="Shop", Icon="shopping-cart"})
local Player = Window:Tab({Title="Player", Icon="user"})
local Event = Window:Tab({Title="Event", Icon="party-popper"})
local Buff = Window:Tab({Title="Misc", Icon="file-cog"})
Window:SelectTab(1)

-- ====================== CONFIG MANAGER ======================
local ConfigManager = Window.ConfigManager
ConfigManager:Init(Window)
local myConfig = ConfigManager:CreateConfig("dyhub_settings")

-- ====================== ANTI AFK THREAD ======================
local antiAFKConnection = nil

local function StartAntiAFK()
    if antiAFKConnection then return end
    antiAFKConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AntiAFK then
            if antiAFKConnection then antiAFKConnection:Disconnect() end
            antiAFKConnection = nil
            return
        end
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end

local function StopAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
end

-- ====================== OPTIMIZED PROXIMITY PROMPT SYSTEM ======================
-- ✅ FIXED: Cache prompts to avoid scanning every frame
local PromptCache = {}
local PromptCacheDirty = true
local PromptCacheTTL = 2
local LastPromptCacheRebuild = 0

local function RebuildPromptCache()
    PromptCache = {}
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                local part = obj.Parent
                if part and part:IsA("BasePart") then
                    PromptCache[obj] = part
                end
            end
        end
    end)
    PromptCacheDirty = false
    LastPromptCacheRebuild = tick()
end

local function GetValidPrompts()
    if PromptCacheDirty or (tick() - LastPromptCacheRebuild) > PromptCacheTTL then
        RebuildPromptCache()
    end
    return PromptCache
end

Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        PromptCacheDirty = true
    end
end)
Workspace.DescendantRemoving:Connect(function(obj)
    if obj:IsA("ProximityPrompt") and PromptCache[obj] then
        PromptCache[obj] = nil
    end
end)

-- ✅ OPTIMIZED: Pre-build prompt groups by ActionText for faster lookup
local ActionPromptCache = {}
local function RebuildActionPromptCache()
    ActionPromptCache = {}
    for prompt, part in pairs(GetValidPrompts()) do
        local key = prompt.ActionText or ""
        if not ActionPromptCache[key] then
            ActionPromptCache[key] = {}
        end
        table.insert(ActionPromptCache[key], {prompt = prompt, part = part})
    end
end

-- ====================== PLAYER TAB ======================
Player:Section({Title="Character", Icon="user"})

_G.DYHUB_WalkSpeed = 16
_G.DYHUB_JumpPower = 50

local SpeedSlider = Player:Slider({
    Title = "Walk Speed",
    Desc = "Increase or decrease your character's walking speed.",
    Value = { Min=16, Max=500, Default=16 },
    Step = 1,
    Callback = function(v)
        _G.DYHUB_WalkSpeed = v
        pcall(function() Humanoid.WalkSpeed = v end)
    end
})

local JumpSlider = Player:Slider({
    Title = "Jump Power",
    Desc = "Increase or decrease your character's jumping ability.",
    Value = { Min=7, Max=500, Default=7 },
    Step = 1,
    Callback = function(v)
        _G.DYHUB_JumpPower = v
        pcall(function() Humanoid.JumpPower = v end)
    end
})

Player:Button({
    Title = "Reset Speed & Jump",
    Desc = "Restore walking speed and jump power to default values.",
    Callback = function()
        _G.DYHUB_WalkSpeed = 16
        _G.DYHUB_JumpPower = 7
        pcall(function() Humanoid.WalkSpeed = 16; Humanoid.JumpPower = 7 end)
        WindUI:Notify({Title="Reset", Content="Speed & Jump reset to default", Duration=2, Icon="rotate-ccw"})
    end
})

Player:Section({Title="Anti AFK", Icon="shield"})
local AntiAFKToggle = Player:Toggle({
    Title="Anti AFK",
    Desc = "Prevent automatic logout when inactive.",
    Value=false,
    Callback=function(state)
        Settings.AntiAFK = state
        if state then StartAntiAFK() else StopAntiAFK() end
        myConfig:Set("AntiAFK", state)
        myConfig:Save()
    end
})
myConfig:Register("AntiAFK", AntiAFKToggle)

-- ====================== REDEEM CODES ======================
Buff:Section({Title="Redeem Code", Icon="gift"})

local RedeemCodeDropdown = Buff:Dropdown({
    Title = "Select Code",
    Desc = "Choose promo codes to redeem.",
    Values = CodeList,
    Multi = true,
    Value = {},
    Callback = function(value)
        Dropdowns.SelectedCode = value
        myConfig:Set("SelectedCode", value)
        myConfig:Save()
    end
})
myConfig:Register("SelectedCode", RedeemCodeDropdown)

local function RedeemCodesLoop()
    while Settings.AutoRedeemCode do
        local codes = Dropdowns.SelectedCode
        if codes and #codes > 0 then
            local remote = FindRemote("RedemptionCodeRE")
            if remote then
                for _, code in ipairs(codes) do
                    if not Settings.AutoRedeemCode then break end
                    SafeFire(remote, {
                        ["event"] = "usecode",
                        ["code"] = code
                    })
                    task.wait(1.5)
                end
            else
                task.wait(3)
            end
        else
            task.wait(2)
        end
    end
end

local RedeemCodeToggle = Buff:Toggle({
    Title = "Auto Redeem Code",
    Desc = "Automatically claim selected promo codes.",
    Value = false,
    Callback = function(state)
        Settings.AutoRedeemCode = state
        if state then
            task.spawn(RedeemCodesLoop)
        end
        myConfig:Set("AutoRedeemCode", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoRedeemCode", RedeemCodeToggle)

-- ====================== AUTO BUY & EQUIP CONVEYOR ======================
Auto:Section({Title="Buy Conveyor", Icon="package"})

local BuyConveyorDropdown = Auto:Dropdown({
    Title="Select Conveyor to Buy",
    Desc = "Choose which conveyor tier to purchase automatically.",
    Values=ConveyorList,
    Multi=false,
    Value="1",
    Callback=function(value)
        Dropdowns.BuyIndex = tonumber(value) or 1
        myConfig:Set("BuyIndex", Dropdowns.BuyIndex)
        myConfig:Save()
    end
})
myConfig:Register("BuyIndex", BuyConveyorDropdown)

local function BuyConveyorLoop()
    while Settings.AutoBuyConveyor do
        local remote = FindRemote("ConveyorRE")
        if remote then
            SafeFire(remote, "Upgrade", Dropdowns.BuyIndex)
        end
        task.wait(ActionDelays.BuyConveyor)
    end
end

local BuyConveyorToggle = Auto:Toggle({
    Title="Buy Conveyor",
    Desc = "Automatically purchase the selected conveyor upgrade.",
    Value=false,
    Callback=function(state)
        Settings.AutoBuyConveyor = state
        if state then task.spawn(BuyConveyorLoop) end
        myConfig:Set("AutoBuyConveyor", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoBuyConveyor", BuyConveyorToggle)

Auto:Section({Title="Equip Conveyor", Icon="layout-grid"})

local EquipConveyorDropdown = Auto:Dropdown({
    Title="Select Conveyor to Equip",
    Desc = "Choose which conveyor tier to equip automatically.",
    Values=ConveyorList,
    Multi=false,
    Value="1",
    Callback=function(value)
        Dropdowns.EquipIndex = tonumber(value) or 1
        myConfig:Set("EquipIndex", Dropdowns.EquipIndex)
        myConfig:Save()
    end
})
myConfig:Register("EquipIndex", EquipConveyorDropdown)

local function EquipConveyorLoop()
    while Settings.AutoEquip do
        local remote = FindRemote("ConveyorRE")
        if remote then
            SafeFire(remote, "Switch", Dropdowns.EquipIndex)
        end
        task.wait(ActionDelays.SwitchConveyor)
    end
end

local EquipConveyorToggle = Auto:Toggle({
    Title="Equip Conveyor",
    Desc = "Automatically switch to the selected conveyor.",
    Value=false,
    Callback=function(state)
        Settings.AutoEquip = state
        if state then task.spawn(EquipConveyorLoop) end
        myConfig:Set("AutoEquip", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoEquip", EquipConveyorToggle)

-- ====================== POTIONS ======================
Buff:Section({Title="Potion", Icon="flask-conical"})

local PotionDropdown = Buff:Dropdown({
    Title="Select Potion(s)",
    Desc = "Choose one or multiple potions to use. Select 'All' to use all available potions.",
    Values=PotionDisplayList,
    Multi=true,
    Value={},
    Callback=function(values)
        if table.find(values, "All") then
            Dropdowns.SelectedPotions = {}
            for i = 2, #PotionDisplayList do
                table.insert(Dropdowns.SelectedPotions, PotionDisplayList[i])
            end
        else
            Dropdowns.SelectedPotions = values
        end
        myConfig:Set("SelectedPotions", Dropdowns.SelectedPotions)
        myConfig:Save()
    end
})
myConfig:Register("SelectedPotions", PotionDropdown)

local function PotionLoop()
    while Settings.AutoPotion do
        if #Dropdowns.SelectedPotions > 0 then
            local remote = FindRemote("ShopRE")
            if remote then
                for _, potion in ipairs(Dropdowns.SelectedPotions) do
                    if not Settings.AutoPotion then break end
                    SafeFire(remote, "UsePotion", potion)
                    task.wait(ActionDelays.Potion)
                end
            end
        end
        task.wait(5)
    end
end

local PotionToggle = Buff:Toggle({
    Title="Auto Use Selected Potions",
    Desc = "Automatically use potions on a regular interval.",
    Value=false,
    Callback=function(state)
        Settings.AutoPotion = state
        if state then task.spawn(PotionLoop) end
        myConfig:Set("AutoPotion", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoPotion", PotionToggle)

-- ====================== BAIT & FOOD ======================
Auto:Section({Title="Buy Bait", Icon="fish"})

local BaitDropdown = Auto:Dropdown({
    Title="Select Bait",
    Desc = "Choose which bait to purchase. Select 'All' to buy all available baits.",
    Values=BaitDisplayList,
    Multi=false,
    Value="FishingBait1",
    Callback=function(value)
        if value == "All" then
            Dropdowns.SelectedBait = BaitList[1]
        else
            Dropdowns.SelectedBait = value
        end
        myConfig:Set("SelectedBait", Dropdowns.SelectedBait)
        myConfig:Save()
    end
})
myConfig:Register("SelectedBait", BaitDropdown)

local function BaitLoop()
    while Settings.AutoBait do
        local remote = FindRemote("FishingRE")
        if remote and Dropdowns.SelectedBait then
            SafeFire(remote, "buy", Dropdowns.SelectedBait)
        end
        task.wait(ActionDelays.Bait)
    end
end

local BaitToggle = Auto:Toggle({
    Title="Buy Bait",
    Desc = "Automatically purchase the selected fishing bait.",
    Value=false,
    Callback=function(state)
        Settings.AutoBait = state
        if state then task.spawn(BaitLoop) end
        myConfig:Set("AutoBait", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoBait", BaitToggle)

Auto:Section({Title="Buy Food", Icon="shopping-bag"})

local FoodDisplayList = {"All"}
for _, food in ipairs(FoodList) do table.insert(FoodDisplayList, food) end

local FoodDropdown = Auto:Dropdown({
    Title="Select Food",
    Desc = "Choose which food to purchase. Select 'All' to buy all available foods.",
    Values=FoodDisplayList,
    Multi=false,
    Value="Strawberry",
    Callback=function(value)
        if value == "All" then
            Dropdowns.SelectedFood = FoodList[1]
        else
            Dropdowns.SelectedFood = value
        end
        myConfig:Set("SelectedFood", Dropdowns.SelectedFood)
        myConfig:Save()
    end
})
myConfig:Register("SelectedFood", FoodDropdown)

local function FoodLoop()
    while Settings.AutoFood do
        local remote = FindRemote("FoodStoreRE")
        if remote and Dropdowns.SelectedFood then
            SafeFire(remote, Dropdowns.SelectedFood)
        end
        task.wait(ActionDelays.Food)
    end
end

local FoodToggle = Auto:Toggle({
    Title="Buy Food",
    Desc = "Automatically purchase the selected food.",
    Value=false,
    Callback=function(state)
        Settings.AutoFood = state
        if state then task.spawn(FoodLoop) end
        myConfig:Set("AutoFood", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoFood", FoodToggle)

-- ====================== AUTO COLLECT COIN ======================
Main:Section({Title="Collect", Icon="dollar-sign"})

local timw = Main:Slider({
    Title = "Collect Delay (sec)",
    Desc = "Set the time interval between each collection attempt.",
    Value = { Min=1, Max=200, Default=10 },
    Step = 1,
    Callback = function(v)
        ActionDelays.Coin = v
        myConfig:Set("CoinDelay", v)
        myConfig:Save()
    end
})
myConfig:Register("CoinDelay", timw)

local function CollectCoinLoop()
    while Settings.AutoCollectCoin do
        local petsFolder = Workspace:FindFirstChild("Pets")
        if petsFolder then
            for _, pet in ipairs(petsFolder:GetChildren()) do
                if not Settings.AutoCollectCoin then break end
                local trg = pet:FindFirstChild("TrgIdle")
                if trg and trg:FindFirstChild("TouchInterest") then
                    pcall(function()
                        firetouchinterest(HumanoidRootPart, trg, 0)
                        task.wait()
                        firetouchinterest(HumanoidRootPart, trg, 1)
                    end)
                end
            end
        end
        task.wait(ActionDelays.Coin)
    end
end

local CollectCoinToggleWT = Main:Toggle({
    Title = "Auto Collect Coin",
    Desc = "Collect coins from pets automatically.",
    Value = false,
    Callback = function(state)
        Settings.AutoCollectCoin = state
        if state then task.spawn(CollectCoinLoop) end
        myConfig:Set("AutoCollectCoin", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoCollectCoin", CollectCoinToggleWT)

-- ====================== AUTO FISH ======================
Main:Section({Title="Fishing", Icon="fish"})

local function FishLoop()
    while Settings.AutoFish do
        local remote = FindRemote("FishingRE")
        if remote then
            SafeFire(remote, {"POUT",{SUC=1}})
        end
        task.wait(ActionDelays.Fish)
    end
end

local FishToggle = Main:Toggle({
    Title="Auto Reel",
    Desc = "Automatically reel in fish during fishing.",
    Value=false,
    Callback=function(state)
        Settings.AutoFish = state
        if state then task.spawn(FishLoop) end
        myConfig:Set("AutoFish", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoFish", FishToggle)

-- ====================== AUTO SPIN ======================
Main:Section({Title="Spin: Ticket", Icon="ticket"})

local function SpinLoop(count)
    local flag = (count == 1 and "AutoSpin1") or (count == 5 and "AutoSpin2") or "AutoSpin3"
    while Settings[flag] do
        local remote = FindRemote("LotteryRE")
        if remote then
            SafeFire(remote, {event = "lottery", count = count})
        end
        task.wait(ActionDelays.Spin)
    end
end

local SpinToggle = Main:Toggle({
    Title = "Auto Spin Lottery (x1)",
    Desc = "Automatically spin the lottery machine once per cycle.",
    Value = false,
    Callback = function(state)
        Settings.AutoSpin1 = state
        if state then task.spawn(function() SpinLoop(1) end) end
        myConfig:Set("AutoSpin1", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoSpin1", SpinToggle)

local SpinToggle2 = Main:Toggle({
    Title = "Auto Spin Lottery (x5)",
    Desc = "Automatically spin the lottery machine five times per cycle.",
    Value = false,
    Callback = function(state)
        Settings.AutoSpin2 = state
        if state then task.spawn(function() SpinLoop(5) end) end
        myConfig:Set("AutoSpin2", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoSpin2", SpinToggle2)

local SpinToggle3 = Main:Toggle({
    Title = "Auto Spin Lottery (x10)",
    Desc = "Automatically spin the lottery machine ten times per cycle.",
    Value = false,
    Callback = function(state)
        Settings.AutoSpin3 = state
        if state then task.spawn(function() SpinLoop(10) end) end
        myConfig:Set("AutoSpin3", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoSpin3", SpinToggle3)

-- ====================== BUY EGGS ======================
Egg:Section({Title="Buy Eggs", Icon="egg"})

local function getEggType(eggModel)
    local root = eggModel:FindFirstChild("RootPart")
    local eggType = nil
    if root then
        eggType = root:GetAttribute("Type") or root:GetAttribute("EggType")
    end
    if not eggType then
        eggType = eggModel:GetAttribute("Type") or eggModel:GetAttribute("EggType")
    end
    if not eggType then
        for _, child in ipairs(eggModel:GetChildren()) do
            if child:IsA("StringValue") and (child.Name == "Type" or child.Name == "EggType") then
                eggType = child.Value
                break
            end
        end
    end
    return eggType
end

local eggTypesDisplay = {"All"}
for _, egg in ipairs(EggTypes) do table.insert(eggTypesDisplay, egg) end

local BuyEggDropdown = Egg:Dropdown({
    Title = "Select Eggs",
    Desc = "Choose which eggs to purchase. Select 'All' to buy all available egg types.",
    Values = eggTypesDisplay,
    Multi = true,
    Value = {},
    Callback = function(values)
        if table.find(values, "All") then
            for _, egg in ipairs(EggTypes) do
                eggBuyMap[egg] = true
            end
        else
            for _, egg in ipairs(EggTypes) do
                eggBuyMap[egg] = false
            end
            for _, v in ipairs(values) do
                eggBuyMap[v] = true
            end
        end
        Dropdowns.SelectedEggs = values
        myConfig:Set("SelectedEggs", values)
        myConfig:Save()
    end
})
myConfig:Register("SelectedEggs", BuyEggDropdown)

local function BuyEggLoop()
    local characterRE = nil
    while Settings.AutoBuyEgg do
        -- Lazy load remote
        if not characterRE then
            characterRE = FindRemote("CharacterRE", 3)
        end

        if not characterRE then
            task.wait(2)
            continue
        end

        -- Check if any egg is selected
        local anyActive = false
        for _, v in pairs(eggBuyMap) do
            if v then
                anyActive = true
                break
            end
        end
        if not anyActive then
            task.wait(1)
            continue
        end

        local art = Workspace:FindFirstChild("Art")
        if not art then
            task.wait(1)
            continue
        end

        -- ✅ OPTIMIZED: Only iterate active islands/conveyors
        for _, island in ipairs(art:GetChildren()) do
            if not Settings.AutoBuyEgg then break end
            if not island.Name:match("^Island_%d+$") then continue end

            local env = island:FindFirstChild("ENV")
            local conveyor = env and env:FindFirstChild("Conveyor")
            if not conveyor then continue end

            for _, conveyorX in ipairs(conveyor:GetChildren()) do
                if not Settings.AutoBuyEgg then break end
                if not conveyorX.Name:match("^Conveyor%d+$") then continue end

                local belt = conveyorX:FindFirstChild("Belt")
                if not belt then continue end

                local eggCount = 0
                for _, eggModel in ipairs(belt:GetChildren()) do
                    if not Settings.AutoBuyEgg then break end
                    if eggCount >= 50 then break end

                    local eggType = getEggType(eggModel)
                    if eggType and eggBuyMap[eggType] then
                        local root = eggModel:FindFirstChild("RootPart")
                        local uidVal = (root and root:GetAttribute("UID")) or
                                       eggModel:GetAttribute("UID") or
                                       tostring(eggModel.Name)

                        SafeFire(characterRE, "BuyEgg", uidVal)
                        eggCount = eggCount + 1
                        task.wait(ActionDelays.BuyEgg)
                    end
                end
            end
        end

        task.wait(0.5)
    end
end

local BuyEggToggle = Egg:Toggle({
    Title = "Auto Buy Eggs",
    Desc = "Automatically purchase the selected egg types.",
    Value = false,
    Callback = function(state)
        Settings.AutoBuyEgg = state
        if state then task.spawn(BuyEggLoop) end
        myConfig:Set("AutoBuyEgg", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoBuyEgg", BuyEggToggle)

-- ====================== ACTION EGGS (HATCH/PLACE/PICKUP) - OPTIMIZED ======================
-- ====================== ACTION EGGS (HATCH/PLACE/PICKUP) - FIXED VERSION ======================
Egg:Section({Title="Action Eggs", Icon="cpu"})

-- ✅ FIXED: Dynamic cache rebuild + enable check
local HatchPromptCache = {}
local PlacePromptCache = {}
local PickupPromptCache = {}

local function RebuildActionCache()
    HatchPromptCache = {}
    PlacePromptCache = {}
    PickupPromptCache = {}

    -- Get fresh prompts every time (don't rely on stale cache)
    local prompts = GetValidPrompts()
    
    for prompt, part in pairs(prompts) do
        -- ✅ CRITICAL FIX: Check if prompt is ACTUALLY enabled NOW
        if not prompt.Parent or not prompt.Enabled then
            continue
        end
        
        local action = prompt.ActionText or ""
        local pos = part.Position
        
        if action == "Hatch" then
            table.insert(HatchPromptCache, {prompt = prompt, part = part, pos = pos})
        elseif action == "Place" then
            table.insert(PlacePromptCache, {prompt = prompt, part = part, pos = pos})
        elseif action == "Recall" then
            table.insert(PickupPromptCache, {prompt = prompt, part = part, pos = pos})
        end
    end

    -- Sort by distance (closest first)
    local function sortByDist(a, b)
        if not HumanoidRootPart then return false end
        return (HumanoidRootPart.Position - a.pos).Magnitude < (HumanoidRootPart.Position - b.pos).Magnitude
    end
    
    table.sort(HatchPromptCache, sortByDist)
    table.sort(PlacePromptCache, sortByDist)
    table.sort(PickupPromptCache, sortByDist)
end

-- ✅ OPTIMIZED: Use cached prompts + final validation before trigger
local function TriggerCachedPrompt(cache, range)
    range = range or 100
    local rootPos = HumanoidRootPart and HumanoidRootPart.Position
    if not rootPos then return end

    for _, entry in ipairs(cache) do
        -- ✅ CRITICAL FIX: Double-check prompt still exists and is ENABLED
        if entry.prompt and entry.prompt.Parent and entry.part and entry.part.Parent then
            if entry.prompt.Enabled then  -- Check enable status AGAIN here
                local dist = (rootPos - entry.pos).Magnitude
                if dist <= range then
                    pcall(function()
                        fireproximityprompt(entry.prompt)
                    end)
                    return true
                end
            end
        end
    end
    return false
end

-- ✅ FIXED: Rebuild cache more frequently to catch enable/disable changes
local function ActionLoop(cache, settingName, baseDelay)
    while Settings[settingName] do
        RebuildActionCache()  -- Rebuild every loop to catch dynamic changes
        if cache == HatchPromptCache then
            if #HatchPromptCache > 0 then
                TriggerCachedPrompt(HatchPromptCache, 100)
            end
        elseif cache == PlacePromptCache then
            if #PlacePromptCache > 0 then
                TriggerCachedPrompt(PlacePromptCache, 100)
            end
        elseif cache == PickupPromptCache then
            if #PickupPromptCache > 0 then
                TriggerCachedPrompt(PickupPromptCache, 100)
            end
        end
        task.wait(baseDelay)
    end
end

local HatchToggle = Egg:Toggle({
    Title = "Auto Hatch Eggs",
    Desc = "Automatically hatch eggs when available.",
    Value = false,
    Callback = function(state)
        Settings.AutoHatch = state
        if state then
            task.spawn(function() ActionLoop(HatchPromptCache, "AutoHatch", 0.1) end)
        end
        myConfig:Set("AutoHatch", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoHatch", HatchToggle)

local PlaceEggToggle = Egg:Toggle({
    Title = "Auto Place Eggs",
    Desc = "Automatically place eggs in available slots.",
    Value = false,
    Callback = function(state)
        Settings.AutoPlace = state
        if state then
            task.spawn(function() ActionLoop(PlacePromptCache, "AutoPlace", 0.15) end)
        end
        myConfig:Set("AutoPlace", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoPlace", PlaceEggToggle)

Egg:Section({Title="Action Pet", Icon="bone"})

local PickEggToggle = Egg:Toggle({
    Title = "Auto Pickup Pet (Need equip hammer)",
    Desc = "Automatically pickup pets when available.",
    Value = false,
    Callback = function(state)
        Settings.AutoPickup = state
        if state then
            task.spawn(function() ActionLoop(PickupPromptCache, "AutoPickup", 0.2) end)
        end
        myConfig:Set("AutoPickup", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoPickup", PickEggToggle)

-- ====================== EVENT: VOID ======================
Event:Section({Title="Event: Honeybloom", Icon="flower"})

local QuestDropdown = Event:Dropdown({
    Title = "Select Honeybloom Quest",
    Desc = "Choose which quest to claim rewards from. Select 'All' to claim all quests.",
    Values = QuestList,
    Multi = false,
    Value = "Task_1",
    Callback = function(value)
        Dropdowns.SelectedQuest = value
        myConfig:Set("SelectedQuest", value)
        myConfig:Save()
    end
})
myConfig:Register("SelectedQuest", QuestDropdown)

local function QuestLoop()
    while Settings.AutoQuest do
        local remote = FindRemote("DinoEventRE", 3)
        if remote then
            if Dropdowns.SelectedQuest == "All" then
                for i = 1, 20 do
                    if not Settings.AutoQuest then break end
                    SafeFire(remote, {{event = "claimreward", id = "Task_" .. i}})
                    task.wait(0.3)
                end
            else
                SafeFire(remote, {{event = "claimreward", id = Dropdowns.SelectedQuest}})
            end
        end
        task.wait(ActionDelays.Quest)
    end
end

local QuestToggle = Event:Toggle({
    Title = "Auto Claim Quest",
    Desc = "Automatically claim quest rewards on an interval.",
    Value = false,
    Callback = function(state)
        Settings.AutoQuest = state
        if state then task.spawn(QuestLoop) end
        myConfig:Set("AutoQuest", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoQuest", QuestToggle)

local function CollectDinoLoop()
    while Settings.AutoCollectDino do
        local remote = FindRemote("DinoEventRE", 3)
        if remote then
            SafeFire(remote, {{event = "onlinepack"}})
        end
        task.wait(ActionDelays.DinoCollect)
    end
end

local CollectDinoToggle = Event:Toggle({
    Title = "Auto Collect Honeybloom Rewards",
    Desc = "Automatically collect event rewards on an interval.",
    Value = false,
    Callback = function(state)
        Settings.AutoCollectDino = state
        if state then task.spawn(CollectDinoLoop) end
        myConfig:Set("AutoCollectDino", state)
        myConfig:Save()
    end
})
myConfig:Register("AutoCollectDino", CollectDinoToggle)

-- ====================== INFO TAB ======================
Info = InfoTab

if not ui then ui = {} end
if not ui.Creator then ui.Creator = {} end

ui.Creator.Request = function(requestData)
    local success, result = pcall(function()
        if HttpService.RequestAsync then
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

local InviteCode = "jWNDPNMmyB"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local function LoadDiscordInfo()
    local success, result = pcall(function()
        return HttpService:JSONDecode(ui.Creator.Request({
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
            Desc = "Refresh Discord server statistics.",
            Callback = function()
                local updated, updatedResult = pcall(function()
                    return HttpService:JSONDecode(ui.Creator.Request({
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
            Desc = "Copy the Discord invite link to clipboard.",
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

Info:Paragraph({Title="Main Owner", Desc="@dyumraisgoodguy#8888", Image="rbxassetid://119789418015420", ImageSize=30})
Info:Paragraph({
    Title="Social",
    Desc="Copy link social media for follow!",
    Image="rbxassetid://104487529937663",
    ImageSize=30,
    Buttons={{Icon="copy", Title="Copy Link", Callback=function() setclipboard("https://guns.lol/DYHUB") end}}
})
Info:Paragraph({
    Title="Discord",
    Desc="Join our discord for more scripts!",
    Image="rbxassetid://104487529937663",
    ImageSize=30,
    Buttons={{Icon="copy", Title="Copy Link", Callback=function() setclipboard("https://discord.gg/jWNDPNMmyB") end}}
})

-- ====================== LOAD CONFIG ON STARTUP ======================
pcall(function() myConfig:Load() end)

-- Restore eggs selection
local loadedEggs = myConfig:Get("SelectedEggs")
if loadedEggs and type(loadedEggs) == "table" then
    for _, egg in ipairs(EggTypes) do eggBuyMap[egg] = false end
    for _, v in ipairs(loadedEggs) do
        eggBuyMap[v] = true
    end
end

-- Restore settings
for key, value in pairs({
    AntiAFK = "AntiAFK",
    AutoBuyConveyor = "AutoBuyConveyor",
    AutoEquip = "AutoEquip",
    AutoPotion = "AutoPotion",
    AutoBait = "AutoBait",
    AutoFood = "AutoFood",
    AutoCollectCoin = "AutoCollectCoin",
    AutoFish = "AutoFish",
    AutoSpin1 = "AutoSpin1",
    AutoSpin2 = "AutoSpin2",
    AutoSpin3 = "AutoSpin3",
    AutoBuyEgg = "AutoBuyEgg",
    AutoHatch = "AutoHatch",
    AutoPlace = "AutoPlace",
    AutoPickup = "AutoPickup",
    AutoQuest = "AutoQuest",
    AutoCollectDino = "AutoCollectDino",
    AutoRedeemCode = "AutoRedeemCode",
}) do
    local saved = myConfig:Get(key)
    if saved ~= nil then
        Settings[value] = saved
    end
end

-- Apply AntiAFK on load
if Settings.AntiAFK then StartAntiAFK() end

-- ✅ OPTIMIZED: Re-build prompt cache periodically in background
task.spawn(function()
    while true do
        task.wait(5)
        if Settings.AutoHatch or Settings.AutoPlace or Settings.AutoPickup then
            RebuildPromptCache()
            RebuildActionCache()
        end
    end
end)

Window:OnClose(function() myConfig:Save() end)

print("[DYHUB] Build a Zoo v" .. version .. " loaded successfully!")
print("[DYHUB] All systems optimized for performance.")
