local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local PlayerProvider = Library.getService("PlayerProvider")
local Transaction = Library.getService("Transaction")
local MarketplaceService = game:GetService("MarketplaceService")
-- EVENTS
local TestCallbackEvent = EventService.get("TestCallback")
local InterfaceOpenEvent = EventService.get("Interface.InterfaceOpen")
local InterfaceActionEvent = EventService.get("Interface.InterfaceAction")
-- STARTS


-- TODO: start coding and finish it.

TestCallbackEvent.OnServerEvent:Connect(function(_player)
    InterfaceOpenEvent:FireClient(_player, "agreement", {
        ActionId = "PURCHASE_BOOSTER",
        Title = [[<b>Purchase Notification</b>]],
        Message =
[[
You already have <font color="#ff0000">Jump Booster</font>!

You will only get <font color="#00ffff">Money Booster</font>
Do you want to buy?
]]
    })
end)

InterfaceActionEvent.OnServerEvent:Connect(function(_player : Player, _id : string, _information : table)
    if _id == nil or _information == nil or _information.Id ~= "PURCHASE_BOOSTER" then return end
    
    if _information.Action then
        MarketplaceService:PromptProductPurchase(_player, 1246742045)
    end
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