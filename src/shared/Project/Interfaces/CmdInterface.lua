local class = {}
-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local SpamService = Library.getService("SpamService")
local EventService = Library.getService("EventService")
-- EVENTS
local CommandEvent = EventService.get("Command.Command")
-- STARTS


------------------------
-- INITIALIZATION (STARTS)
------------------------

-- Creates agreement interface.
local interface = InterfaceService.createScreen("cmd", InterfaceService.VIEWPORTS.PC, 999)

-- Base panel.
local panel = interface:addElement({
    Name = "panel",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(1075, 464),
            Size = Vector2.new(1690, 1231)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    },

    BuildWith = {
        "AspectRatio"
    }
})

-- Command line.
local commandLine = panel:addElement({
    Name = "Command Line",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(0, 0),
            Size = Vector2.new(1690, 160)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.fromHex("#223038")
    },
})

-- Line.
local command_line = commandLine:addElement({
    Name = "line",
    Type = "TextBox",
    Properties = {
        Size = UDim2.fromScale(0.9, 0.9),
        Position = UDim2.fromScale(0.5, 0.5),

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        RichText = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "Code",
        TextScaled = true,
        Text = "/give dberketurkmen Foreseeing Goggles"
    },
    Events = {
        {
            Name = "click",
            Event = "FocusLost",
            Consumer = function(_binder, _enter)
                if _enter then
                    CommandEvent:FireServer(_binder:getParent():getInstance().Text)
                else
                    commandLine:updateProperties({
                        BackgroundColor3 = Color3.fromHex("#223038")
                    })
                end
            end
        }
    }
})

------------------------
-- INITIALIZATION (ENDS)
------------------------

------------------------
-- EVENTS (STARTS)
------------------------

CommandEvent.OnClientEvent:Connect(function(_success : boolean)
    if _success then
        commandLine:updateProperties({
            BackgroundColor3 = Color3.fromRGB(91, 165, 57)
        })
    else
        commandLine:updateProperties({
            BackgroundColor3 = Color3.fromRGB(211, 79, 79)
        })
    end
end)

------------------------
-- EVENTS (ENDS)
------------------------



-- ENDS
return class