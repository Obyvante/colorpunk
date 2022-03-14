local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local Endpoints = require(game.ServerScriptService.Project.Utils.Endpoints)
local Product = require(game.ServerScriptService.Project.Product.Product)
local HTTPService = Library.getService("HTTPService")
-- STARTS


local content = {}

-- Gets products.
-- @return Pets.
function class.getContent()
    return content
end

-- Finds product by its id. (SAFE)
-- @param _id Product id.
-- @return Product. (NULLABLE)
function class.find(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Product id cannot be null")
    return content[_id]
end

-- Gets product by its id.
-- @param _id Product id.
-- @return Product.
function class.get(_id : number)
    local _result = class.find(_id)
    assert(_result ~= nil, "Product(" .. _id .. ") cannot be null")
    return _result
end


----------
-- INITIALIZATION
----------

local time = os.time()

local response = HTTPService.GET(Endpoints.PRODUCT_ENDPOINT, { ["BARDEN-API-KEY"] = Endpoints.API_KEY })
-- If fetching data was not successfully, no need to continue.
if not response.Success then
	error("Couldn't get products from the backend! [1]")
end

local json = HTTPService.decodeJson(response.Body)
-- If backend response is not positive, no need to continue
if not json.success == true then
	error("Couldn't get products from the backend! [2] -> " .. json.error)
end

-- Handles products.
for _, _data in pairs(json.results) do
	content[_data.id] = Product.new(_data.id, _data.cap)
end

-- Informing successful initialization.
print("✔️", Library.getService("TableService").size(content), "products have been initialized in", os.time() - time, "ms!")


-- ENDS
return class