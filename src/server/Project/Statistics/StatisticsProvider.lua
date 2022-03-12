local class = {}
-- IMPORTS
local Endpoints = require(game.ServerScriptService.Project.Utils.Endpoints)
local Library = require(game.ReplicatedStorage.Library.Library)
local TaskService = Library.getService("TaskService")
local HTTPService = Library.getService("HTTPService")
local TableService = Library.getService("TableService")
local DataStore = game:GetService("DataStoreService"):GetDataStore("Restore")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.content = {
    Game = {},
    Players = {}
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- METHODS (STARTS)
------------------------

------------------------
-- GAME (STARTS)
------------------------

-- Sets statistic value to game content.
-- @param _type Statistic type.
-- @param _value Statistic value to add.
-- @eturn Statistics. (BUILDER)
function class.setGame(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Statistic type cannot be nil")
    assert(_value ~= nil, "Statistic value cannot be nil")
    assert(_value >= 0, "Statistic value must be positive")

    class.content.Game[_type] = _value
    return class
end

-- Adds statistic value to game content.
-- @param _type Statistic type.
-- @param _value Statistic value to add.
-- @eturn Statistics. (BUILDER)
function class.addGame(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Statistic type cannot be nil")
    assert(_value ~= nil, "Statistic value cannot be nil")
    assert(_value >= 0, "Statistic value must be positive")

    local previous_value = class.content.Game[_type]
    class.content.Game[_type] = previous_value and previous_value + _value or _value

    return class
end

-- Removes statistic value from game content.
-- @param _type Statistic type.
-- @param _value Statistic value to add.
-- @eturn Statistics. (BUILDER)
function class.removeGame(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Statistic type cannot be nil")
    assert(_value ~= nil, "Statistic value cannot be nil")
    assert(_value >= 0, "Statistic value must be positive")

    local previous_value = class.content.Game[_type]
    class.content.Game[_type] = previous_value and math.max(previous_value - _value, 0) or _value

    return class
end

------------------------
-- GAME (ENDS)
------------------------


------------------------
-- PLAYER (STARTS)
------------------------

-- Sets statistic value to player content.
-- @param _id Player id. (ROBLOX USER ID)
-- @param _type Statistic type.
-- @param _value Statistic value to add.
-- @eturn Statistics. (BUILDER)
function class.setPlayer(_id : number, _type : string, _value : number)
    -- Object nil checks.
    assert(_id ~= nil, "Player id cannot be nil")
    assert(_type ~= nil, "Statistic type cannot be nil")
    assert(_value ~= nil, "Statistic value cannot be nil")
    assert(_value >= 0, "Statistic value must be positive")

    -- If player doesn't have any data.
    if class.content.Players[_id] == nil then class.content.Players[_id] = {} end

    class.content.Players[_id][_type] = _value
    return class
end

-- Adds statistic value to player content.
-- @param _id Player id. (ROBLOX USER ID)
-- @param _type Statistic type.
-- @param _value Statistic value to add.
-- @eturn Statistics. (BUILDER)
function class.addPlayer(_id : number, _type : string, _value : number)
    -- Object nil checks.
    assert(_id ~= nil, "Player id cannot be nil")
    assert(_type ~= nil, "Statistic type cannot be nil")
    assert(_value ~= nil, "Statistic value cannot be nil")
    assert(_value >= 0, "Statistic value must be positive")

    -- If player doesn't have any data.
    if class.content.Players[_id] == nil then class.content.Players[_id] = {} end

    local previous_value = class.content.Players[_id][_type]
    class.content.Players[_id][_type] = previous_value and previous_value + _value or _value
    return class
end

-- Removes statistic value from player content.
-- @param _id Player id. (ROBLOX USER ID)
-- @param _type Statistic type.
-- @param _value Statistic value to add.
-- @eturn Statistics. (BUILDER)
function class.removePlayer(_id : number, _type : string, _value : number)
    -- Object nil checks.
    assert(_id ~= nil, "Player id cannot be nil")
    assert(_type ~= nil, "Statistic type cannot be nil")
    assert(_value ~= nil, "Statistic value cannot be nil")
    assert(_value >= 0, "Statistic value must be positive")

    -- If player doesn't have any data.
    if class.content.Players[_id] == nil then class.content.Players[_id] = {} end

    local previous_value = class.content.Players[_id][_type]
    class.content.Players[_id][_type] = previous_value and math.max(previous_value - _value, 0) or _value
    return class
end

------------------------
-- PLAYER (ENDS)
------------------------

------------------------
-- METHODS (ENDS)
------------------------


------------------------
-- LOOP (STARTS)
------------------------

function class.save()
    -- If there is no statistics to save, no need to continue.
    if TableService.size(class.content.Game) == 0 and TableService.size(class.content.Players) == 0 then return end

    -- Creates request body.
    local request_body = HTTPService.encodeJson({
        players = class.content.Players,
        overall = class.content.Game
    })
    :gsub('"players":%[%]', '"players":{}')
    :gsub('"overall":%[%]', '"overall":{}')

    -- Handles HTTP response.
    local response = HTTPService.POST(Endpoints.STATISTICS_ENDPOINT, request_body, { ["BARDEN-API-KEY"] = Endpoints.API_KEY })
    if not response.Success then error("Couldn't save satistics! [DB-1]") end

    -- Handles json answer.
    local json = HTTPService.decodeJson(response.Body)
    if not json.success == true then error("Couldn't save satistics! [DB-2] -> " .. json.error) end

    -- Resets
    class.content = {
        Game = {},
        Players = {}
    }
end

TaskService.create(90, 90, function(_task)
    -- Handles saving in background. (ASYNC)
    task.spawn(function()
        -- Handles exceptions.
        local success, message = pcall(class.save)

        -- Informs about errors.
        if not success then
            warn("Couldn't save statistics! -> " .. message)
            
            -- Statistics.
            class.addGame("FAILED_STATISTICS_UPDATE_REQUEST", 1)
        end
    end)
end):run()

-- Restore old data.
local _table = DataStore:GetAsync("statistics")
if _table ~= nil then
    class.content = _table
    -- Removes restoration data.
    DataStore:RemoveAsync("statistics")

    -- Informs server.
    warn("Statistics are restored!")
end

------------------------
-- LOOP (ENDS)
------------------------


-- ENDS
return class