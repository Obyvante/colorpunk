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
    RIGHT = {
        ICON_PANEL = 9042912452,
        PANEL = 9042912328,
        RANK = 9042912582,
        WIN = 9042912152,
        MONEY = 9042912701
    },
    BOTTOM = {
        ICON_PANEL = 9039522875,
        PANEL = 9039522723,
        JUMP = 9039522532,
        SPEED = 9039522298
    }
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- BUNDLES (STARTS)
------------------------

function createLeftPanel(_parent, _name : string, _position : Vector2, _icon : number)
    -- Base left panel backpack.
    local panel = _parent:addElement({
        Name = "body_" .. _name,
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(223, 223)
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0,

            Image = "rbxassetid://" .. asset_ids.LEFT.PANEL
        }
    })
    -- Base left panel icon.
    panel:addElement({
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

            Image = "rbxassetid://" .. _icon
        }
    })
end

function createRightPanel(_parent, _name : string, _position : Vector2, _iconProperties : Vector2)
    -- Base body.
    local bottom = _parent:addElement({
        Name = "body_" .. _name,
        Type = "Frame",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(578, 171)
            },

            AnchorPoint = Vector2.new(1, 1),
            BorderSizePixel = 0,
            BackgroundTransparency = 1
        }
    })
    -- Icon panel.
    bottom:addElement({
        Name = "icon_panel",
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = Vector2.new(-6, -6),
                Size = Vector2.new(227, 229)
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0,

            Image = "rbxassetid://" .. asset_ids.RIGHT.ICON_PANEL
        }
    })
    -- Icon.
    bottom:addElement({
        Name = "icon",
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _iconProperties.Position,
                Size = _iconProperties.Size
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0,

            Image = "rbxassetid://" .. _iconProperties.AssetId
        }
    })
    -- Panel.
    bottom:addElement({
        Name = "panel",
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = Vector2.new(263, -8),
                Size = Vector2.new(573, 233)
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0,

            Image = "rbxassetid://" .. asset_ids.RIGHT.PANEL
        }
    })
    -- Panel text.
    bottom:addElement({
        Name = "text",
        Type = "TextLabel",
        Properties = {
            Custom = {
                Position = Vector2.new(407, 60),
                Size = Vector2.new(283, 100),
                FontSize = 120
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = "DenkOne",
            Text = "999M",
        }
    })
end

function createBottomPanel(_parent, _name : string, _position : Vector2, _iconProperties : Vector2)
    -- Base body.
    local bottom = _parent:addElement({
        Name = "body_" .. _name,
        Type = "Frame",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(578, 171)
            },

            AnchorPoint = Vector2.new(1, 1),
            BorderSizePixel = 0,
            BackgroundTransparency = 1
        }
    })
    -- Icon panel.
    bottom:addElement({
        Name = "icon_panel",
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
    -- Icon.
    bottom:addElement({
        Name = "icon",
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _iconProperties.Position,
                Size = _iconProperties.Size
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0,

            Image = "rbxassetid://" .. _iconProperties.AssetId
        }
    })
    -- Panel.
    bottom:addElement({
        Name = "panel",
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
    -- Panel text.
    bottom:addElement({
        Name = "text",
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

        Image = "rbxassetid://" .. asset_ids.TOP.BACKGROUND
    },

    BuildWith = {
        "AspectRatio"
    }
})
-- Top left text.
top_background:addElement({
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
top_background:addElement({
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
top_background:addElement({
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

-- Top right text for erros.
interface:addElement({
    Name = "error_panel",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(2898, 47),
            Size = Vector2.new(928, 243),
        },

        AnchorPoint = Vector2.new(0.5, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    },

    BuildWith = {
        "AspectRatio"
    }
}):addElement({
    Name = "text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(-75, 100),
            Size = Vector2.new(928, 243),
            FontSize = 70
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,

        TextTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 0, 0),
        Font = "DenkOne",
        Text =
[[
Microtransactions and logins are
temporarily suspended because an error
occurred on the servers. You can continue
playing the game.
]]
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
        BackgroundTransparency = 1
    },

    BuildWith = {
        "AspectRatio"
    }
})

--
-- BACKPACK
--
createLeftPanel(left_body, "backpack", Vector2.new(-6, -6), asset_ids.LEFT.BACKPACK)
left_body:getElement("body_backpack"):updateEvents({
    {
        Name = "click",
        Event = "InputBegan",
        Consumer = function(_binder, _event)
            -- If it is not clicked, no need to continue.
            if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end

            local ui = InterfaceService.get("inventory")
            if ui:isBound() then
                ui:unbind()
            else
                ui:bind(game.Players.LocalPlayer.PlayerGui)
            end
        end
    }
})

--
-- SETTINGS
--
createLeftPanel(left_body, "settings", Vector2.new(-6, 255), asset_ids.LEFT.SETTINGS)
left_body:getElement("body_settings"):updateEvents({
    {
        Name = "click",
        Event = "InputBegan",
        Consumer = function(_binder, _event)
            if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end

            if (_event.UserInputType == Enum.UserInputType.MouseButton1
            or _event.UserInputType == Enum.UserInputType.Touch)
            and _event.UserInputState == Enum.UserInputState.Begin then
                local ui = InterfaceService.get("settings")
                if ui:isBound() then ui:unbind() else ui:bind(game.Players.LocalPlayer.PlayerGui) end
            end
            if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end
        end
    }
})


------------------------
-- LEFT (ENDS)
------------------------


------------------------
-- RIGHT (STARTS)
------------------------

-- Bottom base body.
local right_body = interface:addElement({
    Name = "right_body",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(2942, 728),
            Size = Vector2.new(828, 704)
        },

        AnchorPoint = Vector2.new(1, 1),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    },

    BuildWith = {
        "AspectRatio"
    }
})

createRightPanel(right_body, "rank", Vector2.new(0, 0), {
    Position = Vector2.new(46, 52),
    Size = Vector2.new(148, 101),
    AssetId = asset_ids.RIGHT.RANK
})
createRightPanel(right_body, "win", Vector2.new(0, 243), {
    Position = Vector2.new(46, 42),
    Size = Vector2.new(143, 134),
    AssetId = asset_ids.RIGHT.WIN
})
createRightPanel(right_body, "money", Vector2.new(0, 487), {
    Position = Vector2.new(56, 42),
    Size = Vector2.new(129, 129),
    AssetId = asset_ids.RIGHT.MONEY
})


------------------------
-- RIGHT (ENDS)
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

createBottomPanel(bottom_body, "speed", Vector2.new(0, 0), {
    Position = Vector2.new(56, 29),
    Size = Vector2.new(78, 113),
    AssetId = asset_ids.BOTTOM.SPEED
})
createBottomPanel(bottom_body, "jump", Vector2.new(656, 0), {
    Position = Vector2.new(52, 33),
    Size = Vector2.new(90, 106),
    AssetId = asset_ids.BOTTOM.JUMP
})


------------------------
-- BOTTOM (ENDS)
------------------------


------------------------
-- PRODUCT ICONS PANEL (STARTS)
------------------------

-- Bottom base body.
local product_icon_body = interface:addElement({
    Name = "product_icon_body",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(50, 1960),
            Size = Vector2.new(720, 150)
        },

        AnchorPoint = Vector2.new(0, 1),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    },

    BuildWith = {
        "AspectRatio"
    }
})

-- Adds icons to the panel.
for i = 1, 4, 1 do
    product_icon_body:addElement({
        Name = "icon_panel_" .. i,
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = Vector2.new((i - 1) * 190, 0),
                Size = Vector2.new(150, 150)
            },
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0
        }
    })
end

------------------------
-- PRODUCT ICONS PANEL (ENDS)
------------------------


-- ENDS
return class