-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local EventService = Library.getService("EventService")
-- EVENTS
local PlayerLoadCompleteEvent = EventService.get("PlayerLoadComplete")
local TestCallbackEvent = EventService.get("TestCallback")
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
-- IMPORTS (STARTS)
------------------------

require(game.ReplicatedStorage.Project.Player.ClientPlayerProvider)
require(game.ReplicatedStorage.Project.Server.ClientServerProvider)
require(game.ReplicatedStorage.Project.Game.ClientGameProvider)

------------------------
-- IMPORTS (ENDS)
------------------------


-- Last think to inform server that player is fully loaded.
PlayerLoadCompleteEvent:FireServer()

-- Destroys interface.
interface_load.destroy()

-- Informs client.
print("✔️ DONE! (", os.time() - time, ")")


------------------------
-- TEST (STARTS)
------------------------

local sound = Instance.new("Sound", game.Workspace)
sound.SoundId = "rbxassetid://9059061304"
sound.Looped = true
sound:Play()

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Q then
        TestCallbackEvent:FireServer()
    elseif input.KeyCode == Enum.KeyCode.R then
        InterfaceService.get("summary"):bind(game.Players.LocalPlayer.PlayerGui)
    end
end)

------------------------
-- TEST (ENDS)
------------------------