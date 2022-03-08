local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local InterfaceService = Library.getService("InterfaceService")
-- EVENTS
local PlayerSettingsEvent = EventService.get("PlayerSettings")
local PlayerStatsEvent = EventService.get("PlayerStats")
-- STARTS


------------------------
-- AUTOMATION (STARTS)
------------------------
------------------------
-- AUTOMATION (ENDS)
------------------------


------------------------
-- SETTINGS (STARTS)
------------------------

PlayerSettingsEvent.OnClientEvent:Connect(function(_packet)
    local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
    ClientPlayer.getSettings().handlePacket(_packet)
end)

------------------------
-- SETTINGS (ENDS)
------------------------


------------------------
-- STATS (STARTS)
------------------------

PlayerStatsEvent.OnClientEvent:Connect(function(_packet)
    local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
    ClientPlayer.getStats().handlePacket(_packet)
    print("update!")
end)

------------------------
-- STATS (ENDS)
------------------------


-- ENDS
return class