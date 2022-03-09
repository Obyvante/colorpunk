local class = {}
-- IMPORTS
local GameRound = require(script.Parent.GameRound)
local PistPartColor = require(script.Parent.PistPartColor)
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local TaskService = Library.getService("TaskService")
local TeleportService = Library.getService("TeleportService")
local PlayerProvider = Library.getService("PlayerProvider")
local TableService = Library.getService("TableService")
local PlayerService = game:GetService("Players")
-- EVENTS
local GameStateEvent = EventService.get("GameState")
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
    },
    Pist = game.Workspace.World.Arena.Pist,
    Pists = game.ReplicatedStorage.Pists:GetDescendants(),
    Bottom = game.Workspace.World.Barriers.Outside.Bottom
}
for i = 1, 20, 1 do
    class.Locations.Spawns.Lobby[i] = class.Locations.Spawns.Lobby.Self["spawner_lobby_" .. i]
    class.Locations.Spawns.Pist[i] = class.Locations.Spawns.Pist.Self["spawner_pist_" .. i]
end

class.Requirements = {
    MINIMUM_PLAYER = 2, -- 10
    QUEUE_TIMER = 10 -- 30
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- EVENTS (STARTED)
------------------------

class.Locations.Bottom.Touched:Connect(function(_part)
    local player = PlayerService:GetPlayerFromCharacter(_part.Parent)
    TeleportService.teleport(player, class.Locations.Spawns.Lobby[math.random(1, #class.Locations.Spawns.Lobby)].Position, Vector3.new(0, 90, 0))
end)

------------------------
-- EVENTS (ENDS)
------------------------


------------------------
-- METHODS (STARTED)
------------------------

-- Resets game.
function class.reset()
    class.Round = {
        Current = 1,
        Timer = 0,
        Pist = nil,
        Color = nil
    }
    class.Falling = {
        Duration = 3,
        Timer = 0
    }
    class.Status = {
        Started = false,
        Starting = false
    }
    class.Starting = {
        Timer = {
            Duration = 5,
            Current = 0
        },
    }
    class.Participants = {}
    class.Eliminated = {}
end

-- Gets available players.
function class.getAvailablePlayers()
    local _available = {}

    for _, player in pairs(PlayerService:GetPlayers()) do
        local _player = PlayerProvider.find(player.UserId)
        if not _player or not _player:isLoaded() then continue end

        table.insert(_available, player)
    end

    return _available
end

-- Selects random pist.
function class.randomPist()
    -- Sets pist field.
    class.Round.Pist = class.Locations.Pists[math.random(1, #class.Locations.Pists)]
    local PistModule = require(class.Round.Pist)

    -- Sets color field.
    local Colors = TableService.keys(PistModule.WHITELIST)
    class.Round.Color = PistPartColor.content[Colors[math.random(1, #Colors)]]
end

------------------------
-- METHODS (ENDS)
------------------------


------------------------
-- GAME LOOP (STARTS)
------------------------

-- Resets if it is first time.
class.reset()

-- Game loop function.
local game_loop_func = function()
    -- Declares required fields.
    local players = class.getAvailablePlayers()

    -- If game is starting currently.
    if class.Status.Starting then
        -- If there is no neough player, cancel countdown.
        if class.Requirements.MINIMUM_PLAYER > #players then
            -- Resets game.
            class.reset()
            -- Fires cancelled packet.
            GameStateEvent:FireAllClients("CANCELLED")
            return
        end

        class.Starting.Timer.Current += 0.1
        if class.Starting.Timer.Current < class.Starting.Timer.Duration then return end
    end

    -- If game is not started yet.
    if not class.Status.Started and not class.Status.Starting then
        -- If there is no neough player, no need to continue.
        if class.Requirements.MINIMUM_PLAYER > #players then return end

        -- Enables starting.
        class.Status.Starting = true

        -- TODO: egg opening, doing stuff etc. check.
        GameStateEvent:FireAllClients("STARTING")
        print("starting")
        return
    end

    -- If it is not started yet.
    if not class.Status.Started then
        -- Enables starting.
        class.Status.Starting = false
        class.Status.Started = true
        class.Starting.Timer.Current = 0
        class.Participants = players

        -- Configures pist.
        class.randomPist()

        -- Player teleportation.
        for index, player in pairs(PlayerService:GetPlayers()) do
            TeleportService.teleport(player, class.Locations.Spawns.Pist[index].Position, Vector3.new(0, 90, 0))
        end

        -- Fires cancelled packet.
        GameStateEvent:FireAllClients("STARTED", {
            Round = 1,
            Duration = GameRound.get(1).Duration,
            Pist = class.Round.Pist.Name,
            Color = class.Round.Color
        })
    end

    -- Declares required fields.
    local round = GameRound.get(class.Round.Current)

    -- If current timer duration has passed.
    if class.Round.Timer > round.Duration then
        -- Handles falling timer.
        if class.Falling.Timer == 0 then
            local PistModule = require(class.Round.Pist)
            local Colors = TableService.keys(PistModule.WHITELIST)

            -- Sends falling packet.
            GameStateEvent:FireAllClients("FALLING")
        end

        -- If it is in falling stage.
        class.Falling.Timer += 0.1
        if class.Falling.Timer < class.Falling.Duration then return end

        -- Resets base fields.
        class.Falling.Timer = 0
        class.Round.Current += 1
        class.Round.Timer = 0
        round = GameRound.get(class.Round.Current)

        -- Configures pist.
        class.randomPist()

        -- If it was a last round!
        if not round then
            -- Player teleportation.
            for index, player in pairs(class.Participants) do
                if player == nil then continue end
                TeleportService.teleport(player, class.Locations.Spawns.Lobby[index].Position, Vector3.new(0, 90, 0))
            end
            
            -- Resets class.
            class.reset()

            -- Sends cancelled packet.
            GameStateEvent:FireAllClients("ENDED")
            return
        end

        -- Sends round packet.
        GameStateEvent:FireAllClients("ROUND", {
            Round = class.Round.Current,
            Duration = round.Duration,
            Pist = class.Round.Pist.Name,
            Color = class.Round.Color
        })
        return
    end

    -- Increasments.
    class.Round.Timer += 0.1
end

-- Starts game loop
TaskService.createRepeating(0.1, function(_task)
    -- To prevent task cancellation.
    local success, message = pcall(game_loop_func)

    if not success then
        error("[GAME LOOP] " .. message)
    end
end):run()

------------------------
-- GAME LOOP (ENDS)
------------------------



-- ENDS
return class