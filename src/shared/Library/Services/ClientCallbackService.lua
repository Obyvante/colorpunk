local class = {}
-- IMPORTS
local EventService = require(script.Parent.EventService)
-- STARTS


-- Handles remote event callback with timeout system.
-- @param _name Remote event name.
-- @param _timeout Timeout duration. (seconds)
-- @param ... Arguments.
-- @return Server response.
function class.handle(_name : string, _timeout : number, ...) -- variadic arguments
    -- Object nil checks.
    assert(_name ~= nil, "Callback remote event name cannot be nil")
    assert(_timeout ~= nil, "Callback timeout duration cannot be nil")

    -- Gets event by its name.
    local _event = EventService.get(_name)

    -- Declares required fields.
    local completed, results
    local elapsed_time = 0
    local kill_queue = false

    -- Fires server and waits for the response.
    _event:FireServer(...)

    -- Creates a reciever that waits a reponse from the server.
    local reciever = coroutine.create(function()
        local temp = _event.OnClientEvent:Wait()

        -- If the server gave the answer before timeout, completes the thread.
        if not kill_queue then
            completed = true
            results = temp
        end
    end) coroutine.resume(reciever)

    -- Freezes current task to wait until timeout duration.
    while not completed and elapsed_time < _timeout do
        elapsed_time = elapsed_time + task.wait()
    end

    -- Bug and memory leak preventation.
    kill_queue = true
    reciever = nil

    -- If server has not responded, throws error.
    if not completed then error("Remote event(" .. _name .. ") callback timeout(" .. _timeout .. ")!") end

    return results
end


-- ENDS
return class