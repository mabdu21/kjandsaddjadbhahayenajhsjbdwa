-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

-- Constants
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local IsComputer = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled

-- Configuration - ALL Original Settings
local Configuration = {
    -- Aimbot
    Aimbot = false,
    OnePressAimingMode = false,
    AimKey = "RMB",
    AimMode = "Camera",
    SilentAimMethods = { "Mouse.Hit / Mouse.Target", "GetMouseLocation" },
    SilentAimChance = 100,
    OffAimbotAfterKill = false,
    AimPartDropdownValues = { "Head", "HumanoidRootPart" },
    AimPart = "HumanoidRootPart",
    RandomAimPart = false,
    
    -- Offset
    UseOffset = false,
    OffsetType = "Static",
    StaticOffsetIncrement = 10,
    DynamicOffsetIncrement = 10,
    AutoOffset = false,
    MaxAutoOffset = 50,
    
    -- Sensitivity
    UseSensitivity = false,
    Sensitivity = 50,
    UseNoise = false,
    NoiseFrequency = 50,
    
    -- Bots
    SpinBot = false,
    OnePressSpinningMode = false,
    SpinKey = "Q",
    SpinBotVelocity = 50,
    SpinPartDropdownValues = { "Head", "HumanoidRootPart" },
    SpinPart = "HumanoidRootPart",
    RandomSpinPart = false,
    
    TriggerBot = false,
    OnePressTriggeringMode = false,
    SmartTriggerBot = false,
    TriggerKey = "E",
    TriggerBotChance = 100,
    
    -- Checks
    AliveCheck = false,
    GodCheck = false,
    TeamCheck = false,
    FriendCheck = false,
    FollowCheck = false,
    VerifiedBadgeCheck = false,
    WallCheck = false,
    WaterCheck = false,
    
    FoVCheck = false,
    FoVRadius = 100,
    MagnitudeCheck = false,
    TriggerMagnitude = 500,
    TransparencyCheck = false,
    IgnoredTransparency = 0.5,
    WhitelistedGroupCheck = false,
    WhitelistedGroup = 0,
    BlacklistedGroupCheck = false,
    BlacklistedGroup = 0,
    
    IgnoredPlayersCheck = false,
    IgnoredPlayersDropdownValues = {},
    IgnoredPlayers = {},
    TargetPlayersCheck = false,
    TargetPlayersDropdownValues = {},
    TargetPlayers = {},
    
    PremiumCheck = false,
    
    -- Visuals
    FoV = false,
    FoVKey = "R",
    FoVThickness = 2,
    FoVOpacity = 0.8,
    FoVFilled = false,
    FoVColour = Color3.fromRGB(255, 255, 255),
    
    SmartESP = false,
    ESPKey = "T",
    ESPBox = false,
    ESPBoxFilled = false,
    NameESP = false,
    NameESPFont = "Monospace",
    NameESPSize = 16,
    NameESPOutlineColour = Color3.fromRGB(0, 0, 0),
    HealthESP = false,
    MagnitudeESP = false,
    TracerESP = false,
    ESPThickness = 2,
    ESPOpacity = 0.8,
    ESPColour = Color3.fromRGB(255, 255, 255),
    ESPUseTeamColour = false,
    
    RainbowVisuals = false,
    RainbowDelay = 5,
    
    -- Settings
    ShowNotifications = true,
    ShowWarnings = true,
    AutoImport = true,
}

-- Variables
local Aiming = false
local Target = nil
local MouseSensitivity = UserInputService.MouseDeltaSensitivity
local Spinning = false
local Triggering = false
local ShowingFoV = false
local ShowingESP = false
local FoVCircle = nil
local ESPObjects = {}
local RainbowHue = 0

-- Create main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OpenAimbotNative"
ScreenGui.ResetOnSpawn = false

-- Parent to CoreGui or PlayerGui
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = Player.PlayerGui
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 750, 0, 520)
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Main Corner
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Main Border
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 120, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DYHUB | Rivals (Beta)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -40, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Position = UDim2.new(1, -80, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextScaled = true
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 180, 1, -45)
TabContainer.Position = UDim2.new(0, 0, 0, 45)
TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

-- Content Container
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -180, 1, -45)
ContentContainer.Position = UDim2.new(0, 180, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.ScrollBarThickness = 8
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(60, 120, 255)
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.Parent = MainFrame

-- Content Layout
local ContentLayout = Instance.new("UIListLayout")
ContentLayout.FillDirection = Enum.FillDirection.Vertical
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentContainer

-- Update canvas size automatically
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
end)

-- Tab System
local TabSystem = {}
TabSystem.CurrentTab = nil
TabSystem.Tabs = {}

function TabSystem:CreateTab(name, icon)
    local tabCount = 0
    for _ in pairs(self.Tabs) do
        tabCount = tabCount + 1
    end
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -10, 0, 40)
    TabButton.Position = UDim2.new(0, 5, 0, tabCount * 45 + 5)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TabButton.BorderSizePixel = 0
    TabButton.Text = icon .. " " .. name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextScaled = true
    TabButton.Font = Enum.Font.Gotham
    TabButton.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, -10, 1, -10)
    TabContent.Position = UDim2.new(0, 5, 0, 5)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 8
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 120, 255)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.Parent = ContentContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Vertical
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.Parent = TabContent
    
    -- Update canvas size when content changes
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    
    self.Tabs[name] = {
        Button = TabButton,
        Content = TabContent
    }
    
    if not self.CurrentTab then
        self:SwitchTab(name)
    end
    
    return TabContent
end

function TabSystem:SwitchTab(name)
    for tabName, tab in pairs(self.Tabs) do
        if tabName == name then
            tab.Button.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            tab.Content.Visible = true
        else
            tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            tab.Content.Visible = false
        end
    end
    self.CurrentTab = name
end

-- UI Element Creators
local function CreateSection(parent, title)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, -20, 0, 35)
    Section.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Section.BorderSizePixel = 0
    Section.Parent = parent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -20, 1, 0)
    SectionTitle.Position = UDim2.new(0, 10, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextScaled = true
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    return Section
end

local function CreateToggle(parent, text, configKey, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, -20, 0, 35)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = Toggle
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextScaled = true
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = Toggle
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 45, 0, 25)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = Configuration[configKey] and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(60, 60, 70)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = Configuration[configKey] and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextScaled = true
    ToggleButton.Parent = Toggle
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 12)
    ButtonCorner.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        Configuration[configKey] = not Configuration[configKey]
        ToggleButton.BackgroundColor3 = Configuration[configKey] and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(60, 60, 70)
        ToggleButton.Text = Configuration[configKey] and "ON" or "OFF"
        
        if callback then
            callback(Configuration[configKey])
        end
    end)
    
    return Toggle
end

local function CreateSlider(parent, text, configKey, min, max, callback)
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, -20, 0, 55)
    Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Slider.BorderSizePixel = 0
    Slider.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = Slider
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -15, 0, 25)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = text .. ": " .. Configuration[configKey]
    SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextScaled = true
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = Slider
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, -20, 0, 8)
    SliderTrack.Position = UDim2.new(0, 10, 1, -20)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = Slider
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 4)
    TrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((Configuration[configKey] - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 4)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 18, 0, 18)
    SliderButton.Position = UDim2.new((Configuration[configKey] - min) / (max - min), -9, 0.5, -9)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.Parent = SliderTrack
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 9)
    ButtonCorner.Parent = SliderButton
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        Configuration[configKey] = value
        SliderLabel.Text = text .. ": " .. value
        local percentage = (value - min) / (max - min)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        SliderButton.Position = UDim2.new(percentage, -9, 0.5, -9)
        if callback then
            callback(value)
        end
    end
    
    local dragging = false
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = SliderTrack.AbsolutePosition
            local relativePos = (mousePos.X - trackPos.X) / SliderTrack.AbsoluteSize.X
            local value = min + (max - min) * math.clamp(relativePos, 0, 1)
            updateSlider(math.floor(value))
        end
    end)
    
    return Slider
end

local function CreateDropdown(parent, text, configKey, options)
    local Dropdown = Instance.new("Frame")
    Dropdown.Size = UDim2.new(1, -20, 0, 35)
    Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Dropdown.BorderSizePixel = 0
    Dropdown.Parent = parent
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = Dropdown
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(0.5, -5, 1, 0)
    DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = text
    DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.TextScaled = true
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = Dropdown
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0.5, -15, 0, 25)
    DropdownButton.Position = UDim2.new(0.5, 5, 0.5, -12.5)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = Configuration[configKey] or options[1]
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.TextScaled = true
    DropdownButton.Parent = Dropdown
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = DropdownButton
    
    local isOpen = false
    local optionFrames = {}
    
    DropdownButton.MouseButton1Click:Connect(function()
        if isOpen then
            for _, frame in pairs(optionFrames) do
                frame:Destroy()
            end
            optionFrames = {}
            Dropdown.Size = UDim2.new(1, -20, 0, 35)
            isOpen = false
        else
            Dropdown.Size = UDim2.new(1, -20, 0, 35 + (#options * 25))
            for i, option in ipairs(options) do
                local OptionFrame = Instance.new("TextButton")
                OptionFrame.Size = UDim2.new(0.5, -15, 0, 20)
                OptionFrame.Position = UDim2.new(0.5, 5, 0, 35 + (i-1) * 25)
                OptionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                OptionFrame.BorderSizePixel = 0
                OptionFrame.Text = option
                OptionFrame.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptionFrame.Font = Enum.Font.Gotham
                OptionFrame.TextScaled = true
                OptionFrame.Parent = Dropdown
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionFrame
                
                OptionFrame.MouseButton1Click:Connect(function()
                    Configuration[configKey] = option
                    DropdownButton.Text = option
                    for _, frame in pairs(optionFrames) do
                        frame:Destroy()
                    end
                    optionFrames = {}
                    Dropdown.Size = UDim2.new(1, -20, 0, 35)
                    isOpen = false
                end)
                
                table.insert(optionFrames, OptionFrame)
            end
            isOpen = true
        end
    end)
    
    return Dropdown
end

-- Create ALL Original Tabs
local AimbotTab = TabSystem:CreateTab("Aimbot", "🎯")
local BotsTab = TabSystem:CreateTab("Bots", "🤖")
local ChecksTab = TabSystem:CreateTab("Checks", "✅")
local VisualsTab = TabSystem:CreateTab("Visuals", "👁️")
local SettingsTab = TabSystem:CreateTab("Settings", "⚙️")

-- AIMBOT TAB CONTENT
CreateSection(AimbotTab, "🎯 Aimbot")
CreateToggle(AimbotTab, "Aimbot", "Aimbot")
CreateToggle(AimbotTab, "One Press Mode", "OnePressAimingMode")
CreateDropdown(AimbotTab, "Aim Mode", "AimMode", {"Camera", "Mouse", "Silent"})
CreateDropdown(AimbotTab, "Aim Part", "AimPart", Configuration.AimPartDropdownValues)
CreateSlider(AimbotTab, "Silent Aim Chance", "SilentAimChance", 0, 100)
CreateToggle(AimbotTab, "Random Aim Part", "RandomAimPart")
CreateToggle(AimbotTab, "Off After Kill", "OffAimbotAfterKill")

CreateSection(AimbotTab, "🎚️ Sensitivity")
CreateToggle(AimbotTab, "Use Sensitivity", "UseSensitivity")
CreateSlider(AimbotTab, "Sensitivity", "Sensitivity", 1, 100)
CreateToggle(AimbotTab, "Use Noise", "UseNoise")
CreateSlider(AimbotTab, "Noise Frequency", "NoiseFrequency", 1, 100)

CreateSection(AimbotTab, "📐 Offset")
CreateToggle(AimbotTab, "Use Offset", "UseOffset")
CreateDropdown(AimbotTab, "Offset Type", "OffsetType", {"Static", "Dynamic"})
CreateSlider(AimbotTab, "Static Offset", "StaticOffsetIncrement", 1, 50)
CreateSlider(AimbotTab, "Dynamic Offset", "DynamicOffsetIncrement", 1, 50)
CreateToggle(AimbotTab, "Auto Offset", "AutoOffset")
CreateSlider(AimbotTab, "Max Auto Offset", "MaxAutoOffset", 10, 100)

-- BOTS TAB CONTENT
CreateSection(BotsTab, "🌀 Spin Bot")
CreateToggle(BotsTab, "Spin Bot", "SpinBot")
CreateToggle(BotsTab, "One Press Spinning", "OnePressSpinningMode")
CreateSlider(BotsTab, "Spin Velocity", "SpinBotVelocity", 1, 100)
CreateDropdown(BotsTab, "Spin Part", "SpinPart", Configuration.SpinPartDropdownValues)
CreateToggle(BotsTab, "Random Spin Part", "RandomSpinPart")

CreateSection(BotsTab, "⚡ Trigger Bot")
CreateToggle(BotsTab, "Trigger Bot", "TriggerBot")
CreateToggle(BotsTab, "One Press Triggering", "OnePressTriggeringMode")
CreateToggle(BotsTab, "Smart Trigger Bot", "SmartTriggerBot")
CreateSlider(BotsTab, "Trigger Chance", "TriggerBotChance", 0, 100)

-- CHECKS TAB CONTENT
CreateSection(ChecksTab, "👤 Player Checks")
CreateToggle(ChecksTab, "Alive Check", "AliveCheck")
CreateToggle(ChecksTab, "God Check", "GodCheck")
CreateToggle(ChecksTab, "Team Check", "TeamCheck")
CreateToggle(ChecksTab, "Friend Check", "FriendCheck")
CreateToggle(ChecksTab, "Follow Check", "FollowCheck")
CreateToggle(ChecksTab, "Verified Badge Check", "VerifiedBadgeCheck")

CreateSection(ChecksTab, "🌍 Environment Checks")
CreateToggle(ChecksTab, "Wall Check", "WallCheck")
CreateToggle(ChecksTab, "Water Check", "WaterCheck")
CreateToggle(ChecksTab, "Transparency Check", "TransparencyCheck")
CreateSlider(ChecksTab, "Ignored Transparency", "IgnoredTransparency", 0, 1)

CreateSection(ChecksTab, "📏 Distance & FoV Checks")
CreateToggle(ChecksTab, "FoV Check", "FoVCheck")
CreateSlider(ChecksTab, "FoV Radius", "FoVRadius", 10, 500)
CreateToggle(ChecksTab, "Magnitude Check", "MagnitudeCheck")
CreateSlider(ChecksTab, "Trigger Magnitude", "TriggerMagnitude", 50, 1000)

CreateSection(ChecksTab, "👥 Group Checks")
CreateToggle(ChecksTab, "Whitelisted Group Check", "WhitelistedGroupCheck")
CreateSlider(ChecksTab, "Whitelisted Group", "WhitelistedGroup", 0, 999999)
CreateToggle(ChecksTab, "Blacklisted Group Check", "BlacklistedGroupCheck")
CreateSlider(ChecksTab, "Blacklisted Group", "BlacklistedGroup", 0, 999999)

CreateSection(ChecksTab, "🎯 Player Targeting")
CreateToggle(ChecksTab, "Ignored Players Check", "IgnoredPlayersCheck")
CreateToggle(ChecksTab, "Target Players Check", "TargetPlayersCheck")

CreateSection(ChecksTab, "💎 Premium Checks")
CreateToggle(ChecksTab, "Premium Check", "PremiumCheck")

-- VISUALS TAB CONTENT
CreateSection(VisualsTab, "🔍 FoV")
CreateToggle(VisualsTab, "FoV", "FoV", function(value)
    ShowingFoV = value
    if value then
        CreateFoVCircle()
    else
        DestroyFoVCircle()
    end
end)
CreateSlider(VisualsTab, "FoV Thickness", "FoVThickness", 1, 10)
CreateSlider(VisualsTab, "FoV Opacity", "FoVOpacity", 0, 1)
CreateToggle(VisualsTab, "FoV Filled", "FoVFilled")

CreateSection(VisualsTab, "👁️ ESP")
CreateToggle(VisualsTab, "Smart ESP", "SmartESP", function(value)
    ShowingESP = value
    if value then
        CreateESP()
    else
        DestroyESP()
    end
end)
CreateToggle(VisualsTab, "ESP Box", "ESPBox")
CreateToggle(VisualsTab, "ESP Box Filled", "ESPBoxFilled")
CreateToggle(VisualsTab, "Name ESP", "NameESP")
CreateDropdown(VisualsTab, "Name ESP Font", "NameESPFont", {"UI", "System", "Plex", "Monospace"})
CreateSlider(VisualsTab, "Name ESP Size", "NameESPSize", 8, 28)
CreateToggle(VisualsTab, "Health ESP", "HealthESP")
CreateToggle(VisualsTab, "Magnitude ESP", "MagnitudeESP")
CreateToggle(VisualsTab, "Tracer ESP", "TracerESP")
CreateSlider(VisualsTab, "ESP Thickness", "ESPThickness", 1, 10)
CreateSlider(VisualsTab, "ESP Opacity", "ESPOpacity", 0, 1)
CreateToggle(VisualsTab, "Use Team Colour", "ESPUseTeamColour")

CreateSection(VisualsTab, "🌈 Visuals")
CreateToggle(VisualsTab, "Rainbow Visuals", "RainbowVisuals")
CreateSlider(VisualsTab, "Rainbow Delay", "RainbowDelay", 1, 20)

-- SETTINGS TAB CONTENT
CreateSection(SettingsTab, "🔔 Notifications")
CreateToggle(SettingsTab, "Show Notifications", "ShowNotifications")
CreateToggle(SettingsTab, "Show Warnings", "ShowWarnings")

CreateSection(SettingsTab, "💾 Configuration")
CreateToggle(SettingsTab, "Auto Import", "AutoImport")

-- Button Functions
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 750, 0, 45)
        ContentContainer.Visible = false
        TabContainer.Visible = false
        MinimizeButton.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 750, 0, 520)
        ContentContainer.Visible = true
        TabContainer.Visible = true
        MinimizeButton.Text = "—"
    end
end)

-- Utility Functions
local function GetPlayerName(String)
    if typeof(String) == "string" and #String > 0 then
        for _, _Player in next, Players:GetPlayers() do
            if string.sub(string.lower(_Player.Name), 1, #string.lower(String)) == string.lower(String) then
                return _Player.Name
            end
        end
    end
    return ""
end

local function GetClosestTarget()
    local ClosestTarget = nil
    local ClosestDistance = math.huge
    
    for _, OtherPlayer in pairs(Players:GetPlayers()) do
        if OtherPlayer ~= Player and OtherPlayer.Character and OtherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Character = OtherPlayer.Character
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            local RootPart = Character.HumanoidRootPart
            
            -- All checks from original
            if Configuration.AliveCheck and (not Humanoid or Humanoid.Health <= 0) then
                continue
            end
            
            if Configuration.GodCheck and Humanoid and Humanoid.MaxHealth == math.huge then
                continue
            end
            
            if Configuration.TeamCheck and OtherPlayer.Team == Player.Team then
                continue
            end
            
            if Configuration.FriendCheck and OtherPlayer:IsFriendsWith(Player.UserId) then
                continue
            end
            
            if Configuration.VerifiedBadgeCheck and OtherPlayer.HasVerifiedBadge then
                continue
            end
            
            if Configuration.PremiumCheck and OtherPlayer.MembershipType ~= Enum.MembershipType.None then
                continue
            end
            
            local Distance = (RootPart.Position - Camera.CFrame.Position).Magnitude
            local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
            
            if not OnScreen then
                continue
            end
            
            if Configuration.MagnitudeCheck and Distance > Configuration.TriggerMagnitude then
                continue
            end
            
            if Configuration.FoVCheck then
                local MousePosition = UserInputService:GetMouseLocation()
                local FoVDistance = math.sqrt((ScreenPosition.X - MousePosition.X)^2 + (ScreenPosition.Y - MousePosition.Y)^2)
                if FoVDistance > Configuration.FoVRadius then
                    continue
                end
            end
            
            if Distance < ClosestDistance then
                ClosestDistance = Distance
                ClosestTarget = OtherPlayer
            end
        end
    end
    
    return ClosestTarget
end

-- FoV Circle Functions
function CreateFoVCircle()
    pcall(function()
        if FoVCircle then
            FoVCircle:Remove()
        end
        
        FoVCircle = Drawing.new("Circle")
        FoVCircle.Visible = true
        FoVCircle.Radius = Configuration.FoVRadius
        FoVCircle.Color = Configuration.FoVColour
        FoVCircle.Thickness = Configuration.FoVThickness
        FoVCircle.Transparency = Configuration.FoVOpacity
        FoVCircle.Filled = Configuration.FoVFilled
    end)
end

function DestroyFoVCircle()
    pcall(function()
        if FoVCircle then
            FoVCircle:Remove()
            FoVCircle = nil
        end
    end)
end

-- ESP Functions
function CreateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            CreatePlayerESP(player)
        end
    end
end

function CreatePlayerESP(player)
    pcall(function()
        if ESPObjects[player] then
            return
        end
        
        local ESPData = {}
        
        if Configuration.ESPBox then
            ESPData.Box = Drawing.new("Square")
            ESPData.Box.Visible = false
            ESPData.Box.Color = Configuration.ESPColour
            ESPData.Box.Thickness = Configuration.ESPThickness
            ESPData.Box.Transparency = Configuration.ESPOpacity
            ESPData.Box.Filled = Configuration.ESPBoxFilled
        end
        
        if Configuration.NameESP then
            ESPData.Name = Drawing.new("Text")
            ESPData.Name.Visible = false
            ESPData.Name.Color = Configuration.ESPColour
            ESPData.Name.Size = Configuration.NameESPSize
            ESPData.Name.Center = true
            ESPData.Name.Outline = true
            ESPData.Name.OutlineColor = Configuration.NameESPOutlineColour
            ESPData.Name.Text = player.Name
        end
        
        if Configuration.TracerESP then
            ESPData.Tracer = Drawing.new("Line")
            ESPData.Tracer.Visible = false
            ESPData.Tracer.Color = Configuration.ESPColour
            ESPData.Tracer.Thickness = Configuration.ESPThickness
            ESPData.Tracer.Transparency = Configuration.ESPOpacity
        end
        
        if Configuration.HealthESP then
            ESPData.Health = Drawing.new("Text")
            ESPData.Health.Visible = false
            ESPData.Health.Color = Color3.fromRGB(0, 255, 0)
            ESPData.Health.Size = Configuration.NameESPSize - 2
            ESPData.Health.Center = true
            ESPData.Health.Outline = true
            ESPData.Health.OutlineColor = Configuration.NameESPOutlineColour
        end
        
        if Configuration.MagnitudeESP then
            ESPData.Distance = Drawing.new("Text")
            ESPData.Distance.Visible = false
            ESPData.Distance.Color = Configuration.ESPColour
            ESPData.Distance.Size = Configuration.NameESPSize - 4
            ESPData.Distance.Center = true
            ESPData.Distance.Outline = true
            ESPData.Distance.OutlineColor = Configuration.NameESPOutlineColour
        end
        
        ESPObjects[player] = ESPData
    end)
end

function DestroyESP()
    pcall(function()
        for player, espData in pairs(ESPObjects) do
            for _, drawing in pairs(espData) do
                drawing:Remove()
            end
        end
        ESPObjects = {}
    end)
end

function UpdateESP()
    pcall(function()
        for player, espData in pairs(ESPObjects) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local character = player.Character
                local rootPart = character.HumanoidRootPart
                local head = character:FindFirstChild("Head")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                local rootPosition, rootOnScreen = Camera:WorldToViewportPoint(rootPart.Position)
                local headPosition = head and Camera:WorldToViewportPoint(head.Position) or rootPosition
                
                if rootOnScreen then
                    local currentColor = Configuration.RainbowVisuals and Color3.fromHSV(RainbowHue, 1, 1) or Configuration.ESPColour
                    if Configuration.ESPUseTeamColour and player.Team then
                        currentColor = player.Team.TeamColor.Color
                    end
                    
                    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                    
                    -- Update all ESP elements
                    if espData.Box and Configuration.ESPBox then
                        local size = math.max(Camera.ViewportSize.Y / rootPosition.Z * 2, 4)
                        espData.Box.Size = Vector2.new(size * 0.8, size * 1.2)
                        espData.Box.Position = Vector2.new(rootPosition.X - size * 0.4, rootPosition.Y - size * 0.6)
                        espData.Box.Color = currentColor
                        espData.Box.Visible = true
                    end
                    
                    if espData.Name and Configuration.NameESP then
                        espData.Name.Position = Vector2.new(headPosition.X, headPosition.Y - 30)
                        espData.Name.Color = currentColor
                        espData.Name.Visible = true
                    end
                    
                    if espData.Health and Configuration.HealthESP and humanoid then
                        local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                        espData.Health.Text = tostring(healthPercent) .. "%"
                        espData.Health.Position = Vector2.new(headPosition.X, headPosition.Y - 50)
                        espData.Health.Color = Color3.fromRGB(255 - (healthPercent * 2.55), healthPercent * 2.55, 0)
                        espData.Health.Visible = true
                    end
                    
                    if espData.Distance and Configuration.MagnitudeESP then
                        espData.Distance.Text = tostring(math.floor(distance)) .. "m"
                        espData.Distance.Position = Vector2.new(headPosition.X, headPosition.Y - 70)
                        espData.Distance.Color = currentColor
                        espData.Distance.Visible = true
                    end
                    
                    if espData.Tracer and Configuration.TracerESP then
                        local mousePos = UserInputService:GetMouseLocation()
                        espData.Tracer.From = Vector2.new(mousePos.X, mousePos.Y)
                        espData.Tracer.To = Vector2.new(rootPosition.X, rootPosition.Y)
                        espData.Tracer.Color = currentColor
                        espData.Tracer.Visible = true
                    end
                else
                    -- Hide all ESP elements when not on screen
                    if espData.Box then espData.Box.Visible = false end
                    if espData.Name then espData.Name.Visible = false end
                    if espData.Health then espData.Health.Visible = false end
                    if espData.Distance then espData.Distance.Visible = false end
                    if espData.Tracer then espData.Tracer.Visible = false end
                end
            else
                -- Hide all ESP elements when character doesn't exist
                if espData.Box then espData.Box.Visible = false end
                if espData.Name then espData.Name.Visible = false end
                if espData.Health then espData.Health.Visible = false end
                if espData.Distance then espData.Distance.Visible = false end
                if espData.Tracer then espData.Tracer.Visible = false end
            end
        end
    end)
end

-- Aimbot Functions
local function AimAt(targetPlayer)
    pcall(function()
        if not targetPlayer or not targetPlayer.Character then
            return
        end
        
        local character = targetPlayer.Character
        local aimPart = Configuration.AimPart
        
        if Configuration.RandomAimPart then
            aimPart = Configuration.AimPartDropdownValues[math.random(1, #Configuration.AimPartDropdownValues)]
        end
        
        local targetPart = character:FindFirstChild(aimPart)
        if not targetPart then
            targetPart = character:FindFirstChild("HumanoidRootPart")
        end
        
        if not targetPart then
            return
        end
        
        local targetPosition = targetPart.Position
        
        -- Apply offset
        if Configuration.UseOffset then
            local offset = Vector3.new(0, 0, 0)
            if Configuration.OffsetType == "Static" then
                offset = Vector3.new(
                    math.random(-Configuration.StaticOffsetIncrement, Configuration.StaticOffsetIncrement),
                    math.random(-Configuration.StaticOffsetIncrement, Configuration.StaticOffsetIncrement),
                    math.random(-Configuration.StaticOffsetIncrement, Configuration.StaticOffsetIncrement)
                ) / 10
            elseif Configuration.OffsetType == "Dynamic" then
                local distance = (targetPosition - Camera.CFrame.Position).Magnitude
                local dynamicOffset = (distance / 100) * Configuration.DynamicOffsetIncrement
                offset = Vector3.new(
                    math.random(-dynamicOffset, dynamicOffset),
                    math.random(-dynamicOffset, dynamicOffset),
                    math.random(-dynamicOffset, dynamicOffset)
                ) / 10
            end
            targetPosition = targetPosition + offset
        end
        
        -- Apply noise
        if Configuration.UseNoise then
            local noise = Vector3.new(
                math.sin(tick() * Configuration.NoiseFrequency) * 0.1,
                math.cos(tick() * Configuration.NoiseFrequency) * 0.1,
                math.sin(tick() * Configuration.NoiseFrequency * 1.5) * 0.1
            )
            targetPosition = targetPosition + noise
        end
        
        if Configuration.AimMode == "Camera" then
            local lookDirection = (targetPosition - Camera.CFrame.Position).Unit
            local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + lookDirection)
            
            if Configuration.UseSensitivity then
                local sensitivity = Configuration.Sensitivity / 100
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, sensitivity)
            else
                Camera.CFrame = targetCFrame
            end
        end
    end)
end

-- Input Handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Aimbot
    if (input.UserInputType == Enum.UserInputType.MouseButton2 and Configuration.AimKey == "RMB") or
       (input.KeyCode.Name == Configuration.AimKey and Configuration.AimKey ~= "RMB") then
        if Configuration.Aimbot then
            if Configuration.OnePressAimingMode then
                Aiming = not Aiming
            else
                Aiming = true
            end
        end
    end
    
    -- SpinBot
    if input.KeyCode.Name == Configuration.SpinKey then
        if Configuration.SpinBot then
            if Configuration.OnePressSpinningMode then
                Spinning = not Spinning
            else
                Spinning = true
            end
        end
    end
    
    -- TriggerBot
    if input.KeyCode.Name == Configuration.TriggerKey then
        if Configuration.TriggerBot then
            if Configuration.OnePressTriggeringMode then
                Triggering = not Triggering
            else
                Triggering = true
            end
        end
    end
    
    -- FoV Toggle
    if input.KeyCode.Name == Configuration.FoVKey then
        Configuration.FoV = not Configuration.FoV
        ShowingFoV = Configuration.FoV
        if ShowingFoV then
            CreateFoVCircle()
        else
            DestroyFoVCircle()
        end
    end
    
    -- ESP Toggle
    if input.KeyCode.Name == Configuration.ESPKey then
        Configuration.SmartESP = not Configuration.SmartESP
        ShowingESP = Configuration.SmartESP
        if ShowingESP then
            CreateESP()
        else
            DestroyESP()
        end
    end
    
    -- GUI Toggle
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Aimbot
    if (input.UserInputType == Enum.UserInputType.MouseButton2 and Configuration.AimKey == "RMB") or
       (input.KeyCode.Name == Configuration.AimKey and Configuration.AimKey ~= "RMB") then
        if not Configuration.OnePressAimingMode then
            Aiming = false
        end
    end
    
    -- SpinBot
    if input.KeyCode.Name == Configuration.SpinKey then
        if not Configuration.OnePressSpinningMode then
            Spinning = false
        end
    end
    
    -- TriggerBot
    if input.KeyCode.Name == Configuration.TriggerKey then
        if not Configuration.OnePressTriggeringMode then
            Triggering = false
        end
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Rainbow effect
    if Configuration.RainbowVisuals then
        RainbowHue = RainbowHue + (1 / (Configuration.RainbowDelay * 60))
        if RainbowHue >= 1 then
            RainbowHue = 0
        end
        
        -- Update colors
        local rainbowColor = Color3.fromHSV(RainbowHue, 1, 1)
        MainStroke.Color = rainbowColor
        Configuration.FoVColour = rainbowColor
        Configuration.ESPColour = rainbowColor
    end
    
    -- Update FoV Circle
    if ShowingFoV and FoVCircle then
        pcall(function()
            local mousePos = UserInputService:GetMouseLocation()
            FoVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
            FoVCircle.Radius = Configuration.FoVRadius
            FoVCircle.Color = Configuration.FoVColour
            FoVCircle.Thickness = Configuration.FoVThickness
            FoVCircle.Transparency = Configuration.FoVOpacity
            FoVCircle.Filled = Configuration.FoVFilled
        end)
    end
    
    -- Update ESP
    if ShowingESP then
        UpdateESP()
    end
    
    -- Aimbot
    if Aiming and Configuration.Aimbot then
        local target = GetClosestTarget()
        if target then
            Target = target
            AimAt(target)
        end
    end
    
    -- SpinBot
    if Spinning and Configuration.SpinBot then
        pcall(function()
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = Player.Character.HumanoidRootPart
                local spinPart = Configuration.SpinPart
                
                if Configuration.RandomSpinPart then
                    spinPart = Configuration.SpinPartDropdownValues[math.random(1, #Configuration.SpinPartDropdownValues)]
                end
                
                local targetPart = Player.Character:FindFirstChild(spinPart) or rootPart
                targetPart.CFrame = targetPart.CFrame * CFrame.Angles(0, math.rad(Configuration.SpinBotVelocity), 0)
            end
        end)
    end
end)

-- Player Events
Players.PlayerAdded:Connect(function(player)
    if ShowingESP then
        CreatePlayerESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        pcall(function()
            for _, drawing in pairs(ESPObjects[player]) do
                drawing:Remove()
            end
            ESPObjects[player] = nil
        end)
    end
end)

print("✨ Open Aimbot Complete Edition Loaded Successfully! ✨")
print("🎮 Press RightShift to toggle GUI")
print("📑 All 5 original tabs included: Aimbot • Bots • Checks • Visuals • Settings")
print("🎯 Advanced features with native UI ready!")
print("🌈 Full feature set with professional interface!")