local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reuploaded"))()
local venyx = library.new("Random Mafia Shooter | BETA", 5013109572)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local UserInputService = game:GetService("UserInputService")
local RMBHeld = false

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RMBHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RMBHeld = false
    end
end)

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
local Boost2Value = 0.1
local ESPEnabled = false
local SkeletonESPEnabled = false
local aimbotEnabledFlag = false
local aimbotFOVFlag = true
local aimbotFOVSizeFlag = 50
local aimbotHoldRMB = true
local aimbotWallCheck = false
local aimbotCheckDead = false

RunService.RenderStepped:Connect(function()
    if not SpeedBoost2Flag then return end
    if not Character then return end

    local hrp = Character:FindFirstChild("HumanoidRootPart")
    local humanoid = Character:FindFirstChild("Humanoid")

    if hrp and humanoid and humanoid.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * Boost2Value)
    end
end)


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

local function HasLineOfSight(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character, targetPart.Parent}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(origin, direction, rayParams)
    return result == nil
end

local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = math.huge
    local center = Camera.ViewportSize / 2

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            if aimbotCheckDead and humanoid and humanoid.Health <= 0 then
                continue
            end

            local head = plr.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude

                if aimbotWallCheck and not HasLineOfSight(head) then
                    continue
                end

                if (not aimbotFOVFlag or dist <= aimbotFOVSizeFlag) and dist < shortestDistance then
                    shortestDistance = dist
                    closestTarget = head
                end
            end
        end
    end

    return closestTarget
end

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

local aimbotSection = combat:addSection("Aimbot")

aimbotSection:addToggle("Enable Aimbot", nil, function(value)
    aimbotEnabledFlag = value
end)

aimbotSection:addToggle("Use FOV", nil, function(value)
    aimbotFOVFlag = value
end)

aimbotSection:addSlider("FOV Size", 50, 1, 200, function(v)
    aimbotFOVSizeFlag = v
end)

aimbotSection:addToggle("Hold RMB to Aim", true, function(v)
    aimbotHoldRMB = v
end)

aimbotSection:addToggle("Wall Check", nil, function(v)
    aimbotWallCheck = v
end)

aimbotSection:addToggle("Check Dead", nil, function(v)
    aimbotCheckDead = v
end)

local visuals = venyx:addPage("Visuals", 5012544693)
local espSection = visuals:addSection("ESP")

espSection:addToggle("Enable ESP", nil, function(v)
    ESPEnabled = v
end)

espSection:addToggle("Skeleton ESP", nil, function(v)
    SkeletonESPEnabled = v
end)

local movement = venyx:addPage("Movement", 5012544693)
local movementSection = movement:addSection("WalkSpeed")
local movementSection2 = movement:addSection("CFrame")
movementSection:addToggle("SpeedBoost1 (Walkspeed)", nil, function(v)
    SpeedBoostFlag = v
end)

movementSection:addSlider("Boost Value", 14, 14, 34, function(v)
    BoostValue = v
end)

movementSection2:addToggle("SpeedBoost2 (CFrame)", nil, function(v)
    SpeedBoost2Flag = v
end)

movementSection2:addTextbox("Boost Value", nil, function(value)
    Boost2Value = tonumber(value)
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

local SkeletonLines = {}
local Camera = workspace.CurrentCamera

local R6SkeletonPairs = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"},
}

RunService.RenderStepped:Connect(function()
    -- Hide old lines
    for _, line in pairs(SkeletonLines) do
        line.Visible = false
    end

    if not ESPEnabled or not SkeletonESPEnabled then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local char = plr.Character

            for _, pair in ipairs(R6SkeletonPairs) do
                local p1 = char:FindFirstChild(pair[1])
                local p2 = char:FindFirstChild(pair[2])

                if p1 and p2 then
                    local v1, on1 = Camera:WorldToViewportPoint(p1.Position)
                    local v2, on2 = Camera:WorldToViewportPoint(p2.Position)

                    if on1 and on2 then
                        local id = plr.UserId .. pair[1] .. pair[2]

                        if not SkeletonLines[id] then
                            local line = Drawing.new("Line")
                            line.Thickness = 1
                            line.Color = Color3.fromRGB(255, 255, 255)
                            line.Transparency = 1
                            SkeletonLines[id] = line
                        end

                        local line = SkeletonLines[id]
                        line.From = Vector2.new(v1.X, v1.Y)
                        line.To = Vector2.new(v2.X, v2.Y)
                        line.Visible = true
                    end
                end
            end
        end
    end
end)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Radius = aimbotFOVSizeFlag
FOVCircle.Visible = false
FOVCircle.Transparency = 1

RunService.RenderStepped:Connect(function()
    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

    FOVCircle.Position = center
    FOVCircle.Radius = aimbotFOVSizeFlag
    FOVCircle.Visible = aimbotEnabledFlag and aimbotFOVFlag

    if not aimbotEnabledFlag then return end
    if aimbotHoldRMB and not RMBHeld then return end

    local target = GetClosestTarget()
    if target then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
    end
end)

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
