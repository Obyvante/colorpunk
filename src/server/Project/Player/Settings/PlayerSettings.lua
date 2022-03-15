local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
-- EVENTS
local PlayerUpdateEvent = EventService.get("Player.PlayerUpdate")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

-- Enum functions.
local _types_boolean_checker = function(_value : number) return _value == 0 or _value == 1 end

-- Types (ENUM)
class.Types = {
    VFX = {
        DEFAULT = 1,
        TYPE = "BOOLEAN",
        CheckType = _types_boolean_checker
    },
    MUSIC = {
        DEFAULT = 1,
        TYPE = "BOOLEAN",
        CheckType = _types_boolean_checker
    },
    SKIP_WARNING_SCREEN = {
        DEFAULT = 0,
        TYPE = "BOOLEAN",
        CheckType = _types_boolean_checker
    },
    AUTO_ACCEPT_MATCH = {
        DEFAULT = 0,
        TYPE = "BOOLEAN",
        CheckType = _types_boolean_checker
    }
}

------------------------
-- VARIABLES (ENDS)
------------------------


-- Creates a player settings.
-- @param _player Player.
-- @param _table Player settings table.
-- @return Created player settings.
function class.new(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player settings table cannot be null")

    return setmetatable({
        player = _player,
        content = _table
    }, class)
end

-- Gets player.
-- @return Player.
function class:getPlayer()
    return self.player
end

-- Gets player setting value.
-- @param _type Player setting type.
-- @return Player setting value.
function class:get(_type : string)
    -- Object nil checks.
    assert(_type ~= nil, "Player setting type cannot be null")
    assert(class.Types[_type] ~= nil, "Player setting type is not exist")
    local _result = self.content[_type]
    return _result == nil and class.Types[_type].DEFAULT or _result
end

-- Gets player setting value as a boolean.
-- @param _type Player setting type.
-- @return Player setting value as a boolean.
function class:asBoolean(_type : string)
    return self:get(_type) == 1
end

-- Sets player setting value.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player setting type.
-- @param _value Value to set. (POSITIVE NUMBER)
function class:set(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player setting type cannot be null")
    assert(class.Types[_type] ~= nil, "Player setting type is not exist")
    assert(_value ~= nil, "Player setting value cannot be null")
    assert(_value >= 0, "Player setting value must be positive")
    self.content[_type] = math.floor(_value)

    -- Gets roblox player and checks if it is online.
    local player = self.player:getRobloxPlayer()
    if not player then return end

    -- Sends update packet.
    PlayerUpdateEvent:FireClient(player, "settings", {
        Type = _type,
        Value = _value
    })
end

-- Handles player settings packet.
-- @param _packet Player settings packet.
-- @return Player settings. (BUILDER)
function class:handlePacket(_packet : table)
    -- Safety check. (NIL)
    if _packet == nil or type(_packet) ~= "table" or _packet.Type == nil or _packet.Value == nil then return end
    -- Safety check. (INSIDE [A])
    if class.Types[_packet.Type] == nil or not class.Types[_packet.Type].CheckType(_packet.Value) then return end

    -- Updates setting value.
    self.content[_packet.Type] = math.floor(_packet.Value)
    return self
end

-- Converts player settings to a table.
-- @return Player settings table.
function class:toTable()
    return self.content
end


-- ENDS
return class