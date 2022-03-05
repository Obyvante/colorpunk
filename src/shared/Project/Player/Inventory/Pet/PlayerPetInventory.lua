local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local PlayerPet = require(game.ServerScriptService.Project.Player.Cosmetics.Pet.PlayerPet)
local PetProvider = Library.getService("PetProvider")
local TableService = Library.getService("TableService")
local HTTPService = Library.getService("HTTPService")
-- STARTS


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
        _inventory.content[key] = PlayerPet.new(_player, value.uid, value.id, value.active)
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
-- @return Created player pet.
function class:add(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Pet id cannot be null")
    if PetProvider.find(_id) == nil then error("pet(" .. _id .. ") does not exist!") end

    local player_pet = PlayerPet.new(self.player, HTTPService.randomUUID(), _id, false)

    self.content[player_pet:getUID()] = player_pet
    return player_pet
end

-- Removes player pet.
-- @param _uid Player pet unique id.
-- @return Player pet inventory. (BUILDER)
function class:remove(_uid : string)
    -- Object nil checks.
    assert(_uid ~= nil, "Player pet unique id cannot be null")
    self.content[_uid] = nil
    return self
end

-- Converts player pet inventory to a table.
-- @return Player pet inventory table.
function class:toTable()
    local _table = {}

    for key, value in pairs(self.content) do
        _table[key] = value:toTable()
    end

    return _table
end



-- ENDS
return class