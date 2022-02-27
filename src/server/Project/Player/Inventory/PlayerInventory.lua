local class = {}
class.__index = class
-- IMPORTS
local PlayerPetInventory = require(game.ServerScriptService.Project.Player.Inventory.Pet.PlayerPetInventory)
local PlayerTrailInventory = require(game.ServerScriptService.Project.Player.Inventory.Trail.PlayerTrailInventory)
-- STARTS


-- Creates a player inventory.
-- @param _player Player.
-- @param _table Player inventory table.
-- @return Created player inventory.
function class.new(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player inventory table cannot be null")

    return setmetatable({
        player = _player,
        pet = PlayerPetInventory.new(_player, _table.pets),
        trail = PlayerTrailInventory.new(_player, _table.trails)
    }, class)
end

-- Gets player.
-- @return Player.
function class:getPlayer()
    return self.player
end

-- Gets player pet inventory.
-- @return Player pet inventory.
function class:getPet()
    return self.pet
end

-- Gets player trail inventory.
-- @return Player trail inventory.
function class:getTrail()
    return self.trail
end

-- Converts player inventory to a table.
-- @return Player inventory table.
function class:toTable()
    return {
        pets = self.pet:toTable(),
        trails = self.trail:toTable()
    }
end


-- ENDS
return class