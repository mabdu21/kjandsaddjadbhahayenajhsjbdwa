local function destroyObjectCache(parent)
    for _, obj in pairs(parent:GetChildren()) do
        if obj.Name == "ObjectCache" then
            obj:Destroy()
        else
            destroyObjectCache(obj)
        end
    end
end

destroyObjectCache(workspace.Terrain)

local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ByteNetReliable = ReplicatedStorage:WaitForChild("ByteNetReliable")
local CoreGui = game:GetService("CoreGui")
local zombiesFolder = workspace:WaitForChild("Entities"):WaitForChild("Zombie")
local UIS = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local noclipTouchedParts = {}
local AutoClearToggle = {Value = true}
local AutoAttackToggle = {Value = false}
local AutoSwapToggle = {Value = false}
local AutoCollectToggle = {Value = false}
local AutoSkillsToggle = {Value = false}
local UsePerkToggle = {Value = false}
local BringMobsToggle = {Value = false}
local AutoReplayToggle = {Value = false}
local offset = Vector3.new(1, 6, 0)


player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    table.clear(noclipTouchedParts)
end)

local function enableNoclip(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            noclipTouchedParts[part] = true
            part.CanCollide = false
        end
    end
end

local function disableNoclip(character)
    for part in pairs(noclipTouchedParts) do
        if part and part.Parent then
            part.CanCollide = true
        end
    end
    table.clear(noclipTouchedParts)

    if hrp then
        local bv = hrp:FindFirstChild("Lock")
        if bv then bv:Destroy() end
    end
end

local function moveToTarget(targetHRP, offset)
    if not (hrp and hrp.Parent) then return end
    if not (targetHRP and targetHRP.Parent) then return end

    offset = offset or Vector3.new(0,5,0)
    local speed = 100

    local bv = hrp:FindFirstChild("Lock")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "Lock"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = hrp
    end

    repeat
        if not (targetHRP and targetHRP.Parent) then break end
        local targetPos = targetHRP.Position + offset
        local dir = targetPos - hrp.Position
        if dir.Magnitude > 0.5 then
            bv.Velocity = dir.Unit * speed
        else
            bv.Velocity = Vector3.zero
        end
        enableNoclip(char)
        RunService.Heartbeat:Wait()
    until not (targetHRP and targetHRP.Parent) or (hrp.Position - targetHRP.Position - offset).Magnitude <= 0.5

    bv.Velocity = Vector3.zero
end

-- โหลด UI ใหม่ (x2zu Framework)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()


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

-- สร้างหน้าต่างหลัก
local Window = Library:Window({
    Title = "DYHUB",
    Desc = "Hunty Zombies | " .. userversion,
    Icon = 104487529937663,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "DYHUB"
    }
})

-- Tab หลัก
local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local MainDivider = Window:Divider()
local MainTab = Window:Tab({Title = "Main", Icon = "star"})
local Extra = Window:Tab({Title = "Auto", Icon = "crown"})

MainTab:Section({Title = "Feature Farm"})

MainTab:Toggle({
    Title = "Auto Farm (UPG)",
    Value = true,
    Callback = function(state)
        AutoClearToggle.Value = state
        if state then
            task.spawn(function()
                enableNoclip(char)
                while AutoClearToggle.Value do
                    local targetZombie = nil
                    -- หา zombie ตัวสูงกว่า -20
                    for _, z in ipairs(zombiesFolder:GetChildren()) do
                        local zHRP = z:FindFirstChild("HumanoidRootPart")
                        if zHRP and zHRP.Position.Y > -20 then
                            targetZombie = zHRP
                            break
                        end
                    end

                    if targetZombie and targetZombie.Parent then
                        moveToTarget(targetZombie, Vector3.new(0,5,0))
                        task.wait(0.1)
                    else
                        -- ถ้าไม่มี zombie → จัดการ generator / radio / heli
                        local handled = false

                        -- BossRoom generator
                        local bossRoom = workspace:FindFirstChild("Sewers") 
                                         and workspace.Sewers:FindFirstChild("Rooms") 
                                         and workspace.Sewers.Rooms:FindFirstChild("BossRoom")
                        if bossRoom and bossRoom:FindFirstChild("generator") and bossRoom.generator:FindFirstChild("gen") then
                            local gen = bossRoom.generator.gen
                            local pom = gen:FindFirstChild("pom")
                            if pom and pom:IsA("ProximityPrompt") and pom.Enabled then
                                moveToTarget(gen, Vector3.new(0,0,0))
                                task.wait(0.5)
                                fireproximityprompt(pom)
                                task.wait(1)
                                handled = true
                            end
                        end

                        -- School Rooftop radio → heli
                        local school = workspace:FindFirstChild("School")
                        if school and school:FindFirstChild("Rooms") then
                            local rooftop = school.Rooms:FindFirstChild("RooftopBoss")
                            if rooftop and rooftop:FindFirstChild("RadioObjective") then
                                local radioPrompt = rooftop.RadioObjective:FindFirstChildOfClass("ProximityPrompt")
                                if radioPrompt and radioPrompt.Enabled then
                                    moveToTarget(rooftop.RadioObjective, Vector3.new(0,0,0))
                                    task.wait(0.5)
                                    fireproximityprompt(radioPrompt)
                                    task.wait(10)

                                    local guiLabel = player.PlayerGui 
                                        and player.PlayerGui.MainScreen 
                                        and player.PlayerGui.MainScreen.ObjectiveDisplay
                                        and player.PlayerGui.MainScreen.ObjectiveDisplay.ObjectiveElement
                                        and player.PlayerGui.MainScreen.ObjectiveDisplay.ObjectiveElement.List
                                        and player.PlayerGui.MainScreen.ObjectiveDisplay.ObjectiveElement.List.Value
                                        and player.PlayerGui.MainScreen.ObjectiveDisplay.ObjectiveElement.List.Value.Label

                                    local timeout = 15
                                    local startTime = os.clock()
                                    repeat
                                        task.wait(1)
                                    until (guiLabel and guiLabel.ContentText == "0") 
                                       or (os.clock() - startTime > timeout)

                                    local heliPrompt = rooftop:FindFirstChild("HeliObjective") 
                                                        and rooftop.HeliObjective:FindFirstChildOfClass("ProximityPrompt")
                                    if heliPrompt and heliPrompt.Enabled then
                                        moveToTarget(rooftop.HeliObjective, Vector3.new(0,0,0))
                                        task.wait(0.5)
                                        fireproximityprompt(heliPrompt)
                                    end
                                    handled = true
                                end
                            end
                        end

                        if not handled then
                            task.wait(1)
                        end
                    end
                end
                disableNoclip(char)
            end)
        else
            disableNoclip(char)
        end
    end
})

MainTab:Section({Title = "Farm Setting"})

-- Auto Attack
MainTab:Toggle({
    Title = "Auto Attack",
    Desc = "",
    Value = true,
    Callback = function(state)
    AutoAttackToggle.Value = state
        if state then
            task.spawn(function()
                while state do
                    VirtualUser:Button1Down(Vector2.new(958, 466))
                    task.wait(1)
                end
            end)
        end
    end
})

-- Auto Swap Weapons
MainTab:Toggle({
    Title = "Auto Swap Weapons",
    Value = true,
    Callback = function(state)
        AutoSwapToggle.Value = state
        if state then
            task.spawn(function()
                local keys = { Enum.KeyCode.One, Enum.KeyCode.Two }
                local current = 1
                while AutoSwapToggle.Value do
                    local key = keys[current]
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                    current = current == 1 and 2 or 1
                    task.wait(2)
                end
            end)
        end
    end
})

-- Auto Collect\
MainTab:Toggle({
    Title = "Auto Collect",
    Value = true,
    Callback = function(state)
        AutoCollectToggle.Value = state
        if state then
            task.spawn(function()
                local DropItemsFolder = workspace:WaitForChild("DropItems")
                while AutoCollectToggle.Value do
                    if hrp then
                        for _, item in ipairs(DropItemsFolder:GetChildren()) do
                            local targetPos
                            if item:IsA("Model") and item.PrimaryPart then
                                targetPos = item.PrimaryPart.Position
                            elseif item:IsA("BasePart") then
                                targetPos = item.Position
                            end
                            if targetPos then
                                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                                task.wait(0.1)
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

Extra:Section({Title = "Feature Auto"})

Extra:Toggle({
    Title = "Auto Skills",
    Value = true,
    Callback = function(state)
        AutoSkillsToggle.Value = state
        if state then
            task.spawn(function()
                local keys = { Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.G }
                while AutoSkillsToggle.Value do
                    for _, key in ipairs(keys) do
                        VirtualInputManager:SendKeyEvent(true, key, false, game)
                        VirtualInputManager:SendKeyEvent(false, key, false, game)
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end
})

Extra:Toggle({
    Title = "Auto Perk",
    Value = true,
    Callback = function(state)
        UsePerkToggle.Value = state

        if state then
            task.spawn(function()
                local args = { buffer.fromstring("\f") }
                while UsePerkToggle.Value do
                    ByteNetReliable:FireServer(unpack(args))
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end
})

Extra:Section({Title = "Object Auto"})

Extra:Toggle({
    Title = "Auto Open Door",
    Value = true,
    Callback = function(state)
        BringMobsToggle.Value = state

        if state then
            task.spawn(function()
                while BringMobsToggle.Value do
                    local sewers = workspace:FindFirstChild("Sewers")
                    if sewers and sewers:FindFirstChild("Doors") then
                        for _, door in ipairs(sewers.Doors:GetChildren()) do
                            local args = { buffer.fromstring("\b\001"), {door} }
                            ByteNetReliable:FireServer(unpack(args))
                            task.wait(0.1)
                        end
                    end
                    local school = workspace:FindFirstChild("School")
                    if school and school:FindFirstChild("Doors") then
                        for _, door in ipairs(school.Doors:GetChildren()) do
                            local args = { buffer.fromstring("\b\001"), {door} }
                            ByteNetReliable:FireServer(unpack(args))
                            task.wait(0.1)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
-- Auto Replay
 Extra:Toggle({
    Title = "Auto Replay",
    Value = true,
    Callback = function(state)
        AutoReplayToggle.Value = state

        if state then
            task.spawn(function()
                local voteReplay = ReplicatedStorage:WaitForChild("external"):WaitForChild("Packets"):WaitForChild("voteReplay")
                while AutoReplayToggle.Value do
                    voteReplay:FireServer()
                    task.wait(0.5)
                end
            end)
        end
    end
})

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
