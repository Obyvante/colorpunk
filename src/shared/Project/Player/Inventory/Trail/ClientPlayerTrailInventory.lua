local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local ClientPlayerTrail = require(game.ReplicatedStorage.Project.Player.Cosmetics.Trail.ClientPlayerTrail)
local TableService = Library.getService("TableService")
local EventService = Library.getService("EventService")
-- EVENTS
local PlayerRequestEvent = EventService.get("PlayerRequest")
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
        class.content[key] = ClientPlayerTrail.new(_player, key, value.id, value.active)
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

-- Sends player trail remove request to the backend.
-- @param _uid Player trail uid.
function class.removeRequest(_uid : string)
    PlayerRequestEvent:FireServer("REMOVE_TRAIL", class.get(_uid):getUID()) -- Getting player trail to prevent nil.
end



-- ENDS
return class