local Terminal = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local UserInputService = game:GetService("UserInputService")

local Assets = ReplicatedFirst.Assets
local Events = ReplicatedFirst.Interface.Events
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local New = Fusion.New
local Hydrate = Fusion.Hydrate
local Spring = Fusion.Spring
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value

local Bin = nil
local InputBox : TextBox
local IsOpen = Value(false)
local InputText = Value("")
local PromptText = Value("")

function Terminal:Init(...)
    Bin = ...

    New "BindableEvent" {
        Name = "ShowTerminal",
        Parent = Events,
    }

    New "BindableEvent" {
        Name = "HideTerminal",
        Parent = Events,
    }

    local TerminalFrame = Hydrate(Assets.Terminal.Frame) {
        Parent = Bin,
        Name = "TerminalFrame",
        Visible = IsOpen,
    }

    InputBox = Hydrate(TerminalFrame.Input) {
        Name = "InputBox",
        Text = "",

        [OnEvent "Changed"] = function()
            InputText:set(InputBox.Text)
        end
    }

    Hydrate(TerminalFrame.Prompt) {
        Name = "PromptText",
        Text = PromptText,
    }

    Remotes.EndTerminalWithStatus.OnClientEvent:Connect(function(WasCorrectInput)
        if WasCorrectInput then
            InputBox.Text = "Correct input."
        else
            InputBox.Text = "Incorrect input."
        end

        task.delay(0.5, function()
            IsOpen:set(false)
        end)
    end)
end

function Terminal:ShowTerminal(Text)
    if IsOpen:get() == false then
        PromptText:set(Text)
        InputBox.Text = ""
        IsOpen:set(true)
        InputBox:CaptureFocus()

        InputBox.FocusLost:Wait()

        if IsOpen:get() == true then
            Remotes.SubmitTerminalInput:FireServer(InputText:get())
            InputBox.Text = "..."
        end
    end
end

function Terminal:HideTerminal()
    IsOpen:set(false)
end

return Terminal