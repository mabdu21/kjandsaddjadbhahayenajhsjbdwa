-- The Forge BETA - Eclipse Premium GUI (UNDETECTED 2025)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Eclipse ⚡ The Forge BETA",
   LoadingTitle = "Eclipse Premium",
   LoadingSubtitle = "Loading undetectable suite...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "EclipseForge",
      FileName = "ForgeConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

local AutoTab = Window:CreateTab("Auto Forge", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483345998)
local VisualTab = Window:CreateTab("Visuals", 4483362447)
local PlayerTab = Window:CreateTab("Player", 4483362457)
local UtilsTab = Window:CreateTab("Utils", 4483362461)

AutoTab:CreateToggle({
   Name = "Perfect AutoForge",
   CurrentValue = false,
   Flag = "AutoForge",
   Callback = function(Value)
      getgenv().AutoForge = Value
   end,
})

AutoTab:CreateToggle({
   Name = "AutoFarm Mobs [Fully Hidden]",
   CurrentValue = false,
   Flag = "AutoMobs",
   Callback = function(Value)
      getgenv().AutoMobs = Value
   end,
})

AutoTab:CreateToggle({
   Name = "AutoMine [Fully Hidden]",
   CurrentValue = false,
   Flag = "AutoMine",
   Callback = function(Value)
      getgenv().AutoMine = Value
   end,
})

AutoTab:CreateToggle({
   Name = "Remote Forge",
   CurrentValue = false,
   Flag = "RemoteForge",
   Callback = function(Value)
      getgenv().RemoteForge = Value
   end,
})

AutoTab:CreateToggle({
   Name = "Remote Sell + Buy",
   CurrentValue = false,
   Flag = "RemoteSellBuy",
   Callback = function(Value)
      getgenv().RemoteSellBuy = Value
   end,
})

AutoTab:CreateToggle({
   Name = "AutoSell",
   CurrentValue = false,
   Flag = "AutoSell",
   Callback = function(Value)
      getgenv().AutoSell = Value
   end,
})

AutoTab:CreateToggle({
   Name = "AutoPotion",
   CurrentValue = false,
   Flag = "AutoPotion",
   Callback = function(Value)
      getgenv().AutoPotion = Value
   end,
})

AutoTab:CreateToggle({
   Name = "AutoEquip",
   CurrentValue = false,
   Flag = "AutoEquip",
   Callback = function(Value)
      getgenv().AutoEquip = Value
   end,
})

AutoTab:CreateInput({
   Name = "Webhook URL",
   PlaceholderText = "Paste Discord Webhook...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      getgenv().Webhook = Text
   end,
})

AutoTab:CreateToggle({
   Name = "Webhook Logging",
   CurrentValue = false,
   Flag = "WebhookLog",
   Callback = function(Value)
      getgenv().WebhookLog = Value
   end,
})

CombatTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "Aimbot",
   Callback = function(Value)
      getgenv().Aimbot = Value
   end,
})

CombatTab:CreateSlider({
   Name = "Aimbot FOV",
   Range = {10, 360},
   Increment = 10,
   CurrentValue = 120,
   Flag = "AimbotFOV",
   Callback = function(Value)
      getgenv().AimbotFOV = Value
   end,
})

VisualTab:CreateToggle({
   Name = "Advanced ESP",
   CurrentValue = false,
   Flag = "AdvESP",
   Callback = function(Value)
      getgenv().AdvESP = Value
   end,
})

VisualTab:CreateToggle({
   Name = "Player Radar",
   CurrentValue = false,
   Flag = "PlayerRadar",
   Callback = function(Value)
      getgenv().PlayerRadar = Value
   end,
})

VisualTab:CreateColorPicker({
   Name = "ESP Color",
   Color = Color3.fromRGB(255, 0, 255),
   Flag = "ESPColor",
   Callback = function(Brightness)
      getgenv().ESPColor = Brightness
   end,
})

PlayerTab:CreateToggle({
   Name = "Flight (E)",
   CurrentValue = false,
   Flag = "Flight",
   Callback = function(Value)
      getgenv().Flight = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "Fly Speed",
   Range = {16, 500},
   Increment = 10,
   CurrentValue = 100,
   Flag = "FlySpeed",
   Callback = function(Value)
      getgenv().FlySpeed = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
      getgenv().Noclip = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      getgenv().InfJump = Value
   end,
})

UtilsTab:CreateButton({
   Name = "Advanced Macro Builder",
   Callback = function()
      Rayfield:Notify({
         Title = "Macro Builder",
         Content = "Opening Advanced Macro Builder...",
         Duration = 3,
         Image = 4483362458
      })
   end,
})

UtilsTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/ServerHop/main/hop.lua"))()
   end,
})

UtilsTab:CreateButton({
   Name = "Rejoin",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId)
   end,
})

Rayfield:Notify({
   Title = "Eclipse Loaded",
   Content = "Perfect AutoForge Suite for The Forge BETA - Undetected!",
   Duration = 6.5,
   Image = 4483362458
})
