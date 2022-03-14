local class = {}
-- IMPORTS
local Endpoints = require(game.ServerScriptService.Project.Utils.Endpoints)
local Library = require(game.ReplicatedStorage.Library.Library)
local HTTPService = Library.getService("HTTPService")
-- STARTS


-- Sends transaction information to the backend server.
-- @param _transaction Transaction.
function class.send(_transaction : ModuleScript)
    -- Object nil checks.
    assert(_transaction ~= nil)

    local response = HTTPService.POST(Endpoints.TRANSACTION_ENDPOINT, _transaction:toJson(), { ["BARDEN-API-KEY"] = Endpoints.API_KEY })
    -- If fetching data was not successfully, no need to continue.
    if not response.Success then
        error("Couldn't send transaction information to the backend! [1]")
    end

    local json = HTTPService.decodeJson(response.Body)
    -- If backend response is not positive, no need to continue
    if not json.success then
        error("Couldn't send transaction information to the backend! [2] -> " .. json.error)
    end
end


-- ENDS
return class