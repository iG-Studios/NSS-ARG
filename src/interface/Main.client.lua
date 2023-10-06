local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayersService = game:GetService("Players")

local Components = script.Parent.Components
local Fusion = require(ReplicatedStorage:WaitForChild("Packages").fusion) 

local Player = PlayersService.LocalPlayer
local New = Fusion.New

local Bin = New "ScreenGui" {
    Parent = Player:WaitForChild("PlayerGui"),
    Name = "Interface",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
}

local Events = New "Folder" {
    Name = "Events",
    Parent = script.Parent,
}

-------------
-- Init

for _, ComponentModule in ipairs(Components:GetChildren()) do
    local Component = require(ComponentModule)
    Component:Init(Bin)
end
-------------

Events.ShowTerminal.Event:Connect(function(...)
    require(Components.Terminal):Open(...)
end)

Events.HideTerminal.Event:Connect(function(...)
    require(Components.Terminal):Close(...)
end)