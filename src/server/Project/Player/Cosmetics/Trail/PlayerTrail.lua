local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local TrailProvider = Library.getService("TrailProvider")
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

-- Gets trail.
-- @return Trail.
function class:getTrail()
    return TrailProvider.get(self.id)
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

-- Sets player trail active status.
-- @param _active Player trail active status.
-- @return Player trail. (BUILDER)
function class:setActive(_active : boolean)
    -- Object nil checks.
    assert(_active ~= nil, "Active status cannot be null")
    if self.active == _active then return end

    self.active = _active
    return self
end

-- Converts player trail to a table.
-- @param _client Is it for client or not.
-- @return Player trail table.
function class:toTable(_client : boolean)
    if _client then
        return {
            id = self.id,
            assetId = self:getPet():getAssetId(),
            active = self.active
         }
    end
    return {
       id = self.id,
       active = self.active
    }
end


-- ENDS
return class