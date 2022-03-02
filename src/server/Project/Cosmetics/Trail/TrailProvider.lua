local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local Endpoints = require(game.ServerScriptService.Project.Utils.Endpoints)
local HTTPService = Library.getService("HTTPService")
local Trail = require(game.ServerScriptService.Project.Cosmetics.Trail.Trail)
-- STARTS


local content = {}

-- Gets trails.
-- @return Trails.
function class.getContent()
    return content
end

-- Finds trail by its id. (SAFE)
-- @param _id Trail id.
-- @return Trail. (NULLABLE)
function class.find(_id : number)
    -- Object nil checks.
    assert(_id ~= nil, "Trail id cannot be null")
    return content[_id]
end

-- Gets trail by its id.
-- @param _id Trail id.
-- @return Trail.
function class.get(_id : number)
    local _result = class.find(_id)
    assert(_result ~= nil, "Trail(" .. _id .. ") cannot be null")
    return _result
end


----------
-- INITIALIZATION
----------

local response = HTTPService.GET(Endpoints.TRAIL_ENDPOINT, { ["BARDEN-API-KEY"] = Endpoints.API_KEY })
-- If fetching data was not successfully, no need to continue.
if not response.Success then
	error("Couldn't get trails from the backend! [1]")
end

local json = HTTPService.decodeJson(response.Body)
-- If backend response is not positive, no need to continue
if not json.success == true then
	error("Couldn't get trails from the backend! [2] -> " .. json.error)
end

-- Handles trails.
for _id, _data in pairs(json.results) do
	content[_id] = Trail.new(_id, _data.type, _data.name, _data.asset_id)
end

-- Informing successful initialization.
print(Library.getService("TableService").size(content), "trails are initialized successfully!")


-- ENDS
return class