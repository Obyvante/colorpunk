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

require(game.ReplicatedStorage.Project.Player.Settings.Interface.PlayerSettingsInterface)
require(game.ReplicatedStorage.Project.Player.Interfaces.PlayerGameInterface)
local InterfaceService = Library.getService("InterfaceService")

local PlayerSettingsInterface = InterfaceService.get("settings")
local PlayerGameInterface = InterfaceService.get("game")

PlayerSettingsInterface:bind(game.Players.LocalPlayer.PlayerGui)
PlayerGameInterface:bind(game.Players.LocalPlayer.PlayerGui)

game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Q then
        if PlayerSettingsInterface:isBound() then
            PlayerSettingsInterface:unbind()
        else
            PlayerSettingsInterface:bind(game.Players.LocalPlayer.PlayerGui)
        end
        return
    else
        if input.KeyCode == Enum.KeyCode.R then
            if PlayerGameInterface:isBound() then
                PlayerGameInterface:unbind()
            else
                PlayerGameInterface:bind(game.Players.LocalPlayer.PlayerGui)
            end
            return
        end
    end
end)

------------------------
-- TEST (ENDS)
------------------------