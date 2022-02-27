-- PATHS
local PATHS = {
    [1] = game.ServerScriptService.Project.Cosmetics.Pet.PetProvider,
    [2] = game.ServerScriptService.Project.Cosmetics.Trail.TrailProvider,
    [3] = game.ServerScriptService.Project.Player.PlayerProvider
}
local PATH_SIZE = 3

-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)


----------
-- INITIALIZATION
----------

-- Saves custom services.
for i = 1, PATH_SIZE, 1 do Library.saveService(PATHS[i]) end

-- Initializes required paths.
-- It is after saving services since we are not sure which one
-- can throw error.
for i = 1, PATH_SIZE, 1 do require(PATHS[i]) end