local class = {}
-- IMPORTS
local Endpoints = require(game.ServerScriptService.Project.Utils.Endpoints)
local PlayerHTTP = require(game.ServerScriptService.Project.Player.HTTP.PlayerHTTP)
local Library = require(game.ReplicatedStorage.Library.Library)
local TaskService = Library.getService("TaskService")
local TableService = Library.getService("TableService")
local HTTPService = Library.getService("HTTPService")
local EventService = Library.getService("EventService")
-- EVENTS
local ServerStateEvent = EventService.get("ServerState")
-- STARTS


-- Declares required fields.
_G.server_active = true
class.Active = true
class.Counter = 0


-- Handles player queue.
function handlePlayerQueue()
    -- Handles player queue.
    if _G.http_player_update_queue then
        local _keys = TableService.keys(_G.http_player_update_queue)

        local _success, _message = pcall(PlayerHTTP.updatesAsJson, _G.http_player_update_queue)
        if not _success then
            warn("---------------------")
            warn("PLAYERS UPDATES ERROR [IMPORTANT ISSUE!] (SERVER)")
            warn(_message)
            warn("---------------------")
        else
            -- Removes updated player from the list.
            for _, key in pairs(_keys) do _G.http_player_update_queue[key] = nil end
        end
    end
end


-- Server health check loop.
TaskService.createRepeating(3, function(_task)
    -- Handles task safely.
    local success, message = pcall(function()
        local response = HTTPService.GET(Endpoints.HEALTH_ENDPOINT, { ["BARDEN-API-KEY"] = Endpoints.API_KEY })
        -- If fetching data was not successfully, no need to continue.
        if not response.Success then error("Health check is unsuccessfully! [1]") end
    
        local json = HTTPService.decodeJson(response.Body)
        -- If backend response is not positive, no need to continue
        if not json.success == true then error("Health check is unsuccessfully! [1]", json.error) end
    end)

    -- If it is not successfully, increases counter.
    if not success then
        -- Prints error message to console.
        warn(message)

        _G.server_active = false
        class.Active = false
        class.Counter += 1

        -- Sends server state information to all clients.
        ServerStateEvent:FireAllClients(false)
        return
    end

    -- Handles queue tasks to process.
    if not class.Active then
        -- Handles player queue.
        handlePlayerQueue()
    end

    -- Declares it is successfully.
    _G.server_active = true
    class.Active = true
    class.Counter = 0

    -- Sends server state information to all clients.
    ServerStateEvent:FireAllClients(true)
end):run()



-- ENDS
return class