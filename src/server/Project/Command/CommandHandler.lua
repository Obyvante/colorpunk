local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local TableService = Library.getService("TableService")
local StringService = Library.getService("StringService")
local ProductProvider = Library.getService("ProductProvider")
local PetProvider = Library.getService("PetProvider")
local PlayerProvider = Library.getService("PlayerProvider")
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
            elseif StringService.startsWith(_command, "givepet") then
                local args = _command:gsub("givepet ", ""):split(" ")
                local _target = class.findPlayerByName(args[1])
                if not _target then error("player(" .. args[1] .. ") not found!") end

                local _player = PlayerProvider.get(_target.UserId)
                _player:getInventory():getPet():add(tonumber(args[2]))

                cmdSuccess = true
            elseif StringService.startsWith(_command, "give") then
                local args = _command:gsub("give ", ""):split(" ")
                local _target = class.findPlayerByName(args[1])
                if not _target then error("player(" .. args[1] .. ") not found!") end

                local productName = args[2]:gsub("_", " ")
                local product = ProductProvider.findByName(productName)
                if not product then
                    if not _target then error("product(" .. productName .. ") not found!") end
                end

                local _player = PlayerProvider.get(_target.UserId)
                _player:getInventory():getProduct():add(product:getId(), 1)
                _player:getInventory():getStats():updateCharacterAttributes()

                cmdSuccess = true
            elseif StringService.startsWith(_command, "remove") then
                local args = _command:gsub("remove ", ""):split(" ")
                local _target = class.findPlayerByName(args[1])
                if not _target then error("player(" .. args[1] .. ") not found!") end

                local productName = args[2]:gsub("_", " ")
                local product = ProductProvider.findByName(productName)
                if not product then
                    if not _target then error("product(" .. productName .. ") not found!") end
                end

                local _player = PlayerProvider.get(_target.UserId)
                _player:getInventory():getProduct():remove(product:getId())
                _player:getInventory():getStats():updateCharacterAttributes()

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