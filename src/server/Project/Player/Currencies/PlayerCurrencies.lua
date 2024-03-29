local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
-- EVENTS
local PlayerUpdateEvent = EventService.get("Player.PlayerUpdate")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

-- Types (ENUM)
class.Types = {
    GOLD = {
        NAME = "Money"
    }
}

------------------------
-- VARIABLES (ENDS)
------------------------


-- Creates a player currencies.
-- @param _player Player.
-- @param _table Player currencies table.
-- @return Created player currencies.
function class.new(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player currencies table cannot be null")

    return setmetatable({
        player = _player,
        content = _table
    }, class)
end

-- Gets player.
-- @return Player.
function class:getPlayer()
    return self.player
end

-- Gets player currency value.
-- @param _type Player currency type.
-- @return Player currency value.
function class:get(_type : string)
    -- Object nil checks.
    assert(_type ~= nil, "Player currency type cannot be null")
    assert(class.Types[_type] ~= nil, "Player currency type is not exist")
    local _result = self.content[_type]
    return _result and _result or 0
end

-- Sets player currency value.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player currency type.
-- @param _value Value to set. (POSITIVE NUMBER)
function class:set(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player currency type cannot be null")
    assert(class.Types[_type] ~= nil, "Player currency type is not exist")
    assert(_value ~= nil, "Player currency value cannot be null")
    assert(_value >= 0, "Player currency value must be positive")
    self.content[_type] = _value

    -- Sends update packet.
    self:_sendUpdatePacket(_type)
end

-- Adds value to player currency.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player currency type.
-- @param _value Value to add. (POSITIVE NUMBER)
function class:add(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player currency type cannot be null")
    assert(class.Types[_type] ~= nil, "Player currency type is not exist")
    assert(_value ~= nil, "Player currency value cannot be null")
    assert(_value >= 0, "Player currency value must be positive")
    self.content[_type] = math.max(self:get(_type) + _value, 0)

    -- Sends update packet.
    self:_sendUpdatePacket(_type)
end

-- Removes value from player currency.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player currency type.
-- @param _value Value to add. (POSITIVE NUMBER)
function class:remove(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player currency type cannot be null")
    assert(class.Types[_type] ~= nil, "Player currency type is not exist")
    assert(_value ~= nil, "Player currency value cannot be null")
    assert(_value >= 0, "Player currency value must be positive")
    self.content[_type] = math.max(self:get(_type) - _value, 0)

    -- Sends update packet.
    self:_sendUpdatePacket(_type)
end

-- Sends update packet for target type to client.
-- @param _type Currency type.
-- @return Player currencies. (BUILDER)
function class:_sendUpdatePacket(_type : string)
    -- Object nil checks.
    assert(_type ~= nil, "Player currency type cannot be null")

    -- Gets roblox player and checks if it is online.
    local player = self.player:getRobloxPlayer()
    if not player then return end

    -- Sends update packet.
    PlayerUpdateEvent:FireClient(player, "currencies", {
        Type = _type,
        Value = self.content[_type]
    })
    return self
end

-- Converts player currencies to a table.
-- @return Player currencies table.
function class:toTable()
    return self.content
end


-- ENDS
return class