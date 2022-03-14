local class = {}
-- PATHS
local PlayerFolder = game.ReplicatedStorage.Project.Player
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local ClientPlayerInventory = require(PlayerFolder.Inventory.ClientPlayerInventory)
local ClientPlayerCurrencies = require(PlayerFolder.Currencies.ClientPlayerCurrencies)
local ClientPlayerStats = require(PlayerFolder.Stats.ClientPlayerStats)
local ClientPlayerSettings = require(PlayerFolder.Settings.ClientPlayerSettings)
local ClientPlayerStatistics = require(PlayerFolder.Statistics.ClientPlayerStatistics)
local Metadata = Library.getTemplate("Metadata")
local EventBinder = Library.getTemplate("EventBinder")
-- STARTS


class.initialized = false

-- Gets if player is initialized or not.
-- @return If player is initialized or not.
function class.isInitialized()
    return class.initialized
end

-- Updates player.
-- @param _table Player table.
-- @return Player.
function class.update(_table : table)
    -- Object nil checks.
    assert(_table ~= nil, "Player table cannot be null")

    -- Handles initialization.
    if not class.initialized then
        class.id = _table.id
        class.name = _table.name
        class.rank = _table.rank
        class.inventory = ClientPlayerInventory.update(class, _table.inventory)
        class.currencies = ClientPlayerCurrencies.update(class, _table.currencies)
        class.settings = ClientPlayerSettings.update(class, _table.settings)
        class.stats = ClientPlayerStats.update(class, _table.stats)
        class.statistics = ClientPlayerStatistics.update(class, _table.statistics)
        class.initialized = true
        return class
    end

    -- Handles updates.
    class.inventory.update(_table.inventory)
    class.currencies.update(class, _table.currencies)
    class.settings.update(class, _table.settings)
    class.stats.update(class, _table.stats)
    class.statistics.update(class, _table.statistics)

    return class
end

-- Gets player metadata.
-- @return Metadata.
function class.getMetadata()
    if not class.metadata then class.metadata = Metadata.new() end
    return class.metadata
end

-- Gets player event binder.
-- @return Player event binder.
function class.getEventBinder()
    if not class.event_binder then class.event_binder = EventBinder.new(class) end
    return class.event_binder
end

-- Gets player roblox id.
-- @return Player roblox id.
function class.getId()
    return class.id
end

-- Gets player roblox name.
-- @return Player roblox name.
function class.getName()
    return class.name
end

-- Gets player inventory.
-- @return Player inventory.
function class.getInventory()
    return class.inventory
end

-- Gets player currencies.
-- @return Player currencies.
function class.getCurrencies()
    return class.currencies
end

-- Gets player stats.
-- @return Player stats.
function class.getStats()
    return class.stats
end

-- Gets player settings.
-- @return Player settings.
function class.getSettings()
    return class.settings
end

-- Gets player statistics.
-- @return Player statistics.
function class.getStatistics()
    return class.statistics
end

-- Gets player rank.
function class.getRank()
    return class.rank
end

-- Sets player rank.
-- @param _rank Player rank.
-- @return Player. (BUULDER)
function class.setRank(_rank : number)
    assert(_rank ~= nil, "Rank cannot be nil")
    class.rank = _rank
    return class
end


-- ENDS
return class