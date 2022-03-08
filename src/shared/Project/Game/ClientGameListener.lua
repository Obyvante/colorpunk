local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local InterfaceService = Library.getService("InterfaceService")
-- EVENTS
local Q = EventService.get("PlayerSettings")
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

Q.OnClientEvent:Connect(function(_packet)
    --local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
    --ClientPlayer.getSettings().handlePacket(_packet)
end)

------------------------
-- SETTINGS (ENDS)
------------------------


-- ENDS
return class