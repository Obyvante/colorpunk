local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local TaskService = Library.getService("TaskService")
local NumberService = Library.getService("NumberService")
local StringService = Library.getService("StringService")
-- STARTS


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



-- ENDS
return class