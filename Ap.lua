local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local virtualUser = game:GetService("VirtualUser")

local autoClicking = false

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:FindFirstChildOfClass("PlayerGui")

-- สร้างปุ่ม
local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 150, 0, 50) -- ขนาดปุ่ม
button.Position = UDim2.new(0.5, -75, 0.8, 0) -- ตำแหน่งปุ่ม
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- สีพื้นหลัง
button.TextColor3 = Color3.fromRGB(255, 255, 255) -- สีข้อความ
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Text = "Start / Auto M1"

-- ฟังก์ชัน Auto Click
local function autoClick()
    while autoClicking do
        if userInputService.TouchEnabled then
            -- รองรับ Mobile (แตะหน้าจอ)
            virtualUser:Button1Down(Vector2.new(0, 0)) 
            task.wait(0.05)
            virtualUser:Button1Up(Vector2.new(0, 0))
        else
            -- รองรับ PC (คลิกเมาส์)
            userInputService.InputBegan:Fire(Enum.UserInputType.MouseButton1, false)
        end
        task.wait(0.1) -- ปรับความเร็วคลิก (ค่าต่ำลง = เร็วขึ้น)
    end
end

-- เมื่อกดปุ่มให้สลับสถานะ Auto Click
button.MouseButton1Click:Connect(function()
    autoClicking = not autoClicking

    if autoClicking then
        button.Text = "Stop / Auto M1"
        autoClick()
    else
        button.Text = "Start / Auto M1"
    end
end)
