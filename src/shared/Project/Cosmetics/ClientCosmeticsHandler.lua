local class = {}
-- IMPORTS
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local CaseAnimation = require(game.ReplicatedStorage.Project.Animations.CaseAnimation)
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
-- EVENTS
local CosmeticCaseOpenEvent = EventService.get("Cosmetics.CosmeticCaseOpen")
-- STARTS

------------------------
-- EVENTS (STARTS)
------------------------

CosmeticCaseOpenEvent.OnClientEvent:Connect(function(_information : table)
    CaseAnimation.startEggAnimation(_information.Type, _information.Name, _information.Id)
end)

------------------------
-- EVENTS (ENDS)
------------------------


-- ENDS
return class