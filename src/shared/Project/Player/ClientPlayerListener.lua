local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local InterfaceService = Library.getService("InterfaceService")
-- EVENTS
local PlayerUpdateEvent = EventService.get("Player.PlayerUpdate")
-- STARTS


PlayerUpdateEvent.OnClientEvent:Connect(function(_type : string, _packet : string)
    -- Declares required fields.
    local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)

    -- Handles types.
    if _type == "settings" then
        ClientPlayer.getSettings().handlePacket(_packet)
    elseif _type == "stats" then
        ClientPlayer.getStats().handlePacket(_packet)
    elseif _type == "currencies" then
        ClientPlayer.getCurrencies().handlePacket(_packet)
    elseif _type == "statistics" then
        ClientPlayer.getStatistics().handlePacket(_packet)
    elseif _type == "rank" then
        ClientPlayer.setRank(_packet)
    elseif _type == "INVENTORY_PRODUCT" then
        ClientPlayer.getInventory().getProduct().update(ClientPlayer, _packet)
    elseif _type == "INVENTORY_PET" then
        ClientPlayer.getInventory().getPet().update(ClientPlayer, _packet)
    end
end)


-- ENDS
return class