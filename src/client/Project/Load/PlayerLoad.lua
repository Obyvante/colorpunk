local class = {}
-- IMPORTS
local client = game:GetService("Players").LocalPlayer
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local ClientCallbackService = Library.getService("ClientCallbackService")
-- STARTS


-- Handles exceptions.
local success, message = pcall(function() ClientPlayer.update(ClientCallbackService.handle("Player.PlayerLoad", 20)) end)

-- If it is not successfully, kicks player.
if not success then
    client:Kick(
[[


(ERROR: WAIT THRESHOLD)

We couldn't load your information from our system. 
Please try again after a while.

If you think it is a bug/an issue, please contact our staff or Roblox staff.
]]
    )
    task.wait(3)
    return nil
end


-- ENDS
return class