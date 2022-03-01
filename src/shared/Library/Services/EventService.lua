local class = {}
-- IMPORTS
local LoaderService = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Services"):WaitForChild("LoaderService"))
-- STARTS


-- Gets remote event by its name.
-- @param _path Remote event path/name.
-- @return Remote event.
function class.get(_path : string)
    -- Object nil checks.
    assert(_path ~= nil, "Remote event name cannot be nil")

    local _event = LoaderService.waitChild(game.ReplicatedStorage, "Events." .. _path)
    assert(_event ~= nil, "Remote event(" .. _path .. ") cannot be nil")

    return _event
end


-- ENDS
return class