local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")

-- ===================================================

local Untarget = {"Namw", "Name", "Name"} -- Name of a brainrot that does not need to be killed (Ex: Liril)
local WeaponName = "Pistol" -- Your weapon name (Ex: Minigun)

-- ===================================================

local Gun

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoShooterGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 180)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Auto Shooter"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

local function createToggleButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.Text = name..": Off"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Parent = mainFrame
    btn.AutoButtonColor = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        btn.Text = name..": "..(state and "On" or "Off")
    end)

    return btn
end

local autoShoot = false
local autoSell = false

local shootButton = createToggleButton("Auto Shoot", 45, function(state)
    autoShoot = state
end)

local sellButton = createToggleButton("Auto Sell All (5s)", 95, function(state)
    autoSell = state
end)

local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

runService.RenderStepped:Connect(function()
    if dragging and dragInput then
        update(dragInput)
    end
end)

local function getCharacterWeapon()
    local char = player.Character or player.CharacterAdded:Wait()
    local weapon = char:WaitForChild(WeaponName)
    Gun = weapon
end

spawn(getCharacterWeapon)

local function shootNPC(npcHitbox)
    if not Gun then return end
    local args = {
        buffer.fromstring("\005\209'\000\195\203\208\215\193\253C\146B\188\t\230h\026{\134C\231\212\153A\235\031UB\218\015I\192\0040\178?\218\015I@\001\000\001\0001\001\002"),
        {npcHitbox, Gun}
    }
    replicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
end

local lastSell = tick()
runService.RenderStepped:Connect(function()
    if autoShoot and Gun then
        local npcsFolder = workspace:WaitForChild("Stampede"):WaitForChild("NPCs")
        for _, npc in pairs(npcsFolder:GetChildren()) do
            if npc:FindFirstChild("Hitbox") then
                local canShoot = true
                for _, name in pairs(Untarget) do
                    if npc.Name:lower():match(name:lower()) then
                        canShoot = false
                        break
                    end
                end
                if canShoot then
                    shootNPC(npc.Hitbox)
                end
            end
        end
    end

    if autoSell and tick() - lastSell >= 5 then
        local args = { buffer.fromstring("\017") }
        replicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
        lastSell = tick()
    end
end)
