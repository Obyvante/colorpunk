local class = {}
-- IMPORTS
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local GamePist = require(game.ReplicatedStorage.Project.Game.Pist.GamePist)
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local TaskService = Library.getService("TaskService")
local InterfaceService = Library.getService("InterfaceService")
local PlayerService = game:GetService("Players")
-- INTERFACES
local GameInterface = InterfaceService.get("game")
local text_center = GameInterface:getElementByPath("top_background.center_text")
local timer_text_1 = GameInterface:getElementByPath("top_background.left_text")
local timer_text_2 = GameInterface:getElementByPath("top_background.right_text")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.Locations = {
    Spawns = {
        Folder = game.Workspace.World["Spawn Locations"],
        Lobby = {
            Self =game.Workspace.World["Spawn Locations"].Lobby
        },
        Pist = {
            Self =game.Workspace.World["Spawn Locations"].Pist
        }
    }
}
for i = 1, 20, 1 do
    class.Locations.Spawns.Lobby[i] = class.Locations.Spawns.Lobby.Self["spawner_lobby_" .. i]
    class.Locations.Spawns.Pist[i] = class.Locations.Spawns.Pist.Self["spawner_pist_" .. i]
end

class.Requirements = {
    MINIMUM_PLAYER = 2
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- METHODS (STARTED)
------------------------

-- Resets game.
function class.reset()
    GamePist.reset()

    class.Round = {
        Current = 1,
        Duration = 999,
        Timer = 0,
        Pist = nil,
        Color = nil
    }
    class.State = nil
    class.Starting = {
        Timer = {
            Duration = 30,
            Current = 0
        }
    }
end

-- Applies state information to client game.
function class.applyState(_state : string, _information : table)
    -- Handles states.
    if _state == "LOAD" then
        class.Round = _information.Round
        class.Starting = _information.Starting
        class.State = _information.State

        if class.State == "STARTING" then
            class.applyState("STARTING")
        elseif class.State == "STARTED" then
            -- Updates texts.
            text_center:updateProperties({
                Custom = {
                    FontSize = 120
                },
                Text = "BLACK",
            })
        end
    elseif _state == "STARTING" then
        -- Resets pist with color.
        GamePist.restWithColor()

        -- Updates texts.
        text_center:updateProperties({
            Custom = {
                FontSize = 75
            },
            Text = "Game is starting..."
        })
        timer_text_1:updateProperties({
            TextColor3 = Color3.fromRGB(255, 255, 255)
        })
        timer_text_2:updateProperties({
            TextColor3 = Color3.fromRGB(255, 255, 255)
        })
        class.State = _state
    elseif _state == "STARTED" then
        -- Safety.
        if class.State == nil then return end

        -- Updates texts.
        text_center:updateProperties({
            Custom = {
                FontSize = 120
            },
            Text = "BLACK",
        })
        
        -- Updates round informations.
        class.Round.Duration = _information.Duration
        class.Round.Current = _information.Round
        class.Round.Pist = _information.Pist
        class.Round.Color = _information.Color
        class.Round.Timer = 0
        class.State = _state

        -- Loads pist.
        GamePist.load(class.Round.Pist)

        class.State = _state
    elseif _state == "ROUND" then
        -- Safety.
        if class.State == nil then return end
        
        -- Updates round informations.
        class.Round.Duration = _information.Duration
        class.Round.Current = _information.Round
        class.Round.Pist = _information.Pist
        class.Round.Color = _information.Color
        class.Round.Timer = 0

        -- Loads pist.
        GamePist.load(class.Round.Pist)
    elseif _state == "FALLING" then
        -- Safety.
        if class.State == nil then return end

        GamePist.whitelist(class.Round.Pist, class.Round.Color.brick_color)
    elseif _state == "CANCELLED" then
        -- Safety.
        if class.State == nil then return end

        class.reset()
        GamePist.reset()
        class.State = nil
    elseif _state == "ENDED" then
        -- Safety.
        if class.State == nil then return end

        class.reset()
    elseif _state == "SUMMARY" then
        -- Safety.
        if class.State == nil then return end
        
    end
end

------------------------
-- METHODS (ENDS)
------------------------


------------------------
-- GAME LOOP (STARTS)
------------------------

-- Resets if it is first time.
class.reset()

-- Client game loop.
TaskService.create(0.1, 0.1, function(_task)
    -- Handles states.
    if class.State == nil then
        -- Updates/Handles center texts.
        if text_center:getFontSize() ~= 75 then
            text_center:updateProperties({
                Custom = {
                    FontSize = 75
                },
                Text = "Waiting players...",
            })
        else
            text_center:updateProperties({
                Text = "Waiting players...",
            })
        end

        -- Updates number texts.
        timer_text_1:updateProperties({
            TextColor3 = Color3.fromRGB(0, 255, 128),
            Text = #PlayerService:GetPlayers()
        })
        timer_text_2:updateProperties({
            TextColor3 = Color3.fromRGB(255, 0, 0),
            Text = class.Requirements.MINIMUM_PLAYER
        })
    elseif class.State == "STARTING" then
        -- Increases current timer.
        class.Starting.Timer.Current += 0.1
        -- If it has passed maximum limit, sets to maximum again.
        if class.Starting.Timer.Current > class.Starting.Timer.Duration then
            class.Starting.Timer.Current = class.Starting.Timer.Duration
            return
        end

        -- Declares result.
        local _result = math.floor(class.Starting.Timer.Duration - class.Starting.Timer.Current + 1)

        -- Updates texts.
        timer_text_1:updateProperties({
            Text = _result
        })
        timer_text_2:updateProperties({
            Text = _result
        })
    elseif class.State == "STARTED" then
        -- Increases current timer.
        class.Round.Timer += 0.1

        -- If it has passed maximum limit, sets to maximum again.
        if class.Round.Timer > class.Round.Duration then
            -- Updates texts.
            text_center:updateProperties({
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Text = "WATCH OUT!",
            })
            timer_text_1:updateProperties({
                TextColor3 = Color3.fromRGB(255, 0, 0),
                Text = "🍃"
            })
            timer_text_2:updateProperties({
                TextColor3 = Color3.fromRGB(255, 0, 0),
                Text = "🍃"
            })
            return
        end

        -- Updates texts.
        text_center:updateProperties({
            TextColor3 = class.Round.Color.color,
            Text = class.Round.Color.name,
        })
        timer_text_1:updateProperties({
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = math.floor(class.Round.Duration - class.Round.Timer + 1)
        })
        timer_text_2:updateProperties({
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = class.Round.Current
        })
    end
end):run()

------------------------
-- GAME LOOP (ENDS)
------------------------



-- ENDS
return class