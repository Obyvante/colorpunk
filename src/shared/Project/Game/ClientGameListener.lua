local class = {}
-- IMPORTS
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local ClientGame = require(script.Parent.ClientGame)
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local InterfaceService = Library.getService("InterfaceService")
-- EVENTS
local GameStateEvent = EventService.get("GameState")
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

GameStateEvent.OnClientEvent:Connect(function(_state : string, _information : table)
    ClientGame.applyState(_state, _information)
end)

------------------------
-- SETTINGS (ENDS)
------------------------


-- ENDS
return class