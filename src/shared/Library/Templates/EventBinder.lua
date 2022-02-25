local class = {}
class.__index = class
-- STARTS


-- Creates an event binder.
-- @param _parent Parent to bind. (OPTIONAL)
-- @return Event binder.
function class.new(_parent : ModuleScript)
    return setmetatable({
        ["parent"] = _parent,
        ["events"] = {}
    }, class)
end

-- Gets parent.
-- @return Event binder parent. (NULLABLE)
function class:getParent()
    return self.parent
end

-- Gets event by its id.
-- @param _id Event id.
-- @return Binded element.
function class:get(_id : string)
    -- Object nil checks.
    assert(_id ~= nil, "Custom event id cannot be null[get event]")
    return self.events[_id]
end

-- Creates an event and binds to target instance.
--
-- Example event data to pass;
-- {
--   Name = "My Unique Event Name",
--   Consumer = function(_binder, _event_data_to_catch) then
--      print("yey")
--   do
-- }
--
-- @param _instance Instance to bind event.
-- @param _event Event data.
-- @return Event binder. (BUILDER)
function class:bind(_instance : Instance, _event : table)
    -- Object nil checks.
    assert(_instance ~= nil, "Custom event cannot be null")
    assert(_event ~= nil, "Custom event data cannot be null")
    assert(self.events[_event.Name] == nil, "Custom event(" .. _event.Name .. ") is already exsist[bind]")

    -- Connects an event to the given instance.
    self.events[_event.Name] = _instance:Connect(function(...)
        -- Runs declared consumer(function) with declared arguments.
        --
        -- NOTE: It'll copy the table to pass data. Why don't we use "SignalService" to
        -- solve this problem? Unfortunately, there might be 'server-side' events to handle.
        -- We cannot pass signal data to client-side to server-side.
        _event.Consumer(self, ...)
    end)
    return self
end

-- Unbinds event.
-- @param _id Event id.
-- @return Event binder. (BUILDER)
function class:unbind(_id : string)
    -- Object nil checks.
    assert(_id ~= nil, "Custom event id cannot be null")
    assert(self.events[_id] ~= nil, "Custom event(" .. _id .. ") is not exsist[unbind]")

    self.events[_id]:Disconnect()
    self.events[_id] = nil

    return self
end

-- Destroys event binder.
-- It'll make all events to disconnect. (MEMORY SAFE)
function class:destroy()
    for _, value in pairs(self.events) do value:Disconnect() end
    setmetatable(self, nil)
end


-- ENDS
return class