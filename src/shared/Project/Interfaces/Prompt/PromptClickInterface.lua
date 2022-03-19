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
    BUTTON_E = 9114490466,
    BUTTON_CLICK = 9114490655
}

------------------------
-- VARIABLES (ENDS)
------------------------


function class.create(_parent : Instance, _prompt : ProximityPrompt, _input : Enum)
    -- Handles existed interface.
    local interface = InterfaceService.get("prompt_click_" .. _prompt.Name)
    if interface then return interface end

    -- Creates prompt interface.
    interface = InterfaceService.createBillboard("prompt_click_" .. _prompt.Name, Vector2.new(680, 775), {
        Adornee = _parent,
        Size = UDim2.fromScale(7.5, 7.5),
        StudsOffset = Vector3.new(0, -3, 0),
        AlwaysOnTop = true,
        Active = true
    })

    -- Button.
    interface:addElement({
        Name = "button",
        Type = "ImageButton",
        Properties = {
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0,
            Active = true,

            Image = "rbxassetid://" .. (_input == Enum.ProximityPromptInputType.Keyboard and asset_ids.BUTTON_E or asset_ids.BUTTON_CLICK)
        },

        Events = {
            {
                Name = "click_began",
                Event = "InputBegan",
                Consumer = function(_binder, _event)
                    if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end
                    _prompt:InputHoldBegin()
                end
            },
            {
                Name = "click_ended",
                Event = "InputBegan",
                Consumer = function(_binder, _event)
                    if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end
                    _prompt:InputHoldEnd()
                end
            }
        }
    })

    return interface
end


-- ENDS
return class