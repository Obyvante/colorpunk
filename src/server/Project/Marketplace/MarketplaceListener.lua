local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local PlayerProvider = Library.getService("PlayerProvider")
local CoolDownService = Library.getService("CoolDownService")
local SpamService = Library.getService("SpamService")
-- EVENTS
local InterfaceOpenEvent = EventService.get("Interface.InterfaceOpen")
local ProximityPromptService = game:GetService("ProximityPromptService")
-- STARTS


ProximityPromptService.PromptTriggered:Connect(function(prompt, _player)
    -- Declares required fields.
    local player = PlayerProvider.find(_player.UserId)
    if player == nil then return end

    -- Declares required fields.
    local _name = prompt.Name
    local _products = player:getInventory():getProduct()
    local _speed = _products:has(1248410518)
    local _jump = _products:has(1248410451)

    -- Handles prompt name
    if _name == "Speed and Jump Booster" then
        if _speed and not _jump then
            _name = "Jump Booster"
        elseif not _speed and _jump then
            _name = "Speed Booster"
        end
    end

    -- Handles prompts.
    if _name == "Money Booster" then
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
    elseif _name == "Foreseeing Goggles" then
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
    elseif _name == "Speed and Jump Booster" then
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
    elseif _name == "Jump Booster" then
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
    elseif _name == "Speed Booster" then
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