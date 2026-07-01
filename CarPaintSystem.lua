-- Car Paint System
-- Beautiful UI for selecting paint colors and types with live preview

local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local CarPaintSystem = {
    Enabled = false,
    CurrentColor = Color3.fromRGB(255, 255, 255),
    CurrentPaintType = "Normal",
    CurrentVehicle = nil,
    PaintTypes = {"Normal", "Metallic", "Matte", "Shiny", "Aluminum"},
}

local PAINT_GUI_NAME = "CarPaintUI"
local BLUR_NAME = "PaintBlur"

-- Color presets for quick selection
local COLOR_PRESETS = {
    {name = "Red", color = Color3.fromRGB(255, 0, 0)},
    {name = "Blue", color = Color3.fromRGB(0, 0, 255)},
    {name = "Green", color = Color3.fromRGB(0, 255, 0)},
    {name = "Yellow", color = Color3.fromRGB(255, 255, 0)},
    {name = "Black", color = Color3.fromRGB(0, 0, 0)},
    {name = "White", color = Color3.fromRGB(255, 255, 255)},
    {name = "Purple", color = Color3.fromRGB(128, 0, 128)},
    {name = "Orange", color = Color3.fromRGB(255, 165, 0)},
    {name = "Pink", color = Color3.fromRGB(255, 192, 203)},
    {name = "Cyan", color = Color3.fromRGB(0, 255, 255)},
}

local function fireSetDirtEvent()
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Vehicles"):WaitForChild("SetDirt"):FireServer(-99)
    end)
end

local function fireSetPaintEvent(vehicle, color, paintType)
    if not vehicle or not vehicle.Parent then return false end
    
    local ok = pcall(function()
        local args = {
            "Car",
            vehicle,
            color,
            paintType
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Vehicles"):WaitForChild("SetPaint"):FireServer(unpack(args))
    end)
    
    return ok
end

local function addBlurEffect()
    local screenGui = PG:FindFirstChild(BLUR_NAME)
    if screenGui then screenGui:Destroy() end
    
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = BLUR_NAME
    screenGui.ResetOnSpawn = false
    screenGui.ZIndex = 100
    
    local blur = Instance.new("Frame")
    blur.Name = "Blur"
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blur.BackgroundTransparency = 0.5
    blur.BorderSizePixel = 0
    blur.ZIndex = 100
    blur.Parent = screenGui
    
    screenGui.Parent = PG
    return screenGui
end

local function removeBlurEffect()
    local blur = PG:FindFirstChild(BLUR_NAME)
    if blur then blur:Destroy() end
end

local function createColorPickerUI(onColorSelected, onPaintTypeSelected)
    local oldGui = PG:FindFirstChild(PAINT_GUI_NAME)
    if oldGui then oldGui:Destroy() end
    
    -- Add blur
    addBlurEffect()
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = PAINT_GUI_NAME
    screenGui.ResetOnSpawn = false
    screenGui.ZIndex = 101
    
    -- Main container
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(0, 500, 0, 600)
    mainContainer.Position = UDim2.new(0.5, -250, 0.5, -300)
    mainContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainContainer.BorderSizePixel = 0
    mainContainer.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainContainer
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    title.BorderSizePixel = 0
    title.Text = "Car Paint Customizer"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = mainContainer
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title
    
    -- Color gradient area
    local colorGradient = Instance.new("Frame")
    colorGradient.Name = "ColorGradient"
    colorGradient.Size = UDim2.new(1, -20, 0, 250)
    colorGradient.Position = UDim2.new(0, 10, 0, 60)
    colorGradient.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    colorGradient.BorderSizePixel = 0
    colorGradient.Parent = mainContainer
    
    local gradientCorner = Instance.new("UICorner")
    gradientCorner.CornerRadius = UDim.new(0, 8)
    gradientCorner.Parent = colorGradient
    
    -- Hue slider (horizontal)
    local hueSlider = Instance.new("Frame")
    hueSlider.Name = "HueSlider"
    hueSlider.Size = UDim2.new(1, -20, 0, 20)
    hueSlider.Position = UDim2.new(0, 10, 0, 320)
    hueSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    hueSlider.BorderSizePixel = 0
    hueSlider.Parent = mainContainer
    
    local hueCorner = Instance.new("UICorner")
    hueCorner.CornerRadius = UDim.new(0, 6)
    hueCorner.Parent = hueSlider
    
    -- Create gradient texture for hue
    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.84, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
    }
    hueGradient.Rotation = 90
    hueGradient.Parent = hueSlider
    
    -- Hue indicator
    local hueIndicator = Instance.new("Frame")
    hueIndicator.Name = "Indicator"
    hueIndicator.Size = UDim2.new(0, 3, 1, 0)
    hueIndicator.Position = UDim2.new(0, 0, 0, 0)
    hueIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueIndicator.BorderSizePixel = 0
    hueIndicator.Parent = hueSlider
    
    -- Paint type selector
    local typeLabel = Instance.new("TextLabel")
    typeLabel.Name = "TypeLabel"
    typeLabel.Size = UDim2.new(0.5, 0, 0, 30)
    typeLabel.Position = UDim2.new(0, 10, 0, 350)
    typeLabel.BackgroundTransparency = 1
    typeLabel.Text = "Paint Type:"
    typeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    typeLabel.TextSize = 14
    typeLabel.Font = Enum.Font.Gotham
    typeLabel.TextXAlignment = Enum.TextXAlignment.Left
    typeLabel.Parent = mainContainer
    
    local typeDropdown = Instance.new("Frame")
    typeDropdown.Name = "TypeDropdown"
    typeDropdown.Size = UDim2.new(0.4, 0, 0, 35)
    typeDropdown.Position = UDim2.new(0.55, 0, 0, 345)
    typeDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    typeDropdown.BorderSizePixel = 0
    typeDropdown.Parent = mainContainer
    
    local typeCorner = Instance.new("UICorner")
    typeCorner.CornerRadius = UDim.new(0, 6)
    typeCorner.Parent = typeDropdown
    
    local typeText = Instance.new("TextLabel")
    typeText.Name = "Text"
    typeText.Size = UDim2.new(1, -30, 1, 0)
    typeText.Position = UDim2.new(0, 10, 0, 0)
    typeText.BackgroundTransparency = 1
    typeText.Text = CarPaintSystem.CurrentPaintType
    typeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    typeText.TextSize = 14
    typeText.Font = Enum.Font.Gotham
    typeText.TextXAlignment = Enum.TextXAlignment.Left
    typeText.Parent = typeDropdown
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "Button"
    dropdownButton.Size = UDim2.new(0, 25, 1, 0)
    dropdownButton.Position = UDim2.new(1, -25, 0, 0)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = "▼"
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.TextSize = 12
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = typeDropdown
    
    -- Dropdown menu
    local dropdownMenu = Instance.new("Frame")
    dropdownMenu.Name = "Menu"
    dropdownMenu.Size = UDim2.new(0, 120, 0, 0)
    dropdownMenu.Position = UDim2.new(0, 0, 1, 5)
    dropdownMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropdownMenu.BorderSizePixel = 0
    dropdownMenu.ClipsDescendants = true
    dropdownMenu.Visible = false
    dropdownMenu.Parent = typeDropdown
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 6)
    menuCorner.Parent = dropdownMenu
    
    local menuLayout = Instance.new("UIListLayout")
    menuLayout.Padding = UDim.new(0, 2)
    menuLayout.Parent = dropdownMenu
    
    local function createTypeOption(typeName)
        local option = Instance.new("TextButton")
        option.Name = typeName
        option.Size = UDim2.new(1, 0, 0, 28)
        option.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        option.BorderSizePixel = 0
        option.Text = typeName
        option.TextColor3 = Color3.fromRGB(200, 200, 200)
        option.TextSize = 13
        option.Font = Enum.Font.Gotham
        
        option.MouseEnter:Connect(function()
            option.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        
        option.MouseLeave:Connect(function()
            option.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
        
        option.MouseButton1Click:Connect(function()
            CarPaintSystem.CurrentPaintType = typeName
            typeText.Text = typeName
            dropdownMenu.Visible = false
            onPaintTypeSelected(typeName)
        end)
        
        option.Parent = dropdownMenu
    end
    
    for _, paintType in ipairs(CarPaintSystem.PaintTypes) do
        createTypeOption(paintType)
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        dropdownMenu.Visible = not dropdownMenu.Visible
        if dropdownMenu.Visible then
            dropdownMenu.Size = UDim2.new(0, 120, 0, 28 * #CarPaintSystem.PaintTypes + 2 * (#CarPaintSystem.PaintTypes - 1))
        end
    end)
    
    -- Color presets
    local presetsLabel = Instance.new("TextLabel")
    presetsLabel.Name = "PresetsLabel"
    presetsLabel.Size = UDim2.new(1, 0, 0, 20)
    presetsLabel.Position = UDim2.new(0, 10, 0, 390)
    presetsLabel.BackgroundTransparency = 1
    presetsLabel.Text = "Quick Colors:"
    presetsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    presetsLabel.TextSize = 12
    presetsLabel.Font = Enum.Font.Gotham
    presetsLabel.TextXAlignment = Enum.TextXAlignment.Left
    presetsLabel.Parent = mainContainer
    
    local presetsContainer = Instance.new("Frame")
    presetsContainer.Name = "PresetsContainer"
    presetsContainer.Size = UDim2.new(1, -20, 0, 50)
    presetsContainer.Position = UDim2.new(0, 10, 0, 415)
    presetsContainer.BackgroundTransparency = 1
    presetsContainer.Parent = mainContainer
    
    local presetsLayout = Instance.new("UIGridLayout")
    presetsLayout.CellSize = UDim2.new(0, 40, 0, 40)
    presetsLayout.CellPadding = UDim2.new(0, 5, 0, 5)
    presetsLayout.Parent = presetsContainer
    
    local function createPresetButton(presetData)
        local presetBtn = Instance.new("TextButton")
        presetBtn.Name = presetData.name
        presetBtn.Size = UDim2.new(0, 40, 0, 40)
        presetBtn.BackgroundColor3 = presetData.color
        presetBtn.BorderSizePixel = 2
        presetBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
        presetBtn.Text = ""
        
        local presetCorner = Instance.new("UICorner")
        presetCorner.CornerRadius = UDim.new(0, 6)
        presetCorner.Parent = presetBtn
        
        presetBtn.MouseEnter:Connect(function()
            presetBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
            presetBtn.BorderSizePixel = 3
        end)
        
        presetBtn.MouseLeave:Connect(function()
            presetBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
            presetBtn.BorderSizePixel = 2
        end)
        
        presetBtn.MouseButton1Click:Connect(function()
            CarPaintSystem.CurrentColor = presetData.color
            onColorSelected(presetData.color)
        end)
        
        presetBtn.Parent = presetsContainer
    end
    
    for _, preset in ipairs(COLOR_PRESETS) do
        createPresetButton(preset)
    end
    
    -- Buttons container
    local buttonsContainer = Instance.new("Frame")
    buttonsContainer.Name = "ButtonsContainer"
    buttonsContainer.Size = UDim2.new(1, 0, 0, 50)
    buttonsContainer.Position = UDim2.new(0, 0, 1, -50)
    buttonsContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    buttonsContainer.BorderSizePixel = 0
    buttonsContainer.Parent = mainContainer
    
    local buttonsCorner = Instance.new("UICorner")
    buttonsCorner.CornerRadius = UDim.new(0, 12)
    buttonsCorner.Parent = buttonsContainer
    
    local applyBtn = Instance.new("TextButton")
    applyBtn.Name = "ApplyButton"
    applyBtn.Size = UDim2.new(0, 150, 0, 35)
    applyBtn.Position = UDim2.new(0, 20, 0.5, -17.5)
    applyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    applyBtn.BorderSizePixel = 0
    applyBtn.Text = "Apply Paint"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.TextSize = 14
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.Parent = buttonsContainer
    
    local applyCorner = Instance.new("UICorner")
    applyCorner.CornerRadius = UDim.new(0, 6)
    applyCorner.Parent = applyBtn
    
    applyBtn.MouseEnter:Connect(function()
        applyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
    end)
    
    applyBtn.MouseLeave:Connect(function()
        applyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    end)
    
    applyBtn.MouseButton1Click:Connect(function()
        fireSetDirtEvent()
        task.wait(0.2)
        fireSetPaintEvent(CarPaintSystem.CurrentVehicle, CarPaintSystem.CurrentColor, CarPaintSystem.CurrentPaintType)
        closeColorPicker()
    end)
    
    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Name = "CancelButton"
    cancelBtn.Size = UDim2.new(0, 150, 0, 35)
    cancelBtn.Position = UDim2.new(1, -170, 0.5, -17.5)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    cancelBtn.BorderSizePixel = 0
    cancelBtn.Text = "Cancel"
    cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelBtn.TextSize = 14
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.Parent = buttonsContainer
    
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 6)
    cancelCorner.Parent = cancelBtn
    
    cancelBtn.MouseEnter:Connect(function()
        cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
    end)
    
    cancelBtn.MouseLeave:Connect(function()
        cancelBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end)
    
    cancelBtn.MouseButton1Click:Connect(function()
        closeColorPicker()
    end)
    
    screenGui.Parent = PG
    return screenGui
end

function closeColorPicker()
    local gui = PG:FindFirstChild(PAINT_GUI_NAME)
    if gui then gui:Destroy() end
    removeBlurEffect()
end

function CarPaintSystem.OpenPainter(vehicle)
    if not vehicle or not vehicle.Parent then
        warn("Invalid vehicle")
        return
    end
    
    CarPaintSystem.CurrentVehicle = vehicle
    
    local onColorSelected = function(color)
        CarPaintSystem.CurrentColor = color
    end
    
    local onPaintTypeSelected = function(paintType)
        CarPaintSystem.CurrentPaintType = paintType
    end
    
    createColorPickerUI(onColorSelected, onPaintTypeSelected)
end

function CarPaintSystem.CreatePaintButton()
    local screenGui = PG:FindFirstChild("MainGui") or PG:FindFirstChild("STOP_USE_DEX")
    if not screenGui then return nil end
    
    local paintButtonContainer = Instance.new("Frame")
    paintButtonContainer.Name = "PaintButtonContainer"
    paintButtonContainer.Size = UDim2.new(0, 120, 0, 45)
    paintButtonContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    paintButtonContainer.BorderSizePixel = 0
    paintButtonContainer.Parent = screenGui
    
    local container_corner = Instance.new("UICorner")
    container_corner.CornerRadius = UDim.new(0, 8)
    container_corner.Parent = paintButtonContainer
    
    -- Color indicator circle
    local colorIndicator = Instance.new("Frame")
    colorIndicator.Name = "ColorIndicator"
    colorIndicator.Size = UDim2.new(0, 25, 0, 25)
    colorIndicator.Position = UDim2.new(0, 8, 0.5, -12.5)
    colorIndicator.BackgroundColor3 = CarPaintSystem.CurrentColor
    colorIndicator.BorderSizePixel = 0
    colorIndicator.Parent = paintButtonContainer
    
    local indicator_corner = Instance.new("UICorner")
    indicator_corner.CornerRadius = UDim.new(0.5, 0)
    indicator_corner.Parent = colorIndicator
    
    -- Paint button
    local paintBtn = Instance.new("TextButton")
    paintBtn.Name = "PaintButton"
    paintBtn.Size = UDim2.new(1, -40, 1, 0)
    paintBtn.Position = UDim2.new(0, 35, 0, 0)
    paintBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    paintBtn.BorderSizePixel = 0
    paintBtn.Text = "Car Paint"
    paintBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    paintBtn.TextSize = 12
    paintBtn.Font = Enum.Font.GothamBold
    paintBtn.Parent = paintButtonContainer
    
    local btn_corner = Instance.new("UICorner")
    btn_corner.CornerRadius = UDim.new(0, 6)
    btn_corner.Parent = paintBtn
    
    paintBtn.MouseEnter:Connect(function()
        paintBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    
    paintBtn.MouseLeave:Connect(function()
        paintBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    paintBtn.MouseButton1Click:Connect(function()
        local vehicleId = nil
        pcall(function()
            local gui, _ = getAChassis()
            if gui then
                local carVal = gui:FindFirstChild("Car", true)
                if carVal then
                    vehicleId = carVal.Value
                end
            end
        end)
        
        if vehicleId then
            CarPaintSystem.OpenPainter(vehicleId)
        end
    end)
    
    return paintButtonContainer, colorIndicator
end

return CarPaintSystem
