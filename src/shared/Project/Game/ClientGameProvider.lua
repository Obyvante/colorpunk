local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local TaskService = Library.getService("TaskService")
local NumberService = Library.getService("NumberService")
local StringService = Library.getService("StringService")
-- STARTS


------------------------
-- INITIALIZATION (STARTS)
------------------------


------------------------
-- IMPORTS (STARTS)
------------------------

-- Loads client player listener.
require(game.ReplicatedStorage.Project.Game.ClientGame)
require(game.ReplicatedStorage.Project.Game.ClientGameListener)

------------------------
-- IMPORTS (ENDS)
------------------------


------------------------
-- INTERFACES (STARTS)
------------------------

-- Imports interfaces. (ORDER IS IMPORTANT!)
--require(game.ReplicatedStorage.Project.Game.Interfaces.GameMatchOfferInterface)

------------------------
-- INTERFACES (ENDS)
------------------------


------------------------
-- INITIALIZATION (ENDS)
------------------------


------------------------
-- TEST (START)
------------------------

local client_game = require(game.ReplicatedStorage.Project.Game.Pist.GamePist)
local pist

local UserInputService = game:GetService("UserInputService")
UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Q then
        client_game.reset()
    elseif input.KeyCode == Enum.KeyCode.R then
        local childs = game.ReplicatedStorage.Pists:GetDescendants()
        pist = childs[math.random(1, #childs)]
        client_game.load(pist.Name)
    elseif input.KeyCode == Enum.KeyCode.T then
        client_game.whitelist({
            pist_id = pist.Name,
            brick_color = "Really red"
        })
    end
end)

--[[
local childs = game.ReplicatedStorage.Pists:GetDescendants()
TaskService.createRepeating(0.5, function(_task)
    client_game.load(childs[math.random(1, #childs)].Name)
end):run()
]]

------------------------
-- TEST (ENDS)
------------------------



-- ENDS
return class