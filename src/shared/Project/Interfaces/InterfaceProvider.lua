local class = {}
-- IMPORTS
local Player = game.Players.LocalPlayer
local Library = require(game.ReplicatedStorage.Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local EventService = Library.getService("EventService")
local NumberService = Library.getService("NumberService")
-- EVENTS
local InterfaceOpenEvent = EventService.get("Interface.InterfaceOpen")
-- STARTS


------------------------
-- IMPORTS (STARTS)
------------------------

-- Imports interfaces. (ORDER IS IMPORTANT!)
require(game.ReplicatedStorage.Project.Interfaces.InformativeInterface)
require(game.ReplicatedStorage.Project.Interfaces.GameInterface)
require(game.ReplicatedStorage.Project.Interfaces.SettingsInterface)
require(game.ReplicatedStorage.Project.Interfaces.InventoryInterface)
require(game.ReplicatedStorage.Project.Interfaces.AgreementInterface)
require(game.ReplicatedStorage.Project.Interfaces.SummaryInterface)

------------------------
-- IMPORTS (ENDS)
------------------------


------------------------
-- EVENTS (STARTS)
------------------------

class.InterfaceOpen = function(_id : string, _information : table)
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
    elseif _id == "summary" then
        interface:getElementByPath("body.ROUND_PLAYED.value"):getInstance().Text = _information.ROUND_PLAYED
        interface:getElementByPath("body.GOLD_EARNED.value"):getInstance().Text = NumberService.format(_information.GOLD_EARNED)
        interface:getElementByPath("body.RANK.value"):getInstance().Text = _information.RANK

        -- Binds interface to player gui.
        interface:bind(Player.PlayerGui)
    elseif _id == "agreement" then
        -- Declares required fields.
        local _metadata = interface:getMetadata()

        if _information.Title then
            interface:getElementByPath("panel.title"):getInstance().Text = _information.Title
        end
        interface:getElementByPath("panel.text"):getInstance().Text = _information.Message

        -- Handles action id.
        if _information.ActionId then
            _metadata:set("action:id", _information.ActionId)
        else
            _metadata:remove("action:id")
        end

        -- Binds interface to player gui.
        interface:bind(Player.PlayerGui)
    end
end

-- Listens event.
InterfaceOpenEvent.OnClientEvent:Connect(class.InterfaceOpen)

------------------------
-- EVENTS (ENDS)
------------------------



-- ENDS
return class