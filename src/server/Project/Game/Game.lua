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
local SignalService = Library.getService("SignalService")
local StatisticsProvider = Library.getService("StatisticsProvider")
local PlayerService = game:GetService("Players")
local Debris = game:GetService("Debris")
-- SIGNALS
local PlayerLeaveSignal = SignalService.getById("PlayerLeave")
-- EVENTS
local GameStateEvent = EventService.get("Game.GameState")
local InterfaceOpenEvent = EventService.get("Interface.InterfaceOpen")
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
    MINIMUM_PLAYER = 2
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- METHODS (STARTED)
------------------------

-- Handles winners.
function class.winners()
    for _, player in pairs(class.Participants) do
        -- Gets player.
        local _player = PlayerProvider.find(player.UserId)
        if _player == nil then continue end

        -- Statistics.
        _player:getStatistics():add("WIN", 1)

        -- Declares required fields.
        local round = GameRound.get(class.Round.Current)
        
        -- Currencies.
        _player:getCurrencies():add("GOLD", round.Money)
        -- Statistics.
        _player:getStatistics():add("GOLD_EARNED", round.Money)
        StatisticsProvider.addGame("GOLD_EARNED", round.Money)

        -- Shows summary screen for player.
        InterfaceOpenEvent:FireClient(player, "summary", {
            ROUND_PLAYED = class.Round.Current,
            GOLD_EARNED = GameRound.totalEarnedMoney(class.Round.Current),
            RANK = 1
        })
    end
end

-- Resets game.
function class.reset()
    -- Player teleportation.
    if class.Participants then
        for index, player in pairs(class.Participants) do
            if player == nil then continue end
            TeleportService.teleport(player, class.Locations.Spawns.Lobby[index].Position, Vector3.new(0, 90, 0))
        end
    end

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
            Duration = 30,
            Current = 0
        }
    }
    class.FreezeDuration = 2
    class.Participants = {}
    class.LastStarted = 0
    class.Eliminated = {}
end

-- Gets available players.
function class.getAvailablePlayers()
    local _available = {}

    for _, player in pairs(PlayerService:GetPlayers()) do
        -- Only gets loaded players.
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

    print("[DEBUG] Pist information -> ", class.Round.Pist, class.Round.Color.name)
end

-- Removes target player from the participants
-- @param _player Roblox player.
function class.removeFromParticipants(_player : Player)
    for index, _participant in pairs(class.Participants) do
        if _player == _participant then
            table.remove(class.Participants, index)

            -- Gets player.
            local player = PlayerProvider.find(_player.UserId)
            if player == nil then break end

            -- Statistics.
            player:getStatistics():add("LOSE", 1)

            -- Shows summary screen for player..
            InterfaceOpenEvent:FireClient(_player, "summary", {
                ROUND_PLAYED = class.Round.Current - 1,
                GOLD_EARNED = GameRound.totalEarnedMoney(class.Round.Current - 1),
                RANK = #class.Participants + 1
            })
            break
        end
    end
end

-- Handles player join for game.
function class.handlePlayerJoin(_player : Player)
    -- Declares required fields.
    local round = GameRound.get(class.Round.Current)

    local state
    if class.Status.Starting then
        state = "STARTING"
    elseif class.Status.Started then
        state = "STARTED"
    end

    -- Fires cancelled packet.
    GameStateEvent:FireClient(_player, "LOAD", {
        Round = {
            Current = class.Round.Current,
            Duration = round.Duration,
            Timer = class.Round.Timer,
            Pist = class.Round.Pist and class.Round.Pist.Name or nil,
            Color = class.Round.Color,
        },
        Starting = class.Starting,
        State = state
    })
end

------------------------
-- METHODS (ENDS)
------------------------


------------------------
-- EVENTS (STARTED)
------------------------

-- Handles player elimination when they fell.
class.Locations.Bottom.Touched:Connect(function(_part)
    -- Gets player from its character.
    local _player = PlayerService:GetPlayerFromCharacter(_part.Parent)
    if _player == nil then return end

    -- Handles attributes.
    if _player:GetAttribute("falling") then return end
    _player:SetAttribute("falling", true)

    -- Teleports player to the target lobby spawn location.
    TeleportService.teleport(_player, class.Locations.Spawns.Lobby[math.random(1, #class.Locations.Spawns.Lobby)].Position, Vector3.new(0, 90, 0))

    -- Removes player from the participant list.
    class.removeFromParticipants(_player)
end)

-- Handles player elimination when they quit.
PlayerLeaveSignal:connect(function(_player)
    -- Removes player from the participant list.
    class.removeFromParticipants(_player)
end)

------------------------
-- EVENTS (ENDS)
------------------------


------------------------
-- GAME LOOP (STARTS)
------------------------

-- Resets if it is first time.
class.reset()

-- Game loop function.
local game_loop_func = function()
    -- Statistics.
    if not class.Status.Started then
        class.LastStarted += 0.1
    end

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

        -- Starting timer increasment.
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
        return
    end

    -- If it is not started yet.
    if not class.Status.Started then
        -- Game statistics.
        StatisticsProvider.addGame("GAME_PLAYED", 1)
        StatisticsProvider.addGame("GAME_START_TIME", class.LastStarted - class.Starting.Timer.Duration)

        -- Enables starting.
        class.Status.Starting = false
        class.Status.Started = true
        class.Starting.Timer.Current = 0
        class.Participants = players
        class.LastStarted = 0

        -- Configures pist.
        class.randomPist()

        -- Player teleportation.
        for index, player in pairs(PlayerService:GetPlayers()) do
            local _player = PlayerProvider.find(player.UserId)
            if _player == nil then continue end
     
            -- Statistics.
            _player:getStatistics():add("GAME_PLAYED", 1)

            TeleportService.teleport(player, class.Locations.Spawns.Pist[index].Position, Vector3.new(0, 90, 0))
            player:SetAttribute("falling", nil)

            local force_field = Instance.new("ForceField")
            force_field.Visible = true
            force_field.Parent = player.Character
            Debris:AddItem(force_field, class.FreezeDuration)
        end

        -- Fires cancelled packet.
        GameStateEvent:FireAllClients("STARTED", {
            Round = 1,
            Duration = GameRound.get(1).Duration,
            Pist = class.Round.Pist.Name,
            Color = class.Round.Color
        })
    end

    -- If there is no enough participants, ends game.
    -- TODO: will remove false.
    if #class.Participants <= 1 then
        -- Handles winners.
        class.winners()
        -- Resets class.
        class.reset()
        -- Sends cancelled packet.
        GameStateEvent:FireAllClients("ENDED")
        return
    end

    -- Declares required fields.
    local round = GameRound.get(class.Round.Current)

    -- If current timer duration has passed.
    if class.Round.Timer > round.Duration then
        -- Handles falling timer.
        if class.Falling.Timer == 0 then
            -- Sends falling packet.
            GameStateEvent:FireAllClients("FALLING")
        end

        -- If it is in falling stage.
        class.Falling.Timer += 0.1
        if class.Falling.Timer < class.Falling.Duration then return end

        for _, player in pairs(class.Participants) do
            local _player = PlayerProvider.find(player.UserId)
            if _player == nil then continue end

            -- Currencies.
            _player:getCurrencies():add("GOLD", round.Money)
     
            -- Statistics.
            StatisticsProvider.addGame("GOLD_EARNED", round.Money)
            _player:getStatistics():add("GOLD_EARNED", round.Money)
            _player:getStatistics():add("ROUND_PLAYED", 1)

            -- For now.
            _player:getStats():set("WALK_SPEED", math.random())
            _player:getStats():set("JUMP_HEIGHT", math.random())
        end

        -- Games statistics.
        StatisticsProvider.addGame("ROUND_PLAYED", 1)

        -- Resets base fields.
        class.Falling.Timer = 0
        class.Round.Current += 1
        class.Round.Timer = 0
        round = GameRound.get(class.Round.Current)

        -- If it was a last round!
        if not round then
            -- Handles winners.
            class.winners()
            -- Resets class.
            class.reset()
            -- Sends cancelled packet.
            GameStateEvent:FireAllClients("ENDED")
            return
        end
        
        -- Configures pist.
        class.randomPist()

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