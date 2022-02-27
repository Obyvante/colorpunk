local class = {}
class.__index = class
-- IMPORTS
local HttpService = game:GetService("HttpService")
-- STARTS


-- VARIABLES
local _content = {}


-- Gets task by its id.
-- @param id Task id.
-- @return Task. (NULLABLE)
function class.getById(id : ObjectValue)
    -- Object nil checks.
    assert(id ~= nil, "Signal id cannot be null")
    return _content[id]
end

-- Creates a signal service.
-- @return Created signal service.
function class.create(_id : string)
    -- Object nil checks.
    assert(_id ~= nil, "Signal id cannot be null")

    -- If signal with same id is already exist, no need to continue.
    if class.getById(_id) ~= nil then error("Signal(" .. _id .. ") is already exist") end

    -- Creates a signal service.
    local _signal = {
        ["id"] = _id,
        ["event"] = Instance.new("BindableEvent"),
        ["dictionary"] = {},
        ["exist"] = true
    }

    -- Binds event to remove bounded event from the dictionary.
    -- Connecting a function to the 'BindableEvent' will add head
    -- of the list. Thus, below function will run last.
    _signal.event.Event:Connect(function(_key)
        _signal.dictionary[_key] = nil
    end)

    _content[_signal.id] = _signal

    -- Sets metatable and returns it.
    return setmetatable(_signal, class)
end

-- Gets signal metadata.
-- @return Metadata.
function class:getMetadata()
    if not self.metadata then
        self.metadata = require(script.Parent.Parent:WaitForChild("Templates"):WaitForChild("Metadata")).new()
    end
    return self.metadata
end

-- Gets signal id.
-- @return Signal service id.
function class:getId()
    return self.id
end

-- Fires event.
-- @param ... Arguments.
function class:fire(...)
    -- If signal service is destroyed, no need to continue.
    if not self.exist then error("Tried to use signal service even it is destroyed") end

    local _key = HttpService:GenerateGUID(false)
    local arguments = table.pack(...)

    self.dictionary[_key] = arguments

    self.event:Fire(_key)
end

-- Connects a function to the event.
-- Event will be triggered when 'fire' used.
-- @param _consumer Consumer(function) to run.
-- @return Bindable Event connection.
function class:connect(_consumer)
    -- If signal service is destroyed, no need to continue.
    if not self.exist then error("Tried to use signal service even it is destroyed") end

    -- If consumer(function) type is not function, no need to continue.
    if typeof(_consumer) ~="function" then error("Connection consumer(function) must be a function type") end

    -- Creates a connection for bindable event then returns it.
    return self.event.Event:Connect(function(_key)
        local arguments = self.dictionary[_key]
        if arguments == nil then error("Signal(" .. self.id .. ") has nil arguments(connection)") end

        -- Unpacks arguments then runs consumer(function).
        _consumer(table.unpack(self.dictionary[_key]))
    end)
end

-- Wait for fire to be called, and return the arguments it was given.
-- @yield
-- @return Consumer(function) arguments.
function class:wait()
    -- If signal service is destroyed, no need to continue.
    if not self.exist then error("Tried to use signal service even it is destroyed") end

    -- Waits for the key of the event.
    local _key = self.event:Wait()

    local arguments = self.dictionary[_key]
    if arguments == nil then error("Signal(" .. self.id .. ") has nil arguments(wait)") end

    -- Unpacks arguments then returns them.
    return table.unpack(self.dictionary[_key])
end

-- Destroys signal service.
function class:destroy()
    self.exist = false
    if self.metadata then self.metadata:reset() end
    self.event:Destroy()

    _content[self.id] = nil

    setmetatable(self, nil)
end


-- ENDS
return class