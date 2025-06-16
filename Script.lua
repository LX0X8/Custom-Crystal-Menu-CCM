local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

Rayfield:Notify({
   Title = "CCM is active",
   Content = "Welcome to Custom Crystal Menu",
   Duration = 5,
   Image = 9256533592,
})

local Window = Rayfield:CreateWindow({
   Name = "Custom Crystal Menu (CCM)",
   Theme = "AmberGlow",
   ToggleUIKeybind = Enum.KeyCode.N,
})

local Tab1 = Window:CreateTab("Basic")

Tab1:CreateSection("Part")

local positionString = "0,0,0"
local partCount = 1
local sizeString = "5,1,5"

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
            Image = 9256533592,
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
         end
      else
         Rayfield:Notify({
            Title = "Invalid Input",
            Content = "Use format: X,Y,Z (e.g. 10,5,20 for position or 5,1,5 for size)",
            Duration = 5,
            Image = 9256533592,
         })
      end
   end,
})
