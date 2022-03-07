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
    TOP = {
        BACKGROUND = 9038585313
    },
    LEFT = {
        PANEL = 9039056428,
        BACKPACK = 9039056588,
        SETTINGS = 9039056256
    },
    BOTTOM = {
        ICON_PANEL = 9039522875,
        PANEL = 9039522723,
        JUMP = 9039522532,
        SPEED = 9039522298
    },
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- BUNDLES (STARTS)
------------------------
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

-- Creates game interface.
local interface = InterfaceService.createScreen("game", InterfaceService.VIEWPORTS.PC)


------------------------
-- TOP (STARTS)
------------------------

-- Base background.
local top_background = interface:addElement({
    Name = "top_background",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(1211, 0),
            Size = Vector2.new(1418, 435)
        },

        AnchorPoint = Vector2.new(0.5, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,
        Active = true,

        Image = "rbxassetid://" .. asset_ids.TOP.BACKGROUND
    },

    BuildWith = {
        "AspectRatio"
    }
})

-- Top left text.
local top_left_text = top_background:addElement({
    Name = "left_text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(173, 164),
            Size = Vector2.new(81, 85),
            FontSize = 150
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "00",
    }
})

-- Top center text.
local top_center_text = top_background:addElement({
    Name = "center_text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(513, 155),
            Size = Vector2.new(408, 106),
            FontSize = 140
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "White",
    }
})

-- Top right text.
local top_right_text = top_background:addElement({
    Name = "right_text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(1163, 164),
            Size = Vector2.new(81, 85),
            FontSize = 150
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "00",
    }
})

------------------------
-- TOP (ENDS)
------------------------


------------------------
-- LEFT (STARTS)
------------------------

-- Left.
local left_body = interface:addElement({
    Name = "left_body",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(70, 843),
            Size = Vector2.new(211, 474)
        },

        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Active = true
    },

    BuildWith = {
        "AspectRatio"
    }
})

-- Base left panel backpack.
local left_panel_backpack = left_body:addElement({
    Name = "left_panel_backpack",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(-6, -6),
            Size = Vector2.new(223, 223)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,

        Image = "rbxassetid://" .. asset_ids.LEFT.PANEL
    },

    Events = {
        {
            Name = "click",
            Event = "InputBegan",
            Consumer = function(_binder, _event)
                if not InterfaceService.isClicked(_event.UserInputType) then return end

                print("backpack")
            end
        },
    }
})

-- Base left backpack icon.
local left_backpack_icon = left_panel_backpack:addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(55, 49),
            Size = Vector2.new(129, 129)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,

        Image = "rbxassetid://" .. asset_ids.LEFT.BACKPACK
    }
})

-- Base left panel settings.
local left_panel_settings = left_body:addElement({
    Name = "left_panel_settings",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(-6, 255),
            Size = Vector2.new(223, 225)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,

        Image = "rbxassetid://" .. asset_ids.LEFT.PANEL
    },

    Events = {
        {
            Name = "click",
            Event = "InputBegan",
            Consumer = function(_binder, _event)
                if not InterfaceService.isClicked(_event.UserInputType) then return end

                local ui = InterfaceService.get("settings")
                if ui:isBound() then ui:unbind() else ui:bind(game.Players.LocalPlayer.PlayerGui) end
            end
        },
    }
})

-- Base left settings icon.
local left_settings_icon = left_panel_settings:addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(55, 51),
            Size = Vector2.new(129, 129)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,

        Image = "rbxassetid://" .. asset_ids.LEFT.SETTINGS
    }
})

------------------------
-- LEFT (ENDS)
------------------------


------------------------
-- BOTTOM (STARTS)
------------------------


-- Bottom base body.
local bottom_body = interface:addElement({
    Name = "bottom_body",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(2534, 1918),
            Size = Vector2.new(1235, 171)
        },

        AnchorPoint = Vector2.new(1, 1),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    },

    BuildWith = {
        "AspectRatio"
    }
})
-- Bottom speed base body.
local bottom_speed = bottom_body:addElement({
    Name = "bottom_speed",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(0, 0),
            Size = Vector2.new(578, 171)
        },

        AnchorPoint = Vector2.new(1, 1),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    }
})
-- Bottom jump base body.
local bottom_jump = bottom_body:addElement({
    Name = "bottom_jump",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(656, 0),
            Size = Vector2.new(578, 171)
        },

        AnchorPoint = Vector2.new(1, 1),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    }
})

-- Bottom speed icon panel.
local bottom_speed_icon_panel = bottom_speed:addElement({
    Name = "bottom_speed_icon_panel",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(-5, -5),
            Size = Vector2.new(209, 180)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,

        Image = "rbxassetid://" .. asset_ids.BOTTOM.ICON_PANEL
    }
})
-- Bottom speed icon.
local bottom_speed_icon = bottom_speed:addElement({
    Name = "bottom_speed_icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(56, 29),
            Size = Vector2.new(78, 113)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,

        Image = "rbxassetid://" .. asset_ids.BOTTOM.SPEED
    }
})

-- Bottom jump icon panel.
local bottom_jump_icon_panel = bottom_jump:addElement({
    Name = "bottom_jump_icon_panel",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(-5, -5),
            Size = Vector2.new(209, 180)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,

        Image = "rbxassetid://" .. asset_ids.BOTTOM.ICON_PANEL
    }
})
-- Bottom jump icon.
local bottom_jump_icon = bottom_jump:addElement({
    Name = "bottom_jump_icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(52, 33),
            Size = Vector2.new(90, 106)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,

        Image = "rbxassetid://" .. asset_ids.BOTTOM.JUMP
    }
})

-- Bottom speed panel.
local bottom_speed_panel = bottom_speed:addElement({
    Name = "bottom_speed_panel",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(200, 0),
            Size = Vector2.new(386, 179)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,

        Image = "rbxassetid://" .. asset_ids.BOTTOM.PANEL
    }
})
-- Bottom speed panel text.
local bottom_speed_panel_text = bottom_speed:addElement({
    Name = "bottom_speed_panel_text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(281, 55),
            Size = Vector2.new(226, 68),
            FontSize = 120
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "x1.00",
    }
})

-- Bottom jump panel.
local bottom_jump_panel = bottom_jump:addElement({
    Name = "bottom_jump_panel",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(200, 0),
            Size = Vector2.new(386, 179)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,

        Image = "rbxassetid://" .. asset_ids.BOTTOM.PANEL
    }
})
-- Bottom jump panel text.
local bottom_jump_panel_text = bottom_jump:addElement({
    Name = "bottom_jump_panel_text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(281, 55),
            Size = Vector2.new(226, 68),
            FontSize = 120
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "x1.00",
    }
})


------------------------
-- BOTTOM (ENDS)
------------------------


------------------------
-- INITIALIZATION (ENDS)
------------------------


-- ENDS
return class