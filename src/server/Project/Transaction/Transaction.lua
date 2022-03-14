local class = {}
class.__index = class
-- IMPORTS
local HTTP = require(script.Parent.HTTP.TransactionHTTP)
local Library = require(game.ReplicatedStorage.Library.Library)
local HTTPService = Library.getService("HTTPService")
-- STARTS


-- Creates a transaction.
-- @param _product Product it.
-- @param _buyer Roblox user id.
-- @param _price Product price.
-- @return Transaction.
function class.new(_product : number, _buyer : number, _price : number)
    -- Object nil checks.
    assert(_product ~= nil)
    assert(_buyer ~= nil)
    assert(_price ~= nil)

    return setmetatable({
        product = _product,
        buyer = _buyer,
        price = _price
    }, class)
end

-- Gets transaction product.
-- @return Transaction product.
function class:getProduct()
    return self.product
end

-- Gets transaction buyer.
-- @return Transaction buyer. (ROBLOX USER ID)
function class:getBuyer()
    return self.buyer
end

-- Gets transaction price.
-- @return Transaction price.
function class:getPrice()
    return self.price
end

-- Converts transaction to a table.
-- @return Transaction table.
function class:toTable()
    return {
        product = self.product,
        buyer = self.buyer,
        price = self.price
    }
end

-- Converts player to a json.
-- @return Player json.
function class:toJson()
    return HTTPService.encodeJson(self:toTable())
end

-- Sends HTTP reuqest to the backend.
function class:send()
    HTTP.send(self)
end


-- ENDS
return class