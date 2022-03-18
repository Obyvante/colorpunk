local class = {}
-- IMPORTS
local TaskService = require(script.Parent.TaskService)
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.content = {}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- METHODS (STARTS)
------------------------

-- Gets if cool down has started or not.
-- @param _id Cool down id.
-- @return True if it is not in cool down, otherwise it is in cool down.
function class.has(_id : string)
    return class.content[_id] ~= nil
end

-- Handles cool down.
-- @param _id Cool down id.
-- @param _duration Cool down duration.
-- @return True if it is not in cool down and just started, otherwise it is in cool down.
function class.handle(_id : string, _duration : number)
    -- Object nil checks.
    assert(_id ~= nil and _duration ~= nil)

    -- If it is in cool down, returns false.
    if class.content[_id] then return false end

    -- Handles cool down task.
    class.content[_id] = TaskService.createDelayed(_duration, function(_task)
        class.content[_id] = nil
    end):run()

    -- Returns true if it is just started.
    return true
end

-- Cancels cool down.
function class.cancel(_id : string)
    -- Object nil checks.
    assert(_id ~= nil)

    -- Cancels cool down.
    if class.content[_id] then
        class.content[_id]:cancel()
        class.content[_id] = nil
    end
end

------------------------
-- METHODS (ENDS)
------------------------


-- ENDS
return class