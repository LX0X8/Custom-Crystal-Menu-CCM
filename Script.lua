local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxgamer2300/Rayfield/main/source.lua"))()

Rayfield:CreateKeySystem({
   Title = "Custom Crystal Menu",
   Subtitle = "Key System",
   Note = "Keys can be used multiple times!",
   FileName = "CCMKey",
   SaveKey = false,
   GrabKeyFromSite = false,
   Keys = {"1X1", "2X2", "3X3"}
})

repeat task.wait() until Rayfield.KeySystemFinished

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
Tab1:CreateSection("Basic")

local positionString = "0,0,0"

Tab1:CreateInput({
   Name = "Part Position (X,Y,Z)",
   PlaceholderText = "e.g. 10,5,20",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
      positionString = Value
   end,
})

Tab1:CreateButton({
   Name = "Create Part at Position",
   Callback = function()
      local x, y, z = string.match(positionString, "(%-?%d+)[%s,]+(%-?%d+)[%s,]+(%-?%d+)")
      x, y, z = tonumber(x), tonumber(y), tonumber(z)

      if x and y and z then
         local part = Instance.new("Part")
         part.Size = Vector3.new(5, 1, 5)
         part.Position = Vector3.new(x, y, z)
         part.Anchored = true
         part.BrickColor = BrickColor.Random()
         part.Parent = workspace
      else
         Rayfield:Notify({
            Title = "Invalid Input",
            Content = "Use format: X,Y,Z (e.g. 10,5,20)",
            Duration = 5,
            Image = 9256533592,
         })
      end
   end,
})
