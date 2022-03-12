local class = {}
-- IMPORTS
local Endpoints = require(game.ServerScriptService.Project.Utils.Endpoints)
local PlayerHTTP = require(game.ServerScriptService.Project.Player.HTTP.PlayerHTTP)
local Library = require(game.ReplicatedStorage.Library.Library)
local TaskService = Library.getService("TaskService")
local TableService = Library.getService("TableService")
local HTTPService = Library.getService("HTTPService")
local EventService = Library.getService("EventService")
local PlayerProvider = Library.getService("PlayerProvider")
local StatisticsProvider = Library.getService("StatisticsProvider")
local DataStore = game:GetService("DataStoreService"):GetDataStore("Restore")
-- EVENTS
local ServerStateEvent = EventService.get("ServerState")
-- STARTS


-- Declares required fields.
_G.server_active = true
class.Active = true
class.Counter = 0


-- Saves player queue.
function class.savePlayerQueue()
    -- If player queue is empty.
    if _G.http_player_update_queue == nil then return end
    
    -- Converts queue to a list.
    local _keys = TableService.keys(_G.http_player_update_queue)
    if #_keys == 0 then return end

    -- Updates it.
    PlayerHTTP.updatesAsJson(_G.http_player_update_queue)

    -- Removes updated player from the list.
    for _, key in pairs(_keys) do _G.http_player_update_queue[key] = nil end
end

-- Handles player queue.
function class.handlePlayerQueue()
    local _success, _message = pcall(class.savePlayerQueue)
    
    -- Warns if execution was unsuccessfully.
    if not _success then
        warn("---------------------")
        warn("PLAYERS UPDATES ERROR [IMPORTANT ISSUE!] (SERVER)")
        warn(_message)
        warn("---------------------")
    end
end


-- Server health check loop.
TaskService.createRepeating(3, function(_task)
    -- Handles saving in background. (ASYNC)
    task.spawn(function()
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

            -- Statistics.
            if class.Counter == 1 then StatisticsProvider.addGame("FAILED_HEALTH_CHECK_REQUEST", 1) end
            return
        end

        -- Handles queue tasks to process.
        if not class.Active then
            -- Handles player queue.
            class.handlePlayerQueue()
        end

        -- Declares it is successfully.
        _G.server_active = true
        class.Active = true
        class.Counter = 0

        -- Sends server state information to all clients.
        ServerStateEvent:FireAllClients(true)
    end)
end):run()

-- Make server waits for queue.
game:BindToClose(function()
    -- Declares base fields.
    local time = os.time()
    local timer = 0
    local completed = {}

    while true do
        timer += 1
        if timer >= 5 then break end

        -- Handles last saving.
        local success, message = pcall(function()
            -- Handles player queue saving.
            if not completed.player_queue then
                class.savePlayerQueue()
                completed.player_queue = true
            end

            -- Handles player saving.
            if not completed.players then
                if TableService.size(PlayerProvider.getContent()) > 0 then PlayerHTTP.updates(PlayerProvider.getContent()) end
                completed.players = true
            end

            -- Handles statistics saving.
            if not completed.statistics then
                StatisticsProvider.save()
                completed.statistics = true
            end
        end)

        -- If it was not successfully, no need to continue.
        if not success then
            warn("Couldn't save informations to the database! -> " .. message)
            task.wait(1)
            continue
        end

        -- Exits loop.
        break
    end

    -- If the system couldn't save the data, it'll save to data store.
    if timer >= 5 then
        while true do
            -- Handles last saving.
            local success, message = pcall(function()
                -- In queue player data.
                if not completed.player_queue then
                    for _, player in pairs(_G.http_player_update_queue) do DataStore:SetAsync("player:" .. player.id, player) end
                    completed.player_queue = true
                end

                -- Player data in server.
                if not completed.players then
                    for id, player in pairs(PlayerProvider.getContent()) do DataStore:SetAsync("player:" .. id, player:toTable()) end
                    completed.players = true
                end

                -- Handles statistics saving.
                if not completed.statistics then
                    DataStore:SetAsync("statistics", StatisticsProvider.content)
                    completed.statistics = true
                end
            end)

            -- If it was not successfully, no need to continue.
            if not success then
                warn("Couldn't save informations to the data store! -> " .. message)
                task.wait(0.5)
                continue
            end

            -- Informs server about what happened.
            print("Restoration data saved to Roblox data store!")
            break
        end
    end

    -- Informs server.
    print("✔️ Colorpunk server has saved in", os.time() - time, "ms!")
end)



-- ENDS
return class