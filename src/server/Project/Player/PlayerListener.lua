local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local SpamService = Library.getService("SpamService")
local TableService = Library.getService("TableService")
-- EVENTS
local PlayerLoadCompleteEvent = EventService.get("Player.PlayerLoadComplete")
local PlayerUpdateEvent = EventService.get("Player.PlayerUpdate")
local PlayerRequestEvent = EventService.get("Player.PlayerRequest")
local InventoryUpdateEvent = EventService.get("Inventory.InventoryUpdate")
-- STARTS


------------------------
-- AUTOMATION (STARTS)
------------------------

-- Checks spam.
-- @param _player Player to kick.
-- @return Should kick or not.
function spamCheck(_player : Player, _id : string, _maximum : number, _duration : number)
    local status = SpamService.handle(_player.UserId .. _id, _maximum, _duration)
    if not status then return false end

    _player:Kick(
[[


(ERROR: SPAMMING)
            
You've kicked from the experience due to
spamming.

If you think it is a bug/an issue, please contact our staff or Roblox staff.
]]
    )

    return true
end

------------------------
-- AUTOMATION (ENDS)
------------------------


------------------------
-- LOAD COMPLETE (STARTS)
------------------------

PlayerLoadCompleteEvent.OnServerEvent:Connect(function(_player)
    -- Prevents spamming.
    if spamCheck(_player, "load", 10, 10) then return end

    -- Declares required fields.
    local PlayerProvider = Library.getService("PlayerProvider")
    local player = PlayerProvider.find(_player.UserId)

    -- If player is not exist, no need to continue.
    if not player then return end

    -- Completes player loading stage.
    player:completeLoading()
end)

------------------------
-- LOAD COMPLETE (ENDS)
------------------------


------------------------
-- SETTINGS (STARTS)
------------------------

PlayerUpdateEvent.OnServerEvent:Connect(function(_player, _type, _packet)
    -- Prevents spamming.
    if _type ~= "settings" or spamCheck(_player, "settings", 60, 30) then return end

    -- Declares required fields.
    local PlayerProvider = Library.getService("PlayerProvider")
    local player = PlayerProvider.find(_player.UserId)

    -- If player is not exist, no need to continue.
    if not player then return end

    -- Updates player settings.
    player:getSettings():handlePacket(_packet)
end)

------------------------
-- SETTINGS (ENDS)
------------------------


------------------------
-- REQUEST (STARTS)
------------------------

PlayerRequestEvent.OnServerEvent:Connect(function(_player, _type, _packet)
    -- Safety check.
    if _type == nil then return end

    -- Declares required fields.
    local PlayerProvider = Library.getService("PlayerProvider")
    local player = PlayerProvider.find(_player.UserId)

    -- If player is not exist, no need to continue.
    if not player then return end

    -- Handles types.
    if _type == "REMOVE_PET" then
        -- Prevents spamming.
        if spamCheck(_player, _type, 60, 30) then return end

        -- Updates player settings.
        local success, message = pcall(function()
            for _, value in pairs(_packet) do
                player:getInventory():getPet():remove(value, false)
            end
            player:getInventory():getPet():_sendUpdatePacket()
            InventoryUpdateEvent:FireClient(_player)
        end)

        -- Handles error.
        if not success then warn(_player.UserId .. " tried to remove their pet(" .. _packet .. ")", message) end
    elseif _type == "STATE_PET" then
        -- Prevents spamming.
        if spamCheck(_player, _type, 60, 30) then return end

        -- Packet safety check.
        if _packet == nil or typeof(_packet) ~= "table" or #_packet == 0 then return end

        -- Updates player pet states.
        local success, message = pcall(function()
            -- Declares required fields.
            local _actives = TableService.size(player:getInventory():getPet():getContentByState(true))

            -- Loops through packet content.
            for _, value in pairs(_packet) do
                -- Safety checl.
                if typeof(value.STATE) ~= "boolean" then continue end

                -- Declares required fields for player pet.
                local _pet = player:getInventory():getPet():get(value.UID)
                local _change = _pet:isActive() ~= value.STATE
                if not _change then continue end

                -- Increasment for active size.
                if _change and not value.STATE then
                    _actives -= 1
                elseif _change and value.STATE then
                    _actives += 1
                end

                -- Checks if active size is 4 already.
                if _actives > 4 then break end
                
                -- Sets player pet state.
                _pet:setActive(value.STATE)
            end

            -- Updates entity positions.
            player:getInventory():getPet():updateEntities()

            -- Sends update about pet states.
            player:getInventory():getPet():_sendUpdatePacket()
            -- Updates client player inventory.
            InventoryUpdateEvent:FireClient(_player)
        end)

        -- Handles error.
        if not success then
            warn(_player.UserId .. " tried to change state of their pet")
            warn(message)
        end
    else
        -- Prevents spamming. (EMPTY PACKET)
        if spamCheck(_player, "empty_request", 60, 30) then return end
    end
end)

------------------------
-- REQUEST (ENDS)
------------------------


-- ENDS
return class