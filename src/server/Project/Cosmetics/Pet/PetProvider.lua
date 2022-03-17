local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local Endpoints = require(game.ServerScriptService.Project.Utils.Endpoints)
local Pet = require(game.ServerScriptService.Project.Cosmetics.Pet.Pet)
local HTTPService = Library.getService("HTTPService")
-- STARTS


local content = {}

-- Gets pets.
-- @return Pets.
function class.getContent()
    return content
end

-- Finds pet by its id. (SAFE)
-- @param _id Pet id.
-- @return Pet. (NULLABLE)
function class.find(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Pet id cannot be null")
    return content[_id]
end

-- Gets pet by its id.
-- @param _id Pet id.
-- @return Pet.
function class.get(_id : number)
    local _result = class.find(_id)
    assert(_result ~= nil, "Pet(" .. _id .. ") cannot be null")
    return _result
end


----------
-- INITIALIZATION
----------

local time = os.time()

local response = HTTPService.GET(Endpoints.PET_ENDPOINT, { ["BARDEN-API-KEY"] = Endpoints.API_KEY })
-- If fetching data was not successfully, no need to continue.
if not response.Success then
	error("Couldn't get pets from the backend! [1]")
end

local json = HTTPService.decodeJson(response.Body)
-- If backend response is not positive, no need to continue
if not json.success then
	error("Couldn't get pets from the backend! [2] -> " .. json.error)
end

-- Handles pets.
for _, _data in pairs(json.results) do
	content[_data.id] = Pet.new(_data.id, _data.name, _data.iconId, _data.meshId, _data.textureId)
end

-- Informing successful initialization.
print("✔️", Library.getService("TableService").size(content), "pets have been initialized in", os.time() - time, "ms!")


-- ENDS
return class