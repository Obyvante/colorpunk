local class = {}
-- IMPORTS
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local SpamService = Library.getService("SpamService")
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
            Text = _status and "ACCPET" or "DECLINE",
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

-- Creates match offer interface.
local interface = InterfaceService.createScreen("match_offer", InterfaceService.VIEWPORTS.PC, 999)

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
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "MATCH FOUND!",
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
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text =
[[
Match found! Press "Accept" button
to join game.
]]
    }
})

createButton(panel, "decline", Vector2.new(328, 932), false)
createButton(panel, "accept", Vector2.new(930, 932), true)

------------------------
-- INITIALIZATION (ENDS)
------------------------


-- ENDS
return class