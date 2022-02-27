local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local Player = require(game.ServerScriptService.Project.Player.Player)
local PlayerHTTP = require(game.ServerScriptService.Project.Player.HTTP.PlayerHTTP)
local SignalService = Library.getService("SignalService")
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


----------
-- INITIALIZATION
----------

------------------------
-- SIGNAL HANDLERS (PLAYER JOIN)
-------- (STARTS) --------

-- Creates player join signal.
local signal_player_join = SignalService.create("PlayerJoin")

-- Connects actual event.
signal_player_join:connect(function(player)
    local _table = PlayerHTTP.handle(player.UserId, player.Name)
    local _player = Player.new(_table)
    content[_table.id] = _player

    print(_player:toTable())
end)

-- Fires player join signal when player join.
PlayersService.PlayerAdded:Connect(function(player)
    signal_player_join:fire(player)
end)

-- If it is studio, call player join signal manually.
if RunService:IsStudio() then
    for _, value in pairs(PlayersService:GetPlayers()) do
        signal_player_join:fire(value)
    end
end

------------------------
-- SIGNAL HANDLERS (PLAYER JOIN)
-------- (ENDS) --------



-- ENDS
return class