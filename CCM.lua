local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

Rayfield:Notify({
    Title = "CCM Toolkit Loaded",
    Content = "Welcome to Custom Crystal Menu",
    Duration = 4,
    Image = "shield-alert"
})

local Window = Rayfield:CreateWindow({
    Name = "Custom Crystal Menu (CCM)",
    Theme = "AmberGlow",
    ToggleUIKeybind = Enum.KeyCode.N,
    KeySystem = true,
    KeySettings = {
        Title = "CCM | Keys",
        Subtitle = "Enter your key!",
        Note = "Keys can be used multiple times!",
        FileName = "KeysCCM",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"1X1", "2X2", "3X3", "BasicCCMKey1"}
    }
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function parseVector(str)
    local x,y,z = string.match(str or "", "(-?%d+)[, ]*(-?%d+)[, ]*(-?%d+)")
    if x and y and z then
        return Vector3.new(tonumber(x), tonumber(y), tonumber(z))
    end
end

local createdParts = {}

-- Tab 1: Build & Player Mods
local Tab1 = Window:CreateTab("Builder & Player")

Tab1:CreateSection("Part Spawner")
local spawnPos = "0,5,0"
local spawnCount = 1
local spawnSize = "4,1,4"

Tab1:CreateInput({Name = "Position (X,Y,Z)", PlaceholderText = "0,5,0", Callback = function(v) spawnPos = v end})
Tab1:CreateInput({Name = "Count", PlaceholderText = "1", Callback = function(v) spawnCount = tonumber(v) or 1 end})
Tab1:CreateInput({Name = "Size (X,Y,Z)", PlaceholderText = "4,1,4", Callback = function(v) spawnSize = v end})

Tab1:CreateButton({
    Name = "Spawn Parts",
    Callback = function()
        local pos = parseVector(spawnPos)
        local size = parseVector(spawnSize)
        if pos and size then
            for i = 1, spawnCount do
                local p = Instance.new("Part")
                p.Size = size
                p.Position = pos + Vector3.new(0, (i-1) * (size.Y + 0.5), 0)
                p.Anchored = true
                p.Material = Enum.Material.Neon
                p.BrickColor = BrickColor.Random()
                p.Parent = workspace
                table.insert(createdParts, p)
            end
            Rayfield:Notify({Title = "Spawned", Content = spawnCount .. " parts created", Duration = 2, Image = "shield-alert"})
        else
            Rayfield:Notify({Title = "Error", Content = "Invalid input format", Duration = 2, Image = "shield-alert"})
        end
    end
})

Tab1:CreateButton({
    Name = "Clear Parts",
    Callback = function()
        for _, p in ipairs(createdParts) do p:Destroy() end
        createdParts = {}
        Rayfield:Notify({Title = "Cleared", Content = "All spawned parts removed", Duration = 2, Image = "shield-alert"})
    end
})

Tab1:CreateSection("Player Movement")
local speedSlider = Tab1:CreateSlider({Name = "WalkSpeed", Range = {0, 3000}, Increment = 1, CurrentValue = 16, Callback = function(v)
    local hum = getHumanoid()
    if hum then hum.WalkSpeed = v end
end})
local jumpSlider = Tab1:CreateSlider({Name = "JumpPower", Range = {0, 500}, Increment = 1, CurrentValue = 50, Callback = function(v)
    local hum = getHumanoid()
    if hum then hum.JumpPower = v end
end})

Tab1:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(state)
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if state then
            local BodyGyro = Instance.new("BodyGyro", root)
            BodyGyro.Name = "FlyBG"
            BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            BodyGyro.P = 9e4
            BodyGyro.CFrame = root.CFrame
            local BodyVelocity = Instance.new("BodyVelocity", root)
            BodyVelocity.Name = "FlyBV"
            BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            local UIS = game:GetService("UserInputService")
            local speed = 100
            local move = {W = false, A = false, S = false, D = false, Space = false, LeftShift = false}
            local function updateVelocity()
                local vel = Vector3.new()
                if move.W then vel = vel + workspace.CurrentCamera.CFrame.LookVector end
                if move.S then vel = vel - workspace.CurrentCamera.CFrame.LookVector end
                if move.A then vel = vel - workspace.CurrentCamera.CFrame.RightVector end
                if move.D then vel = vel + workspace.CurrentCamera.CFrame.RightVector end
                if move.Space then vel = vel + Vector3.new(0, 1, 0) end
                if move.LeftShift then vel = vel - Vector3.new(0, 1, 0) end
                BodyVelocity.Velocity = vel.Unit * speed
                if vel.Magnitude == 0 then BodyVelocity.Velocity = Vector3.new(0, 0, 0) end
            end
            local conn1 = UIS.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.W then move.W = true updateVelocity() end
                if input.KeyCode == Enum.KeyCode.A then move.A = true updateVelocity() end
                if input.KeyCode == Enum.KeyCode.S then move.S = true updateVelocity() end
                if input.KeyCode == Enum.KeyCode.D then move.D = true updateVelocity() end
                if input.KeyCode == Enum.KeyCode.Space then move.Space = true updateVelocity() end
                if input.KeyCode == Enum.KeyCode.LeftShift then move.LeftShift = true updateVelocity() end
            end)
            local conn2 = UIS.InputEnded:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.W then move.W = false updateVelocity() end
                if input.KeyCode == Enum.KeyCode.A then move.A = false updateVelocity() end
                if input.KeyCode == Enum.KeyCode.S then move.S = false updateVelocity() end
                if input.KeyCode == Enum.KeyCode.D then move.D = false updateVelocity() end
                if input.KeyCode == Enum.KeyCode.Space then move.Space = false updateVelocity() end
                if input.KeyCode == Enum.KeyCode.LeftShift then move.LeftShift = false updateVelocity() end
            end)
            hum.PlatformStand = true
            flyConnections = {conn1, conn2}
        else
            if char:FindFirstChild("HumanoidRootPart"):FindFirstChild("FlyBG") then
                char.HumanoidRootPart.FlyBG:Destroy()
            end
            if char:FindFirstChild("HumanoidRootPart"):FindFirstChild("FlyBV") then
                char.HumanoidRootPart.FlyBV:Destroy()
            end
            local hum = getHumanoid()
            if hum then hum.PlatformStand = false end
            if flyConnections then
                for _, con in pairs(flyConnections) do
                    if con then con:Disconnect() end
                end
            end
        end
    end
})

-- Tab 2: Fun & Visual FX
local Tab2 = Window:CreateTab("Fun & Visual")

Tab2:CreateButton({Name = "Rainbow Skin", Callback = function()
    local char = LocalPlayer.Character
    if char then
        task.spawn(function()
            while true do
                task.wait(0.1)
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.Color = Color3.fromHSV((tick() % 5) / 5, 1, 1)
                    end
                end
            end
        end)
    end
end})

Tab2:CreateToggle({Name = "Spin Character", CurrentValue = false, Callback = function(v)
    _G.spin = v
end})
RunService.RenderStepped:Connect(function()
    if _G.spin then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(5), 0) end
    end
end)

Tab2:CreateButton({Name = "Sparkles", Callback = function()
    local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if head then
        local emitter = Instance.new("ParticleEmitter", head)
        emitter.Texture = "rbxassetid://241865958"
        emitter.Rate = 100
        emitter.Lifetime = NumberRange.new(1)
        emitter.Speed = NumberRange.new(0, 1)
        delay(3, function() emitter:Destroy() end)
    end
end})

Tab2:CreateSection("Emotes")
local emotes = {
    {Name = "Wave", Id = 455703516},
    {Name = "Cheer", Id = 507766388},
    {Name = "Point", Id = 507777826},
    {Name = "Dance", Id = 16670852124},
    {Name = "Sit", Id = 507763666},
}

local function playAnim(id)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. id
        local track = animator:LoadAnimation(anim)
        track:Play()
    end
end

for _, emote in pairs(emotes) do
    Tab2:CreateButton({
        Name = emote.Name,
        Callback = function() playAnim(emote.Id) end
    })
end

Tab2:CreateSection("Visual Effects")
Tab2:CreateToggle({Name = "Night Vision", CurrentValue = false, Callback = function(v)
    if v then
        Lighting.Brightness = 6
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    else
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1, 1, 1)
    end
end})

Tab2:CreateSlider({Name = "Brightness", Range = {0, 10}, Increment = 0.1, CurrentValue = 2, Callback = function(v)
    Lighting.Brightness = v
end})

Tab2:CreateDropdown({Name = "Theme", Options = {"AmberGlow", "Midnight", "Light", "Serenity", "Ocean"}, CurrentOption = "AmberGlow", Callback = function(v)
    Rayfield:ChangeTheme(v)
end})

Tab2:CreateToggle({Name = "Trails", CurrentValue = false, Callback = function(v)
    local char = LocalPlayer.Character
    if char then
        for _, limb in ipairs(char:GetChildren()) do
            if limb:IsA("BasePart") then
                if v then
                    local a0 = Instance.new("Attachment", limb)
                    local a1 = Instance.new("Attachment", limb)
                    local trail = Instance.new("Trail", limb)
                    trail.Attachment0 = a0
                    trail.Attachment1 = a1
                    trail.Lifetime = 0.5
                    trail.Transparency = NumberSequence.new(0.5)
                else
                    for _, c in ipairs(limb:GetChildren()) do
                        if c:IsA("Trail") or c:IsA("Attachment") then
                            c:Destroy()
                        end
                    end
                end
            end
        end
    end
end})

-- Tab 3: Utilities & Teleports
local Tab3 = Window:CreateTab("Utilities & Teleports")

Tab3:CreateSection("Teleportation")
local tpInput = ""
Tab3:CreateInput({Name = "Teleport Position (X,Y,Z)", PlaceholderText = "0,10,0", Callback = function(v) tpInput = v end})
Tab3:CreateButton({
    Name = "Teleport",
    Callback = function()
        local pos = parseVector(tpInput)
        local char = LocalPlayer.Character
        if pos and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(pos)
            Rayfield:Notify({Title = "Teleported", Content = "Teleported to " .. tpInput, Duration = 3, Image = "shield-alert"})
        else
            Rayfield:Notify({Title = "Error", Content = "Invalid teleport position", Duration = 3, Image = "shield-alert"})
        end
    end
})

Tab3:CreateSection("Misc Tools")

Tab3:CreateButton({Name = "Clear Workspace Parts", Callback = function()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Part") and not table.find(createdParts, obj) then
            obj:Destroy()
        end
    end
    Rayfield:Notify({Title = "Workspace Cleared", Content = "All workspace parts removed", Duration = 3, Image = "shield-alert"})
end})

Tab3:CreateButton({Name = "Rejoin Game", Callback = function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end})

Tab3:CreateButton({Name = "Force Reset Character", Callback = function()
    LocalPlayer.Character:BreakJoints()
end})

Tab3:CreateButton({Name = "Toggle Full Bright", Callback = function()
    if Lighting.Brightness < 20 then
        Lighting.Brightness = 20
        Lighting.GlobalShadows = false
        Rayfield:Notify({Title = "FullBright ON", Content = "Extreme brightness enabled", Duration = 3, Image = "shield-alert"})
    else
        Lighting.Brightness = 2
        Lighting.GlobalShadows = true
        Rayfield:Notify({Title = "FullBright OFF", Content = "Brightness restored", Duration = 3, Image = "shield-alert"})
    end
end})

Tab3:CreateToggle({Name = "Anti AFK", CurrentValue = false, Callback = function(v)
    if v then
        local vu = game:GetService("VirtualUser")
        _G.AFKcon = RunService.Stepped:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    else
        if _G.AFKcon then _G.AFKcon:Disconnect() _G.AFKcon = nil end
    end
end})

Tab3:CreateSection("Game-Specific Teleports")

local strongBattlegroundsTPs = {
    {"Spawn", Vector3.new(0,5,0)},
    {"Shop", Vector3.new(250,10,-300)},
    {"Arena", Vector3.new(500,20,100)},
    {"SafeZone", Vector3.new(-100,5,-100)},
    {"Secret Base", Vector3.new(1000,50,1000)},
}

for _, tp in pairs(strongBattlegroundsTPs) do
    Tab3:CreateButton({
        Name = "Teleport to " .. tp[1],
        Callback = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(tp[2])
                Rayfield:Notify({Title = "Teleported", Content = "Teleported to " .. tp[1], Duration = 3, Image = "shield-alert"})
            end
        end
    })
end
