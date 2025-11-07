-- ================= V6.0 SMOOTH EDITION =================
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ================= CONFIG =================
local Config = {
    CamlockEnabled = false,
    ThroughWalls = false,
    EspEnabled = false,
    TeamCheck = true,
    ShowFOV = true,
    FOVRadius = 150,
    Smoothness = 0.16, -- ยิ่งต่ำ = ยิ่งเร็ว
    Prediction = 0.135, -- ค่าทำนายการเคลื่อนไหว
    LockPart = "Head",
    LockParts = {"Head", "UpperTorso", "HumanoidRootPart"},
    Keybinds = {
        Camlock = Enum.KeyCode.V,
        LockPart = Enum.KeyCode.G,
        ThroughWalls = Enum.KeyCode.H,
        ESP = Enum.KeyCode.T,
        Team = Enum.KeyCode.K,
        Menu = Enum.KeyCode.End
    }
}

-- ================= STATE =================
local State = {
    LockedTarget = nil,
    MenuOpen = true,
    FOVCircle = nil
}

-- ================= SAFE GET =================
local function safeFind(obj, name)
    return obj and obj:FindFirstChild(name)
end

local function getRoot(char)
    return safeFind(char, "HumanoidRootPart") or safeFind(char, "Torso")
end

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 300)
Frame.Position = UDim2.new(0.5, 0, 0.35, 0)
Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Visible = State.MenuOpen
Frame.AnchorPoint = Vector2.new(0.5, 0)
Frame.Parent = ScreenGui
Frame.ZIndex = 9999
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 16)

local Shadow = Instance.new("UIStroke", Frame)
Shadow.Thickness = 2
Shadow.Color = Color3.fromRGB(0, 0, 0)
Shadow.Transparency = 0.7

-- Draggable
local dragging, startPos, startPosFrame
local function updateDrag(input)
    if not dragging then return end
    local delta = input.Position - startPos
    Frame.Position = UDim2.new(
        startPosFrame.X.Scale,
        startPosFrame.X.Offset + delta.X,
        startPosFrame.Y.Scale,
        startPosFrame.Y.Offset + delta.Y
    )
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        startPos = input.Position
        startPosFrame = Frame.Position
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        updateDrag(input)
    end
end)

-- ================= BUTTON CREATOR =================
local function createButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.Position = pos
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.BorderSizePixel = 0
    btn.ZIndex = 10000
    btn.Parent = Frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(55, 55, 70) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50) end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ================= MAIN GUI =================
local ToggleBtn = createButton("Camlock: OFF", UDim2.new(0,10,0,15), function()
    Config.CamlockEnabled = not Config.CamlockEnabled
    ToggleBtn.Text = Config.CamlockEnabled and "Camlock: ON" or "Camlock: OFF"
end)

local ModeBtn = createButton("Part: "..Config.LockPart, UDim2.new(0,10,0,55), function()
    local i = table.find(Config.LockParts, Config.LockPart)
    i = (i % #Config.LockParts) + 1
    Config.LockPart = Config.LockParts[i]
    ModeBtn.Text = "Part: " .. Config.LockPart
end)

local WallBtn = createButton("Walls: OFF", UDim2.new(0,10,0,95), function()
    Config.ThroughWalls = not Config.ThroughWalls
    WallBtn.Text = Config.ThroughWalls and "Walls: ON" or "Walls: OFF"
end)

local EspBtn = createButton("ESP: OFF", UDim2.new(0,10,0,135), function()
    Config.EspEnabled = not Config.EspEnabled
    EspBtn.Text = Config.EspEnabled and "ESP: ON" or "ESP: OFF"
end)

local TeamBtn = createButton("Team: ON", UDim2.new(0,10,0,175), function()
    Config.TeamCheck = not Config.TeamCheck
    TeamBtn.Text = Config.TeamCheck and "Team: ON" or "Team: OFF"
end)

local FovBtn = createButton("FOV: ON", UDim2.new(0,10,0,215), function()
    Config.ShowFOV = not Config.ShowFOV
    FovBtn.Text = Config.ShowFOV and "FOV: ON" or "FOV: OFF"
    State.FOVCircle.Visible = Config.ShowFOV
end)

-- Menu Icon
local MenuIcon = Instance.new("ImageButton")
MenuIcon.Size = UDim2.new(0, 55, 0, 55)
MenuIcon.Position = UDim2.new(0, 15, 0, 15)
MenuIcon.Image = "rbxassetid://104487529937663"
MenuIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MenuIcon.ZIndex = 10000
MenuIcon.Parent = ScreenGui
Instance.new("UICorner", MenuIcon).CornerRadius = UDim.new(0.5, 0)

MenuIcon.MouseButton1Click:Connect(function()
    State.MenuOpen = not State.MenuOpen
    Frame.Visible = State.MenuOpen
    MenuIcon.BackgroundColor3 = State.MenuOpen and Color3.fromRGB(60, 140, 60) or Color3.fromRGB(40, 40, 40)
end)

-- ================= FOV CIRCLE =================
State.FOVCircle = Drawing.new("Circle")
State.FOVCircle.Thickness = 2
State.FOVCircle.NumSides = 32
State.FOVCircle.Radius = Config.FOVRadius
State.FOVCircle.Color = Color3.fromRGB(255, 100, 100)
State.FOVCircle.Transparency = 0.6
State.FOVCircle.Filled = false
State.FOVCircle.Visible = Config.ShowFOV

RunService.RenderStepped:Connect(function()
    if State.FOVCircle.Visible then
        local pos = Vector2.new(Mouse.X, Mouse.Y)
        State.FOVCircle.Position = pos
    end
end)

-- ================= KEYBINDS =================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local key = input.KeyCode
    for action, bind in pairs(Config.Keybinds) do
        if key == bind then
            if action == "Camlock" then ToggleBtn.MouseButton1Click:Fire()
            elseif action == "LockPart" then ModeBtn.MouseButton1Click:Fire()
            elseif action == "ThroughWalls" then WallBtn.MouseButton1Click:Fire()
            elseif action == "ESP" then EspBtn.MouseButton1Click:Fire()
            elseif action == "Team" then TeamBtn.MouseButton1Click:Fire()
            elseif action == "Menu" then MenuIcon.MouseButton1Click:Fire()
            end
        end
    end
end)

-- ================= TARGET VALIDATION =================
local function isValidTarget(plr)
    if not plr or plr == LocalPlayer or not plr.Character then return false end
    if Config.TeamCheck and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return false end

    local char = plr.Character
    local humanoid = safeFind(char, "Humanoid")
    local part = safeFind(char, Config.LockPart)
    if not humanoid or not part or humanoid.Health <= 0 then return false end

    local root = getRoot(LocalPlayer.Character)
    if not root then return false end

    local dist = (part.Position - root.Position).Magnitude
    if dist > 1000 then return false end

    -- FOV Check
    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if onScreen then
        local mousePos = Vector2.new(Mouse.X, Mouse.Y)
        local fovDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if fovDist > Config.FOVRadius then return false end
    end

    -- Wall Check
    if not Config.ThroughWalls then
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, char}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        local result = Workspace:Raycast(root.Position, part.Position - root.Position, rayParams)
        if result then return false end
    end

    return true, part
end

local function findNearestTarget()
    local root = getRoot(LocalPlayer.Character)
    if not root then return nil end

    local closest, closestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        local valid, part = isValidTarget(plr)
        if valid then
            local dist = (part.Position - root.Position).Magnitude
            if dist < closestDist then
                closest = plr
                closestDist = dist
            end
        end
    end
    return closest
end

-- ================= PREDICTION =================
local function predictPosition(part, velocityMultiplier)
    local humanoid = part.Parent:FindFirstChild("Humanoid")
    if not humanoid then return part.Position end
    local moveVector = humanoid.MoveDirection * (humanoid.WalkSpeed or 16) * Config.Prediction * velocityMultiplier
    return part.Position + moveVector
end

-- ================= SMOOTH CAMERA LOCK =================
local currentCFrame = Camera.CFrame

RunService.RenderStepped:Connect(function(dt)
    if Config.CamlockEnabled then
        if not State.LockedTarget or not isValidTarget(State.LockedTarget) then
            State.LockedTarget = findNearestTarget()
        end

        if State.LockedTarget then
            local char = State.LockedTarget.Character
            local part = safeFind(char, Config.LockPart)
            if part then
                local predicted = predictPosition(part, 1.2)
                local targetCFrame = CFrame.new(Camera.CFrame.Position, predicted)
                currentCFrame = currentCFrame:Lerp(targetCFrame, Config.Smoothness)
                Camera.CFrame = currentCFrame
            end
        end
    else
        State.LockedTarget = nil
    end
end)

-- ================= ESP SYSTEM =================
local ESPs = {}

local function createESP(plr)
    if ESPs[plr] or not plr.Character then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = plr.Character
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = ScreenGui

    local box = Drawing.new("Square")
    box.Thickness = 1.5
    box.Color = Color3.fromRGB(255, 100, 100)
    box.Filled = false
    box.Transparency = 1

    ESPs[plr] = {Highlight = highlight, Box = box}
end

local function removeESP(plr)
    if ESPs[plr] then
        ESPs[plr].Highlight:Destroy()
        ESPs[plr].Box:Remove()
        ESPs[plr] = nil
    end
end

RunService.RenderStepped:Connect(function()
    if not Config.EspEnabled then
        for plr, _ in pairs(ESPs) do
            removeESP(plr)
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local root = getRoot(plr.Character)
            local head = safeFind(plr.Character, "Head")
            if root and head then
                createESP(plr)
                local esp = ESPs[plr]

                -- Team Color
                local teamColor = (Config.TeamCheck and plr.Team == LocalPlayer.Team) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                esp.Highlight.FillColor = teamColor

                -- 2D Box
                local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
                local footPos, footOnScreen = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                if headOnScreen and footOnScreen then
                    local height = math.abs(headPos.Y - footPos.Y)
                    local width = height * 0.6
                    esp.Box.Size = Vector2.new(width, height)
                    esp.Box.Position = Vector2.new(headPos.X - width/2, headPos.Y)
                    esp.Box.Visible = true
                else
                    esp.Box.Visible = false
                end
            end
        else
            removeESP(plr)
        end
    end
end)

-- Cleanup
Players.PlayerRemoving:Connect(removeESP)
LocalPlayer.CharacterRemoving:Connect(function()
    task.wait(1)
    for plr, _ in pairs(ESPs) do removeESP(plr) end
end)
