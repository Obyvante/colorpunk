local class = {}
-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local TableService = Library.getService("TableService")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

-- Interface asset ids.
class.Content = {
    Pets = {
        Premium = {
            THE_MASK = 9114852125,
            SHARK = 9114853914,
            COWBOY = 9114857071,
            MR_COW = 9114858744,
            CASPER = 9114855439
        },
        Free = {
            BEE = 9114996090,
            BAT = 9114998180,
            BLUE_BULL = 9115000759,
            CAT = 9115002486,
            DEER = 9115004442
        }
    }
}

------------------------
-- VARIABLES (ENDS)
------------------------


function class.create(_parent : Instance, _prompt : ProximityPrompt, _content : table)
    -- Handles existed interface.
    local interface = InterfaceService.get("prompt_content_" .. _prompt.Name)
    if interface then return interface end

    -- Creates prompt interface.
    interface = InterfaceService.createBillboard("prompt_content_" .. _prompt.Name, Vector2.new(680, 775), {
        Adornee = _parent,
        Size = UDim2.fromScale(12, 13.56),
        StudsOffset = Vector3.new(0, 10, 0),
        AlwaysOnTop = true
    })

    -- Creates body.
    local body = interface:addElement({
        Name = "body",
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Size = Vector2.new(680, 775),
                Position = Vector2.new(0, 0)
            },
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            Image = "rbxassetid://9001118772"
        }
    })

    local X = 73
    local Y = 83
    local current = 1
    
    local _size = TableService.size(_content)
    local _values = TableService.values(_content)
    for row = 1, 3, 1 do
        for column = 1, 3, 1 do
            if current > _size then break end

            body:addElement({
                Name = "box_" .. current,
                Type = "ImageLabel",
                Properties = {
                    Custom = {
                        Position = Vector2.new(X + ((column - 1) * 181), Y + ((row - 1) * 177)),
                        Size = Vector2.new(173, 173)
                    },
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
        
                    Image = "rbxassetid://" .. _values[current]
                }
            })
            current += 1
        end
    end
    return interface
end


-- ENDS
return class