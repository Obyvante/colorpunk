local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local PlayerPet = require(game.ServerScriptService.Project.Player.Cosmetics.Pet.PlayerPet)
local PetProvider = Library.getService("PetProvider")
local TableService = Library.getService("TableService")
local HTTPService = Library.getService("HTTPService")
local EventService = Library.getService("EventService")
-- EVENTS
local PlayerUpdateEvent = EventService.get("Player.PlayerUpdate")
-- STARTS


class.EntityPositions = {
    [4] = {
        [1] = Vector3.new(0, 2, 4), -- MIDDLE
        [2] = Vector3.new(-2, 2, 6), -- LEFT
        [3] = Vector3.new(2, 2, 6), -- RIGHT
        [4] = Vector3.new(0, 2, 8) -- BACK
    },
    [3] = {
        [1] = Vector3.new(0, 2, 4), -- MIDDLE
        [2] = Vector3.new(-2, 2, 6), -- LEFT
        [3] = Vector3.new(2, 2, 6), -- RIGHT
    },
    [2] = {
        [1] = Vector3.new(1, 2, 4), -- MIDDLE
        [2] = Vector3.new(-1, 2, 4), -- LEFT
    },
    [1] = {
        [1] = Vector3.new(0, 2, 4), -- MIDDLE
    }
}


-- Creates a player pet inventory.
-- @param _player Player.
-- @param _content Player pet inventory table.
-- @return Created player pet inventory.
function class.new(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player pet inventory table cannot be null")

    local _inventory = setmetatable({ player = _player, content = {} }, class)

    for key, value in pairs(_table) do
        _inventory.content[key] = PlayerPet.new(_player, key, value.id, value.active)
    end

    return _inventory
end

-- Gets player.
-- @return Player.
function class:getPlayer()
    return self.player
end

-- Gets player pets.
-- @return Player pets.
function class:getContent()
    return TableService.values(self.content)
end

-- Gets player pets by its state.
-- @param _state Player pet state.
-- @return Player pets.
function class:getContentByState(_state : boolean)
    local _content = {}

    for _, value in pairs(self.content) do
        if value:isActive() == _state then
            table.insert(_content, value)
        end
    end

    return _content
end

-- Finds player pet by its unique id. (SAFE)
-- @param _uid Player pet unique id.
-- @return Player pet. (NULLABLE)
function class:find(_uid : number)
    -- Object nil checks.
    assert(_uid ~= nil, "Player pet unique id cannot be null")
    return self.content[_uid]
end

-- Gets player pet by its unique id.
-- @param _uid Player pet unique id.
-- @return Player pet.
function class:get(_uid : number)
    local _result = self:find(_uid)
    assert(_result ~= nil, "Player(" .. self.player:getId() .. ") pet(" .. _uid .. ") cannot be null")
    return _result
end

-- Creates a player pet.
-- @param _id Pet id.
function class:add(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Pet id cannot be null")
    if PetProvider.find(_id) == nil then error("pet(" .. _id .. ") does not exist!") end
    if TableService.size(self.content) >= 27 then error("Player(" .. self.player:getId() .. ") inventory size must be equals or lower than 27") end

    local player_pet = PlayerPet.new(self.player, HTTPService.randomUUID(), _id, false)

    self.content[player_pet:getUID()] = player_pet

    -- Sends update packet.
    self:_sendUpdatePacket()
end

-- Removes player pet.
-- @param _uid Player pet unique id.
function class:remove(_uid : string, _packet : boolean)
    -- Object nil checks.
    assert(_uid ~= nil, "Player pet unique id cannot be null")

    -- Gets player pet.
    local _pet = self:find(_uid)
    -- If player pet is not exist, no need to continue.
    if not _pet then return end

    -- Despawn player pet entity.
    _pet:despawnEntity()

    -- Removes it from the cache.
    self.content[_uid] = nil

    -- Sends update packet.
    if _packet == nil or _packet then  self:_sendUpdatePacket() end
end

-- Converts player pet inventory to a table.
-- @param _client Is it for client or not.
-- @return Player pet inventory table.
function class:toTable(_client : boolean)
    local _table = {}

    for key, value in pairs(self.content) do
        _table[key] = value:toTable(_client)
    end

    return _table
end

-- Updates entities.
function class:updateEntities()
    -- Handles pet entity spawning and despawning.
    for _, value in pairs(self.content) do
        if value:isActive() and not value:getEntity() then
            value:spawnEntity(Vector3.new(0, 0, 0))
        elseif not value:isActive() and value:getEntity() then
            value:despawnEntity()
        end
    end

    -- Gets actives pets.
    local _actives = self:getContentByState(true)

    -- Handles active pet positions.
    for index, value in pairs(_actives) do
        if not value:getEntity() then continue end

        -- Updates position.
        value:getEntity():updatePosition(class.EntityPositions[#_actives][index])
    end
end

-- Sends update packet for target type to client.
function class:_sendUpdatePacket()
    -- Gets roblox player and checks if it is online.
    local player = self.player:getRobloxPlayer()
    if not player then return end

    -- Sends update packet.
    PlayerUpdateEvent:FireClient(player, "INVENTORY_PET", self:toTable(true))
end



-- ENDS
return class