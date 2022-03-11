------------------------
-- VARIABLES (STARTS)
------------------------
local time = os.time()

local PATHS = {
    [1] = game.ServerScriptService.Project.Cosmetics.Pet.PetProvider,
    [2] = game.ServerScriptService.Project.Cosmetics.Trail.TrailProvider,
    [3] = game.ServerScriptService.Project.Player.PlayerProvider,
    [4] = game.ServerScriptService.Project.Marketplace.Marketplace,
    [5] = game.ServerScriptService.Project.Leaderboard.LeaderboardProvider,
    [6] = game.ServerScriptService.Project.Server.Server
}
local PATH_SIZE = 6

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- IMPORTS (STARTS)
------------------------

local Library = require(game.ReplicatedStorage.Library.Library)

-- Saves custom services.
for i = 1, PATH_SIZE, 1 do Library.saveService(PATHS[i]) end

-- Initializes required paths.
-- It is after saving services since we are not sure which one
-- can throw error.
for i = 1, PATH_SIZE, 1 do require(PATHS[i]) end

-- Imports game.
require(script.Parent.Game.Game)

------------------------
-- IMPORTS (ENDS)
------------------------


print("✔️ Colorpunk server has been initialized in", os.time() - time, "ms!")