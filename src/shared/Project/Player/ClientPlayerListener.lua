local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local InterfaceService = Library.getService("InterfaceService")
-- EVENTS
local PlayerSettingsEvent = EventService.get("PlayerSettings")
local PlayerStatsEvent = EventService.get("PlayerStats")
local PlayerCurrenciesEvent = EventService.get("PlayerCurrencies")
local PlayerStatisticsEvent = EventService.get("PlayerStatistics")
local PlayerRankEvent = EventService.get("PlayerRank")
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
end)

------------------------
-- STATS (ENDS)
------------------------


------------------------
-- CURRENCIES (STARTS)
------------------------

PlayerCurrenciesEvent.OnClientEvent:Connect(function(_packet)
    local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
    ClientPlayer.getCurrencies().handlePacket(_packet)
end)

------------------------
-- CURRENCIES (ENDS)
------------------------


------------------------
-- STATISTICS (STARTS)
------------------------

PlayerStatisticsEvent.OnClientEvent:Connect(function(_packet)
    local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
    ClientPlayer.getStatistics().handlePacket(_packet)
end)

------------------------
-- STATISTICS (ENDS)
------------------------


------------------------
-- SERVER STATE (STARTS)
------------------------

PlayerRankEvent.OnClientEvent:Connect(function(_rank)
    local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
    ClientPlayer.setRank(_rank)
end)

------------------------
-- SERVER STATE (ENDS)
------------------------


-- ENDS
return class