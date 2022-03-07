local class = {}
class.__index = class
-- STARTS


class.initialized = false

-- Gets if player currencies is initialized or not.
-- @return If player currencies is initialized or not.
function class.isInitialized()
    return class.initialized
end

-- Updates player currencies.
-- @param _player Player.
-- @param _table Player currencies table.
-- @return Player currencies.
function class.update(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player currencies table cannot be null")

    class.player = _player
    class.content = _table
    class.initialized = true

    return class
end

-- Gets player.
-- @return Player.
function class.getPlayer()
    return class.player
end

-- Gets player currency value.
-- @param _type Player currency type.
-- @return Player currency value.
function class.get(_type : string)
    -- Object nil checks.
    assert(_type ~= nil, "Player currency type cannot be null")
    assert(class.Types[_type] ~= nil, "Player currency type is not exist")
    local _result = class.content[_type]
    return _result and _result or 0
end

-- Sets player currency value.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player currency type.
-- @param _value Value to set. (POSITIVE NUMBER)
function class.set(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player currency type cannot be null")
    assert(class.Types[_type] ~= nil, "Player currency type is not exist")
    assert(_value ~= nil, "Player currency value cannot be null")
    assert(_value >= 0, "Player currency value must be positive")
    class.content[_type] = _value
end

-- Adds value to player currency.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player currency type.
-- @param _value Value to add. (POSITIVE NUMBER)
function class.add(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player currency type cannot be null")
    assert(class.Types[_type] ~= nil, "Player currency type is not exist")
    assert(_value ~= nil, "Player currency value cannot be null")
    assert(_value >= 0, "Player currency value must be positive")
    class.content[_type] = math.max(class.get(_type) + _value, 0)
end

-- Removes value from player currency.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player currency type.
-- @param _value Value to add. (POSITIVE NUMBER)
function class.remove(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player currency type cannot be null")
    assert(class.Types[_type] ~= nil, "Player currency type is not exist")
    assert(_value ~= nil, "Player currency value cannot be null")
    assert(_value >= 0, "Player currency value must be positive")
    class.content[_type] = math.max(class.get(_type) - _value, 0)
end


-- ENDS
return class