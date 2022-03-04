-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)


------------------------
-- API CALLS AND IMPORTS (STARTS)
------------------------

-- Loads interface first.
local interface_load = require(script.Parent.Load.InterfaceLoad)

-- Loads game.
if not game.Loaded then game.Loaded:Wait() end

-- Loads player.
local player_load = require(script.Parent.Load.PlayerLoad)
-- Loads assets.
local asset_load = require(script.Parent.Load.AssetsLoad)

-- Starts warning screen.
interface_load.startWarning()

------------------------
-- API CALLS AND IMPORTS (ENDS)
------------------------


------------------------
-- DESTROY AND BE READY (STARTS)
------------------------

interface_load.destroy()

--interface_load.destroy()

print("READY!")

------------------------
-- DESTROY AND BE READY (ENDS)
------------------------