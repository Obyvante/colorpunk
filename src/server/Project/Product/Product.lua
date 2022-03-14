local class = {}
class.__index = class
-- STARTS


-- Creates a product.
-- @param _id Product id.
-- @param _cap Product cap.
-- @return Created product.
function class.new(_id : number, _cap : number)
    -- Object nil checks.
    assert(_id ~= nil, "Product id cannot be null")
    assert(_cap ~= nil, "Product(" .. _id .. ") cap cannot be null")
    
    return setmetatable({
        id = _id,
        cap = _cap
    }, class)
end

-- Gets product id.
-- @return Product id.
function class:getId()
    return self.id
end

-- Gets product cap.
-- @return Product cap.
function class:getCap()
    return self.cap
end


-- ENDS
return class