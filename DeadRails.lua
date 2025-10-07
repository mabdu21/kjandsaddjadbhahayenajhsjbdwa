local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "DYHUB | Auto Bond | Menu"
gui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 120)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local borderStroke = Instance.new("UIStroke")
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Thickness = 3
borderStroke.Parent = mainFrame

local function getRainbowColor(t)
    local f = 2
    local r = math.floor(math.sin(f * t + 0) * 127 + 128)
    local g = math.floor(math.sin(f * t + 2) * 127 + 128)
    local b = math.floor(math.sin(f * t + 4) * 127 + 128)
    return Color3.fromRGB(r, g, b)
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Dead Rails V2 | DYHUB"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = mainFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 50)
infoLabel.Position = UDim2.new(0, 10, 0, 50)
infoLabel.Text = "⚠️ Script will auto run in 3 seconds!"
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextScaled = true
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
infoLabel.Parent = mainFrame

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 42, 0, 42)
toggleBtn.Position = UDim2.new(1, -54, 0, 12)
toggleBtn.Text = "D"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    toggleStroke.Color = color
    toggleBtn.TextColor3 = color
    title.TextColor3 = color
end)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
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

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

task.wait(3)
gui:Destroy()

if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until player.Character and not player.PlayerGui:FindFirstChild("LoadingScreenPrefab")

ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("EndDecision"):FireServer(false)

if not game.CoreGui:FindFirstChild("BondFarm") then
    local gui2 = Instance.new("ScreenGui", game.CoreGui)
    gui2.Name = "BondFarm"
    gui2.ResetOnSpawn = false
    gui2.IgnoreGuiInset = true

    local black = Instance.new("Frame", gui2)
    black.Size = UDim2.new(1, 0, 1, 0)
    black.BackgroundColor3 = Color3.new(0, 0, 0)
    black.BackgroundTransparency = 0.4

    local mainFrame2 = Instance.new("Frame", gui2)
    mainFrame2.Name = "mainFrame"
    mainFrame2.Size = UDim2.new(0.4, 0, 0.2, 0)
    mainFrame2.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame2.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame2.BackgroundTransparency = 1

    local title2 = Instance.new("TextLabel", mainFrame2)
    title2.Size = UDim2.new(0.8, 0, 0.3, 0)
    title2.Position = UDim2.new(0.5, 0, 0.1, 0)
    title2.AnchorPoint = Vector2.new(0.5, 0)
    title2.BackgroundTransparency = 1
    title2.Text = "Auto-Farm Bond | DYHUB"
    title2.TextColor3 = Color3.new(1, 1, 1)
    title2.TextScaled = true
    title2.Font = Enum.Font.SourceSansBold

    RunService.RenderStepped:Connect(function()
        title2.TextColor3 = getRainbowColor(tick())
    end)

    local bondCount = Instance.new("TextLabel", mainFrame2)
    bondCount.Name = "bondCount"
    bondCount.Size = UDim2.new(0.6, 0, 0.2, 0)
    bondCount.Position = UDim2.new(0.5, 0, 0.6, 0)
    bondCount.AnchorPoint = Vector2.new(0.5, 0)
    bondCount.BackgroundTransparency = 1
    bondCount.Text = "Collected Bonds: 0"
    bondCount.TextColor3 = Color3.new(1, 1, 1)
    bondCount.TextScaled = true
    bondCount.Font = Enum.Font.SourceSans

    Instance.new("BlurEffect", game:GetService("Lighting")).Size = 12
end

local collectedBonds = 0
_G.Bond = 0

workspace.RuntimeItems.ChildAdded:Connect(function(v)
    if v.Name:find("Bond") and v:FindFirstChild("Part") then
        v.Destroying:Connect(function()
            _G.Bond += 1
            collectedBonds += 1
        end)
    end
end)

task.spawn(function()
    while true do
        local gui2 = game.CoreGui:FindFirstChild("BondFarm")
        if gui2 and gui2:FindFirstChild("mainFrame") and gui2.mainFrame:FindFirstChild("bondCount") then
            gui2.mainFrame.bondCount.Text = "Collected Bonds: " .. tostring(_G.Bond)
        end

        if collectedBonds >= 999 then
            TeleportService:Teleport(116495829188952, player)
            break
        elseif collectedBonds >= 200 then
            task.wait(15)
            TeleportService:Teleport(116495829188952, player)
            break
        end

        task.wait(0.1)
    end
end)

local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
workspace.CurrentCamera.CameraSubject = hum
hrp.Anchored = true
task.wait(0.2)
hrp.CFrame = CFrame.new(80, 3, -9000)
repeat task.wait() until workspace.RuntimeItems:FindFirstChild("MaximGun")
task.wait(0.2)

for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
    if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
        v.VehicleSeat.Disabled = false
        v.VehicleSeat:SetAttribute("Disabled", false)
        v.VehicleSeat:Sit(hum)
    end
end

task.wait(0.2)
for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
    if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and (hrp.Position - v.VehicleSeat.Position).Magnitude < 400 then
        hrp.CFrame = v.VehicleSeat.CFrame
    end
end

task.wait(0.5)
hrp.Anchored = false
repeat task.wait(0.1) until hum.Sit
task.wait(0.3)
hum.Sit = false
task.wait(0.2)
repeat
    for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
        if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and (hrp.Position - v.VehicleSeat.Position).Magnitude < 400 then
            hrp.CFrame = v.VehicleSeat.CFrame
        end
    end
    task.wait(0.2)
until hum.Sit
task.wait(0.4)

for _, v in pairs(workspace:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("RequiredComponents") then
        local seat = v.RequiredComponents:FindFirstChild("Controls")
            and v.RequiredComponents.Controls:FindFirstChild("ConductorSeat")
            and v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat")
        if seat then
            local tp = TweenService:Create(hrp, TweenInfo.new(15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = seat.CFrame * CFrame.new(0, 20, 0)})
            tp:Play()
            if not hrp:FindFirstChild("VelocityHandler") then
                local bv = Instance.new("BodyVelocity", hrp)
                bv.Name = "VelocityHandler"
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Velocity = Vector3.zero
            end
            tp.Completed:Wait()
        end
    end
end

task.wait(0.5)
while true do
    if hum.Sit then
        local tp = TweenService:Create(hrp, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = CFrame.new(0.5, -78, -49429)})
        tp:Play()
        if not hrp:FindFirstChild("VelocityHandler") then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "VelocityHandler"
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.zero
        end
        repeat task.wait() until workspace.RuntimeItems:FindFirstChild("Bond")
        tp:Cancel()

        for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
            if v.Name:find("Bond") and v:FindFirstChild("Part") then
                repeat
                    if v:FindFirstChild("Part") then
                        hrp.CFrame = v.Part.CFrame
                        ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(v)
                    end
                    task.wait(0.1)
                until not v:FindFirstChild("Part")
            end
        end
    end
    task.wait(0.1)
end
