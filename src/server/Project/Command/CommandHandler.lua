local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local TableService = Library.getService("TableService")
local StringService = Library.getService("StringService")
local PlayerService = game:GetService("Players")
local DataStore = game:GetService("DataStoreService"):GetDataStore("Bans")
-- EVENTS
local CommandEvent = EventService.get("Command.Command")
-- STARTS


class.Admins = {
    2722028600,
    2717530962,
    2982337117
}

function class.findPlayerByName(_name : string)
    for key, value in pairs(PlayerService:GetPlayers()) do
        if value.Name == _name then
            return value
        end
    end
end

CommandEvent.OnServerEvent:Connect(function(player : Player, _command : string)
    task.spawn(function()
        -- Kick check.
        if not TableService.containsValue(class.Admins, player.UserId) then
            player:Kick("You don't have permission to use this command!")
            return
        end

        local cmdSuccess = false

        local success, message = pcall(function()
            if StringService.startsWith(_command, "ban") then
                local args = _command:gsub("ban ", ""):split(" ")
                local _target = class.findPlayerByName(args[1])
                if not _target then error("player(" .. args[1] .. ") not found!") end
                if TableService.containsValue(class.Admins, _target.UserId) then
                    error("You can't ban an admin!")
                    return
                end

                DataStore:SetAsync(_target.UserId, true)

                if _target then
                    _target:Kick("You've been banned from the server!")
                end

                cmdSuccess = true
            elseif StringService.startsWith(_command, "unban") then
                local args = _command:gsub("unban ", ""):split(" ")
                local _target = class.findPlayerByName(args[1])
                if not _target then
                    _target = PlayerService:GetUserIdFromNameAsync(args[1])
                    if not _target then error("player(" .. args[1] .. ") not found!") end
                end
                DataStore:RemoveAsync(_target)

                cmdSuccess = true
            else
                cmdSuccess = false
            end
        end)

        if not success then
            warn(message)
            cmdSuccess = false
        end

        CommandEvent:FireClient(player, cmdSuccess)
    end)
end)


-- ENDS
return class