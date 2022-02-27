local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local Player = require(game.ServerScriptService.Project.Player.Player)
local PlayerHTTP = require(game.ServerScriptService.Project.Player.HTTP.PlayerHTTP)
local SignalService = Library.getService("SignalService")
local TaskService = Library.getService("TaskService")
local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")
-- STARTS


local content = {}

-- Gets players.
-- @return Players.
function class.getContent()
    return content
end

-- Finds player by its id. (SAFE)
-- @param _id Player id.
-- @return Player. (NULLABLE)
function class.find(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Player id cannot be null")
    return content[_id]
end

-- Gets player by its id.
-- @param _id Player id.
-- @return Player.
function class.get(_id : number)
    local _result = class.find(_id)
    assert(_result ~= nil, "Player(" .. _id .. ") cannot be null")
    return _result
end

-- Removes player by its id.
-- @param _id Player id.
function class.remove(_id : number)
    local _player = class.find(_id)
    assert(_player ~= nil, "Player(" .. _id .. ") cannot be null")

    _player:destroy()
    content[_id] = nil
end


------------------------
-- INITIALIZATION (STARTS)
------------------------


------------------------
-- TASKS (STARTS)
-----------------------

-- Player cache updater.
-- Every 90 seconds.
TaskService.createRepeating(90, function(_task)
    -- Async task.
    task.spawn(function()
        -- Safe http request.
        local success, message = pcall(PlayerHTTP.updates, content)

        -- If it is no successfully, warns server about that.
        if not success then
            warn(" ")
            warn("PLAYERS UPDATES ERROR [IMPORTANT ISSUE!]")
            warn(message)
            warn(" ")
        end
    end)
end):run()

------------------------
-- TASKS (ENDS)
-----------------------


------------------------
-- SIGNAL HANDLERS (PLAYER JOIN) (STARTS)
------------------------

-- Creates player join signal.
local signal_player_join = SignalService.create("PlayerJoin")

-- Connects actual event.
signal_player_join:connect(function(player)
    local _table = PlayerHTTP.handle(player.UserId, player.Name)
    local _player = Player.new(_table)

    content[_table.id] = _player
end)

-- Fires player join signal when player join.
PlayersService.PlayerAdded:Connect(function(player)
    signal_player_join:fire(player)
end)

-- Handles player leave.
PlayersService.PlayerRemoving:Connect(function(player)
    -- Async task.
    task.spawn(function()
        local _player = class.find(player.UserId)
        if _player == nil then return end

        -- Safe http request.
        local success, message = pcall(PlayerHTTP.update, _player)

        -- Removes player from the cache.
        class.remove(player.UserId)

        -- If it is no successfully, warns server about that.
        if not success then
            warn(" ")
            warn("PLAYERS UPDATE(" .. player.UserId .. ") ERROR [IMPORTANT ISSUE!]")
            warn(message)
            warn(" ")
        end
    end)
end)

-- If it is studio, call player join signal manually.
if RunService:IsStudio() then
    for _, value in pairs(PlayersService:GetPlayers()) do
        signal_player_join:fire(value)
    end
end

------------------------
-- SIGNAL HANDLERS (PLAYER JOIN) (ENDS)
------------------------


------------------------
-- INITIALIZATION (ENDS)
------------------------



-- ENDS
return class