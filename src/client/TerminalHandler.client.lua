local CollectionService = game:GetService("CollectionService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Interface = ReplicatedFirst.Interface
local Events = Interface:WaitForChild("Events")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ShowTerminal = Events:WaitForChild("ShowTerminal")
local HideTerminal = Events:WaitForChild("HideTerminal")

local function GetNewProximityPrompt() : ProximityPrompt
    local ProximityPrompt = Instance.new("ProximityPrompt")
    ProximityPrompt.ActionText = "Open Terminal"
    ProximityPrompt.ObjectText = "Terminal"
    ProximityPrompt.HoldDuration = 0.5
    ProximityPrompt.MaxActivationDistance = 10
    ProximityPrompt.Enabled = true
    return ProximityPrompt
end

local function GetCurrentPrompt() : string
    return Remotes.GetCurrentPrompt:InvokeServer()
end

local function HandleTerminal(TerminalObject : BasePart)
    local ProximityPrompt = GetNewProximityPrompt()
    ProximityPrompt.Parent = TerminalObject

    ProximityPrompt.Triggered:Connect(function()
        ShowTerminal:Fire(GetCurrentPrompt())
    end)
end

local function HandleTerminalAdded(TerminalObject : BasePart)
    if CollectionService:HasTag(TerminalObject, "Terminal") then
        HandleTerminal(TerminalObject)
    end
end

CollectionService:GetInstanceAddedSignal("Terminal"):Connect(HandleTerminalAdded)

for _, TerminalObject in ipairs(CollectionService:GetTagged("Terminal")) do
    HandleTerminal(TerminalObject)
end