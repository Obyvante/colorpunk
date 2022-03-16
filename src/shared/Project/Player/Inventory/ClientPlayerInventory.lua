local class = {}
class.__index = class
-- IMPORTS
local ClientPlayerPetInventory = require(game.ReplicatedStorage.Project.Player.Inventory.Pet.ClientPlayerPetInventory)
local ClientPlayerTrailInventory = require(game.ReplicatedStorage.Project.Player.Inventory.Trail.ClientPlayerTrailInventory)
local ClientPlayerProductInventory = require(game.ReplicatedStorage.Project.Player.Inventory.Product.ClientPlayerProductInventory)
-- STARTS


class.initialized = false

-- Gets if player inventory is initialized or not.
-- @return If player inventory is initialized or not.
function class.isInitialized()
    return class.initialized
end

-- Updates a player inventory.
-- @param _player Player.
-- @param _table Player inventory table.
-- @return Created player inventory.
function class.update(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player inventory table cannot be null")

    -- Handles initialization.
    if not class.initialized then
        class.player = _player
        class.pet = ClientPlayerPetInventory.update(_player, _table.pets)
        class.trail = ClientPlayerTrailInventory.update(_player, _table.trails)
        class.product = ClientPlayerProductInventory.update(_player, _table.products)
    end

    -- Handles updates.
    class.pet.update(_player, _table.pets)
    class.trail.update(_player, _table.trails)
    class.product.update(_player, _table.products)
    return class
end

-- Gets player.
-- @return Player.
function class.getPlayer()
    return class.player
end

-- Gets player pet inventory.
-- @return Player pet inventory.
function class.getPet()
    return class.pet
end

-- Gets player trail inventory.
-- @return Player trail inventory.
function class.getTrail()
    return class.trail
end

-- Gets player product inventory.
-- @return Player product inventory.
function class.getProduct()
    return class.product
end


-- ENDS
return class