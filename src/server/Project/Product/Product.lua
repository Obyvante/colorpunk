local class = {}
class.__index = class
-- STARTS


-- Creates a product.
-- @param _id Product id.
-- @param _type Product type.
-- @param _name Product name.
-- @param _item If product is an item or not. (If it is not an item, it'll not add to your inventory.)
-- @param _cap Product cap.
-- @param _metadata Product metadata.
-- @return Created product.
function class.new(_id : number, _type : string, _name : string, _item : boolean, _cap : number, _metadata : table)
    -- Object nil checks.
    assert(_id ~= nil, "Product id cannot be null")
    assert(_type ~= nil, "Product(" .. _id .. ") type cannot be null")
    assert(_name ~= nil, "Product(" .. _id .. ") name cannot be null")
    assert(_item ~= nil, "Product(" .. _id .. ") item cannot be null")
    assert(_cap ~= nil, "Product(" .. _id .. ") cap cannot be null")

    return setmetatable({
        id = _id,
        type = _type,
        name = _name,
        item = _item,
        cap = _cap,
        metadata = _metadata or {}
    }, class)
end

-- Gets product id.
-- @return Product id.
function class:getId()
    return self.id
end

-- Gets product type.
-- @return Product type.
function class:getType()
    return self.type
end

-- Gets product name.
-- @return Product name.
function class:getName()
    return self.name
end

-- Gets if product is an item or not. (If it is not an item, it'll not add to your inventory.)
-- @return If product is an item or not.
function class:isItem()
    return self.item
end

-- Gets product cap.
-- @return Product cap.
function class:getCap()
    return self.cap
end

-- Gets product metadata.
-- @return Product metadata.
function class:getMetadata()
    return self.metadata
end

-- Gets product metadata value by its key.
-- @return Product metadata value.
function class:getMetadataValue(_key : string)
    --Object nil checks.
    assert(_key ~= nil)
    return self.metadata[_key]
end

-- Gets if product metadata exist or not.
-- @return If product metadata exist or not.
function class:hasMetadata(_key : string)
    --Object nil checks.
    assert(_key ~= nil)
    return self.metadata[_key] ~= nil
end


-- ENDS
return class