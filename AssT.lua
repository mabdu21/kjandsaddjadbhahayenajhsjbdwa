local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "🗡️ DYHUB | Abilities Tower",
            Text = text,
            Duration = 3
        })
    end)
end

notify("✅ DYHUB Loaded! | Abilities Tower")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DYHUB | Auto Win | Abilities Tower"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 230)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -115)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 20)

local borderStroke = Instance.new("UIStroke")
borderStroke.Parent = mainFrame
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Thickness = 3

local function getRainbowColor(tick)
    local frequency = 2
    local red = math.floor(math.sin(frequency * tick + 0) * 127 + 128)
    local green = math.floor(math.sin(frequency * tick + 2) * 127 + 128)
    local blue = math.floor(math.sin(frequency * tick + 4) * 127 + 128)
    return Color3.fromRGB(red, green, blue)
end

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Abilities Tower | DYHUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    title.TextColor3 = color
end)

local autoButton = Instance.new("TextButton", mainFrame)
autoButton.Size = UDim2.new(0.8, 0, 0, 40)
autoButton.Position = UDim2.new(0.1, 0, 0, 50)
autoButton.Text = "Auto Win: Off"
autoButton.Font = Enum.Font.GothamBold
autoButton.TextScaled = true
autoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Instance.new("UICorner", autoButton).CornerRadius = UDim.new(0, 10)

local fixBugButton = Instance.new("TextButton", mainFrame)
fixBugButton.Size = UDim2.new(0.8, 0, 0, 40)
fixBugButton.Position = UDim2.new(0.1, 0, 0, 100)
fixBugButton.Text = "Fix Bug (Respawn)"
fixBugButton.Font = Enum.Font.GothamBold
fixBugButton.TextScaled = true
fixBugButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fixBugButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
Instance.new("UICorner", fixBugButton).CornerRadius = UDim.new(0, 10)

local infoLabel = Instance.new("TextLabel", mainFrame)
infoLabel.Size = UDim2.new(1, -20, 0, 50)
infoLabel.Position = UDim2.new(0, 10, 0, 150)
infoLabel.Text = "⚠️ Auto-Win Smooth Moving...\nRepeat every 15 sec."
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextScaled = true
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.BackgroundTransparency = 1
infoLabel.TextWrapped = true

-- ข้อมูลเคลื่อนที่
local targetCFrame = CFrame.new(
    -223.086075, 345.209686, 128.781738,
    0.866007268, 0, 0.500031412,
    0, 1, 0,
    -0.500031412, 0, 0.866007268
)

local autoWin = false
local isRunning = false

local padsFolder = Workspace:FindFirstChild("AutoWinPads")
if not padsFolder then
    padsFolder = Instance.new("Folder")
    padsFolder.Name = "AutoWinPads"
    padsFolder.Parent = Workspace
end

local function clearPads()
    for _, pad in ipairs(padsFolder:GetChildren()) do
        if pad:IsA("BasePart") then
            pad:Destroy()
        end
    end
end

local function createPad(position, color)
    local pad = Instance.new("Part")
    pad.Size = Vector3.new(8, 1, 8)
    pad.Anchored = true
    pad.CanCollide = true
    pad.Transparency = 1
    pad.Material = Enum.Material.Neon
    pad.Color = color
    pad.CFrame = CFrame.new(position - Vector3.new(0, 3, 0))
    pad.Parent = padsFolder
    return pad
end

local function runAutoWin()
    if isRunning then return end
    isRunning = true

    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")

    local startPos = rootPart.Position
    local liftHeight = targetCFrame.Position.Y + 2
    local liftPos = Vector3.new(startPos.X, liftHeight, startPos.Z)
    local targetPos = targetCFrame.Position

    local duration1 = 16
    local durationWait = 16
    local duration2 = 17
    local t0 = tick()

    local lifting, waiting, gliding = true, false, false

    local con
    con = RunService.RenderStepped:Connect(function()
        local dt = tick() - t0

        if lifting then
            local alpha = math.clamp(dt / duration1, 0, 1)
            local newPos = startPos:Lerp(liftPos, alpha)
            rootPart.CFrame = CFrame.new(newPos)

            createPad(newPos, Color3.fromRGB(255, 255, 0))

            if alpha >= 1 then
                lifting = false
                waiting = true
                t0 = tick()
            end

        elseif waiting then
            rootPart.CFrame = CFrame.new(liftPos)
            createPad(rootPart.Position, Color3.fromRGB(255, 255, 0))

            if dt >= durationWait then
                notify("⚠️ Bypass Anti-Faster Win")
                waiting = false
                gliding = true
                t0 = tick()
                startPos = rootPart.Position
            end

        elseif gliding then
            local alpha = math.clamp(dt / duration2, 0, 1)
            local newXZ = startPos:Lerp(Vector3.new(targetPos.X, liftHeight, targetPos.Z), alpha)
            rootPart.CFrame = CFrame.new(newXZ)

            createPad(newXZ, Color3.fromRGB(0, 255, 0))

            if alpha >= 1 then
                rootPart.CFrame = targetCFrame
                gliding = false
                con:Disconnect()
                isRunning = false
                notify("✅ Auto Win Finished")
                clearPads()
            end
        end
    end)
end

autoButton.MouseButton1Click:Connect(function()
    autoWin = not autoWin
    autoButton.Text = autoWin and "Auto Win: On" or "Auto Win: Off"
    notify("Auto Win: " .. (autoWin and "✅ Enabled" or "❌ Disabled"))

    if autoWin and not isRunning then
        runAutoWin()
    end
end)

fixBugButton.MouseButton1Click:Connect(function()
    notify("♻️ Fix Bug: Respawning player...")
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        else
            player.Character:Destroy()
        end
    end

    autoWin = false
    autoButton.Text = "Auto Win: Off"

    local character = player.CharacterAdded:Wait()
    character:WaitForChild("HumanoidRootPart")

    notify("✅ Player Respawned! Restarting Auto Win...")

    autoWin = true
    autoButton.Text = "Auto Win: On"
    runAutoWin()
end)

task.spawn(function()
    while true do
        if autoWin and not isRunning then
            runAutoWin()
        end
        wait(15)
    end
end)
