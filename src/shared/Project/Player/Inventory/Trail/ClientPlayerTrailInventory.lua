local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local ClientPlayerTrail = require(game.ReplicatedStorage.Project.Player.Cosmetics.Trail.ClientPlayerTrail)
local TableService = Library.getService("TableService")
local EventService = Library.getService("EventService")
-- EVENTS
local PlayerRequestEvent = EventService.get("Player.PlayerRequest")
-- STARTS


-- Updates player trail inventory.
-- @param _player Player.
-- @param _content Player trail inventory table.
-- @return Player trail inventory.
function class.update(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player trail inventory table cannot be null")

    class.player = _player
    class.content = {}
    for key, value in pairs(_table) do
        class.content[key] = ClientPlayerTrail.new(_player, key, tonumber(value.id), value.active)
    end

    return class
end

-- Gets player.
-- @return Player.
function class.getPlayer()
    return class.player
end

-- Gets player trails.
-- @return Player trails.
function class.getContent()
    return TableService.values(class.content)
end

-- Finds player trail by its unique id. (SAFE)
-- @param _uid Player trail unique id.
-- @return Player trail. (NULLABLE)
function class.find(_uid : number)
    -- Object nil checks.
    assert(_uid ~= nil, "Player trail unique id cannot be null")
    return class.content[_uid]
end

-- Gets player trail by its unique id.
-- @param _uid Player trail unique id.
-- @return Player trail.
function class.get(_uid : number)
    local _result = class.find(_uid)
    assert(_result ~= nil, "Player(" .. class.player:getId() .. ") trail(" .. _uid .. ") cannot be null")
    return _result
end

-- Sends player trail state request to the backend.
-- @param _content Player trails.
function class.stateRequest(_content : table)
    PlayerRequestEvent:FireServer("STATE_TRAIL", _content)
end

-- Sends player trail remove request to the backend.
-- @param _content Player trails.
function class.removeRequest(_content : table)
    PlayerRequestEvent:FireServer("REMOVE_TRAIL", _content)
end



-- ENDS
return class