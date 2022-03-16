local class = {}
-- IMPORTS
local ClientServer = require(game.ReplicatedStorage.Project.Server.ClientServer)
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local Library = require(game.ReplicatedStorage.Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local TaskService = Library.getService("TaskService")
local NumberService = Library.getService("NumberService")
local ProximityPromptService = game:GetService("ProximityPromptService")
-- STARTS


------------------------
-- IMPORTS (STARTS)
------------------------

-- Loads client player listener.
require(game.ReplicatedStorage.Project.Player.ClientPlayerListener)
require(game.ReplicatedStorage.Project.Interfaces.InterfaceProvider)
require(game.ReplicatedStorage.Project.Interfaces.Prompt.PromptClickInterface)

------------------------
-- IMPORTS (ENDS)
------------------------

-- Loads default interfaces.
function class.loadDefaultInterfaces()
    -- Gets game interface.
    local game_ui = InterfaceService.get("game")

    -- Binds interface.
    game_ui:bind(game.Players.LocalPlayer.PlayerGui)

    -- Updates every 0.5 seconds.
    TaskService.createRepeating(0.5, function(_task)
        game_ui:getElementByPath("bottom_body.body_speed.text"):updateProperties({
            Text = "x" .. string.format("%0.2f", 1 + ClientPlayer.getStats().get("WALK_SPEED"))
        })
        game_ui:getElementByPath("bottom_body.body_jump.text"):updateProperties({
            Text = "x" .. string.format("%0.2f", 1 + ClientPlayer.getStats().get("JUMP_HEIGHT"))
        })

        game_ui:getElementByPath("right_body.body_rank.text"):updateProperties({
            Text = ClientPlayer.getRank() == -1
            and "-"
            or (ClientPlayer.getRank() < 1000 and ClientPlayer.getRank() or "+" .. NumberService.format(ClientPlayer.getRank(), "%.0f"))
        })
        game_ui:getElementByPath("right_body.body_win.text"):updateProperties({
            Text = NumberService.format(ClientPlayer.getStatistics().get("WIN"))
        })
        game_ui:getElementByPath("right_body.body_money.text"):updateProperties({
            Text = NumberService.format(ClientPlayer.getCurrencies().get("GOLD"))
        })

        game_ui:getElementByPath("error_panel.text"):updateProperties({
            TextTransparency = ClientServer.Active and 1 or 0
        })
    end):run()
end


-- ENDS
return class