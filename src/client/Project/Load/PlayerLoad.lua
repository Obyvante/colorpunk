local class = {}
-- IMPORTS
local client = game:GetService("Players").LocalPlayer
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
--local Player = require(game.ReplicatedStorage.Project.Player.Player)
local ClientCallbackService = Library.getService("ClientCallbackService")
-- STARTS


-- Handles exceptions.
local success, message = pcall(function()
    local _data = ClientCallbackService.handle("PlayerLoad", 10)
    print(_data)
end)

-- If it is not successfully, kicks player.
if not success then
    client:Kick([[


(ERROR: DATABASE)

We couldn't load your information from our system. 
Please try again after a while.

If you think it is a bug/an issue, please contact our staff or Roblox staff.
]])
    task.wait(5)
end


-- ENDS
return class