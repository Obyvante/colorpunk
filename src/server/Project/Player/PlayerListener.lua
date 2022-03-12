local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local SpamService = Library.getService("SpamService")
-- EVENTS
local PlayerLoadCompleteEvent = EventService.get("PlayerLoadComplete")
local PlayerSettingsEvent = EventService.get("PlayerSettings")
-- STARTS


------------------------
-- AUTOMATION (STARTS)
------------------------

-- Checks spam.
-- @param _player Player to kick.
-- @return Should kick or not.
function spamCheck(_player : Player)
    local status = SpamService.handle(_player.UserId .. "settings", 30, 30)
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
    if spamCheck(_player) then return end

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

PlayerSettingsEvent.OnServerEvent:Connect(function(_player, _packet)
    -- Prevents spamming.
    if spamCheck(_player) then return end

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


-- ENDS
return class