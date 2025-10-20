local ver = "Version: 1.7.9"

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DYHUB | Guts & Blackpowder",
   Icon = 104487529937663, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "DYHUB Loaded! - G&B",
   LoadingSubtitle = "Join our at dsc.gg/dyhub",
   ShowText = "DYHUB", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Dark Blue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "DYHUB_GAB"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Verification",
      Subtitle = "No one of these hubs are mine",
      Note = "Type (No) To verificate", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"No"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Main", 4483362458) -- Title, Image
local EspTab = Window:CreateTab("Esp", 4483362458)
local AutoTab = Window:CreateTab("Auto", 4483362458)
local AntiTab = Window:CreateTab("Anti", 4483362458)
local Main = Window:CreateTab("Others", 4483362458) -- Title, Image

local Section = Main:CreateSection("Everything")
local Chaos = Main:CreateButton({
   Name = "Chaos Hub (Work on mobile)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/cjbbth1-crypto/Chaos-Hub-GB/refs/heads/main/Chaos%20Hub"))()
   end,
})
local Boost = Main:CreateButton({
   Name = "Boost FPS (By DYHUB)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/mabdu21/kjandsaddjadbhahayenajhsjbdwa/refs/heads/main/Nigga.lua"))()
   end,
})

local Section = AutoTab:CreateSection("Auto Farm")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

local selectedWeapon = ""

-- ฟังก์ชันดึงอาวุธจาก Backpack
local function getWeaponList()
    local list = {"LOAD IN GAME"}
    for _, tool in ipairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(list, tool.Name)
        end
    end
    return list
end

-- ฟังก์ชันถืออาวุธ
local function equipWeapon(weaponName)
    if weaponName == "" then return end
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    
    -- หา Tool ใน Character
    local tool = Character:FindFirstChild(weaponName)
    
    -- ถ้าไม่มีใน Character หาใน Backpack
    if not tool then
        tool = Backpack:FindFirstChild(weaponName)
        if tool then
            tool.Parent = Character -- ย้ายไป Character
        end
    end
    
    -- ถ้าเจอ Tool ก็ Equip
    if tool and tool:IsA("Tool") then
        Humanoid:EquipTool(tool)
        print("[DYHUB] Equipped:", weaponName)
    else
        print("[DYHUB] Tool not found:", weaponName)
    end
end

local Section1 = MainTab:CreateSection("Auto Equip (Beta)")

-- สร้าง Dropdown ใน Rayfield
local WeaponDropdown = MainTab:CreateDropdown({
    Name = "Select Weapon",
    Options = getWeaponList(),
    CurrentOption = "LOAD IN GAME",
    Flag = "WeaponDropdown",
    Callback = function(v)
        if v == "LOAD IN GAME" then
            selectedWeapon = ""
            print("[DYHUB] Cleared Weapon")
        else
            selectedWeapon = v
            print("[DYHUB] Selected Weapon:", selectedWeapon)
            equipWeapon(selectedWeapon)
        end
    end
})

-- Loop อัปเดตรายการอัตโนมัติ
task.spawn(function()
    local previousList = {}
    while true do
        local currentList = getWeaponList()
        local changed = false
        if #currentList ~= #previousList then
            changed = true
        else
            for i, v in ipairs(currentList) do
                if previousList[i] ~= v then
                    changed = true
                    break
                end
            end
        end

        if changed then
            WeaponDropdown:UpdateOptions(currentList)
            previousList = currentList
        end
        task.wait(1)
    end
end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESCAPE_DISTANCE = 15
local ESCAPE_SPEED = 3
local WARP_OFFSET = 6
local ATTACK_DISTANCE = 15
local autoFarmConnection
local killAuraEnabled2 = false

-- ฟังก์ชันหา melee tool ของเรา
local function getMeleeTool2()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") and item:FindFirstChild("RemoteEvent") then
            return item
        end
    end
    return nil
end

-- ฟังก์ชันเช็คว่าตัวละครอยู่บนพื้นหรือไม่
local function isOnGround(humanoid)
    return humanoid.FloorMaterial ~= Enum.Material.Air
end

-- ฟังก์ชันเช็คว่าเส้นทางวาร์ปชัดเจนหรือไม่
local function canWarp(startPos, endPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local result = workspace:Raycast(startPos, (endPos - startPos), raycastParams)
    return result == nil
end

AutoTab:CreateToggle({
    Name = "Auto Farm (AFK)",
    CurrentValue = false,
    Callback = function(value)
        killAuraEnabled2 = value

        if value then
            if autoFarmConnection then return end -- ป้องกันซ้ำ
            autoFarmConnection = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    local humanoidRoot = char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if not humanoidRoot or not humanoid then return end

                    local tool = getMeleeTool2()
                    local zombiesFolder = workspace:FindFirstChild("Zombies")
                    if not zombiesFolder then return end

                    -- หา zombie ใกล้ที่สุด
                    local closestZombie
                    local shortestDist = 9999
                    for _, zombie in ipairs(zombiesFolder:GetChildren()) do
                        local hum = zombie:FindFirstChildOfClass("Humanoid")
                        local root = zombie:FindFirstChild("HumanoidRootPart") or zombie:FindFirstChild("Head")
                        if hum and root and hum.Health > 0 then
                            local dist = (humanoidRoot.Position - root.Position).Magnitude
                            -- ตรวจสอบเส้นทางวาร์ปชัดเจน
                            if dist < shortestDist and canWarp(humanoidRoot.Position, root.Position) then
                                shortestDist = dist
                                closestZombie = root
                            end
                        end
                    end

                    if closestZombie then
                        local dist = (humanoidRoot.Position - closestZombie.Position).Magnitude

                        -- ถ้า zombie อยู่ใกล้ → ถอยหนี
                        if dist < ESCAPE_DISTANCE then
                            local escapeDir = (humanoidRoot.Position - closestZombie.Position).Unit
                            humanoidRoot.CFrame = humanoidRoot.CFrame + escapeDir * ESCAPE_SPEED
                        else
                            -- วาร์ปไปข้างหน้าหา zombie ถ้าอยู่บนพื้น
                            if isOnGround(humanoid) then
                                local forward = (closestZombie.Position - humanoidRoot.Position).Unit
                                humanoidRoot.CFrame = CFrame.new(closestZombie.Position - forward * WARP_OFFSET, closestZombie.Position)
                            end
                        end

                        -- Kill Aura
                        if tool and dist <= ATTACK_DISTANCE then
                            local event = tool:FindFirstChild("RemoteEvent")
                            if event then
                                event:FireServer("Swing", "Thrust")
                                event:FireServer("HitZombie", closestZombie.Parent, closestZombie.Position, true, Vector3.new(0,15,0), "Head", Vector3.new(0,1,0))
                            end
                        end
                    end
                end)
            end)
        else
            if autoFarmConnection then
                autoFarmConnection:Disconnect()
                autoFarmConnection = nil
            end
        end
    end
})

local Button = AutoTab:CreateButton({
   Name = "Auto Farm V1 (Reworked)",
   Callback = function()
      local player = game:GetService("Players").LocalPlayer
      local RunService = game:GetService("RunService")
      local TweenService = game:GetService("TweenService")

      if _G.DYHUB_AutoFarm_Running then
         warn("[DYHUB] Auto Farm already running!")
         return
      end
      _G.DYHUB_AutoFarm_Running = true

      -- ⚙ SETTINGS
      local ATTACK_COOLDOWN = 1
      local LAG_LEVEL = 8
      local highlightEnabled = true
      local currentMode = 2 -- 1: Stop | 2: Normal | 3: Clear Mode
      local lastAttackTime = 0

      local waitDelay = math.clamp(LAG_LEVEL * 0.4, 0, 1.2)

      -- 🌙 UI SETUP (ChatGPT Style)
      local gui = Instance.new("ScreenGui")
      gui.Name = "DYHUB_AutoFarmUI"
      gui.ResetOnSpawn = false
      gui.Parent = player:WaitForChild("PlayerGui")

      local frame = Instance.new("Frame")
      frame.Size = UDim2.new(0, 280, 0, 110)
      frame.Position = UDim2.new(0.5, -140, 0, 10)
      frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
      frame.BorderSizePixel = 0
      frame.BackgroundTransparency = 1
      frame.Parent = gui
      frame.Active = true
      frame.Draggable = true

      local UICorner = Instance.new("UICorner", frame)
      UICorner.CornerRadius = UDim.new(0, 12)

      local UIStroke = Instance.new("UIStroke", frame)
      UIStroke.Thickness = 1.6
      UIStroke.Color = Color3.fromRGB(0, 255, 120)
      UIStroke.Transparency = 0.3

      -- Fade-in
      TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.05}):Play()

      local title = Instance.new("TextLabel", frame)
      title.Text = "DYHUB | Auto Farm V1"
      title.Size = UDim2.new(1, 0, 0.3, 0)
      title.BackgroundTransparency = 1
      title.TextColor3 = Color3.fromRGB(0, 255, 130)
      title.Font = Enum.Font.GothamBold
      title.TextSize = 15

      local status = Instance.new("TextLabel", frame)
      status.Text = "🟢 Auto Attack: Enabled"
      status.Size = UDim2.new(1, 0, 0.3, 0)
      status.Position = UDim2.new(0, 0, 0.35, 0)
      status.BackgroundTransparency = 1
      status.TextColor3 = Color3.fromRGB(0, 255, 0)
      status.Font = Enum.Font.GothamBold
      status.TextSize = 14

      local modeBtn = Instance.new("TextButton", frame)
      modeBtn.Size = UDim2.new(0.9, 0, 0.25, 0)
      modeBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
      modeBtn.Font = Enum.Font.GothamBold
      modeBtn.TextSize = 14
      modeBtn.TextColor3 = Color3.new(1, 1, 1)
      modeBtn.AutoButtonColor = false
      modeBtn.BackgroundTransparency = 0.1

      local UICorner2 = Instance.new("UICorner", modeBtn)
      UICorner2.CornerRadius = UDim.new(0, 12)

      local colors = {
         [1] = Color3.fromRGB(255, 60, 60),
         [2] = Color3.fromRGB(40, 180, 80),
         [3] = Color3.fromRGB(255, 200, 60)
      }
      local names = {"Stop", "Normal", "Kill All"}

      local function updateMode()
         modeBtn.Text = "Mode: " .. names[currentMode]
         TweenService:Create(modeBtn, TweenInfo.new(0.25), {BackgroundColor3 = colors[currentMode]}):Play()
      end
      updateMode()

      modeBtn.MouseButton1Click:Connect(function()
         currentMode = currentMode % 3 + 1
         updateMode()
         game.StarterGui:SetCore("SendNotification", {
            Title = "Mode Changed",
            Text = modeBtn.Text,
            Duration = 3
         })
      end)

      -- ⚔ AUTO ATTACK SYSTEM
      local function getZombies()
         local folder = workspace:FindFirstChild("Zombies")
         if not folder then return {} end
         local zombies = {}
         for _, z in ipairs(folder:GetChildren()) do
            if z:IsA("Model") and z:FindFirstChild("Head") then
               table.insert(zombies, z)
            end
         end
         return zombies
      end

      local function attack()
         if currentMode == 1 then return end
         local now = os.clock()
         if now - lastAttackTime < ATTACK_COOLDOWN then return end

         local char = player.Character
         local root = char and char:FindFirstChild("HumanoidRootPart")
         if not root then return end

         local tool = char:FindFirstChildWhichIsA("Tool")
         local event = tool and (tool:FindFirstChildWhichIsA("RemoteEvent") or tool:FindFirstChild("MeleeBase") and tool.MeleeBase:FindFirstChildWhichIsA("RemoteEvent"))
         if not event then return end

         for _, zombie in ipairs(getZombies()) do
            local head = zombie:FindFirstChild("Head")
            local hum = zombie:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
               local dist = (head.Position - root.Position).Magnitude
               if dist <= 19 then
                  local pos = head.Position
                  local dir = (pos - root.Position).Unit
                  local knock = dir * 15

                  event:FireServer("Swing", "Thrust")
                  event:FireServer("HitZombie", zombie, pos, true, knock, "Head", Vector3.new(math.random(), math.random(), math.random()).Unit)

                  if currentMode == 3 then
                     for i = 1, 4 do
                        task.wait(0.15)
                        event:FireServer("Swing", "Thrust")
                        event:FireServer("HitZombie", zombie, pos + Vector3.new(0, 0.2 * i, 0), true, knock * (1 + i * 0.1), "Head", Vector3.new(math.random(), math.random(), math.random()).Unit)
                     end
                  end
               end
            end
         end
         lastAttackTime = now
      end

      -- ✨ ZOMBIE HIGHLIGHT
      local function highlightModel(model)
         if not model.PrimaryPart then
            model.PrimaryPart = model:FindFirstChildWhichIsA("BasePart")
         end
         if not model.PrimaryPart then return end
         if model:FindFirstChild("DYHUB_Highlight") then return end

         local hl = Instance.new("Highlight")
         hl.Name = "DYHUB_Highlight"
         hl.Adornee = model
         hl.FillTransparency = 0.5
         hl.OutlineTransparency = 0.2
         hl.FillColor = Color3.fromRGB(0, 255, 120)
         hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
         hl.Parent = model
      end

      local function updateHighlights()
         if not highlightEnabled then return end
         local zombies = getZombies()
         for _, zombie in ipairs(zombies) do
            highlightModel(zombie)
         end
      end

      -- 🔁 LOOP SYSTEM (Smooth)
      task.spawn(function()
         while _G.DYHUB_AutoFarm_Running do
            pcall(attack)
            task.wait(waitDelay)
            --pcall(updateHighlights)
            --task.wait(waitDelay)
         end
      end)

      game.StarterGui:SetCore("SendNotification", {
         Title = "✅ DYHUB Auto Farm V3",
         Text = "Smooth Auto-Attack Enabled",
         Duration = 6
      })
   end,
})

local Section = MainTab:CreateSection("Combat")

--========================
-- KILL AURA (Lightweight)
--========================
local killAuraEnabled = false
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

MainTab:CreateToggle({
    Name = "Kill Aura (Smart Focus)",
    CurrentValue = false,
    Callback = function(value)
        killAuraEnabled = value
    end
})

-- 🗡️ หาว่าตอนนี้ถืออาวุธมีดหรือยัง
local function getMeleeTool()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") and item:FindFirstChild("RemoteEvent") then
            return item
        end
    end
    return nil
end

-- 🔎 หา zombie ที่อยู่ใกล้ที่สุด
local function getClosestZombie(maxDistance)
    local folder = Workspace:FindFirstChild("Zombies")
    if not folder then return nil end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closestZombie
    local shortestDist = maxDistance or 9999

    for _, zombie in ipairs(folder:GetChildren()) do
        local hum = zombie:FindFirstChildOfClass("Humanoid")
        local rootPart = zombie:FindFirstChild("HumanoidRootPart") or zombie:FindFirstChild("Head")
        if hum and rootPart and hum.Health > 0 then
            local dist = (rootPart.Position - root.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                closestZombie = zombie
            end
        end
    end

    return closestZombie
end

-- ⚔️ ระบบโจมตีอัตโนมัติ
task.spawn(function()
    while true do
        task.wait(0.01) -- ลดโหลดเครื่อง
        if killAuraEnabled then
            local char = LocalPlayer.Character
            local tool = getMeleeTool()
            if char and tool then
                local target = getClosestZombie(19)
                if target then
                    local rootPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
                    if rootPart then
                        local distance = (rootPart.Position - char.HumanoidRootPart.Position).Magnitude
                        if distance <= 18 then
                            pcall(function()
                                tool.RemoteEvent:FireServer("Swing", "Thrust")
                                tool.RemoteEvent:FireServer(
                                    "HitZombie",
                                    target,
                                    rootPart.Position,
                                    true,
                                    Vector3.new(0, 15, 0),
                                    "Head",
                                    Vector3.new(0, 1, 0)
                                )
                            end)
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.001) -- ลดโหลดเครื่อง
        if killAuraEnabled2 then
            local char = LocalPlayer.Character
            local tool = getMeleeTool()
            if char and tool then
                local target = getClosestZombie(19)
                if target then
                    local rootPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
                    if rootPart then
                        local distance = (rootPart.Position - char.HumanoidRootPart.Position).Magnitude
                        if distance <= 18 then
                            pcall(function()
                                tool.RemoteEvent:FireServer("Swing", "Thrust")
                                tool.RemoteEvent:FireServer(
                                    "HitZombie",
                                    target,
                                    rootPart.Position,
                                    true,
                                    Vector3.new(0, 15, 0),
                                    "Head",
                                    Vector3.new(0, 1, 0)
                                )
                            end)
                        end
                    end
                end
            end
        end
    end
end)

--========================
-- AUTO HEADSHOT
--========================
local headshotEnabled = false
MainTab:CreateToggle({
    Name = "Auto Headshot",
    CurrentValue = false,
    Callback = function(value)
        headshotEnabled = value
        if headshotEnabled then
            local modules = {
                Workspace:FindFirstChild("Flintlock") and Workspace.Flintlock:FindFirstChild("BayonetHitCheck"),
                Workspace:FindFirstChild("MeleeBase") and Workspace.MeleeBase:FindFirstChild("MeleeHitCheck")
            }
            for _, module in pairs(modules) do
                if module and module:IsA("ModuleScript") then
                    local old = require(module)
                    old.Check = function(_, target)
                        local char = target.Parent
                        local head = char and char:FindFirstChild("Head")
                        return head or target
                    end
                end
            end
        end
    end
})

local Section = MainTab:CreateSection("Player")


--====================================================
--// WALK SPEED SECTION
--====================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🏃‍♂️ ตัวแปรหลัก
local customSpeed = 16 -- default
local tpWalkSpeed = 50
local freezeWalkSpeed = false

-- 🧭 ป้อนความเร็วแบบ WalkSpeed ปกติ
MainTab:CreateInput({
    Name = "Set Speed (WalkSpeed)",
    PlaceholderText = "Enter speed (e.g. 50)",
    RemoveTextAfterFocusLost = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            customSpeed = num
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = num
            end
            game.StarterGui:SetCore("SendNotification", {
                Title = "WalkSpeed Updated",
                Text = "Set to " .. tostring(num),
                Duration = 3
            })
        end
    end,
})

-- 🚀 ป้อนความเร็วแบบ TPWalk (เทเลพอร์ตเป็นระยะ)
MainTab:CreateInput({
    Name = "Set Speed (Cframe)",
    PlaceholderText = "Enter speed (e.g. 100)",
    RemoveTextAfterFocusLost = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            tpWalkSpeed = num
            game.StarterGui:SetCore("SendNotification", {
                Title = "TPWalk Speed Updated",
                Text = "Set to " .. tostring(num),
                Duration = 3
            })
        end
    end,
})

-- 🔒 Lock WalkSpeed ให้คงที่
MainTab:CreateToggle({
    Name = "Lock Set Speed",
    CurrentValue = false,
    Callback = function(Value)
        freezeWalkSpeed = Value
        if Value then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Lock Speed Enabled",
                Text = "WalkSpeed locked at " .. tostring(customSpeed),
                Duration = 3
            })
        else
            game.StarterGui:SetCore("SendNotification", {
                Title = "Lock Speed Disabled",
                Text = "Speed now changeable again",
                Duration = 3
            })
        end

        -- 🔁 loop ป้องกัน WalkSpeed ถูกรีเซ็ต
        task.spawn(function()
            while freezeWalkSpeed do
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChild("Humanoid")
                if hum and hum.WalkSpeed ~= customSpeed then
                    hum.WalkSpeed = customSpeed
                end
                task.wait(0.2)
            end
        end)
    end,
})

-- ⚡ ระบบ TPWalk (เทเลพอร์ตเดินเร็ว)
task.spawn(function()
    local RunService = game:GetService("RunService")
    while true do
        task.wait(0.02)
        if tpWalkSpeed > 16 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local char = LocalPlayer.Character
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.MoveDirection.Magnitude > 0 then
                -- เคลื่อนย้ายด้วยการเทเลพอร์ตเล็กๆ
                char:TranslateBy(hum.MoveDirection * (tpWalkSpeed / 100))
            end
        end
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local noclipConnection -- เก็บ connection ของ Noclip

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(value)
        if value then
            -- 🔧 เปิด Noclip
            if not noclipConnection then
                noclipConnection = RunService.Stepped:Connect(function()
                    local char = LocalPlayer.Character
                    if char then
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end
        else
            -- 🔧 ปิด Noclip
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            -- คืนค่า CanCollide ให้ปกติ
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

MainTab:CreateButton({
   Name = "Fly (V3)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))() 

   end,
})

local Section = AntiTab:CreateSection("Anti Mobs")

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local ESCAPE_DISTANCE_DEER = 15   -- ระยะที่เริ่มหนี
local ESCAPE_SPEED_DEER = 1       -- ความเร็วหนี
local escapeLoopDeer

AntiTab:CreateToggle({
    Name = "Anti Zombie (All)",
    CurrentValue = false,
    Callback = function(value)
        if value then
            escapeLoopDeer = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    HumanoidRootPart = char:FindFirstChild("HumanoidRootPart")
                    if not HumanoidRootPart then return end

                    local zombiesFolder = workspace:FindFirstChild("Zombies")
                    if not zombiesFolder then return end

                    local closestZombie
                    local shortestDist = ESCAPE_DISTANCE_DEER

                    -- 🔎 หา zombie ใกล้ที่สุด
                    for _, deer in ipairs(zombiesFolder:GetChildren()) do
                        local hum = deer:FindFirstChildOfClass("Humanoid")
                        local root = deer:FindFirstChild("HumanoidRootPart") or deer:FindFirstChild("Head")
                        if hum and root and hum.Health > 0 then
                            local distance = (HumanoidRootPart.Position - root.Position).Magnitude
                            if distance < shortestDist then
                                shortestDist = distance
                                closestZombie = root
                            end
                        end
                    end

                    -- ⚡ หนี zombie ใกล้ที่สุด
                    if closestZombie then
                        local direction = (HumanoidRootPart.Position - closestZombie.Position).Unit
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_DEER
                    end
                end)
            end)
        else
            if escapeLoopDeer then
                escapeLoopDeer:Disconnect()
                escapeLoopDeer = nil
            end
        end
    end
})

local Section = AntiTab:CreateSection("Anti Boss")

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESCAPE_DISTANCE_BOSS = 22  -- ระยะที่เริ่มหนีจาก Boss
local ESCAPE_SPEED_BOSS = 4.5      -- ความเร็วหนี
local escapeLoopBoss

-- ฟังก์ชันสำหรับรอ Boss ให้ปรากฏตัว
local function getBoss()
    local sleepyHollow = workspace:WaitForChild("Sleepy Hollow")
    local modes = sleepyHollow:WaitForChild("Modes")
    local bossFolder = modes:WaitForChild("Boss")
    local bossObject

    -- รอจนกว่า HeadlessHorsemanBoss จะขึ้น
    repeat
        bossObject = bossFolder:FindFirstChild("HeadlessHorsemanBoss")
        if bossObject then
            bossObject = bossObject:FindFirstChild("HeadlessHorseman")
        end
        wait(0.5)
    until bossObject

    return bossObject
end

AntiTab:CreateToggle({
    Name = "Anti Headless Horseman (Escape)",
    CurrentValue = false,
    Callback = function(value)
        if value then
            -- รอ Boss ให้ขึ้นก่อน แล้วค่อยเริ่ม loop
            spawn(function()
                local boss = getBoss()
                escapeLoopBoss = RunService.RenderStepped:Connect(function()
                    pcall(function()
                        local char = LocalPlayer.Character
                        if not char then return end
                        local HumanoidRootPart = char:FindFirstChild("HumanoidRootPart")
                        if not HumanoidRootPart then return end

                        if boss and boss:FindFirstChild("HumanoidRootPart") then
                            local bossRoot = boss.HumanoidRootPart
                            local distance = (HumanoidRootPart.Position - bossRoot.Position).Magnitude

                            if distance < ESCAPE_DISTANCE_BOSS then
                                local direction = (HumanoidRootPart.Position - bossRoot.Position).Unit
                                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_BOSS
                            end
                        end
                    end)
                end)
            end)
        else
            if escapeLoopBoss then
                escapeLoopBoss:Disconnect()
                escapeLoopBoss = nil
            end
        end
    end
})

local Section = EspTab:CreateSection("ESP")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

--========================
-- ESP SETTINGS
--========================
local espToggles = {
    Runner = false,
    Bomber = false,
    Igniter = false,
    Cuirassier = false
}

local colors = {
    Runner = Color3.fromRGB(0, 255, 0),
    Bomber = Color3.fromRGB(0, 0, 255),
    Igniter = Color3.fromRGB(255, 255, 0),
    Cuirassier = Color3.fromRGB(255, 0, 0)
}

local MAX_DISTANCE = 40
local UPDATE_INTERVAL = 0.5 -- slightly faster for smoother ESP

--========================
-- ZOMBIE TYPE DETECTION
--========================
local function getZombieType(zombie)
    if not zombie then return nil end
    if zombie:FindFirstChild("Barrel") then
        return "Bomber"
    elseif zombie:FindFirstChild("Whale Oil Lantern") then
        return "Igniter"
    elseif zombie:FindFirstChild("Sword") then
        return "Cuirassier"
    elseif zombie:FindFirstChild("Humanoid") and zombie.Humanoid.WalkSpeed > 16 then
        return "Runner"
    end
    return nil
end

--========================
-- ESP UPDATE FUNCTION
--========================
local function updateESP()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, zombie in pairs(Workspace:GetChildren()) do
        local hrp = zombie:FindFirstChild("HumanoidRootPart")
        if hrp then
            local distance = (root.Position - hrp.Position).Magnitude
            if distance <= MAX_DISTANCE then
                local zType = getZombieType(zombie)
                if zType and espToggles[zType] then
                    local hl = zombie:FindFirstChild("ESP_Highlight")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "ESP_Highlight"
                        hl.Adornee = zombie
                        hl.FillColor = colors[zType]
                        hl.OutlineColor = Color3.new(0, 0, 0)
                        hl.FillTransparency = 0.3
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = zombie
                    else
                        hl.FillColor = colors[zType] -- update color dynamically
                    end
                elseif zombie:FindFirstChild("ESP_Highlight") then
                    zombie.ESP_Highlight:Destroy() -- remove highlight if toggle off
                end
            elseif zombie:FindFirstChild("ESP_Highlight") then
                zombie.ESP_Highlight:Destroy() -- remove highlight if out of range
            end
        end
    end
end

--========================
-- ESP LOOP
--========================
task.spawn(function()
    while true do
        task.wait(UPDATE_INTERVAL)
        pcall(updateESP)
    end
end)

--========================
-- RAYFIELD TOGGLES
--========================
for zType, _ in pairs(espToggles) do
    EspTab:CreateToggle({
        Name = zType .. " ESP",
        CurrentValue = false,
        Callback = function(value)
            espToggles[zType] = value
        end
    })
end


local PlayerSection = EspTab:CreateSection("Player ESP")

-- Medic Player ESP
EspTab:CreateToggle({
    Name = "Medic Player ESP",
    CurrentValue = false,
    Flag = "MedicESPToggle",
    Callback = function(state)
        espLifeToggled = state
        checkPlayersLife() -- Handles highlighting low HP players
    end
})

-- Father Infection ESP
EspTab:CreateToggle({
    Name = "Father Infection ESP",
    CurrentValue = false,
    Flag = "FatherInfectionESPToggle",
    Callback = function(state)
        espLifeToggled = state
        checkPlayersLife() -- Handles highlighting infected players
    end
})


local Section = MainTab:CreateSection("Misc")

local Button = MainTab:CreateButton({
   Name = "Anti-Cheat bypass",
   Callback = function()
   -- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
-- Local Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
local humanoid = character:WaitForChild("Humanoid", 5)

-- Validate character
if not humanoidRootPart or not humanoid then
    warn("Character not found. Walking...")
    player.CharacterAdded:Wait()
    character = player.Character
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoidRootPart or not humanoid then
        warn("Character load failed. Script terminated.")
        return
    end
end

local Lighting = game:GetService("Lighting")

local fullBrightEnabled = false
local noFogEnabled = false

-- เก็บค่าเดิม
local originalBrightness = Lighting.Brightness
local originalClockTime = Lighting.ClockTime
local originalAmbient = Lighting.Ambient

local originalAtmosphereDensity = Lighting:FindFirstChild("Atmosphere") and Lighting.Atmosphere.Density or nil
local originalFogStart = Lighting.FogStart
local originalFogEnd = Lighting.FogEnd

-- Full Bright Toggle
EspTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,
    Flag = "FullBrightToggle",
    Callback = function(v)
        fullBrightEnabled = v
        if v then
            task.spawn(function()
                while fullBrightEnabled do
                    if Lighting.Brightness ~= 2 then
                        Lighting.Brightness = 2
                    end
                    if Lighting.ClockTime ~= 14 then
                        Lighting.ClockTime = 14
                    end
                    if Lighting.Ambient ~= Color3.fromRGB(255,255,255) then
                        Lighting.Ambient = Color3.fromRGB(255,255,255)
                    end
                    task.wait(0.5)
                end
            end)
        else
            -- คืนค่าเดิม
            Lighting.Brightness = originalBrightness
            Lighting.ClockTime = originalClockTime
            Lighting.Ambient = originalAmbient
        end
    end
})

-- No Fog Toggle (รองรับ Atmosphere + FogStart/FogEnd)
EspTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Flag = "NoFogToggle",
    Callback = function(v)
        noFogEnabled = v
        if v then
            task.spawn(function()
                while noFogEnabled do
                    -- สำหรับ Atmosphere
                    if Lighting:FindFirstChild("Atmosphere") then
                        if Lighting.Atmosphere.Density ~= 0 then
                            Lighting.Atmosphere.Density = 0
                        end
                    end
                    -- สำหรับ FogStart/FogEnd
                    if Lighting.FogStart ~= 1e6 then
                        Lighting.FogStart = 1e6
                    end
                    if Lighting.FogEnd ~= 1e6 then
                        Lighting.FogEnd = 1e6
                    end
                    task.wait(0.5)
                end
            end)
        else
            -- คืนค่าเดิม
            if Lighting:FindFirstChild("Atmosphere") and originalAtmosphereDensity then
                Lighting.Atmosphere.Density = originalAtmosphereDensity
            end
            Lighting.FogStart = originalFogStart
            Lighting.FogEnd = originalFogEnd
        end
    end
})

-- Variables
local flying = false
local noclipping = false
local speed = 50
local mobileMovement = {x = 0, y = 0}
local control = {forward = 0, backward = 0, left = 0, right = 0, up = 0, down = 0}

local flyConnection
local noclipConnection
local antiPullbackConnection

-- Position tracking
local lastPosition = humanoidRootPart.Position
local positionHistory = {}
local maxHistorySize = 30
local pullbackThreshold = 1.5
local stuckCounter = 0
local lastSafePosition = humanoidRootPart.CFrame

-- Mobile detection
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local mobileFrame = nil
local mobileVisible = false
local MobileToggle = nil

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NoclipFlyGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui", 5)

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 160, 0, 180)
Frame.Position = UDim2.new(1, -170, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Fly & Noclip Bypass"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.TextSize = 11
Title.Font = Enum.Font.GothamBold
Title.TextWrapped = true
Title.Parent = Frame

-- Fly Button
local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0.85, 0, 0, 28)
FlyButton.Position = UDim2.new(0.075, 0, 0.2, 0)
FlyButton.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
FlyButton.Text = "Fly: OFF"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 11
FlyButton.Font = Enum.Font.GothamBold
FlyButton.Parent = Frame

-- Noclip Button
local NoclipButton = Instance.new("TextButton")
NoclipButton.Size = UDim2.new(0.85, 0, 0, 28)
NoclipButton.Position = UDim2.new(0.075, 0, 0.4, 0)
NoclipButton.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
NoclipButton.Text = "Noclip: OFF"
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.TextSize = 11
NoclipButton.Font = Enum.Font.GothamBold
NoclipButton.Parent = Frame

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.85, 0, 0, 25)
StatusLabel.Position = UDim2.new(0.075, 0, 0.82, 0)
StatusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.TextSize = 9
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = Frame

-- Mobile Toggle Button (if mobile)
if isMobile then
    MobileToggle = Instance.new("TextButton")
    MobileToggle.Size = UDim2.new(0.85, 0, 0, 28)
    MobileToggle.Position = UDim2.new(0.075, 0, 0.6, 0)
    MobileToggle.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
    MobileToggle.Text = "Mobile Controls: OFF"
    MobileToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MobileToggle.TextSize = 11
    MobileToggle.Font = Enum.Font.GothamBold
    MobileToggle.Parent = Frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = MobileToggle
end

-- Styling
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = Frame
for _, btn in pairs({FlyButton, NoclipButton}) do
    corner:Clone().Parent = btn
end
if MobileToggle then
    corner:Clone().Parent = MobileToggle
end
corner:Clone().Parent = StatusLabel
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 70, 70)
stroke.Thickness = 1
stroke.Parent = Frame

-- Function to create mobile controls
local function createMobileControls()
    if mobileFrame then return end
    
    mobileFrame = Instance.new("Frame")
    mobileFrame.Name = "MobileControls"
    mobileFrame.Size = UDim2.new(0, 170, 0, 200)
    mobileFrame.Position = UDim2.new(0, 10, 1, -210)
    mobileFrame.BackgroundTransparency = 1
    mobileFrame.Visible = false
    mobileFrame.Parent = ScreenGui
    
    local buttonData = {
        {name = "E", pos = UDim2.new(0, 55, 0, 0), text = "E"},
        {name = "W", pos = UDim2.new(0, 55, 0, 50), text = "W"},
        {name = "A", pos = UDim2.new(0, 10, 0, 100), text = "A"},
        {name = "S", pos = UDim2.new(0, 55, 0, 100), text = "S"},
        {name = "D", pos = UDim2.new(0, 100, 0, 100), text = "D"},
        {name = "Q", pos = UDim2.new(0, 55, 0, 150), text = "Q"},
    }
    
    for _, data in ipairs(buttonData) do
        local btn = Instance.new("TextButton")
        btn.Name = data.name
        btn.Position = data.pos
        btn.Size = UDim2.new(0, 40, 0, 40)
        btn.Text = data.text
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 20
        btn.Font = Enum.Font.GothamBold
        btn.Parent = mobileFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 20)
        btnCorner.Parent = btn
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(100, 100, 100)
        btnStroke.Thickness = 2
        btnStroke.Parent = btn
        
        btn.MouseButton1Down:Connect(function()
            if data.name == "W" then
                control.forward = 1
            elseif data.name == "A" then
                control.left = 1
            elseif data.name == "S" then
                control.backward = 1
            elseif data.name == "D" then
                control.right = 1
            elseif data.name == "E" then
                control.up = 1
            elseif data.name == "Q" then
                control.down = 1
            end
        end)
        
        btn.MouseButton1Up:Connect(function()
            if data.name == "W" then
                control.forward = 0
            elseif data.name == "A" then
                control.left = 0
            elseif data.name == "S" then
                control.backward = 0
            elseif data.name == "D" then
                control.right = 0
            elseif data.name == "E" then
                control.up = 0
            elseif data.name == "Q" then
                control.down = 0
            end
        end)
    end
    
    -- Close button for mobile controls
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 10)
    closeBtn.Text = "✕"
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = mobileFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        mobileVisible = false
        if mobileFrame then
            mobileFrame.Visible = false
        end
        if MobileToggle then
            MobileToggle.Text = "Mobile Controls: OFF"
            MobileToggle.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
        end
    end)
end

-- Create mobile controls if mobile
if isMobile then
    createMobileControls()
end

-- Mobile Toggle Event
if MobileToggle then
    MobileToggle.MouseButton1Click:Connect(function()
        mobileVisible = not mobileVisible
        if mobileFrame then
            mobileFrame.Visible = mobileVisible
        end
        MobileToggle.Text = mobileVisible and "Mobile Controls: ON" or "Mobile Controls: OFF"
        MobileToggle.BackgroundColor3 = mobileVisible and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 100, 50)
    end)
end

-- ฟังก์ชันตรวจสอบว่าอยู่ในกำแพงหรือไม่
local function isInWall()
    if not humanoidRootPart then return false end
    
    local region = Region3.new(
        humanoidRootPart.Position - Vector3.new(3.5, 3.5, 3.5),
        humanoidRootPart.Position + Vector3.new(3.5, 3.5, 3.5)
    )
    region = region:ExpandToGrid(4)
    
    local parts = workspace:FindPartsInRegion3(region, character, 100)
    for _, part in pairs(parts) do
        if part.CanCollide and not part:IsDescendantOf(character) then
            return true
        end
    end
    return false
end

-- ฟังก์ชันตรวจสอบการดึงกลับ
local function detectPullback()
    if not humanoidRootPart then return false end
    
    local currentPos = humanoidRootPart.Position
    local distance = (currentPos - lastPosition).Magnitude
    
    -- ตรวจหาการเคลื่อนที่ที่ผิดปกติ
    if distance > pullbackThreshold then
        return true
    end
    
    local moveDir = humanoid.MoveDirection + Vector3.new(mobileMovement.x, 0, mobileMovement.y)
    
    -- ถ้ากำลังเคลื่อนที่แต่ไม่มีความเร็ว = ติด
    if distance < 0.02 and moveDir.Magnitude > 0.5 then
        stuckCounter = stuckCounter + 1
        if stuckCounter > 2 then
            return true
        end
    else
        stuckCounter = 0
    end
    
    lastPosition = currentPos
    return false
end

-- ฟังก์ชันรีเซ็ต Humanoid State
local function resetHumanoidState()
    if not humanoid or not humanoidRootPart then return end
    
    humanoid.PlatformStand = false
    humanoid.Sit = false
    
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    task.wait(0.05)
    humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    task.wait(0.05)
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
    
    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    
    task.wait(0.1)
    humanoid.PlatformStand = false
end

-- ฟังก์ชัน Fly
local function startFly()
    if flying or not humanoidRootPart or humanoid.Health <= 0 then return end
    flying = true
    FlyButton.Text = "Fly: ON"
    FlyButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    
    StatusLabel.Text = noclipping and "Status: Fly + Noclip" or "Status: Flying"
    StatusLabel.TextColor3 = noclipping and Color3.fromRGB(255, 255, 100) or Color3.fromRGB(100, 200, 255)
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 3000
    bodyGyro.D = 500
    bodyGyro.Parent = humanoidRootPart
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.P = 1250
    bodyVelocity.Parent = humanoidRootPart

    flyConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not flying or not humanoidRootPart or humanoid.Health <= 0 then
            stopFly()
            return
        end

        local camera = workspace.CurrentCamera
        if not camera then return end
        
        bodyGyro.CFrame = camera.CFrame

        local moveVector = Vector3.new(
            (control.right - control.left) + mobileMovement.x,
            control.up - control.down,
            (control.forward - control.backward) + mobileMovement.y
        )

        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit
            
            local lookDirection = camera.CFrame.LookVector
            local rightDirection = camera.CFrame.RightVector
            local upDirection = Vector3.new(0, 1, 0)
            
            local direction = (lookDirection * moveVector.Z + rightDirection * moveVector.X + upDirection * moveVector.Y).Unit
            
            local targetVelocity = direction * speed
            bodyVelocity.Velocity = targetVelocity
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function stopFly()
    if not flying then return end
    flying = false
    FlyButton.Text = "Fly: OFF"
    FlyButton.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
    
    StatusLabel.Text = noclipping and "Status: Noclip Active" or "Status: Ready"
    StatusLabel.TextColor3 = noclipping and Color3.fromRGB(255, 150, 255) or Color3.fromRGB(100, 255, 100)
    
    if humanoidRootPart then
        for _, child in pairs(humanoidRootPart:GetChildren()) do
            if child:IsA("BodyGyro") or child:IsA("BodyVelocity") then
                child:Destroy()
            end
        end
    end
    
    resetHumanoidState()
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

-- ฟังก์ชัน Noclip
local function startNoclip()
    if noclipping then return end
    noclipping = true
    NoclipButton.Text = "Noclip: ON"
    NoclipButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    
    StatusLabel.Text = flying and "Status: Fly + Noclip" or "Status: Noclip Active"
    StatusLabel.TextColor3 = flying and Color3.fromRGB(255, 255, 100) or Color3.fromRGB(255, 150, 255)
    
    print("Noclip ON")
    
    pcall(function()
        humanoidRootPart:SetNetworkOwner(player)
    end)
    
    positionHistory = {}
    lastPosition = humanoidRootPart.Position
    
    -- Noclip Loop - ปิด CanCollide ทั้งหมด
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipping or not character or not humanoidRootPart then return end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        if humanoidRootPart then
            humanoidRootPart.AssemblyLinearVelocity = humanoidRootPart.Velocity
        end
    end)
    
    -- Anti-Pullback Loop - เก็บตำแหน่งปลอดภัยทุกวินาที
    antiPullbackConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not noclipping or not humanoidRootPart then return end
        
        local moveDir = humanoid.MoveDirection + Vector3.new(mobileMovement.x, 0, mobileMovement.y)
        local isMoving = moveDir.Magnitude > 0
        
        -- บันทึกตำแหน่งปลอดภัย - ทุก frame เมื่อมีการเคลื่อนที่
        if isMoving then
            lastSafePosition = humanoidRootPart.CFrame
            table.insert(positionHistory, humanoidRootPart.CFrame)
            if #positionHistory > maxHistorySize then
                table.remove(positionHistory, 1)
            end
        end
        
        -- ตรวจสอบการดึงกลับอย่างอยวาไพ
        if detectPullback() and isMoving then
            -- วิธีที่ 1: กระโดดกลับตำแหน่งล่าสุด
            humanoidRootPart.CFrame = lastSafePosition
            
            -- วิธีที่ 2: รีเซ็ต velocity เสียสนิท
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            
            -- วิธีที่ 3: บังคับอัพเดท network
            for _ = 1, 3 do
                pcall(function()
                    humanoidRootPart:SetNetworkOwner(player)
                end)
            end
            
            -- วิธีที่ 4: ผลักตัวออกจากจุดปัญหา
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + (moveDir * 0.5)
            end
        end
        
        -- ผลักตัวไปข้างหน้า (ความเร็วปกติ 16 แต่ลดแรง)
        if isMoving and not flying then
            moveDir = moveDir.Unit
            
            local bodyVel = humanoidRootPart:FindFirstChild("NoclipPush")
            if not bodyVel then
                bodyVel = Instance.new("BodyVelocity")
                bodyVel.Name = "NoclipPush"
                bodyVel.MaxForce = Vector3.new(50000, 50000, 50000)
                bodyVel.P = 3000
                bodyVel.Parent = humanoidRootPart
            end
            bodyVel.Velocity = moveDir * 16
            
            -- ลด nudge เพื่อให้นิ่มนวล
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + (moveDir * 0.05)
        else
            local bodyVel = humanoidRootPart:FindFirstChild("NoclipPush")
            if bodyVel then
                bodyVel:Destroy()
            end
        end
        
        humanoidRootPart.AssemblyLinearVelocity = humanoidRootPart.Velocity
    end)
end

local function stopNoclip()
    if not noclipping then return end
    noclipping = false
    NoclipButton.Text = "Noclip: OFF"
    NoclipButton.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
    
    StatusLabel.Text = flying and "Status: Flying" or "Status: Ready"
    StatusLabel.TextColor3 = flying and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(100, 255, 100)
    
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if antiPullbackConnection then
        antiPullbackConnection:Disconnect()
        antiPullbackConnection = nil
    end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part:IsDescendantOf(character) then
            if part.Name == "Head" or part.Name == "Torso" or part.Name == "HumanoidRootPart" 
                or part.Name:match("Arm") or part.Name:match("Leg") 
                or part.Parent.Name == "UpperTorso" or part.Parent.Name == "LowerTorso" then
                part.CanCollide = true
            end
        end
    end
    
    if humanoidRootPart then
        local noclipPush = humanoidRootPart:FindFirstChild("NoclipPush")
        if noclipPush then
            noclipPush:Destroy()
        end
    end
    
    task.wait(0.15)
    
    if humanoidRootPart and not flying then
        local camera = workspace.CurrentCamera
        local nudgeAmount = 2
        local nudgeDirection = (camera.CFrame.LookVector + Vector3.new(0, 1, 0)).Unit * nudgeAmount
        humanoidRootPart.CFrame = humanoidRootPart.CFrame + nudgeDirection
        
        pcall(function()
            humanoidRootPart:SetNetworkOwner(player)
        end)
    end
    
    if not flying then
        task.wait(0.2)
        resetHumanoidState()
        
        if humanoid then
            humanoid.Jump = true
            task.wait(0.1)
            humanoid.Jump = false
        end
    end
    
    if humanoid then
        humanoid.WalkSpeed = 16
    end
end

-- Button Events
FlyButton.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

NoclipButton.MouseButton1Click:Connect(function()
    if noclipping then stopNoclip() else startNoclip() end
end)

-- Keyboard Controls
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then control.forward = 1
    elseif key == Enum.KeyCode.S then control.backward = 1
    elseif key == Enum.KeyCode.A then control.left = 1
    elseif key == Enum.KeyCode.D then control.right = 1
    elseif key == Enum.KeyCode.E then control.up = 1
    elseif key == Enum.KeyCode.Q then control.down = 1
    elseif key == Enum.KeyCode.Space then control.up = 1
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if processed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then control.forward = 0
    elseif key == Enum.KeyCode.S then control.backward = 0
    elseif key == Enum.KeyCode.A then control.left = 0
    elseif key == Enum.KeyCode.D then control.right = 0
    elseif key == Enum.KeyCode.E then control.up = 0
    elseif key == Enum.KeyCode.Q then control.down = 0
    elseif key == Enum.KeyCode.Space then control.up = 0
    end
end)

-- Mobile Support (Joystick - disabled when mobile buttons visible)
UserInputService.TouchMoved:Connect(function(touch, processed)
    if UserInputService:GetFocusedTextBox() or mobileVisible then return end
    
    local touchPos = touch.Position
    local screenSize = ScreenGui.Parent.AbsoluteSize
    
    local deadzoneRadius = 40
    local centerLeft = Vector2.new(screenSize.X * 0.15, screenSize.Y * 0.85)
    
    local diff = touchPos - centerLeft
    if diff.Magnitude > deadzoneRadius then
        local dir = diff.Unit
        mobileMovement.x = math.min(1, dir.X)
        mobileMovement.y = math.min(1, -dir.Y)
    else
        mobileMovement.x = 0
        mobileMovement.y = 0
    end
end)

UserInputService.TouchEnded:Connect(function(touch, processed)
    mobileMovement.x = 0
    mobileMovement.y = 0
end)

-- Respawn Handling
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    humanoid = character:WaitForChild("Humanoid", 5)
    positionHistory = {}
    lastPosition = humanoidRootPart.Position
    
    local wasFlying = flying
    local wasNoclipping = noclipping
    
    if wasFlying or wasNoclipping then
        task.wait(0.5)
        if wasNoclipping then startNoclip() end
        if wasFlying then startFly() end
    end
end)

-- Initialize
humanoid.WalkSpeed = 16
humanoid.JumpPower = 50

pcall(function()
    humanoidRootPart:SetNetworkOwner(player)
end)

print("Fly & Noclip System loaded!")
   end,
})

-- Bomber-only Aimbot (targets ONLY models that contain a child named "Torch")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Config (defaults)
local bomberAimbotEnabled = false
local bomberAimbotDistance = 60     -- max range (studs)
local bomberSmoothing = 0.18        -- lerp alpha (0 = instant, 0.2 = smooth)
local bomberHoldToAim = false       -- when true, only aim while RMB is held

-- Rayfield UI (assumes MainTab is defined)
MainTab:CreateToggle({
    Name = "Bomber Aimbot",
    CurrentValue = bomberAimbotEnabled,
    Callback = function(val) bomberAimbotEnabled = val end
})

MainTab:CreateSlider({
    Name = "Bomber Aim Distance",
    Range = {20, 200},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = bomberAimbotDistance,
    Callback = function(val) bomberAimbotDistance = val end
})

MainTab:CreateSlider({
    Name = "Bomber Aim Smoothing",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = bomberSmoothing,
    Callback = function(val) bomberSmoothing = val end
})

MainTab:CreateToggle({
    Name = "Hold Right Mouse To Aim",
    CurrentValue = bomberHoldToAim,
    Callback = function(val) bomberHoldToAim = val end
})

-- Internal hold state
local rightHeld = false
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then rightHeld = true end
end)
UserInputService.InputEnded:Connect(function(inp, gpe)
    if gpe then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then rightHeld = false end
end)

-- Helper: find the closest valid target (model that contains a child named "Torch")
local function getClosestTorchTarget(maxDist)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local bestTarget = nil
    local bestDist = maxDist + 0.0001

    -- Use GetDescendants to catch nested setups, but filter by model with Humanoid
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            -- check for Torch child anywhere inside the model
            if obj:FindFirstChild("Torch", true) then
                -- prefer Head, fallback to HumanoidRootPart
                local targetPart = obj:FindFirstChild("Head") or obj:FindFirstChild("HumanoidRootPart")
                if targetPart and targetPart.Position then
                    local d = (root.Position - targetPart.Position).Magnitude
                    if d <= maxDist and d < bestDist then
                        bestDist = d
                        bestTarget = targetPart
                    end
                end
            end
        end
    end

    return bestTarget
end

-- Aim loop: smooth camera rotation toward the chosen target
local aimConn
aimConn = RunService.RenderStepped:Connect(function(dt)
    if not bomberAimbotEnabled then return end
    if bomberHoldToAim and not rightHeld then return end

    local targetPart = getClosestTorchTarget(bomberAimbotDistance)
    if not targetPart then return end

    -- compute lookCFrame preserving camera position
    local camCFrame = Camera.CFrame
    local camPos = camCFrame.Position
    local targetPos = targetPart.Position

    local desiredCFrame = CFrame.new(camPos, targetPos)
    -- smooth lerp (clamp smoothing to 0..1)
    local alpha = math.clamp(bomberSmoothing, 0, 1)
    local newCFrame = camCFrame:Lerp(desiredCFrame, alpha)

    -- apply new camera CFrame
    Camera.CFrame = newCFrame
end)

Rayfield:Notify({
   Title = "Guts & Blackpowder",
   Content = ver,
   Duration = 3.1,
   Image = 104487529937663,
})

-- Optional cleanup function (call if you unload script)
local function cleanupAimbot()
    if aimConn then
        aimConn:Disconnect()
        aimConn = nil
    end
end

-- Return cleanup if you want to expose it (not required)
return {
    cleanup = cleanupAimbot
}
