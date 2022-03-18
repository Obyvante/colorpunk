local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local PlayerProvider = Library.getService("PlayerProvider")
local CaseProvider = Library.getService("CaseProvider")
local ProductProvider = Library.getService("ProductProvider")
local MarketplaceProvider = Library.getService("MarketplaceProvider")
local CoolDownService = Library.getService("CoolDownService")
-- EVENTS
local CosmeticCaseOpenEvent = EventService.get("Cosmetics.CosmeticCaseOpen")
local ProximityPromptService = game:GetService("ProximityPromptService")
local InventoryUpdateEvent = EventService.get("Inventory.InventoryUpdate")
-- STARTS


------------------------
-- METHODS (STARTS)
------------------------

-- Handles pet case.
-- @param _player Player.
-- @param _id Pet case id.
function class.openCase(_player : Player, _id : string)
    -- Gets and check player.
    local player = PlayerProvider.find(_player.UserId)
    if player == nil then return end

    CoolDownService.handle(_player.UserId .. ":case", 8)

    -- Declares required fields.
    local _result
    -- Handles egg types.
    if _id == "Premium Egg" then
        _result = CaseProvider.random("PREMIUM_PET")
    elseif _id == "Basic Egg" then
        _result = CaseProvider.random("FREE_PET")
    end

    -- Gives item to the player.
    player:getInventory():getPet():add(_result:getId())

    -- Sends inventory update event to handle not updated player pets.
    InventoryUpdateEvent:FireClient(_player)

    -- Sends pet open request.
    CosmeticCaseOpenEvent:FireClient(_player, {
        Product = "PET",
        Type = _id == "Premium Egg" and "PREMIUM" or "BASIC",
        Name = _result:getName(),
        Id = _result:getId()
    })
end

------------------------
-- METHODS (ENDS)
------------------------


------------------------
-- EVENTS (STARTS)
------------------------

ProximityPromptService.PromptTriggered:Connect(function(prompt, _player)
    -- Prompt attribute check.
    if not prompt:GetAttribute("hasClick") or not prompt:GetAttribute("skipInterface") then return end

    -- Gets prodct by prompt name.
    local _product = ProductProvider.findByName(prompt.Name)
    if not _product then return end

    -- Handles cool down.
    if CoolDownService.has(_player.UserId .. ":case") then return end

    -- Handles purchase.
    MarketplaceProvider.handlePurchase(_player, prompt.Name)
end)

------------------------
-- EVENTS (ENDS)
------------------------


-- ENDS
return class