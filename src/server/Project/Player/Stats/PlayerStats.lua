local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
-- EVENTS
local PlayerUpdateEvent = EventService.get("Player.PlayerUpdate")
-- STARTS


-- Creates a player stats.
-- @param _player Player.
-- @param _table Player stats table.
-- @return Created player stats.
function class.new(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player stats table cannot be null")

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

-- Gets player stat value.
-- @param _type Player stat type.
-- @return Player stat value.
function class:get(_type : string)
    -- Object nil checks.
    assert(_type ~= nil, "Player stat type cannot be null")
    local _result = self.content[_type]
    return _result and _result or 0
end

-- Sets player stat value.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player stat type.
-- @param _value Value to set. (POSITIVE NUMBER)
function class:set(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player stat type cannot be null")
    assert(_value ~= nil, "Player stat value cannot be null")
    assert(_value >= 0, "Player stat value must be positive")
    self.content[_type] = _value

    -- Updates player character.
    self:updateCharacterAttributes()
    -- Sends update packet.
    self:_sendUpdatePacket(_type)
end

-- Adds value to player stat.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player stat type.
-- @param _value Value to add. (POSITIVE NUMBER)
function class:add(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player stat type cannot be null")
    assert(_value ~= nil, "Player stat value cannot be null")
    assert(_value >= 0, "Player stat value must be positive")
    self.content[_type] = math.max(self:get(_type) + _value, 0)

    -- Updates player character.
    self:updateCharacterAttributes()
    -- Sends update packet.
    self:_sendUpdatePacket(_type)
end

-- Removes value from player stat.
--
-- NOTE: Value cannot be negative
-- Otherwise, it'll convert to 0.
--
-- @param _type Player stat type.
-- @param _value Value to add. (POSITIVE NUMBER)
function class:remove(_type : string, _value : number)
    -- Object nil checks.
    assert(_type ~= nil, "Player stat type cannot be null")
    assert(_value ~= nil, "Player stat value cannot be null")
    assert(_value >= 0, "Player stat value must be positive")
    self.content[_type] = math.max(self:get(_type) - _value, 0)

    -- Updates player character.
    self:updateCharacterAttributes()
    -- Sends update packet.
    self:_sendUpdatePacket(_type)
end

-- Updates character attributes.
function class:updateCharacterAttributes()
    -- Gets roblox player and checks if it is online.
    local player = self.player:getRobloxPlayer()
    if not player then return end

    -- Declares required fields.
    local _products = self:getPlayer():getInventory():getProduct()
    local _bundle = _products:has(1248410416)
    local _speed = if _products:has(1248410518) or _bundle then 0.5 else 0
    local _jump = if _products:has(1248410451) or _bundle then 0.5 else 0

    -- Applies stats to roblox character.
    local _humanoid = player.Character.Humanoid
    _humanoid.WalkSpeed = game.StarterPlayer.CharacterWalkSpeed * ((self:get("WALK_SPEED") + 1) + _speed)
    _humanoid.JumpPower = game.StarterPlayer.CharacterJumpPower * ((self:get("JUMP_HEIGHT") + 1) + _jump)
end

-- Converts player stats to a table.
-- @return Player stats table.
function class:toTable()
    return self.content
end

-- Sends update packet for target type to client.
-- @param _type Stat type.
-- @return Player stats. (BUILDER)
function class:_sendUpdatePacket(_type : string)
    -- Object nil checks.
    assert(_type ~= nil, "Player stat type cannot be null")
    
    -- Gets roblox player and checks if it is online.
    local player = self.player:getRobloxPlayer()
    if not player then return end

    -- Sends update packet.
    PlayerUpdateEvent:FireClient(player, "stats", {
        Type = _type,
        Value = self.content[_type]
    })
    return self
end


-- ENDS
return class