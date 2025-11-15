-- =========================
local version = "3.6.3"

local ver2 = "Bypass Detected"
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

-- ================================
--        LOAD WIND UI
-- ================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ================================
--        SERVICES / PLAYER
-- ================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ================================
--       VERSION CHECKER
-- ================================
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

    local func = loadstring(response)
    if not func then return FreeVersion end

    local premiumData = func()
    return premiumData[playerName] and PremiumVersion or FreeVersion
end

local userversion = checkVersion(LocalPlayer.Name)

-- ================================
--         CREATE WINDOW
-- ================================
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Anime Rails | " .. userversion,
    Size = UDim2.fromOffset(500, 300),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = { Enabled = true, Anonymous = false },
})

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

Window:SetToggleKey(Enum.KeyCode.K)

pcall(function()
    Window:Tag({
        Title = version,
        Color = Color3.fromHex("#30ff6a")
    })
end)

pcall(function()
    Window:Tag({
        Title = ver2,
        Color = Color3.fromHex("#ff0000")
    })
end)

-- ================================
--              TABS
-- ================================
local Info          = Window:Tab({ Title = "Information",  Icon = "info" })
local MainDivider   = Window:Divider()
local MainTab       = Window:Tab({ Title = "Main",         Icon = "rocket" })
local CashTab       = Window:Tab({ Title = "Cash",         Icon = "dollar-sign" })
local GamepassTab   = Window:Tab({ Title = "Gamepass",     Icon = "cookie" })
Window:SelectTab(1)
-- ================================
--           MAIN TAB
-- ================================
local data = LocalPlayer:WaitForChild("Data")
local event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ChangeValue")

local function getDataNames()
    local names = {}
    for _, child in ipairs(data:GetChildren()) do
        if child:IsA("BoolValue")
            and child.Name ~= "HideMorph"
            and child.Name ~= "HideArmor"
            and not child.Name:match("^Code")
        then
            table.insert(names, child.Name)
        end
    end
    table.sort(names)
    return names
end

-- ================================
--         DUPE SELECT
-- ================================
MainTab:Section({ Title = "Dupe Select", Icon = "layers-2" })

-- ===== Morph =====
MainTab:Dropdown({
    Title = "Select Morph",
    Values = getDataNames(),
    Multi = false,
    Callback = function(v) morphInputValue = v end
})
MainTab:Button({
    Title = "Unlock Morph",
    Icon = "crown",
    Callback = function()
        if morphInputValue then
            event:FireServer("SetMorphBuy", morphInputValue, 0)
        end
    end
})

-- ===== Class =====
MainTab:Dropdown({
    Title = "Select Class",
    Values = getDataNames(),
    Multi = false,
    Callback = function(v) classInputValue = v end
})
MainTab:Button({
    Title = "Unlock Class",
    Icon = "swords",
    Callback = function()
        if classInputValue then
            event:FireServer("SetMorphBuy", classInputValue, 0)
        end
    end
})

-- ===== Aura =====
MainTab:Dropdown({
    Title = "Select Aura",
    Values = getDataNames(),
    Multi = false,
    Callback = function(v) auraInputValue = v end
})
MainTab:Button({
    Title = "Unlock Aura",
    Icon = "flame",
    Callback = function()
        if auraInputValue then
            event:FireServer("SetMorphBuy", auraInputValue, 0)
        end
    end
})

-- ================================
--             CASH TAB
-- ================================
CashTab:Section({ Title = "Join Group first!", Icon = "triangle-alert" })
CashTab:Section({ Title = "Dupe Currency", Icon = "circle-dollar-sign" })

CashTab:Button({
    Title = "Dupe Cash - 10K (One time Only)",
    Icon = "dollar-sign",
    Callback = function()
        ReplicatedStorage:WaitForChild("IDK"):FireServer("23455", "Wins", 10000, "500KMEMBER")
    end,
})

CashTab:Button({
    Title = "Dupe Cash - 50K (One time Only)",
    Icon = "dollar-sign",
    Callback = function()
        ReplicatedStorage:WaitForChild("IDK"):FireServer("23455", "Wins", 50000, "16MVISITS")
    end,
})

CashTab:Button({
    Title = "Dupe Cash - 99K (One time Only)",
    Icon = "dollar-sign",
    Callback = function()
        ReplicatedStorage:WaitForChild("IDK"):FireServer("23455", "Wins", 99999, "BLACKFLASH")
    end,
})

CashTab:Section({ Title = "Warning: You will be reset", Icon = "triangle-alert" })
CashTab:Button({
    Title = "Dupe Cash (Infinite Money)",
    Icon = "dollar-sign",
    Callback = function()
        ReplicatedStorage:WaitForChild("IDK"):FireServer("23455", "Wins", 999999999, "BLACKFLASH")
    end,
})

-- ================================
--         GAMEPASS TAB
-- ================================
GamepassTab:Section({ Title = "Feature Gamepass", Icon = "moon-star" })

local gamepassList = {
    "All",
    "DoubleCash",
    "AlrBoughtSkipSpin",
    "SecClass",
    "Emote",
    "CriticalHit",
    "SkipSpin"
}

GamepassTab:Dropdown({
    Title = "Select Gamepass",
    Values = gamepassList,
    Multi = false,
    Callback = function(selected)
        selectedGamepass = selected
    end,
})

GamepassTab:Button({
    Title = "Enter Unlock",
    Icon = "check",
    Callback = function()

        if not selectedGamepass then 
            warn("[DYHUB] Select gamepass first!") 
            return 
        end

        local d = LocalPlayer:FindFirstChild("Data")
        if not d then return end

        local toUnlock = (selectedGamepass == "All")
            and { "DoubleCash", "AlrBoughtSkipSpin", "SecClass", "Emote", "CriticalHit", "SkipSpin" }
            or { selectedGamepass }

        for _, gp in ipairs(toUnlock) do
            local v = d:FindFirstChild(gp)
            if v then v.Value = true end
        end

        -- Emote UI Fix
        if selectedGamepass == "Emote" or selectedGamepass == "All" then
            local hud = LocalPlayer.PlayerGui:FindFirstChild("HUD")
            if hud and hud:FindFirstChild("Emotes") then
                hud.Emotes.Visible = true
            end
        end
    end,
})

-- ========= HIDE FEATURE =========
GamepassTab:Section({ Title = "Feature Hide", Icon = "eye-off" })

local hideList = { "All", "HideMorph", "HideArmor" }

GamepassTab:Dropdown({
    Title = "Select Hide",
    Values = hideList,
    Multi = false,
    Callback = function(sel)
        selectedGamepass1 = sel
    end,
})

GamepassTab:Button({
    Title = "Enter Hide",
    Icon = "check",
    Callback = function()

        if not selectedGamepass1 then 
            warn("[DYHUB] Select Hide first!") 
            return 
        end

        local d = LocalPlayer:FindFirstChild("Data")
        if not d then return end

        local toHide = (selectedGamepass1 == "All")
            and { "HideMorph", "HideArmor" }
            or { selectedGamepass1 }

        for _, hideName in ipairs(toHide) do
            local v = d:FindFirstChild(hideName)
            if v then v.Value = true end
        end
    end,
})

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
