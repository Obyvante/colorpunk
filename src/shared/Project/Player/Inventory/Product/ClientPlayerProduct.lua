local class = {}
class.__index = class
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


-- ENDS
return class