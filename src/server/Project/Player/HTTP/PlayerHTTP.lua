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

-- Sends player update request to the backend.
-- @param _player Player.
function class.update(_player : ModuleScript)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")

    local response = HTTPService.POST(Endpoints.PLAYER_UPDATE_ENDPOINT, _player:toJson(), { ["BARDEN-API-KEY"] = Endpoints.API_KEY })
    -- If fetching data was not successfully, no need to continue.
    if not response.Success then
        error("Couldn't send player(" .. _player:getId() .. ") update request to the backend! [1]")
    end

    local json = HTTPService.decodeJson(response.Body)
    -- If backend response is not positive, no need to continue
    if not json.success == true then
        error("Couldn't send player(" .. _player:getId() .. ") update request to the backend! [2] -> " .. json.error)
    end
end

-- Sends players update request to the backend.
-- @param _players Players.
function class.updates(_players : table)
    -- Object nil checks.
    assert(_players ~= nil, "Players cannot be null")

    -- Converts player as a table then saves it to the players table.
    local players = {}
    for key, value in pairs(_players) do players[key] = value:toTable() end

    -- Creates request body json string.
    local request_body = HTTPService.encodeJson(players)
                        :gsub('"pets":%[%]', '"pets":{}')
                        :gsub('"trails":%[%]', '"trails":{}')
                        :gsub('"currencies":%[%]', '"currencies":{}')
                        :gsub('"settings":%[%]', '"settings":{}')
                        :gsub('"stats":%[%]', '"stats":{}')
                        :gsub('"statistics":%[%]', '"statistics":{}')

    local response = HTTPService.POST(Endpoints.PLAYER_UPDATES_ENDPOINT, request_body, { ["BARDEN-API-KEY"] = Endpoints.API_KEY })
    -- If fetching data was not successfully, no need to continue.
    if not response.Success then
        error("Couldn't send players update request to the backend! [1]")
    end

    local json = HTTPService.decodeJson(response.Body)
    -- If backend response is not positive, no need to continue
    if not json.success == true then
        error("Couldn't send players update request to the backend! [2] -> " .. json.error)
    end
end


-- ENDS
return class