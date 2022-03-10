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
    local _result = class.content[_type]
    return _result and _result or 0
end

-- Handles player currencies packet.
-- @param _packet Player currencies packet.
-- @return Player currencies. (BUILDER)
function class.handlePacket(_packet : table)
    class.content[_packet.Type] = _packet.Value
    return class
end


-- ENDS
return class