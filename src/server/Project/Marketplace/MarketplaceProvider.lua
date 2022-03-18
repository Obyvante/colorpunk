local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
local PlayerProvider = Library.getService("PlayerProvider")
local ProductProvider = Library.getService("ProductProvider")
local Transaction = Library.getService("Transaction")
local StringService = Library.getService("StringService")
local TableService = Library.getService("TableService")
local MarketplaceService = game:GetService("MarketplaceService")
-- EVENTS
local InterfaceOpenEvent = EventService.get("Interface.InterfaceOpen")
local InterfaceActionEvent = EventService.get("Interface.InterfaceAction")
-- STARTS


------------------------
-- IMPORTS (STARTS)
------------------------

require(script.Parent.MarketplaceListener)

------------------------
-- IMPORTS (ENDS)
------------------------


------------------------
-- VARIABLES (STARTS)
------------------------

class.Messages = {
    BuyError =
[[
There was a problem with our servers,
we will try to deliver this product to
you in the next 3 days. If the product is not
delivered to you within 3 days, <font color="#00ffff">your Robux
will be transferred back.</font>
]],

    CapError =
[[
You've already bought this item,
you cannot have more!
]],
    InventoryError =
[[
Your inventory is full!
]],
    CurrencyError =
[[
You don't have enough money!
]],
    UnknownpProduct =
[[
Product is not exist! Please
try again later in a while.
]],
    UnknownError =
[[
Something went wrong! Please
try again later in a while.
]]
}

class.FailedPurchases = {}
class.InProgressPurchases = {}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- METHODS (STARTS)
------------------------

-- Handles error with interface.
function class.error(_player : Player, _message : string)
    InterfaceOpenEvent:FireClient(_player, "informative", {
        Title = [[ERROR]],
        Message = _message
    })
end

-- Checks if purchase has failed.
function class.isFailed(_user_id : number, _id : number)
    -- Declares required fields.
    _user_id = tonumber(_user_id)
    _id = tonumber(_id)

    -- Object creations.
    class.FailedPurchases[_user_id] = class.FailedPurchases[_user_id] or {}
    return class.FailedPurchases[_user_id][_id]
end

-- Checks if purchase has failed.
function class.isInProgress(_user_id : number, _id : number)
    -- Declares required fields.
    _user_id = tonumber(_user_id)
    _id = tonumber(_id)

    -- Object creations.
    class.InProgressPurchases[_user_id] = class.InProgressPurchases[_user_id] or {}
    return class.InProgressPurchases[_user_id][_id]
end

-- Checks if player can purchase or not.
function class.canPurchase(_user_id : number, _id : number)
    return (class.isFailed(_user_id, _id) or class.isInProgress(_user_id, _id)) == nil
end

-- Handles succeed purchase.
function class.handleSucceedPurchase(_data : table)
    -- Declares required fields.
    _data.PlayerId = tonumber(_data.PlayerId)
    _data.ProductId = tonumber(_data.ProductId)

    -- Object creations.
    class.InProgressPurchases[_data.PlayerId] = class.InProgressPurchases[_data.PlayerId] or {}
    class.FailedPurchases[_data.PlayerId] = class.FailedPurchases[_data.PlayerId] or {}

    class.InProgressPurchases[_data.PlayerId][_data.ProductId] = nil
    class.FailedPurchases[_data.PlayerId][_data.ProductId] = nil
end

-- Handles in progres purchase.
function class.handleInProgressPurchase(_data : table)
    -- Declares required fields.
    _data.PlayerId = tonumber(_data.PlayerId)
    _data.ProductId = tonumber(_data.ProductId)

    -- Object creations.
    class.InProgressPurchases[_data.PlayerId] = class.InProgressPurchases[_data.PlayerId] or {}
    class.FailedPurchases[_data.PlayerId] = class.FailedPurchases[_data.PlayerId] or {}

    class.InProgressPurchases[_data.PlayerId][_data.ProductId] = _data
    class.FailedPurchases[_data.PlayerId][_data.ProductId] = nil
end

-- Handles failed purchase.
function class.handleFailedPurchase(_data : table)
    -- Declares required fields.
    _data.PlayerId = tonumber(_data.PlayerId)
    _data.ProductId = tonumber(_data.ProductId)

    -- Object creations.
    class.InProgressPurchases[_data.PlayerId] = class.InProgressPurchases[_data.PlayerId] or {}
    class.FailedPurchases[_data.PlayerId] = class.FailedPurchases[_data.PlayerId] or {}

    class.FailedPurchases[_data.PlayerId][_data.ProductId] = _data
    class.InProgressPurchases[_data.PlayerId][_data.ProductId] = nil
end

-- Handles purchase.
function class.handlePurchase(_player : Player, _id : string)
    -- Object nil checks.
    assert(_player ~= nil and _id ~= nil)

    -- Gets and check player.
    local player = PlayerProvider.find(_player.UserId)
    if player == nil then return end

    -- If server is not active, no need to continue.
    if not _G.server_active then
        class.error(_player, class.Messages.UnknownError)
        return
    end

    -- Handles product types.
    if _id == "Basic Egg" then
        -- Checks player inventory size.
        local _inventory_size = TableService.size(player:getInventory():getPet():getContent())
        if _inventory_size >= 27 then
            class.error(_player, class.Messages.InventoryError)
            return
        end

        -- Handles palyer currency.
        if player:getCurrencies():get("GOLD") < 300 then
            class.error(_player, class.Messages.CurrencyError)
            return
        end

        -- Removes currency from player.
        player:getCurrencies():remove("GOLD", 300)
        Library.getService("CosmeticProvider").openCase(_player, "Basic Egg")
        return
    end

    -- Declares required fields. (1)
    local _product = ProductProvider.findByName(_id)

    -- If product is not exist, no need to continue.
    if not _product then
        class.error(_player, class.Messages.UnknownpProduct)
        return
    end

    -- Checks if player can purchase it or not.
    if class.isInProgress(_player.UserId, _product:getId()) then
        class.error(_player, class.Messages.UnknownError)
        return
    end

    -- Checks if player can purchase it or not.
    if class.isFailed(_player.UserId, _product:getId()) then
        class.error(_player, class.Messages.BuyError)
        return
    end

    -- If product is an item, handles it.
    if _product:isItem() then
        -- Declares required fields. (2)
        local _player_product = player:getInventory():getProduct():find(_product:getId())
        -- If player doesn't have any inventory space, no need to continue.
        if _player_product ~= nil and _player_product:getAmount() >= _product:getCap() then
            class.error(_player, class.Messages.CapError)
            return
        end

        -- Handles speed and jump booster.
        if _product:getType() == "BOOSTER_BUNDLE" then -- SPEED AND JUMP BOOSTER INVENTORY CHECK.
            -- Declares required fields.
            local _products = player:getInventory():getProduct()
            if _products:has(1248410518) and _products:has(1248410451) then
                class.error(_player, class.Messages.CapError)
                return
            end
        end
    elseif _product:getType() == "PET" then
        -- Checks player inventory size.
        local _inventory_size = TableService.size(player:getInventory():getPet():getContent())
        if _inventory_size >= 27 then
            class.error(_player, class.Messages.InventoryError)
            return
        end
    elseif _product:getType() == "CASE" then
        if StringService.endsWith(_product:getName(), "Egg") then
            -- Checks player inventory size.
            local _inventory_size = TableService.size(player:getInventory():getPet():getContent())
            if _inventory_size >= 27 then
                class.error(_player, class.Messages.InventoryError)
                return
            end
        end
    end

    -- Starts purchasing.
    MarketplaceService:PromptProductPurchase(_player, _product:getId())
    return true
end

------------------------
-- METHODS (ENDS)
------------------------


------------------------
-- BUNDLES (STARTS)
------------------------

function class.failedReceipt(_data : table, _reason : string, _message : string)
    -- Handles failed purchase.
    class.handleFailedPurchase(_data)

    -- Informs server about the failed purchase.
    warn(" ")
    warn("Couldn't handle purchase! " .. _reason)
    warn(_data)
    warn(" ")
    if _message ~= nil then
        warn("Process error -> " .. _message)
        warn("")
    end

    -- Tells server the purchase is not granted yet.
    return Enum.ProductPurchaseDecision.NotProcessedYet
end

------------------------
-- BUNDLES (ENDS)
------------------------


------------------------
-- EVENTS (STARTS)
------------------------

-- Handles purchase.
InterfaceActionEvent.OnServerEvent:Connect(function(_player : Player, _id : string, _information : table)
    -- Safety checks.
    if _id == nil
    or _information == nil
    or _information.Id == nil
    or not StringService.startsWith(_information.Id, "PRODUCT_")
    then return end

    -- If the answer is nil or false, no need to continue.
    if not _information.Action then return end

    -- Handles purchase.
    local success, message = pcall(function() class.handlePurchase(_player, _information.Id:split("PRODUCT_")[2]) end)

    -- Handles exceptions.
    if not success then
        class.error(_player, class.Messages.UnknownError)
        warn("player(" .. _player ..") tried to purchase item(" .. _id .. ")")
        warn(message)
    end
end)

-- Market purchase process recepit handler.
function MarketplaceService.ProcessReceipt(_data)
    -- Handles in-progress purchase.
    class.handleInProgressPurchase(_data)

    -- Gets player by its id.
    local _player = game.Players:GetPlayerByUserId(_data.PlayerId)
    -- If player is not online, no need to continue.
    if _player == nil then return class.failedReceipt(_data, "OFFLINE PLAYER") end

    -- Declares required fields.
    local _product = ProductProvider.find(_data.ProductId)

    -- If product is not exist, no need to continue.
    if not _product then
        class.error(_player, class.Messages.BuyError)
        return class.failedReceipt(_data, "PRODUCT NOT FOUND!")
    end

    -- Tries to get custom player.
    local player
    local timer = 0
    while timer < 8 do
        player = PlayerProvider.find(_data.PlayerId)
        if player ~= nil then break end

        timer += 0.1
        task.wait(0.1)
    end

    -- If player is not online, no need to continue.
    if player == nil then return class.failedReceipt(_data, "PLAYER NOT FOUND") end

    ------------------------
    -- TRANSACTION (STARTS)
    ------------------------

    local transaction
    local success, message = pcall(function()
        transaction = Transaction.new(_data.ProductId, _data.PlayerId, _data.CurrencySpent)
    end)

    if not success then
        class.error(_player, class.Messages.BuyError)
        return class.failedReceipt(_data, "TRANSACTION CREATION", message)
    end

    ------------------------
    -- TRANSACTION (ENDS)
    ------------------------


    -- Handles procuts.
    success, message = pcall(function()
        if _product:isItem() then
            -- Adds product to the player's inventoryç
            player:getInventory():getProduct():add(tonumber(_data.ProductId), 1)

            -- Handles attribute changes.
            if _product:getType() == "BOOSTER" or _product:getType() == "BOOSTER_BUNDLE" then
                player:getStats():updateCharacterAttributes()
            end
        else
            -- Handles pets.
            if _product:getType() == "PET" then
                -- Adds pet to the players pet inventory.
                player:getInventory():getPet():add(tonumber(_product:getMetadataValue("petId")))
            elseif _product:getType() == "CASE" then
                Library.getService("CosmeticProvider").openCase(_player, _product:getName())
            end
        end
    end)

    -- Handles unsuccessful product adding.
    if not success then
        class.error(_player, class.Messages.BuyError)
        return class.failedReceipt(_data, "PRODUCT ADDING", message)
    end


    ------------------------
    -- TRANSFER/PURCHASE HISTORY (STARTS)
    ------------------------

    success, message = pcall(function() transaction:send() end)
    -- We are going to grant this purchase since we cannot stop/remove it.
    if not success then class.failedReceipt(_data, "PURCHASE HISTORY SAVING", message) end

    ------------------------
    -- TRANSFER/PURCHASE HISTORY (ENDS)
    ------------------------

    class.handleSucceedPurchase(_data)
    return Enum.ProductPurchaseDecision.PurchaseGranted
end

------------------------
-- EVENTS (ENDS)
------------------------


-- ENDS
return class