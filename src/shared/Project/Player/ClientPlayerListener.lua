local class = {}
-- IMPORTS
local PromptClickInterface = require(game.ReplicatedStorage.Project.Interfaces.Prompt.PromptClickInterface)
local PromptContentInterface = require(game.ReplicatedStorage.Project.Interfaces.Prompt.PromptContentInterface)
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local InterfaceService = Library.getService("InterfaceService")
local ProximityPromptService = game:GetService("ProximityPromptService")
-- EVENTS
local PlayerUpdateEvent = EventService.get("Player.PlayerUpdate")
-- STARTS


PlayerUpdateEvent.OnClientEvent:Connect(function(_type : string, _packet : string)
    -- Declares required fields.
    local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)

    -- Handles types.
    if _type == "settings" then
        ClientPlayer.getSettings().handlePacket(_packet)
    elseif _type == "stats" then
        ClientPlayer.getStats().handlePacket(_packet)
    elseif _type == "currencies" then
        ClientPlayer.getCurrencies().handlePacket(_packet)
    elseif _type == "statistics" then
        ClientPlayer.getStatistics().handlePacket(_packet)
    elseif _type == "rank" then
        ClientPlayer.setRank(_packet)
    elseif _type == "INVENTORY_PRODUCT" then
        ClientPlayer.getInventory().getProduct().update(ClientPlayer, _packet)
    elseif _type == "INVENTORY_PET" then
        ClientPlayer.getInventory().getPet().update(ClientPlayer, _packet)
    end
end)


------------------------
-- PROXIMITY PROMPT (STARTS)
------------------------

function isPedestal(_name : string)
    return _name == "MONEY_BOOSTER"
    or _name == "FORESEEING_GOGGLES"
    or _name == "SPEED_AND_JUMP_BOOSTER"
    or _name == "JUMP_BOOSTER"
    or _name == "SPEED_BOOSTER"

    or _name == "PREMIUM_CHEST"
    or _name == "PREMIUM_EGG"
    or _name == "BASIC_CHEST"
    or _name == "BASIC_EGG"
end

function isContentPedestal(_name : string)
    return _name == "PREMIUM_CHEST"
    or _name == "PREMIUM_EGG"
    or _name == "BASIC_CHEST"
    or _name == "BASIC_EGG"
end

ProximityPromptService.PromptShown:Connect(function(prompt, inputType)
    -- Safety check.
    if not isPedestal(prompt.Name) then return end

    -- Handles click interface.
    local click_interface = PromptClickInterface.create(prompt.Parent, prompt, inputType)
    if not click_interface:isBound() then click_interface:bind(game.Players.LocalPlayer.PlayerGui) end

    -- Handles content interface.
    if isContentPedestal(prompt.Name) then
        local _content = {}
        if prompt.Name == "PREMIUM_EGG" then
            _content = PromptContentInterface.Content.Pets.Premium
        elseif prompt.Name == "BASIC_EGG" then
            _content = PromptContentInterface.Content.Pets.Free
        end

        local content_interface = PromptContentInterface.create(prompt.Parent, prompt, _content)
        if not content_interface:isBound() then content_interface:bind(game.Players.LocalPlayer.PlayerGui) end
    end
end)

ProximityPromptService.PromptHidden:Connect(function(prompt, inputType)
    -- Safety check.
    if not isPedestal(prompt.Name) then return end

    -- Handles click interface.
    local click_interface = PromptClickInterface.create(prompt.Parent, prompt, inputType)
    if click_interface:isBound() then click_interface:unbind() end

    -- Handles content interface.
    if isContentPedestal(prompt.Name) then
        local _content = {}
        if prompt.Name == "PREMIUM_EGG" then
            _content = PromptContentInterface.Content.Pets.Premium
        elseif prompt.Name == "BASIC_EGG" then
            _content = PromptContentInterface.Content.Pets.Free
        end

        local content_interface = PromptContentInterface.create(prompt.Parent, prompt, _content)
        if content_interface:isBound() then content_interface:unbind() end
    end
end)

------------------------
-- PROXIMITY PROMPT (ENDS)
------------------------


-- ENDS
return class