toclipboard([[
    https://dsc.gg/dyhub
]])
local localPlayer = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local cd = 0
local cd2 = 0
local autotool = false
local servertokens = false
local localtokens = false
local autoquest = false
local autogummy = false
local autoconvert = false
local autofarm = false
local field = "Dandelion Field"
local fields = {}
for i,v in workspace.Fields:GetChildren() do
    table.insert(fields,v.Name)
end
local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/dementiaenjoyer/UI-LIBRARIES/refs/heads/main/wally-modified/source.lua')))()
local window = library:CreateWindow('DYHUB - Bee Swarm Simulator (dsc.gg/dyhub)')
window:Section('Autofarm')
window:Toggle("Auto Farm",{},function(value)
autofarm = value
end)
window:Dropdown("Fields", {
   location = _G;
   flag = "fields";
   list = fields
}, function(selectedfield)
   field = selectedfield
end)
window:Section('Stuff')
window:Toggle("Auto tool",{},function(value)
autotool = value
end)
window:Toggle("Collect Local Tokens",{},function(value)
localtokens = value
end)
window:Toggle("Collect Server Tokens",{},function(value)
servertokens = value
end)
window:Toggle("Auto take/finish quest",{},function(value)
autoquest = value
end)
window:Toggle("Auto Convert",{},function(value)
autoconvert = value
end)
window:Toggle("Auto Gummy",{},function(value)
autogummy = value
end)

game:GetService("RunService").RenderStepped:Connect(function(delta)
    cd += delta
    cd2 += delta
    local data = getrenv()._G.PData
    local character = localPlayer.Character
    local tool = character:FindFirstChildWhichIsA("Tool")

    if localtokens then
        for _, v in workspace.Tokens.Ability[localPlayer.Name]:GetChildren() do
            if v:FindFirstChild("TouchInterest") then
                firetouchinterest(v, character.HumanoidRootPart, 0)
            end
        end
        for _, v in workspace.Tokens.Local[localPlayer.Name]:GetChildren() do
            if v:FindFirstChild("TouchInterest") then
                firetouchinterest(v, character.HumanoidRootPart, 0)
            end
        end
    end

    if servertokens then
        for _, v in workspace.Tokens.Server:GetChildren() do
            if v:FindFirstChild("TouchInterest") then
                firetouchinterest(v, character.HumanoidRootPart, 0)
            end
        end
    end
    if cd > 0.1 then
        cd = 0
        if autogummy and data.Cooldowns.Gumdrops < os.time() then
            replicatedStorage.Remotes.Item:FireServer({Item = "Gumdrops"})
        end
        if autoconvert and data.Stats.Pollen >= data.Stats.Capacity then
            replicatedStorage.Remotes.Item:FireServer({Item = "Micro-Converter"})
        end
        if autotool and tool then
            replicatedStorage.Remotes.Gather:FireServer()
        end
        if autoquest then
            for _,v in replicatedStorage.Modules.Quests:GetChildren() do
                replicatedStorage.Remotes.TakeQuest:FireServer(v.Name)
                replicatedStorage.Remotes.FinishQuest:FireServer(v.Name)
            end
        end
    end
    if cd2 > 0.5 then
        cd2 = 0
        if autofarm and field then
            if data.Stats.Pollen >= data.Stats.Capacity then
                if (character.HumanoidRootPart.CFrame.Position - workspace.Hives[data.Info.Hive].Pad.CFrame.Position).Magnitude > 10 then
                    character.HumanoidRootPart.CFrame = CFrame.new(workspace.Hives[data.Info.Hive].Pad.CFrame.Position + Vector3.new(0,2.5,0))
                elseif not data.Info.Converting then
                    replicatedStorage.Remotes.Hive:FireServer({Action = "Convert"})
                end
            elseif not data.Info.Converting then
                local flower = math.random(1,#workspace.Fields[field]:GetChildren())
                if flower then
                    local flowerpart = workspace.Fields[field]:GetChildren()[flower]
                    if flowerpart and flowerpart.Name == "Flower" and flowerpart.ClassName == "Part" then
                        character.HumanoidRootPart.CFrame = CFrame.new(flowerpart.Position,flowerpart.Position + character.HumanoidRootPart.CFrame.LookVector)
                    end
                end
            end
        end
    end
end)
