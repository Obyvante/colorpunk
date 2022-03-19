local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local Player = require(game.ServerScriptService.Project.Player.Player)
local PlayerHTTP = require(game.ServerScriptService.Project.Player.HTTP.PlayerHTTP)
local SignalService = Library.getService("SignalService")
local TaskService = Library.getService("TaskService")
local EventService = Library.getService("EventService")
local TableService = Library.getService("TableService")
local StatisticsProvider = Library.getService("StatisticsProvider")
local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")
local DataStore = game:GetService("DataStoreService"):GetDataStore("Restore")
local DataStoreBan = game:GetService("DataStoreService"):GetDataStore("Bans")
-- STARTS


local content = {}

-- Gets players.
-- @return Players.
function class.getContent()
    return content
end

-- Finds player by its id. (SAFE)
-- @param _id Player id.
-- @return Player. (NULLABLE)
function class.find(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Player id cannot be null")
    return content[_id]
end

-- Gets player by its id.
-- @param _id Player id.
-- @return Player.
function class.get(_id : number)
    local _result = class.find(_id)
    assert(_result ~= nil, "Player(" .. _id .. ") cannot be null")
    return _result
end

-- Removes player by its id.
-- @param _id Player id.
function class.remove(_id : number)
    local _player = class.find(_id)
    assert(_player ~= nil, "Player(" .. _id .. ") cannot be null")

    _player:destroy()
    content[_id] = nil
end


------------------------
-- TASKS (STARTS)
-----------------------

-- Player cache updater.
-- Every 90 seconds.
TaskService.create(90, 90, function(_task)
    -- If table 
    if TableService.size(content) == 0 then return end

    -- Async task.
    task.spawn(function()
        -- Safe http request.
        local success, message = pcall(PlayerHTTP.updates, content)

        -- If it is no successfully, warns server about that.
        if not success then
            warn(" ")
            warn("PLAYERS UPDATES ERROR [IMPORTANT ISSUE!]")
            warn(message)
            warn(" ")

            -- Statistics.
            StatisticsProvider.addGame("FAILED_PLAYER_UPDATES_REQUEST", 1)
        end
    end)
end):run()

------------------------
-- TASKS (ENDS)
-----------------------


------------------------
-- REMOTE EVENTS (STARTS)
------------------------

-- Gets remote events about player.
local player_load = EventService.get("Player.PlayerLoad")

-- [PLAYER LOAD]
player_load.OnServerEvent:Connect(function(player)
    local timer = 0
    task.spawn(function()
        local _player = class.find(player.UserId)

        -- Waits database to assign player to cache.
        while true do
            -- Gets player every time.
            _player = class.find(player.UserId)
            -- If player is exist, exit loop.
            if _player ~= nil then break end

            timer += task.wait()
            if timer >= 10 then return end
            if player == nil then return end
        end

        -- If it is unsuccessfully.
        if timer >= 10 or player == nil then
            -- Statistics.
            StatisticsProvider.addGame("FAILED_PLAYER_JOIN", 1)
            return
        end

        -- Waits player character.
        if player and not player.Character then player.CharacterAdded:Wait() end

        -- If player is left the experience, no need to continue.
        if player == nil then return end

        -- Gets player again to make sure it is online.
        _player = class.find(player.UserId)
        if _player == nil then return end

        -- If player is in deleting process, no need to continue.
        if _player:isDeleting() then return end
        -- Marks that player class needs loading confirimation.
        _player:waitLoading()

        -- Fires client.
        player_load:FireClient(player, _player:toTable(true))
    end)
end)

------------------------
-- REMOTE EVENTS (ENDS)
------------------------


------------------------
-- SIGNAL HANDLERS (PLAYER JOIN) (STARTS)
------------------------

-- Creates player join signal.
local signal_player_join = SignalService.create("PlayerJoin")
local signal_player_leave = SignalService.create("PlayerLeave")

-- Connects actual event.
signal_player_join:connect(function(player)
    task.spawn(function()
        local _retries = 0
        while _retries < 5 do
            -- Handles exception.
            local success, message = pcall(function()
                -- Safety check.
                local _player = class.find(player.UserId)
                if _player then return end

                -- Ban check.
                if DataStoreBan:GetAsync(player.UserId) then
                    player:Kick("You're banned from the server!")
                    return
                end

                -- Restoration.
                local _table = DataStore:GetAsync("player:" .. player.UserId)
                local _restored = _table ~= nil

                -- Content process.
                _table = _table == nil and PlayerHTTP.handle(player.UserId, player.Name) or _table
                _player = Player.new(_table)
                content[_table.id] = _player

                -- Handles restoration.
                if _restored then
                    -- Informs.
                    warn("Player(" .. player.UserId .. ") restored!")
                    -- Removes player backup from the data store.
                    DataStore:RemoveAsync("player:" .. player.UserId)
                end

                -- Statistics.
                StatisticsProvider.addGame("PLAYER_JOINED", 1)
                if _table.new then StatisticsProvider.addGame("UNIQUE_PLAYER_JOINED", 1) end
            end)

            -- Informs server about player.
            if not success then
                warn("Player(" .. player.UserId .. ") couldn't loaded from the backend! (signal) -> " .. message)

                -- Statistics.
                StatisticsProvider.addGame("FAILED_PLAYER_JOIN_REQUEST", 1)
            else
                break
            end
            _retries += 1
            task.wait(0.2)
        end
    end)
end)

-- Fires player join signal when player join.
PlayersService.PlayerAdded:Connect(function(player)
    signal_player_join:fire(player)
end)

-- Handles player leave.
PlayersService.PlayerRemoving:Connect(function(player)
    -- First player leave signal.
    signal_player_leave:fire(player)

    if not _G.http_player_update_queue then _G.http_player_update_queue = {} end

    -- Finds player.
    local _player = class.find(player.UserId)
    if _player == nil then return end

    -- Statistics.
    _player:getStatistics():add("PLAYTIME", os.time() - _player:getJoinTime())
    -- Statistics. [GLOBAL]
    StatisticsProvider.addGame("PLAYER_LEFT", 1)
    StatisticsProvider.addGame("PLAYTIME", os.time() - _player:getJoinTime())

    -- Handles not active server.
    if not _G.server_active then
        -- Saves player to the cache.
         _G.http_player_update_queue[player.UserId] = _player:toTable()

        -- Removes player from the cache.
        class.remove(player.UserId)
        return
    end

    -- Marks player is currently deleting.
    _player:waitDeleting()

    -- Async task.
    task.spawn(function()
        -- Safe http request.
        local success, message = pcall(PlayerHTTP.update, _player)

        -- Saves player to the cache.
        if not success then _G.http_player_update_queue[player.UserId] = _player:toTable() end

        -- Removes player from the cache.
        class.remove(player.UserId)

        -- If it is no successfully, warns server about that.
        if not success then
            warn("---------------------")
            warn("PLAYERS UPDATE(" .. player.UserId .. ") ERROR [IMPORTANT ISSUE!]")
            warn(message)
            warn("---------------------")

            -- Statistics.
            StatisticsProvider.addGame("FAILED_PLAYER_UPDATE_REQUEST", 1)
        end
    end)
end)

-- If it is studio, call player join signal manually.
if RunService:IsStudio() then
    for _, value in pairs(PlayersService:GetPlayers()) do
        task.spawn(function() signal_player_join:fire(value) end)
    end
end

------------------------
-- SIGNAL HANDLERS (PLAYER JOIN) (ENDS)
------------------------


------------------------
-- IMPORTS (STARTS)
------------------------

require(script.Parent.PlayerListener)

------------------------
-- IMPORTS (ENDS)
------------------------


-- ENDS
return class