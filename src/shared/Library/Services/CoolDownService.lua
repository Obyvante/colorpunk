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

-- Handles cool down.
-- @param _id Cool down id.
-- @param _duration Cool down duration.
-- @return True if it is not in cool down and just started, otherwise it is in cool down.
function class.handle(_id : string, _duration : number)
    -- Object nil checks.
    assert(_id ~= nil and _duration ~= nil)

    -- If it is in cool down, returns false.
    if class.content[_id] then return false end
    class.content[_id] = true

    -- Handles cool down task.
    TaskService.createDelayed(_duration, function(_task)
        class.content[_id] = nil
    end):run()

    -- Returns true if it is just started.
    return true
end

------------------------
-- METHODS (ENDS)
------------------------


-- ENDS
return class