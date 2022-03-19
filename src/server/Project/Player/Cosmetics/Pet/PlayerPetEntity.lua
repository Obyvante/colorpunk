local class = {}
class.__index = class
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local AssetLocation = Library.getService("AssetLocation")
local TaskService = Library.getService("TaskService")
-- STARTS


-- Creates a player pet entity.
function class.new(_pet, _offset : Vector3)
    -- Object nil checks.
    assert(_pet ~= nil)
    assert(_offset ~= nil)

    -- Creates pet entity.
    local self = setmetatable({
        pet = _pet,
        offset = _offset
    }, class)

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
    if not player then return end

    -- Gets roblox player character.
    local character = player.Character
    if not character then return end
    local character_primary = character.PrimaryPart

    -- Creates character attachments.
    self.character_rotation_attachment = Instance.new("Attachment", character_primary)
    self.character_position_attachment = Instance.new("Attachment", character_primary)
    self.character_rotation_attachment.Rotation = Vector3.new(0, -90, 0)
    self.character_position_attachment.Position = self.offset
    self.character_rotation_attachment.Parent = character_primary
    self.character_position_attachment.Parent = character_primary

    -- Creates pet attachments.
    self.pet_rotation_attachment = Instance.new("Attachment")
    self.pet_position_attachment = Instance.new("Attachment")
    self.pet_rotation_attachment.Parent = self.entity
    self.pet_position_attachment.Parent = self.entity

    -- Creates align position.
    local aligin_position = Instance.new("AlignPosition")
    aligin_position.Attachment0 = self.pet_position_attachment
    aligin_position.Attachment1 = self.character_position_attachment
    aligin_position.Parent = self.entity

    -- Creates align rotation.
    local aligin_rotation = Instance.new("AlignOrientation")
    aligin_rotation.RigidityEnabled = false
    aligin_rotation.Attachment0 = self.pet_rotation_attachment
    aligin_rotation.Attachment1 = self.character_rotation_attachment
    aligin_rotation.Parent = self.entity

    -- Sets pet properties.
    self.entity.Position = character.HumanoidRootPart.Position
    self.entity.Parent = game.Workspace

    -- Sets entity network owner to achieve smooth movements.
    self.entity:SetNetworkOwner(player)

    self:playFloatingAnimation()
end

-- Plays floating animation.
function class:playFloatingAnimation()
    -- Checks repeating task.
    if self.Task then
        self.Task:cancel()
        self.Task = nil
    end

    self.floatingY = 0
    self.opposite = true
    self.Task = TaskService.createRepeating(0.1, function(_task)
        -- Checks if entity is exists or not.
        if not self or not self.pet or not self.pet:getPlayer() then
            _task:cancel()
            return
        end
        
        -- Sets floating y-axis.
        self.floatingY = self.opposite and self.floatingY - 0.1 or self.floatingY + 0.1
        if self.floatingY >= 0 then
            self.opposite = true
        elseif self.floatingY <= -3 then
            self.opposite = false
        end

        -- Updates pet position.
        self.character_position_attachment.Position = Vector3.new(self.offset.X, self.offset.Y + self.floatingY, self.offset.Z)
    end):run()
end

-- Updates entity positions.
-- @param _offset Offset vector.
function class:updatePosition(_offset : Vector3)
    self.offset = _offset
    self.character_position_attachment.Position = self.offset

    -- Plays floating animation again.
    self:playFloatingAnimation()
end

-- Destroys entity.
function class:Destroy()
    -- Checks repeating task.
    if self.Task then
        self.Task:cancel()
        self.Task = nil
    end

    -- Destroys entity.
    self.entity:Destroy()

    -- Throws this class to the garbage collector.
    setmetatable(self, nil)
end


-- ENDS
return class