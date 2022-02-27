local class = {}
class.__index = class
-- STARTS


-- Creates a player statistics.
-- @param _player Player.
-- @param _table Player statistics table.
-- @return Created player statistics.
function class.new(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player statistics table cannot be null")

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

-- Gets player statistic value.
-- @param _type Player statistic type.
-- @return Player statistic value.
function class:get(_type : string)
    -- Object nil checks.
    assert(_type ~= nil, "Player statistic type cannot be null")
    local _result = self.content[_type]
    return _result and _result or 0
end

-- Sets player statistic value.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player statistic type.
-- @param _value Value to set. (POSITIVE NUMBER)
function class:set(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player statistic type cannot be null")
    assert(_value ~= nil, "Player statistic value cannot be null")
    assert(_value >= 0, "Player statistic value must be positive")
    self.content[_type] = _value
end

-- Adds value to player statistic.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player statistic type.
-- @param _value Value to add. (POSITIVE NUMBER)
function class:add(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player statistic type cannot be null")
    assert(_value ~= nil, "Player statistic value cannot be null")
    assert(_value >= 0, "Player statistic value must be positive")
    self.content[_type] = math.max(self:get(_type) + _value, 0)
end

-- Removes value from player statistic.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player statistic type.
-- @param _value Value to add. (POSITIVE NUMBER)
function class:remove(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player statistic type cannot be null")
    assert(_value ~= nil, "Player statistic value cannot be null")
    assert(_value >= 0, "Player statistic value must be positive")
    self.content[_type] = math.max(self:get(_type) - _value, 0)
end

-- Converts player statistics to a table.
-- @return Player statistics table.
function class:toTable()
    return self.content
end


-- ENDS
return class