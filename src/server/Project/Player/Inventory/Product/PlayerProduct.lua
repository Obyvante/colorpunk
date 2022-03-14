local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local ProductProvider = Library.getService("ProductProvider")
-- STARTS


-- Creates a player product.
-- @param _player Player.
-- @param _id Product id.
-- @param _amount Product amount.
-- @return Created player product.
function class.new(_player : ModuleScript, _id : number, _amount : number)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_id ~= nil, "Player product id cannot be null")
    assert(_amount ~= nil, "Player product amount cannot be null")
    assert(type(_id) == "number", "Player product id must be a number")
    assert(type(_amount) == "number", "Player product amount must be a number")
    return setmetatable({
        player = _player,
        id = _id,
        amount = _amount,
    }, class)
end

-- Gets product logger prefix.
-- @return Product logger prefix.
function class:getPrefix()
    return "Player(" .. self.player:getId() .. ") product(" .. self.id .. ")"
end

-- Gets product.
-- @return Product.
function class:getProduct()
    return ProductProvider.get(self.id)
end

-- Gets player.
-- @return Player.
function class:getPlayer()
    return self.player
end

-- Gets product id.
-- @return Product id.
function class:getId()
    return self.id
end

-- Gets product amount.
-- @return Product amount.
function class:getAmount()
    return self.amount
end

-- Sets product amount.
-- @param _amount Amount to set.
-- @return Player product. (BUILDER)
function class:setAmount(_amount : number)
    -- Object nil checks.
    assert(_amount, self:getPrefix() .. " amount cannot be nil")
    assert(type(_amount) == "number", self:getPrefix() .. " amount must be a number")
    assert(_amount > 0, self:getPrefix() .. " amount must be higher than 0")

    -- Safety check.
    local product = self:getProduct()
    if _amount > product:getCap() then
        error(self:getPrefix() .. " amount must be lower than or equals to " .. product:getCap())
    end

    self.amount = _amount
    return self
end

-- Adds product amount.
-- @param _amount Amount to add.
-- @return Player product. (BUILDER)
function class:addAmount(_amount : number)
    -- Object nil checks.
    assert(_amount, self:getPrefix() .. " amount cannot be nil")
    assert(type(_amount) == "number", self:getPrefix() .. " amount must be a number")
    assert(_amount > 0, self:getPrefix() .. " amount must be higher than 0")

    -- Safety check.
    local product = self:getProduct()
    if self.amount + _amount > product:getCap() then
        error(self:getPrefix() .. " amount must be lower than or equals to " .. product:getCap())
    end

    self.amount += _amount
    return self
end

-- Removes product amount.
-- @param _amount Amount to remove.
-- @return Player product. (BUILDER)
function class:removeAmount(_amount : number)
    -- Object nil checks.
    assert(_amount, self:getPrefix() .. " amount cannot be nil")
    assert(type(_amount) == "number", self:getPrefix() .. " amount must be a number")
    assert(_amount > 0, self:getPrefix() .. " amount must be higher than 0")
    assert(self.amount - _amount > 0, self:getPrefix() .. " amount result must be higher than 0")

    self.amount -= _amount
    return self
end

-- Converts player product to a table.
-- @return Player product table.
function class:toTable()
    return {
       id = self.id,
       amount = self.amount
    }
end


-- ENDS
return class