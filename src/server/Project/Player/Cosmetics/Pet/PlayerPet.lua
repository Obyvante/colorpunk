local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local PetProvider = Library.getService("PetProvider")
local PlayerPetEntity = require(script.Parent.PlayerPetEntity)
-- STARTS


-- Creates a player pet.
-- @param _player Player.
-- @param _uid Player pet unique id.
-- @param _id Pet id.
-- @param _active Player pet active status.
-- @return Created player pet.
function class.new(_player : ModuleScript, _uid : string, _id : number, _active : boolean)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_uid ~= nil, "Player pet unique id cannot be null")
    assert(_id ~= nil, "Player pet id cannot be null")
    assert(_active ~= nil, "Player pet active status cannot be null")

    local self = setmetatable({
        player = _player,
        uid = _uid,
        id = _id,
        active = _active,
    }, class)
    return self
end

-- Gets pet.
-- @return Pet.
function class:getPet()
    return PetProvider.get(self.id)
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

-- Sets player pet active status.
-- @param _active Player pet active status.
-- @return Player pet. (BUILDER)
function class:setActive(_active : boolean)
    -- Object nil checks.
    assert(_active ~= nil, "Active status cannot be null")
    if self.active == _active then return end

    -- Handles player pet entity spawning.
    if self.active then
        self:despawnEntity()
    else
        self:spawnEntity()
    end
    self.active = _active

    self.player:getInventory():getPet():updateEntities()
    return self
end

-- Gets player pet entity.
function class:getEntity()
    return self.entity
end

-- Spawns entity.
function class:spawnEntity()
    -- Destroys previous pet entity.
    if self.entity then self.entity:Destroy() end

    -- Spawns player pet entity.
    self.entity = PlayerPetEntity.new(self)
end

-- Spawns entity.
function class:despawnEntity()
    -- Destroys previous pet entity.
    if self.entity then
        self.entity:Destroy()
        self.entity = nil
    end
end

-- Converts player pet to a table.
-- @param _client Is it for client or not.
-- @return Player pet table.
function class:toTable(_client : boolean)
    if _client then
        return {
            id = self.id,
            assetId = self:getPet():getIconId(),
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