local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local SpamService = Library.getService("SpamService")
-- EVENTS
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
spamming settings interface.

If you think it is a bug/an issue, please contact our staff or Roblox staff.
]]
    )

    return true
end

------------------------
-- AUTOMATION (ENDS)
------------------------


------------------------
-- SETTINGS (STARTS)
------------------------

PlayerSettingsEvent.OnServerEvent:Connect(function(_player, _packet)
    -- Declares required fields.
    local PlayerProvider = Library.getService("PlayerProvider")
    local player = PlayerProvider.find(_player.UserId)

    -- Prevents spamming.
    if spamCheck(_player) then return end

    -- Updates player settings.
    player:getSettings():handlePacket(_packet)
end)

------------------------
-- SETTINGS (ENDS)
------------------------


-- ENDS
return class