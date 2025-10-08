-- =========================
local version = "CUSTOM"
-- =========================

repeat task.wait() until game:IsLoaded()

if setfpscap then
    setfpscap(1000000)
    warn("FPS Unlocked!")
else
    warn("Your exploit does not support setfpscap.")
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ====================== SERVICES ======================


-- ====================== SETTINGS ======================
local AutoFarm = false

-- ====================== WINDOW ======================
local Window = WindUI:CreateWindow({
    Title = "unLimited",
    IconThemed = true,
    Icon = "flame",
    Author = "Custom Script | Feature: 4",
    Folder = "CUSTOMSCRIPT_UL",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = { Enabled = true, Anonymous = false },
})

pcall(function()
    Window:Tag({
        Title = version,
        Color = Color3.fromHex("#ff0000")
    })
end)

Window:EditOpenButton({
    Title = "Open Ui",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Main = Window:Tab({ Title = "Main", Icon = "rocket" })
Window:SelectTab(1)

-- ====================== MAIN ======================
Main:Section({ Title = "Auto Farm", Icon = "backpack" })

Main:Toggle({
    Title = "Auto Farm (Fixed)",
    Description = "Automatically attack approaching Mobs faster",
    Default = false,
    Callback = function(state)
        AutoFarm = state
        
      
        
        end
    end
})
