local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

local function notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DYHUB",
            Text = text,
            Duration = 4
        })
    end)
end

notify("DYHUB Load! for Ninja Tycoon")

local gui = Instance.new("ScreenGui")
gui.Name = "DYHUB | Auto Money | Ninja Tycoon"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 220)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)

local borderStroke = Instance.new("UIStroke")
borderStroke.Parent = mainFrame
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Thickness = 3

local function getRainbowColor(t)
    local f = 2
    local r = math.floor(math.sin(f * t + 0) * 127 + 128)
    local g = math.floor(math.sin(f * t + 2) * 127 + 128)
    local b = math.floor(math.sin(f * t + 4) * 127 + 128)
    return Color3.fromRGB(r, g, b)
end

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Ninja Tycoon | DYHUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    title.TextColor3 = color
end)

-- ปุ่ม Shop
local shopButton = Instance.new("TextButton", mainFrame)
shopButton.Size = UDim2.new(0.7, 0, 0, 40)
shopButton.Position = UDim2.new(0.15, 0, 0, 45) -- ปรับตำแหน่งให้ไม่ทับหัวข้อ
shopButton.Text = "Shop"
shopButton.Font = Enum.Font.GothamBold
shopButton.TextScaled = true
shopButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
shopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", shopButton).CornerRadius = UDim.new(0, 10)

shopButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(
                770.946777, 712.082947, -502.886719,
                0.132966936, 2.47863152e-08, -0.991120458,
                2.42208422e-08, 1, 2.82578032e-08,
                0.991120458, -2.77631269e-08, 0.132966936
            )
            notify("📦 Teleported to Shop!")
        else
            notify("❌ HumanoidRootPart not found.")
        end
    else
        notify("❌ Character not found.")
    end
end)

local toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.Size = UDim2.new(0.7, 0, 0, 50)
toggleButton.Position = UDim2.new(0.15, 0, 0, 95) -- เลื่อนปุ่ม Auto Money ลงมา
toggleButton.Text = "Auto Money: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 10)

local delayBox = Instance.new("TextBox", mainFrame)
delayBox.Size = UDim2.new(0.7, 0, 0, 40)
delayBox.Position = UDim2.new(0.15, 0, 0, 150) -- เลื่อนกล่อง Delay ลงมาให้พอดี
delayBox.PlaceholderText = "Delay Multiplier (x1 ~ x69)"
delayBox.Text = "10"
delayBox.Font = Enum.Font.Gotham
delayBox.TextScaled = true
delayBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0, 10)

local warnLabel = Instance.new("TextLabel", mainFrame)
warnLabel.Size = UDim2.new(0.7, 0, 0, 30)
warnLabel.Position = UDim2.new(0.15, 0, 0, 195)
warnLabel.Text = "⚠️ Do not set above x69!"
warnLabel.Font = Enum.Font.GothamBold
warnLabel.TextScaled = true
warnLabel.BackgroundTransparency = 1
warnLabel.TextColor3 = Color3.fromRGB(255, 50, 50)

local autoMoney = false

toggleButton.MouseButton1Click:Connect(function()
    autoMoney = not autoMoney
    if autoMoney then
        toggleButton.Text = "Auto Money: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        notify("✅ Auto Money Enabled")

        task.spawn(function()
            while autoMoney do
                local multi = tonumber(delayBox.Text) or 1
                if multi > 69 then
                    multi = 69
                    delayBox.Text = "69"
                elseif multi < 1 then
                    multi = 1
                    delayBox.Text = "1"
                end

                local character = player.Character
                if character then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, prompt in pairs(workspace:GetDescendants()) do
                            if not autoMoney then break end
                            if prompt:IsA("ProximityPrompt") and prompt.Parent:IsA("BasePart") then
                                prompt.HoldDuration = 0
                                prompt.RequiresLineOfSight = false

                                local distance = (root.Position - prompt.Parent.Position).Magnitude
                                if distance <= prompt.MaxActivationDistance then
                                    for i = 1, multi do
                                        if not autoMoney then break end
                                        pcall(function()
                                            fireproximityprompt(prompt, 1, true)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end

                task.wait(0.05)
            end
        end)
    else
        toggleButton.Text = "Auto Money: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        notify("❌ Auto Money Disabled")
    end
end)
