-- v61

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

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- GitHub repository URLs
local REPO_BASE = "https://raw.githubusercontent.com/Baolong12355/AUT/main/"

-- Scripts URLs
local SCRIPTS = {
    autosave = REPO_BASE .. "autosave.lua",
    sell = REPO_BASE .. "sell.lua",
    trait = REPO_BASE .. "trait.lua",
    stats = REPO_BASE .. "stats.lua",
    statsreset = REPO_BASE .. "statsreset.lua",  -- Script mới
    slayer = REPO_BASE .. "slayer.lua",
    rollbanner = REPO_BASE .. "rollbanner.lua",
    loot = REPO_BASE .. "loot.lua",
    feed = REPO_BASE .. "feed.lua",
    crate = REPO_BASE .. "crate.lua",
    combat = REPO_BASE .. "combat.lua",
    asc = REPO_BASE .. "asc.lua",
    specialgrade = REPO_BASE .. "SpecialGradeQuest.lua",
    speciallevelfarm = REPO_BASE .. "SpecialLevelFarm.lua", 
    oneshot = REPO_BASE .. "oneshot.lua",
    autohaki = REPO_BASE .. "autohaki.lua",
    standstate = REPO_BASE .. "autostandonoff.lua"
}

-- Item list dùng trực tiếp (không lấy từ link)
_G.AvailableItems = {
    "Mining Laser", "Phoenix Gemstone", "Jonathan's Signal", "Coal Loot", "Medic's Equipment",
    "A New Fable", "Cursed Orb", "Blood of Joseph", "The Total Force Of Calamity", "Spin Energy Fragment",
    "Umbra's Calamity Force", "Inverted Spear of Heaven", "Light of Hope", "Arrow", "Chest Key",
    "Bone", "Heart", "Shaper's Essence", "Ban Hammer", "Chargin' Targe", "Yo-Yo",
    "Mysterious Fragment", "Shanks' Calamity Force", "Clackers", "Joestar Blood Vial",
    "Heavenly Restriction Awakening", "Knife", "Claw Fragment", "Gojo's Blindfold", "Stocking",
    "Sorcerer's Scarf", "Green Baby", "Busoshoku Manual", "Azakana Mask", "Sovereign's Sword",
    "West Blue Juice", "Heart of the Saint", "Paintball Gun", "Candy Bag", "Camellite",
    "Nanotech Fragments", "Limitless Technique Scroll", "Sukuna's Calamity Force", "Requiem Arrow",
    "Dio's Charm", "Superball", "Death Painting", "Candy Cutlass Blade", "Demonic Scroll",
    "Dragon Ball", "NUCLEAR-CORE", "Watch", "Kuma's Book", "Saints Skull", "Vampirism Mastery",
    "Stone Mask", "Saints Arms", "Soul Gemstone", "Sorcerer Killer Shard", "Saints Eyes",
    "Corrupted Arrow", "Mero Devil Fruit", "Dragon Slayer", "Remembrance of the Sorcerer Killer",
    "Split Soul Katana", "Refined Camellite", "Golden Hook", "Rocket Launcher",
    "Remembrance of the Fallen", "Anshen's Leg Plates", "Tales Of The Universe", "Caesar's Headband",
    "DIO's Bone", "Mahoraga's Calamity Force", "Flamethrower", "Evil Fragments", "Worn Out Scarf",
    "Strange Briefcase", "Bomb", "Anshen's Lance", "Joseph's Signal", "Anshen's Arm Plates",
    "Cultist Staff", "Camellite Arrow", "SHAPER // SWORD", "Cosmic Remnant", "The Vessel Shard",
    "Kars' Calamity Force", "Calibrated Manifold", "STAR SEED", "Harmonic Decoder", "Sukuna's Finger",
    "Heavenly Nectar", "Dormant Staff", "Dormant Dagger", "Hito Devil Fruit", "Cosmic Fragments",
    "Meat On A Bone", "Fractured Sigil", "Geode", "Keycard", "The Denzien Of Hell's Calamity Force",
    "Bait Vampire Mask", "Camellite Fragment", "Mining Laser MK2", "Catalyst", "Crystalline Core",
    "Inhumane Spirit", "Shadow's Calamity Force", "Whitebeard's Calamity Force", "Locacaca",
    "Fragment of Death", "Ancient Sword", "Metal Loot", "Anshen's Suit", "DIO's Diary",
    "King of Curses Shard", "Mysterious Hat", "Slingshot", "Sovereign's Chapter", "Cultist Dagger",
    "Remembrance of the Strongest", "Anshen's Helmet", "Draconic Gemstone", "Cursed Arm",
    "Metal Ingot", "Gun Parts", "Metal Scraps", "Bisento", "Bouquet Of Flowers", "Eyelander",
    "Cursed Gemstone", "Letter to Jonathan", "Aja Stone", "Hamon Imbued Frog", "Altered Steel Ball",
    "Manual of Gryphon's Techniques", "Cursed Apple", "Shrine Item", "Godly Doctor's Poison",
    "Anshen's Chestplate", "Simple Domain Essence", "Slime Energy", "Anshen's Wing Set",
    "Haki Shard", "Remembrance of the Vessel", "Kenbunshoku Manual", "Monochromatic Gemstone",
    "Arm Band", "Bat", "Haoshoku Manual", "Wheel of Dharma", "Playful Cloud", "Knight's Blade",
    "Pumpkin", "Coal", "Saints Legs", "Rundown Mask", "Corrupted Soul", "Kinetic Orb",
    "Letter to Joseph", "Saints Ribcage", "Jonathan's Worn Out Gloves", "Sword", "Gomu Devil Fruit",
    "Kinetic Gemstone", "True Stone Mask", "Baroque Works Contractor Den Den", "Sanji's Cookbook",
    "Ope Devil Fruit", "Grenade Launcher", "Dio's Remains", "Suna Devil Fruit", "Used Arrow",
    "Tactical Vest", "Law's Cap", "Frog", "Trowel", "Saint's Corpse", "Monochromatic Orb"
}

_G.LoadedScripts = {}

-- Default values
_G.AutoSaveSelectedItems = {}
_G.AutoSellExcludeList = {}
_G.CombatSelectedSkills = {""}

-- Load script from GitHub
local function loadScript(name, url)
    if _G.LoadedScripts[name] then return true end

    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        _G.LoadedScripts[name] = true
        return true
    end
    return false
end

-- Create main GUI
local Window = Rayfield:CreateWindow({
    Name = "DYHUB | A Universal Time",
    Icon = 104487529937663,
    LoadingTitle = "DYHUB Loaded! - AUT",
    LoadingSubtitle = "by DYHUB",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DYHUB_AUT",
        FileName = "Config"
    },
    Theme = "Dark Blue",
    ToggleUIKeybind = "K"
})

-- Create tabs
local MainTab = Window:CreateTab("Main", "home")
local CombatTab = Window:CreateTab("Combat", "sword")
local ItemTab = Window:CreateTab("Items", "package")
local QuestTab = Window:CreateTab("Quest", "map")
local TraitTab = Window:CreateTab("Trait & Stats", "star")
local SettingsTab = Window:CreateTab("Settings", "settings")

-- === MAIN TAB ===
MainTab:CreateSection("Load Asset for Some Feature")

local LoadAllButton = MainTab:CreateButton({
    Name = "Load All Asset",
    Callback = function()
        local loaded = 0
        local total = 0
        for name, url in pairs(SCRIPTS) do
            total = total + 1
            if loadScript(name, url) then
                loaded = loaded + 1
            end
        end
        Rayfield:Notify({
            Title = "Completed",
            Content = "Loaded " .. loaded .. "/" .. total .. " Asset",
            Duration = 3,
            Image = "download"
        })
    end
})

-- === COMBAT TAB ===
CombatTab:CreateSection("Auto Combat")

local CombatToggle = CombatTab:CreateToggle({
    Name = "Auto Combat",
    CurrentValue = false,
    Flag = "CombatEnabled",
    Callback = function(Value)
        _G.CombatEnabled = Value
        if Value and not _G.LoadedScripts.combat then
            loadScript("combat", SCRIPTS.combat)
        end
        if _G.ResetCombatTarget then
            _G.ResetCombatTarget()
        end
    end
})

local CombatTypeDropdown = CombatTab:CreateDropdown({
    Name = "Monster Type",
    Options = {"cultists", "cursed", "hooligans", "prisoners", "thugs", "pirates", "guardian"},
    CurrentOption = {"cultists"},
    Flag = "CombatType",
    Callback = function(Options)
        _G.CombatTargetType = Options[1]
        if _G.ResetCombatTarget then
            _G.ResetCombatTarget()
        end
    end
})

local EscapeHeightSlider = CombatTab:CreateSlider({
    Name = "Anti Hit (Studs)",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 30,
    Flag = "EscapeHeight",
    Callback = function(Value)
        _G.CombatEscapeHeight = Value
    end
})

CombatTab:CreateSection("Combat Skills")

local availableSkills = {
    "B", "Q", "E", "R", "T", "Y", "U", "F", "G", "H", "Z", "X", "C", "V",
    "B+", "Q+", "E+", "R+", "T+", "Y+", "U+", "F+", "G+", "H+", "Z+", "X+", "C+", "V+",
    "MOUSEBUTTON2"
}

local CombatSkillsDropdown = CombatTab:CreateDropdown({
    Name = "Select Skills Combat",
    Options = availableSkills,
    CurrentOption = {"B"},
    MultipleOptions = true,
    Flag = "CombatSkills",
    Callback = function(Options)
        _G.CombatSelectedSkills = Options
    end
})

CombatTab:CreateParagraph({
    Title = "Skills Guide",
    Content = "• Normal skills: B, Q, E, R...\n• Advanced skills: B+, Q+, E+, R+...\n• M2: MOUSEBUTTON2\n• Can select multiple skills at the same time"
})

CombatTab:CreateSection("Auto Stand")

local StandAutoToggle = CombatTab:CreateToggle({
    Name = "Auto Stand (On/Off)",
    CurrentValue = getgenv().AutoStandEnabled or false,
    Flag = "AutoStandEnabled",
    Callback = function(Value)
        getgenv().AutoStandEnabled = Value
        if not Value then
            getgenv().AutoStandState = nil
        else
            if getgenv().AutoStandState ~= "on" and getgenv().AutoStandState ~= "off" then
                getgenv().AutoStandState = "on"
            end
            if not _G.LoadedScripts.standstate then
                loadScript("standstate", SCRIPTS.standstate)
            end
        end
    end
})

local StandStateDropdown = CombatTab:CreateDropdown({
    Name = "Stand Mode",
    Options = {"on", "off"},
    CurrentOption = {"on"},
    Flag = "StandStateMode",
    Callback = function(Options)
        local mode = Options[1]
        if mode == "on" or mode == "off" then
            getgenv().AutoStandState = mode
            if getgenv().AutoStandEnabled and not _G.LoadedScripts.standstate then
                loadScript("standstate", SCRIPTS.standstate)
            end
        else
            getgenv().AutoStandState = nil
        end
    end
})

local SlayerQuestToggle = CombatTab:CreateToggle({
    Name = "Prioritize Slayer Boss",
    CurrentValue = false,
    Flag = "SlayerPriority",
    Callback = function(Value)
        _G.SlayerQuestActive = Value
    end
})

CombatTab:CreateSection("Auto One Shot")

local OneShotSlider = CombatTab:CreateSlider({
    Name = "Threshold HP One Shot (%)",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = 50,
    Flag = "OneShotHPThreshold",
    Callback = function(Value)
        getgenv().AutoOneShotHPThreshold = Value
    end
})

local OneShotToggle = CombatTab:CreateToggle({
    Name = "Auto One Shot (HP below the threshold)",
    CurrentValue = false,
    Flag = "OneShotEnabled",
    Callback = function(Value)
        getgenv().AutoOneShotting = Value
        if Value and not _G.LoadedScripts.oneshot then
            loadScript("oneshot", SCRIPTS.oneshot)
        end
    end
})

local HakiToggle = CombatTab:CreateToggle({
    Name = "Auto Busoshoku Haki",
    CurrentValue = false,
    Flag = "AutoHakiEnabled",
    Callback = function(Value)
        getgenv().AutoHakiEnabled = Value
        if Value and not _G.LoadedScripts.autohaki then
            loadScript("autohaki", SCRIPTS.autohaki)
        end
    end
})

-- === ITEM TAB ===
ItemTab:CreateSection("Auto Save Item")

local AutoSaveToggle = ItemTab:CreateToggle({
    Name = "Auto Save Item",
    CurrentValue = false,
    Flag = "AutoSaveEnabled",
    Callback = function(Value)
        _G.AutoSaveEnabled = Value
        if Value and not _G.LoadedScripts.autosave then
            loadScript("autosave", SCRIPTS.autosave)
        end
    end
})

local AutoSaveItemsDropdown = ItemTab:CreateDropdown({
    Name = "Select Items Needed Save",
    Options = _G.AvailableItems,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "AutoSaveItems",
    Callback = function(Options)
        _G.AutoSaveSelectedItems = Options
    end
})

local AutoSaveManualButton = ItemTab:CreateButton({
    Name = "Save Item Handmade",
    Callback = function()
        if not _G.LoadedScripts.autosave then
            loadScript("autosave", SCRIPTS.autosave)
        end
        if _G.TriggerAutoSave then
            _G.TriggerAutoSave()
        end
    end
})

ItemTab:CreateSection("Auto Sell")

local AutoSellToggle = ItemTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Flag = "AutoSellEnabled",
    Callback = function(Value)
        _G.AutoSellEnabled = Value
        if Value and not _G.LoadedScripts.sell then
            loadScript("sell", SCRIPTS.sell)
        end
    end
})

local AutoSellExcludeDropdown = ItemTab:CreateDropdown({
    Name = "Select Items NOT for Sale",
    Options = _G.AvailableItems,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "AutoSellExclude",
    Callback = function(Options)
        _G.AutoSellExcludeList = Options
    end
})

local SellDelaySlider = ItemTab:CreateSlider({
    Name = "Sell Delay (Sec)",
    Range = {5, 120},
    Increment = 5,
    CurrentValue = 30,
    Flag = "SellDelay",
    Callback = function(Value)
        _G.AutoSellDelay = Value
    end
})

ItemTab:CreateSection("Loot & Crate")

local LootToggle = ItemTab:CreateToggle({
    Name = "Auto Loot Chest",
    CurrentValue = false,
    Flag = "LootEnabled",
    Callback = function(Value)
        _G.LootEnabled = Value
        if Value and not _G.LoadedScripts.loot then
            loadScript("loot", SCRIPTS.loot)
        end
    end
})

local CrateToggle = ItemTab:CreateToggle({
    Name = "Auto Crate Collector",
    CurrentValue = false,
    Flag = "CrateEnabled",
    Callback = function(Value)
        _G.CrateCollectorEnabled = Value
        if Value and not _G.LoadedScripts.crate then
            loadScript("crate", SCRIPTS.crate)
        end
    end
})

local CrateDelaySlider = ItemTab:CreateSlider({
    Name = "Crate Check Delay",
    Range = {10, 300},
    Increment = 10,
    CurrentValue = 60,
    Flag = "CrateDelay",
    Callback = function(Value)
        _G.CrateLoopDelay = Value
    end
})

local CrateTPDelaySlider = ItemTab:CreateSlider({
    Name = "Crate TP Delay",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.1,
    Flag = "CrateTPDelay",
    Callback = function(Value)
        _G.CrateTPDelay = Value
    end
})

-- === QUEST TAB ===
QuestTab:CreateSection("Auto Quest")

local SlayerToggle = QuestTab:CreateToggle({
    Name = "Auto Slayer Quest",
    CurrentValue = false,
    Flag = "SlayerEnabled",
    Callback = function(Value)
        _G.SlayerQuestEnabled = Value
        if Value and not _G.LoadedScripts.slayer then
            loadScript("slayer", SCRIPTS.slayer)
        end
    end
})

local SlayerQuestDropdown = QuestTab:CreateDropdown({
    Name = "Slayer Quest Prioritize",
    Options = {"Finger Bearer", "Gojo", "Xeno", "Bur", "Dragon knight", "Oni"},
    CurrentOption = {"Finger Bearer"},
    MultipleOptions = true,
    Flag = "SlayerQuests",
    Callback = function(Options)
        _G.PreferredSlayerQuests = Options
    end
})

local SpecialGradeToggle = QuestTab:CreateToggle({
    Name = "Auto Special Grade Quest",
    CurrentValue = false,
    Flag = "SpecialGradeEnabled",
    Callback = function(Value)
        _G.SpecialGradeQuestEnabled = Value
        if Value and not _G.LoadedScripts.specialgrade then
            loadScript("specialgrade", SCRIPTS.specialgrade)
        end
    end
})

local SpecialGradeDelaySlider = QuestTab:CreateSlider({
    Name = "Special Grade Delay",
    Range = {30, 300},
    Increment = 30,
    CurrentValue = 60,
    Flag = "SpecialGradeDelay",
    Callback = function(Value)
        _G.SpecialGradeQuestDelay = Value
    end
})

-- === TRAIT & STATS TAB ===
TraitTab:CreateSection("Auto Trait")

local TraitToggle = TraitTab:CreateToggle({
    Name = "Auto Pick Trait",
    CurrentValue = false,
    Flag = "TraitEnabled",
    Callback = function(Value)
        _G.TraitAutoPickEnabled = Value
        if Value and not _G.LoadedScripts.trait then
            loadScript("trait", SCRIPTS.trait)
        end
        if _G.TriggerAutoPickTrait then
            _G.TriggerAutoPickTrait()
        end
    end
})

local LegendaryTraitsDropdown = TraitTab:CreateDropdown({
    Name = "Legendary Traits Prioritize",
    Options = {"Prime", "Angelic", "Solar", "Cursed", "Vampiric", "Gluttonous", "Voided", "Gambler", "Overflowing", "Deferred", "True", "Cultivation", "Economic", "Frostbite"},
    CurrentOption = {"Prime"},
    MultipleOptions = true,
    Flag = "LegendaryTraits",
    Callback = function(Options)
        _G.TraitList_Legendary = Options
    end
})

local LegendaryHexedTraitsDropdown = TraitTab:CreateDropdown({
    Name = "Legendary Hexed Traits",
    Options = {"Overconfident Prime", "Fallen Angelic", "Icarus Solar", "Undying Cursed", "Ancient Vampiric", "Festering Gluttonous", "Abyssal Voided", "Idle Death Gambler", "Torrential Overflowing", "Fractured Deferred", "Vitriolic True", "Soul Reaping Cultivation", "Greedy Economic"},
    CurrentOption = {"Overconfident Prime"},
    MultipleOptions = true,
    Flag = "LegendaryHexedTraits",
    Callback = function(Options)
        _G.TraitList_LegendaryHexed = Options
    end
})

local MythicTraitsDropdown = TraitTab:CreateDropdown({
    Name = "Mythic Traits Prioritize",
    Options = {"Godly", "Temporal", "RCT", "Spiritual", "Ryoiki", "Adaptation"},
    CurrentOption = {"Godly"},
    MultipleOptions = true,
    Flag = "MythicTraits",
    Callback = function(Options)
        _G.TraitList_Mythic = Options
    end
})

local MythicHexedTraitsDropdown = TraitTab:CreateDropdown({
    Name = "Mythic Hexed Traits",
    Options = {"Egotistic Godly", "FTL Temporal", "Automatic RCT", "Mastered Spiritual", "Overcharged Ryoiki", "Unbound Adaptation"},
    CurrentOption = {"Egotistic Godly"},
    MultipleOptions = true,
    Flag = "MythicHexedTraits",
    Callback = function(Options)
        _G.TraitList_MythicHexed = Options
    end
})

local TraitHistoryButton = TraitTab:CreateButton({
    Name = "View 5 Discarded Traits",
    Callback = function()
        if _G.TraitDiscardHistory and #_G.TraitDiscardHistory > 0 then
            local historyText = "Trait has been discarded:\n"
            for i, traits in ipairs(_G.TraitDiscardHistory) do
                historyText = historyText .. i .. ". " .. traits .. "\n"
            end
            Rayfield:Notify({
                Title = "Trait History",
                Content = historyText,
                Duration = 8
            })
        else
            Rayfield:Notify({
                Title = "No History",
                Content = "No traits discarded yet",
                Duration = 3
            })
        end
    end
})

TraitTab:CreateSection("Auto Stats")

local StatsToggle = TraitTab:CreateToggle({
    Name = "Auto Stats",
    CurrentValue = false,
    Flag = "StatsEnabled",
    Callback = function(Value)
        _G.AutoStatsEnabled = Value
        if Value and not _G.LoadedScripts.stats then
            loadScript("stats", SCRIPTS.stats)
        end
    end
})

local StatsTypeDropdown = TraitTab:CreateDropdown({
    Name = "Type Stats",
    Options = {"Attack", "Defense", "Health", "Special"},
    CurrentOption = {"Attack"},
    Flag = "StatsType",
    Callback = function(Options)
        _G.AutoStatsType = Options[1]
    end
})

local StatsAmountSlider = TraitTab:CreateSlider({
    Name = "Points Per Time",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = 1,
    Flag = "StatsAmount",
    Callback = function(Value)
        _G.AutoStatsAmount = Value
    end
})

-- Thêm phần Auto Stats Reset
TraitTab:CreateSection("Auto Stats Reset")

local StatsResetToggle = TraitTab:CreateToggle({
    Name = "Ucoin burner",
    CurrentValue = false,
    Flag = "StatsResetEnabled",
    Callback = function(Value)
        _G.AutoStatsResetEnabled = Value
        if Value and not _G.LoadedScripts.statsreset then
            loadScript("statsreset", SCRIPTS.statsreset)
        end
    end
})


TraitTab:CreateSection("Auto Ascend & Feed")

local AscendToggle = TraitTab:CreateToggle({
    Name = "Auto Ascend",
    CurrentValue = false,
    Flag = "AscendEnabled",
    Callback = function(Value)
        _G.AutoAscendEnabled = Value
        if Value and not _G.LoadedScripts.asc then
            loadScript("asc", SCRIPTS.asc)
        end
    end
})

local FeedToggle = TraitTab:CreateToggle({
    Name = "Auto Feed Shards",
    CurrentValue = false,
    Flag = "FeedEnabled",
    Callback = function(Value)
        _G.FeedShardsEnabled = Value
        if Value and not _G.LoadedScripts.feed then
            loadScript("feed", SCRIPTS.feed)
        end
    end
})

--- === SETTINGS TAB ===
SettingsTab:CreateSection("Banner Roll")

local BannerToggle = SettingsTab:CreateToggle({
    Name = "Auto Roll Banner",
    CurrentValue = false,
    Flag = "BannerEnabled",
    Callback = function(Value)
        _G.RollBannerEnabled = Value
        if Value and not _G.LoadedScripts.rollbanner then
            loadScript("rollbanner", SCRIPTS.rollbanner)
        end
    end
})

SettingsTab:CreateSection("Level Farm")

local SpecialLevelFarmToggle = SettingsTab:CreateToggle({
    Name = "Special Leveling",
    CurrentValue = false,
    Flag = "SpecialLevelFarmEnabled",
    Callback = function(Value)
        _G.SpecialLevelFarmEnabled = Value
        if Value and not _G.LoadedScripts.speciallevelfarm then
            loadScript("speciallevelfarm", SCRIPTS.speciallevelfarm)
        end
    end
})

SettingsTab:CreateParagraph({
    Title = "Max Item Bank Notes",
    Content = "• Automatically max item bank for Hamon Base.\n• Requirement: DONE Joseph's Informant's QUEST and be at Hamon Base!"
})

SettingsTab:CreateSection("Information")

SettingsTab:CreateParagraph({
    Title = "DYHUB: Information",
    Content = "• All scripts loaded from DYHUB\n• Automatically sync settings\n• Pause logic between scripts\n• Shortcut: K to hide/show GUI"
})

local ReloadAllButton = SettingsTab:CreateButton({
    Name = "Reload All Scripts",
    Callback = function()
        _G.LoadedScripts = {}
        local loaded = 0
        local total = 0
        for name, url in pairs(SCRIPTS) do
            total = total + 1
            if loadScript(name, url) then
                loaded = loaded + 1
            end
        end
        Rayfield:Notify({
            Title = "Reload Complete",
            Content = "Reloaded " .. loaded .. "/" .. total .. " scripts",
            Duration = 3,
            Image = "refresh-cw"
        })
    end
})

Rayfield:Notify({
    Title = "DYHUB Loaded",
    Content = "Premium is ready to use!",
    Duration = 5,
    Image = "check"
})

Rayfield:LoadConfiguration()
