local class = {}
-- STARTS


class.initialized = false

-- Gets if player statistics is initialized or not.
-- @return If player statistics is initialized or not.
function class.isInitialized()
    return class.initialized
end

-- Updates player statistics.
-- @param _player Player.
-- @param _table Player statistics table.
-- @return Player statistics.
function class.update(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player statistics table cannot be null")

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

-- Gets player statistic value.
-- @param _type Player statistic type.
-- @return Player statistic value.
function class.get(_type : string)
    -- Object nil checks.
    assert(_type ~= nil, "Player statistic type cannot be null")
    local _result = class.content[_type]
    return _result and _result or 0
end


-- ENDS
return class