local class = {}
class.__index = class
-- STARTS


-- Creates a player settings.
-- @param _player Player.
-- @param _table Player settings table.
-- @return Created player settings.
function class.new(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player settings table cannot be null")

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

-- Gets player setting value.
-- @param _type Player setting type.
-- @return Player setting value.
function class:get(_type : string)
    -- Object nil checks.
    assert(_type ~= nil, "Player setting type cannot be null")
    local _result = self.content[_type]
    return _result and _result or 0
end

-- Gets player setting value as a boolean.
-- @param _type Player setting type.
-- @return Player setting value as a boolean.
function class:asBoolean(_type : string)
    return self:get(_type) == 1
end

-- Sets player setting value.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player setting type.
-- @param _value Value to set. (POSITIVE NUMBER)
function class:set(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player setting type cannot be null")
    assert(_value ~= nil, "Player setting value cannot be null")
    assert(_value >= 0, "Player setting value must be positive")
    self.content[_type] = math.floor(_value)
end

-- Converts player settings to a table.
-- @return Player settings table.
function class:toTable()
    return self.content
end


-- ENDS
return class