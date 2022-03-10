local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local MarketplaceService = game:GetService("MarketplaceService")
-- EVENTS
local TestCallbackEvent = EventService.get("TestCallback")
-- STARTS


TestCallbackEvent.OnServerEvent:Connect(function(_player)
    MarketplaceService:PromptProductPurchase(_player, 1246742045)
end)


function MarketplaceService.ProcessReceipt(_data)
    print(_data)
    return Enum.ProductPurchaseDecision.NotProcessedYet
end


-- ENDS
return class