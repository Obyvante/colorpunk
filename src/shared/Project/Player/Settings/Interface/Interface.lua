local class = {}
-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local TaskService = Library.getService("TaskService")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

-- Interface asset ids.
local asset_ids = {
    BACKGROUND = 9029200270,

    BUTTON = {
        EXIT = 9014862110,
        SWITCH = 9029198793
    },

    SQUARE = {
        VFX = 9029151938,
        MUSIC = 9029154068,
        FOOTER = 9029152867
    },

    ICON = {
        VFX = 9029164237,
        MUSIC = 9029164625,
        INFORMATION = 9029165223,
        AUTO_ACCEPT = 9029165599
    },

    SCROLL = {
        NEGATIVE = 9029153835,
        POSITIVE = 9029153595,

        LEFT_BAR = 9029154259,
        RIGHT_BAR = 9029153226,
        BAR = 9029199322,

        FILLED = {
            LEFT_BAR = 9029166462,
            RIGHT_BAR = 9029166055,
            BAR = 9029176182
        },
    },

    SWITCH = {
        ON = 9029152293,
        OFF = 9029152584
    }
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- INITIALIZATION (STARTS)
------------------------

-- Creates settings interface.
local interface = InterfaceService.createScreen("settings", InterfaceService.VIEWPORTS.PC)

-- Creates background.
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

        Image = "rbxassetid://" .. asset_ids.BACKGROUND
    },

    BuildWith = {
        "AspectRatio"
    }
})

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
        BackgroundTransparency = 1,
        Active = true,

        Image = "rbxassetid://" .. asset_ids.BUTTON.EXIT
    },

    Events = {
        {
            Name = "click",
            Event = "InputBegan",
            Consumer = function(_binder, _event)
                if _event.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return
                end

                InterfaceService.delete("settings")
            end
        },
        {
            Name = "begin",
            Event = "InputBegan",
            Consumer = function(_binder, _event)
                if _event.UserInputType ~= Enum.UserInputType.MouseMovement then
                    return
                end
                local parent = _binder:getParent()
                local properties = parent:getProperties()
                local properties_custom = parent:getProperties().Custom
                local difference = (properties_custom.Size - (properties_custom.Size * 1.2)) / 2
                
                parent:updateProperties({
                    Custom = {
                        Position = Vector2.new(properties_custom.Position.X + difference.X, properties_custom.Position.Y + difference.Y),
                        Size = properties_custom.Size * 1.2
                    },
                    AnchorPoint = Vector2.new(0.5, 0.5),
                })

            end
        },
        {
            Name = "end",
            Event = "InputEnded",
            Consumer = function(_binder, _event)
                if _event.UserInputType ~= Enum.UserInputType.MouseMovement then
                    return
                end
                local parent = _binder:getParent()
                local properties = parent:getProperties()
                local properties_custom = parent:getProperties().Custom
                local difference = (properties_custom.Size - (properties_custom.Size / 1.2)) / 2
                
                parent:updateProperties({
                    Custom = {
                        Position = Vector2.new(properties_custom.Position.X + difference.X, properties_custom.Position.Y + difference.Y),
                        Size = properties_custom.Size / 1.2
                    },
                    AnchorPoint = Vector2.new(0.5, 0.5),
                })
            end
        }
    }
})

------------------------
-- INITIALIZATION (ENDS)
------------------------


-- ENDS
return class