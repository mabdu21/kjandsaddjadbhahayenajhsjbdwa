if game.Players.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and game.Players.LocalPlayer.PlayerGui.LoadingUI.Enabled == true then
repeat task.wait() until game.Players.LocalPlayer.PlayerGui.LoadingUI.Enabled == false
end

if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "FPS Unlocked!",
        Duration = 5,
        Button1 = "Okay"
    })
    warn("FPS Unlocked!")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "Your exploit does not support setfpscap.",
        Duration = 5,
        Button1 = "Okay"
    })
    warn("Your exploit does not support setfpscap.")
end

Screech = false
ClutchHeart = false
local old
old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(self) == "Screech" and method == "FireServer" and Screech == true then
        args[1] = true
        return old(self,unpack(args))
    end
    if tostring(self) == "ClutchHeartbeat" and method == "FireServer" and ClutchHeart == true then
        args[2] = true
        return old(self,unpack(args))
    end
    return old(self,...)
end))

workspace.DescendantAdded:Connect(function(v)
if v:IsA("Model") and v.Name == "Screech" then
v:Destroy()
end
end)

------ Script --------

local EntityModules = game:GetService("ReplicatedStorage").ModulesClient.EntityModules
local gameData = game.ReplicatedStorage:WaitForChild("GameData")
local floor = gameData:WaitForChild("Floor")
local isMines = floor.Value == "Mines"
local isHotel = floor.Value == "Hotel"
local isBackdoor = floor.Value == "Backdoor"
local isGarden = floor.Value == "Garden"

function Distance(pos)
	if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude
	end
end

_G.GetOldBright = {
	Brightness = game.Lighting.Brightness,
	ClockTime = game.Lighting.ClockTime,
	FogEnd = game.Lighting.FogEnd,
	GlobalShadows = game.Lighting.GlobalShadows,
	OutdoorAmbient = game.Lighting.OutdoorAmbient
}

---- Script ----

local ui = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

ui:AddTheme({
    Name = "Dark",
    Accent = "#18181b",
    Dialog = "#18181b", 
    Outline = "#FFFFFF",
    Text = "#FFFFFF",
    Placeholder = "#999999",
    Background = "#0e0e10",
    Button = "#52525b",
    Icon = "#a1a1aa",
})

ui:AddTheme({
    Name = "Light",
    Accent = "#f4f4f5",
    Dialog = "#f4f4f5",
    Outline = "#000000", 
    Text = "#000000",
    Placeholder = "#666666",
    Background = "#ffffff",
    Button = "#e4e4e7",
    Icon = "#52525b",
})

ui:AddTheme({
    Name = "Gray",
    Accent = "#374151",
    Dialog = "#374151",
    Outline = "#d1d5db", 
    Text = "#f9fafb",
    Placeholder = "#9ca3af",
    Background = "#1f2937",
    Button = "#4b5563",
    Icon = "#d1d5db",
})

ui:AddTheme({
    Name = "Blue",
    Accent = "#1e40af",
    Dialog = "#1e3a8a",
    Outline = "#93c5fd", 
    Text = "#f0f9ff",
    Placeholder = "#60a5fa",
    Background = "#1e293b",
    Button = "#3b82f6",
    Icon = "#93c5fd",
})

ui:AddTheme({
    Name = "Green",
    Accent = "#059669",
    Dialog = "#047857",
    Outline = "#6ee7b7", 
    Text = "#ecfdf5",
    Placeholder = "#34d399",
    Background = "#064e3b",
    Button = "#10b981",
    Icon = "#6ee7b7",
})

ui:AddTheme({
    Name = "Purple",
    Accent = "#7c3aed",
    Dialog = "#6d28d9",
    Outline = "#c4b5fd", 
    Text = "#faf5ff",
    Placeholder = "#a78bfa",
    Background = "#581c87",
    Button = "#8b5cf6",
    Icon = "#c4b5fd",
})

ui:SetNotificationLower(true)

local themes = {"Dark", "Light", "Gray", "Blue", "Green", "Purple"}
local currentThemeIndex = 1

if not getgenv().TransparencyEnabled then
    getgenv().TransparencyEnabled = true
end

local Window = ui:CreateWindow({
    Title = "DYHUB",
    Icon = "rbxassetid://104487529937663", 
    Author = "Doors | Premium Version",
    Folder = "DYHUB_Doors_config",
    Size = UDim2.fromOffset(500, 350),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
           
            WindUI:Notify({
                Title = "Theme Changed",
                Content = "Switched to " .. newTheme .. " theme!",
                Duration = 2,
                Icon = "palette"
            })
            print("Switched to " .. newTheme .. " theme")
        end,
    },
    
})

Window:SetToggleKey(Enum.KeyCode.K)

ui:Notify({
    Title = "DYHUB | Notify",
    Content = "Press K To Open/Close Menu!",
    Duration = 3, 
    Icon = "keyboard",
})

pcall(function()
    Window:CreateTopbarButton("TransparencyToggle", "eye", function()
        if getgenv().TransparencyEnabled then
            getgenv().TransparencyEnabled = false
            pcall(function() Window:ToggleTransparency(false) end)
            
            WindUI:Notify({
                Title = "Transparency", 
                Content = "Transparency disabled",
                Duration = 3,
                Icon = "eye"
            })
            print("Transparency = false")
        else
            getgenv().TransparencyEnabled = true
            pcall(function() Window:ToggleTransparency(true) end)
            
            WindUI:Notify({
                Title = "Transparency",
                Content = "Transparency enabled", 
                Duration = 3,
                Icon = "eye-off"
            })
            print(" Transparency = true")
        end
        
     
        print("Debug  Current Transparency state:", getgenv().TransparencyEnabled)
    end, 990)
end)

pcall(function()
    Window:Tag({
        Title = "4.2.7",
        Color = Color3.fromHex("#30ff6a") 
    })
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true
})

Tabs = {
    ["Info"] = Window:Tab({Title = "Information", Icon = "info"}),
    Tab = Window:Tab({Title = "Main", Icon = "rocket"}),
    Tab2 = Window:Tab({Title = "Esp", Icon = "eye"}),
    Tab3 = Window:Tab({Title = "Anti", Icon = "shield"}),
    Tab1 = Window:Tab({Title = "Misc", Icon = "layout-grid"}),
}

Window:SelectTab(1)

local Main = Tabs.Tab
local Anti = Tabs.Tab3

Main:Section({Title = "Feature Auto", TextXAlignment = "Left", TextSize = 17})

_G.Aura = {
    "ActivateEventPrompt",
    "AwesomePrompt",
    "FusesPrompt",
    "HerbPrompt",
    "LeverPrompt",
    "LootPrompt",
    "ModulePrompt",
    "SkullPrompt",
    "UnlockPrompt",
    "ValvePrompt",
}

Main:Toggle({
    Title = "Auto Everything (Aura)",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.AutoLoot = Value
if _G.AutoLoot then
lootables = {}
local function LootCheck(v)
    if not table.find(lootables, v) and v.Name ~= "Groundskeeper" and v:IsA("ProximityPrompt") and table.find(_G.Aura, v.Name) then
        table.insert(lootables, v)
    end
end
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("ProximityPrompt") then
	LootCheck(v)
end
end
ChildAllNext = workspace.DescendantAdded:Connect(function(v)
if v:IsA("ProximityPrompt") then
	LootCheck(v)
end
end)
RemoveChild = workspace.DescendantRemoving:Connect(function(v)
    for i = #lootables, 1, -1 do
        if lootables[i] == v then
            table.remove(lootables, i)
            break
        end
    end
end)
else
if ChildAllNext then
ChildAllNext:Disconnect()
ChildAllNext = nil
end
if RemoveChild then
RemoveChild:Disconnect()
RemoveChild = nil
end
end
while _G.AutoLoot do
for i, v in pairs(lootables) do
	if v:IsA("ProximityPrompt") and table.find(_G.Aura, v.Name) and (v:GetAttribute("Interactions") == nil or v:GetAttribute("Interactions") <= 2) then
		if Distance(v.Parent:GetPivot().Position) <= 12 then
			fireproximityprompt(v)
		end
	end
end
task.wait(0.1)
end
    end
})

Main:Section({Title = "Feature Visual", TextXAlignment = "Left", TextSize = 17})

Main:Toggle({
    Title = "Full Bright",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.FullBright = Value
while _G.FullBright do
game.Lighting.Brightness = 2
game.Lighting.ClockTime = 14
game.Lighting.FogEnd = 100000
game.Lighting.GlobalShadows = false
game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
task.wait()
end
for i, v in pairs(_G.GetOldBright) do
game.Lighting[i] = v
end
    end
})

Main:Toggle({
    Title = "No Fog",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.Nofog = Value
while _G.Nofog do
game:GetService("Lighting").FogStart = 100000
game:GetService("Lighting").FogEnd = 200000
for i, v in pairs(game:GetService("Lighting"):GetChildren()) do
if v.ClassName == "Atmosphere" then
v.Density = 0
v.Haze = 0
end
end
task.wait()
end
game:GetService("Lighting").FogStart = 0
game:GetService("Lighting").FogEnd = 1000
for i, v in pairs(game:GetService("Lighting"):GetChildren()) do
if v.ClassName == "Atmosphere" then
v.Density = 0.3
v.Haze = 1
end
end
    end
})

Main:Toggle({
    Title = "Instant Prompt",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.NoCooldownProximity = Value
if _G.NoCooldownProximity == true then
for i, v in pairs(workspace:GetDescendants()) do
if v.ClassName == "ProximityPrompt" then
v.HoldDuration = 0
end
end
CooldownProximity = workspace.DescendantAdded:Connect(function(Cooldown)
if _G.NoCooldownProximity == true then
if Cooldown:IsA("ProximityPrompt") then
Cooldown.HoldDuration = 0
end
end
end)
else
if CooldownProximity then
CooldownProximity:Disconnect()
CooldownProximity = nil
end
end
    end
})

Anti:Section({Title = "Feature Anti", TextXAlignment = "Left", TextSize = 17})

Anti:Toggle({
    Title = "Anti Screech",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.AntiScreech = Value
Screech = Value
    end
})

Anti:Toggle({
    Title = "Auto Clutch Heart Win",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
ClutchHeart = Value
    end
})

Anti:Toggle({
    Title = "Anti Halt",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.NoHalt = Value
local HaltShade = EntityModules:FindFirstChild("Shade") or EntityModules:FindFirstChild("_Shade")
if HaltShade then
    HaltShade.Name = _G.NoHalt and "_Shade" or "Shade"
end
    end
})

Anti:Toggle({
    Title = "Anti Eyes / Lookman",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.NoEyes = Value
while _G.NoEyes do
if workspace:FindFirstChild("Eyes") or workspace:FindFirstChild("BackdoorLookman") then
if game:GetService("ReplicatedStorage"):FindFirstChild("RemotesFolder") then
game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("MotorReplication"):FireServer(-649)
end
end
task.wait()
end
    end
})

Main:Toggle({
    Title = "Inf Oxygen",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.ActiveInfOxygen = Value 
while _G.ActiveInfOxygen do 
if game.Players.LocalPlayer.Character:GetAttribute("Oxygen") then
game.Players.LocalPlayer.Character:SetAttribute("Oxygen",99999)
end
task.wait()
end 
if game.Players.LocalPlayer.Character:GetAttribute("Oxygen") then
game.Players.LocalPlayer.Character:SetAttribute("Oxygen",100)
end
    end
})

local Misc = Tabs.Tab1
Misc:Section({Title = "Feature Notify", TextXAlignment = "Left", TextSize = 17})

local EntityGet = Misc:Dropdown({
    Title = "Choose Entity",
    Values = {"Rush", "Seek", "Eyes", "Window", "LookMan", "Giggle", "GloombatSwarm", "Ambush", "A-60", "A-120"},
    Value = {"Rush"},
    Multi = true,
    AllowNone = true,
    Callback = function(Value) 
_G.EntityChoose = Value
    end
})

Misc:Toggle({
    Title = "Notification Entity",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.NotifyEntity = Value
if _G.NotifyEntity then
    EntityChild = workspace.ChildAdded:Connect(function(child)
        for _, v in ipairs(_G.EntityChoose) do
            if child:IsA("Model") and child.Name:find(v) then
                repeat task.wait() until not child:IsDescendantOf(workspace) or (game.Players.LocalPlayer:DistanceFromCharacter(child:GetPivot().Position) < 1000)
                if child:IsDescendantOf(workspace) then
                    ui:Notify({Title = v.." Spawn!!", Duration = 5})
                    if _G.NotifyEntityChat then
                        local text = _G.ChatNotify or ""
                        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(text..v.." Spawn!!")
                    end
                end
            end
        end
    end)
else
    if EntityChild then
        EntityChild:Disconnect()
        EntityChild = nil
    end
end
    end
})

Misc:Section({Title = "Feature Code", TextXAlignment = "Left", TextSize = 17})

if isHotel then
Misc:Toggle({
    Title = "Auto Get Code Library",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.NotifyEntity = Value
if _G.NotifyEntity then
local function Deciphercode(v)
local Hints = game.Players.LocalPlayer.PlayerGui:WaitForChild("PermUI"):WaitForChild("Hints")

local code = {[1] = "_",[2] = "_", [3] = "_", [4] = "_", [5] = "_"}
    for i, v in pairs(v:WaitForChild("UI"):GetChildren()) do
        if v:IsA("ImageLabel") and v.Name ~= "Image" then
            for b, n in pairs(Hints:GetChildren()) do
                if n:IsA("ImageLabel") and n.Visible and v.ImageRectOffset == n.ImageRectOffset then
                    code[tonumber(v.Name)] = n:FindFirstChild("TextLabel").Text 
                end
            end
        end
    end 
    return code
end
local function CodeAll(v)
	if v:IsA("Tool") and v.Name == "LibraryHintPaper" then
        local code = table.concat(Deciphercode(v))
        if code then
	        ui:Notify({Title = "Code: "..code, Duration = 5})
			if _G.NotifyEntityChat then
				if not _G.ChatNotify then
					TextChat = ""
				else
					TextChat = _G.ChatNotify
				end
				if TextChat then
					game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(TextChat..code)
				end
			end
	        if workspace:FindFirstChild("Padlock") and Distance(workspace.Padlock:GetPivot().Position) <= 30 then
				if game:GetService("ReplicatedStorage"):FindFirstChild("RemotesFolder") then
					game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("LP"):FireServer(code)
				end
			end
		end
    end
end
Getpaper = game.Players.LocalPlayer.Character.ChildAdded:Connect(function(v)
CodeAll(v)
end)
else
if Getpaper then
Getpaper:Disconnect()
Getpaper = nil
end
end
    end
})
end

Misc:Section({Title = "Feature Remind", TextXAlignment = "Left", TextSize = 17})

Misc:Input({
    Title = "Input Chat",
    Value = "",
    InputIcon = "speaker",
    Type = "Input",
    Placeholder = "Your Chat...",
    Callback = function(Value) 
_G.ChatNotify = Value
    end
})

Misc:Toggle({
    Title = "Notification Chat",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.NotifyEntityChat = Value
    end
})

Misc:Slider({
    Title = "Hiding Transparency",
    Step = 0.1,
    Value = {
        Min = 0,
        Max = 1,
        Default = 0.5,
    },
    Callback = function(Value)
_G.TransparencyHide = Value
    end
})

Misc:Toggle({
    Title = "Transparency Hiding",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.HidingTransparency = Value
while _G.HidingTransparency do
if game.Players.LocalPlayer.Character:GetAttribute("Hiding") then
	for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
		if v:IsA("ObjectValue") and v.Name == "HiddenPlayer" then
			if v.Value == game.Players.LocalPlayer.Character then
                local hidePart = {}
                for _, i in pairs(v.Parent:GetChildren()) do
                    if i:IsA("BasePart") then
		                i.Transparency = _G.TransparencyHide or 0.5
		                table.insert(hidePart, i)
		            end
		        end
            repeat task.wait()
                for _, h in pairs(hidePart) do
                    h.Transparency = _G.TransparencyHide or 0.5
                    task.wait()
                end
            until not game.Players.LocalPlayer.Character:GetAttribute("Hiding") or not _G.HidingTransparency
            for _, n in pairs(hidePart) do
                n.Transparency = 0
                task.wait()
            end
            break
		end
	end
end
end
task.wait()
end
    end
})

Misc:Section({Title = "Settings Player", TextXAlignment = "Left", TextSize = 17})

Misc:Slider({
    Title = "Walkspeed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 21,
        Default = 16,
    },
    Callback = function(Value)
_G.WalkSpeedTp = Value
    end
})

Misc:Toggle({
    Title = "WalkSpeed",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.SpeedWalk = Value
while _G.SpeedWalk do
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeedTp
end
task.wait()
end
    end
})

local Esp = Tabs.Tab2
local EspTr = "Esp"

Esp:Section({Title = "Essential Esp", TextXAlignment = "Left", TextSize = 17})

Esp:Toggle({
    Title = "Esp Gui",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspGui = Value
    end
})

Esp:Toggle({
    Title = "Esp HightLight",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspHighlight = Value
    end
})

Esp:Section({Title = "Settings Esp", TextXAlignment = "Left", TextSize = 17})

if not isGarden then
Esp:Toggle({
    Title = (((isHotel or isBackdoor) and "Esp Key / Lever") or (isMines and "Esp Fuse")),
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspKey = Value
if _G.EspKey == false then
_G.KeyAdd = {}
if KeySpawn then
KeySpawn:Disconnect()
KeySpawn = nil
end
if KeyRemove then
KeyRemove:Disconnect()
KeyRemove = nil
end
for _, v in pairs(workspace:GetDescendants()) do 
if v.Name:find("Key") or v.Name == "LeverForGate" or v.Name:find("FuseObtain") then
for i, z in pairs(v:GetChildren()) do
if z.Name:find("Esp_") then
z:Destroy()
end
end
end
end
else
function Keys(v)
if ((v.Name:find("Key") or v.Name:find("FuseObtain")) and v:FindFirstChild("Hitbox")) or (v.Name == "LeverForGate" and v.PrimaryPart) then
if v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
	v:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v
	Highlight.Parent = v
	elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight"):Destroy()
end
if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
	v["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and ((v.Name == "LeverForGate" and "Lever") or (v.Name:find("Key") and "Key") or (v.Name:find("FuseObtain") and "Fuse")) or "")..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.0f", Distance((v.Name == "LeverForGate" and v.PrimaryPart.Position) or ((v.Name:find("Key") or v.Name:find("FuseObtain")) and v.Hitbox.Position))).."m)" or "")
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
	GuiEsp = Instance.new("BillboardGui", v)
	GuiEsp.Adornee = v
	GuiEsp.Name = "Esp_Gui"
	GuiEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiEsp.AlwaysOnTop = true
	GuiEspText = Instance.new("TextLabel", GuiEsp)
	GuiEspText.BackgroundTransparency = 1
	GuiEspText.Font = Enum.Font.Code
	GuiEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiEspText.TextSize = 15
	GuiEspText.TextColor3 = Color3.new(0,0,0) 
	GuiEspText.TextStrokeTransparency = 0.5
	GuiEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiEspText
	elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
	v:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
local function CheckKey(v)
    if not table.find(_G.KeyAdd, v) and ((v.Name:find("Key") or v.Name:find("FuseObtain")) and v:FindFirstChild("Hitbox")) or (v.Name == "LeverForGate" and v.PrimaryPart) then
        table.insert(_G.KeyAdd, v)
    end
end
for _, v in ipairs(workspace:GetDescendants()) do
	CheckKey(v)
end
KeySpawn = workspace.DescendantAdded:Connect(function(v)
    CheckKey(v)
end)
KeyRemove = workspace.DescendantRemoving:Connect(function(v)
    for i = #_G.KeyAdd, 1, -1 do
        if _G.KeyAdd[i] == v then
            table.remove(_G.KeyAdd, i)
            break
        end
    end
end)
end
while _G.EspKey do
for i, v in pairs(_G.KeyAdd) do
if v:IsA("Model") then
Keys(v)
end
end
task.wait()
end
    end
})
end

Esp:Toggle({
    Title = "Esp Door",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
        _G.EspDoor = Value
        if _G.EspDoor == false then
            for _, v in pairs(game.Workspace:FindFirstChild("CurrentRooms"):GetChildren()) do 
                if v:IsA("Model") then
                    for i, z in pairs(v:GetChildren()) do
                        if z.Name:find("Esp_") then
                            z:Destroy()
                        end
                    end
                end
            end
        end

        while _G.EspDoor do
            for i, v in pairs(game.Workspace:FindFirstChild("CurrentRooms"):GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Door") and v.Door:FindFirstChild("Door") then
                    -- อัพเดท Highlight ที่มีอยู่แล้ว
                    if v:FindFirstChild("Esp_Highlight") then
                        v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                        v:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                    end

                    -- สร้าง Highlight ถ้าเปิด EspHighlight
                    if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
                        local Highlight = Instance.new("Highlight")
                        Highlight.Name = "Esp_Highlight"
                        Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
                        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
                        Highlight.FillTransparency = 0.5
                        Highlight.OutlineTransparency = 0
                        Highlight.Adornee = v.Door.Door -- ✅ MeshPart
                        Highlight.Parent = v
                    elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
                        v:FindFirstChild("Esp_Highlight"):Destroy()
                    end

                    -- อัพเดท GUI ถ้ามี
                    if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
                        v["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
                            (_G.EspName == true and "Door "..((v.Door:FindFirstChild("Sign") 
                            and v.Door.Sign:FindFirstChild("Stinker") 
                            and v.Door.Sign.Stinker.Text) 
                            or (v.Door.Sign:FindFirstChild("SignText") 
                            and v.Door.Sign.SignText.Text)):gsub("^0+", "")..
                            (v.Door:FindFirstChild("Lock") and " (lock)" or "") or "")..
                            (_G.EspDistance == true and "\nDistance ("..string.format("%.0f", Distance(v.Door.Door.Position)).."m)" or "")
                        
                        v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                        v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                    end

                    -- สร้าง GUI ถ้าเปิด EspGui
                    if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
                        local GuiEsp = Instance.new("BillboardGui", v)
                        GuiEsp.Adornee = v.Door.Door -- ✅ MeshPart
                        GuiEsp.Name = "Esp_Gui"
                        GuiEsp.Size = UDim2.new(0, 100, 0, 150)
                        GuiEsp.AlwaysOnTop = true

                        local GuiEspText = Instance.new("TextLabel", GuiEsp)
                        GuiEspText.BackgroundTransparency = 1
                        GuiEspText.Font = Enum.Font.Code
                        GuiEspText.Size = UDim2.new(0, 100, 0, 100)
                        GuiEspText.TextSize = 15
                        GuiEspText.TextColor3 = Color3.new(0,0,0) 
                        GuiEspText.TextStrokeTransparency = 0.5
                        GuiEspText.Text = ""

                        local UIStroke = Instance.new("UIStroke")
                        UIStroke.Color = Color3.new(0, 0, 0)
                        UIStroke.Thickness = 1.5
                        UIStroke.Parent = GuiEspText
                    elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
                        v:FindFirstChild("Esp_Gui"):Destroy()
                    end
                end
            end
            task.wait()
        end
    end
})


if isBackdoor then
Esp:Toggle({
    Title = "Esp Time Lever",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspLeverTime = Value
if _G.EspLeverTime == false then
_G.TimeLeverAdd = {}
if TimeLeverSpawn then
TimeLeverSpawn:Disconnect()
TimeLeverSpawn = nil
end
if TimeLeverRemove then
TimeLeverRemove:Disconnect()
TimeLeverRemove = nil
end
for _, v in pairs(workspace:GetDescendants()) do 
if v.Name:find("TimerLever") then
for i, z in pairs(v:GetChildren()) do
if z.Name:find("Esp_") then
z:Destroy()
end
end
end
end
else
function LeverTimes(v)
if v.Name:find("TimerLever") and v.PrimaryPart then
if v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
	v:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v
	Highlight.Parent = v
	elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight"):Destroy()
end
if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
	v["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and "Lever Time" or "")..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.0f", Distance(v.PrimaryPart.Position)).."m)" or "")
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
	GuiEsp = Instance.new("BillboardGui", v)
	GuiEsp.Adornee = v
	GuiEsp.Name = "Esp_Gui"
	GuiEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiEsp.AlwaysOnTop = true
	GuiEspText = Instance.new("TextLabel", GuiEsp)
	GuiEspText.BackgroundTransparency = 1
	GuiEspText.Font = Enum.Font.Code
	GuiEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiEspText.TextSize = 15
	GuiEspText.TextColor3 = Color3.new(0,0,0) 
	GuiEspText.TextStrokeTransparency = 0.5
	GuiEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiEspText
	elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
	v:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
local function CheckTimeLever(v)
    if not table.find(_G.TimeLeverAdd, v) and v.Name == "TimerLever" then
        table.insert(_G.TimeLeverAdd, v)
    end
end
for _, v in ipairs(workspace:GetDescendants()) do
	CheckTimeLever(v)
end
TimeLeverSpawn = workspace.DescendantAdded:Connect(function(v)
    CheckTimeLever(v)
end)
TimeLeverRemove = workspace.DescendantRemoving:Connect(function(v)
    for i = #_G.TimeLeverAdd, 1, -1 do
        if _G.TimeLeverAdd[i] == v then
            table.remove(_G.TimeLeverAdd, i)
            break
        end
    end
end)
end
while _G.EspLeverTime do
for i, v in pairs(_G.TimeLeverAdd) do
if v:IsA("Model") then
LeverTimes(v)
end
end
task.wait()
end
    end
})
end

if isHotel then
Esp:Toggle({
    Title = "Esp Book",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspBook = Value
if _G.EspBook == false then
_G.BookAdd = {}
if BookSpawn then
BookSpawn:Disconnect()
BookSpawn = nil
end
if BookRemove then
BookRemove:Disconnect()
BookRemove = nil
end
for _, v in pairs(workspace:GetDescendants()) do 
if v.Name:find("LiveHintBook") then
for i, z in pairs(v:GetChildren()) do
if z.Name:find("Esp_") then
z:Destroy()
end
end
end
end
else
function Books(v)
if v.Name:find("LiveHintBook") and v.PrimaryPart then
if v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
	v:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v
	Highlight.Parent = v
	elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight"):Destroy()
end
if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
	v["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and "Book" or "")..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.0f", Distance(v.PrimaryPart.Position)).."m)" or "")
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
	GuiEsp = Instance.new("BillboardGui", v)
	GuiEsp.Adornee = v
	GuiEsp.Name = "Esp_Gui"
	GuiEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiEsp.AlwaysOnTop = true
	GuiEspText = Instance.new("TextLabel", GuiEsp)
	GuiEspText.BackgroundTransparency = 1
	GuiEspText.Font = Enum.Font.Code
	GuiEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiEspText.TextSize = 15
	GuiEspText.TextColor3 = Color3.new(0,0,0) 
	GuiEspText.TextStrokeTransparency = 0.5
	GuiEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiEspText
	elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
	v:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
local function CheckBook(v)
    if not table.find(_G.BookAdd, v) and v.Name == "LiveHintBook" then
        table.insert(_G.BookAdd, v)
    end
end
for _, v in ipairs(workspace:GetDescendants()) do
	CheckBook(v)
end
BookSpawn = workspace.DescendantAdded:Connect(function(v)
    CheckBook(v)
end)
BookRemove = workspace.DescendantRemoving:Connect(function(v)
    for i = #_G.BookAdd, 1, -1 do
        if _G.BookAdd[i] == v then
            table.remove(_G.BookAdd, i)
            break
        end
    end
end)
end
while _G.EspBook do
for i, v in pairs(_G.BookAdd) do
if v:IsA("Model") then
Books(v)
end
end
task.wait()
end
    end
})

Esp:Toggle({
    Title = "Esp Breaker",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspBreaker = Value
if _G.EspBreaker == false then
_G.BreakerAdd = {}
if BreakerSpawn then
BreakerSpawn:Disconnect()
BreakerSpawn = nil
end
if BreakerRemove then
BreakerRemove:Disconnect()
BreakerRemove = nil
end
for _, v in pairs(workspace:GetDescendants()) do 
if v.Name:find("LiveBreakerPolePickup") then
for i, z in pairs(v:GetChildren()) do
if z.Name:find("Esp_") then
z:Destroy()
end
end
end
end
else
function Breakers(v)
if v.Name == "LiveBreakerPolePickup" and v:FindFirstChildOfClass("ProximityPrompt") then
if v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
	v:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v
	Highlight.Parent = v
	elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight"):Destroy()
end
if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
	v["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and "Breaker" or "")..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.0f", Distance(v.PrimaryPart.Position)).."m)" or "")
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
	GuiEsp = Instance.new("BillboardGui", v)
	GuiEsp.Adornee = v
	GuiEsp.Name = "Esp_Gui"
	GuiEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiEsp.AlwaysOnTop = true
	GuiEspText = Instance.new("TextLabel", GuiEsp)
	GuiEspText.BackgroundTransparency = 1
	GuiEspText.Font = Enum.Font.Code
	GuiEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiEspText.TextSize = 15
	GuiEspText.TextColor3 = Color3.new(0,0,0) 
	GuiEspText.TextStrokeTransparency = 0.5
	GuiEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiEspText
	elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
	v:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
local function CheckBreaker(v)
    if not table.find(_G.BreakerAdd, v) and v.Name == "LiveBreakerPolePickup" then
        table.insert(_G.BreakerAdd, v)
    end
end
for _, v in ipairs(workspace:GetDescendants()) do
	CheckBreaker(v)
end
BreakerSpawn = workspace.DescendantAdded:Connect(function(v)
    CheckBreaker(v)
end)
BreakerRemove = workspace.DescendantRemoving:Connect(function(v)
for i = #_G.BreakerAdd, 1, -1 do
    if _G.BreakerAdd[i] == v then
        table.remove(_G.BreakerAdd, i)
        break
    end
end
end)
end
while _G.EspBreaker do
for i, v in pairs(_G.BreakerAdd) do
if v.Name == "LiveBreakerPolePickup" then
Breakers(v)
end
end
task.wait()
end
    end
})
end

Esp:Toggle({
    Title = "Esp Item",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspItem = Value
if _G.EspItem == false then
_G.ItemAdd = {}
if ItemSpawn then
ItemSpawn:Disconnect()
ItemSpawn = nil
end
if ItemRemove then
ItemRemove:Disconnect()
ItemRemove = nil
end
for _, v in pairs(workspace:GetDescendants()) do 
if v.Name:find("Handle") then
for i, z in pairs(v:GetChildren()) do
if z.Name:find("Esp_") then
z:Destroy()
end
end
end
end
else
function Items(v)
if v.Name == "Handle" and v.Parent:FindFirstChildOfClass("ProximityPrompt") then
if v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
	v:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v.Parent
	Highlight.Parent = v
	elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight"):Destroy()
end
if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
	v["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and v.Parent.Name or "")..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.0f", Distance(v.Position)).."m)" or "")
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
	GuiEsp = Instance.new("BillboardGui", v)
	GuiEsp.Adornee = v.Parent
	GuiEsp.Name = "Esp_Gui"
	GuiEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiEsp.AlwaysOnTop = true
	GuiEspText = Instance.new("TextLabel", GuiEsp)
	GuiEspText.BackgroundTransparency = 1
	GuiEspText.Font = Enum.Font.Code
	GuiEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiEspText.TextSize = 15
	GuiEspText.TextColor3 = Color3.new(0,0,0) 
	GuiEspText.TextStrokeTransparency = 0.5
	GuiEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiEspText
	elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
	v:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
local function CheckItem(v)
    if not table.find(_G.ItemAdd, v) and v.Name == "Handle" then
        table.insert(_G.ItemAdd, v)
    end
end
for _, v in ipairs(workspace:GetDescendants()) do
	CheckItem(v)
end
ItemSpawn = workspace.DescendantAdded:Connect(function(v)
    CheckItem(v)
end)
ItemRemove = workspace.DescendantRemoving:Connect(function(v)
for i = #_G.ItemAdd, 1, -1 do
    if _G.ItemAdd[i] == v then
        table.remove(_G.ItemAdd, i)
        break
    end
end
end)
end
while _G.EspItem do
for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
	if v:IsA("Tool") then
		for i, z in pairs(v:GetChildren()) do
			if z.Name:find("Esp_") then
				z:Destroy()
			end
		end
	end
end
for i, v in pairs(_G.ItemAdd) do
if v.Name == "Handle" then
Items(v)
end
end
task.wait()
end
    end
})

_G.EspEntityNameDis = {
	["FigureRig"] = "Figure",
	["SallyMoving"] = "Window",
	["RushMoving"] = "Rush",
	["Eyes"] = "Eyes",
	["Groundskeeper"] = "Skeeper",
	["BackdoorLookman"] = "Lookman",
	["BackdoorRush"] = "Blitz",
	["MandrakeLive"] = "Mandrake",
	["GloombatSwarm"] = "Gloombat",
	["GiggleCeiling"] = "Giggle",
	["AmbushMoving"] = "Ambush"
}

Esp:Toggle({
    Title = "Esp Entity",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspEntity = Value
if _G.EspEntity == false then
_G.EntityAdd = {}
if EntitySpawn then
EntitySpawn:Disconnect()
EntitySpawn = nil
end
if EntityRemove then
EntityRemove:Disconnect()
EntityRemove = nil
end
for _, v in pairs(workspace:GetDescendants()) do 
for x, z in pairs(_G.EspEntityNameDis) do
if v:IsA("Model") and (v.Name == x) then
if v.PrimaryPart then
v.PrimaryPart.Transparency = 1
end
for i, z in pairs(v:GetChildren()) do
if z.Name:find("Esp_") then
z:Destroy()
end
end
end
end
end
else
local function CheckEntity(v)
	for x, z in pairs(_G.EspEntityNameDis) do
		if v:IsA("Model") and (v.Name == x) then
		    if not table.find(_G.EntityAdd, v) then
		        table.insert(_G.EntityAdd, v)
		    end
		end
	end
end
for _, v in ipairs(workspace:GetDescendants()) do
	CheckEntity(v)
end
EntitySpawn = workspace.DescendantAdded:Connect(function(v)
    CheckEntity(v)
end)
EntityRemove = workspace.DescendantRemoving:Connect(function(v)
for i = #_G.EntityAdd, 1, -1 do
    if _G.EntityAdd[i] == v then
        table.remove(_G.EntityAdd, i)
        break
    end
end
end)
end
while _G.EspEntity do
for i, v in pairs(_G.EntityAdd) do
for x, z in pairs(_G.EspEntityNameDis) do
if v:IsA("Model") and (v.Name == x) then
if v.PrimaryPart then
v.PrimaryPart.Transparency = 0
end
if v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
	v:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v
	Highlight.Parent = v
	elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight"):Destroy()
end
if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
	v["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and _G.EspEntityNameDis[v.Name] or "")..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.0f", Distance(v.PrimaryPart.Position)).."m)" or "")
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
	GuiEsp = Instance.new("BillboardGui", v)
	GuiEsp.Adornee = v
	GuiEsp.Name = "Esp_Gui"
	GuiEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiEsp.AlwaysOnTop = true
	GuiEspText = Instance.new("TextLabel", GuiEsp)
	GuiEspText.BackgroundTransparency = 1
	GuiEspText.Font = Enum.Font.Code
	GuiEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiEspText.TextSize = 15
	GuiEspText.TextColor3 = Color3.new(0,0,0) 
	GuiEspText.TextStrokeTransparency = 0.5
	GuiEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiEspText
	elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
	v:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
end
task.wait()
end
    end
})

Esp:Toggle({
    Title = "Esp Hiding Spots",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspHiding = Value
if _G.EspHiding == false then
_G.HidingAdd = {}
if HidingSpawn then
HidingSpawn:Disconnect()
HidingSpawn = nil
end
if HidingRemove then
HidingRemove:Disconnect()
HidingRemove = nil
end
for _, v in pairs(workspace:GetDescendants()) do 
if v.Name == "Bed" or v.Name == "Wardrobe" or v.Name == "Backdoor_Wardrobe" or v.Name == "Locker_Large" or v.Name == "Rooms_Locker" then
for i, z in pairs(v:GetChildren()) do
if z.Name:find("Esp_") then
z:Destroy()
end
end
end
end
else
function Hidings(v)
if (v.Name == "Bed" or v.Name == "Wardrobe" or v.Name == "Backdoor_Wardrobe" or v.Name == "Locker_Large" or v.Name == "Rooms_Locker") and v.PrimaryPart then
if v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
	v:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v
	Highlight.Parent = v
	elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight"):Destroy()
end
if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
	v["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and v.Name or "")..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.0f", Distance(v.PrimaryPart.Position)).."m)" or "")
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
	GuiEsp = Instance.new("BillboardGui", v)
	GuiEsp.Adornee = v
	GuiEsp.Name = "Esp_Gui"
	GuiEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiEsp.AlwaysOnTop = true
	GuiEspText = Instance.new("TextLabel", GuiEsp)
	GuiEspText.BackgroundTransparency = 1
	GuiEspText.Font = Enum.Font.Code
	GuiEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiEspText.TextSize = 15
	GuiEspText.TextColor3 = Color3.new(0,0,0) 
	GuiEspText.TextStrokeTransparency = 0.5
	GuiEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiEspText
	elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
	v:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
local function CheckHiding(v)
    if not table.find(_G.HidingAdd, v) and v.Name == "Bed" or v.Name == "Wardrobe" or v.Name == "Backdoor_Wardrobe" or v.Name == "Locker_Large" or v.Name == "Rooms_Locker" then
        table.insert(_G.HidingAdd, v)
    end
end
for _, v in ipairs(workspace:GetDescendants()) do
	CheckHiding(v)
end
BookSpawn = workspace.DescendantAdded:Connect(function(v)
    CheckHiding(v)
end)
BookRemove = workspace.DescendantRemoving:Connect(function(v)
    for i = #_G.HidingAdd, 1, -1 do
        if _G.HidingAdd[i] == v then
            table.remove(_G.HidingAdd, i)
            break
        end
    end
end)
end
while _G.EspHiding do
for i, v in pairs(_G.HidingAdd) do
if v:IsA("Model") then
Hidings(v)
end
end
task.wait()
end
    end
})

Esp:Toggle({
    Title = "Esp Player",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspPlayer = Value
if _G.EspPlayer == false then
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
		for x, b in pairs(v.Character:GetChildren()) do
			if b.Name:find("Esp_") then
				b:Destroy()
			end
		end
	end
end
end
while _G.EspPlayer do
for i, v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
if v.Character:FindFirstChild("Esp_Highlight") then
	v.Character:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.new(255, 255, 255)
	v.Character:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.new(255, 255, 255)
end
if _G.EspHighlight == true and v.Character:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v.Character
	Highlight.Parent = v.Character
	elseif _G.EspHighlight == false and v.Character:FindFirstChild("Esp_Highlight") then
	v.Character:FindFirstChild("Esp_Highlight"):Destroy()
end
if v.Character:FindFirstChild("Esp_Gui") and v.Character["Esp_Gui"]:FindFirstChild("TextLabel") then
	v.Character["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and v.Name or "")..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.0f", Distance(v.Character.HumanoidRootPart.Position)).."m)" or "")..
            (_G.EspHealth == true and "\nHealth [ "..(v.Character.Humanoid.Health <= 0 and "Dead" or string.format("%.0f", (v.Character.Humanoid.Health))).." ]" or "")
    v.Character["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v.Character["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v.Character:FindFirstChild("Esp_Gui") == nil then
	GuiPlayerEsp = Instance.new("BillboardGui", v.Character)
	GuiPlayerEsp.Adornee = v.Character.Head
	GuiPlayerEsp.Name = "Esp_Gui"
	GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiPlayerEsp.AlwaysOnTop = true
	GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
	GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
	GuiPlayerEspText.BackgroundTransparency = 1
	GuiPlayerEspText.Font = Enum.Font.Code
	GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiPlayerEspText.TextSize = 15
	GuiPlayerEspText.TextColor3 = Color3.new(0,0,0) 
	GuiPlayerEspText.TextStrokeTransparency = 0.5
	GuiPlayerEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiPlayerEspText
	elseif _G.EspGui == false and v.Character:FindFirstChild("Esp_Gui") then
	v.Character:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
task.wait()
end
    end
})

Esp:Section({Title = "Settings Color", TextXAlignment = "Left", TextSize = 17})

Esp:Colorpicker({
    Title = "Color Gui",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Locked = false,
    Callback = function(Value) 
_G.EspGuiTextColor = Value
    end
})

Esp:Colorpicker({
    Title = "Color HightLight",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Locked = false,
    Callback = function(Value) 
_G.ColorLight = Value
    end
})

Esp:Slider({
    Title = "Text Size [ Gui ]",
    Step = 1,
    Value = {
        Min = 5,
        Max = 50,
        Default = 10,
    },
    Callback = function(Value)
_G.EspGuiTextSize = Value
    end
})

Esp:Section({Title = "Settings Text", TextXAlignment = "Left", TextSize = 17})

Esp:Toggle({
    Title = "Esp Name",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspName = Value
    end
})

Esp:Toggle({
    Title = "Esp Distance",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspDistance = Value
    end
})

Esp:Toggle({
    Title = "Esp Health",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
_G.EspHealth = Value
    end
})

-----------------------------------
Info = Tabs["Info"]  -- This correctly references your existing Info tab

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
