local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local AssetLocation = Library.getService("AssetLocation")
-- STARTS


-- Creates a player pet entity.
function class.new(_pet)
    -- Object nil checks.
    assert(_pet ~= nil)

    -- Creates pet entity.
    local self = setmetatable({ pet = _pet }, class)

    -- Clones and spawn pet entity.
    self.entity = AssetLocation.Models.Pets[_pet:getPet():getId()]:Clone()
    self.entity.CanCollide = false
    self.entity.CanTouch = false
    self:startLoop()

    -- Returns created pet entity.
    return self
end

-- Starts entity follow loop.
function class:startLoop()
    -- Handles process in background.
    task.spawn(function()
        -- Infinite loop to wait player to be loaded.
        while true do
            -- If player is not active or loaded, escapes from the loop.
            if self.pet:getPlayer() == nil or self.pet:getPlayer():isLoaded() then break end
            task.wait(1)
        end

        -- If player is not active, no need to continue.
        if self == nil or self.pet:getPlayer() == nil then return end

        -- Gets roblox player.
        local player = self.pet:getPlayer():getRobloxPlayer()
        if player == nil then return end

        -- Gets roblox player character.
        local character = player.Character
        if player.Character == nil then return end
        local character_primary = character.PrimaryPart

        -- Creates character attachments.
		local character_rotation_attachment = Instance.new("Attachment", character_primary)
		local character_position_attachment = Instance.new("Attachment", character_primary)
        character_rotation_attachment.Rotation = Vector3.new(0, -90, 0)
		character_position_attachment.Position = Vector3.new(0, 3, 14)
        character_rotation_attachment.Parent = character_primary
        character_position_attachment.Parent = character_primary
		
        -- Creates pet attachments.
		local pet_rotation_attachment = Instance.new("Attachment")
		local pet_position_attachment = Instance.new("Attachment")
        pet_rotation_attachment.Parent = self.entity
        pet_position_attachment.Parent = self.entity

        -- Creates align position.
        local aligin_position = Instance.new("AlignPosition")
		aligin_position.Attachment0 = pet_position_attachment
		aligin_position.Attachment1 = character_position_attachment
		aligin_position.Parent = self.entity

        -- Creates align rotation.
        local aligin_rotation = Instance.new("AlignOrientation")
        aligin_rotation.RigidityEnabled = false
		aligin_rotation.Attachment0 = pet_rotation_attachment
		aligin_rotation.Attachment1 = character_rotation_attachment
		aligin_rotation.Parent = self.entity

        -- Sets pet properties.
        self.entity.Position = character.HumanoidRootPart.Position
        self.entity.Anchored = false
        self.entity.Parent = game.Workspace

        -- Sets entity network owner to achieve smooth movements.
        self.entity:SetNetworkOwner(player)
    end)
end

-- Destroys entity.
function class:Destroy()
    -- Destroys entity.
    self.entity:Destroy()

    -- Throws this class to the garbage collector.
    setmetatable(self, nil)
end


-- ENDS
return class