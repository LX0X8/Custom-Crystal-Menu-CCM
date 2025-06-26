local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
Rayfield:Notify({Title="✨ CCM Loaded",Content="Custom Crystal Menu!",Duration=4})
local Win = Rayfield:CreateWindow({Name="Custom Crystal Menu",Theme="Serenity",ToggleUIKeybind=Enum.KeyCode.RightControl,KeySystem=false})
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local parts,effects = {},{}
local parseVec=function(s)local x,y,z=s:match("(%-?%d+),?(%-?%d+),?(%-?%d+)")return x and Vector3.new(x,y,z)end
local hum=function()return Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")end

local searchBar = Win:CreateSearchBox({ PlaceholderText="Search tools..." })

local function filter(tab)
    local term=searchBar:Get()
    for _,btn in ipairs(tab.Elements) do
        btn.Instance.Visible = term=="" or btn.Name:lower():find(term:lower())
    end
end
searchBar:OnChanged(function()
    for _,tab in ipairs(Win.Tabs) do filter(tab) end
end)

local b=Win:CreateTab("Builder")
b:CreateInput({Name="Position",Callback=function(v)posStr=v end})
b:CreateInput({Name="Size",Callback=function(v)sizeStr=v end})
b:CreateInput({Name="Count",Callback=function(v)cnt=tonumber(v)or 1 end})
b:CreateButton({Name="Spawn",Callback=function()
    local p,s=parseVec(posStr),parseVec(sizeStr)
    if p and s then for i=1,cnt do local pr=Instance.new("Part")pr.Size,pr.CFrame,pr.Anchored,pr.Material,pr.BrickColor,pr.TopSurface,pr.Parent=s,CFrame.new(p+Vector3.new(0,(i-1)*(s.Y+1),0)),true,Enum.Material.Neon,BrickColor.Random(),Enum.SurfaceType.Smooth,workspace table.insert(parts,pr)end end
end})
b:CreateButton({Name="Clear All",Callback=function()for _,p in ipairs(parts)do p:Destroy()end parts={}end})

local p=Win:CreateTab("Player Mods")
p:CreateSlider({Name="Speed",Range={0,300},CurrentValue=16,Callback=function(v)if hum()then hum().WalkSpeed=v end end})
p:CreateSlider({Name="Jump",Range={0,300},CurrentValue=50,Callback=function(v)if hum()then hum().JumpPower=v end end})
p:CreateSlider({Name="Gravity",Range={-200,200},CurrentValue=196.2,Callback=function(v)workspace.Gravity=v end})
p:CreateToggle({Name="Infinite Health",Callback=function(v)if v and hum()then local h=hum()h.Health,h.MaxHealth=math.huge,math.huge end end})

local vf=Win:CreateTab("Visual FX")
vf:CreateButton({Name="Rainbow Skin",Callback=function()local c=Player.Character if c then task.spawn(function()while wait(0.1)do for _,pr in ipairs(c:GetDescendants())do if pr:IsA("BasePart")then pr.Color=Color3.fromHSV(tick()%1,1,1)end end end end)end end})
vf:CreateToggle({Name="Night Vision",Callback=function(v)local L=game.Lighting L.Brightness,L.Ambient= v and 6 or 2, v and Color3.fromRGB(50,50,50) or Color3.new(1,1,1)end})
vf:CreateSlider({Name="FOV",Range={70,120},CurrentValue=70,Callback=function(v)workspace.CurrentCamera.FieldOfView=v end})
vf:CreateToggle({Name="Trails",Callback=function(v)local c=Player.Character if c then for _,pr in ipairs(c:GetChildren())do if pr:IsA("BasePart")then if v then local a0,a1=Instance.new("Attachment",pr),Instance.new("Attachment",pr);local t=Instance.new("Trail",pr);t.Attachment0,t.Attachment1=a0,a1;t.Lifetime=0.5;t.Transparency=NumberSequence.new(0.5)else for _,ch in ipairs(pr:GetChildren())do if ch:IsA("Trail")or ch:IsA("Attachment")then ch:Destroy()end end end end end end end})
vf:CreateButton({Name="Sparkle Head",Callback=function(localPlayer=Player)local hrp=localPlayer.Character and localPlayer.Character:FindFirstChild("Head")if hrp then local e=Instance.new("ParticleEmitter",hrp);e.Texture,e.Rate,e.Lifetime,e.Speed="rbxassetid://241865958",100,NumberRange.new(1),NumberRange.new(0,1);game:GetService("Debris"):AddItem(e,3)end end})
vf:CreateDropdown({Name="Lighting",Options={"Day","Sunset","Night"},Callback=function(o)local L=game.Lighting;if o=="Day"then L.TimeOfDay,L.Brightness,L.OutdoorAmbient="12:00:00",2,Color3.fromRGB(200,200,200)elseif o=="Sunset"then L.TimeOfDay,L.Brightness,L.OutdoorAmbient="19:00:00",1.5,Color3.fromRGB(255,150,100)else L.TimeOfDay,L.Brightness,L.OutdoorAmbient="00:00:00",1,Color3.fromRGB(50,50,100)end end})

local fu=Win:CreateTab("Fun")
fu:CreateButton({Name="Sparkles",Callback=function(localPlayer=Player)local hrp=localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")if hrp then Instance.new("Sparkles",hrp)end end})
fu:CreateButton({Name="Crystal Rain",Callback=function(localPlayer=Player)local hrp=localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")if hrp then for i=1,50 do local pr=Instance.new("Part",workspace);pr.Size,pr.Anchored,pr.Material=Vector3.new(0.3,0.3,0.3),true,Enum.Material.Neon;pr.Position=hrp.Position+Vector3.new(math.random(-20,20),30,math.random(-20,20));pr.BrickColor=BrickColor.Random();game:GetService("Debris"):AddItem(pr,5)end end end})
fu:CreateButton({Name="Spin Char",Callback=function()effects.spin=not effects.spin;if effects.spin then game:GetService("RunService").RenderStepped:Connect(function(localPlayer=Player)local r=localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")if r then r.CFrame=r.CFrame*CFrame.Angles(0,math.rad(10),0)end end)end end})
fu:CreateButton({Name="Fake Kick",Callback=function()Rayfield:Notify({Title="Fake Kick",Content="You have been kicked!",Duration=3,Image="x"})end})
fu:CreateButton({Name="Fake Ban",Callback=function()Rayfield:Notify({Title="Fake Ban",Content="You have been banned!",Duration=3,Image="shield-off"})end})

local esp=Win:CreateTab("ESP")
esp:CreateToggle({Name="Player ESP",Callback=function(v)for _,h in ipairs(effects.esp or {})do h:Destroy()end;effects.esp={};if v then for _,pl in ipairs(game.Players:GetPlayers())do if pl~=Player and pl.Character then local h=Instance.new("Highlight",pl.Character);h.Adornee, h.FillColor, h.FillTransparency=pl.Character,Color3.new(1,0,0),0.5;table.insert(effects.esp,h)end end end end})

local pt=Win:CreateTab("Particles")
local toggleFx=function(k,fn)if effects[k]then for _,o in ipairs(effects[k])do o.Destroy and o:Destroy()end;effects[k]=nil else effects[k]=fn()end end
pt:CreateToggle({Name="Sparkles",Callback=function()toggleFx("spark",function()local arr={},c=Player.Character or Player.CharacterAdded:Wait();for _,p in ipairs(c:GetDescendants())do if p:IsA("BasePart")then local s=Instance.new("Sparkles",p);table.insert(arr,s)end end;return arr end)end})
pt:CreateToggle({Name="Fire Aura",Callback=function()toggleFx("fire",function()local arr={},c=Player.Character or Player.CharacterAdded:Wait();for _,p in ipairs(c:GetDescendants())do if p:IsA("BasePart")then local f=Instance.new("Fire",p);f.Size=5;table.insert(arr,f)end end;return arr end)end})
pt:CreateToggle({Name="Smoke Trail",Callback=function()toggleFx("smoke",function()local arr={},c=Player.Character or Player.CharacterAdded:Wait();for _,p in ipairs(c:GetDescendants())do if p:IsA("BasePart")then local s=Instance.new("Smoke",p);s.Size=3;s.Opacity=0.3;table.insert(arr,s)end end;return arr end)end})
pt:CreateToggle({Name="Aura Ring",Callback=function()toggleFx("ring",function()local c=Player.Character or Player.CharacterAdded:Wait();local root=c:FindFirstChild("HumanoidRootPart");local arr,parts={}
for a=0,360,30 do local p=Instance.new("Part",workspace);p.Size,p.Anchored,p.CanCollide=Vector3.new(0.3,0.3,0.3),true,false;p.Shape,p.Material,p.BrickColor=Enum.PartType.Ball,Enum.Material.Neon,BrickColor.Random();table.insert(parts,p)end
local conn=game:GetService("RunService").Heartbeat:Connect(function()local t,i= tick(),0;for _,p in ipairs(parts)do i=i+1;local ang=math.rad((t*60+i*30)%360);p.Position=root.Position+Vector3.new(math.cos(ang)*5,0.5,math.sin(ang)*5)end end)
for _,p in ipairs(parts)do table.insert(arr,p)end
table.insert(arr,{Destroy=function()conn:Disconnect();for _,p in ipairs(parts)do p:Destroy()end end})
return arr end)end})
pt:CreateToggle({Name="Glow Body",Callback=function()toggleFx("glow",function()local arr={},c=Player.Character or Player.CharacterAdded:Wait();local h=Instance.new("Highlight",c);h.FillColor, h.FillTransparency, h.OutlineTransparency=Color3.new(1,0,1),0.5,1;table.insert(arr,h);return arr end)end})

local devt=Win:CreateTab("Dev Tools")
devt:CreateToggle({Name="Inspector",Callback=function(v)effects.inspect=v end})
Mouse.Button1Down:Connect(function()if effects.inspect and Mouse.Target then Rayfield:Notify({Title="Inspect",Content="["..Mouse.Target.ClassName.."] "..Mouse.Target.Name,Duration=4})end end)
do local sg=Instance.new("ScreenGui",Player:WaitForChild("PlayerGui"));local fr=Instance.new("Frame",sg);fr.Size,fr.Position,fr.BackgroundTransparency=UDim2.new(0,300,0,150),UDim2.new(0,0,0.6,0),0.7
local tb=Instance.new("TextBox",fr);tb.Size,tb.TextWrapped,tb.TextColor3=UDim2.new(1,0,1,0),true,Color3.new(1,1,1)
game:GetService("LogService").MessageOut:Connect(function(m,t)tb.Text=tb.Text.."["..t.Name.."] "..m.."\n")end)end

local ut=Win:CreateTab("Utilities")
ut:CreateButton({Name="Spawn Block",Callback=function()local hrp=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")if hrp then local b=Instance.new("Part");b.Size,b.Position,b.BrickColor=Vector3.new(4,4,4),hrp.Position+hrp.CFrame.LookVector*5,BrickColor.Random();b.Parent=workspace end end})
ut:CreateButton({Name="Spawn Sphere",Callback=function()local hrp=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")if hrp then local s=Instance.new("Part");s.Shape,s.Size,s.Position,s.BrickColor=Enum.PartType.Ball,Vector3.new(3,3,3),hrp.Position+hrp.CFrame.LookVector*5,BrickColor.Random();s.Parent=workspace end end})
ut:CreateButton({Name="Grid 5x5",Callback=function()local hrp=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")if hrp then local o=hrp.Position+Vector3.new(0,0,-10)for x=0,4 do for z=0,4 do local p=Instance.new("Part");p.Size,p.Position,p.Anchored,p.BrickColor=Vector3.new(1,1,1),o+Vector3.new(x*2,0,z*2),true,BrickColor.Random();p.Parent=workspace end end end end})
ut:CreateButton({Name="Circle 12",Callback=function()local hrp=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")if hrp then local o,r=hrp.Position,5 for i=1,12 do local a=math.rad(i*30);local p=Instance.new("Part");p.Size,p.Position,p.Anchored,p.BrickColor=Vector3.new(1,1,1),o+Vector3.new(math.cos(a)*r,0,math.sin(a)*r),true,BrickColor.Random();p.Parent=workspace end end end})
ut:CreateButton({Name="Sine Wave",Callback=function()local hrp=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")if hrp then local o=hrp.Position for i=1,50 do local p=Instance.new("Part");p.Size,p.Anchored=Vector3.new(1,1,1),true;p.Position=o+Vector3.new(i,math.sin(math.rad(i*15))*5,0);p.BrickColor=BrickColor.new(Color3.fromHSV((i/50)%1,1,1));p.Parent=workspace end end end})
