local class = {}
class.__index = class
-- STARTS


-- Creates a trail.
-- @param _id Trail id.
-- @param _type Trail type.
-- @param _name Trail name.
-- @param _assetId Trail asset id. (ROBLOX PACKAGE)
-- @return Created trail.
function class.new(_id : number, _type : string, _name : string, _assetId : string)
    -- Object nil checks.
    assert(_id ~= nil, "Trail id cannot be null")
    assert(_type ~= nil, "Trail(" .. _id .. ") type cannot be null")
    assert(_name ~= nil, "Trail(" .. _id .. ") name cannot be null")
    assert(_assetId ~= nil, "Trail(" .. _id .. ") asset id cannot be null")

    local _trail = setmetatable({
        id = _id,
        type = _type,
        name = _name,
        asset_id = _assetId
    }, class)

    return _trail
end

-- Gets trail id.
-- @return Trail id.
function class:getId()
    return self.id
end

-- Gets trail type.
-- @return Trail type.
function class:getType()
    return self.type
end

-- Gets trail name.
-- @return Trail name.
function class:getName()
    return self.name
end

-- Gets trail asset id.
-- @return Trail asset id. (ROBLOX PACKAGE)
function class:getAssetId()
    return self.asset_id
end


-- ENDS
return class