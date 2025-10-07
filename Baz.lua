-- =========================
local version = "3.1.4"
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

-- ====================== WINDUI ======================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ====================== SERVICES ======================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- ====================== SETTINGS ======================
local SelectedCode = nil
local SelectedBait = nil
local SelectedFood = nil
local SelectedQuest = nil

local autoHatch = false
local AutoEquip = false
local AutoPotion = false
local AutoCollectEnabled = false
local autoCollectDino = false
local AutoBuyConveyor = false
local AutoDinoEnabled = false
local AutoBaitEnabled = false
local AutoFoodEnabled = false
local AutoFishEnabled = false
local AutoSpinEnabled = false
local AutoBuyEggEnabled = false

local SelectedPotions = {}
local QuestList = {"All"}
for i = 1, 20 do table.insert(QuestList, "Task_"..i) end
local BuyIndex = 1
local EquipIndex = 1
local SpinCounts = {1,3,10}
local SelectedCount = 1

local FoodList = {
    "Strawberry","Blueberry","Watermelon","Apple","Orange",
    "Corn","Banana","Grape","Pear","PineApple","Dargon Fruit",
    "Gold Mango","Bloodstone Cycad","Colossal Pinecone","Volt Ginkgo",
    "Deepsea Pearl Fruit","Durian"
}
local eggTypes = {
    "BasicEgg","RareEgg","SuperRareEgg","EpicEgg","LegendEgg","HyperEgg",
    "BowserEgg","VoidEgg","CornEgg","BoneDragonEgg","DemonEgg","PrismaticEgg",
    "DarkGoatyEgg","LionfishEgg","OctopusEgg","UltraEgg","UnicornEgg","UnicornProEgg",
    "AnglerfishEgg","RhinoRockEgg","SaberCubEgg","SeaweedEgg","SharkEgg","SnowbunnyEgg",
    "GeneralKongEgg","SailfishEgg","SeaDragonEgg","PegasusEgg","ClownfishEgg","AncientEgg",
    "DinoEgg","FlyEgg","OceanEgg"
}
local PotionList = {"Potion_Coin","Potion_Luck","Potion_Hatch","Potion_3in1"}
local BaitList = { "FishingBait1", "FishingBait2", "FishingBait3" }
local CodeList = {
    "CFJXEH4M8K5","DelayGift","60KCCU919","50KCCU0912","SeasonOne",
    "ZooFish829","FIXERROR819","MagicFruit","WeekendEvent89","BugFixes",
    "U2CA518SC5","X2CA821BA3","55PA21N8y2"
}

-- ====================== WINDUI WINDOW ======================
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
    User = {Enabled=true, Anonymous=false},
})

pcall(function()
    Window:Tag({Title=version, Color=Color3.fromHex("#30ff6a")})
end)

Window:EditOpenButton({
    Title="DYHUB - Open",
    Icon="monitor",
    CornerRadius=UDim.new(0,6),
    StrokeThickness=2,
    Color=ColorSequence.new(Color3.fromRGB(30,30,30), Color3.fromRGB(255,255,255)),
    Draggable=true,
})

-- ====================== TABS ====================== 

local InfoTab = Window:Tab({Title="Information", Icon="info"}) 

local MainDivider = Window:Divider() 

local Main = Window:Tab({Title="Main", Icon="rocket"}) 
local Auto = Window:Tab({Title="Shop", Icon="shopping-cart"}) 
local Egg = Window:Tab({Title="Egg", Icon="egg"}) 

local Main1Divider = Window:Divider() 

local Event = Window:Tab({Title="Event", Icon="party-popper"}) 
local Buff = Window:Tab({Title="Buff", Icon="biceps-flexed"}) 
local Codes = Window:Tab({Title="Codes", Icon="gift"}) 

Window:SelectTab(1)

-- ====================== CONFIG MANAGER ======================
local ConfigManager = Window.ConfigManager
ConfigManager:Init(Window)  -- ต้อง init ก่อนใช้งาน
local myConfig = ConfigManager:CreateConfig("DYHUB_BAZ_Config")

-- ====================== AUTO FARM / AUTO BUY ======================
Auto:Section({ Title = "Buy Conveyor", Icon = "package" })

local BuyConveyorDropdown = Auto:Dropdown({
    Title = "Select Conveyor to Buy (Common-Celestial)",
    Values = {"1","2","3","4","5","6","7","8","9"},
    Multi = false,
    Callback = function(value)
        BuyIndex = tonumber(value)
        myConfig:Set("BuyIndex", BuyIndex)
        myConfig:Save()
    end
})
myConfig:Register("BuyIndex", BuyConveyorDropdown)

local BuyConveyorToggle = Auto:Toggle({
    Title = "Buy Conveyor",
    Value = false,
    Callback = function(state)
        AutoBuyConveyor = state
        myConfig:Set("AutoBuyConveyor", state)
        myConfig:Save()
        if state then
            task.spawn(function()
                while AutoBuyConveyor do
                    local args = {"Upgrade", BuyIndex}
                    ReplicatedStorage.Remote.ConveyorRE:FireServer(unpack(args))
                    task.wait(2)
                end
            end)
        end
    end
})
myConfig:Register("AutoBuyConveyor", BuyConveyorToggle)

-- Equip Conveyor
Auto:Section({ Title = "Equip Conveyor", Icon = "layout-grid" })

local EquipConveyorDropdown = Auto:Dropdown({
    Title = "Select Conveyor to Equip (Common-Celestial)",
    Values = {"1","2","3","4","5","6","7","8","9"},
    Multi = false,
    Callback = function(value)
        EquipIndex = tonumber(value)
        myConfig:Set("EquipIndex", EquipIndex)
        myConfig:Save()
    end
})
myConfig:Register("EquipIndex", EquipConveyorDropdown)

local EquipConveyorToggle = Auto:Toggle({
    Title = "Equip Conveyor",
    Value = false,
    Callback = function(state)
        AutoEquip = state
        myConfig:Set("AutoEquip", state)
        myConfig:Save()
        if state then
            task.spawn(function()
                while AutoEquip do
                    local args = {"Switch", EquipIndex}
                    ReplicatedStorage.Remote.ConveyorRE:FireServer(unpack(args))
                    task.wait(1.5)
                end
            end)
        end
    end
})
myConfig:Register("AutoEquip", EquipConveyorToggle)

-- Auto Potions
Buff:Section({ Title = "Potion", Icon = "flask-conical" })

local PotionDropdown = Buff:Dropdown({
    Title = "Select Potion(s)",
    Values = PotionList,
    Multi = true,
    Callback = function(values)
        SelectedPotions = values
        myConfig:Set("SelectedPotions", SelectedPotions)
        myConfig:Save()
    end
})
myConfig:Register("SelectedPotions", PotionDropdown)

local AutoPotionToggle = Buff:Toggle({
    Title = "Auto Use Selected Potions",
    Value = false,
    Callback = function(state)
        AutoPotion = state
        myConfig:Set("AutoPotion", state)
        myConfig:Save()
        if state then
            task.spawn(function()
                while AutoPotion do
                    for _,potion in pairs(SelectedPotions) do
                        local args = {"UsePotion", potion}
                        ReplicatedStorage.Remote.ShopRE:FireServer(unpack(args))
                        task.wait(1)
                    end
                    task.wait(5)
                end
            end)
        end
    end
})
myConfig:Register("AutoPotion", AutoPotionToggle)

-- Auto Buy Eggs
Egg:Section({ Title = "Buy Eggs", Icon = "egg" })

local buyEggList = {}
for _, egg in ipairs(eggTypes) do buyEggList[egg] = false end

local EggDropdown = Egg:Dropdown({
    Title = "Select Eggs",
    Values = eggTypes,
    Multi = true,
    Callback = function(values)
        for _, egg in ipairs(eggTypes) do buyEggList[egg] = false end
        for _, v in ipairs(values) do buyEggList[v] = true end
        myConfig:Set("BuyEggList", buyEggList)
        myConfig:Save()
    end
})
myConfig:Register("BuyEggList", EggDropdown)

local AutoBuyEggToggle = Egg:Toggle({
    Title = "Auto Buy Eggs",
    Value = false,
    Callback = function(state)
        AutoBuyEggEnabled = state
        myConfig:Set("AutoBuyEggEnabled", state)
        myConfig:Save()
        if state then
            spawn(function()
                while AutoBuyEggEnabled do
                    task.wait(0.15 + math.random(0, 300)/1000)
                    -- loop buy egg logic (เหมือนเดิม)
                end
            end)
        end
    end
})
myConfig:Register("AutoBuyEggEnabled", AutoBuyEggToggle)

-- Auto Hatch
local AutoHatchToggle = Egg:Toggle({
    Title = "Auto Hatch Eggs",
    Value = false,
    Callback = function(state)
        autoHatch = state
        myConfig:Set("autoHatch", state)
        myConfig:Save()
        if state then
            spawn(function()
                while autoHatch do
                    task.wait(0.5)
                    -- loop hatch egg logic (เหมือนเดิม)
                end
            end)
        end
    end
})
myConfig:Register("autoHatch", AutoHatchToggle)

-- Auto Collect Coin
Main:Section({ Title = "Collect Coin", Icon = "egg" })

local AutoCollectToggle = Main:Toggle({
    Title = "Auto Collect Coin",
    Value = false,
    Callback = function(state)
        AutoCollectEnabled = state
        myConfig:Set("AutoCollectEnabled", state)
        myConfig:Save()
        if state then
            spawn(function()
                while AutoCollectEnabled do
                    local petsFolder = workspace:WaitForChild("Pets")
                    local args = {"Claim"}
                    for _, pet in pairs(petsFolder:GetChildren()) do
                        if pet:FindFirstChild("RootPart") and pet.RootPart:FindFirstChild("RE") then
                            pcall(function()
                                pet.RootPart.RE:FireServer(unpack(args))
                            end)
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
    end
})
myConfig:Register("AutoCollectEnabled", AutoCollectToggle)

-- ====================== LOAD CONFIG ======================
myConfig:Load()  -- โหลดค่าที่บันทึกไว้ก่อนหน้านี้

-- ====================== ON CLOSE SAVE ======================
Window:OnClose(function()
    myConfig:Save()
end)

-- ======================= INFORMATION ========================
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
