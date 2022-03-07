local class = {}
class.__index = class
-- IMPORTS
local TaskService = require(script.Parent.TaskService)
-- STARTS


local content = {}

-- Gets spam service by its name
-- @param _name Spam service name.
-- @return Spawm service.
function class.get(_name : string)
    -- Object nil checks.
    assert(_name ~= nil, "Spam service name cannot be nil")
    return content[_name]
end

-- Creates a spam service.
-- @param _name Spam name.
-- @param _size Spam size.
-- @param _duration Spam duration.
-- @return Spam service.
function class.create(_name : string, _size : number, _duration : number)
    -- Object nil checks.
    assert(_name ~= nil, "Spam service name cannot be nil")
    assert(_size ~= nil, "Spam service(" .. _name ..") size cannot be nil")
    assert(_duration ~= nil, "Spam service(" .. _name ..") duration cannot be nil")
    assert(_size > 0, "Spam service(" .. _name ..") size must be higher than 0")

    local _self = setmetatable({}, class)
    _self.name = _name
    _self.size = _size
    _self.duration = _duration
    _self.current = 0

    -- After a delay, removes it.
    TaskService.createDelayed(_duration, function() content[_name] = nil end):run()

    content[_name] = _self
    return _self
end

-- Checks if we should block or not.
-- @param _name Spam name.
-- @param _size Spam size.
-- @param _duration Spam duration.
-- @return If we should block or not.
function class.handle(_name : string, _size : number, _duration : number)
    -- Object nil checks.
    assert(_name ~= nil, "Spam service name cannot be nil")
    assert(_size ~= nil, "Spam service(" .. _name ..") size cannot be nil")
    assert(_duration ~= nil, "Spam service(" .. _name ..") duration cannot be nil")

    -- Declares required fields.
    local spam = content[_name]
    if spam == nil then spam = class.create(_name, _size, _duration) end

    return spam:count():isMaximum()
end

-- Gets spam service name.
-- @return Spam service name.
function class:getName()
    return self.name
end

-- Gets spam service size.
-- @return Spam service size.
function class:getSize()
    return self.size
end

-- Gets spam service consumer.
-- @return Spam service consumer.
function class:getConsumer()
    return self.consumer
end

-- Gets spam service current.
-- @return Spam service current.
function class:getCurrent()
    return self.current
end

-- Gets if it is a spam or not.
-- @return If it is a spam or not.
function class:isMaximum()
    return self.current > self.size
end

-- Counts.
-- @return Spam service. (BUILDER)
function class:count()
    self.current += 1
    return self
end


-- ENDS
return class