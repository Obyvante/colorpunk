local class = {}
class.__index = class
-- IMPORTS
local Endpoints = require(game.ServerScriptService.Project.Utils.Endpoints)
local Library = require(game.ReplicatedStorage.Library.Library)
local HTTPService = Library.getService("HTTPService")
local TableService = Library.getService("TableService")
local PlayerProvider = Library.getService("PlayerProvider")
local StatisticsProvider = Library.getService("StatisticsProvider")
-- STARTS


-- Creates a leaderboard.
-- @param _type Statistic type.
-- @return Leaderboard.
function class.new(_type : string)
    local self = setmetatable({}, class)
    self.type = _type
    self.content = {}
    self.players = {}
    return self
end

-- Gets statistic type.
-- @return Statistic type.
function class:getType()
    return self.type
end

-- Gets leaderboard entries.
-- @return Leaderboard entries.
function class:getContent()
    return self.content
end

-- Updates leaderboard.
function class:update()
    local success, message = pcall(function()
        -- Creates request body.
        local request_body = self.type == "WIN" and HTTPService.encodeJson({
            type = self.type,
            players = TableService.keys(PlayerProvider.getContent())
        }) or HTTPService.encodeJson({
            type = self.type
        })

        -- Handles HTTP response.
        local response = HTTPService.POST(Endpoints.LEADERBOARD_ENDPOINT, request_body, { ["BARDEN-API-KEY"] = Endpoints.API_KEY })
        if not response.Success then error("Couldn't get leaderboard(" .. self.type .. ") from the backend! [1]") end

        -- Handles json answer.
        local json = HTTPService.decodeJson(response.Body)
        if not json.success then error("Couldn't get leaderboard(" .. self.type .. ") from the backend! [2] -> " .. json.error) end

        -- Updates class fields.
        self.content = json.results

        -- Handles player responses.
        self.players = json.responses
        if json.responses then
            for key, value in pairs(self.players) do
                -- Gets player and if it is not active, no need to continue.
                local _player = PlayerProvider.find(tonumber(key))
                if _player == nil then continue end

                -- Updates player rank.
                _player:setRank(value)
            end
        end
    end)

    -- Informs about errors.
    if not success then
        warn("Couldn't update leaderboard(" .. self.type ..")! -> " .. message)

        -- Statistics.
        StatisticsProvider.addGame("FAILED_LEADERBOARD_REQUEST", 1)
    end
end


-- ENDS
return class