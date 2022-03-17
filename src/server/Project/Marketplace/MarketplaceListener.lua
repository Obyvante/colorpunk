local class = {}
-- IMPORTS
local ProductOpenAnimation = require(game.ServerScriptService.Project.Animations.ProductOpenAnimation)
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local PlayerProvider = Library.getService("PlayerProvider")
-- EVENTS
local InterfaceOpenEvent = EventService.get("Interface.InterfaceOpen")
local ProximityPromptService = game:GetService("ProximityPromptService")
-- STARTS


ProximityPromptService.PromptTriggered:Connect(function(prompt, _player)
    -- Declares required fields.
    local player = PlayerProvider.find(_player.UserId)
    if player == nil then return end


    if prompt.Name == "PREMIUM_EGG" or prompt.Name == "BASIC_EGG" then
        ProductOpenAnimation.start(_player, {})
    end

    -- Declares required fields.
    local _name = prompt.Name
    local _products = player:getInventory():getProduct()
    local _speed = _products:has(1248410518)
    local _jump = _products:has(1248410451)

    -- Handles prompt name
    if _name == "SPEED_AND_JUMP_BOOSTER" then
        if _speed and not _jump then
            _name = "JUMP_BOOSTER"
        elseif not _speed and _jump then
            _name = "SPEED_BOOSTER"
        end
    end

    -- Handles prompts.
    if _name == "MONEY_BOOSTER" then
        InterfaceOpenEvent:FireClient(_player, "agreement", {
            ActionId = "PRODUCT_" .. _name,
            Title = [[SHOP]],
            Message =
[[
The money you've earned at the end of
the game will be doubled.

Would you like to buy?
]]
        })
    elseif _name == "FORESEEING_GOGGLES" then
        InterfaceOpenEvent:FireClient(_player, "agreement", {
            ActionId = "PRODUCT_" .. _name,
            Title = [[SHOP]],
            Message =
[[
The blocks you have to stand on in the arena
will be more visible.

Would you like to buy?
]]
        })
    elseif _name == "SPEED_AND_JUMP_BOOSTER" then
        InterfaceOpenEvent:FireClient(_player, "agreement", {
            ActionId = "PRODUCT_" .. _name,
            Title = [[SHOP]],
            Message =
[[
Your movement speed and jump height will
be increased by 50%.

Would you like to buy?
]]
        })
    elseif _name == "JUMP_BOOSTER" then
        InterfaceOpenEvent:FireClient(_player, "agreement", {
            ActionId = "PRODUCT_" .. _name,
            Title = [[SHOP]],
            Message =
[[
Your jump height will be increased by
50% permanently.

Would you like to buy?
]]
        })
    elseif _name == "SPEED_BOOSTER" then
        InterfaceOpenEvent:FireClient(_player, "agreement", {
            ActionId = "PRODUCT_" .. _name,
            Title = [[SHOP]],
            Message =
[[
Your movement speed will be increased by
50% permanently.

Would you like to buy?
]]
        })
    end
end)


-- ENDS
return class