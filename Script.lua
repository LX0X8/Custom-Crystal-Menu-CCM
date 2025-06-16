local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

Rayfield:Notify({
   Title = "CCM is active",
   Content = "Welcome to Custom Crystal Menu",
   Duration = 5,
   Image = "!",
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
      Key = {"1X1", "2X2", "3X3"}
   }
})

local Tab1 = Window:CreateTab("Basic")
Tab1:CreateSection("Part")

local positionString = "0,0,0"
local partCount = 1
local sizeString = "5,1,5"
local createdParts = {}

Tab1:CreateInput({
   Name = "Part Position (X,Y,Z)",
   PlaceholderText = "e.g. 10,5,20",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
      positionString = Value
   end,
})

Tab1:CreateInput({
   Name = "Amount",
   PlaceholderText = "e.g. 3",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
      local n = tonumber(Value)
      if n and n > 0 then
         partCount = math.floor(n)
      else
         partCount = 1
         Rayfield:Notify({
            Title = "Invalid Amount",
            Content = "Must be a positive number",
            Duration = 5,
            Image = "!",
         })
      end
   end,
})

Tab1:CreateInput({
   Name = "Part Size (X,Y,Z)",
   PlaceholderText = "e.g. 5,1,5",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
      sizeString = Value
   end,
})

Tab1:CreateButton({
   Name = "Create Part(s)",
   Callback = function()
      local x, y, z = string.match(positionString, "(%-?%d+)[%s,]+(%-?%d+)[%s,]+(%-?%d+)")
      local sx, sy, sz = string.match(sizeString, "(%-?%d+)[%s,]+(%-?%d+)[%s,]+(%-?%d+)")
      x, y, z = tonumber(x), tonumber(y), tonumber(z)
      sx, sy, sz = tonumber(sx), tonumber(sy), tonumber(sz)
      if x and y and z and sx and sy and sz then
         for i = 1, partCount do
            local part = Instance.new("Part")
            part.Size = Vector3.new(sx, sy, sz)
            part.Position = Vector3.new(x, y + (i - 1) * (sy + 1), z)
            part.Anchored = true
            part.BrickColor = BrickColor.Random()
            part.Parent = workspace
            table.insert(createdParts, part)
         end
      else
         Rayfield:Notify({
            Title = "Invalid Input",
            Content = "Use format: X,Y,Z (e.g. 10,5,20 for position or 5,1,5 for size)",
            Duration = 5,
            Image = "!",
         })
      end
   end,
})

Tab1:CreateButton({
   Name = "Clear Parts",
   Callback = function()
      for _, part in pairs(createdParts) do
         if part and part.Parent then
            part:Destroy()
         end
      end
      createdParts = {}
      Rayfield:Notify({
         Title = "Cleared",
         Content = "Your created parts have been removed",
         Duration = 3,
         Image = "!",
      })
   end,
})

local Tab2 = Window:CreateTab("TCO")
Tab2:CreateSection("Items")

Tab2:CreateButton({
   Name = "GE - Give Arkenstone",
   Callback = function()
      local Players = game:GetService("Players")
      local player = Players.LocalPlayer
      local found = nil
      for _, otherPlayer in pairs(Players:GetPlayers()) do
         if otherPlayer ~= player then
            local backpackTool = otherPlayer:FindFirstChild("Backpack") and otherPlayer.Backpack:FindFirstChild("The Arkenstone")
            local charTool = otherPlayer.Character and otherPlayer.Character:FindFirstChild("The Arkenstone")
            if backpackTool then
               found = backpackTool
               break
            elseif charTool then
               found = charTool
               break
            end
         end
      end
      if found then
         local clone = found:Clone()
         clone.Parent = player.Backpack
         local function tryActivateAdmin(tool)
            local success = false
            if tool:FindFirstChild("RemoteEvent") then
               pcall(function()
                  tool.RemoteEvent:FireServer()
                  success = true
               end)
            end
            if tool:FindFirstChild("Activate") and tool.Activate:IsA("BindableFunction") then
               pcall(function()
                  tool.Activate:Invoke()
                  success = true
               end)
            end
            return success
         end
         tryActivateAdmin(clone)
         Rayfield:Notify({
            Title = "Copied",
            Content = "You were given The Arkenstone and its powers",
            Duration = 4,
            Image = "!",
         })
      else
         Rayfield:Notify({
            Title = "Not Found",
            Content = "No one has 'The Arkenstone' in their inventory",
            Duration = 5,
            Image = "!",
         })
      end
   end,
})

local Tab3 = Window:CreateTab("Player")
Tab3:CreateSection("Humanoid")

Tab3:CreateSlider({
   Name = "Player Speed",
   Range = {0, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

Tab3:CreateSlider({
   Name = "Player Jump Power",
   Range = {0, 500},
   Increment = 1,
   Suffix = "Jump Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

local Tab4 = Window:CreateTab("Gun Games")
Tab4:CreateSection("Basic")

local highlights = {}

Tab4:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "ToggleESP",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local LocalPlayer = Players.LocalPlayer

      for _, h in pairs(highlights) do
         if h and h.Parent then
            h:Destroy()
         end
      end
      highlights = {}

      if Value then
         for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
               local highlight = Instance.new("Highlight")
               highlight.Adornee = player.Character
               highlight.FillColor = Color3.fromRGB(255, 0, 0)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
               highlight.FillTransparency = 0.5
               highlight.OutlineTransparency = 0
               highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
               highlight.Parent = player.Character
               table.insert(highlights, highlight)
            end
         end
      end
   end,
})
