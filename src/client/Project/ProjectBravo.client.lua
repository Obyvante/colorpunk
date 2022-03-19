-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local EventService = Library.getService("EventService")
-- EVENTS
local PlayerLoadCompleteEvent = EventService.get("Player.PlayerLoadComplete")
-- TIMER
local time = os.time()


------------------------
-- FIRST LOGIN LOADING (STARTS)
------------------------

-- Loads interface first.
local interface_load = require(script.Parent.Load.InterfaceLoad)

-- Loads game.
if not game.Loaded then game.Loaded:Wait() end

-- Loads character.
require(script.Parent.Load.CharacterLoad)

-- Loads assets.
require(script.Parent.Load.AssetsLoad)

-- Loads player.
require(script.Parent.Load.PlayerLoad)
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)

-- Starts warning screen.
if ClientPlayer.getSettings().asBoolean("SKIP_WARNING_SCREEN") then interface_load.startWarning() end

------------------------
-- FIRST LOGIN LOADING (ENDS)
------------------------


------------------------
-- SERVICE SAVING (STARTS)
------------------------

require(game.ReplicatedStorage.Project.Locations.AssetLocation)
Library.saveService(game.ReplicatedStorage.Project.Locations.AssetLocation)

------------------------
-- SERVICE SAVING (ENDS)
------------------------


------------------------
-- IMPORTS (STARTS)
------------------------

require(game.ReplicatedStorage.Project.Interfaces.InterfaceProvider)
local ClientPlayerProvider = require(game.ReplicatedStorage.Project.Player.ClientPlayerProvider)
require(game.ReplicatedStorage.Project.Server.ClientServerProvider)
require(game.ReplicatedStorage.Project.Game.ClientGameProvider)
require(game.ReplicatedStorage.Project.Cosmetics.ClientCosmeticsHandler)
require(game.ReplicatedStorage.Project.Music.MusicPlayer)

-- Loads default interfaces.
ClientPlayerProvider.loadDefaultInterfaces()

------------------------
-- IMPORTS (ENDS)
------------------------


------------------------
-- LAST CHECK (STARTS)
------------------------

-- Last think to inform server that player is fully loaded.
PlayerLoadCompleteEvent:FireServer()

-- Destroys interface.
interface_load.destroy()

------------------------
-- LAST CHECK (ENDS)
------------------------


-- Informs client.
print("✔️ DONE! (", os.time() - time, ")")