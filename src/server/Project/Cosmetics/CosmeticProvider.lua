local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local PlayerProvider = Library.getService("PlayerProvider")
local CaseProvider = Library.getService("CaseProvider")
local CoolDownService = Library.getService("CoolDownService")
-- EVENTS
local CosmeticCaseOpenEvent = EventService.get("Cosmetics.CosmeticCaseOpen")
local ProximityPromptService = game:GetService("ProximityPromptService")
local InterfaceOpenEvent = EventService.get("Interface.InterfaceOpen")
-- STARTS


------------------------
-- EVENTS (STARTS)
------------------------

ProximityPromptService.PromptTriggered:Connect(function(prompt, _player)
    if prompt.Name == "PREMIUM_EGG" or prompt.Name == "BASIC_EGG" then
        -- Handles cool down.
        if not CoolDownService.handle(_player.UserId .. ":case", 8) then return end

        -- Handles exceptions.
        local success, message = pcall(function()
            -- Declares required fields.
            local player = PlayerProvider.find(_player.UserId)
            if player == nil then return end

            -- Declares required fields.
            local _result

            -- Handles egg types.
            if prompt.Name == "PREMIUM_EGG" then
                _result = CaseProvider.random("PREMIUM_PET")
            elseif prompt.Name == "BASIC_EGG" then
                _result = CaseProvider.random("FREE_PET")
            end

            -- Gives item to the player.
            player:getInventory():getPet():add(_result:getId())

            -- Sends pet open request.
            CosmeticCaseOpenEvent:FireClient(_player, {
                Product = "PET",
                Type = prompt.Name == "PREMIUM_EGG" and "PREMIUM" or "BASIC",
                Name = _result:getName(),
                Id = _result:getId()
            })
        end)

        -- Handles exceptions.
        if not success then
            warn("Player(" .. _player.UserId .. ") tried to open case(" .. prompt.Name .. ")")
            warn(message)
        end
    end
end)

------------------------
-- EVENTS (ENDS)
------------------------


-- ENDS
return class