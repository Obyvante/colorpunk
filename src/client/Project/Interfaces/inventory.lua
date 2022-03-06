local class = {}
-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local TaskService = Library.getService("TaskService")
-- STARTS


-- Interface asset ids.
local asset_ids = {
    BACKGROUND = 9014863981,
    BODY = 9014862981,
    BUTTON = {
        EXIT = 9014862110,
        FOOTER = 9014861779,

        BODY = {
            NORMAL = 9014862981,
            GOLD = 9014862668
        }
    },

    ICON = {
        PARTICLES = 9015392994,
        FEET = 9015728865,
        PET = 9015728507,
        UNEQUIP = 9015727900,
        TRASH = 9015728213
    }
}

local interface = InterfaceService.createScreen("inventory", InterfaceService.VIEWPORTS.PC)

local background = interface:addElement({
    Name = "background",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(655, 360),
            Size = Vector2.new(2530, 1440)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0.1,

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
            Position = Vector2.new(610, 42),
            Size = Vector2.new(1279, 170),
            FontSize = 175
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "INVENTORY: PETS",
    }
})

local button_exit = background:addElement({
    Name = "button_exit",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(2304, 47),
            Size = Vector2.new(160, 160)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,

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

                InterfaceService.delete("inventory")
            end
        }
    }
})

local body = background:addElement({
    Name = "body",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(0, 256),
            Size = Vector2.new(2528, 872),

            Scroll = {
                Height = 248 * (4 - 3),
                Factory = 70,
                
                Bar = {
                    Position = Vector2.new(2487, 275),
                    Size = Vector2.new(33, 832),
                    Image = "rbxassetid://9024031274"
                },

                Button = {
                    Position = Vector2.new(8, 9),
                    Size = Vector2.new(16, 0),
                }
            }
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Active = true
    }
})

function createButton(_slot : number, _position : Vector2)
    body:addElement({
        Name = "button_body_normal_" .. _slot,
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(250, 251)
            },
    
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
    
            Image = "rbxassetid://" .. asset_ids.BUTTON.BODY.NORMAL
        }
    })
end

function createFooterButton(_slot : number, _position : Vector2)
    return background:addElement({
        Name = "button_footer_" .. _slot,
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(252, 256)
            },
    
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
    
            Image = "rbxassetid://" .. asset_ids.BUTTON.FOOTER
        }
    })
end

local total = 0
for row = 1, 5, 1 do
    local height = (row - 1) * 248
    for slot = 1, 9, 1 do
        createButton(total, Vector2.new(90 + ((slot - 1) * 260), 62 + height))
        total += 1
    end
end

createFooterButton(1, Vector2.new(863, 1159)):addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(49, 45),
            Size = Vector2.new(155, 158)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.PARTICLES
    }
})

createFooterButton(2, Vector2.new(1123, 1159)):addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(38, 40),
            Size = Vector2.new(177, 177)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.FEET
    }
})

createFooterButton(3, Vector2.new(1383, 1159)):addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(43, 52),
            Size = Vector2.new(167, 152)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.PET
    }
})

createFooterButton(4, Vector2.new(1907, 1159)):addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(34, 52),
            Size = Vector2.new(184, 153)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.UNEQUIP
    }
})

createFooterButton(5, Vector2.new(2164, 1159)):addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(59, 52),
            Size = Vector2.new(134, 152)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.TRASH
    }
})

function class.equip()
    interface:bind(game.Players.LocalPlayer.PlayerGui)
end


-- ENDS
return class