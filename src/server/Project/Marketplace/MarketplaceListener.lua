local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
-- EVENTS
local InterfaceOpenEvent = EventService.get("Interface.InterfaceOpen")
local ProximityPromptService = game:GetService("ProximityPromptService")
-- STARTS


ProximityPromptService.PromptTriggered:Connect(function(prompt, playerWhoTriggered)
    if prompt.Name == "MONEY_BOOSTER" then
        InterfaceOpenEvent:FireClient(playerWhoTriggered, "agreement", {
            ActionId = "PRODUCT_" .. prompt.Name,
            Title = [[SHOP]],
            Message =
[[
The money you've earned at the end of
the game will be doubled.

Would you like to buy?
]]
        })
    elseif prompt.Name == "FORESEEING_GOGGLES" then
        InterfaceOpenEvent:FireClient(playerWhoTriggered, "agreement", {
            ActionId = "PRODUCT_" .. prompt.Name,
            Title = [[SHOP]],
            Message =
[[
The blocks you have to stand on in the arena
will be more visible.

Would you like to buy?
]]
        })
    elseif prompt.Name == "SPEED_AND_JUMP_BOOSTER" then
        InterfaceOpenEvent:FireClient(playerWhoTriggered, "agreement", {
            ActionId = "PRODUCT_" .. prompt.Name,
            Title = [[SHOP]],
            Message =
[[
Your movement speed and jump height will
be increased by 50%.

Would you like to buy?
]]
        })
    elseif prompt.Name == "JUMP_BOOSTER" then
        InterfaceOpenEvent:FireClient(playerWhoTriggered, "agreement", {
            ActionId = "PRODUCT_" .. prompt.Name,
            Title = [[SHOP]],
            Message =
[[
Your jump height will be increased by
50% permanently.

Would you like to buy?
]]
        })
    elseif prompt.Name == "SPEED_BOOSTER" then
        InterfaceOpenEvent:FireClient(playerWhoTriggered, "agreement", {
            ActionId = "PRODUCT_" .. prompt.Name,
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