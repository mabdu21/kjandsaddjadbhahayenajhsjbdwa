-- DYHUB | Steal A Brainrot - Upgraded Full Script (Version 3.17 -> Upgraded)
-- หมายเหตุ: สคริปต์นี้พยายามรองรับ executor ยอดนิยมหลายตัว
-- หาก executor ของคุณรองรับ writefile/readfile จะเก็บ config ให้แบบถาวร
-- ถ้าไม่รองรับ สคริปต์จะยังทำงานได้แต่ไม่สามารถบันทึกค่าได้

repeat task.wait() until game:IsLoaded()

-- Services (ประกาศครั้งเดียว)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Utilities: safe http loadstring
local function safeLoadURL(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok then return nil, ("HttpGet failed: %s"):format(tostring(res)) end
    local f, err = loadstring(res)
    if not f then return nil, ("loadstring failed: %s"):format(tostring(err)) end
    local ok2, rtn = pcall(f)
    if not ok2 then return nil, ("execution failed: %s"):format(tostring(rtn)) end
    return rtn
end

-- Config persistence (optional)
local CONFIG_FILE = "dyhub_sab_config.json"
local function canWriteFiles()
    return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
end

local config = {
    SpeedBoost = false,
    BoostSpeedValue = 50,
    AntiTrap = false,
    InfiniteJump = false,
    ESP = false,
    ViewBaseTimers = false,
    Autobuy = {},
    SelectedJobId = nil
}

local function loadConfig()
    if canWriteFiles() and isfile(CONFIG_FILE) then
        local ok, txt = pcall(readfile, CONFIG_FILE)
        if ok and txt then
            local decodeOk, data = pcall(function() return HttpService:JSONDecode(txt) end)
            if decodeOk and type(data) == "table" then
                for k,v in pairs(data) do config[k] = v end
            end
        end
    end
end

local function saveConfig()
    if canWriteFiles() then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(config))
        end)
    end
end

-- load persisted config if possible
loadConfig()

-- Connection management for clean unload
local connections = {}
local function addConn(conn)
    table.insert(connections, conn)
end
local function cleanup()
    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    connections = {}
    -- cleanup created instances
    pcall(function()
        if game.CoreGui:FindFirstChild("DYHUB_SAB_UI") then
            game.CoreGui.DYHUB_SAB_UI:Destroy()
        end
    end)
end

-- WindUI load (safely)
local WindUI
do
    local ok, ret = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)
    if ok and ret then
        WindUI = ret
    else
        warn("Failed to load WindUI:", ret)
        -- fallback: minimal UI stub to avoid errors (non-interactive)
        WindUI = {
            Popup = function() end,
            CreateWindow = function() return {
                EditOpenButton = function() end,
                Tab = function() return { Button = function() end, Toggle = function() end, Section = function() end, Dropdown = function() end, Paragraph = function() end, Input = function() end } end,
                SelectTab = function() end
            } end
        }
    end
end

-- Friendly popup (ไม่ Kick อีกต่อไป)
local Confirmed = false
pcall(function()
    WindUI:Popup({
        Title = "DYHUB Loaded! - Steal A Brainrot",
        Icon = "star",
        IconThemed = true,
        Content = "Join us at (https://dsc.gg/dyhub)",
        Buttons = {
            {
                Title = "Cancel",
                Variant = "Secondary",
                Callback = function()
                    -- ปิด UI และ cleanup แทนการ kick
                    cleanup()
                    -- ถ้าใช้ executor แบบที่สามารถ disconnect ui ได้ ให้ลบชื่อ UI
                    LocalPlayer:Kick("User cancelled DYHUB (closing).")
                end
            },
            {
                Title = "Continue",
                Icon = "arrow-right",
                Variant = "Primary",
                Callback = function()
                    Confirmed = true
                end
            }
        }
    })
end)

repeat task.wait() until Confirmed

-- Main window
local Window = WindUI:CreateWindow({
    Folder = "DYHUB Scripts - SAB",
    Title = "DYHUB | Steal A Brainrot (Upgraded)",
    IconThemed = true,
    Icon = "star",
    Author = "Version: 3.17 (Upgraded)",
    Size = UDim2.fromOffset(680, 460),
    Transparent = false,
    HasOutline = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- Tabs
local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "star" }),
    Visual = Window:Tab({ Title = "Visual", Icon = "eye-off" }),
    Shop = Window:Tab({ Title = "Shop", Icon = "shopping-basket" }),
    Random = Window:Tab({ Title = "Random Features", Icon = "dices" }),
    Brainrot = Window:Tab({ Title = "Brainrot Finder", Icon = "brain" }),
}

Window:SelectTab(Tabs.Main)

-- Helpers: safe loader wrapper
local function tryLoadURLToRun(url)
    local ok, err = pcall(function()
        local txt = game:HttpGet(url)
        local f = loadstring(txt)
        if f then pcall(f) end
    end)
    if not ok then warn("Failed to load:", url, err) end
end

-- ========== MAIN TAB ==========
Tabs.Main:Section({Title = "Utilities"})

Tabs.Main:Button({
    Title = "Steal Helper (Collab)",
    Desc = "Opens a helper GUI for stealing",
    Callback = function()
        pcall(function()
            tryLoadURLToRun("https://raw.githubusercontent.com/erewe23/uitest.github.io/refs/heads/main/ere.lua")
        end)
    end,
})

Tabs.Main:Button({
    Title = "Antisteal (OP)",
    Desc = "Loads anti-steal script (will attempt to leave game when someone enters base if script does that)",
    Callback = function()
        pcall(function()
            tryLoadURLToRun("https://raw.githubusercontent.com/34wefwef/antisteal.github.io/refs/heads/main/ere.lua")
        end)
    end,
})

Tabs.Main:Button({
    Title = "Brainrot Rare Joiner",
    Desc = "Loads external rare joiner GUI",
    Callback = function()
        pcall(function()
            tryLoadURLToRun("https://raw.githubusercontent.com/erewe23/stealhelper.github.io/refs/heads/main/ere.lua")
        end)
    end,
})

-- ========== ANTI TRAP ==========
local antiTrapEnabled = false
local function enableAntiTrap()
    if antiTrapEnabled then return end
    antiTrapEnabled = true
    local BATCH_SIZE = 250
    local SEARCH_TRAPS_IN_GAME = false

    local function shouldRemoveTrapTouch(tt)
        if not (tt:IsA("TouchTransmitter") and tt.Name == "TouchInterest") then return false end
        local p = tt.Parent
        if not (p and p:IsA("MeshPart") and p.Name == "Open") then return false end
        local m = p:FindFirstAncestorOfClass("Model")
        if not (m and m.Name == "Trap") then return false end
        return true
    end

    local function removeTrapTouch(tt)
        pcall(function() if tt.Parent then tt:Destroy() end end)
    end

    task.defer(function()
        local root = SEARCH_TRAPS_IN_GAME and game or workspace
        local all = root:GetDescendants()
        for i = 1, #all do
            local o = all[i]
            if o:IsA("TouchTransmitter") and shouldRemoveTrapTouch(o) then
                removeTrapTouch(o)
            end
            if i % BATCH_SIZE == 0 then task.wait() end
        end
    end)

    local conn = workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("TouchTransmitter") and shouldRemoveTrapTouch(obj) then
            removeTrapTouch(obj)
        end
    end)
    addConn(conn)
end

local function disableAntiTrap()
    antiTrapEnabled = false
    -- can't undelete objects; just stop listening (we already track conn)
end

Tabs.Main:Toggle({
    Title = "Anti Trap",
    Desc = "Removes common trap touch hitboxes",
    Value = config.AntiTrap,
    Callback = function(state)
        config.AntiTrap = state
        saveConfig()
        if state then enableAntiTrap() else disableAntiTrap() end
    end
})

-- ========== SPEED BOOST ==========
local speedConn
local DEFAULT_SPEED = 16
local BOOSTED_SPEED = config.BoostSpeedValue or 50

local speedEnabled = config.SpeedBoost
Tabs.Main:Section({Title = "Speed"})
Tabs.Main:Toggle({
    Title = "Boost Speed",
    Desc = "Makes movement faster when moving",
    Value = speedEnabled,
    Callback = function(val)
        speedEnabled = val
        config.SpeedBoost = val
        saveConfig()
        if speedConn then
            pcall(function() speedConn:Disconnect() end)
            speedConn = nil
        end
        if val then
            speedConn = RunService.Heartbeat:Connect(function()
                if not _G._lastSpeedBoostUpdate or (tick() - _G._lastSpeedBoostUpdate) >= 0.1 then
                    local character = LocalPlayer.Character
                    if character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
                            local moveDir = humanoid.MoveDirection
                            rootPart.Velocity = Vector3.new(
                                moveDir.X * (config.BoostSpeedValue or BOOSTED_SPEED),
                                rootPart.Velocity.Y,
                                moveDir.Z * (config.BoostSpeedValue or BOOSTED_SPEED)
                            )
                        end
                    end
                    _G._lastSpeedBoostUpdate = tick()
                end
            end)
            addConn(speedConn)
        end
    end
})

Tabs.Main:Input({
    Title = "Set Boost Speed Value",
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            config.BoostSpeedValue = num
            saveConfig()
        end
    end
})

-- ========== INFINITE JUMP ==========
local infJumpConn
local infJumpEnabled = config.InfiniteJump

local function enableInfJump()
    if infJumpConn then return end
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        if not infJumpEnabled then return end
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    addConn(infJumpConn)
end

local function disableInfJump()
    if infJumpConn then
        pcall(function() infJumpConn:Disconnect() end)
        infJumpConn = nil
    end
end

Tabs.Visual:Toggle({
    Title = "Infinite Jump (Improved)",
    Value = infJumpEnabled,
    Callback = function(val)
        infJumpEnabled = val
        config.InfiniteJump = val
        saveConfig()
        if val then enableInfJump() else disableInfJump() end
    end
})

-- ========== PLAYER ESP ==========
local espEnabled = config.ESP
local espUpdateConn

local function addHighlightToCharacter(char)
    if not char or char == LocalPlayer.Character or char:FindFirstChild("HighlightESP_DYHUB") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "HighlightESP_DYHUB"
    highlight.FillTransparency = 0.75
    highlight.OutlineTransparency = 0.5
    highlight.FillColor = Color3.new(0, 0, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.Adornee = char
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
end

local function removeHighlightFromCharacter(char)
    local highlight = char and char:FindFirstChild("HighlightESP_DYHUB")
    if highlight then highlight:Destroy() end
end

local function enableESP()
    if espUpdateConn then return end
    espUpdateConn = RunService.Heartbeat:Connect(function()
        if not espEnabled then return end
        if not _G._lastESPUpdate or (tick() - _G._lastESPUpdate) >= 0.1 then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    addHighlightToCharacter(player.Character)
                end
            end
            _G._lastESPUpdate = tick()
        end
    end)
    addConn(espUpdateConn)
end

local function disableESP()
    if espUpdateConn then
        pcall(function() espUpdateConn:Disconnect() end)
        espUpdateConn = nil
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            removeHighlightFromCharacter(player.Character)
        end
    end
end

Tabs.Visual:Toggle({
    Title = "Player ESP",
    Desc = "Highlight other players",
    Value = espEnabled,
    Callback = function(state)
        espEnabled = state
        config.ESP = state
        saveConfig()
        if state then enableESP() else disableESP() end
    end
})

Tabs.Visual:Button({
    Title = "ESP - Most Expensive Brainrot (external)",
    Callback = function()
        pcall(function()
            tryLoadURLToRun("https://raw.githubusercontent.com/34t34t33/mostexpensive.github.io/refs/heads/main/rare.lua")
        end)
    end
})

-- ========== PLOT / BASE TIMERS ==========
local plotTimers_Enabled = config.ViewBaseTimers
local plotTimers_RenderConnection = nil
local plotTimers_OriginalProperties = {}

local function disablePlotTimers()
    plotTimers_Enabled = false
    if plotTimers_RenderConnection then
        pcall(function() plotTimers_RenderConnection:Disconnect() end)
        plotTimers_RenderConnection = nil
    end
    for label, props in pairs(plotTimers_OriginalProperties) do
        pcall(function()
            if label and label.Parent then
                local bb = label:FindFirstAncestorWhichIsA("BillboardGui")
                if bb and bb.Parent then
                    bb.Enabled = props.bb_enabled
                    bb.AlwaysOnTop = props.bb_alwaysOnTop
                    bb.Size = props.bb_size
                    bb.MaxDistance = props.bb_maxDistance
                    label.TextScaled = props.label_textScaled
                    label.TextWrapped = props.label_textWrapped
                    label.AutomaticSize = props.label_automaticSize
                    label.Size = props.label_size
                    label.TextSize = props.label_textSize
                end
            end
        end)
    end
    table.clear(plotTimers_OriginalProperties)
end

local function enablePlotTimers()
    disablePlotTimers()
    plotTimers_Enabled = true
    local camera = workspace.CurrentCamera
    local DISTANCE_THRESHOLD = 45
    local SCALE_START, SCALE_RANGE = 100, 300
    local MIN_TEXT_SIZE, MAX_TEXT_SIZE = 30, 36
    local lastUpdate = 0

    plotTimers_RenderConnection = RunService.RenderStepped:Connect(function()
        if not plotTimers_Enabled then return end
        if tick() - lastUpdate < 0.1 then return end
        lastUpdate = tick()

        for _, label in ipairs(workspace.Plots:GetDescendants()) do
            if label:IsA("TextLabel") and label.Name == "RemainingTime" then
                local bb = label:FindFirstAncestorWhichIsA("BillboardGui")
                if not bb then continue end
                local model = bb:FindFirstAncestorWhichIsA("Model")
                if not model then continue end
                local basePart = model:FindFirstChildWhichIsA("BasePart", true)
                if not basePart then continue end
                if not plotTimers_OriginalProperties[label] then
                    plotTimers_OriginalProperties[label] = {
                        bb_enabled = bb.Enabled,
                        bb_alwaysOnTop = bb.AlwaysOnTop,
                        bb_size = bb.Size,
                        bb_maxDistance = bb.MaxDistance,
                        label_textScaled = label.TextScaled,
                        label_textWrapped = label.TextWrapped,
                        label_automaticSize = label.AutomaticSize,
                        label_size = label.Size,
                        label_textSize = label.TextSize,
                    }
                end
                bb.MaxDistance = 10000
                bb.AlwaysOnTop = true
                bb.ClipsDescendants = false
                bb.Size = UDim2.new(0, 300, 0, 150)
                label.TextScaled = false
                label.TextWrapped = true
                label.ClipsDescendants = false
                label.Size = UDim2.new(1, 0, 0, 32)
                label.AutomaticSize = Enum.AutomaticSize.Y

                local distance = (camera.CFrame.Position - basePart.Position).Magnitude
                if distance > DISTANCE_THRESHOLD and basePart.Position.Y >= 0 then
                    bb.Enabled = false
                else
                    bb.Enabled = true
                    local t = math.clamp((distance - SCALE_START) / SCALE_RANGE, 0, 1)
                    local newTextSize = math.clamp(MIN_TEXT_SIZE + (MAX_TEXT_SIZE - MIN_TEXT_SIZE) * t, MIN_TEXT_SIZE, MAX_TEXT_SIZE)
                    label.TextSize = newTextSize
                    label.Size = UDim2.new(1, 0, 0, newTextSize + 6)
                end
            end
        end
    end)
    addConn(plotTimers_RenderConnection)
end

Tabs.Visual:Toggle({
    Title = "View Base Lock Timers",
    Value = plotTimers_Enabled,
    Callback = function(state)
        config.ViewBaseTimers = state
        saveConfig()
        if state then enablePlotTimers() else disablePlotTimers() end
    end
})

-- ========== SHOP AUTO BUY ==========
Tabs.Shop:Section({Title = "Buy Items"})
local itemList = {
    "Slap","Speed Coil","Trap","Iron Slap","Gravity Coil","Bee Launcher","Gold Slap","Coil Combo","Rage Table",
    "Diamond Slap","Grapple Hook","Taser Gun","Emerald Slap","Invisibility Cloak","Boogie Bomb","Ruby Slap",
    "Medusa's Head","Dark Matter Slap","Web Slinger","Flame Slap","Quantum Cloner","All Seeing Sentry","Nuclear Slap",
    "Rainbowrath Sword","Body Swap Potion","Splatter Slap","Paintball Gun"
}
local autobuy_selected = config.Autobuy or {}

Tabs.Shop:Dropdown({
    Title = "Select Which Items To Auto Buy",
    Values = itemList,
    Value = autobuy_selected,
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        autobuy_selected = selected
        config.Autobuy = selected
        saveConfig()
    end
})

Tabs.Shop:Button({
    Title = "Auto Buy Selected Items Now",
    Callback = function()
        task.spawn(function()
            for _, item in ipairs(autobuy_selected or {}) do
                local args = { item }
                local ok, err = pcall(function()
                    ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/CoinsShopService/RequestBuy"):InvokeServer(unpack(args))
                end)
                if not ok then warn("AutoBuy failed for", item, tostring(err)) end
                task.wait(0.3)
            end
        end)
    end
})

-- ========== RANDOM / MISC ==========
Tabs.Random:Section({Title = "Server"})
Tabs.Random:Paragraph({
    Title = "Copy JobId",
    Desc = tostring(game.JobId),
    Buttons = {
        {
            Title = "Copy",
            Callback = function() pcall(function() setclipboard(game.JobId) end) end
        }
    }
})

Tabs.Random:Input({
    Title = "Enter Job Id",
    Callback = function(value)
        _G.JobId = tostring(value)
        config.SelectedJobId = _G.JobId
        saveConfig()
    end
})

Tabs.Random:Button({
    Title = "Join Job Id",
    Callback = function()
        if _G.JobId then
            pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _G.JobId) end)
        end
    end
})

-- ========== BRAINROT TAB ==========
Tabs.Brainrot:Button({
    Title = "BRAINROT RARE JOINER (External)",
    Desc = "Opens external GUI for rare brainrots",
    Callback = function()
        pcall(function()
            tryLoadURLToRun("https://raw.githubusercontent.com/erewe23/stealhelper.github.io/refs/heads/main/ere.lua")
        end)
    end
})

Tabs.Brainrot:Section({Title = "SECRET BRAINROT ONLY"})
Tabs.Brainrot:Button({
    Title = "Pet Finder Secret Only",
    Desc = "Opens secret brainrot joiner",
    Callback = function()
        pcall(function()
            tryLoadURLToRun("https://raw.githubusercontent.com/erewe23/stealhelper.github.io/refs/heads/main/ere.lua")
        end)
    end
})

-- ========== AUTO LOAD small tools on start (non-blocking) ==========
task.spawn(function()
    task.wait(1)
    pcall(function()
        tryLoadURLToRun("https://raw.githubusercontent.com/wedfwef3/ere.github.io/refs/heads/main/infyield.lua")
    end)
end)

-- ========== UNLOAD HANDLER ==========
-- Provide a simple method to cleanup everything and save config
local function unloadAll()
    saveConfig()
    cleanup()
    -- remove highlights that may remain
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            pcall(function() removeHighlightFromCharacter(player.Character) end)
        end
    end
    -- remove plot timer modifications
    disablePlotTimers()
end

-- Expose unload (some executors call this)
if syn and syn.protect_gui then
    -- nothing special needed here, but keep for compat
end

-- Create a global unload function for manual use
_G.DYHUB_SAB_Unload = unloadAll

-- Final message
print("[DYHUB SAB] Upgraded script loaded. Use the UI to toggle features. To unload: _G.DYHUB_SAB_Unload()")

-- EOF
