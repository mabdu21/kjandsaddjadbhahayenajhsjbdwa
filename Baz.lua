-- =========================
local version = "3.5.9"
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
local AutoCollectEnabled_Coin = false
local autoCollectDino = false
local AutoBuyConveyor = false
local AutoDinoEnabled = false
local AutoBaitEnabled = false
local AutoFoodEnabled = false
local AutoFishEnabled = false
local AutoSpinEnabled = false
local AutoSpinEnabled2 = false
local AutoSpinEnabled3 = false
local AutoBuyEggEnabled = false

local SelectedPotions = {}
local QuestList = {"All"}
for i = 1, 20 do table.insert(QuestList, "Task_"..i) end

local BuyIndex, EquipIndex, SelectedCount = 1, 1, 1
local SpinCounts = {1,3,10}

local FoodList = {"Strawberry","Blueberry","Watermelon","Apple","Orange","Corn","Banana","Grape","Pear","PineApple","Dargon Fruit","Gold Mango","Bloodstone Cycad","Colossal Pinecone","Volt Ginkgo","Deepsea Pearl Fruit","Durian"}
local eggTypes = {"BasicEgg","RareEgg","SuperRareEgg","EpicEgg","LegendEgg","HyperEgg","BowserEgg","VoidEgg","CornEgg","BoneDragonEgg","DemonEgg","PrismaticEgg","DarkGoatyEgg","LionfishEgg","OctopusEgg","UltraEgg","UnicornEgg","UnicornProEgg","AnglerfishEgg","RhinoRockEgg","SaberCubEgg","SeaweedEgg","SharkEgg","SnowbunnyEgg","GeneralKongEgg","SailfishEgg","SeaDragonEgg","PegasusEgg","ClownfishEgg","AncientEgg","DinoEgg","FlyEgg","OceanEgg","MetroGiraffeEgg","GodzillaEgg","CapyEgg","HalloweenEgg"}
local PotionList = {"Potion_Coin","Potion_Luck","Potion_Hatch","Potion_3in1"}
local BaitList = {"FishingBait1","FishingBait2","FishingBait3"}
local CodeList = {"CFJXEH4M8K5","DelayGift","60KCCU919","50KCCU0912","SeasonOne","ZooFish829","FIXERROR819","MagicFruit","WeekendEvent89","BugFixes","U2CA518SC5","X2CA821BA3","55PA21N8y2"}

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
local Auto = Window:Tab({Title="Shop", Icon="shopping-cart"})
local Egg = Window:Tab({Title="Egg", Icon="egg"})
local Event = Window:Tab({Title="Event", Icon="party-popper"})
local Buff = Window:Tab({Title="Buff", Icon="biceps-flexed"})
local Codes = Window:Tab({Title="Codes", Icon="gift"})
Window:SelectTab(1)

-- ====================== CONFIG MANAGER ======================
local ConfigManager = Window.ConfigManager
ConfigManager:Init(Window)
local myConfig = ConfigManager:CreateConfig("dyhub_settings")

-- ====================== AUTO BUY & EQUIP ======================
-- Buy Conveyor
Auto:Section({Title="Buy Conveyor", Icon="package"})
local BuyConveyorDropdown = Auto:Dropdown({Title="Select Conveyor to Buy (1-9)", Values={"1","2","3","4","5","6","7","8","9","10"}, Multi=false, Callback=function(value) BuyIndex=tonumber(value); myConfig:Save() end})
myConfig:Register("BuyIndex", BuyConveyorDropdown)
local BuyConveyorToggle = Auto:Toggle({Title="Buy Conveyor", Value=false, Callback=function(state) AutoBuyConveyor=state
    if state then task.spawn(function()
        while AutoBuyConveyor do
            local args={"Upgrade",BuyIndex}
            ReplicatedStorage.Remote.ConveyorRE:FireServer(unpack(args))
            task.wait(2)
        end
    end) end
    myConfig:Save()
end})
myConfig:Register("AutoBuyConveyor", BuyConveyorToggle)

-- Equip Conveyor
Auto:Section({Title="Equip Conveyor", Icon="layout-grid"})
local EquipConveyorDropdown = Auto:Dropdown({Title="Select Conveyor to Equip (1-9)", Values={"1","2","3","4","5","6","7","8","9","10"}, Multi=false, Callback=function(value) EquipIndex=tonumber(value); myConfig:Save() end})
myConfig:Register("EquipIndex", EquipConveyorDropdown)
local EquipConveyorToggle = Auto:Toggle({Title="Equip Conveyor", Value=false, Callback=function(state) AutoEquip=state
    if state then task.spawn(function()
        while AutoEquip do
            local args={"Switch",EquipIndex}
            ReplicatedStorage.Remote.ConveyorRE:FireServer(unpack(args))
            task.wait(1.5)
        end
    end) end
    myConfig:Save()
end})
myConfig:Register("AutoEquip", EquipConveyorToggle)

-- ====================== POTIONS ======================
Buff:Section({Title="Potion", Icon="flask-conical"})
local PotionDropdown = Buff:Dropdown({Title="Select Potion(s)", Values=PotionList, Multi=true, Callback=function(values) SelectedPotions=values; myConfig:Save() end})
myConfig:Register("SelectedPotions", PotionDropdown)
local PotionToggle = Buff:Toggle({Title="Auto Use Selected Potions", Value=false, Callback=function(state) AutoPotion=state
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
end})
myConfig:Register("AutoPotion", PotionToggle)

-- ====================== AUTO BAIT & FOOD ======================
Auto:Section({Title="Buy Bait", Icon="fish"})
local BaitDropdown = Auto:Dropdown({Title="Select Bait", Values=BaitList, Multi=false, Callback=function(value) SelectedBait=value; myConfig:Save() end})
myConfig:Register("SelectedBait", BaitDropdown)
local BaitToggle = Auto:Toggle({Title="Buy Bait", Value=false, Callback=function(state) AutoBaitEnabled=state
    task.spawn(function() while AutoBaitEnabled do if SelectedBait then ReplicatedStorage.Remote.FishingRE:FireServer("buy",SelectedBait) end; task.wait(0.5) end end)
    myConfig:Save()
end})
myConfig:Register("AutoBaitEnabled", BaitToggle)

Auto:Section({Title="Buy Food", Icon="shopping-bag"})
local FoodDropdown = Auto:Dropdown({Title="Select Food", Values=FoodList, Multi=false, Callback=function(value) SelectedFood=value; myConfig:Save() end})
myConfig:Register("SelectedFood", FoodDropdown)
local FoodToggle = Auto:Toggle({Title="Buy Food", Value=false, Callback=function(state) AutoFoodEnabled=state
    task.spawn(function() while AutoFoodEnabled do if SelectedFood then ReplicatedStorage.Remote.FoodStoreRE:FireServer(SelectedFood) end; task.wait(0.5) end end)
    myConfig:Save()
end})
myConfig:Register("AutoFoodEnabled", FoodToggle)

-- =========================
-- 🪙 Auto Teleport to Closest Pet v4.0
-- =========================

Main:Section({ Title = "Collect Coin", Icon = "egg" })

local function getClosestPet()
    local petsFolder = workspace:FindFirstChild("Pets")
    if not petsFolder then return nil end

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart", 3)
    if not root then return nil end

    local closestPet = nil
    local shortestDistance = math.huge

    for _, pet in ipairs(petsFolder:GetChildren()) do
        local petRoot = pet:FindFirstChild("RootPart")
        if petRoot then
            local distance = (root.Position - petRoot.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPet = pet
            end
        end
    end

    return closestPet
end

local CollectCoinToggle = Main:Toggle({
    Title = "Auto Collect (Under Fixing)",
    Value = false,
    Callback = function(state)
        AutoCollectEnabled_Coin = state

        if state then
            task.spawn(function()
                local player = game.Players.LocalPlayer
                local ReplicatedStorage = game:GetService("ReplicatedStorage")

                while AutoCollectEnabled_Coin do
                    task.wait(0.25)

                    local character = player.Character or player.CharacterAdded:Wait()
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if not root then continue end

                    -- 🔍 หาสัตว์เลี้ยงที่ใกล้ที่สุด
                    local closestPet = getClosestPet()
                    if not closestPet then
                        warn("[Auto Collect] ❌ ไม่พบสัตว์เลี้ยงใกล้ตัว")
                        task.wait(1)
                        continue
                    end

                    local petRoot = closestPet:FindFirstChild("RootPart")
                    if petRoot then
                        -- 🏃‍♂️ วาร์ปตัวผู้เล่นไปหาสัตว์เลี้ยงที่ใกล้ที่สุด
                        root.CFrame = petRoot.CFrame + Vector3.new(0, 3, 0) -- เพิ่มระยะขึ้นนิดหน่อยกันชน
                        print("[Auto Collect] 🪙 วาร์ปไปหาสัตว์:", closestPet.Name)

                        -- 🔁 พยายามเก็บเหรียญของสัตว์นั้นถ้ามี RE
                        local re = petRoot:FindFirstChild("RE")
                        if re then
                            pcall(function()
                                re:FireServer("Claim")
                            end)
                        end
                    end
                end
            end)
        end

        myConfig:Save()
    end
})

myConfig:Register("AutoCollectEnabled_Coin", CollectCoinToggle)

-- ====================== AUTO FISH ======================
Main:Section({Title="Fishing", Icon="fish"})
local FishToggle = Main:Toggle({Title="Auto Reel", Value=false, Callback=function(state)
    AutoFishEnabled=state
    task.spawn(function() while AutoFishEnabled do ReplicatedStorage.Remote.FishingRE:FireServer({"POUT",{SUC=1}}); task.wait(0.5) end end)
    myConfig:Save()
end})
myConfig:Register("AutoFishEnabled", FishToggle)

-- ====================== AUTO SPIN ======================
-- 🎰 Toggle Auto Spin
Main:Section({Title="Spin: Ticket", Icon="ticket"})

local SpinToggle = Main:Toggle({
    Title = "Auto Spin Lottery (x1)",
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

Main:Button({
    Title = "Dupe Money (Beta)",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        -- 🔍 ตรวจสอบว่า GUI มีอยู่จริง
        local success, Event = pcall(function()
            return LocalPlayer.PlayerGui
                .ScreenSeasonPass
                .Root
                .FrameLotteryReward
                .Event
        end)

        if success and Event then
            pcall(function()
                Event:Fire(
                    "Coin",
                    9000000000,
                    "rbxassetid://87534904975459"
                )
            end)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "💰 Dupe Money",
                Text = "Successfully sent event (Beta)",
                Duration = 2
            })
        else
            warn("[Dupe Money] ❌ ไม่พบ Event ใน GUI")
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "💰 Dupe Money",
                Text = "Event not found!",
                Duration = 2
            })
        end
    end
})

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

-- =========================
-- 📦 Auto Buy Eggs
-- =========================

local BuyEggDropdown = Egg:Dropdown({
    Title = "Select Eggs",
    Values = eggTypes,
    Multi = true,
    Callback = function(values)
        for _, egg in ipairs(eggTypes) do
            buyEggList[egg] = false
        end
        for _, v in ipairs(values) do
            buyEggList[v] = true
        end
        myConfig:Save()
    end
})

myConfig:Register("SelectedEggs", BuyEggDropdown)

local BuyEggToggle = Egg:Toggle({
    Title = "Auto Buy Eggs",
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

-- =========================
-- 🐣 Auto Hatch Eggs
-- =========================

Egg:Section({ Title = "Hatch Eggs", Icon = "clock" })

local HatchToggle = Egg:Toggle({
    Title = "Auto Hatch Eggs",
    Value = false,
    Callback = function(state)
        autoHatch = state
        if state then
            task.spawn(function()
                while autoHatch do
                    task.wait(0.4)
                    local art = workspace:FindFirstChild("Art")
                    if not art then
                        task.wait(1)
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

                            for _, eggModel in ipairs(belt:GetChildren()) do
                                local root = eggModel:FindFirstChild("RootPart")
                                local rf = root and root:FindFirstChild("RF")
                                if rf and rf:IsA("RemoteFunction") then
                                    pcall(function()
                                        rf:InvokeServer("Hatch")
                                    end)
                                    task.wait(0.1)
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
myConfig:Register("autoHatch", HatchToggle)

-- ====================== EVENT ======================
-- =========================
-- 🎃 Event: Halloween v3.2
-- =========================

Event:Section({ Title = "Event: Halloween", Icon = "candy" })

-- 🎯 Select Quest
local QuestDropdown = Event:Dropdown({
    Title = "Select Halloween Quest",
    Values = QuestList,
    Multi = false,
    Callback = function(value)
        SelectedQuest = value
        myConfig:Save()
    end
})
myConfig:Register("SelectedQuest", QuestDropdown)

-- =========================
-- 👻 Auto Claim Halloween Quest
-- =========================
local QuestToggle = Event:Toggle({
    Title = "Auto Claim Halloween Quest",
    Value = false,
    Callback = function(state)
        AutoDinoEnabled = state

        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")

                while AutoDinoEnabled do
                    task.wait(2.5 + math.random() * 0.5) -- ปรับ delay เล็กน้อยให้ดูเหมือนผู้เล่นจริง

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

-- =========================
-- 🍬 Auto Collect Halloween Rewards
-- =========================
local CollectDinoToggle = Event:Toggle({
    Title = "Auto Collect Halloween Rewards",
    Value = false,
    Callback = function(state)
        autoCollectDino = state

        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")

                while autoCollectDino do
                    task.wait(5 + math.random(0, 2)) -- ปรับช่วงเวลาให้ปลอดภัยจากการ spam

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

-- =============================================

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

-- ====================== LOAD CONFIG ======================
pcall(function() myConfig:Load() end)
local loadedEggs=myConfig:Get("SelectedEggs")
if loadedEggs and type(loadedEggs)=="table" then
    for _,egg in ipairs(eggTypes) do buyEggList[egg]=false end
    for _,v in ipairs(loadedEggs) do buyEggList[v]=true end
end

Window:OnClose(function() myConfig:Save() end)
