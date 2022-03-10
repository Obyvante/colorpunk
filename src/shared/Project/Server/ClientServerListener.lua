local class = {}
-- IMPORTS
local ClientServer = require(game.ReplicatedStorage.Project.Server.ClientServer)
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local InterfaceService = Library.getService("InterfaceService")
-- EVENTS
local ServerStateEvent = EventService.get("ServerState")
-- STARTS


------------------------
-- SERVER STATE (STARTS)
------------------------

ServerStateEvent.OnClientEvent:Connect(function(_state)
    -- Updates server state.
    ClientServer.Active = _state
end)

------------------------
-- SERVER STATE (ENDS)
------------------------


-- ENDS
return class