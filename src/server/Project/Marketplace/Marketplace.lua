local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local PlayerProvider = Library.getService("PlayerProvider")
local Transaction = Library.getService("Transaction")
local MarketplaceService = game:GetService("MarketplaceService")
-- EVENTS
local TestCallbackEvent = EventService.get("TestCallback")
-- STARTS


-- TODO: start coding and finish it.

TestCallbackEvent.OnServerEvent:Connect(function(_player)
    MarketplaceService:PromptProductPurchase(_player, 1246742045)
end)


-- TODO: MORE TRUSTABLE SYSTEM!
function MarketplaceService.ProcessReceipt(_data)
    local transaction = Transaction.new(_data.ProductId, _data.PlayerId, _data.CurrencySpent)

    local player = PlayerProvider.find(_data.PlayerId)
    if player == nil then
        warn("failed to pruchase. (PLAYER NOT FOUND)")
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    if _data.ProductId == 1246742045 then
        -- Testing!
        player:getInventory():getProduct():remove(1246742045)
        local success, message = pcall(function()
            player:getInventory():getProduct():add(1246742045, 1)
            transaction:send()
        end)

        if not success then
            warn("failed to pruchase. (PLAYER PRODUCT INVENTORY) -> " .. message)
            return Enum.ProductPurchaseDecision.NotProcessedYet
        end
    end

    return Enum.ProductPurchaseDecision.PurchaseGranted
end


-- ENDS
return class