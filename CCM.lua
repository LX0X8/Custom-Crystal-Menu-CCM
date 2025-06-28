-- Custom Crystal Menu (CCM) v2 – Enhanced with Battlegrounds Tab
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local Character = LocalPlayer.Character
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local HRP = Character:FindFirstChild("HumanoidRootPart")

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- THEME
local Window = Rayfield:CreateWindow({
    Name = "Custom Crystal Menu (CCM)",
    Theme = {
        Accent = Color3.fromRGB(163, 73, 164),
        WindowBackground = Color3.fromRGB(15, 10, 24),
        TabBackground = Color3.fromRGB(20, 15, 35),
        Toggle = Color3.fromRGB(163, 73, 164),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
    },
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

-- UTIL FUNCTIONS
local function notify(title, content)
    Rayfield:Notify({Title = title, Content = content, Duration = 3, Image = "shield-alert"})
end

local function getPlayerByName(name)
    name = name:lower()
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl.Name:lower():find(name) then return pl end
    end
    return nil
end

-- ESP SYSTEM
local espEnabled = false
local espHighlights = {}
local function createHighlight(plr)
    if espHighlights[plr] then return end
    local char = plr.Character
    if not char then return end
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(163, 73, 164)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.Adornee = char
    hl.Parent = char
    espHighlights[plr] = hl
end
local function clearAllHighlights()
    for plr, hl in pairs(espHighlights) do
        if hl then hl:Destroy() end
    end
    espHighlights = {}
end
Players.PlayerRemoving:Connect(function(plr) if espHighlights[plr] then espHighlights[plr]:Destroy() end end)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.1)
        if espEnabled then createHighlight(plr) end
    end)
end)

-- TAB 1: Player & Builder
local tab1 = Window:CreateTab("Player & Builder")
tab1:CreateSection("Movement & Mods")
tab1:CreateSlider({Name = "WalkSpeed", Range = {16, 3000}, Increment = 1, CurrentValue = 16, Flag = "WS", Callback = function(v) Humanoid.WalkSpeed = v end})
tab1:CreateSlider({Name = "JumpPower", Range = {50, 1000}, Increment = 1, CurrentValue = 50, Flag = "JP", Callback = function(v) Humanoid.JumpPower = v end})
local infJumpConn, noclipConn
tab1:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(state)
    if state then
        infJumpConn = UIS.JumpRequest:Connect(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    else
        if infJumpConn then infJumpConn:Disconnect() end
    end
end})
tab1:CreateToggle({Name = "No Clip", CurrentValue = false, Callback = function(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            for _,p in ipairs(Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end)
        notify("No Clip", "Enabled")
    else
        if noclipConn then noclipConn:Disconnect() end
        notify("No Clip", "Disabled")
    end
end})
tab1:CreateButton({Name = "Reset Character", Callback = function() Humanoid.Health = 0 end})
tab1:CreateButton({Name = "Teleport to Spawn", Callback = function() HRP.CFrame = CFrame.new(0, 5, 0) end})

tab1:CreateSection("Builder")
local spawnCount, spawnPos, spawnSize = 1, "0,5,0", "4,1,4"
local parts = {}
tab1:CreateInput({Name = "Position (X,Y,Z)", PlaceholderText = "0,5,0", Callback = function(v) spawnPos = v end})
tab1:CreateInput({Name = "Count", PlaceholderText = "1", Callback = function(v) spawnCount = tonumber(v) or 1 end})
tab1:CreateInput({Name = "Size (X,Y,Z)", PlaceholderText = "4,1,4", Callback = function(v) spawnSize = v end})
tab1:CreateButton({Name = "Spawn Parts", Callback = function()
    local x,y,z = spawnPos:match("(-?%d+),?(%-?%d+),?(%-?%d+)")
    local sx,sy,sz = spawnSize:match("(-?%d+),?(%-?%d+),?(%-?%d+)")
    x,y,z,sx,sy,sz = tonumber(x),tonumber(y),tonumber(z),tonumber(sx),tonumber(sy),tonumber(sz)
    if x and sx then
        for i=1,spawnCount do
            local p = Instance.new("Part", workspace)
            p.Size = Vector3.new(sx,sy,sz)
            p.Position = Vector3.new(x, y + (i-1)*(sy+0.5), z)
            p.Anchored = true
            p.BrickColor = BrickColor.Random()
            p.Material = Enum.Material.Neon
            table.insert(parts, p)
        end
        notify("Builder", spawnCount.." parts spawned")
    else
        notify("Builder", "Invalid input format")
    end
end})
tab1:CreateButton({Name = "Clear Parts", Callback = function()
    for _,p in ipairs(parts) do if p and p.Parent then p:Destroy() end end
    parts = {}
    notify("Builder", "Cleared spawned parts")
end})

-- TAB 2: Fun & Visual
local tab2 = Window:CreateTab("Fun & Visual")
tab2:CreateButton({Name = "Rainbow Skin", Callback = function()
    task.spawn(function()
        while task.wait(0.1) and Character.Parent do
            for _,v in ipairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Color = Color3.fromHSV((tick()%5)/5,1,1)
                end
            end
        end
    end)
end})
tab2:CreateButton({Name = "ForceField", Callback = function() return Instance.new("ForceField", Character) end})
tab2:CreateButton({Name = "Glow Effect", Callback = function()
    for _,v in ipairs(Character:GetDescendants()) do if v:IsA("BasePart") then Instance.new("PointLight", v).Brightness = 5 end end
end})
tab2:CreateButton({Name = "Headlight", Callback = function()
    if HRP then Instance.new("SpotLight", HRP).Angle, instance.Range = 90, 30 end
end})
local autoSpinConn
tab2:CreateToggle({Name = "Auto Spin", CurrentValue = false, Callback = function(state)
    if state then
        autoSpinConn = RunService.RenderStepped:Connect(function()
            HRP.CFrame = HRP.CFrame * CFrame.Angles(0, math.rad(5), 0)
        end); notify("Visual", "Auto Spin enabled")
    else
        if autoSpinConn then autoSpinConn:Disconnect() end; notify("Visual", "Auto Spin disabled")
    end
end})
local nightVisionConn
tab2:CreateToggle({Name = "Night Vision", CurrentValue = false, Callback = function(state)
    if state then 
        Lighting.Brightness, Lighting.Ambient = 6, Color3.new(0.5,0.5,0.5)
    else
        Lighting.Brightness, Lighting.Ambient = 2, Color3.new(1,1,1)
    end
    notify("Visual", "Night Vision "..(state and "enabled" or "disabled"))
end})
tab2:CreateToggle({Name = "ESP", CurrentValue = false, Callback = function(state)
    espEnabled = state
    if state then
        for _,pl in ipairs(Players:GetPlayers()) do if pl~=LocalPlayer then createHighlight(pl) end end
        notify("Visual", "ESP enabled")
    else
        clearAllHighlights(); notify("Visual", "ESP disabled")
    end
end})
tab2:CreateButton({Name = "Spawn Sparkles", Callback = function()
    local head = Character:FindFirstChild("Head")
    if head then
        local em = Instance.new("ParticleEmitter", head)
        em.Texture, em.Rate = "rbxassetid://241865958", 100
        em.Lifetime, em.Speed = NumberRange.new(1), NumberRange.new(0,1)
        task.delay(3, function() em:Destroy() end)
    end
end})
tab2:CreateButton({Name = "Fireworks", Callback = function()
    local p = Instance.new("Part", workspace)
    p.Anchored, p.CanCollide = true, false
    p.Position = HRP.Position + Vector3.new(0,5,0)
    local em = Instance.new("ParticleEmitter", p)
    em.Texture, em.Rate = "rbxassetid://243660364", 200
    em.Lifetime, em.Speed = NumberRange.new(1), NumberRange.new(10,20)
    task.delay(5, function() p:Destroy() end)
end})
tab2:CreateButton({Name = "Rainbow Trails", Callback = function()
    for _,limb in ipairs(Character:GetChildren()) do
        if limb:IsA("BasePart") then
            local a0,a1 = Instance.new("Attachment", limb), Instance.new("Attachment", limb)
            local trail = Instance.new("Trail", limb)
            trail.Attachment0,trail.Attachment1,trail.Lifetime,trail.Color = a0, a1, 0.5, ColorSequence.new{{0,Color3.fromHSV(0,1,1)},{1,Color3.fromHSV(1,1,1)}}
            trail.Name = "CCMRainbowTrail"
        end
    end
end})
tab2:CreateButton({Name = "Remove Trails", Callback = function()
    for _,limb in ipairs(Character:GetChildren()) do for _,c in ipairs(limb:GetChildren()) do
        if c:IsA("Trail") and c.Name=="CCMRainbowTrail" then c:Destroy() end
        if c:IsA("Attachment") then c:Destroy() end
    end end
end})

-- TAB 3: Utilities
local tab3 = Window:CreateTab("Utilities")
tab3:CreateButton({Name = "Rejoin Server", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end})
tab3:CreateButton({Name = "Server Hop", Callback = function() TeleportService:Teleport(game.PlaceId) end})
tab3:CreateButton({Name = "Low Graphics", Callback = function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end end
    notify("Utilities", "Low graphics enabled")
end})
tab3:CreateButton({Name = "Clear Workspace", Callback = function()
    for _,o in ipairs(workspace:GetChildren()) do
        if o:IsA("BasePart") and not o.Anchored then o:Destroy() end
    end
    notify("Utilities", "Workspace cleared")
end})
tab3:CreateButton({Name = "Force Give Arkenstone", Callback = function()
    local found
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer then
            local item = pl.Backpack:FindFirstChild("The Arkenstone") or pl.Character:FindFirstChild("The Arkenstone")
            if item then found = item break end
        end
    end
    if found then
        found:Clone().Parent = LocalPlayer.Backpack
        notify("Utilities", "Arkenstone obtained")
    else
        notify("Utilities", "No Arkenstone found")
    end
end})
tab3:CreateButton({Name = "Fling Self", Callback = function()
    local bv = Instance.new("BodyVelocity", HRP)
    bv.Velocity, bv.MaxForce = Vector3.new(9999,9999,9999), Vector3.new(9999,9999,9999)
    task.wait(0.5); bv:Destroy()
end})
tab3:CreateButton({Name = "Teleport to Lobby", Callback = function() HRP.CFrame = CFrame.new(0,50,0) end})
tab3:CreateButton({Name = "Infinite Yield", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end})

-- TAB 4: Fun
local tab4 = Window:CreateTab("Fun")
tab4:CreateButton({Name = "Spin Character", Callback = function()
    local conn = RunService.RenderStepped:Connect(function() HRP.CFrame = HRP.CFrame * CFrame.Angles(0, math.rad(10), 0) end)
    task.delay(5, function() conn:Disconnect() end)
end})
tab4:CreateButton({Name = "Ragdoll", Callback = function()
    for _,limb in pairs(Character:GetDescendants()) do
        if limb:IsA("Motor6D") then
            local s = Instance.new("BallSocketConstraint", limb.Part0)
            s.Attachment0, s.Attachment1 = Instance.new("Attachment", limb.Part0), Instance.new("Attachment", limb.Part1)
            limb:Destroy()
        end
    end
end})
tab4:CreateButton({Name = "Sound Spam", Callback = function()
    for i=1,10 do
        local s = Instance.new("Sound", HRP)
        s.SoundId = "rbxassetid://183858"
        s:Play()
    end
end})

-- TAB 5: Troll
local tab5 = Window:CreateTab("Troll")
tab5:CreateButton({Name = "Fling Others", Callback = function()
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local bv = Instance.new("BodyVelocity", pl.Character.HumanoidRootPart)
            bv.Velocity, bv.MaxForce = Vector3.new(0,1000,0), Vector3.new(1e9,1e9,1e9)
            game:GetService("Debris"):AddItem(bv,1)
        end
    end
end})
tab5:CreateButton({Name = "Walk Upside-Down", Callback = function() HRP.CFrame = HRP.CFrame * CFrame.Angles(math.pi,0,0) end})
tab5:CreateButton({Name = "Headless Mode", Callback = function() if Character:FindFirstChild("Head") then Character.Head:Destroy() end end})

-- TAB 6: Battlegrounds
local tab6 = Window:CreateTab("Battlegrounds")
local farming, upgrading, buying, rebirthing = false, false, false, false

tab6:CreateToggle({Name = "Auto-Farm Gold", CurrentValue = false, Callback = function(v)
    farming = v; notify("Battlegrounds", "Auto-Farm "..(v and "ON" or "OFF"))
    spawn(function()
        while farming do
            task.wait(1)
            local rem = ReplicatedStorage:FindFirstChild("CollectCoin")
            if rem then pcall(function() rem:FireServer() end) end
        end
    end)
end})

tab6:CreateToggle({Name = "Auto-Upgrade Hero", CurrentValue = false, Callback = function(v)
    upgrading = v; notify("Battlegrounds", "Auto-Upgrade "..(v and "ON" or "OFF"))
    spawn(function()
        while upgrading do
            task.wait(5)
            local rem = ReplicatedStorage:FindFirstChild("UpgradeHero")
            if rem then pcall(function() rem:FireServer() end) end
        end
    end)
end})

tab6:CreateButton({Name = "Teleport to Merchant", Callback = function()
    local shop = workspace:FindFirstChild("Merchant") or workspace:FindFirstChild("Shop")
    if shop and shop.PrimaryPart then
        HRP.CFrame = shop.PrimaryPart.CFrame + Vector3.new(0,3,0)
        notify("Battlegrounds", "Teleported to merchant")
    else
        notify("Battlegrounds", "Merchant not found")
    end
end})

tab6:CreateToggle({Name = "Auto-Buy Items", CurrentValue = false, Callback = function(v)
    buying = v; notify("Battlegrounds", "Auto-Buy "..(v and "ON" or "OFF"))
    spawn(function()
        while buying do
            task.wait(2)
            local rem = ReplicatedStorage:FindFirstChild("BuyBestItem")
            if rem then pcall(function() rem:FireServer() end) end
        end
    end)
end})

tab6:CreateToggle({Name = "Auto-Rebirth", CurrentValue = false, Callback = function(v)
    rebirthing = v; notify("Battlegrounds", "Auto-Rebirth "..(v and "ON" or "OFF"))
    spawn(function()
        while rebirthing do
            task.wait(30)
            local rem = ReplicatedStorage:FindFirstChild("Rebirth")
            if rem then pcall(function() rem:FireServer() end) end
        end
    end)
end})

tab6:CreateButton({Name = "Collect All Heroes", Callback = function()
    local rem = ReplicatedStorage:FindFirstChild("GetAllHeroes")
    if rem then
        pcall(function() rem:FireServer() end)
        notify("Battlegrounds", "Collected all heroes")
    else
        notify("Battlegrounds", "GetAllHeroes not found")
    end
end})

-- CHAT COMMAND PARSER
LocalPlayer.Chatted:Connect(function(msg)
    if msg:sub(1,1)==";" then
        local args = msg:split(" ")
        local cmd = args[1]:lower()
        local function n(t) notify("Command", t) end

        if cmd==";fly" then
            local gy=Instance.new("BodyGyro",HRP); local bv=Instance.new("BodyVelocity",HRP)
            gy.MaxTorque,bv.MaxForce = Vector3.new(1e5,1e5,1e5),Vector3.new(1e5,1e5,1e5)
            RunService.RenderStepped:Connect(function()
                gy.CFrame=workspace.CurrentCamera.CFrame
                bv.Velocity=workspace.CurrentCamera.CFrame.LookVector*50
            end); n("Fly ON")
        elseif cmd==";nofly" then
            for _,v in ipairs(HRP:GetChildren()) do if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end end; n("Fly OFF")
        elseif cmd==";speed" then
            local s,m = tonumber(args[2]), args[3] and getPlayerByName(args[3])
            local t = m or LocalPlayer
            if s and s>=16 and s<=3000 and t.Character then t.Character:FindFirstChildOfClass("Humanoid").WalkSpeed=s; n("Speed set to "..s) else n("Invalid speed/target") end
        elseif cmd==";jump" then
            local j,m = tonumber(args[2]), args[3] and getPlayerByName(args[3])
            local t = m or LocalPlayer
            if j and j>=50 and j<=1000 and t.Character then t.Character:FindFirstChildOfClass("Humanoid").JumpPower=j; n("Jump set to "..j) else n("Invalid jump/target") end
        elseif cmd==";tp" then
            local m = getPlayerByName(args[2])
            if m and m.Character and HRP then HRP.CFrame = m.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0); n("Teleported to "..m.Name) else n("Target not found") end
        elseif cmd==";fling" then
            local m = getPlayerByName(args[2]) or LocalPlayer
            if m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") then
                local v=Instance.new("BodyVelocity", m.Character.HumanoidRootPart)
                v.Velocity=Vector3.new(9999,9999,9999); task.delay(0.5,function() v:Destroy() end); n("Flinging "..m.Name)
            else n("Target not found") end
        else
            n("Unknown command: "..cmd)
        end
    end
end)

Window:Init()
