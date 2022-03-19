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
    BACKGROUND = 9029200270,

    BUTTON = {
        EXIT = 9014862110
    },

    SQUARE = 9029152867,

    ICON = {
        VFX = 9036437412,
        MUSIC = 9036437553,
        WARNING_SCREEN = 9036437214,
        AUTO_MATCH_ACCEPT = 9036437693
    },

    SWITCH = {
        ON = 9036654755,
        OFF = 9036654971
    }
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- BUNDLES (STARTS)
------------------------

-- Creates a square.
-- @param _name Square name.
-- @param _position Square position.
-- @return Table.
function createSquare(_name : string, _position : Vector2)
    return {
        Name = _name .. "_square",
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(309, 309)
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            Image = "rbxassetid://" .. asset_ids.SQUARE
        }
    }
end

-- Creates an off switch.
-- @param _name Switch name.
-- @param _position Switch position.
-- @return Table.
function createSwitchOff(_name : string, _position : Vector2)
    return {
        Name = _name .. "_switch",
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(112, 184)
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            Image = "rbxassetid://" .. asset_ids.SWITCH.OFF
        }
    }
end

-- Creates an on switch.
-- @param _name Switch name.
-- @param _position Switch position.
-- @return Table.
function createSwitchOn(_name : string, _position : Vector2)
    return {
        Name = _name .. "_switch",
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(114, 185)
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            Image = "rbxassetid://" .. asset_ids.SWITCH.ON
        }
    }
end

-- Creates an off switch.
-- @param _name Switch name.
-- @param _position Switch position.
-- @param _status Switch status.
-- @return Table.
function createSwitch(_name : string, _position : Vector2, _status : boolean)
    return _status and createSwitchOn(_name, _position) or createSwitchOff(_name, _position)
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
    return SpamService.handle("settings", 20, 30)
end

-- Handles switch click.
-- @param _element Interface element.
-- @param _type Settings type.
-- @param _binder Interface element binder.
-- @param _event Event information.
function switchClick(_element, _type, _binder, _event)
    -- If it is not mouse event, no need to continue.
    if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end

    -- Prevents client spam.
    if spamCheck() then return end

    -- Gets required fields.
    local status = ClientPlayer.getSettings().asBoolean(_type)

    -- Updates switch image.
    _element:updateProperties({
        Image = "rbxassetid://" .. if status then asset_ids.SWITCH.OFF else asset_ids.SWITCH.ON
    })

    -- Sets field.
    ClientPlayer.getSettings().set(_type, if status then 0 else 1)
end

------------------------
-- AUTOMATION (ENDS)
------------------------


------------------------
-- INITIALIZATION (STARTS)
------------------------

-- Creates settings interface.
local interface = InterfaceService.createScreen("settings", InterfaceService.VIEWPORTS.PC)

-- Base background.
local background = interface:addElement({
    Name = "background",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(933, 480),
            Size = Vector2.new(1974, 1200)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,
        Active = true,

        Image = "rbxassetid://" .. asset_ids.BACKGROUND
    },

    BuildWith = {
        "AspectRatio"
    }
})

-- Base title.
local title = background:addElement({
    Name = "title",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(504, 12),
            Size = Vector2.new(966, 175),
            FontSize = 175
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "SETTINGS",
    }
})

-- Button exit.
local button_exit = background:addElement({
    Name = "button_exit",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(1790, 27),
            Size = Vector2.new(145, 145)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BackgroundTransparency = 1,
        Active = true,

        Image = "rbxassetid://" .. asset_ids.BUTTON.EXIT
    },

    Events = {
        {
            Name = "click",
            Event = "InputBegan",
            Consumer = function(_binder, _event)
                if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end
                interface:unbind()
            end
        }
    }
})


------------------------
-- VFX (STARTS)
------------------------

-- Square.
local vfx_square = background:addElement(createSquare("VFX", Vector2.new(63, 303)))
-- Icon.
local vfx_icon = background:addElement({
    Name = "vfx_icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(141, 377),
            Size = Vector2.new(152, 152)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.VFX
    }
})
-- Text.
local vfx_text = background:addElement({
    Name = "vfx_text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(400, 410),
            Size = Vector2.new(415, 173),
            FontSize = 90
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text =
[[
VFX
     SOUND
]]
    }
})

-- Switch.
local vfx_switch = background:addElement(createSwitch("VFX", Vector2.new(395, 357), ClientPlayer.getSettings().asBoolean("VFX")))
-- Handles switch click event.
vfx_switch:getEventBinder():bind(vfx_switch:getInstance().InputBegan, {
    Name = "click",
    Consumer = function(_binder, _event) switchClick(vfx_switch, "VFX", _binder, _event) end
})

------------------------
-- VFX (ENDS)
------------------------


------------------------
-- MUSIC (STARTS)
------------------------

-- Square.
local music_square = background:addElement(createSquare("MUSIC", Vector2.new(1009, 299)))
-- Icon.
local music_icon = background:addElement({
    Name = "music_icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(1092, 366),
            Size = Vector2.new(142, 173)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.MUSIC
    }
})
-- Text.
local music_text = background:addElement({
    Name = "music_text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(1400, 400),
            Size = Vector2.new(415, 173),
            FontSize = 90
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text =
[[
MUSIC
SOUND
]]
    }
})

-- Switch.
local music_switch = background:addElement(createSwitch("MUSIC", Vector2.new(1342, 356), ClientPlayer.getSettings().asBoolean("MUSIC")))
-- Handles switch click event.
music_switch:getEventBinder():bind(music_switch:getInstance().InputBegan, {
    Name = "click",
    Consumer = function(_binder, _event) switchClick(music_switch, "MUSIC", _binder, _event) end
})

------------------------
-- MUSIC (ENDS)
------------------------


------------------------
-- WARNING SCREEN (STARTS)
------------------------

-- Square.
local warning_square = background:addElement(createSquare("WARNING", Vector2.new(63, 711)))
-- Icon.
local warning_icon = background:addElement({
    Name = "warning_icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(144, 788),
            Size = Vector2.new(146, 146)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.WARNING_SCREEN
    }
})
-- Text.
local warning_text = background:addElement({
    Name = "warning_text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(450, 820),
            Size = Vector2.new(415, 173),
            FontSize = 90
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text =
[[
    WARNING
SCREEN
]]
    }
})

-- Switch.
local warning_switch = background:addElement(createSwitch("WARNING", Vector2.new(395, 765), ClientPlayer.getSettings().asBoolean("SKIP_WARNING_SCREEN")))
-- Handles switch click event.
warning_switch:getEventBinder():bind(warning_switch:getInstance().InputBegan, {
    Name = "click",
    Consumer = function(_binder, _event) switchClick(warning_switch, "SKIP_WARNING_SCREEN", _binder, _event) end
})

------------------------
-- WARNING SCREEN (ENDS)
------------------------


------------------------
-- AUTO ACCEPT (STARTS)
------------------------

-- Square.
local auto_accept_square = background:addElement(createSquare("AUTO_ACCEPT", Vector2.new(1009, 707)))
-- Icon.
local auto_accept_icon = background:addElement({
    Name = "auto_accept_icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(1090, 788),
            Size = Vector2.new(148, 148)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.AUTO_MATCH_ACCEPT
    }
})
-- Text.
local auto_accept_text = background:addElement({
    Name = "auto_accept_text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(1400, 820),
            Size = Vector2.new(415, 173),
            FontSize = 90
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text =
[[
         AUTO MATCH
ACCEPT
]]
    }
})

-- Switch.
local auto_accept_switch = background:addElement(createSwitch("AUTO_ACCEPT", Vector2.new(1342, 764), ClientPlayer.getSettings().asBoolean("AUTO_ACCEPT_MATCH")))
-- Handles switch click event.
auto_accept_switch:getEventBinder():bind(auto_accept_switch:getInstance().InputBegan, {
    Name = "click",
    Consumer = function(_binder, _event) switchClick(auto_accept_switch, "AUTO_ACCEPT_MATCH", _binder, _event) end
})

------------------------
-- AUTO ACCEPT (ENDS)
------------------------


------------------------
-- INITIALIZATION (ENDS)
------------------------


-- ENDS
return class