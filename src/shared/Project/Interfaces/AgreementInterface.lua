local class = {}
-- IMPORTS
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local SpamService = Library.getService("SpamService")
local EventService = Library.getService("EventService")
-- EVENTS
local InterfaceActionEvent = EventService.get("Interface.InterfaceAction")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

-- Interface asset ids.
local asset_ids = {
    PANEL = 9045139741,
    DECLINE = 9045140032,
    ACCEPT = 9045140215
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- BUNDLES (STARTS)
------------------------

function createButton(_parent, _name : string, _position : Vector2, _status : boolean)
    -- Creates button.
    local button = _parent:addElement({
        Name = _name,
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(593, 188)
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0,

            Image = "rbxassetid://" .. (_status and asset_ids.ACCEPT or asset_ids.DECLINE)
        },

        Events = {
            {
                Name = "click",
                Event = "InputEnded",
                Consumer = function(_binder, _event)
                    -- Listen click.
                    if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end

                    -- Declares required fields.
                    local _interface = _parent:getInterface()
                    local _metadata = _interface:getMetadata()
                    local _action_id = _metadata:get("action:id")

                    -- Unbinds interface. (CLOSES)
                    InterfaceService.get("agreement"):unbind()

                    -- Handles interface action event.
                    if _action_id ~= nil then
                        InterfaceActionEvent:FireServer("agreement", {
                            Id = _action_id,
                            Action = _status
                        })
                    end
                end
            }
        }
    })
    -- Button text.
    button:addElement({
        Name = "title",
        Type = "TextLabel",
        Properties = {
            Custom = {
                Position = Vector2.new(149, 43),
                Size = Vector2.new(295, 75),
                FontSize = 100
            },
    
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = "DenkOne",
            Text = _status and "ACCEPT" or "DECLINE",
        }
    })
end

------------------------
-- BUNDLES (ENDS)
------------------------


------------------------
-- AUTOMATION (STARTS)
------------------------

-- Checks spam.
-- @return Should block or not.
function spamCheck()
    return SpamService.handle("game", 20, 30)
end

------------------------
-- AUTOMATION (ENDS)
------------------------


------------------------
-- INITIALIZATION (STARTS)
------------------------

-- Creates agreement interface.
local interface = InterfaceService.createScreen("agreement", InterfaceService.VIEWPORTS.PC, 999)

-- Base panel.
local panel = interface:addElement({
    Name = "panel",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(992, 417),
            Size = Vector2.new(1854, 1323)
        },

        AnchorPoint = Vector2.new(0.5, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,
        Active = true,
        LayoutOrder = 1,

        Image = "rbxassetid://" .. asset_ids.PANEL
    },

    BuildWith = {
        "AspectRatio"
    }
})
-- Panel title.
panel:addElement({
    Name = "title",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(544, 127),
            Size = Vector2.new(769, 109),
            FontSize = 150
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        RichText = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "AGREEMENT",
    }
})
-- Panel text.
panel:addElement({
    Name = "text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(159, 320),
            Size = Vector2.new(1536, 611),
            FontSize = 100
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        RichText = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = ""
    }
})

createButton(panel, "decline", Vector2.new(328, 932), false)
createButton(panel, "accept", Vector2.new(930, 932), true)

------------------------
-- INITIALIZATION (ENDS)
------------------------


-- ENDS
return class