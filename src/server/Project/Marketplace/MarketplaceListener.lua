local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
-- EVENTS
local TestCallbackEvent = EventService.get("TestCallback")
local InterfaceOpenEvent = EventService.get("Interface.InterfaceOpen")
local InterfaceActionEvent = EventService.get("Interface.InterfaceAction")
local PlayerService = game:GetService("Players")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.Locations = {
    Pedestals = {
        MoneyBoosterBoundingBox = game.Workspace.World.Lobby.Pedestal.Right["1"]["Bound Box"]
    }
}

class.Touchs = {}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- METHODS (STARTS)
------------------------

function class.touchStarted(_part : BasePart, _id : string)
    -- Gets player from its character.
    local player = PlayerService:GetPlayerFromCharacter(_part)
    if player == nil then return end

    -- Safety check.
    if class.Touchs[player.UserId] then return end

    -- Marks player currently touching.
    class.Touchs[player.UserId] = _id

    if _id == "MONEY_BOOSTER" then
        print("a")
        InterfaceOpenEvent:FireClient(player, "agreement", {
            ActionId = "PRODUCT_MONEY_BOSSTER",
            Title = [[SHOP]],
            Message =
[[
The money you've earned at the end of
the game will be doubled.

Would you like to buy?
]]
        })
    end
end

function class.touchEnded(_part : BasePart)
    -- Gets player from its character.
    local player = PlayerService:GetPlayerFromCharacter(_part)
    if player == nil then return end

    -- Removes player from the touching list.
    class.Touchs[player.UserId] = nil

    print("ended")
end

------------------------
-- METHODS (ENDS)
------------------------


------------------------
-- EVENTS (STARTS)
------------------------

class.Locations.Pedestals.MoneyBoosterBoundingBox.Touched:Connect(function(_part : BasePart)
    class.touchStarted(_part.Parent, "MONEY_BOOSTER")
end)


class.Locations.Pedestals.MoneyBoosterBoundingBox.TouchEnded:Connect(function(_part : BasePart)
    class.touchEnded(_part.Parent)
end)

------------------------
-- EVENTS (ENDS)
------------------------


TestCallbackEvent.OnServerEvent:Connect(function(_player)
    InterfaceOpenEvent:FireClient(_player, "agreement", {
        ActionId = "PRODUCT_MONEY_BOSSTER",
        Title = [[SHOP]],
        Message =
[[
The money you've earned at the end of
the game will be doubled.

Would you like to buy?
]]
    })
end)

return class