-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local EventService = Library.getService("EventService")
-- EVENTS
local PlayerLoadEvent = EventService.get("PlayerLoad")
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
local PlayerLoad = require(script.Parent.Load.PlayerLoad)
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local ClientPlayerProvider = require(game.ReplicatedStorage.Project.Player.ClientPlayerProvider)

-- Starts warning screen.
if ClientPlayer.getSettings().asBoolean("SKIP_WARNING_SCREEN") then interface_load.startWarning() end

-- Loads default interfaces.
ClientPlayerProvider.loadDefaultInterfaces()

------------------------
-- API CALLS AND IMPORTS (ENDS)
------------------------


------------------------
-- GAME (STARTS)
------------------------

-- Loads client game provider.
require(game.ReplicatedStorage.Project.Game.ClientGameProvider)

------------------------
-- GAME (ENDS)
------------------------

-- Last think to inform server that player is fully loaded.
PlayerLoadEvent:FireServer()

-- Destroys interface.
interface_load.destroy()

-- Informs client.
print("✔️ DONE! (", os.time() - time, ")")


------------------------
-- TEST (STARTS)
------------------------



------------------------
-- TEST (ENDS)
------------------------