local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local PetProvider = Library.getService("PetProvider")
local TableService = Library.getService("TableService")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.content = {
    Pet = {
        Premium = {
            ["1"] = 20,
            ["2"] = 20,
            ["3"] = 20,
            ["4"] = 20,
            ["5"] = 20
        },
        Free = {
            ["6"] = 20,
            ["7"] = 20,
            ["8"] = 20,
            ["9"] = 20,
            ["10"] = 20
        }
    }
}

class.price = {
    Pet = {
        Premium = 100, -- ROBUX
        Free = 100 -- GOLD
    }
}

------------------------
-- VARIABLES (ENDS)
------------------------

-- Gets random item from the target type case.
-- @param _type Case type. ["PREMIUM_PET", "FREE_PET"]
function class.random(_type : string)
    if _type == "PREMIUM_PET" then
        -- Handles chacens.
        for item, chance in pairs(class.content.Pet.Premium) do
            if chance >= math.random() * 100 then return PetProvider.get(tonumber(item)) end
        end

        -- Declares required fields.
        local _keys = TableService.keys(class.content.Pet.Premium)
        local _id = tonumber(_keys[math.random(1, #_keys)])

        return PetProvider.get(_id)
    elseif _type == "FREE_PET" then
        -- Handles chacens.
        for item, chance in pairs(class.content.Pet.Free) do
            if chance >= math.random() * 100 then return PetProvider.get(tonumber(item)) end
        end

        -- Declares required fields.
        local _keys = TableService.keys(class.content.Pet.Free)
        local _id = tonumber(_keys[math.random(1, #_keys)])

        return PetProvider.get(_id)
    end
end


-- ENDS
return class