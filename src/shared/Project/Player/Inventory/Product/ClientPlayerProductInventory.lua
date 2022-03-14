local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local ClientPlayerProduct = require(game.ReplicatedStorage.Project.Player.Inventory.Product.ClientPlayerProduct)
local TableService = Library.getService("TableService")
-- STARTS


-- Updates player product inventory.
-- @param _player Player.
-- @param _content Player product inventory table.
-- @return Created player product inventory.
function class.update(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player product inventory table cannot be null")

    class.player = _player
    class.content = {}
    for key, value in pairs(_table) do
        class.content[tonumber(key)] = ClientPlayerProduct.new(_player, tonumber(value.id), tonumber(value.amount))
    end
    return class
end

-- Gets player.
-- @return Player.
function class.getPlayer()
    return class.player
end

-- Gets player products.
-- @return Player products.
function class.getContent()
    return TableService.values(class.content)
end

-- Finds player product by its id. (SAFE)
-- @param _id Player product id.
-- @return Player product. (NULLABLE)
function class.find(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Player product id cannot be null")
    return class.content[_id]
end

-- Gets player product by its id.
-- @param _id Player product id.
-- @return Player product.
function class.get(_id : number)
    local _result = class.find(_id)
    assert(_result ~= nil, "Player product(" .. _id .. ") cannot be null")
    return _result
end


-- ENDS
return class