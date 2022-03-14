local class = {}
class.__index = class
-- STARTS


-- Creates a player pet.
-- @param _player Player.
-- @param _uid Player pet unique id.
-- @param _id Pet id.
-- @param _active Player pet active status.
-- @return Created player pet.
function class.new(_player, _uid : string, _id : number, _active : boolean)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_uid ~= nil, "Player pet unique id cannot be null")
    assert(_id ~= nil, "Player pet id cannot be null")
    assert(_active ~= nil, "Player pet active status cannot be null")

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

-- Gets player pet unique id.
-- @return Playe pet unique id.
function class:getUID()
    return self.uid
end

-- Gets pet id.
-- @return Pet id.
function class:getId()
    return self.id
end

-- Gets if player pet is active or not.
-- @return If player pet is active or not.
function class:isActive()
    return self.active
end


-- ENDS
return class