local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local HTTPService = Library.getService("HTTPService")
local Endpoints = require(game.ServerScriptService.Project.Endpoints)
-- STARTS


-- Handles player creation/getting.
-- @param _id Player id.
-- @param _name Player name.
-- @return Player table.
function class.handle(_id : number, _name : string)
    -- Object nil checks.
    assert(_id ~= nil, "Player id cannot be null")
    assert(_name ~= nil, "Player name cannot be null")

    local response = HTTPService.GET(Endpoints.PLAYER_ENDPOINT .. "handle?id=" .. _id .. "&name=" .. _name .. "&insert=yes", { ["BARDEN-API-KEY"] = Endpoints.API_KEY })
    -- If fetching data was not successfully, no need to continue.
    if not response.Success then
        error("Couldn't get player(" .. _id .. ") from the backend! [1]")
    end

    local json = HTTPService.decodeJson(response.Body)
    -- If backend response is not positive, no need to continue
    if not json.success == true then
        error("Couldn't get player(" .. _id .. ") from the backend! [2] -> " .. json.error)
    end

    return json.results
end


-- ENDS
return class