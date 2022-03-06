-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)

-- TIMER
local time = os.time()
------------------------
-- API CALLS AND IMPORTS (STARTS)
------------------------

task.spawn(function()
    for i = 1, 10, 1 do
        print(game.Workspace.CurrentCamera.ViewportSize)
        task.wait(0.1)
    end
end)

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
-- TODO: it is for skipipping warning more faster.
--interface_load.startWarning()
interface_load.destroy()

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

require(game.ReplicatedStorage.Project.Player.Settings.Interface.Interface)
local InterfaceService = Library.getService("InterfaceService")
InterfaceService.get("settings"):bind(game.Players.LocalPlayer.PlayerGui)

------------------------
-- TEST (ENDS)
------------------------