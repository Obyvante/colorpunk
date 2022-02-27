local class = {}
class.__index = class
-- IMPORTS
local TaskService = require(script.Parent.Parent:WaitForChild("Services"):WaitForChild("TaskService", 999))
local StringService = require(script.Parent.Parent:WaitForChild("Services"):WaitForChild("StringService", 999))
-- STARTS


-- VARIABLES
local EXPIRE_SUFFIX = "[=!:expirable:!=]"


-- Creates a metadata module.
-- @return Created metadata module.
function class.new()
    return setmetatable({
        ["_content"] = {}
    }, class)
end

-- Converts key to the expirable key.
-- @param _key Key to convert.
-- @return Converted key. (Expirable key)
function toExpireKey(_key : string)
    -- Object nil checks.
    assert(_key ~= nil, "Metadata key cannot be null")
    return typeof(_key) == "string" and _key .. EXPIRE_SUFFIX or _key + EXPIRE_SUFFIX
end

-- Gets if metadata key is exist or not.
-- @param _key Metadata key.
-- @return Answer. (BOOLEAN)
function class:has(_key : ObjectValue)
    -- Object nil checks.
    assert(_key ~= nil, "Metadata key cannot be null")
    return self._content[_key] ~= nil
end

-- Gets metadata value by its key.
-- @param _key Metadata key.
-- @return Metadata value. [OBJECT] (NULLABLE)
function class:get(_key : ObjectValue, _default : ObjectValue)
    -- Object nil checks.
    assert(_key ~= nil, "Metadata key cannot be null")
    local result = self._content[_key]
    -- If result is nil and default value is set, returns default value instead of nil.
    if result == nil and _default ~= nil then return _default end
    return result
end

-- Sets metadata value by key.
-- @param _key Metadata key.
-- @param _value Metadata value.
-- @return Metadata. (BUILDER)
function class:set(_key : ObjectValue, _value : ObjectValue)
    -- Object nil checks.
    assert(_key ~= nil, "Metadata key cannot be null")
    assert(_value ~= nil, "Metadata value cannot be null")

    local _expire_key = toExpireKey(_key)

    -- If the metadata key is already created and is expirable, removes it and cancels the task.
    if self:has(_expire_key) then
        self:get(_expire_key):cancel()
        self._content[_key] = nil
        self._content[_expire_key] = nil
    end

    self._content[_key] = _value
    return self
end

-- Sets metadata value by key with expire feature.
-- @param _key Metadata key.
-- @param _value Metadata value.
-- @param _delay Delay to expire metadata key.
-- @param _consumer Consumer(function) to run when metadata key expires.
-- @return Metadata. (BUILDER)
function class:setExpirable(_key : ObjectValue, _value : ObjectValue, _delay : number, _consumer : ObjectValue)
    -- Object nil checks.
    assert(_key ~= nil, "Metadata key cannot be null")
    assert(_value ~= nil, "Metadata value cannot be null")
    assert(_delay ~= nil, "Metadata delay cannot be null")
    -- Illegal field checks.
    assert(_delay > 0, "Metadata delay must be higher than 0")

    self:set(_key, _value)

    local _expire_key = toExpireKey(_key)
    self._content[_expire_key] = TaskService.create(_delay, nil, function(_task)
        self._content[_key] = nil
        self._content[_expire_key] = nil
        if _consumer ~= nil then _consumer(self) end
    end):run()
    return self
end

-- Adds metadata value.
-- @param _key Metadata key.
-- @return Metadata. (BUILDER)
function class:add(_key : ObjectValue)
    return self:set(_key, 0)
end

-- Adds metadata value with expire feature.
-- @param _key Metadata key.
-- @param _delay Delay to expire metadata key.
-- @param _consumer Consumer(function) to run when metadata key expires.
-- @return Metadata. (BUILDER)
function class:addExpirable(_key : ObjectValue, _delay : number, _consumer : ObjectValue)
    return self:setExpirable(_key, 0, _delay, _consumer)
end

-- Removes metadata value by its key.
-- @param _key Metadata key.
-- @return Metadata. (BUILDER)
function class:remove(_key : ObjectValue)
    self._content[_key] = nil
    return self
end

-- Resets metadata.
function class:reset()
    for key, value in pairs(self._content) do
        if not StringService.endsWith(key, EXPIRE_SUFFIX) then continue end
        -- Cancels expire task.
        value:cancel()
    end
    self._content = {}
end


-- ENDS
return class