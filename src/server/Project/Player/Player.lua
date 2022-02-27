local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local Metadata = Library.getTemplate("Metadata")
local EventBinder = Library.getTemplate("EventBinder")
local PlayerInventory = require(game.ServerScriptService.Project.Player.Inventory.PlayerInventory)
-- STARTS


-- Creates a player.
-- @param _table Player table.
-- @return Created player.
function class.new(_table : table)
    -- Object nil checks.
    assert(_table ~= nil, "Player table cannot be null")

    local _player = setmetatable({
        id = _table.id,
        name = _table.name
    }, class)
    _player.inventory = PlayerInventory.new(_player, _table.inventory)

    return _player
end

-- Gets player metadata.
-- @return Metadata.
function class:getMetadata()
    if not self.metadata then self.metadata = Metadata.new() end
    return self.metadata
end

-- Gets player event binder.
-- @return Player event binder.
function class:getEventBinder()
    if not self.event_binder then self.event_binder = EventBinder.new(self) end
    return self.event_binder
end

-- Destroys player.
function class:destroy()
    if self.metadata then self.metadata:reset() end
    if self.event_binder then self.event_binder:destroy() end

    setmetatable(self, nil)
end

-- Converts player to table.
-- @return Player table.
function class:toTable()
    return {
        id = self.id,
        name = self.name,
        inventory = self.inventory:toTable()
    }
end


-- ENDS
return class