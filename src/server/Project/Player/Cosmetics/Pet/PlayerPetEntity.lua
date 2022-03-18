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
    self.started = false

    -- Clones and spawn pet entity.
    self.entity = AssetLocation.Models.Pets[_pet:getPet():getId()]:Clone()
    self.entity.CanCollide = false
    self.entity.CanTouch = false
    self.entity.Anchored = false
    self:startLoop()

    -- Returns created pet entity.
    return self
end

-- Starts entity follow loop.
function class:startLoop()
    -- Gets roblox player.
    local player = self.pet:getPlayer():getRobloxPlayer()

    -- Gets roblox player character.
    local character = player.Character
    local character_primary = character.PrimaryPart

    -- Creates character attachments.
    class.character_rotation_attachment = Instance.new("Attachment", character_primary)
    class.character_position_attachment = Instance.new("Attachment", character_primary)
    class.character_rotation_attachment.Rotation = Vector3.new(0, -90, 0)
    class.character_position_attachment.Position = Vector3.new(0, 3, 14)
    class.character_rotation_attachment.Parent = character_primary
    class.character_position_attachment.Parent = character_primary

    -- Creates pet attachments.
    class.pet_rotation_attachment = Instance.new("Attachment")
    class.pet_position_attachment = Instance.new("Attachment")
    class.pet_rotation_attachment.Parent = self.entity
    class.pet_position_attachment.Parent = self.entity

    -- Creates align position.
    local aligin_position = Instance.new("AlignPosition")
    aligin_position.Attachment0 = class.pet_position_attachment
    aligin_position.Attachment1 = class.character_position_attachment
    aligin_position.Parent = self.entity

    -- Creates align rotation.
    local aligin_rotation = Instance.new("AlignOrientation")
    aligin_rotation.RigidityEnabled = false
    aligin_rotation.Attachment0 = class.pet_rotation_attachment
    aligin_rotation.Attachment1 = class.character_rotation_attachment
    aligin_rotation.Parent = self.entity

    -- Sets pet properties.
    self.entity.Position = character.HumanoidRootPart.Position
    self.entity.Parent = game.Workspace

    -- Sets entity network owner to achieve smooth movements.
    self.entity:SetNetworkOwner(player)
end

-- Updates entity positions.
function class:updatePosition(_order : number, _size : number)
    local vector
    if _order == 1 then
        vector = Vector3.new(0, 2, 8)
    elseif _order == 2 then
        vector = Vector3.new(-5, 2, 12)
    elseif _order == 3 then
        vector = Vector3.new(5, 2, 12)
    elseif _order == 4 then
        vector = Vector3.new(0, 2, 16)
    end

    class.character_position_attachment.Position = vector
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