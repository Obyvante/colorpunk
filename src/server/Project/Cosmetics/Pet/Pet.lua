local class = {}
class.__index = class
-- STARTS


-- Creates a pet.
-- @param _id Pet id.
-- @param _name Pet name.
-- @param _iconId Pet icon id. (ROBLOX ASSET ID)
-- @param _meshId Pet mesh id. (ROBLOX ASSET ID)
-- @param _textureId Pet texture id. (ROBLOX ASSET ID)
-- @return Created pet.
function class.new(_id : number, _name : string, _iconId : string, _meshId : string, _textureId : string)
    -- Object nil checks.
    assert(_id ~= nil, "Pet id cannot be null")
    assert(_name ~= nil, "Pet(" .. _id .. ") name cannot be null")
    assert(_iconId ~= nil, "Pet(" .. _id .. ") icon id cannot be null")
    assert(_meshId ~= nil, "Pet(" .. _id .. ") mesh id cannot be null")
    assert(_textureId ~= nil, "Pet(" .. _id .. ") texture id cannot be null")
    
    return setmetatable({
        id = _id,
        name = _name,
        iconId = _iconId,
        meshId = _meshId,
        textureId = _textureId
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

-- Gets pet icon id.
-- @return Pet icon id. (ROBLOX ASSET ID)
function class:getIconId()
    return self.iconId
end

-- Gets pet mesh id.
-- @return Pet mesh id. (ROBLOX ASSET ID)
function class:getMeshId()
    return self.iconId
end

-- Gets pet texture id.
-- @return Pet texture id. (ROBLOX ASSET ID)
function class:getTextureId()
    return self.iconId
end


-- ENDS
return class