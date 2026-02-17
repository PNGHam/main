local CoastingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Coasting%20Ui%20Lib/source.lua"))()
Players = game:GetService("Players")
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Workspace = game:GetService("Workspace")

localPlayer = Players.LocalPlayer
camera = workspace.CurrentCamera

HeadSizeEnabled = false;
local v4 = 0;
local v5 = 25;
headScale = Vector3.new(2, 2, 2);
headTransparency = 0;
local v6 = {};
local function v9(v7)
    local l_Head_0 = v7:FindFirstChild("Head");
    if l_Head_0 and l_Head_0:IsA("BasePart") then
        if HeadSizeEnabled then
            if not v6[l_Head_0] then
                v6[l_Head_0] = {
                    Size = l_Head_0.Size,
                    Transparency = l_Head_0.Transparency,
                    CanCollide = l_Head_0.CanCollide
                };
            end;
            l_Head_0.Size = headScale;
            l_Head_0.Transparency = headTransparency;
            l_Head_0.CanCollide = false;
        elseif v6[l_Head_0] then
            l_Head_0.Size = v6[l_Head_0].Size;
            l_Head_0.Transparency = v6[l_Head_0].Transparency;
            l_Head_0.CanCollide = v6[l_Head_0].CanCollide;
            v6[l_Head_0] = nil;
        end;
    end;
end;
RunService.RenderStepped:Connect(function()
    v4 = v4 + 1;
    if v5 <= v4 then
        v4 = 0;
        for _, v11 in pairs(workspace:GetChildren()) do
            if v11:IsA("Model") and v11 ~= localPlayer.Character then
                v9(v11);
            end;
        end;
    end;
end);

-- AIMBOT
local AimbotEnabled = false
local AimbotFOV = 150
local smoothing = 1
local mb2Held = false
local target = nil
local VisualizeTrajectory = false
local bowpath = workspace.Const.Ignore.FPSArms

-- projectile physics
local projectileSpeed = 300
local simStep = 0.01
local maxSimTime = 6
local aimSolveIterations = 20

-- trajectory visualization
local showTrajectory = true
local trajectoryPoints = {}
local trajectoryResolution = 0.01
local trajectoryLength = 1

local function clearTrajectory()
    for _, p in ipairs(trajectoryPoints) do
        p:Destroy()
    end
    table.clear(trajectoryPoints)
end

local function stepProjectile(position, velocity, dt)
    local gravity = Vector3.new(0, -workspace.Gravity, 0)
    local newPosition = position + velocity * dt + 0.5 * gravity * dt * dt
    local newVelocity = velocity + gravity * dt
    return newPosition, newVelocity
end

local function simulatePath(origin, direction, targetPos)
    local position = origin
    local velocity = direction * projectileSpeed
    local closestPoint = position
    local closestDist = (position - targetPos).Magnitude
    local totalTime = 0

    while totalTime < maxSimTime do
        position, velocity = stepProjectile(position, velocity, simStep)
        local dist = (position - targetPos).Magnitude
        if dist < closestDist then
            closestDist = dist
            closestPoint = position
        end
        totalTime += simStep
    end

    return closestPoint
end

local function solveAimDirection(origin, targetPos, targetVelocity)
    local g = workspace.Gravity
    local speed = projectileSpeed

    local relPos = targetPos - origin
    local relVel = targetVelocity

    -- quadratic for intercept time ignoring gravity first (gives usable lead)
    local a = relVel:Dot(relVel) - speed^2
    local b = 2 * relPos:Dot(relVel)
    local c = relPos:Dot(relPos)

    local disc = b*b - 4*a*c
    if disc < 0 then
        return relPos.Unit
    end

    local t1 = (-b - math.sqrt(disc)) / (2*a)
    local t2 = (-b + math.sqrt(disc)) / (2*a)
    local t = math.min(t1, t2)
    if t < 0 then t = math.max(t1, t2) end
    if t < 0 then
        return relPos.Unit
    end

    -- predicted position at intercept time
    local futureTarget = targetPos + relVel * t

    -- gravity compensation (THIS is what was missing)
    local drop = Vector3.new(0, 0.5 * g * t * t, 0)

    -- aim above target to cancel gravity
    local aimPoint = futureTarget + drop

    return (aimPoint - origin).Unit
end


local function drawTrajectory(origin, direction)
    if not VisualizeTrajectory then return end
    clearTrajectory()

    local position = origin
    local velocity = direction * projectileSpeed
    local totalTime = 0

    while totalTime < maxSimTime do
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.2, 0.2, 0.2)
        part.Shape = Enum.PartType.Ball
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.Neon
        part.Position = position
        part.Parent = workspace

        table.insert(trajectoryPoints, part)

        position, velocity = stepProjectile(position, velocity, trajectoryResolution)
        totalTime += trajectoryResolution
    end
end


local function isValidTarget(model)
    if not model then return false end
    if not model.Parent then return false end
    if model == localPlayer.Character then return false end
    return model:FindFirstChild("Head") and model:FindFirstChild("HumanoidRootPart")
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        mb2Held = true
        clearTrajectory() -- clear ONLY when RMB is pressed again
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        mb2Held = false
        target = nil
        -- do NOT clear here
    end
end)


local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Radius = AimbotFOV
FOVCircle.Color = Color3.new(1,1,1)
FOVCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

local function getNearestCharacter()
    local nearestCharacter = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= localPlayer.Character then
            local head = obj:FindFirstChild("Head")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if head and hrp then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X,screenPos.Y)-screenCenter).Magnitude
                    if dist <= AimbotFOV and dist < shortestDistance then
                        shortestDistance = dist
                        nearestCharacter = obj
                    end
                end
            end
        end
    end
    return nearestCharacter
end

local function hasBowEquipped()
    if not bowpath then return false end

    local handModel = bowpath:FindFirstChild("HandModel")
    if not handModel then return false end

    local Handle = handModel:FindFirstChild("Handle")
    if not Handle then return false end

    local arrow = handModel:FindFirstChild("Arrow")
	if not arrow then return false end

	local fabric = handModel:FindFirstChild("Fabric")
	if not fabric then return false end

    return true
end

-- throttle heavy calculations
local heavyCalcInterval = 0.2
local lastHeavyCalc = 0
local cachedAimDirection = nil

local function moveMouseSmooth(character)
    if not mb2Held or not AimbotEnabled then
        return
    end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local origin = camera.CFrame.Position
    local targetPos = head.Position
    local targetVelocity = head.AssemblyLinearVelocity

    local useProjectilePhysics = hasBowEquipped()

    local now = tick()

    if useProjectilePhysics then
        -- run heavy solver + trajectory at interval
        if not cachedAimDirection or (now - lastHeavyCalc) >= heavyCalcInterval then
            cachedAimDirection = solveAimDirection(origin, targetPos, targetVelocity)
            drawTrajectory(origin, cachedAimDirection)
            lastHeavyCalc = now
        end
    else
        -- direct aim (no gravity)
        cachedAimDirection = (targetPos - origin).Unit
        clearTrajectory()
    end

    local aimPoint = origin + cachedAimDirection * 1000
    local screenPos, onScreen = camera:WorldToViewportPoint(aimPoint)
    if not onScreen then return end

    local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    local delta = (Vector2.new(screenPos.X,screenPos.Y)-center) * smoothing
    mousemoverel(delta.X, delta.Y)
end

RunService.RenderStepped:Connect(function()
    if not mb2Held then
        target = nil
        return
    end

    if target and not isValidTarget(target) then
        target = nil
    end

    if not target then
        target = getNearestCharacter()
    end

    if target then
        moveMouseSmooth(target)
    end
end)

local AimbotTab = CoastingLibrary:CreateTab("Aimbot")
local MainSection = AimbotTab:CreateSection("Main")

MainSection:CreateToggle("Aimbot", function(boolean)
	AimbotEnabled = boolean
	FOVCircle.Visible = boolean
end)

MainSection:CreateToggle("Visualize Path", function(boolean)
	VisualizeTrajectory = boolean
end)

MainSection:CreateSlider("Field Of View", 1, 500,150, false, function(value)
	AimbotFOV = value
	FOVCircle.Radius = value
end)

MainSection:CreateSlider("AimbotSmoothness", 0.1, 2, 1, false, function(value)
	smoothing = value
end)

local HitboxSection = AimbotTab:CreateSection("Hitbox")
HitboxSection:CreateToggle("Enabled", function(boolean)
	HeadSizeEnabled = boolean
	if not v12 then
        for v13, v14 in pairs(v6) do
            if v13 and v13.Parent then
                 v13.Size = v14.Size
                v13.Transparency = v14.Transparency
                v13.CanCollide = v14.CanCollide
            end
        end
        v6 = {}
    end;
end)

HitboxSection:CreateSlider("Size", 1, 10, 2, false, function(value)
	headScale = Vector3.new(value, value, value);
end)

HitboxSection:CreateSlider("Transparency", 1, 10, 1, false, function(value)
	headTransparency = (value / 10);
end)

local VisualsTab = CoastingLibrary:CreateTab("Visuals")
local ESPSection = VisualsTab:CreateSection("ESP")
local l_RunService_0 = game:GetService("RunService");
local l_Workspace_0 = game:GetService("Workspace");
local l_CurrentCamera_0 = l_Workspace_0.CurrentCamera;
local v25 = {};
local v26 = false;
local v27 = true;
local v28 = true;
local v29 = true;
local v30 = false;
local v31 = true;
local v32 = false;
local v33 = Color3.fromRGB(255, 255, 255);
local v34 = Color3.fromRGB(255, 255, 255);
local v35 = Color3.fromRGB(255, 255, 255);
local _ = math.tan(math.rad(l_CurrentCamera_0.FieldOfView * 0.5));

ESPSection:CreateToggle("Box ESP", function(boolean)
	ToggleBoxes(boolean);
end)
ESPSection:CreateToggle("Distance ESP", function(boolean)
	ToggleDistance(boolean);
end)
ESPSection:CreateToggle("Entity ESP", function(boolean)
	ToggleType(boolean);
end)
ESPSection:CreateToggle("Sleeper Check", function(boolean)
	ToggleSleeperCheck(boolean);
end)
ESPSection:CreateToggle("Weapon ESP", function(boolean)
	ToggleWeaponESP(boolean);
end)
ESPSection:CreateToggle("Skeleton ESP", function(boolean)
	ToggleSkeletonESP(boolean);
end)

ESPSection:CreateColorPicker("Box Color", Color3.fromRGB(255, 255, 255), function(color)
	v33 = color
end)
ESPSection:CreateColorPicker("Skeleton Color", Color3.fromRGB(255, 255, 255), function(color)
	v35 = color
end)
ESPSection:CreateColorPicker("Text Color", Color3.fromRGB(255, 255, 255), function(color)
	v34 = color
end)
local v46 = {
    {
        "Head", 
        "Torso"
    }, 
    {
        "Torso", 
        "LeftUpperArm"
    }, 
    {
        "LeftUpperArm", 
        "LeftLowerArm"
    }, 
    {
        "Torso", 
        "RightUpperArm"
    }, 
    {
        "RightUpperArm", 
        "RightLowerArm"
    }, 
    {
        "LowerTorso", 
        "LeftUpperLeg"
    }, 
    {
        "LeftUpperLeg", 
        "LeftLowerLeg"
    }, 
    {
        "Torso", 
        "LowerTorso"
    }, 
    {
        "RightUpperLeg", 
        "RightLowerLeg"
    }, 
    {
        "LowerTorso", 
        "RightUpperLeg"
    }, 
    {
        "LeftLowerLeg", 
        "LeftFoot"
    }, 
    {
        "RightLowerLeg", 
        "RightFoot"
    }, 
    {
        "RightLowerArm", 
        "RightHand"
    }, 
    {
        "LeftLowerArm", 
        "LeftHand"
    }
};
local v47 = {
    Bow = {
        "Arrow", 
        "Fabric", 
        "Handle", 
        "Meshes/Bow", 
        "ADS", 
        "Mover", 
        "AnimationController"
    }, 
    AR15 = {
        "AnimSaves", 
        "Barrel", 
        "Body", 
        "Bolt", 
        "ChargingHandle", 
        "Decor", 
        "Grip", 
        "Handle", 
        "Mag", 
        "Rails", 
        "Stock", 
        "ADS", 
        "Muzzle", 
        "AnimationController"
    }, 
    AdminMinigun = {
        "AnimSaves", 
        "Barrel", 
        "BarrelBolts", 
        "Body", 
        "Bolt", 
        "Handle", 
        "Handle2", 
        "Trigger", 
        "AnimationController"
    }, 
    Bandage = {
        "Handle", 
        "Bandage", 
        "AnimationController"
    }, 
    Beans = {
        "Beans", 
        "Handle", 
        "AnimationController"
    }, 
    BloxyCola = {
        "Bloxy Cola HD", 
        "Handle", 
        "AnimationController"
    }, 
    Blunderbuss = {
        "Body", 
        "Handle", 
        "Tube", 
        "thing", 
        "ADS", 
        "Muzzle", 
        "AnimationController"
    }, 
    C4 = {
        "Handle", 
        "default", 
        "prim", 
        "Light", 
        "Timer", 
        "AnimationController"
    }, 
    C9 = {
        "Barrel", 
        "Body", 
        "Bolt", 
        "Decor", 
        "Grip", 
        "Handle", 
        "LowerSlide", 
        "Mag", 
        "Sight1", 
        "Sight2", 
        "UpperSlide", 
        "ADS", 
        "Muzzle", 
        "AnimationController"
    }, 
    ClimbingPick = {
        "Left", 
        "Right", 
        "AnimationController"
    }, 
    CrossBow = {
        "Arrow", 
        "BackMetal", 
        "Body", 
        "FrontNails", 
        "Handle", 
        "Release", 
        "SpringSteel", 
        "String", 
        "Wheel", 
        "ADS", 
        "Slide", 
        "AnimationController"
    }, 
    Crowbar = {
        "Handle", 
        "model", 
        "AnimationController"
    }, 
    Dynamite = {
        "Handle", 
        "Body", 
        "Fuse", 
        "AnimationController"
    }, 
    EnergyRifle = {
        "DefaultSight", 
        "FrontCover", 
        "Glowing", 
        "Grip", 
        "Handle", 
        "Mag", 
        "Metal", 
        "Metal2", 
        "RearCover", 
        "RearDecor", 
        "Screws", 
        "Tubes", 
        "AnimationController"
    }, 
    FlameThrower = {
        "Barrel", 
        "Body", 
        "Decor", 
        "Grip", 
        "Handle", 
        "Hoses", 
        "LowerTank", 
        "Mag", 
        "Strap", 
        "Tubes", 
        "Particle", 
        "AnimationController"
    }, 
    Flare = {
        "Handle", 
        "Body", 
        "Color", 
        "AnimationController"
    }, 
    Flashgrenade = {
        "Body", 
        "Color", 
        "Fuse", 
        "Handle", 
        "Lever", 
        "Ring", 
        "AnimationController"
    }, 
    GaussRifle = {
        "DefaultSight", 
        "Barrel", 
        "Body", 
        "CoilHolders", 
        "Coils", 
        "Decals1", 
        "Decals2", 
        "Grip", 
        "Handle", 
        "Housing", 
        "Mag", 
        "StockBack", 
        "AnimationController"
    }, 
    Glowstick = {
        "Ends", 
        "Handle", 
        "GlowPart", 
        "AnimationController"
    }, 
    Grenade = {
        "Body", 
        "Fuse", 
        "Handle", 
        "Lever", 
        "LeverHolder", 
        "Pin", 
        "AnimationController"
    }, 
    HMAR = {
        "DefaultSight", 
        "Body", 
        "Bolt", 
        "Bolts", 
        "Cover", 
        "Handle", 
        "Mag", 
        "Rails", 
        "Spring", 
        "Stock", 
        "Wood", 
        "Muzzle", 
        "AnimationController"
    }, 
    HMCharge = {
        "Charge", 
        "Fuse", 
        "Handle", 
        "Strap", 
        "AnimationController"
    }, 
    Hammer = {
        "Handle", 
        "Head", 
        "Dowel", 
        "AnimationController"
    }, 
    HealingBandage = {
        "Handle", 
        "Bandage", 
        "AnimationController"
    }, 
    IronHammer = {
        "Handle", 
        "Head", 
        "Dowel", 
        "AnimationController"
    }, 
    KABAR = {
        "Blade", 
        "Grip", 
        "Guard", 
        "Handle", 
        "AnimationController"
    }, 
    LeverActionRifle = {
        "9mm", 
        "DefaultSight", 
        "Body", 
        "Brass", 
        "Hammer", 
        "Handle", 
        "Lever", 
        "Metal", 
        "Thing", 
        "Wood", 
        "Muzzle", 
        "AnimationController"
    }, 
    M4A1 = {
        "DefaultSight", 
        "Body", 
        "Bolt", 
        "ChargeHandle", 
        "Grip", 
        "Handle", 
        "Mag", 
        "Metal", 
        "mbrk", 
        "Muzzle", 
        "AnimationController"
    }, 
    MedSerum = {
        "Body", 
        "Cross", 
        "Handle", 
        "Injector", 
        "Plunger", 
        "Spring", 
        "AnimationController"
    }, 
    Minigun = {
        "AnimSaves", 
        "Barrel", 
        "BarrelBolts", 
        "Body", 
        "Bolt", 
        "Handle", 
        "Handle2", 
        "Trigger", 
        "AnimationController"
    }, 
    MiningDrill = {
        "Bearings", 
        "Body", 
        "DrillBit", 
        "Handle", 
        "Inlets", 
        "Tubes", 
        "VisualHandle", 
        "AnimationController"
    }, 
    Molotov = {
        "Handle", 
        "default", 
        "Part", 
        "AnimationController"
    }, 
    PipePistol = {
        "DefaultSight", 
        "Body", 
        "Bolt", 
        "Handle", 
        "Mag", 
        "Muzzle", 
        "AnimationController", 
        "Animator"
    }, 
    PipeSMG = {
        "DefaultSight", 
        "Barrel", 
        "Body", 
        "Bolt", 
        "Flap", 
        "Grip", 
        "Handle", 
        "Mag", 
        "Stock", 
        "Muzzle", 
        "AnimationController"
    }, 
    PumpShotgun = {
        "Barrel", 
        "Body", 
        "Handle", 
        "MainMetal", 
        "RearSight", 
        "Shell", 
        "Slider", 
        "ADS", 
        "Muzzle", 
        "AnimationController"
    }, 
    RPG = {
        "RocketModel", 
        "Body", 
        "Body2", 
        "Caps", 
        "Fasteners", 
        "FireMech", 
        "Handle", 
        "Safety", 
        "Sight", 
        "Trigger", 
        "ADS", 
        "Muzzle", 
        "AnimationController"
    }, 
    RiotShield = {
        "Body", 
        "Glass", 
        "Handle", 
        "Metal", 
        "Straps", 
        "AnimationController"
    }, 
    SCAR = {
        "DefaultSight", 
        "Barrel", 
        "Body", 
        "ChargingHandle", 
        "Decals", 
        "Handle", 
        "Mag", 
        "Rails", 
        "ShoulderPad", 
        "Stock", 
        "Muzzle", 
        "AnimationController"
    }, 
    SVD = {
        "DefaultSight", 
        "Body", 
        "Bolt", 
        "Handle", 
        "Magazine", 
        "Magazine2", 
        "Metal2", 
        "Wood", 
        "AnimationController"
    }, 
    StelHammer = {
        "Handle", 
        "Head", 
        "Dowel", 
        "DowelDecor", 
        "AnimationController"
    }, 
    StoneHammer = {
        "Handle", 
        "Head", 
        "Dowel", 
        "AnimationController"
    }, 
    USP9 = {
        "Body", 
        "Handle", 
        "Mag", 
        "Slide", 
        "ADS", 
        "Muzzle", 
        "AnimationController"
    }, 
    UZI = {
        "DefaultSight", 
        "Body", 
        "Body2", 
        "Bolt", 
        "ChargingHandle", 
        "Decor", 
        "Grip", 
        "Handle", 
        "Mag", 
        "Stock", 
        "Muzzle", 
        "AnimationController"
    }
};
local v48 = {};
local function v52(v49) --[[ Line: 0 ]] --[[ Name:  ]]
    local l_Head_1 = v49:FindFirstChild("Head");
    local v51 = v49:FindFirstChild("Torso") or v49:FindFirstChild("UpperTorso") or v49:FindFirstChild("LowerTorso");
    if l_Head_1 and v51 then
        return l_Head_1, v51;
    else
        return;
    end;
end;
local function v55(v53) --[[ Line: 0 ]] --[[ Name:  ]]
    local l_Torso_0 = v53:FindFirstChild("Torso");
    if l_Torso_0 and l_Torso_0:FindFirstChild("LeftBooster") then
        return true;
    else
        return false;
    end;
end;
local function v65(v56) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v47 (ref)
    local l_HandModel_0 = v56:FindFirstChild("HandModel");
    if not l_HandModel_0 then
        return "None";
    else
        local v58 = nil;
        local v59 = 0;
        for v60, v61 in pairs(v47) do
            local v62 = 0;
            for _, v64 in ipairs(v61) do
                if l_HandModel_0:FindFirstChild(v64, true) then
                    v62 = v62 + 1;
                end;
            end;
            if v59 < v62 then
                v59 = v62;
                v58 = v60;
            end;
        end;
        return not v58 and "None" or v58;
    end;
end;
local function v80(v66) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v25 (ref), v52 (ref), v33 (ref), v46 (ref), v55 (ref), v35 (ref)
    if v25[v66] then
        return;
    else
        local v67, v68 = v52(v66);
        if not v67 or not v68 then
            return;
        else
            local v69 = Drawing.new("Square");
            v69.Thickness = 1;
            v69.Filled = false;
            v69.Color = v33;
            v69.Visible = false;
            local v70 = Drawing.new("Square");
            v70.Thickness = 1;
            v70.Filled = false;
            v70.Color = Color3.fromRGB(0, 0, 0);
            v70.Visible = false;
            local v71 = Drawing.new("Text");
            v71.Size = 16;
            v71.Center = true;
            v71.Outline = true;
            v71.OutlineColor = Color3.new(0, 0, 0);
            v71.Visible = false;
            local v72 = Drawing.new("Text");
            v72.Size = 16;
            v72.Center = true;
            v72.Outline = true;
            v72.OutlineColor = Color3.new(0, 0, 0);
            v72.Visible = false;
            local v73 = {};
            for _, v75 in ipairs(v46) do
                local v76 = Drawing.new("Line");
                v76.Color = v55(v66) and v35 or Color3.fromRGB(0, 150, 255);
                v76.Thickness = 1.5;
                v76.Visible = false;
                table.insert(v73, {
                    line = v76, 
                    a = v75[1], 
                    b = v75[2]
                });
            end;
            v25[v66] = {
                box = v69, 
                outline = v70, 
                text = v71, 
                weaponText = v72, 
                head = v67, 
                torso = v68, 
                skeletonLines = v73
            };
            v66.Destroying:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v69 (ref), v70 (ref), v71 (ref), v72 (ref), v73 (ref), v25 (ref), v66 (ref)
                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v69 (ref)
                    v69:Remove();
                end);
                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v70 (ref)
                    v70:Remove();
                end);
                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v71 (ref)
                    v71:Remove();
                end);
                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v72 (ref)
                    v72:Remove();
                end);
                for _, v78 in ipairs(v73) do
                    do
                        local l_v78_0 = v78;
                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                            -- upvalues: l_v78_0 (ref)
                            l_v78_0.line:Remove();
                        end);
                    end;
                end;
                v25[v66] = nil;
            end);
            return;
        end;
    end;
end;
for _, v82 in ipairs(l_Workspace_0:GetChildren()) do
    if v82:IsA("Model") then
        v80(v82);
    end;
end;
l_Workspace_0.ChildAdded:Connect(function(v83) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v80 (ref)
    if v83:IsA("Model") then
        v80(v83);
    end;
end);
task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v25 (ref), v48 (ref), v65 (ref)
    while true do
        for v84 in pairs(v25) do
            v48[v84] = v65(v84);
        end;
        task.wait(1);
    end;
end);
ToggleESP = function(v85) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v26 (ref)
    v26 = v85;
end;
ToggleBoxes = function(v86) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v29 (ref)
    v29 = v86;
end;
ToggleDistance = function(v87) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v27 (ref)
    v27 = v87;
end;
ToggleType = function(v88) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v28 (ref)
    v28 = v88;
end;
ToggleSleeperCheck = function(v89) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v30 (ref)
    v30 = v89;
end;
ToggleWeaponESP = function(v90) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v31 (ref)
    v31 = v90;
end;
ToggleSkeletonESP = function(v91) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v32 (ref)
    v32 = v91;
end;
SetESPColor = function(v92) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v33 (ref)
    v33 = v92;
end;
l_RunService_0.RenderStepped:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v26 (ref), l_CurrentCamera_0 (ref), v25 (ref), v52 (ref), v30 (ref), v29 (ref), v55 (ref), v33 (ref), v28 (ref), v27 (ref), v34 (ref), v31 (ref), v48 (ref), v32 (ref)
    if not v26 then
        return;
    else
        local l_Position_0 = l_CurrentCamera_0.CFrame.Position;
        for v94, v95 in pairs(v25) do
            local v96 = true;
            local l_head_0 = v95.head;
            local l_torso_0 = v95.torso;
            if not l_head_0 or not l_torso_0 or not l_head_0.Parent or not l_torso_0.Parent then
                local v99, v100 = v52(v94);
                l_torso_0 = v100;
                l_head_0 = v99;
                v99 = l_head_0;
                v95.torso = l_torso_0;
                v95.head = v99;
                if not l_head_0 or not l_torso_0 then
                    v96 = false;
                end;
            end;
            if v96 and v30 then
                local l_LowerTorso_0 = v94:FindFirstChild("LowerTorso");
                if l_LowerTorso_0 then
                    local l_RootRig_0 = l_LowerTorso_0:FindFirstChild("RootRig");
                    if l_RootRig_0 and typeof(l_RootRig_0.CurrentAngle) == "number" and l_RootRig_0.CurrentAngle ~= 0 then
                        v96 = false;
                    end;
                end;
            end;
            local v103 = nil;
            local v104 = nil;
            if v96 then
                v103 = (l_head_0.Position + l_torso_0.Position) * 0.5;
                v104 = (v103 - l_Position_0).Magnitude;
                if v104 >= 3000 then
                    v96 = false;
                end;
            end;
            local v105 = nil;
            local v106 = nil;
            if v96 then
                local v107, v108 = l_CurrentCamera_0:WorldToViewportPoint(v103);
                v106 = v108;
                v105 = v107;
                if not v106 then
                    v96 = false;
                end;
            end;
            if not v96 then
                v95.box.Visible = false;
                v95.outline.Visible = false;
                v95.text.Visible = false;
                v95.weaponText.Visible = false;
                for _, v110 in ipairs(v95.skeletonLines) do
                    v110.line.Visible = false;
                end;
            else
                local v111 = 1000 / (v104 * 2) / math.tan(math.rad(l_CurrentCamera_0.FieldOfView / 1.7));
                local v112 = math.clamp(math.floor(6.5 * v111), 10, 600);
                local v113 = math.clamp(math.floor(9.5 * v111), 14, 800);
                local v114 = v105.X - v112 / 2;
                local v115 = v105.Y - v113 / 3.5;
                if v29 then
                    local v116 = 2;
                    v95.outline.Size = Vector2.new(v112 + v116, v113 + v116);
                    v95.outline.Position = Vector2.new(v114 - v116 / 2, v115 - v116 / 2);
                    v95.outline.Visible = true;
                    v95.box.Size = Vector2.new(v112, v113);
                    v95.box.Position = Vector2.new(v114, v115);
                    v95.box.Color = v55(v94) and v33 or Color3.fromRGB(0, 150, 255);
                    v95.box.Visible = true;
                else
                    v95.outline.Visible = false;
                    v95.box.Visible = false;
                end;
                local v117 = {};
                if v28 then
                    table.insert(v117, v55(v94) and "Player" or "Bot");
                end;
                if v27 then
                    table.insert(v117, math.floor(v104) .. "m");
                end;
                local v118 = table.concat(v117, " | ");
                if v118 ~= "" then
                    v95.text.Color = v55(v94) and v34 or Color3.fromRGB(0, 150, 255);
                    v95.text.Text = v118;
                    v95.text.Position = Vector2.new(v105.X, v115 - 16);
                    v95.text.Visible = true;
                else
                    v95.text.Visible = false;
                end;
                if v31 then
                    local v119 = v48[v94] or "None";
                    v95.weaponText.Color = v55(v94) and v34 or Color3.fromRGB(0, 150, 255);
                    v95.weaponText.Text = v119;
                    v95.weaponText.Position = Vector2.new(v105.X, v115 + v113);
                    v95.weaponText.Visible = true;
                else
                    v95.weaponText.Visible = false;
                end;
                if v32 then
                    for _, v121 in ipairs(v95.skeletonLines) do
                        local l_v94_FirstChild_0 = v94:FindFirstChild(v121.a);
                        local l_v94_FirstChild_1 = v94:FindFirstChild(v121.b);
                        if l_v94_FirstChild_0 and l_v94_FirstChild_1 then
                            local v124, v125 = l_CurrentCamera_0:WorldToViewportPoint(l_v94_FirstChild_0.Position);
                            local v126, v127 = l_CurrentCamera_0:WorldToViewportPoint(l_v94_FirstChild_1.Position);
                            if v125 and v127 then
                                v121.line.From = Vector2.new(v124.X, v124.Y);
                                v121.line.To = Vector2.new(v126.X, v126.Y);
                                v121.line.Visible = true;
                            else
                                v121.line.Visible = false;
                            end;
                        else
                            v121.line.Visible = false;
                        end;
                    end;
                else
                    for _, v129 in ipairs(v95.skeletonLines) do
                        v129.line.Visible = false;
                    end;
                end;
            end;
        end;
        return;
    end;
end);
ToggleESP(true);
ToggleBoxes(false);
ToggleDistance(false);
ToggleType(false);
ToggleSleeperCheck(false);
ToggleWeaponESP(false);
ToggleSkeletonESP(false);
G2L = {};
G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
G2L["1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
G2L["2"] = Instance.new("Frame", G2L["1"]);
G2L["2"].ZIndex = -8;
G2L["2"].BackgroundColor3 = Color3.fromRGB(31, 31, 31);
G2L["2"].Size = UDim2.new(0, 786, 0, 77);
G2L["2"].Position = UDim2.new(0.3, 1, 0, -30);
G2L["2"].BorderColor3 = Color3.fromRGB(11, 11, 11);
G2L["2"].Name = "Armor";
G2L["2"].BackgroundTransparency = 1;
G2L["4"] = Instance.new("TextLabel", G2L["2"]);
G2L["4"].ZIndex = 3;
G2L["4"].BorderSizePixel = 0;
G2L["4"].TextSize = 20;
G2L["4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255);
G2L["4"].FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["4"].TextColor3 = Color3.fromRGB(255, 255, 255);
G2L["4"].BackgroundTransparency = 1;
G2L["4"].Size = UDim2.new(0, 219, 0, 16);
G2L["4"].BorderColor3 = Color3.fromRGB(0, 0, 0);
G2L["4"].Text = "Armor";
G2L["4"].Name = "Section";
G2L["4"].Position = UDim2.new(0.34987, 0, -7.5E-4, 0);
G2L["5"] = Instance.new("Frame", G2L["2"]);
G2L["5"].ZIndex = 2;
G2L["5"].BackgroundColor3 = Color3.fromRGB(31, 31, 31);
G2L["5"].Size = UDim2.new(0, 786, 0, 81);
G2L["5"].BorderColor3 = Color3.fromRGB(255, 255, 255);
G2L["5"].Name = "Back";
G2L["5"].BackgroundTransparency = 0.4;
G2L["6"] = Instance.new("Frame", G2L["2"]);
G2L["6"].BackgroundColor3 = Color3.fromRGB(31, 31, 31);
G2L["6"].Size = UDim2.new(0, 788, 0, 83);
G2L["6"].Position = UDim2.new(0, -1, 0, -1);
G2L["6"].BorderColor3 = Color3.fromRGB(0, 0, 0);
G2L["6"].Name = "Front";
G2L["6"].BackgroundTransparency = 0.4;
local l_2_0 = G2L["2"];
local _ = game:GetService("UserInputService");
local v133 = false;
local v134 = nil;
local v135 = nil;
l_2_0.InputBegan:Connect(function(v136, v137) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v133 (ref), v134 (ref), v135 (ref), l_2_0 (ref)
    if v137 then
        return;
    else
        if v136.UserInputType == Enum.UserInputType.MouseButton1 or v136.UserInputType == Enum.UserInputType.Touch then
            v133 = true;
            v134 = v136.Position;
            v135 = l_2_0.Position;
            v136.Changed:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v136 (ref), v133 (ref)
                if v136.UserInputState == Enum.UserInputState.End then
                    v133 = false;
                end;
            end);
        end;
        return;
    end;
end);
l_2_0.InputChanged:Connect(function(v138) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v133 (ref), v134 (ref), l_2_0 (ref), v135 (ref)
    if v133 and (v138.UserInputType == Enum.UserInputType.MouseMovement or v138.UserInputType == Enum.UserInputType.Touch) then
        local v139 = v138.Position - v134;
        l_2_0.Position = UDim2.new(v135.X.Scale, v135.X.Offset + v139.X, v135.Y.Scale, v135.Y.Offset + v139.Y);
    end;
end);
armorMapping = {
    IronHelmet = ReplicatedStorage.Shared.items.wearables.Iron.IronHelmet.Image, 
    IronChestplate = ReplicatedStorage.Shared.items.wearables.Iron.IronChestplate.Image, 
    IronLeggings = ReplicatedStorage.Shared.items.wearables.Iron.IronLeggings.Image, 
    WoodHelmet = ReplicatedStorage.Shared.items.wearables.wood.WoodHelmet.Image, 
    WoodChestplate = ReplicatedStorage.Shared.items.wearables.wood.WoodChestplate.Image, 
    WoodLeggings = ReplicatedStorage.Shared.items.wearables.wood.WoodLeggings.Image, 
    Boots = ReplicatedStorage.Shared.items.wearables.clothes.Boots.Image, 
    CamoPants = ReplicatedStorage.Shared.items.wearables.clothes.CamoPants.Image, 
    CamoShirt = ReplicatedStorage.Shared.items.wearables.clothes.CamoShirt.Image, 
    Flippers = ReplicatedStorage.Shared.items.wearables.clothes.Flippers.Image, 
    PolicePants = ReplicatedStorage.Shared.items.wearables.clothes.PolicePants.Image, 
    PoliceShirt = ReplicatedStorage.Shared.items.wearables.clothes.PoliceShirt.Image, 
    RiotChestplate = ReplicatedStorage.Shared.items.wearables.riot.RiotChestplate.Image, 
    RiotHelmet = ReplicatedStorage.Shared.items.wearables.riot.RiotHelmet.Image, 
    RiotLeggings = ReplicatedStorage.Shared.items.wearables.riot.RiotLeggings.Image, 
    SteelChestplate = ReplicatedStorage.Shared.items.wearables.steel.SteelChestplate.Image, 
    SteelHelmet = ReplicatedStorage.Shared.items.wearables.steel.SteelHelmet.Image, 
    SteelLeggings = ReplicatedStorage.Shared.items.wearables.steel.SteelLeggings.Image, 
    CombatHelmet = ReplicatedStorage.Shared.items.wearables.CombatHelmet.Image, 
    GasMask = ReplicatedStorage.Shared.items.wearables.GasMask.Image, 
    JetPack = ReplicatedStorage.Shared.items.wearables.Jetpack.Image, 
    KevlarVest = ReplicatedStorage.Shared.items.wearables.KevlarVest.Image, 
    Rebreather = ReplicatedStorage.Shared.items.wearables.Rebreather.Image, 
    ShoulderLight = ReplicatedStorage.Shared.items.wearables.ShoulderLight.Image, 
    Sling = ReplicatedStorage.Shared.items.wearables.Sling.Image, 
    SmallBackpack = ReplicatedStorage.Shared.items.wearables.SmallBackpack.Image
};
screenGui = Instance.new("ScreenGui");
screenGui.Name = "ArmorPreviewUI";
screenGui.ResetOnSpawn = false;
screenGui.Parent = localPlayer:WaitForChild("PlayerGui");
local function v145(v140, v141) --[[ Line: 0 ]] --[[ Name:  ]]
    local v142 = v140:Clone();
    v142.Size = UDim2.new(0, 100, 0, 100);
    local l_Position_1 = G2L["2"].Position;
    local _ = G2L["2"].Size;
    v142.Position = UDim2.new(l_Position_1.X.Scale, l_Position_1.X.Offset + v141, l_Position_1.Y.Scale, l_Position_1.Y.Offset + -12);
    v142.BackgroundTransparency = 1;
    v142.Parent = G2L["1"];
end;
local v146 = Drawing.new("Circle");
v146.Visible = false;
v146.Thickness = 1.5;
v146.Radius = 150;
v146.Color = Color3.fromRGB(0, 255, 0);
v146.Filled = false;
local v147 = Drawing.new("Line");
v147.Visible = false;
v147.Thickness = 1.5;
v147.Color = Color3.fromRGB(255, 0, 0);
local v148 = nil;
local v149 = 0;
local v150 = 1;
local v151 = false;
local v152 = 220;

local MiscSection = VisualsTab:CreateSection("Misc")
MiscSection:CreateToggle("Armor ESP", function(boolean)
    v151 = boolean;
    if not boolean then
        for _, v155 in ipairs(screenGui:GetChildren()) do
            if v155:IsA("ViewportFrame") then
                v155:Destroy();
            end;
        end;
    end;
end)
MiscSection:CreateToggle("Show FOV", function(boolean)
   	v146.Visible = boolean;
end)
MiscSection:CreateSlider("FOV", 1, 500, 150, false, function(value)
   	v152 = value;
    v146.Radius = value;
end)
local function v167() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v152 (ref)
    local v159 = nil;
    local l_huge_0 = math.huge;
    local v161 = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2);
    for _, v163 in ipairs(workspace:GetChildren()) do
        if v163:IsA("Model") and v163:FindFirstChild("Head") and v163:FindFirstChild("Armor") then
            local v164, v165 = camera:WorldToViewportPoint(v163.Head.Position);
            if v165 then
                local l_Magnitude_0 = (Vector2.new(v164.X, v164.Y) - v161).Magnitude;
                if l_Magnitude_0 <= v152 and l_Magnitude_0 < l_huge_0 then
                    l_huge_0 = l_Magnitude_0;
                    v159 = v163;
                end;
            end;
        end;
    end;
    return v159;
end;
l_RunService_0.RenderStepped:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v146 (ref), v149 (ref), v150 (ref), v151 (ref), v147 (ref), v148 (ref), v167 (ref), v145 (ref)
    v146.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2);
    v149 = v149 + 1;
    if v149 < v150 then
        return;
    else
        v149 = 0;
        if not v151 then
            v147.Visible = false;
            v148 = nil;
            return;
        else
            local v168 = v167();
            if v168 then
                local v169, v170 = camera:WorldToViewportPoint(v168.Head.Position);
                if v170 then
                    v147.Visible = true;
                    v147.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2);
                    v147.To = Vector2.new(v169.X, v169.Y);
                    if v168 ~= v148 then
                        v148 = v168;
                        for _, v172 in ipairs(G2L["1"]:GetChildren()) do
                            if v172:IsA("ViewportFrame") then
                                v172:Destroy();
                            end;
                        end;
                        if v168:FindFirstChild("Armor") then
                            local v173 = 10;
                            for _, v175 in ipairs(v168.Armor:GetChildren()) do
                                local v176 = armorMapping[v175.Name];
                                if v176 then
                                    v145(v176, v173);
                                    v173 = v173 + 130;
                                end;
                            end;
                        end;
                    end;
                else
                    v147.Visible = false;
                    v148 = nil;
                end;
            else
                v147.Visible = false;
                v148 = nil;
            end;
            return;
        end;
    end;
end);
local function v180(v177, v178) --[[ Line: 0 ]] --[[ Name:  ]]
    local v179 = Drawing.new("Text");
    v179.Text = v177;
    v179.Size = 16;
    v179.Center = true;
    v179.Outline = true;
    v179.OutlineColor = Color3.new(0, 0, 0);
    v179.Color = v178;
    v179.Visible = false;
    return v179;
end;
ItemESP = {};
ItemESP_Enabled = false;
itemFrameCounter = 0;
local function v187(v181) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v180 (ref)
    if ItemESP[v181] then
        return;
    else
        local l_Union_0 = v181:FindFirstChild("Union");
        local l_Display_0 = v181:FindFirstChild("Display");
        local l_Part_0 = v181:FindFirstChild("Part");
        if not l_Union_0 or not l_Display_0 or not l_Part_0 then
            return;
        else
            local v185 = l_Union_0 or l_Display_0 or l_Part_0;
            local v186 = v180("Item", Color3.new(1, 1, 0));
            ItemESP[v181] = {
                drawing = v186, 
                part = v185
            };
            return;
        end;
    end;
end;
local function v190() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: l_Workspace_0 (ref), v187 (ref)
    if not ItemESP_Enabled then
        return;
    else
        for _, v189 in ipairs(l_Workspace_0:GetChildren()) do
            if v189:IsA("Model") then
                v187(v189);
            end;
        end;
        return;
    end;
end;

-- raid

local function v193() --[[ Line: 0 ]] --[[ Name:  ]]
    for _, v192 in pairs(ItemESP) do
        v192.drawing:Remove();
    end;
    ItemESP = {};
end;
CorpseESP = {};
CorpseESPEnabled = false;
local function v200(v194) --[[ Line: 0 ]] --[[ Name:  ]]
    local v195 = {};
    for _, v197 in ipairs(v194:GetChildren()) do
        if v197:IsA("BasePart") then
            table.insert(v195, v197);
        end;
    end;
    if #v195 ~= 2 then
        return false;
    else
        local l_Material_0 = v195[1].Material;
        local l_Material_1 = v195[2].Material;
        return l_Material_0 == Enum.Material.Fabric and not (l_Material_1 ~= Enum.Material.Metal) or l_Material_0 == Enum.Material.Metal and l_Material_1 == Enum.Material.Fabric;
    end;
end;
local function v203(v201) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v180 (ref)
    if CorpseESP[v201] then
        return;
    else
        local v202 = v180("Bag", Color3.fromRGB(255, 255, 255));
        CorpseESP[v201] = {
            drawing = v202, 
            model = v201
        };
        v201.Destroying:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v202 (ref), v201 (ref)
            v202:Remove();
            CorpseESP[v201] = nil;
        end);
        return;
    end;
end;
local function v206() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: l_Workspace_0 (ref), v200 (ref), v203 (ref)
    for _, v205 in ipairs(l_Workspace_0:GetChildren()) do
        if v205:IsA("Model") and v200(v205) then
            v203(v205);
        end;
    end;
end;
l_Workspace_0.ChildAdded:Connect(function(v207) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v200 (ref), v203 (ref)
    if v207:IsA("Model") and v200(v207) then
        v203(v207);
    end;
end);
RaidESP = {};
RaidESP_Enabled = false;
hitSoundNames = {
    Explosion = true, 
    Explosion_Muffled = true
};
local function v210(v208) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v180 (ref)
    v208.Played:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v208 (ref), v180 (ref)
        local v209 = v208.Parent and v208.Parent.Position;
        if v209 then
            table.insert(RaidESP, {
                text = v180("Raid", Color3.fromRGB(255, 0, 0)), 
                position = v209, 
                startTime = tick()
            });
        end;
    end);
end;
local l_ipairs_0 = ipairs;
local v212 = "GetDescendants";
local l_l_Workspace_0_0 = l_Workspace_0;
for _, v215 in l_ipairs_0(l_Workspace_0[v212](l_l_Workspace_0_0)) do
    if v215:IsA("Sound") and hitSoundNames[v215.Name] then
        v210(v215);
    end;
end;
l_Workspace_0.DescendantAdded:Connect(function(v216) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v210 (ref)
    if v216:IsA("Sound") and hitSoundNames[v216.Name] then
        v210(v216);
    end;
end);
AirdropESP = {};
AirdropESP_Enabled = false;
l_ipairs_0 = function(v217) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v180 (ref)
    if not v217 or not v217.Parent then
        return;
    else
        local v218 = v217:FindFirstChild("Crates") or v217:FindFirstChild("Cables");
        if not v218 then
            return;
        else
            if not AirdropESP[v217] then
                local v219 = v180("Airdrop", Color3.fromRGB(255, 255, 0));
                AirdropESP[v217] = {
                    drawing = v219, 
                    part = v218
                };
            end;
            return;
        end;
    end;
end;
local function v222() --[[ Line: 0 ]] --[[ Name:  ]]
    for _, v221 in pairs(AirdropESP) do
        v221.drawing:Remove();
    end;
    AirdropESP = {};
end;
l_RunService_0.RenderStepped:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v190 (ref), l_CurrentCamera_0 (ref), l_Workspace_0 (ref), l_ipairs_0 (ref)
    if ItemESP_Enabled then
        itemFrameCounter = itemFrameCounter + 1;
        if itemFrameCounter >= 10 then
            v190();
            itemFrameCounter = 0;
        end;
        for v223, v224 in pairs(ItemESP) do
            if v224.part and v224.part.Parent then
                local v225, v226 = l_CurrentCamera_0:WorldToViewportPoint(v224.part.Position);
                v224.drawing.Visible = v226;
                if v226 then
                    v224.drawing.Position = Vector2.new(v225.X, v225.Y - 20);
                end;
            else
                v224.drawing:Remove();
                ItemESP[v223] = nil;
            end;
        end;
    end;
    if CorpseESPEnabled then
        for v227, v228 in pairs(CorpseESP) do
            local v229 = v227.PrimaryPart or v227:FindFirstChildWhichIsA("BasePart");
            if v229 then
                local v230, v231 = l_CurrentCamera_0:WorldToViewportPoint(v229.Position);
                v228.drawing.Visible = v231;
                if v231 then
                    v228.drawing.Position = Vector2.new(v230.X, v230.Y - 20);
                end;
            else
                v228.drawing.Visible = false;
            end;
        end;
    else
        for _, v233 in pairs(CorpseESP) do
            v233.drawing.Visible = false;
        end;
    end;
    if RaidESP_Enabled then
        for v234 = #RaidESP, 1, -1 do
            local v235 = RaidESP[v234];
            local v236 = tick() - v235.startTime;
            if v236 > 300 then
                v235.text:Remove();
                table.remove(RaidESP, v234);
            else
                local v237, v238 = l_CurrentCamera_0:WorldToViewportPoint(v235.position);
                v235.text.Visible = v238;
                if v238 then
                    local v239 = math.floor((v235.position - l_CurrentCamera_0.CFrame.Position).Magnitude);
                    v235.text.Text = "Raid | " .. v239 .. " | " .. math.floor(v236);
                    v235.text.Position = Vector2.new(v237.X, v237.Y);
                end;
            end;
        end;
    end;
    if AirdropESP_Enabled then
        for _, v241 in ipairs(l_Workspace_0:GetChildren()) do
            if v241:IsA("Model") then
                l_ipairs_0(v241);
            end;
        end;
        for v242, v243 in pairs(AirdropESP) do
            if not v242 or not v242.Parent then
                v243.drawing:Remove();
                AirdropESP[v242] = nil;
            else
                local v244, v245 = l_CurrentCamera_0:WorldToViewportPoint(v243.part.Position);
                v243.drawing.Visible = v245;
                if v245 then
                    v243.drawing.Position = Vector2.new(v244.X, v244.Y - 20);
                end;
            end;
        end;
    end;
end);
MiscSection:CreateToggle("Item ESP", function(boolean)
   	ItemESP_Enabled = boolean;
    if boolean then
        v190();
    else
        v193();
    end;
end)
MiscSection:CreateToggle("Bag ESP", function(boolean)
   	CorpseESPEnabled = boolean;
    if boolean then
        v206();
    end;
end)
MiscSection:CreateToggle("Raid ESP", function(boolean)
   	RaidESP_Enabled = boolean;
    if not boolean then
        for _, v250 in pairs(RaidESP) do
            v250.text:Remove();
        end;
        RaidESP = {};
    end;
end)
MiscSection:CreateToggle("Airdrop ESP", function(boolean)
   	AirdropESP_Enabled = boolean;
    if not boolean then
        v222();
    end;
end)

local FarmTab = CoastingLibrary:CreateTab("Farming")
local OreSection = FarmTab:CreateSection("Ores")
OreSection:CreateToggle("Stone ESP", function(boolean)
   	ESP_ENABLED.Stone = boolean;
end)
OreSection:CreateToggle("Iron ESP", function(boolean)
   	ESP_ENABLED.Iron = boolean;
end)
OreSection:CreateToggle("Stone ESP", function(boolean)
   	ESP_ENABLED.Nitrate = boolean;
end)
OreSection:CreateToggle("Show Distance", function(boolean)
   	ESP_ENABLED.ShowDistance = boolean;
end)
OreSection:CreateSlider("Ore Distance", 10, 1000, 750, false, function(value)
	renderDistance = value
end)
local l_RunService_1 = game:GetService("RunService");
local l_Workspace_1 = game:GetService("Workspace");
local l_CurrentCamera_1 = l_Workspace_1.CurrentCamera;
local _ = game:GetService("Players").LocalPlayer;
ESP_ENABLED = {
    Stone = false, 
    Iron = false, 
    Nitrate = false, 
    ShowDistance = false
};
oreESP = {};
renderDistance = 750;
local v269 = {
    Stone = {
        Color3.fromRGB(72, 72, 72)
    }, 
    Iron = {
        Color3.fromRGB(72, 72, 72), 
        Color3.fromRGB(199, 172, 120)
    }, 
    Nitrate = {
        Color3.fromRGB(248, 248, 248), 
        Color3.fromRGB(72, 72, 72)
    }
};
local v270 = {
    Stone = Color3.fromRGB(120, 120, 120), 
    Iron = Color3.fromRGB(255, 215, 0), 
    Nitrate = Color3.fromRGB(200, 255, 200)
};
local function v273(v271, v272) --[[ Line: 0 ]] --[[ Name:  ]]
    return math.abs(v271.R - v272.R) < 0.02 and math.abs(v271.G - v272.G) < 0.02 and math.abs(v271.B - v272.B) < 0.02;
end;
local function v281(v274) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v273 (ref), v269 (ref)
    local v275 = {};
    for _, v277 in ipairs(v274:GetChildren()) do
        if v277:IsA("MeshPart") then
            table.insert(v275, v277);
        end;
    end;
    if #v275 == 1 then
        local l_Color_0 = v275[1].Color;
        if v273(l_Color_0, v269.Stone[1]) then
            return "Stone", v275[1];
        end;
    elseif #v275 == 2 then
        local l_Color_1 = v275[1].Color;
        local l_Color_2 = v275[2].Color;
        if v273(l_Color_1, v269.Iron[1]) and v273(l_Color_2, v269.Iron[2]) or v273(l_Color_1, v269.Iron[2]) and v273(l_Color_2, v269.Iron[1]) then
            return "Iron", v275[1];
        elseif v273(l_Color_1, v269.Nitrate[1]) and v273(l_Color_2, v269.Nitrate[2]) or v273(l_Color_1, v269.Nitrate[2]) and v273(l_Color_2, v269.Nitrate[1]) then
            return "Nitrate", v275[1];
        end;
    end;
    return nil;
end;
local function v286(v282, v283, v284) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v270 (ref)
    local v285 = Drawing.new("Text");
    v285.Text = v283;
    v285.Size = 16;
    v285.Center = true;
    v285.Outline = true;
    v285.Color = v270[v283];
    v285.Visible = true;
    oreESP[v282] = {
        Text = v285, 
        OreType = v283, 
        Part = v284
    };
end;
local function v288(v287) --[[ Line: 0 ]] --[[ Name:  ]]
    if oreESP[v287] then
        oreESP[v287].Text:Remove();
        oreESP[v287] = nil;
    end;
end;
task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: l_Workspace_1 (ref), v281 (ref), v286 (ref), v288 (ref)
    while true do
        for _, v290 in ipairs(l_Workspace_1:GetChildren()) do
            if v290:IsA("Model") and not oreESP[v290] then
                local v291, v292 = v281(v290);
                if v291 and ESP_ENABLED[v291] then
                    v286(v290, v291, v292);
                end;
            end;
        end;
        for v293 in pairs(oreESP) do
            if not v293.Parent then
                v288(v293);
            end;
        end;
        task.wait(2);
    end;
end);
l_RunService_1.RenderStepped:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: l_CurrentCamera_1 (ref), v288 (ref)
    for v294, v295 in pairs(oreESP) do
        local l_Part_1 = v295.Part;
        if l_Part_1 and l_Part_1.Parent then
            local l_Magnitude_1 = (l_CurrentCamera_1.CFrame.Position - l_Part_1.Position).Magnitude;
            local v298, v299 = l_CurrentCamera_1:WorldToViewportPoint(l_Part_1.Position);
            if v299 and l_Magnitude_1 <= renderDistance and ESP_ENABLED[v295.OreType] then
                local l_Text_0 = v295.Text;
                if ESP_ENABLED.ShowDistance then
                    l_Text_0.Text = string.format("%s | %.0fm", v295.OreType, l_Magnitude_1);
                else
                    l_Text_0.Text = v295.OreType;
                end;
                l_Text_0.Position = Vector2.new(v298.X, v298.Y);
                l_Text_0.Visible = true;
            else
                v295.Text.Visible = false;
            end;
        else
            v288(v294);
        end;
    end;
end);
local l_RunService_2 = game:GetService("RunService");
local l_CurrentCamera_2 = workspace.CurrentCamera;
local _ = game:GetService("UserInputService");
local l_vehicles_0 = game:GetService("ReplicatedStorage").Shared.entities.vehicles;
VehicleBlueprints = {
    ATV = l_vehicles_0.ATV.Model, 
    Boat = l_vehicles_0.Boat.Model, 
    Helicopter = l_vehicles_0.Helicopter.Model, 
    Trolly = l_vehicles_0.Trolly.Model
};
VehicleESP = {};
EspEnabled = {
    ATV = false, 
    Boat = false, 
    Helicopter = false, 
    Trolly = false
};
DistanceESPEnabled = false;
local function v310(v306, v307) --[[ Line: 0 ]] --[[ Name:  ]]
    for _, v309 in ipairs(v307:GetChildren()) do
        if not v306:FindFirstChild(v309.Name) then
            return false;
        end;
    end;
    return true;
end;
local function v314(v311, v312) --[[ Line: 0 ]] --[[ Name:  ]]
    local v313 = Drawing.new("Text");
    v313.Size = 18;
    v313.Color = Color3.fromRGB(0, 255, 0);
    v313.Center = true;
    v313.Outline = true;
    v313.Visible = true;
    VehicleESP[v311] = {
        Drawing = v313, 
        Name = v312
    };
end;
local function v316(v315) --[[ Line: 0 ]] --[[ Name:  ]]
    if VehicleESP[v315] then
        VehicleESP[v315].Drawing:Remove();
        VehicleESP[v315] = nil;
    end;
end;
local v317 = 0;
local v318 = 500;
l_RunService_2.RenderStepped:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v317 (ref), v318 (ref), v310 (ref), v314 (ref), v316 (ref), l_CurrentCamera_2 (ref)
    v317 = v317 + 1;
    if v317 % v318 == 0 then
        for _, v320 in ipairs(workspace:GetChildren()) do
            if v320:IsA("Model") and not VehicleESP[v320] then
                for v321, v322 in pairs(VehicleBlueprints) do
                    if EspEnabled[v321] and v310(v320, v322) then
                        v314(v320, v321);
                        break;
                    end;
                end;
            end;
        end;
        for v323, _ in pairs(VehicleESP) do
            if not v323.Parent then
                v316(v323);
            end;
        end;
    end;
    for v325, v326 in pairs(VehicleESP) do
        local l_Drawing_0 = v326.Drawing;
        local l_Name_0 = v326.Name;
        if EspEnabled[l_Name_0] and v325.PrimaryPart then
            local v329, v330 = l_CurrentCamera_2:WorldToViewportPoint(v325.PrimaryPart.Position);
            if v330 then
                local v331 = math.floor((v325.PrimaryPart.Position - l_CurrentCamera_2.CFrame.Position).Magnitude);
                if DistanceESPEnabled then
                    l_Drawing_0.Text = string.format("%s | %dm", l_Name_0, v331);
                else
                    l_Drawing_0.Text = l_Name_0;
                end;
                l_Drawing_0.Position = Vector2.new(v329.X, v329.Y);
                l_Drawing_0.Visible = true;
            else
                l_Drawing_0.Visible = false;
            end;
        else
            l_Drawing_0.Visible = false;
        end;
    end;
end);

local VehicleSection = FarmTab:CreateSection("Vehicle")
VehicleSection:CreateToggle("ATV", function(boolean)
	EspEnabled.ATV = boolean
end)
VehicleSection:CreateToggle("Boat", function(boolean)
	EspEnabled.Boat = boolean
end)
VehicleSection:CreateToggle("Helicopter", function(boolean)
	EspEnabled.Helicopter = boolean
end)
VehicleSection:CreateToggle("Trolly", function(boolean)
	EspEnabled.Trolly = boolean
end)
VehicleSection:CreateToggle("Distance ESP", function(boolean)
	DistanceESPEnabled = v336;
end)
-- a
local WorldTab = CoastingLibrary:CreateTab("World")
local WorldSection = WorldTab:CreateSection("World")
WorldSection:CreateToggle("Shadows", function(boolean)
   	game:GetService("Lighting").GlobalShadows = boolean
end)
WorldSection:CreateToggle("Grass", function(boolean)
   	setGrass(boolean);
end)
if not game:IsLoaded() then
    repeat
        task.wait();
    until game:IsLoaded();
end;
local v366 = nil;
repeat
    v366 = workspace:FindFirstChildOfClass("Terrain");
    task.wait();
until v366;
setGrass = function(v367) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v366 (ref)
    if not sethiddenproperty then
        warn("Your executor does not support sethiddenproperty");
        return;
    else
        if not pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v366 (ref), v367 (ref)
            sethiddenproperty(v366, "Decoration", v367);
        end) then
            warn("Failed to change grass (Decoration property)");
        end;
        return;
    end;
end;
setGrass(true);
local l_Workspace_2 = game:GetService("Workspace");
local v369 = {
    "Fir3_Leaves", 
    "Elm1_Leaves", 
    "Birch1_Leaves"
};
local function v373(v370) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: l_Workspace_2 (ref), v369 (ref)
    for _, v372 in ipairs(l_Workspace_2:GetDescendants()) do
        if v372:IsA("BasePart") and table.find(v369, v372.Name) then
            v372.Transparency = v370 and 0 or 1;
            v372.CanCollide = v370;
        end;
    end;
end;

WorldSection:CreateToggle("Tree Leaves", function(boolean)
   	v373(boolean);
end)
local l_Lighting_1 = game:GetService("Lighting");
local l_RunService_3 = game:GetService("RunService");
local v378 = false;
local v379 = 2.5;
local v380 = 18.5;
local v381 = 6.5;
local function v387() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: l_Lighting_1 (ref)
    local v382, v383, v384 = string.match(l_Lighting_1.TimeOfDay, "(%d+):(%d+):(%d+)");
    local v385 = tonumber(v382);
    local v386 = tonumber(v383);
    v384 = tonumber(v384);
    return v385 + v386 / 60 + v384 / 3600;
end;
l_RunService_3.RenderStepped:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v378 (ref), l_Lighting_1 (ref), v387 (ref), v380 (ref), v381 (ref), v379 (ref)
    if not v378 then
        l_Lighting_1.ExposureCompensation = 0;
        return;
    else
        local v388 = v387();
        local v389 = 0;
        if v380 <= v388 or v388 < v381 then
            if v380 <= v388 then
                v388 = v388 - 24;
            end;
            if v388 < 0 then
                v389 = v379 * ((v388 + 3) / 3);
            else
                v389 = v379 * math.clamp(1 - v388 / v381, 0, 1);
            end;
        else
            v389 = 0;
        end;
        l_Lighting_1.ExposureCompensation = v389;
        return;
    end;
end);

WorldSection:CreateToggle("Bright Night", function(boolean)
   	v378 = boolean;
    if not boolean then
        l_Lighting_1.ExposureCompensation = 0;
    end;
end)

local LightingSection = WorldTab:CreateSection("Lighting")
LightingSection:CreateToggle("Lighting", function(boolean)
   	game:GetService("Lighting").StimEffect.Enabled = boolean;
end)
LightingSection:CreateColorPicker("TintColor", Color3.fromRGB(255, 255, 255), function(color)
   	game:GetService("Lighting").StimEffect.TintColor = color
end)
LightingSection:CreateSlider("Brightness", 1, 50, 1, false, function(value)
   	game:GetService("Lighting").StimEffect.Brightness = (value / 10)
end)
LightingSection:CreateSlider("Contrast", 1, 100, 10, false, function(value)
   	game:GetService("Lighting").StimEffect.Contrast = (value / 10)
end)
LightingSection:CreateSlider("Saturation", 1, 10, 10, false, function(value)
   	game:GetService("Lighting").StimEffect.Saturation = value
end)

-- why are you here