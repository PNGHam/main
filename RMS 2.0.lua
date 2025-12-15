local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reuploaded"))()
local venyx = library.new("Venyx", 5013109572)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local Character, Humanoid
local function UpdateCharacter()
    Character = LP.Character or LP.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
end
UpdateCharacter()
LP.CharacterAdded:Connect(UpdateCharacter)

local HitboxFlag = false
local HitboxSizeFlag = 6
local HitboxTransparencyFlag = 0.7
local TargetNPCFlag = false
local NPCHitboxSizeFlag = 5
local NPCHitboxTransparencyFlag = 0.7
local AutoCollectFlag = false
local SpeedBoostFlag = false
local SpeedBoost2Flag = false
local BoostValue = 14
local Boost2Value = 1

task.spawn(function()
    while task.wait(0.5) do
        for i, player in pairs(workspace.Players:GetChildren()) do
            if player and player.Parent and player.Name ~= LP.Name then
                if player:FindFirstChild("Head") then
                    local Head = player.Head
                    Head.CanCollide = false
                    Head.Massless = true

                    if HitboxFlag then
                        Head.Size = Vector3.new(
                            HitboxSizeFlag,
                            HitboxSizeFlag,
                            HitboxSizeFlag
                        )
                        Head.Transparency = HitboxTransparencyFlag
                    else
                        Head.Size = Vector3.new(2, 2, 2)
                        Head.Transparency = 0
                    end
                end
            end
        end
    end
end)

task.spawn(function()
while task.wait(0.1) do
    -- Civilians
    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Civilians") then
        for i, npc in pairs(workspace.Map.Civilians:GetChildren()) do
            if npc and npc.Parent then
                if npc:FindFirstChild("Head") then
                    local Head = npc.Head
                    Head.CanCollide = false
                    Head.Massless = true

                    if TargetNPCFlag then
                        Head.Size = Vector3.new(
                            NPCHitboxSizeFlag,
                            NPCHitboxSizeFlag,
                            NPCHitboxSizeFlag
                        )
                        Head.Transparency = NPCHitboxTransparencyFlag
                    else
                        Head.Size = Vector3.new(2, 2, 2)
                        Head.Transparency = 0
                    end
                end
            end
        end
    end

    -- Enemies
    if workspace:FindFirstChild("Enemies") then
        for i, npc in pairs(workspace.Enemies:GetChildren()) do
            if npc and npc.Parent then
                if npc:FindFirstChild("Head") then
                    local Head = npc.Head
                    Head.CanCollide = false
                    Head.Massless = true

                    if TargetNPCFlag then
                        Head.Size = Vector3.new(
                            NPCHitboxSizeFlag,
                            NPCHitboxSizeFlag,
                            NPCHitboxSizeFlag
                        )
                        Head.Transparency = NPCHitboxTransparencyFlag
                    else
                        Head.Size = Vector3.new(2, 2, 2)
                        Head.Transparency = 0
                    end
                end
            end
        end
    end

end
end)

task.spawn(function()
    while task.wait() do
        if not AutoCollectFlag then continue end
        if not workspace:FindFirstChild("Valuables") then continue end

        for _, v in ipairs(workspace.Valuables:GetChildren()) do
            for _, item in ipairs(v:GetDescendants()) do
                if item:IsA("ProximityPrompt") then
                    item.HoldDuration = 0
                    fireproximityprompt(item)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Humanoid then
            if SpeedBoostFlag then
                Humanoid.WalkSpeed = BoostValue
            else
                Humanoid.WalkSpeed = 14 -- default Roblox walkspeed
            end
        end
    end
end)

local themes = {
    Background = Color3.fromRGB(24,24,24),
    Glow = Color3.fromRGB(255,255,255),
    Accent = Color3.fromRGB(10,10,10),
    LightContrast = Color3.fromRGB(20,20,20),
    DarkContrast = Color3.fromRGB(14,14,14),
    TextColor = Color3.fromRGB(255,255,255)
}

local combat = venyx:addPage("Combat", 5012544693)
local combatSection = combat:addSection("Combat")

combatSection:addToggle("Hitbox Expander", nil, function(v)
    HitboxFlag = v                  
end)

combatSection:addTextbox("Hitbox Size", "6", function(v)
    HitboxSizeFlag = tonumber(v) or HitboxSizeFlag
end)

combatSection:addTextbox("Hitbox Transparency", nil, function(v)
    HitboxTransparencyFlag = tonumber(v)
end)

local NPCSection = combat:addSection("NPC")

NPCSection:addToggle("Target NPC's", nil, function(value)
    TargetNPCFlag = value
end)

NPCSection:addTextbox("NPC Hitbox Size", nil, function(value)
    NPCHitboxSizeFlag = tonumber(value)
end)

NPCSection:addTextbox("NPC Hitbox Transparency", nil, function(value)
    NPCHitboxTransparencyFlag = tonumber(value)
end)

local movement = venyx:addPage("Movement", 5012544693)
local movementSection = movement:addSection("Movement")

movementSection:addToggle("SpeedBoost1 (Walkspeed)", nil, function(v)
    SpeedBoostFlag = v
end)

movementSection:addSlider("Boost Value", 14, 14, 34, function(v)
    BoostValue = v
end)

movementSection:addToggle("SpeedBoost2 (CFrame)", nil, function(v)
    SpeedBoost2Flag = v
end)

movementSection:addSlider("Boost Value", 1, 1, 5, function(v)
    Boost2Value = v
end)

local other = venyx:addPage("Other", 5012544693)
local otherSection = other:addSection("Useful")

otherSection:addToggle("Auto Collect Cash/Gold", nil, function(v)
    AutoCollectFlag = v
end)

local themePage = venyx:addPage("Theme", 5012544693)
local colorSection = themePage:addSection("Colors")
local guiSection = themePage:addSection("Gui")

for themeName, color in pairs(themes) do
    colorSection:addColorPicker(themeName, color, function(c)
        venyx:setTheme(themeName, c)
    end)
end

guiSection:addKeybind("Toggle UI", Enum.KeyCode.Three, function()
    venyx:toggle()
end)

venyx:SelectPage(venyx.pages[1], true)

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VenyxMobileToggle"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 90, 0, 32)
button.Position = UDim2.new(0, 10, 0.5, -16)
button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
button.BorderSizePixel = 0
button.Text = "MENU"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 14
button.Font = Enum.Font.Gotham
button.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

button.MouseButton1Click:Connect(function()
    venyx:toggle()
end)




