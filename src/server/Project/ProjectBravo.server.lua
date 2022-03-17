------------------------
-- VARIABLES (STARTS)
------------------------
local time = os.time()

local PATHS = {
    game.ServerScriptService.Project.Cosmetics.Pet.PetProvider,
    game.ServerScriptService.Project.Cosmetics.Trail.TrailProvider,
    game.ServerScriptService.Project.Cosmetics.Case.CaseProvider,
    game.ServerScriptService.Project.Cosmetics.CosmeticProvider,
    game.ServerScriptService.Project.Product.ProductProvider,
    game.ServerScriptService.Project.Player.PlayerProvider,
    game.ServerScriptService.Project.Marketplace.Marketplace,
    game.ServerScriptService.Project.Leaderboard.LeaderboardProvider,
    game.ServerScriptService.Project.Statistics.StatisticsProvider,
    game.ServerScriptService.Project.Transaction.Transaction,
    game.ServerScriptService.Project.Server.Server
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- IMPORTS (STARTS)
------------------------

local Library = require(game.ReplicatedStorage.Library.Library)

-- Saves custom services.
for i = 1, #PATHS, 1 do Library.saveService(PATHS[i]) end

-- Initializes required paths.
-- It is after saving services since we are not sure which one
-- can throw error.
for i = 1, #PATHS, 1 do require(PATHS[i]) end

-- Imports game.
require(script.Parent.Game.Game)

------------------------
-- IMPORTS (ENDS)
------------------------

-- Informs server.
print("✔️ Colorpunk server has been initialized in", os.time() - time, "ms!")

-- Statistics
Library.getService("StatisticsProvider").addGame("ROBLOX_SERVER_OPEN_DURATION", os.time() - time)