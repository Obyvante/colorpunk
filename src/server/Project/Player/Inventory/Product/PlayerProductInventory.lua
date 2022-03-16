local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local PlayerProduct = require(game.ServerScriptService.Project.Player.Inventory.Product.PlayerProduct)
local ProductProvider = Library.getService("ProductProvider")
local TableService = Library.getService("TableService")
local EventService = Library.getService("EventService")
-- EVENTS
local PlayerUpdateEvent = EventService.get("Player.PlayerUpdate")
-- STARTS


-- Creates a player product inventory.
-- @param _player Player.
-- @param _content Player product inventory table.
-- @return Created player product inventory.
function class.new(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player product inventory table cannot be null")

    local _inventory = setmetatable({
        player = _player,
        content = {}
    }, class)

    for key, value in pairs(_table) do
        _inventory.content[tonumber(key)] = PlayerProduct.new(_player, tonumber(value.id), tonumber(value.amount))
    end

    return _inventory
end

-- Gets player.
-- @return Player.
function class:getPlayer()
    return self.player
end

-- Gets player products.
-- @return Player products.
function class:getContent()
    return TableService.values(self.content)
end

-- Finds player product by its id. (SAFE)
-- @param _id Player product id.
-- @return Player product. (NULLABLE)
function class:find(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Player product id cannot be null")
    return self.content[_id]
end

-- Checks if player has product by its id or not.
-- @param _id Player product id.
-- @return If player has product by its id or not.
function class:has(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Player product id cannot be null")
    return self.content[_id] ~= nil
end

-- Gets player product by its id.
-- @param _id Player product id.
-- @return Player product.
function class:get(_id : number)
    local _result = self:find(_id)
    assert(_result ~= nil, "Player(" .. self.player:getId() .. ") product(" .. _id .. ") cannot be null")
    return _result
end

-- Creates a player product.
-- @param _id Product id.
-- @param _amount Product amount.
function class:add(_id : number, _amount : number)
    -- Object nil checks.
    assert(_id ~= nil, "Product id cannot be null")
    local _product = ProductProvider.find(_id)
    if _product == nil then error("product(" .. _id .. ") does not exist!") end

    local product = self:find(_id)
    if product ~= nil then
        product:addAmount(_amount)
    else
        if _amount > _product:getCap() then error("Player(" .. self.player:getId() .. ") product amount must be lower than or equals to " .. _product:getCap()) end
        product = PlayerProduct.new(self.player, _id, _amount)
        self.content[_id] = product
    end

    -- Sends update packet.
    self:_sendUpdatePacket()
end

-- Removes player product.
-- @param _id Player product id.
function class:remove(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Player(" .. self.player:getId() .. ") product id cannot be null")
    self.content[_id] = nil

    -- Sends update packet.
    self:_sendUpdatePacket()
end

-- Converts player product inventory to a table.
-- @return Player product inventory table.
function class:toTable()
    local _table = {}

    for key, value in pairs(self.content) do
        _table[key] = value:toTable()
    end

    return _table
end

-- Sends update packet for target type to client.
function class:_sendUpdatePacket()
    -- Gets roblox player and checks if it is online.
    local player = self.player:getRobloxPlayer()
    if not player then return end

    -- Sends update packet.
    PlayerUpdateEvent:FireClient(player, "INVENTORY_PRODUCT", self:toTable())
end


-- ENDS
return class