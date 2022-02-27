local class = {}
class.__index = class
-- STARTS


-- Creates a pet.
-- @param _id Pet id.
-- @param _name Pet name.
-- @param _assetId Pet asset id. (ROBLOX PACKAGE)
-- @return Created pet.
function class.new(_id : number, _name : string, _assetId : string)
    -- Object nil checks.
    assert(_id ~= nil, "Pet id cannot be null")
    assert(_name ~= nil, "Pet(" .. _id .. ") name cannot be null")
    assert(_assetId ~= nil, "Pet(" .. _id .. ") asset id cannot be null")
    
    return setmetatable({
        id = _id,
        name = _name,
        asset_id = _assetId
    }, class)
end

-- Gets pet id.
-- @return Pet id.
function class:getId()
    return self.id
end

-- Gets pet name.
-- @return Pet name.
function class:getName()
    return self.name
end

-- Gets pet asset id.
-- @return Pet asset id. (ROBLOX PACKAGE)
function class:getAssetId()
    return self.asset_id
end


-- ENDS
return class