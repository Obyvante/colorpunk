local class = {}
-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local InterfaceService = Library.getService("InterfaceService")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

-- Interface asset ids.
local asset_ids = {
    BODY = 9101166641,
    PANEL = 9101165654,
    BUTTON = 9101165940
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- BUNDLES (STARTS)
------------------------

function createButton(_parent, _name : string, _position : Vector2)
    -- Creates button.
    local button = _parent:addElement({
        Name = _name,
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(494, 170)
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0,

            Image = "rbxassetid://" .. asset_ids.BUTTON
        },

        Events = {
            {
                Name = "exit",
                Event = "InputBegan",
                Consumer = function(_binder, _event)
                    if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end
                    InterfaceService.get("summary"):unbind()
                end
            }
        }
    })
    -- Button text.
    button:addElement({
        Name = "text",
        Type = "TextLabel",
        Properties = {
            Custom = {
                Position = Vector2.new(150, 22),
                Size = Vector2.new(194, 104),
                FontSize = 125
            },
    
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            
            TextColor3 = Color3.fromRGB(1, 75, 109),
            Font = "DenkOne",
            Text = "OK.",
        }
    })
end

function createPanel(_parent, _name : string, _position : Vector2, _text : string, _value : string)
    -- Creates button.
    local panel = _parent:addElement({
        Name = _name,
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(1368, 223)
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0,

            Image = "rbxassetid://" .. asset_ids.PANEL
        }
    })
    -- Text.
    panel:addElement({
        Name = "text",
        Type = "TextLabel",
        Properties = {
            Custom = {
                Position = Vector2.new(74, 71),
                Size = Vector2.new(589, 81),
                FontSize = 120
            },
    
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = "DenkOne",
            Text = _text,
        }
    })
    -- Value.
    panel:addElement({
        Name = "value",
        Type = "TextLabel",
        Properties = {
            Custom = {
                Position = Vector2.new(1100, 71),
                Size = Vector2.new(137, 81),
                FontSize = 120
            },
    
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = "DenkOne",
            Text = _value,
        }
    })
end

------------------------
-- BUNDLES (ENDS)
------------------------


------------------------
-- INITIALIZATION (STARTS)
------------------------

-- Creates match offer interface.
local interface = InterfaceService.createScreen("summary", InterfaceService.VIEWPORTS.PC, 999)

-- Base panel.
local body = interface:addElement({
    Name = "body",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(1174, 480),
            Size = Vector2.new(1493, 1200)
        },

        AnchorPoint = Vector2.new(0.5, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,
        LayoutOrder = 1,

        Image = "rbxassetid://" .. asset_ids.BODY
    },

    BuildWith = {
        "AspectRatio"
    }
})
-- Body title.
body:addElement({
    Name = "title",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(445, 44),
            Size = Vector2.new(610, 121),
            FontSize = 150
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "SUMMARY",
    }
})

createButton(body, "OK", Vector2.new(499, 924))

createPanel(body, "ROUND_PLAYED", Vector2.new(62, 252), "ROUND PLAYED", "1")
createPanel(body, "GOLD_EARNED", Vector2.new(62, 469), "GOLD EARNED   ", "10")
createPanel(body, "RANK", Vector2.new(62, 680), "RANK                ", "999.9M")

------------------------
-- INITIALIZATION (ENDS)
------------------------


-- ENDS
return class