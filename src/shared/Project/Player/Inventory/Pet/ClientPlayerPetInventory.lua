local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local ClientPlayerPet = require(game.ReplicatedStorage.Project.Player.Cosmetics.Pet.ClientPlayerPet)
local TableService = Library.getService("TableService")
local EventService = Library.getService("EventService")
-- EVENTS
local PlayerRequestEvent = EventService.get("Player.PlayerRequest")
-- STARTS


-- Updates player pet inventory.
-- @param _player Player.
-- @param _content Player pet inventory table.
-- @return Created player pet inventory.
function class.update(_player : ModuleScript, _table : table)
    -- Object nil checks.
    assert(_player ~= nil, "Player cannot be null")
    assert(_table ~= nil, "Player pet inventory table cannot be null")

    class.player = _player
    class.content = {}
    for key, value in pairs(_table) do
        class.content[key] = ClientPlayerPet.new(_player, key, value.id, tonumber(value.assetId), value.active)
    end
    return class
end

-- Gets player.
-- @return Player.
function class.getPlayer()
    return class.player
end

-- Gets player pets.
-- @return Player pets.
function class.getContent()
    return TableService.values(class.content)
end

-- Finds player pet by its unique id. (SAFE)
-- @param _uid Player pet unique id.
-- @return Player pet. (NULLABLE)
function class.find(_uid : string)
    -- Object nil checks.
    assert(_uid ~= nil, "Player pet unique id cannot be null")
    return class.content[_uid]
end

-- Gets player pet by its unique id.
-- @param _uid Player pet unique id.
-- @return Player pet.
function class.get(_uid : string)
    local _result = class.find(_uid)
    assert(_result ~= nil, "Player pet(" .. _uid .. ") cannot be null")
    return _result
end

-- Sends player pet state request to the backend.
-- @param _uid Player pet uid.
function class.stateRequest(_uid : string, _state : boolean)
    PlayerRequestEvent:FireServer("STATE_PET", {
        UID = class.get(_uid):getUID(), -- Getting player pet to prevent nil.
        STATE = _state
    })
end

-- Sends player pet remove request to the backend.
-- @param _uid Player pet uid.
function class.removeRequest(_uid : string)
    PlayerRequestEvent:FireServer("REMOVE_PET", class.get(_uid):getUID()) -- Getting player pet to prevent nil.
end


-- ENDS
return class