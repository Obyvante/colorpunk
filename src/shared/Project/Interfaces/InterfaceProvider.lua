local class = {}
-- IMPORTS
local Player = game.Players.LocalPlayer
local Library = require(game.ReplicatedStorage.Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local EventService = Library.getService("EventService")
-- EVENTS
local OpenInterfaceEvent = EventService.get("OpenInterface")
-- STARTS


------------------------
-- IMPORTS (STARTS)
------------------------

-- Imports interfaces. (ORDER IS IMPORTANT!)
require(game.ReplicatedStorage.Project.Interfaces.InformativeInterface)
require(game.ReplicatedStorage.Project.Interfaces.GameInterface)
require(game.ReplicatedStorage.Project.Interfaces.SettingsInterface)
require(game.ReplicatedStorage.Project.Interfaces.SummaryInterface)

------------------------
-- IMPORTS (ENDS)
------------------------


------------------------
-- EVENTS (STARTS)
------------------------

class.OpenInterface = function(_id : string, _information : table)
    -- Declares required fields.
    local interface = InterfaceService.get(_id)

    -- Handles interfaces.
    if _id == "informative" then
        if _information.Title then
            interface:getElementByPath("body.title"):getInstance().Text = _information.Title
        end
        interface:getElementByPath("body.text"):getInstance().Text = _information.Message

        -- Binds interface to player gui.
        interface:bind(Player.PlayerGui)
    end
end

-- Listens event.
OpenInterfaceEvent.OnClientEvent:Connect(class.OpenInterface)

------------------------
-- EVENTS (ENDS)
------------------------



-- ENDS
return class