-- =========================
local version = "3.1.2"
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

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- โหลด WindUI
local WindUI = nil
local success, errorMessage = pcall(function()
    local scriptContent = game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
    if scriptContent and scriptContent ~= "" then
        WindUI = loadstring(scriptContent)()
    else
        error("Failed to retrieve WindUI script content.")
    end
end)

if not success or not WindUI then
    warn("Failed to load WindUI: " .. (errorMessage or "Unknown error"))
    StarterGui:SetCore("SendNotification", {
        Title = "DYHUB Error",
        Text = "The script does not support your executor!",
        Duration = 10,
        Button1 = "OK"
    })
    return
end

-- สร้างหน้าต่างหลัก
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Steal A Baddie | " .. userversion,
    Size = UDim2.fromOffset(500, 320),
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

-- สร้าง Tabs
local Tabs = {
    InfoTab = Window:Tab({ Title = "Information", Icon = "info" }),
    MainDivider = Window:Divider(),
    GameTab = Window:Tab({ Title = "Main", Icon = "rocket" }),
    FarmTab = Window:Tab({ Title = "Auto Farm", Icon = "crown" }),
    PlayerTab = Window:Tab({ Title = "Player", Icon = "user" }),
    ESPTab = Window:Tab({ Title = "ESP", Icon = "eye" }),
    TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" }),
}
Window:SelectTab(1)

-- ======= GameTab (Steal) =======
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local fakeClone = nil
local isInvisible = false
local originalCameraSubject = nil
local originalFakePos = nil

Tabs.GameTab:Toggle({
    Title = "Invisible (Clone)",
    Default = false,
    Callback = function(state)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not character or not humanoid or not rootPart then return end

        if state and not isInvisible then
            isInvisible = true

            -- บันทึกตำแหน่งปัจจุบันก่อนย้ายขึ้น
            originalFakePos = rootPart.CFrame

            -- ย้ายตัวจริงให้ลอยขึ้น
            rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 50, 0)

            -- Clone ตัวปลอม
            fakeClone = character:Clone()
            fakeClone.Name = "FakeClone"
            fakeClone.Parent = Workspace

            -- ลบ scripts ใน clone
            for _, desc in pairs(fakeClone:GetDescendants()) do
                if desc:IsA("Script") or desc:IsA("LocalScript") then
                    desc:Destroy()
                end
            end

            -- ยึดตำแหน่งตัวปลอมให้อยู่กับที่
            local fakeHRP = fakeClone:FindFirstChild("HumanoidRootPart")
            local fakeHumanoid = fakeClone:FindFirstChildOfClass("Humanoid")
            if fakeHRP then
                fakeHRP.Anchored = true
            end
            if fakeHumanoid then
                fakeHumanoid.DisplayName = "[Clone]"
                fakeHumanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                fakeHumanoid.NameDisplayDistance = 0
            end

            -- กล้องตามร่างปลอม
            originalCameraSubject = Workspace.CurrentCamera.CameraSubject
            Workspace.CurrentCamera.CameraSubject = fakeHumanoid

        elseif not state and isInvisible then
            isInvisible = false

            -- เอาตัวจริงกลับมาตำแหน่งร่างปลอม
            if fakeClone and fakeClone:FindFirstChild("HumanoidRootPart") then
                local targetCFrame = fakeClone.HumanoidRootPart.CFrame
                rootPart.CFrame = targetCFrame + Vector3.new(0, 2, 0) -- ยืนเหนือร่างปลอมเล็กน้อย
            elseif originalFakePos then
                rootPart.CFrame = originalFakePos -- fallback
            end

            -- กล้องกลับมาหาตัวจริง
            if originalCameraSubject then
                Workspace.CurrentCamera.CameraSubject = originalCameraSubject
            end

            -- ลบร่างปลอม
            if fakeClone and fakeClone.Parent then
                fakeClone:Destroy()
            end
        end
    end
})

Tabs.GameTab:Button({
    Title = "Steal (No Hold)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/nodelay.lua"))()
    end
})

-- ======= PlayerTab (Speed, Jump, Fly, Noclip) =======
getgenv().speedEnabled = false
getgenv().speedValue = 20
Tabs.PlayerTab:Toggle({
    Title = "Enable Speed",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})
Tabs.PlayerTab:Slider({
    Title = "Set Speed Value",
    Value = { Min = 16, Max = 600, Default = 20 },
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

getgenv().jumpEnabled = false
getgenv().jumpValue = 50
Tabs.PlayerTab:Toggle({
    Title = "Enable JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().jumpEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.JumpPower = v and getgenv().jumpValue or 16 end
    end
})
Tabs.PlayerTab:Slider({
    Title = "Set Jump Value",
    Value = { Min = 10, Max = 600, Default = 50 },
    Step = 1,
    Callback = function(val)
        getgenv().jumpValue = val
        if getgenv().jumpEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end
})

Tabs.PlayerTab:Button({
    Title = "Fly (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Dupe-Anime-Rails/refs/heads/main/Dly"))()
    end
})

local noclipConnection
_G.Noclip = false
Tabs.PlayerTab:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        _G.Noclip = state
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char and _G.Noclip then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

-- ======= FarmTab (Auto Collect Money) =======
_G.AutoCollectMoney = false
Tabs.FarmTab:Toggle({
    Title = "Auto Collect (Money)",
    Default = false,
    Callback = function(state)
        local RS = ReplicatedStorage
        local ClaimCash = RS:WaitForChild("src"):WaitForChild("Modules"):WaitForChild("KnitClient")
            :WaitForChild("Services"):WaitForChild("BaseService"):WaitForChild("RE"):WaitForChild("ClaimCash")

        _G.AutoCollectMoney = state
        if state then
            task.spawn(function()
                while _G.AutoCollectMoney do
                    for i = 1, 20 do
                        pcall(function()
                            ClaimCash:FireServer(i)
                        end)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- ======= ESP Tab =======
local ESPEnabled = false
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = CoreGui

local function createESP(player)
    if player == LocalPlayer then return end
    if ESPFolder:FindFirstChild(player.Name) then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name
    highlight.FillColor = Color3.fromRGB(0, 255, 0) -- สีเขียว
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_ESPLabel"
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.new(1, 1, 1) -- สีขาว
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = billboard

    local function attachESP()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            highlight.Adornee = player.Character
            billboard.Adornee = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
        end
    end

    attachESP()
    player.CharacterAdded:Connect(function()
        task.wait(1)
        attachESP()
    end)

    highlight.Parent = ESPFolder
    billboard.Parent = ESPFolder
end

local function removeESP(player)
    local h = ESPFolder:FindFirstChild(player.Name)
    local b = ESPFolder:FindFirstChild(player.Name .. "_ESPLabel")
    if h then h:Destroy() end
    if b then b:Destroy() end
end

local function enableESP()
    for _, player in pairs(Players:GetPlayers()) do
        createESP(player)
    end
    Players.PlayerAdded:Connect(createESP)
    Players.PlayerRemoving:Connect(removeESP)
end

local function disableESP()
    ESPFolder:ClearAllChildren()
end

Tabs.ESPTab:Toggle({
    Title = "Player ESP",
    Default = false,
    Callback = function(state)
        ESPEnabled = state
        if state then
            enableESP()
        else
            disableESP()
        end
    end
})

-- ======= Teleport Tab =======
local savedCFrame = nil

-- เซฟตำแหน่งจุดแรก หลังโหลดเสร็จ
task.delay(2, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)

Tabs.TeleportTab:Button({
    Title = "Teleport to Home",
    Callback = function()
        if savedCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = savedCFrame
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Teleport",
                Text = "Spawn point not saved or character missing!",
                Duration = 5
            })
        end
    end
})

Info = Tabs.InfoTab

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
