local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local PlayerInventory = require(game.ServerScriptService.Project.Player.Inventory.PlayerInventory)
local PlayerCurrencies = require(game.ServerScriptService.Project.Player.Currencies.PlayerCurrencies)
local PlayerStats = require(game.ServerScriptService.Project.Player.Stats.PlayerStats)
local PlayerSettings = require(game.ServerScriptService.Project.Player.Settings.PlayerSettings)
local PlayerStatistics = require(game.ServerScriptService.Project.Player.Statistics.PlayerStatistics)
local HTTPService = Library.getService("HTTPService")
local Metadata = Library.getTemplate("Metadata")
local EventBinder = Library.getTemplate("EventBinder")
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
    _player.currencies = PlayerCurrencies.new(_player, _table.currencies)
    _player.settings = PlayerSettings.new(_player, _table.settings)
    _player.stats = PlayerStats.new(_player, _table.stats)
    _player.statistics = PlayerStatistics.new(_player, _table.statistics)

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

-- Gets roblox player.
-- @return Roblox player.
function class:getRobloxPlayer()
    return game:GetService("Players"):GetPlayerByUserId(self.id)
end

-- Gets if player is waiting to be loaded or not.
-- @return If player is waiting to be loaded or not.
function class:isWaitingLoad()
    return self.waitLoading
end

-- Waits player to be loaded.
function class:waitLoading()
    self.wait_loading = true
end

-- Gets if player is loaded or not.
-- @return If player is loaded or not.
function class:isLoaded()
    return self.loaded
end

-- Completes player loading process.
function class:completeLoading()
    if not self.wait_loading then return end
    self.wait_loading = false
    self.loaded = true
end

-- Gets player roblox id.
-- @return Player roblox id.
function class:getId()
    return self.id
end

-- Gets player roblox name.
-- @return Player roblox name.
function class:getName()
    return self.name
end

-- Gets player inventory.
-- @return Player inventory.
function class:getInventory()
    return self.inventory
end

-- Gets player currencies.
-- @return Player currencies.
function class:getCurrencies()
    return self.currencies
end

-- Gets player stats.
-- @return Player stats.
function class:getStats()
    return self.stats
end

-- Gets player settings.
-- @return Player settings.
function class:getSettings()
    return self.settings
end

-- Gets player statistics.
-- @return Player statistics.
function class:getStatistics()
    return self.currencies
end

-- Destroys player.
function class:destroy()
    if self.metadata then self.metadata:reset() end
    if self.event_binder then self.event_binder:destroy() end

    setmetatable(self, nil)
end

-- Converts player to a table.
-- @return Player table.
function class:toTable()
    return {
        id = self.id,
        name = self.name,
        inventory = self.inventory:toTable(),
        currencies = self.currencies:toTable(),
        stats = self.stats:toTable(),
        settings = self.settings:toTable(),
        statistics = self.statistics:toTable()
    }
end

-- Converts player as a json string.
-- @return Player json string.
function class:toJson()
    return HTTPService.encodeJson(self:toTable())
    :gsub('"pets":%[%]', '"pets":{}')
    :gsub('"trails":%[%]', '"trails":{}')
	:gsub('"currencies":%[%]', '"currencies":{}')
	:gsub('"settings":%[%]', '"settings":{}')
	:gsub('"stats":%[%]', '"stats":{}')
	:gsub('"statistics":%[%]', '"statistics":{}')
end


-- ENDS
return class