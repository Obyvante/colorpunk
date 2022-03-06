local class = {}
class.__index = class
-- IMPORTS
-- STARTS


class.initialized = false

-- Gets if player statistics is initialized or not.
-- @return If player statistics is initialized or not.
function class.isInitialized()
    return class.initialized
end

-- Updates player settings.
-- @param _player Player.
-- @param _table Player settings table.
-- @return Player settings.
function class.update(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player settings table cannot be null")

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

-- Gets player setting value.
-- @param _type Player setting type.
-- @return Player setting value.
function class.get(_type : string)
    -- Object nil checks.
    assert(_type ~= nil, "Player setting type cannot be null")
    local _result = class.content[_type]
    return _result and _result or 0
end

-- Gets player setting value as a boolean.
-- @param _type Player setting type.
-- @return Player setting value as a boolean.
function class.asBoolean(_type : string)
    return class.get(_type) == 1
end

-- Sets player setting value.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player setting type.
-- @param _value Value to set. (POSITIVE NUMBER)
function class.set(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player setting type cannot be null")
    assert(_value ~= nil, "Player setting value cannot be null")
    assert(_value >= 0, "Player setting value must be positive")
    class.content[_type] = math.floor(_value)
end


-- ENDS
return class