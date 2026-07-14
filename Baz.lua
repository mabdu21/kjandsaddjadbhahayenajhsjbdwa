-- =========================
local version = "3.7.5"
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
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- ====================== SETTINGS ======================
local SelectedCode, SelectedBait, SelectedFood, SelectedQuest
local autoHatch = false
local AutoEquip = false
local AutoPotion = false
local AutoCollectEnabled_CoinWT = false
local autoCollectDino = false
local AutoBuyConveyor = false
local AutoDinoEnabled = false
local AutoBaitEnabled = false
local AutoFoodEnabled = false
local AutoFishEnabled = false
local AutoSpinEnabled = false
local AutoSpinEnabled2 = false
local AutoSpinEnabled3 = false
local wtvalue = 10
local AutoBuyEggEnabled = false
local autoPlaceEggs = false
local autopickEggs = false
local dinoDelay = 5

local SelectedPotions = {}
local QuestList = {"All"}
for i = 1, 20 do table.insert(QuestList, "Task_"..i) end

local BuyIndex, EquipIndex, SelectedCount = 1, 1, 1
local SpinCounts = {1,3,10}

local FoodList = {
    "Strawberry","Blueberry","Watermelon","Apple",
    "Orange","Corn","Banana","Grape","Pear","PineApple",
    "Dargon Fruit","Gold Mango","Bloodstone Cycad","Colossal Pinecone",
    "Volt Ginkgo","Deepsea Pearl Fruit","Durian","Pumpkin","Franken Kiwi",
    "Acorn","Cranberry","Gingerbread","Candy Cane","Cherry","Yogurt Ice Cream",
    "Mint Jelly","Macaron Jely"
}

local eggTypes = {
    "BasicEgg","RareEgg","SuperRareEgg","EpicEgg","LegendEgg","HyperEgg",
    "BowserEgg","VoidEgg","CornEgg","BoneDragonEgg","DemonEgg","PrismaticEgg",
    "DarkGoatyEgg","LionfishEgg","OctopusEgg","UltraEgg","UnicornEgg","UnicornProEgg",
    "AnglerfishEgg","RhinoRockEgg","SaberCubEgg","SeaweedEgg","SharkEgg","SnowbunnyEgg",
    "GeneralKongEgg","SailfishEgg","SeaDragonEgg","PegasusEgg","ClownfishEgg","AncientEgg",
    "DinoEgg","FlyEgg","OceanEgg","MetroGiraffeEgg","GodzillaEgg","CapyEgg","HalloweenEgg",
    "WarmLittleRabbitEgg","WendigoEgg","WhiteTigerEgg","WoollyRhinocerosEgg","YILANDDragonEgg",
    "ToyDragonEgg","SwanEgg","StoneLionEgg","SiriusEgg","SpaceMouseEgg","SteampunkTurtleEgg",
    "ShadowKingEgg","SeaPlugEgg","Seahorse","SaberCubEgg","RedPandaEgg","RcckChickenEgg",
    "OceanSunfishEgg","PinkUnicorn","PirateCrabEgg","PurpleButterflyEgg","OakenEgg","NinjaDogEgg",
    "NarwhalEgg","NanoRamEgg","LobsterEgg","MagicRabbitEgg","LittieMonsterEgg","KnightHorse",
    "GreenStormEgg","GlassesRabbitEgg","FlyingsquirrelEgg","GingerCatEgg","FlowerWhaleEgg","FlowerBatEgg",
    "FennecFoxEgg","EggshellDinosaurEgg","DrakespineEgg","DivineDeerEgg","CyberDragonEgg","BullDemonEgg","ArowanaEgg","PetalwingEgg"
}

local PotionList = {"All", "Potion_Coin","Potion_Luck","Potion_Hatch","Potion_3in1"}
local BaitList = {"All", "FishingBait1","FishingBait2","FishingBait3"}
local ConveyorList = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14"}
local EquipConveyorList = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14"}
local CodeList = {
    "RABBITHAT30","MERRYTIMES2026","4XW5RG4CHRY","N7A68Q82H83",
    "3XKK8Z2WB6G","DS5523YSQ3C","SANTASWORKS","ZooFish829",
    "U2CA518SC5","FIXERROR819","A38JBJ3TSSE","TUESDAYFUN1",
    "ROMANCEBLOOMS","50KCCU0912","MagicFruit"
}

local buyEggList = {}
for _, egg in ipairs(eggTypes) do buyEggList[egg] = false end

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

-- ====================== PLAYER TAB ======================
Player:Section({Title="Character", Icon="user"})

local SpeedSlider = Player:Slider({
    Title = "Walk Speed",
    Desc = "Increase or decrease your character's walking speed.",
    Value = { Min=16, Max=500, Default=16 },
    Step = 1,
    Callback = function(v)
        local lp = game.Players.LocalPlayer
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
})

local JumpSlider = Player:Slider({
    Title = "Jump Power",
    Desc = "Increase or decrease your character's jumping ability.",
    Value = { Min=7, Max=500, Default=7 },
    Step = 1,
    Callback = function(v)
        local lp = game.Players.LocalPlayer
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = v end
    end
})

Player:Button({
    Title = "Reset Speed & Jump",
    Desc = "Restore walking speed and jump power to default values.",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed=16; hum.JumpPower=7 end
        WindUI:Notify({Title="Reset", Content="Speed & Jump reset to default", Duration=2, Icon="rotate-ccw"})
    end
})

Player:Section({Title="Anti AFK", Icon="shield"})
local AntiAFKToggle = Player:Toggle({
    Title="Anti AFK",
    Desc = "Prevent automatic logout when inactive.",
    Value=false,
    Callback=function(state)
        AntiAFKEnabled = state
        if state then task.spawn(function()
            local VirtualUser = game:GetService("VirtualUser")
            while AntiAFKEnabled do
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                task.wait(20)
            end
        end) end
        myConfig:Save()
    end
})
myConfig:Register("AntiAFKEnabled", AntiAFKToggle)

-- ====================== CODES TAB ======================
Buff:Section({
    Title = "Redeem Code",
    Icon = "gift"
})

local SelectedCode = CodeList[1]

local RedeemCodeDropdown = Buff:Dropdown({
    Title = "Select Code",
    Desc = "Choose a promo code to redeem.",
    Values = CodeList,
    Multi = true,
    Callback = function(value)
        SelectedCode = value
        myConfig:Save()
    end
})
myConfig:Register("SelectedCode", RedeemCodeDropdown)

local RedeemCodeToggle = Buff:Toggle({
    Title = "Auto Redeem Code",
    Desc = "Automatically claim available promo codes.",
    Value = false,
    Callback = function(state)
        AutoRedeemCode = state

        if state then
            task.spawn(function()
                while AutoRedeemCode do
                    local args = {
                        [1] = {
                            ["event"] = "usecode",
                            ["code"] = SelectedCode
                        }
                    }

                    game:GetService("ReplicatedStorage")
                        .Remote.RedemptionCodeRE:FireServer(unpack(args))

                    task.wait(2)
                end
            end)
        end

        myConfig:Save()
    end
})
myConfig:Register("AutoRedeemCode", RedeemCodeToggle)

-- ====================== AUTO BUY & EQUIP ======================
-- Buy Conveyor
Auto:Section({Title="Buy Conveyor", Icon="package"})
local BuyConveyorDropdown = Auto:Dropdown({
    Title="Select Conveyor to Buy",
    Desc = "Choose which conveyor tier to purchase automatically.",
    Values=ConveyorList,
    Multi=false,
    Callback=function(value)
        BuyIndex=tonumber(value)
        myConfig:Save()
    end
})
myConfig:Register("BuyIndex", BuyConveyorDropdown)
local BuyConveyorToggle = Auto:Toggle({
    Title="Buy Conveyor",
    Desc = "Automatically purchase the selected conveyor upgrade.",
    Value=false,
    Callback=function(state)
        AutoBuyConveyor=state
        if state then task.spawn(function()
            while AutoBuyConveyor do
                local args={"Upgrade",BuyIndex}
                ReplicatedStorage.Remote.ConveyorRE:FireServer(unpack(args))
                task.wait(2)
            end
        end) end
        myConfig:Save()
    end
})
myConfig:Register("AutoBuyConveyor", BuyConveyorToggle)

-- Equip Conveyor
Auto:Section({Title="Equip Conveyor", Icon="layout-grid"})
local EquipConveyorDropdown = Auto:Dropdown({
    Title="Select Conveyor to Equip",
    Desc = "Choose which conveyor tier to equip automatically.",
    Values=EquipConveyorList,
    Multi=false,
    Callback=function(value)
        EquipIndex=tonumber(value)
        myConfig:Save()
    end
})
myConfig:Register("EquipIndex", EquipConveyorDropdown)
local EquipConveyorToggle = Auto:Toggle({
    Title="Equip Conveyor",
    Desc = "Automatically switch to the selected conveyor.",
    Value=false,
    Callback=function(state)
        AutoEquip=state
        if state then task.spawn(function()
            while AutoEquip do
                local args={"Switch",EquipIndex}
                ReplicatedStorage.Remote.ConveyorRE:FireServer(unpack(args))
                task.wait(1.5)
            end
        end) end
        myConfig:Save()
    end
})
myConfig:Register("AutoEquip", EquipConveyorToggle)

-- ====================== POTIONS ======================
Buff:Section({Title="Potion", Icon="flask-conical"})
local PotionDropdown = Buff:Dropdown({
    Title="Select Potion(s)",
    Desc = "Choose one or multiple potions to use. Select 'All' to use all available potions.",
    Values=PotionList,
    Multi=true,
    Callback=function(values)
        if table.find(values, "All") then
            SelectedPotions = {}
            for i = 2, #PotionList do
                table.insert(SelectedPotions, PotionList[i])
            end
        else
            SelectedPotions=values
        end
        myConfig:Save()
    end
})
myConfig:Register("SelectedPotions", PotionDropdown)
local PotionToggle = Buff:Toggle({
    Title="Auto Use Selected Potions",
    Desc = "Automatically use potions on a regular interval.",
    Value=false,
    Callback=function(state)
        AutoPotion=state
        if state then task.spawn(function()
            while AutoPotion do
                for _,potion in pairs(SelectedPotions) do
                    local args={"UsePotion",potion}
                    ReplicatedStorage.Remote.ShopRE:FireServer(unpack(args))
                    task.wait(1)
                end
                task.wait(5)
            end
        end) end
        myConfig:Save()
    end
})
myConfig:Register("AutoPotion", PotionToggle)

-- ====================== AUTO BAIT & FOOD ======================
Auto:Section({Title="Buy Bait", Icon="fish"})
local BaitDropdown = Auto:Dropdown({
    Title="Select Bait",
    Desc = "Choose which bait to purchase. Select 'All' to buy all available baits.",
    Values=BaitList,
    Multi=false,
    Callback=function(value)
        if value == "All" then
            SelectedBait = BaitList[2]
        else
            SelectedBait=value
        end
        myConfig:Save()
    end
})
myConfig:Register("SelectedBait", BaitDropdown)
local BaitToggle = Auto:Toggle({
    Title="Buy Bait",
    Desc = "Automatically purchase the selected fishing bait.",
    Value=false,
    Callback=function(state)
        AutoBaitEnabled=state
        task.spawn(function()
            while AutoBaitEnabled do
                if SelectedBait then
                    ReplicatedStorage.Remote.FishingRE:FireServer("buy",SelectedBait)
                end
                task.wait(0.5)
            end
        end)
        myConfig:Save()
    end
})
myConfig:Register("AutoBaitEnabled", BaitToggle)

Auto:Section({Title="Buy Food", Icon="shopping-bag"})
local FoodList_Dropdown = {"All"}
for _, food in ipairs(FoodList) do table.insert(FoodList_Dropdown, food) end

local FoodDropdown = Auto:Dropdown({
    Title="Select Food",
    Desc = "Choose which food to purchase. Select 'All' to buy all available foods.",
    Values=FoodList_Dropdown,
    Multi=false,
    Callback=function(value)
        if value == "All" then
            SelectedFood = FoodList[1]
        else
            SelectedFood=value
        end
        myConfig:Save()
    end
})
myConfig:Register("SelectedFood", FoodDropdown)
local FoodToggle = Auto:Toggle({
    Title="Buy Food",
    Desc = "Automatically purchase the selected food.",
    Value=false,
    Callback=function(state)
        AutoFoodEnabled=state
        task.spawn(function()
            while AutoFoodEnabled do
                if SelectedFood then
                    ReplicatedStorage.Remote.FoodStoreRE:FireServer(SelectedFood)
                end
                task.wait(0.5)
            end
        end)
        myConfig:Save()
    end
})
myConfig:Register("AutoFoodEnabled", FoodToggle)

-- ====================== AUTO COLLECT ======================
Main:Section({ Title = "Collect", Icon = "dollar-sign" })

local timw = Main:Slider({
    Title    = "Collect Delay (sec)",
    Desc     = "Set the time interval between each collection attempt.",
    Value    = { Min=1, Max=200, Default=wtvalue },
    Step     = 1,
    Callback = function(v)
        wtvalue = v
        myConfig:Save()
    end
})
myConfig:Register("wtvalue", timw)

local CollectCoinToggleWT = Main:Toggle({
    Title = "Auto Collect Coin",
    Desc = "Collect coins from pets",
    Value = false,
    Callback = function(state)
        AutoCollectEnabled_CoinWT = state

        if state then
            task.spawn(function()
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")

                player.CharacterAdded:Connect(function(char)
                    character = char
                    hrp = char:WaitForChild("HumanoidRootPart")
                end)

                while AutoCollectEnabled_CoinWT do
                    local petsFolder = workspace:WaitForChild("Pets")

                    for _, pet in pairs(petsFolder:GetChildren()) do
                        local trg = pet:FindFirstChild("TrgIdle")

                        if trg and trg:FindFirstChild("TouchInterest") then
                            pcall(function()
                                firetouchinterest(hrp, trg, 0)
                                firetouchinterest(hrp, trg, 1)
                            end)
                        end
                    end

                    task.wait(wtvalue)
                end
            end)
        end

        myConfig:Save()
    end
})
myConfig:Register("AutoCollectEnabled_CoinWT", CollectCoinToggleWT)

-- ====================== AUTO FISH ======================
Main:Section({Title="Fishing", Icon="fish"})
local FishToggle = Main:Toggle({
    Title="Auto Reel",
    Desc = "Automatically reel in fish during fishing.",
    Value=false,
    Callback=function(state)
        AutoFishEnabled=state
        task.spawn(function()
            while AutoFishEnabled do
                ReplicatedStorage.Remote.FishingRE:FireServer({"POUT",{SUC=1}})
                task.wait(0.5)
            end
        end)
        myConfig:Save()
    end
})
myConfig:Register("AutoFishEnabled", FishToggle)

-- ====================== AUTO SPIN ======================
Main:Section({Title="Spin: Ticket", Icon="ticket"})

local SpinToggle = Main:Toggle({
    Title = "Auto Spin Lottery (x1)",
    Desc = "Automatically spin the lottery machine once per cycle.",
    Value = false,
    Callback = function(state)
        AutoSpinEnabled = state

        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local LotteryRE = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("LotteryRE")

                while AutoSpinEnabled do
                    pcall(function()
                        LotteryRE:FireServer({
                            event = "lottery",
                            count = 1
                        })
                    end)
                    task.wait(1)
                end
            end)
        end

        myConfig:Save()
    end
})
myConfig:Register("AutoSpinx1Enabled", SpinToggle)

local SpinToggle2 = Main:Toggle({
    Title = "Auto Spin Lottery (x5)",
    Desc = "Automatically spin the lottery machine five times per cycle.",
    Value = false,
    Callback = function(state)
        AutoSpinEnabled2 = state

        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local LotteryRE = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("LotteryRE")

                while AutoSpinEnabled2 do
                    pcall(function()
                        LotteryRE:FireServer({
                            event = "lottery",
                            count = 5
                        })
                    end)
                    task.wait(1)
                end
            end)
        end

        myConfig:Save()
    end
})
myConfig:Register("AutoSpinx2Enabled", SpinToggle2)

local SpinToggle3 = Main:Toggle({
    Title = "Auto Spin Lottery (x10)",
    Desc = "Automatically spin the lottery machine ten times per cycle.",
    Value = false,
    Callback = function(state)
        AutoSpinEnabled3 = state

        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local LotteryRE = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("LotteryRE")

                while AutoSpinEnabled3 do
                    pcall(function()
                        LotteryRE:FireServer({
                            event = "lottery",
                            count = 10
                        })
                    end)
                    task.wait(1)
                end
            end)
        end

        myConfig:Save()
    end
})
myConfig:Register("AutoSpinx3Enabled", SpinToggle3)

-- ====================== AUTO BUY & HATCH EGG ======================

Egg:Section({ Title = "Buy Eggs", Icon = "egg" })

local function getEggType(eggModel)
    local root = eggModel:FindFirstChild("RootPart")
    local eggType =
        (root and (root:GetAttribute("Type") or root:GetAttribute("EggType"))) or
        eggModel:GetAttribute("Type") or
        eggModel:GetAttribute("EggType")

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

local eggTypes_Dropdown = {"All"}
for _, egg in ipairs(eggTypes) do table.insert(eggTypes_Dropdown, egg) end

local BuyEggDropdown = Egg:Dropdown({
    Title = "Select Eggs",
    Desc = "Choose which eggs to purchase. Select 'All' to buy all available egg types.",
    Values = eggTypes_Dropdown,
    Multi = true,
    Callback = function(values)
        if table.find(values, "All") then
            for _, egg in ipairs(eggTypes) do
                buyEggList[egg] = true
            end
        else
            for _, egg in ipairs(eggTypes) do
                buyEggList[egg] = false
            end
            for _, v in ipairs(values) do
                buyEggList[v] = true
            end
        end
        myConfig:Save()
    end
})

myConfig:Register("SelectedEggs", BuyEggDropdown)

local BuyEggToggle = Egg:Toggle({
    Title = "Auto Buy Eggs",
    Desc = "Automatically purchase the selected egg types.",
    Value = false,
    Callback = function(state)
        AutoBuyEggEnabled = state
        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                while AutoBuyEggEnabled do
                    task.wait(0.15 + math.random() * 0.3)

                    local anyActive = false
                    for _, v in pairs(buyEggList) do
                        if v then
                            anyActive = true
                            break
                        end
                    end
                    if not anyActive then
                        task.wait(1)
                        continue
                    end

                    local art = workspace:FindFirstChild("Art")
                    if not art then
                        task.wait(1)
                        continue
                    end

                    local ok, characterRE = pcall(function()
                        return ReplicatedStorage:WaitForChild("Remote", 5):WaitForChild("CharacterRE", 5)
                    end)
                    if not ok or not characterRE then
                        task.wait(2)
                        continue
                    end

                    for _, island in ipairs(art:GetChildren()) do
                        if not island.Name:match("^Island_%d+$") then
                            continue
                        end

                        local env = island:FindFirstChild("ENV")
                        local conveyor = env and env:FindFirstChild("Conveyor")
                        if not conveyor then
                            continue
                        end

                        for _, conveyorX in ipairs(conveyor:GetChildren()) do
                            if not conveyorX.Name:match("^Conveyor%d+$") then
                                continue
                            end

                            local belt = conveyorX:FindFirstChild("Belt")
                            if not belt then
                                continue
                            end

                            local eggCount = 0
                            for _, eggModel in ipairs(belt:GetChildren()) do
                                if eggCount >= 50 then
                                    break
                                end

                                local eggType = getEggType(eggModel)
                                if eggType and buyEggList[eggType] then
                                    local root = eggModel:FindFirstChild("RootPart")
                                    local uidVal =
                                        (root and root:GetAttribute("UID")) or
                                        eggModel:GetAttribute("UID") or
                                        tostring(eggModel.Name)

                                    pcall(function()
                                        characterRE:FireServer("BuyEgg", uidVal)
                                    end)

                                    eggCount += 1
                                    task.wait(0.05 + math.random() * 0.1)
                                end
                            end
                        end
                    end
                end
            end)
        end
        myConfig:Save()
    end
})
myConfig:Register("AutoBuyEggEnabled", BuyEggToggle)

-- ====================== AUTO HATCH EGGS ======================

Egg:Section({ Title = "Action Eggs", Icon = "cpu" })

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
    character = char
    hrp = char:WaitForChild("HumanoidRootPart")
end)

local function TriggerPrompt(actionText)
    if not hrp then return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt")
        and obj.Enabled
        and obj.ActionText == actionText then

            local part = obj.Parent
            if part and part:IsA("BasePart") then
                if (part.Position - hrp.Position).Magnitude <= 100 then
                    pcall(function()
                        fireproximityprompt(obj)
                    end)
                end
            end
        end
    end
end

local HatchToggle = Egg:Toggle({
    Title = "Auto Hatch Eggs",
    Desc = "Automatically hatch eggs when available.",
    Value = false,
    Callback = function(state)
        autoHatch = state

        if state then
            task.spawn(function()
                while autoHatch do
                    TriggerPrompt("Hatch")
                    task.wait(0.5)
                end
            end)
        end

        myConfig:Save()
    end
})

myConfig:Register("autoHatch", HatchToggle)

local PlaceEggToggle = Egg:Toggle({
    Title = "Auto Place Eggs",
    Desc = "Automatically place eggs in available slots.",
    Value = false,
    Callback = function(state)
        autoPlaceEggs = state

        if state then
            task.spawn(function()
                while autoPlaceEggs do
                    TriggerPrompt("Place")
                    task.wait(0.5)
                end
            end)
        end

        myConfig:Save()
    end
})

myConfig:Register("autoPlaceEggs", PlaceEggToggle)

Egg:Section({ Title = "Action Pet", Icon = "bone" })

local PickEggToggle = Egg:Toggle({
    Title = "Auto Pickup Pet (Need equip hammer)",
    Desc = "Automatically pickup pet in available slots.",
    Value = false,
    Callback = function(state)
        autopickEggs = state

        if state then
            task.spawn(function()
                while autopickEggs do
                    TriggerPrompt("Recall")
                    task.wait(0.5)
                end
            end)
        end

        myConfig:Save()
    end
})

myConfig:Register("autopickEggs", PickEggToggle)

-- ====================== EVENT ======================
Event:Section({ Title = "Event: Void", Icon = "atom" })

local QuestDropdown = Event:Dropdown({
    Title = "Select Void Quest",
    Desc = "Choose which quest to claim rewards from. Select 'All' to claim all quests.",
    Values = QuestList,
    Multi = false,
    Callback = function(value)
        SelectedQuest = value
        myConfig:Save()
    end
})
myConfig:Register("SelectedQuest", QuestDropdown)

local QuestToggle = Event:Toggle({
    Title = "Auto Claim Quest",
    Desc = "Automatically claim quest rewards on an interval.",
    Value = false,
    Callback = function(state)
        AutoDinoEnabled = state

        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")

                while AutoDinoEnabled do
                    task.wait(2.5 + math.random() * 0.5)

                    local ok, remote = pcall(function()
                        return ReplicatedStorage:WaitForChild("Remote", 5):WaitForChild("DinoEventRE", 5)
                    end)
                    if not ok or not remote then
                        task.wait(2)
                        continue
                    end

                    if SelectedQuest then
                        if SelectedQuest == "All" then
                            for i = 1, 20 do
                                pcall(function()
                                    remote:FireServer({ { event = "claimreward", id = "Task_" .. i } })
                                end)
                                task.wait(0.15 + math.random() * 0.2)
                            end
                        else
                            pcall(function()
                                remote:FireServer({ { event = "claimreward", id = SelectedQuest } })
                            end)
                        end
                    end
                end
            end)
        end

        myConfig:Save()
    end
})
myConfig:Register("AutoDinoEnabled", QuestToggle)

local CollectDinoToggle = Event:Toggle({
    Title = "Auto Collect Void Rewards",
    Desc = "Automatically collect event rewards on an interval.",
    Value = false,
    Callback = function(state)
        autoCollectDino = state

        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")

                while autoCollectDino do
                    task.wait(5 + math.random(0, 2))

                    local ok, remote = pcall(function()
                        return ReplicatedStorage:WaitForChild("Remote", 5):WaitForChild("DinoEventRE", 5)
                    end)
                    if not ok or not remote then
                        task.wait(3)
                        continue
                    end

                    pcall(function()
                        remote:FireServer({ { event = "onlinepack" } })
                    end)
                end
            end)
        end

        myConfig:Save()
    end
})
myConfig:Register("autoCollectDino", CollectDinoToggle)

-- ====================== INFO TAB ======================

Info = InfoTab

if not ui then ui = {} end
if not ui.Creator then ui.Creator = {} end

ui.Creator.Request = function(requestData)
    local HttpService = game:GetService("HttpService")
    
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
            Desc = "Refresh Discord server statistics.",
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
        print("Discord API Error:", result)
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

-- ====================== OWNER & SOCIAL INFO ======================

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

-- ====================== LOAD CONFIG ======================
pcall(function() myConfig:Load() end)
local loadedEggs=myConfig:Get("SelectedEggs")
if loadedEggs and type(loadedEggs)=="table" then
    for _,egg in ipairs(eggTypes) do buyEggList[egg]=false end
    for _,v in ipairs(loadedEggs) do buyEggList[v]=true end
end

Window:OnClose(function() myConfig:Save() end)
