local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local SpamService = Library.getService("SpamService")
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
        if spamCheck(_player, "REMOVE_PET", 60, 30) then return end

        -- Updates player settings.
        local success, message = pcall(function() player:getInventory():getPet():remove(_packet) end)

        -- Handles error.
        if not success then warn(_player.UserId .. " tried to remove their pet(" .. _packet .. ")", message) end
    elseif _type == "STATE_PET" then
        -- Prevents spamming.
        if spamCheck(_player, "STATE_PET", 60, 30) then return end

        -- Packet safety check.
        if _packet.UID == nil or _packet.STATE == nil then return end

        -- Updates player settings.
        local success, message = pcall(function()
            player:getInventory():getPet():get(_packet.UID):setActive(_packet.STATE)
            player:getInventory():getPet():_sendUpdatePacket()
            InventoryUpdateEvent:FireClient(player)
        end)

        -- Handles error.
        if not success then warn(_player.UserId .. " tried to change state of their pet(" .. _packet .. ") to " .. _packet.STATE, message) end
    elseif _type == "REMOVE_TRAIL" then
        -- Prevents spamming.
        if spamCheck(_player, "REMOVE_TRAIL", 60, 30) then return end

        -- Updates player settings.
        local success, message = pcall(function() player:getInventory():getTrail():remove(_packet) end)

        -- Handles error.
        if not success then warn(_player.UserId .. " tried to remove their trail(" .. _packet .. ")", message) end
    end
end)

------------------------
-- REQUEST (ENDS)
------------------------


-- ENDS
return class