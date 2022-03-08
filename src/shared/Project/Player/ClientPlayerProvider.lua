local class = {}
-- IMPORTS
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

    local cp_stats = ClientPlayer.getStats()
    TaskService.createRepeating(1, function(_task)
        interface_game:getElementByPath("top_background.left_text"):updateProperties({
            Text = NumberService.format(math.random(0, 99))
        })
        interface_game:getElementByPath("top_background.center_text"):updateProperties({
            Text = StringService.random(math.random(1, 8), true)
        })
        interface_game:getElementByPath("top_background.right_text"):updateProperties({
            Text = NumberService.format(math.random(0, 99))
        })

        interface_game:getElementByPath("bottom_body.body_speed.text"):updateProperties({
            Text = "x" .. string.format("%0.2f", math.random() * 2)
        })
        interface_game:getElementByPath("bottom_body.body_jump.text"):updateProperties({
            Text = "x" .. string.format("%0.2f", math.random() * 2)
        })

        interface_game:getElementByPath("right_body.body_rank.text"):updateProperties({
            Text = NumberService.format(math.random(0, 999999))
        })
        interface_game:getElementByPath("right_body.body_win.text"):updateProperties({
            Text = NumberService.format(math.random(0, 10000))
        })
        interface_game:getElementByPath("right_body.body_money.text"):updateProperties({
            Text = NumberService.format(math.random(0, 999999999))
        })
    end)--:run()
end

------------------------
-- INTERFACES (ENDS)
------------------------


------------------------
-- INITIALIZATION (ENDS)
------------------------



-- ENDS
return class