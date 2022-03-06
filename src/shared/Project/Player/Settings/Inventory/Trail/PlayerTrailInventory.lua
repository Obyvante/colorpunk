local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local PlayerTrail = require(game.ServerScriptService.Project.Player.Cosmetics.Trail.PlayerTrail)
local TrailProvider = Library.getService("TrailProvider")
local TableService = Library.getService("TableService")
local HTTPService = Library.getService("HTTPService")
-- STARTS


-- Creates a player trail inventory.
-- @param _player Player.
-- @param _content Player trail inventory table.
-- @return Created player trail inventory.
function class.new(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player trail inventory table cannot be null")

    local _inventory = setmetatable({ player = _player, content = {} }, class)

    for key, value in pairs(_table) do
        _inventory.content[key] = PlayerTrail.new(_player, value.uid, value.id, value.active)
    end

    return _inventory
end

-- Gets player.
-- @return Player.
function class:getPlayer()
    return self.player
end

-- Gets player trails.
-- @return Player trails.
function class:getContent()
    return TableService.values(self.content)
end

-- Finds player trail by its unique id. (SAFE)
-- @param _uid Player trail unique id.
-- @return Player trail. (NULLABLE)
function class:find(_uid : number)
    -- Object nil checks.
    assert(_uid ~= nil, "Player trail unique id cannot be null")
    return self.content[_uid]
end

-- Gets player trail by its unique id.
-- @param _uid Player trail unique id.
-- @return Player trail.
function class:get(_uid : number)
    local _result = self:find(_uid)
    assert(_result ~= nil, "Player(" .. self.player:getId() .. ") trail(" .. _uid .. ") cannot be null")
    return _result
end

-- Creates a player trail.
-- @param _id Trail id.
-- @return Created player trail.
function class:add(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Trail id cannot be null")
    if TrailProvider.find(_id) == nil then error("trail(" .. _id .. ") does not exist!") end

    local player_trail = PlayerTrail.new(self.player, HTTPService.randomUUID(), _id, false)

    self.content[player_trail:getUID()] = player_trail
    return player_trail
end

-- Removes player trail.
-- @param _uid Player trail unique id.
-- @return Player trail inventory. (BUILDER)
function class:remove(_uid : string)
    -- Object nil checks.
    assert(_uid ~= nil, "Player trail unique id cannot be null")
    self.content[_uid] = nil
    return self
end

-- Converts player trail inventory to a table.
-- @return Player trail inventory table.
function class:toTable()
    local _table = {}

    for key, value in pairs(self.content) do
        _table[key] = value:toTable()
    end

    return _table
end



-- ENDS
return class