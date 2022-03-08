-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)

-- TIMER
local time = os.time()
------------------------
-- API CALLS AND IMPORTS (STARTS)
------------------------

-- Loads interface first.
local interface_load = require(script.Parent.Load.InterfaceLoad)

-- Loads game.
if not game.Loaded then game.Loaded:Wait() end

-- Loads assets.
--local asset_load = require(script.Parent.Load.AssetsLoad)
-- Loads character.
local character_load = require(script.Parent.Load.CharacterLoad)

-- Loads player.
local player_load = require(script.Parent.Load.PlayerLoad)
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local ClientPlayerProvider = require(game.ReplicatedStorage.Project.Player.ClientPlayerProvider)

-- Starts warning screen.
if ClientPlayer.getSettings().asBoolean("SKIP_WARNING_SCREEN") then interface_load.startWarning() end
-- Destroys interface.
interface_load.destroy()

-- Loads default interfaces.
ClientPlayerProvider.loadDefaultInterfaces()

------------------------
-- API CALLS AND IMPORTS (ENDS)
------------------------


------------------------
-- DESTROY AND BE READY (STARTS)
------------------------

print("✔️ DONE!")

------------------------
-- DESTROY AND BE READY (ENDS)
------------------------


------------------------
-- TEST (STARTS)
------------------------



------------------------
-- TEST (ENDS)
------------------------