local class = {}
class.__index = class
-- STARTS


-- Creates a player trail.
-- @param _player Player.
-- @param _uid Player trail unique id.
-- @param _id Trail id.
-- @param _active Player trail active status.
-- @return Created player trail.
function class.new(_player : ModuleScript, _uid : string, _id : number, _active : boolean)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_uid ~= nil, "Player trail unique id cannot be null")
    assert(_id ~= nil, "Player trail id cannot be null")
    assert(_active ~= nil, "Player trail active status cannot be null")

    return setmetatable({
        player = _player,
        uid = _uid,
        id = _id,
        active = _active,
    }, class)
end

-- Gets player.
-- @return Player.
function class:getPlayer()
    return self.player
end

-- Gets player trail unique id.
-- @return Playe trail unique id.
function class:getUID()
    return self.uid
end

-- Gets trail id.
-- @return Trail id.
function class:getId()
    return self.id
end

-- Gets if player trail is active or not.
-- @return If player trail is active or not.
function class:isActive()
    return self.active
end


-- ENDS
return class