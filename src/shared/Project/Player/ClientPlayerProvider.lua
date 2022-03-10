local class = {}
-- IMPORTS
local ClientServer = require(game.ReplicatedStorage.Project.Server.ClientServer)
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local Library = require(game.ReplicatedStorage.Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local TaskService = Library.getService("TaskService")
local NumberService = Library.getService("NumberService")
local StringService = Library.getService("StringService")
-- STARTS


------------------------
-- INITIALIZATION (STARTS)
------------------------


------------------------
-- IMPORTS (STARTS)
------------------------

-- Loads client player listener.
require(game.ReplicatedStorage.Project.Player.ClientPlayerListener)

------------------------
-- IMPORTS (ENDS)
------------------------


------------------------
-- INTERFACES (STARTS)
------------------------

-- Imports interfaces. (ORDER IS IMPORTANT!)
require(game.ReplicatedStorage.Project.Player.Settings.Interface.PlayerSettingsInterface)
require(game.ReplicatedStorage.Project.Player.Interfaces.PlayerGameInterface)

-- Loads default interfaces.
function class.loadDefaultInterfaces()
    local interface_game = InterfaceService.get("game")
    interface_game:bind(game.Players.LocalPlayer.PlayerGui)

    TaskService.createRepeating(0.5, function(_task)
        interface_game:getElementByPath("bottom_body.body_speed.text"):updateProperties({
            Text = "x" .. string.format("%0.2f", 1 + ClientPlayer.getStats().get("WALK_SPEED"))
        })
        interface_game:getElementByPath("bottom_body.body_jump.text"):updateProperties({
            Text = "x" .. string.format("%0.2f", 1 + ClientPlayer.getStats().get("JUMP_HEIGHT"))
        })

        interface_game:getElementByPath("right_body.body_rank.text"):updateProperties({
            Text = NumberService.format(0)
        })
        interface_game:getElementByPath("right_body.body_win.text"):updateProperties({
            Text = NumberService.format(ClientPlayer.getStatistics().get("WIN"))
        })
        interface_game:getElementByPath("right_body.body_money.text"):updateProperties({
            Text = NumberService.format(ClientPlayer.getCurrencies().get("GOLD"))
        })

        interface_game:getElementByPath("error_panel.text"):updateProperties({
            TextTransparency = ClientServer.Active and 1 or 0
        })
    end):run()
end

------------------------
-- INTERFACES (ENDS)
------------------------


------------------------
-- INITIALIZATION (ENDS)
------------------------



-- ENDS
return class