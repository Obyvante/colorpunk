local class = {}
-- STARTS


class.initialized = false

-- Gets if player stats is initialized or not.
-- @return If player stats is initialized or not.
function class.isInitialized()
    return class.initialized
end

-- Updates player stats.
-- @param _player Player.
-- @param _table Player stats table.
-- @return Player stats.
function class.update(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player stats table cannot be null")

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

-- Gets player stat value.
-- @param _type Player stat type.
-- @return Player stat value.
function class.get(_type : string)
    -- Object nil checks.
    assert(_type ~= nil, "Player stat type cannot be null")
    local _result = class.content[_type]
    return _result and _result or 0
end


-- ENDS
return class