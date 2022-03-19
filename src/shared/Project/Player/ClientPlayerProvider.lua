local class = {}
-- IMPORTS
local ClientServer = require(game.ReplicatedStorage.Project.Server.ClientServer)
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local Library = require(game.ReplicatedStorage.Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local TaskService = Library.getService("TaskService")
local NumberService = Library.getService("NumberService")
-- STARTS


------------------------
-- IMPORTS (STARTS)
------------------------

-- Loads client player listener.
require(game.ReplicatedStorage.Project.Player.ClientPlayerListener)

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

        local _prodctIconBody = game_ui:getElementByPath("product_icon_body")
        local _products = ClientPlayer.getInventory().getProduct()
        local _index = 1

        -- Foreseeing goggles.
        if _products.has(1248410359) then
            _prodctIconBody:getElementByPath("icon_panel_" .. _index):updateProperties({
                Image = "rbxassetid://" .. 9132348936
            })
            _index += 1
        end

        -- Money booster.
        if _products.has(1246742045) then
            _prodctIconBody:getElementByPath("icon_panel_" .. _index):updateProperties({
                Image = "rbxassetid://" .. 9132348639
            })
            _index += 1
        end

        -- Speed booster.
        if _products.has(1248410518) then
            _prodctIconBody:getElementByPath("icon_panel_" .. _index):updateProperties({
                Image = "rbxassetid://" .. 9132348299
            })
            _index += 1
        end

        -- Jump booster.
        if _products.has(1248410451) then
            _prodctIconBody:getElementByPath("icon_panel_" .. _index):updateProperties({
                Image = "rbxassetid://" .. 9132348805
            })
            _index += 1
        end

        -- Removes old status icons.
        for i = _index, 4, 1 do
            _prodctIconBody:getElementByPath("icon_panel_" .. i):updateProperties({
                Image = ""
            })
        end
    end):run()
end


-- ENDS
return class