-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)

-- TIMER
local time = os.time()
------------------------
-- API CALLS AND IMPORTS (STARTS)
------------------------

-- Loads interface first.
local interface_load = require(script.Parent.Load.InterfaceLoad)
-- Loads player.
local player_load = require(script.Parent.Load.PlayerLoad)

-- Loads game.
if not game.Loaded then game.Loaded:Wait() end

-- Loads assets.
--local asset_load = require(script.Parent.Load.AssetsLoad)
-- Loads character.
local character_load = require(script.Parent.Load.CharacterLoad)

-- Starts warning screen.
interface_load.startWarning()

------------------------
-- API CALLS AND IMPORTS (ENDS)
------------------------


------------------------
-- DESTROY AND BE READY (STARTS)
------------------------

print("✔️ DONE!")

local inventory = require(script.Parent.Interfaces.inventory)
inventory.equip()

------------------------
-- DESTROY AND BE READY (ENDS)
------------------------