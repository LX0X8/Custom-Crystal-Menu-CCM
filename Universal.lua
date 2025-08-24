-- LocalScript (put in StarterPlayerScripts)

--// Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

--// Create the Crystal Hub Window with Key System
local Window = Rayfield:CreateWindow({
    Name = "Crystal Hub",
    LoadingTitle = "Crystal Hub Loading...",
    LoadingSubtitle = "By Crystal",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- creates a folder in AppData/Local
       FileName = "CrystalHubConfig"
    },
    Discord = {
       Enabled = false,
    },
    KeySystem = true, -- Enable Key System
    KeySettings = {
       Title = "Crystal Hub Key System",
       Subtitle = "Enter the key to continue",
       Note = "Key is case sensitive",
       FileName = "CrystalHubKey",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = "Cryst" -- <-- The key required
    }
})

--// Tabs
local MainTab = Window:CreateTab("Main", 4483362458) -- icon id
local FunTab = Window:CreateTab("Fun", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

--// Main Tab Buttons
MainTab:CreateButton({
    Name = "Give 1000 Coins",
    Callback = function()
        print("Pretending to give 1000 coins...") 
    end
})

MainTab:CreateButton({
    Name = "Auto Farm (Just Fun)",
    Callback = function()
        print("Auto farming... just for fun!")
    end
})

--// Fun Tab
FunTab:CreateButton({
    Name = "Fly (Fake)",
    Callback = function()
        print("You are now flying (in your imagination)!") 
    end
})

FunTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 5,
    Suffix = "speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end,
})

--// Misc Tab
MiscTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
    end
})

print("Crystal Hub loaded! Key system active. :)")
