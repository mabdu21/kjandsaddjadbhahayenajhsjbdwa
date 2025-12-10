-- ==== Whitelist เฉพาะชื่อ ==== --
local Whitelist = {
    "Yolmar_43",
    "Gogo123",
    -- เพิ่มชื่อได้เลยตามต้องการ
}

-- ฟังก์ชันเช็คว่า player อยู่ใน whitelist หรือไม่
local function isWhitelisted(name)
    for _, allowedName in ipairs(Whitelist) do
        if name == allowedName then
            return true
        end
    end
    return false
end

-- ==== เริ่มระบบ ==== --
local player = game.Players.LocalPlayer
local name = player.Name

-- รอให้ Core พร้อมก่อน
repeat wait() until game:IsLoaded()
repeat wait() until pcall(function()
    game.StarterGui:SetCore("SendNotification", {})
end)

-- ตรวจสอบ Whitelist
if isWhitelisted(name) then
    warn("[DYHUB] Whitelist Verified for: " .. name)

    -- โหลดสคริปต์หลัก
    loadstring(game:HttpGet("https://raw.githubusercontent.com/mabdu21/kjandsaddjadbhahayenajhsjbdwa/refs/heads/main/Ex.lua"))()

else
    warn("[DYHUB] You are NOT Whitelisted!")
    game.StarterGui:SetCore("SendNotification", {
        Title = "DYHUB System",
        Text = "You are not whitelisted!",
        Duration = 5
    })
end
