Players = game:GetService("Players");
RunService = game:GetService("RunService");
localPlayer = Players.LocalPlayer;
ReplicatedStorage = game:GetService("ReplicatedStorage");
camera = workspace.CurrentCamera;
Workspace = game:GetService("Workspace");
local v0 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))();
local l_v0_Window_0 = v0:CreateWindow({
    Name = "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 Radium.cc \239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189", 
    Icon = 0, 
    LoadingTitle = "Radium.cc now loading", 
    LoadingSubtitle = "by 48SSG", 
    ShowText = "Rayfield", 
    Theme = "AmberGlow", 
    ToggleUIKeybind = "K", 
    DisableRayfieldPrompts = false, 
    DisableBuildWarnings = false, 
    ConfigurationSaving = {
        Enabled = false, 
        FolderName = nil, 
        FileName = "Big Hub"
    }, 
    Discord = {
        Enabled = false, 
        Invite = "noinvitelink", 
        RememberJoins = true
    }, 
    KeySystem = false
});
local l_l_v0_Window_0_Tab_0 = l_v0_Window_0:CreateTab("AimBot", nil);
local _ = l_l_v0_Window_0_Tab_0:CreateSection("Big Head");
Players = game:GetService("Players");
RunService = game:GetService("RunService");
localPlayer = Players.LocalPlayer;
HeadSizeEnabled = false;
local v4 = 0;
local v5 = 25;
headScale = Vector3.new(2, 2, 2);
headTransparency = 0;
local v6 = {};
local function v9(v7) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v6 (ref)
    local l_Head_0 = v7:FindFirstChild("Head");
    if l_Head_0 and l_Head_0:IsA("BasePart") then
        if HeadSizeEnabled then
            if not v6[l_Head_0] then
                v6[l_Head_0] = {
                    Size = l_Head_0.Size, 
                    Transparency = l_Head_0.Transparency
                };
            end;
            l_Head_0.Size = headScale;
            l_Head_0.Transparency = headTransparency;
        elseif v6[l_Head_0] then
            l_Head_0.Size = v6[l_Head_0].Size;
            l_Head_0.Transparency = v6[l_Head_0].Transparency;
            v6[l_Head_0] = nil;
        end;
    end;
end;
RunService.RenderStepped:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v4 (ref), v5 (ref), v9 (ref)
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
local _ = l_l_v0_Window_0_Tab_0:CreateToggle({
    Name = "Big Head", 
    CurrentValue = false, 
    Flag = "HeadToggle", 
    Callback = function(v12) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v6 (ref)
        HeadSizeEnabled = v12;
        if not v12 then
            for v13, v14 in pairs(v6) do
                if v13 and v13.Parent then
                    v13.Size = v14.Size;
                    v13.Transparency = v14.Transparency;
                end;
            end;
            v6 = {};
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_0:CreateSlider({
    Name = "Head Size", 
    Range = {
        1, 
        10
    }, 
    Increment = 1, 
    Suffix = "x", 
    CurrentValue = 2, 
    Flag = "HeadSizeSlider", 
    Callback = function(v16) --[[ Line: 0 ]] --[[ Name:  ]]
        headScale = Vector3.new(v16, v16, v16);
    end
});
local _ = l_l_v0_Window_0_Tab_0:CreateSlider({
    Name = "Head Transparency", 
    Range = {
        0, 
        1
    }, 
    Increment = 0.1, 
    CurrentValue = 0, 
    Flag = "HeadTransparencySlider", 
    Callback = function(v18) --[[ Line: 0 ]] --[[ Name:  ]]
        headTransparency = v18;
    end
});
local l_l_v0_Window_0_Tab_1 = l_v0_Window_0:CreateTab("ESP", nil);
local _ = l_l_v0_Window_0_Tab_1:CreateSection("Players");
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
l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Box Esp", 
    CurrentValue = false, 
    Flag = "BoxEspToggle", 
    Callback = function(v37) --[[ Line: 0 ]] --[[ Name:  ]]
        ToggleBoxes(v37);
    end
});
l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Distance Esp", 
    CurrentValue = false, 
    Flag = "DistanceEspToggle", 
    Callback = function(v38) --[[ Line: 0 ]] --[[ Name:  ]]
        ToggleDistance(v38);
    end
});
l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Player/Bot Esp", 
    CurrentValue = false, 
    Flag = "BotEspToggle", 
    Callback = function(v39) --[[ Line: 0 ]] --[[ Name:  ]]
        ToggleType(v39);
    end
});
l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Sleeper Check", 
    CurrentValue = false, 
    Flag = "SleeperCheckToggle", 
    Callback = function(v40) --[[ Line: 0 ]] --[[ Name:  ]]
        ToggleSleeperCheck(v40);
    end
});
l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Weapon Esp", 
    CurrentValue = false, 
    Flag = "WeaponEspToggle", 
    Callback = function(v41) --[[ Line: 0 ]] --[[ Name:  ]]
        ToggleWeaponESP(v41);
    end
});
l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Skeleton Esp", 
    CurrentValue = false, 
    Flag = "SkeletonEspToggle", 
    Callback = function(v42) --[[ Line: 0 ]] --[[ Name:  ]]
        ToggleSkeletonESP(v42);
    end
});
l_l_v0_Window_0_Tab_1:CreateColorPicker({
    Name = "Box Color", 
    Color = Color3.fromRGB(255, 255, 255), 
    Flag = "BoxColorPicker1", 
    Callback = function(v43) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v33 (ref)
        v33 = v43;
    end
});
l_l_v0_Window_0_Tab_1:CreateColorPicker({
    Name = "Skeleton Color", 
    Color = Color3.fromRGB(255, 255, 255), 
    Flag = "SkeletonColorPicker1", 
    Callback = function(v44) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v35 (ref)
        v35 = v44;
    end
});
l_l_v0_Window_0_Tab_1:CreateColorPicker({
    Name = "Text Color", 
    Color = Color3.fromRGB(255, 255, 255), 
    Flag = "TextColorPicker1", 
    Callback = function(v45) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v34 (ref)
        v34 = v45;
    end
});
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
local l_l_l_v0_Window_0_Tab_1_Section_1 = l_l_v0_Window_0_Tab_1:CreateSection("Armor");
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
local _ = l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Armor Esp", 
    CurrentValue = false, 
    Flag = "Toggle1", 
    Callback = function(v153) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v151 (ref)
        v151 = v153;
        if not v153 then
            for _, v155 in ipairs(screenGui:GetChildren()) do
                if v155:IsA("ViewportFrame") then
                    v155:Destroy();
                end;
            end;
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_1:CreateSlider({
    Name = "Fov Slider", 
    Range = {
        10, 
        500
    }, 
    Increment = 1, 
    Suffix = "Size", 
    CurrentValue = 220, 
    Flag = "Slider1", 
    Callback = function(v157) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v152 (ref), v146 (ref)
        v152 = v157;
        v146.Radius = v157;
    end
});
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
l_l_l_v0_Window_0_Tab_1_Section_1 = l_l_v0_Window_0_Tab_1:CreateSection("Other");
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
        local v202 = v180("Corpse", Color3.fromRGB(255, 0, 0));
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
l_l_Workspace_0_0 = l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Item ESP", 
    CurrentValue = false, 
    Flag = "ToggleItemESP", 
    Callback = function(v246) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v190 (ref), v193 (ref)
        ItemESP_Enabled = v246;
        if v246 then
            v190();
        else
            v193();
        end;
    end
});
v212 = l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Corpse ESP", 
    CurrentValue = false, 
    Flag = "ToggleCorpseESP", 
    Callback = function(v247) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v206 (ref)
        CorpseESPEnabled = v247;
        if v247 then
            v206();
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Raid ESP", 
    CurrentValue = false, 
    Flag = "ToggleRaidESP", 
    Callback = function(v248) --[[ Line: 0 ]] --[[ Name:  ]]
        RaidESP_Enabled = v248;
        if not v248 then
            for _, v250 in pairs(RaidESP) do
                v250.text:Remove();
            end;
            RaidESP = {};
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Airdrop ESP", 
    CurrentValue = false, 
    Flag = "ToggleAirdropESP", 
    Callback = function(v252) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v222 (ref)
        AirdropESP_Enabled = v252;
        if not v252 then
            v222();
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_1:CreateSection("Ore Esp");
local _ = l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Stone Esp", 
    CurrentValue = false, 
    Flag = "StoneToggle", 
    Callback = function(v255) --[[ Line: 0 ]] --[[ Name:  ]]
        ESP_ENABLED.Stone = v255;
    end
});
local _ = l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Iron Esp", 
    CurrentValue = false, 
    Flag = "IronToggle", 
    Callback = function(v257) --[[ Line: 0 ]] --[[ Name:  ]]
        ESP_ENABLED.Iron = v257;
    end
});
local _ = l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Nitrate Esp", 
    CurrentValue = false, 
    Flag = "NitrateToggle", 
    Callback = function(v259) --[[ Line: 0 ]] --[[ Name:  ]]
        ESP_ENABLED.Nitrate = v259;
    end
});
local _ = l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Show Distance", 
    CurrentValue = false, 
    Flag = "ShowDistanceToggle", 
    Callback = function(v261) --[[ Line: 0 ]] --[[ Name:  ]]
        ESP_ENABLED.ShowDistance = v261;
    end
});
local _ = l_l_v0_Window_0_Tab_1:CreateSlider({
    Name = "Ore Distance Esp", 
    Range = {
        10, 
        1000
    }, 
    Increment = 1, 
    Suffix = "m", 
    CurrentValue = 750, 
    Flag = "DistanceSlider", 
    Callback = function(v263) --[[ Line: 0 ]] --[[ Name:  ]]
        renderDistance = v263;
    end
});
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
local _ = l_l_v0_Window_0_Tab_1:CreateSection("Vehicles");
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
l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "ATV", 
    CurrentValue = false, 
    Flag = "ATV_ESP", 
    Callback = function(v332) --[[ Line: 0 ]] --[[ Name:  ]]
        EspEnabled.ATV = v332;
    end
});
l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Boat", 
    CurrentValue = false, 
    Flag = "Boat_ESP", 
    Callback = function(v333) --[[ Line: 0 ]] --[[ Name:  ]]
        EspEnabled.Boat = v333;
    end
});
l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Helicopter", 
    CurrentValue = false, 
    Flag = "Heli_ESP", 
    Callback = function(v334) --[[ Line: 0 ]] --[[ Name:  ]]
        EspEnabled.Helicopter = v334;
    end
});
l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Trolly", 
    CurrentValue = false, 
    Flag = "Trolly_ESP", 
    Callback = function(v335) --[[ Line: 0 ]] --[[ Name:  ]]
        EspEnabled.Trolly = v335;
    end
});
l_l_v0_Window_0_Tab_1:CreateToggle({
    Name = "Distance Esp", 
    CurrentValue = false, 
    Flag = "Vehicle_Distance_ESP", 
    Callback = function(v336) --[[ Line: 0 ]] --[[ Name:  ]]
        DistanceESPEnabled = v336;
    end
});
local l_l_v0_Window_0_Tab_2 = l_v0_Window_0:CreateTab("World \239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189", nil);
local _ = l_l_v0_Window_0_Tab_2:CreateSection("Water");
local _ = l_l_v0_Window_0_Tab_2:CreateColorPicker({
    Name = "Water Color", 
    Color = Color3.fromRGB(12, 84, 92), 
    Flag = "ColorPicker1", 
    Callback = function(v339) --[[ Line: 0 ]] --[[ Name:  ]]
        game.Workspace.Terrain.WaterColor = v339;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateToggle({
    Name = "Water Reflectance", 
    CurrentValue = true, 
    Flag = "Toggle1", 
    Callback = function(v341) --[[ Line: 0 ]] --[[ Name:  ]]
        if v341 == true then
            game.Workspace.Terrain.WaterReflectance = 1;
        elseif v341 == false then
            game.Workspace.Terrain.WaterReflectance = 0;
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateSlider({
    Name = "Water speed", 
    Range = {
        1, 
        100
    }, 
    Increment = 1, 
    Suffix = "Speed", 
    CurrentValue = 10, 
    Flag = "Slider1", 
    Callback = function(v343) --[[ Line: 0 ]] --[[ Name:  ]]
        game.Workspace.Terrain.WaterWaveSpeed = v343;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateSlider({
    Name = "Wave size", 
    Range = {
        0, 
        1
    }, 
    Increment = 0.1, 
    Suffix = "Size", 
    CurrentValue = 0.5, 
    Flag = "Slider1", 
    Callback = function(v345) --[[ Line: 0 ]] --[[ Name:  ]]
        game.Workspace.Terrain.WaterWaveSize = v345;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateSection("Clouds");
local _ = l_l_v0_Window_0_Tab_2:CreateColorPicker({
    Name = "Color Picker", 
    Color = Color3.fromRGB(255, 255, 255), 
    Flag = "ColorPicker1", 
    Callback = function(v348) --[[ Line: 0 ]] --[[ Name:  ]]
        game.Workspace.Terrain.Clouds.Color = v348;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateSlider({
    Name = "Clouds", 
    Range = {
        0, 
        1
    }, 
    Increment = 0.1, 
    Suffix = "Clouds", 
    CurrentValue = 0.6, 
    Flag = "Slider1", 
    Callback = function(v350) --[[ Line: 0 ]] --[[ Name:  ]]
        game.Workspace.Terrain.Clouds.Cover = v350;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateSection("SkyBox");
local _ = l_l_v0_Window_0_Tab_2:CreateDropdown({
    Name = "Sky Changer", 
    Options = {
        "Defalt", 
        "Magma", 
        "Water", 
        "Obsidian", 
        "Galaxy", 
        "Void"
    }, 
    CurrentOption = {
        "Defalt"
    }, 
    MultipleOptions = false, 
    Flag = "Dropdown1", 
    Callback = function(v353) --[[ Line: 0 ]] --[[ Name:  ]]
        if type(v353) == "table" then
            v353 = v353[1];
        end;
        local l_Lighting_0 = game:GetService("Lighting");
        for _, v356 in ipairs(l_Lighting_0:GetChildren()) do
            if v356:IsA("Sky") then
                v356:Destroy();
            end;
        end;
        if v353 == "Defalt" then
            return;
        else
            local v357 = {
                Magma = "rbxassetid://16468735533", 
                Water = "rbxassetid://17253866105", 
                Obsidian = "rbxassetid://17253878595", 
                Galaxy = "rbxassetid://13726625670", 
                Void = "rbxassetid://16666915143"
            };
            local l_Sky_0 = Instance.new("Sky");
            l_Sky_0.Name = "ExecutorSky";
            l_Sky_0.Parent = l_Lighting_0;
            local v359 = v357[v353];
            if v359 then
                l_Sky_0.SkyboxBk = v359;
                l_Sky_0.SkyboxDn = v359;
                l_Sky_0.SkyboxFt = v359;
                l_Sky_0.SkyboxLf = v359;
                l_Sky_0.SkyboxRt = v359;
                l_Sky_0.SkyboxUp = v359;
            end;
            return;
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateSection("Other");
local _ = l_l_v0_Window_0_Tab_2:CreateToggle({
    Name = "Shadows", 
    CurrentValue = true, 
    Flag = "Toggle1", 
    Callback = function(v362) --[[ Line: 0 ]] --[[ Name:  ]]
        game:GetService("Lighting").GlobalShadows = v362;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateToggle({
    Name = "Grass", 
    CurrentValue = true, 
    Flag = "GrassToggle", 
    Callback = function(v364) --[[ Line: 0 ]] --[[ Name:  ]]
        setGrass(v364);
    end
});
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
local _ = l_l_v0_Window_0_Tab_2:CreateToggle({
    Name = "Tree Leaves", 
    CurrentValue = true, 
    Flag = "Toggle1", 
    Callback = function(v374) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v373 (ref)
        v373(v374);
    end
});
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
local _ = l_l_v0_Window_0_Tab_2:CreateToggle({
    Name = "Bright Night", 
    CurrentValue = false, 
    Flag = "BrightNightToggle", 
    Callback = function(v390) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v378 (ref), l_Lighting_1 (ref)
        v378 = v390;
        if not v390 then
            l_Lighting_1.ExposureCompensation = 0;
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateSection("Lighting");
local _ = l_l_v0_Window_0_Tab_2:CreateToggle({
    Name = "Lighting", 
    CurrentValue = false, 
    Flag = "Toggle1", 
    Callback = function(v393) --[[ Line: 0 ]] --[[ Name:  ]]
        game:GetService("Lighting").StimEffect.Enabled = v393;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateColorPicker({
    Name = "TintColor", 
    Color = Color3.fromRGB(255, 255, 255), 
    Flag = "ColorPicker1", 
    Callback = function(v395) --[[ Line: 0 ]] --[[ Name:  ]]
        game:GetService("Lighting").StimEffect.TintColor = v395;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateSlider({
    Name = "Brightness", 
    Range = {
        0.1, 
        100
    }, 
    Increment = 0.1, 
    Suffix = "Brightness", 
    CurrentValue = 0.1, 
    Flag = "Slider1", 
    Callback = function(v397) --[[ Line: 0 ]] --[[ Name:  ]]
        game:GetService("Lighting").StimEffect.Brightness = v397;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateSlider({
    Name = "Contrast", 
    Range = {
        0, 
        20
    }, 
    Increment = 0.1, 
    Suffix = "Contrast", 
    CurrentValue = 1, 
    Flag = "Slider1", 
    Callback = function(v399) --[[ Line: 0 ]] --[[ Name:  ]]
        game:GetService("Lighting").StimEffect.Contrast = v399;
    end
});
local _ = l_l_v0_Window_0_Tab_2:CreateSlider({
    Name = "Saturation", 
    Range = {
        0, 
        100
    }, 
    Increment = 1, 
    Suffix = "Saturation", 
    CurrentValue = 10, 
    Flag = "Slider1", 
    Callback = function(v401) --[[ Line: 0 ]] --[[ Name:  ]]
        game:GetService("Lighting").StimEffect.Saturation = v401;
    end
});
local l_l_v0_Window_0_Tab_3 = l_v0_Window_0:CreateTab("Player", nil);
local _ = l_l_v0_Window_0_Tab_3:CreateSection("Other");
local _ = game:GetService("UserInputService");
local l_Workspace_3 = game:GetService("Workspace");
local v407 = false;
local v408 = {
    Enum.Material.Cobblestone, 
    Enum.Material.WoodPlanks, 
    Enum.Material.Metal, 
    Enum.Material.CorrodedMetal
};
local v409 = {};
local function v413(v410) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v408 (ref)
    for _, v412 in ipairs(v408) do
        if v412 == v410 then
            return true;
        end;
    end;
    return false;
end;
local function v419(v414) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: l_Workspace_3 (ref), v413 (ref), v409 (ref)
    for _, v416 in ipairs(l_Workspace_3:GetChildren()) do
        if v416:IsA("Model") then
            for _, v418 in ipairs(v416:GetDescendants()) do
                if v418:IsA("BasePart") and v413(v418.Material) then
                    if v414 then
                        if v409[v418] == nil then
                            v409[v418] = v418.Transparency;
                        end;
                        v418.Transparency = 0.5;
                    elseif v409[v418] ~= nil then
                        v418.Transparency = v409[v418];
                    end;
                end;
            end;
        end;
    end;
end;
local _ = l_l_v0_Window_0_Tab_3:CreateKeybind({
    Name = "Xray", 
    CurrentKeybind = "V", 
    HoldToInteract = false, 
    Flag = "Keybind1", 
    Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v407 (ref), v419 (ref)
        v407 = not v407;
        v419(v407);
    end
});
local l_Players_0 = game:GetService("Players");
l_RunService_3 = game:GetService("RunService");
local _ = l_Players_0.LocalPlayer;
local v423 = workspace.CurrentCamera or workspace:WaitForChild("Camera");
local v424 = 70;
local v425 = 70;
local v426 = 20;
local v427 = false;
local _ = l_l_v0_Window_0_Tab_3:CreateKeybind({
    Name = "Zoom", 
    CurrentKeybind = "X", 
    HoldToInteract = true, 
    Flag = "Zoom1", 
    Callback = function(v428) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v427 (ref)
        v427 = v428;
    end
});
local _ = l_l_v0_Window_0_Tab_3:CreateSlider({
    Name = "FOV Changer", 
    Range = {
        50, 
        120
    }, 
    Increment = 1, 
    Suffix = "FOV", 
    CurrentValue = v424, 
    Flag = "Slider1", 
    Callback = function(v430) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v424 (ref)
        v424 = v430;
    end
});
local v432 = getrawmetatable(game);
setreadonly(v432, false);
local l___index_0 = v432.__index;
local l___newindex_0 = v432.__newindex;
v432.__index = newcclosure(function(v435, v436) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v423 (ref), v425 (ref), l___index_0 (ref)
    if v435 == v423 and v436 == "FieldOfView" then
        return v425;
    else
        return l___index_0(v435, v436);
    end;
end);
v432.__newindex = newcclosure(function(v437, v438, v439) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v423 (ref), v427 (ref), l___newindex_0 (ref), v426 (ref), v424 (ref)
    if v437 == v423 and v438 == "FieldOfView" then
        if v427 then
            l___newindex_0(v437, v438, v426);
        else
            l___newindex_0(v437, v438, v424);
        end;
        return;
    else
        return l___newindex_0(v437, v438, v439);
    end;
end);
setreadonly(v432, true);
l_RunService_3.RenderStepped:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v427 (ref), v423 (ref), v426 (ref), v424 (ref)
    if v427 then
        v423.FieldOfView = v426;
    else
        v423.FieldOfView = v424;
    end;
end);
local _ = l_l_v0_Window_0_Tab_3:CreateSection("HitSounds");
local v441 = {
    Default = "rbxassetid://9119561046", 
    Rust = "rbxassetid://5043539486", 
    Gamesense = "rbxassetid://4817809188", 
    Magic = "rbxassetid://182765513", 
    Firework = "rbxassetid://269146157", 
    Lazer = "rbxassetid://360661189", 
    Pop = "rbxassetid://127231141534262", 
    Zap = "rbxassetid://9119594928"
};
local _ = l_l_v0_Window_0_Tab_3:CreateDropdown({
    Name = "Hit sound", 
    Options = {
        "Default", 
        "Rust", 
        "Gamesense", 
        "Magic", 
        "Firework", 
        "Lazer", 
        "Pop", 
        "Zap"
    }, 
    CurrentOption = {
        "Default"
    }, 
    MultipleOptions = false, 
    Flag = "HitSoundDropdown", 
    Callback = function(v442) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v441 (ref)
        local l_v442_0 = v442;
        if type(v442) == "table" then
            l_v442_0 = v442[1];
        end;
        local l_PlayerHitHeadshot_0 = game:GetService("SoundService"):FindFirstChild("PlayerHitHeadshot");
        if l_PlayerHitHeadshot_0 then
            l_PlayerHitHeadshot_0.SoundId = v441[l_v442_0] or v441.Default;
            l_PlayerHitHeadshot_0:Play();
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_3:CreateSlider({
    Name = "Hit sound Volume", 
    Range = {
        0.1, 
        5
    }, 
    Increment = 0.1, 
    Suffix = "Volume", 
    CurrentValue = 1, 
    Flag = "HitSoundVolume", 
    Callback = function(v446) --[[ Line: 0 ]] --[[ Name:  ]]
        local l_PlayerHitHeadshot_1 = game:GetService("SoundService"):FindFirstChild("PlayerHitHeadshot");
        if l_PlayerHitHeadshot_1 then
            l_PlayerHitHeadshot_1.Volume = v446;
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_3:CreateSection("Weapon Trail");
local _ = l_l_v0_Window_0_Tab_3:CreateColorPicker({
    Name = "Arrow Trailcolor", 
    Color = Color3.fromRGB(255, 255, 255), 
    Flag = "ColorPicker1", 
    Callback = function(v450) --[[ Line: 0 ]] --[[ Name:  ]]
        local l_Trail_0 = game:GetService("ReplicatedStorage").Arrow:FindFirstChild("Trail");
        if not l_Trail_0 then
            return;
        else
            l_Trail_0.Color = ColorSequence.new(v450);
            return;
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_3:CreateSlider({
    Name = "Arrow Trail lifespan", 
    Range = {
        0.15, 
        20
    }, 
    Increment = 0.1, 
    Suffix = "s", 
    CurrentValue = 0.15, 
    Flag = "Slider1", 
    Callback = function(v453) --[[ Line: 0 ]] --[[ Name:  ]]
        game:GetService("ReplicatedStorage").Arrow.Trail.Lifetime = v453;
    end
});
l_RunService_3 = game:GetService("RunService");
l_Workspace_3 = game:GetService("Workspace");
local l_Debris_0 = game:GetService("Debris");
ReplicatedStorage = game:GetService("ReplicatedStorage");
BulletTrailEnabled = false;
BulletTrailColor = Color3.fromRGB(255, 255, 255);
BulletTrailThickness = 0.2;
BulletTrailLength = 10;
BulletTrailLifetime = 0.1;
local function v464(v456) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: l_RunService_3 (ref), l_Workspace_3 (ref), l_Debris_0 (ref)
    local v457 = {
        bullet = v456, 
        points = {}
    };
    local v458 = nil;
    v458 = l_RunService_3.RenderStepped:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v456 (ref), v458 (ref), v457 (ref), l_Workspace_3 (ref), l_Debris_0 (ref)
        if not BulletTrailEnabled then
            return;
        elseif not v456 or not v456.Parent then
            v458:Disconnect();
            return;
        else
            local v459 = v456.Position or v456.CFrame.Position;
            table.insert(v457.points, 1, v459);
            if #v457.points > BulletTrailLength then
                table.remove(v457.points);
            end;
            for v460 = 1, #v457.points - 1 do
                local v461 = v457.points[v460];
                local v462 = v457.points[v460 + 1];
                local l_Part_2 = Instance.new("Part");
                l_Part_2.Anchored = true;
                l_Part_2.CanCollide = false;
                l_Part_2.Size = Vector3.new(BulletTrailThickness, BulletTrailThickness, (v461 - v462).Magnitude);
                l_Part_2.CFrame = CFrame.new(v461, v462) * CFrame.new(0, 0, -l_Part_2.Size.Z / 2);
                l_Part_2.Color = BulletTrailColor;
                l_Part_2.Material = Enum.Material.ForceField;
                l_Part_2.Parent = l_Workspace_3;
                l_Debris_0:AddItem(l_Part_2, BulletTrailLifetime);
            end;
            return;
        end;
    end);
end;
l_Workspace_3.DescendantAdded:Connect(function(v465) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v464 (ref)
    if v465.Name == "Bullet" and not v465:IsDescendantOf(ReplicatedStorage) and BulletTrailEnabled then
        v464(v465);
    end;
end);
local _ = l_l_v0_Window_0_Tab_3:CreateToggle({
    Name = "Bullet Trail", 
    CurrentValue = false, 
    Flag = "Toggle1", 
    Callback = function(v466) --[[ Line: 0 ]] --[[ Name:  ]]
        BulletTrailEnabled = v466;
    end
});
local _ = l_l_v0_Window_0_Tab_3:CreateColorPicker({
    Name = "Bullet Trail Color", 
    Color = Color3.fromRGB(255, 255, 255), 
    Flag = "ColorPicker1", 
    Callback = function(v468) --[[ Line: 0 ]] --[[ Name:  ]]
        BulletTrailColor = v468;
    end
});
local _ = l_l_v0_Window_0_Tab_3:CreateSlider({
    Name = "Trail Thickness", 
    Range = {
        0.1, 
        1
    }, 
    Increment = 0.1, 
    Suffix = "Size", 
    CurrentValue = 0.2, 
    Flag = "Slider1", 
    Callback = function(v470) --[[ Line: 0 ]] --[[ Name:  ]]
        BulletTrailThickness = v470;
    end
});
local _ = l_l_v0_Window_0_Tab_3:CreateSlider({
    Name = "Bullet Trail Length", 
    Range = {
        1, 
        25
    }, 
    Increment = 1, 
    Suffix = "Length", 
    CurrentValue = 10, 
    Flag = "Slider2", 
    Callback = function(v472) --[[ Line: 0 ]] --[[ Name:  ]]
        BulletTrailLength = v472;
    end
});
local _ = l_l_v0_Window_0_Tab_3:CreateSlider({
    Name = "Trail LifeTime", 
    Range = {
        0.01, 
        5
    }, 
    Increment = 0.01, 
    Suffix = "LifeTime", 
    CurrentValue = 0.1, 
    Flag = "Slider3", 
    Callback = function(v474) --[[ Line: 0 ]] --[[ Name:  ]]
        BulletTrailLifetime = v474;
    end
});
local _ = l_l_v0_Window_0_Tab_3:CreateSection("Hand and Weapon Chams");
Player = game:GetService("Players").LocalPlayer;
local function v482(v477, v478) --[[ Line: 0 ]] --[[ Name:  ]]
    local l_v477_0 = v477;
    for _, v481 in ipairs(v478) do
        if l_v477_0 then
            l_v477_0 = l_v477_0.FindFirstChild(l_v477_0, v481);
        end;
        if not l_v477_0 then
            return nil;
        end;
    end;
    return l_v477_0;
end;
local v483 = {};
local v484 = {};
local v485 = Color3.fromRGB(255, 255, 255);
local function v489() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v483 (ref), v482 (ref), v484 (ref)
    v483 = {};
    for _, v487 in ipairs({
        {
            "Const", 
            "Ignore", 
            "FPSArms", 
            "RightHand"
        }, 
        {
            "Const", 
            "Ignore", 
            "FPSArms", 
            "RightLowerArm"
        }, 
        {
            "Const", 
            "Ignore", 
            "FPSArms", 
            "LeftLowerArm"
        }, 
        {
            "Const", 
            "Ignore", 
            "FPSArms", 
            "LeftHand"
        }, 
        {
            "Const", 
            "Ignore", 
            "FPSArms", 
            "Fake", 
            "c_RightLowerArm"
        }, 
        {
            "Const", 
            "Ignore", 
            "FPSArms", 
            "Fake", 
            "c_LeftLowerArm"
        }
    }) do
        local v488 = v482(workspace, v487);
        if v488 and v488:IsA("BasePart") then
            table.insert(v483, v488);
            if not v484[v488] then
                v484[v488] = v488.Material;
            end;
        end;
    end;
end;
local function v500(v490) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v483 (ref), v484 (ref)
    if v490 == "Default" then
        for _, v492 in ipairs(v483) do
            if v492 and v492.Parent then
                v492.Material = v484[v492] or Enum.Material.Plastic;
            end;
        end;
        return;
    else
        local l_status_0, l_result_0 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v490 (ref)
            return Enum.Material[v490];
        end);
        if l_status_0 and l_result_0 then
            for _, v496 in ipairs(v483) do
                if v496 and v496.Parent then
                    v496.Material = l_result_0;
                end;
            end;
        else
            for _, v498 in ipairs(v483) do
                do
                    local l_v498_0 = v498;
                    if l_v498_0 and l_v498_0.Parent then
                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                            -- upvalues: l_v498_0 (ref), v490 (ref)
                            l_v498_0.MaterialVariant = v490;
                        end);
                    end;
                end;
            end;
            warn("'" .. tostring(v490) .. "' is not a valid Enum.Material; tried MaterialVariant instead.");
        end;
        return;
    end;
end;
v489();
Player.CharacterAdded:Connect(function(v501) --[[ Line: 0 ]] --[[ Name:  ]]
    local v502 = v501:WaitForChild("Const", 5);
    if v502 then
        v502:WaitForChild("Ignore", 5);
    end;
end);
local l_l_l_v0_Window_0_Tab_3_Dropdown_1 = l_l_v0_Window_0_Tab_3:CreateDropdown({
    Name = "Hand", 
    Options = {
        "Default", 
        "ForceField", 
        "Neon", 
        "Asphalt"
    }, 
    CurrentOption = {
        "Default"
    }, 
    MultipleOptions = false, 
    Flag = "Dropdown_HandMaterial", 
    Callback = function(v503) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v489 (ref), v500 (ref)
        local l_v503_0 = v503;
        if type(l_v503_0) == "table" then
            l_v503_0 = l_v503_0[1];
        end;
        v489();
        v500(l_v503_0);
    end
});
local l_l_l_v0_Window_0_Tab_3_ColorPicker_2 = l_l_v0_Window_0_Tab_3:CreateColorPicker({
    Name = "Hand cham color", 
    Color = v485, 
    Flag = "ColorPicker_Hand", 
    Callback = function(v506) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v485 (ref), v483 (ref)
        v485 = v506;
        for _, v508 in ipairs(v483) do
            if v508 and v508.Parent then
                v508.Color = v506;
            end;
        end;
    end
});
task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v489 (ref), v483 (ref), v485 (ref)
    while true do
        v489();
        for _, v511 in ipairs(v483) do
            if v511 and v511.Parent then
                v511.Color = v485;
            end;
        end;
        task.wait(0.1);
    end;
end);
Player = game:GetService("Players").LocalPlayer;
ReplicatedStorage = game:GetService("ReplicatedStorage");
local l_HandModels_0 = ReplicatedStorage:WaitForChild("HandModels");
local function v520(v513) --[[ Line: 0 ]] --[[ Name:  ]]
    local v514 = {};
    local v515 = {};
    local function v516(v517) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v514 (ref), v515 (ref), v516 (ref)
        if v517:IsA("BasePart") then
            table.insert(v514, v517);
            if not v515[v517] then
                v515[v517] = v517.Material;
            end;
        end;
        for _, v519 in ipairs(v517:GetChildren()) do
            v516(v519);
        end;
    end;
    v516(v513);
    return v514, v515;
end;
local v521 = {};
local v522 = {};
local function v529() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v521 (ref), l_HandModels_0 (ref), v520 (ref), v522 (ref)
    v521 = {};
    for _, v524 in ipairs(l_HandModels_0:GetChildren()) do
        local v525, v526 = v520(v524);
        v521[v524] = v525;
        for v527, v528 in pairs(v526) do
            v522[v527] = v528;
        end;
    end;
end;
local function v546(v530) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v521 (ref), v522 (ref)
    if v530 == "Default" then
        for _, v532 in pairs(v521) do
            for _, v534 in ipairs(v532) do
                if v534 and v534.Parent then
                    v534.Material = v522[v534] or Enum.Material.Plastic;
                end;
            end;
        end;
        return;
    else
        local l_status_1, l_result_1 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v530 (ref)
            return Enum.Material[v530];
        end);
        if l_status_1 and l_result_1 then
            for _, v538 in pairs(v521) do
                for _, v540 in ipairs(v538) do
                    if v540 and v540.Parent then
                        v540.Material = l_result_1;
                    end;
                end;
            end;
        else
            for _, v542 in pairs(v521) do
                for _, v544 in ipairs(v542) do
                    do
                        local l_v544_0 = v544;
                        if l_v544_0 and l_v544_0.Parent then
                            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                -- upvalues: l_v544_0 (ref), v530 (ref)
                                l_v544_0.MaterialVariant = v530;
                            end);
                        end;
                    end;
                end;
            end;
            warn(("'%s' is not a valid Enum.Material; tried MaterialVariant instead."):format(tostring(v530)));
        end;
        return;
    end;
end;
local function v552(v547) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v521 (ref)
    for _, v549 in pairs(v521) do
        for _, v551 in ipairs(v549) do
            if v551 and v551.Parent then
                v551.Color = v547;
            end;
        end;
    end;
end;
v529();
l_HandModels_0.ChildAdded:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v529 (ref), v546 (ref), l_l_l_v0_Window_0_Tab_3_Dropdown_1 (ref), v552 (ref), l_l_l_v0_Window_0_Tab_3_ColorPicker_2 (ref)
    task.wait(0.5);
    v529();
    v546(l_l_l_v0_Window_0_Tab_3_Dropdown_1.CurrentOption[1]);
    v552(l_l_l_v0_Window_0_Tab_3_ColorPicker_2.Color);
end);
local _ = l_l_v0_Window_0_Tab_3:CreateDropdown({
    Name = "Weapon Chams", 
    Options = {
        "Default", 
        "ForceField", 
        "Neon", 
        "Asphalt"
    }, 
    CurrentOption = {
        "Default"
    }, 
    MultipleOptions = false, 
    Flag = "Dropdown_WeaponMaterial", 
    Callback = function(v553) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v529 (ref), v546 (ref)
        local l_v553_0 = v553;
        if type(l_v553_0) == "table" then
            l_v553_0 = l_v553_0[1];
        end;
        v529();
        v546(l_v553_0);
    end
});
local _ = l_l_v0_Window_0_Tab_3:CreateColorPicker({
    Name = "Weapon Cham Color", 
    Color = Color3.fromRGB(255, 255, 255), 
    Flag = "ColorPicker_Weapon", 
    Callback = function(v556) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v552 (ref)
        v552(v556);
    end
});
local l_l_v0_Window_0_Tab_4 = l_v0_Window_0:CreateTab("Misc", nil);
local _ = l_l_v0_Window_0_Tab_4:CreateSection("UI Settings");
local l_UserInputService_3 = game:GetService("UserInputService");
FreeCamEnabled = false;
PITCH_LIMIT = math.rad(80);
local v561 = nil;
local v562 = 0;
local v563 = 0;
local v564 = nil;
local v565 = nil;
local v566 = {
    [Enum.KeyCode.W] = Vector3.new(0, 0, -1), 
    [Enum.KeyCode.S] = Vector3.new(0, 0, 1), 
    [Enum.KeyCode.A] = Vector3.new(-1, 0, 0), 
    [Enum.KeyCode.D] = Vector3.new(1, 0, 0), 
    [Enum.KeyCode.Space] = Vector3.new(0, 1, 0), 
    [Enum.KeyCode.LeftShift] = Vector3.new(0, -1, 0)
};
local v567 = {};
FreeCamSpeed = 150;
local _ = l_l_v0_Window_0_Tab_4:CreateKeybind({
    Name = "Free Cam", 
    CurrentKeybind = "Z", 
    HoldToInteract = false, 
    Flag = "Keybind1", 
    Callback = function(_) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: l_RunService_3 (ref), l_CurrentCamera_2 (ref), v564 (ref), v565 (ref), v561 (ref), v562 (ref), v563 (ref), l_UserInputService_3 (ref), v566 (ref), v567 (ref)
        if FreeCamEnabled then
            FreeCamEnabled = false;
            l_RunService_3:UnbindFromRenderStep("FreeCam");
            l_CurrentCamera_2.CameraType = Enum.CameraType.Custom;
            local l_Character_0 = Player.Character;
            if l_Character_0 then
                local l_Humanoid_0 = l_Character_0:FindFirstChildOfClass("Humanoid");
                if l_Humanoid_0 then
                    if v564 then
                        l_Humanoid_0.WalkSpeed = v564;
                    end;
                    if v565 then
                        l_Humanoid_0.JumpPower = v565;
                    end;
                end;
            end;
        else
            FreeCamEnabled = true;
            local l_CFrame_0 = l_CurrentCamera_2.CFrame;
            v561 = l_CFrame_0.Position;
            local l_LookVector_0 = l_CFrame_0.LookVector;
            v562 = math.asin(-l_LookVector_0.Y);
            v563 = math.atan2(-l_LookVector_0.X, -l_LookVector_0.Z);
            l_CurrentCamera_2.CameraType = Enum.CameraType.Scriptable;
            local l_Character_1 = Player.Character;
            if l_Character_1 then
                local l_Humanoid_1 = l_Character_1:FindFirstChildOfClass("Humanoid");
                if l_Humanoid_1 then
                    v564 = l_Humanoid_1.WalkSpeed;
                    v565 = l_Humanoid_1.JumpPower;
                    l_Humanoid_1.WalkSpeed = 0;
                    l_Humanoid_1.JumpPower = 0;
                end;
            end;
            l_RunService_3:BindToRenderStep("FreeCam", Enum.RenderPriority.Camera.Value + 1, function(v575) --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: l_UserInputService_3 (ref), v563 (ref), v562 (ref), v566 (ref), v567 (ref), v561 (ref), l_CurrentCamera_2 (ref)
                local l_l_UserInputService_3_MouseDelta_0 = l_UserInputService_3:GetMouseDelta();
                v563 = v563 - l_l_UserInputService_3_MouseDelta_0.X * 0.002;
                v562 = math.clamp(v562 - l_l_UserInputService_3_MouseDelta_0.Y * 0.002, -PITCH_LIMIT, PITCH_LIMIT);
                local v577 = CFrame.Angles(0, v563, 0) * CFrame.Angles(v562, 0, 0);
                local l_zero_0 = Vector3.zero;
                for v579, v580 in pairs(v566) do
                    if v567[v579] then
                        l_zero_0 = l_zero_0 + v580;
                    end;
                end;
                if l_zero_0.Magnitude > 0 then
                    l_zero_0 = v577:VectorToWorldSpace(l_zero_0).Unit;
                    v561 = v561 + l_zero_0 * FreeCamSpeed * v575;
                end;
                l_CurrentCamera_2.CFrame = CFrame.new(v561) * v577;
            end);
        end;
    end
});
local _ = l_l_v0_Window_0_Tab_4:CreateSlider({
    Name = "FreeCam Speed", 
    Range = {
        1, 
        500
    }, 
    Increment = 1, 
    CurrentValue = 150, 
    Flag = "Slider1", 
    Callback = function(v582) --[[ Line: 0 ]] --[[ Name:  ]]
        FreeCamSpeed = v582;
    end
});
l_UserInputService_3.InputBegan:Connect(function(v584, v585) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v566 (ref), v567 (ref)
    if v585 then
        return;
    else
        if v566[v584.KeyCode] then
            v567[v584.KeyCode] = true;
        end;
        return;
    end;
end);
l_UserInputService_3.InputEnded:Connect(function(v586) --[[ Line: 0 ]] --[[ Name:  ]]
    -- upvalues: v566 (ref), v567 (ref)
    if v566[v586.KeyCode] then
        v567[v586.KeyCode] = false;
    end;
end);
local _ = l_l_v0_Window_0_Tab_4:CreateButton({
    Name = "Close Radium", 
    Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v0 (ref)
        v0:Destroy();
    end
});
return G2L["1"];