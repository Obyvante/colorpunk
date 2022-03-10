-- IMPORTS
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local TaskService = Library.getService("TaskService")
local Metadata = Library.getTemplate("Metadata")
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild('Humanoid')
local LeftFoot = Character:WaitForChild("LeftFoot")
local RightFoot = Character:WaitForChild("RightFoot")

local _current = "RIGHT"
local _metadata = Metadata.new()

function create1(_position)
    _current = _current == "LEFT" and "RIGHT" or "LEFT"

    local _parent = Instance.new("Part")
    _parent.Anchored = true
    _parent.Size = Vector3.new(0, 0, 0)
    _parent.Transparency = 1
    _parent.CanCollide = false
    _parent.Position = _position + Vector3.new(0, 0.5, 0)
    _parent.Position = _parent.Position
    _parent.Parent = game.Workspace

    local _particle = Instance.new("ParticleEmitter")
    _particle.Texture = "rbxasset://textures/particles/stable1.png"
    _particle.Size = NumberSequence.new(math.random() + 0.4)
    _particle.Color = ColorSequence.new(Color3.fromRGB(0, 217, 255))
    _particle.LightEmission = 1
    _particle.LightInfluence = 1
    _particle.EmissionDirection = Enum.NormalId.Top
    _particle.Rate = 0
    _particle.Speed = NumberRange.new(0)
    _particle.Parent = _parent
	_particle:Emit(10)

    TaskService.createDelayed(1, function(_task)
        _particle:Clear()
        _parent:Destroy()
    end):run()
end

function create2(_position)
    _current = _current == "LEFT" and "RIGHT" or "LEFT"

    local _parent = Instance.new("Part")
    _parent.Anchored = true
    _parent.Size = Vector3.new(0, 0, 0)
    _parent.Transparency = 1
    _parent.CanCollide = false
    _parent.Position = _position + Vector3.new(0, 0.5, 0)
    _parent.Position = _parent.Position
    _parent.Parent = game.Workspace

    local _particle = Instance.new("ParticleEmitter")
    _particle.Texture = "rbxassetid://9055534720"
    _particle.Size = NumberSequence.new(math.random() + 0.3)
    _particle.Color = ColorSequence.new(Color3.fromRGB(0, 217, 255))
    _particle.LightEmission = 1
    _particle.LightInfluence = 1
    _particle.EmissionDirection = Enum.NormalId.Top
    _particle.Rate = 0
    _particle.Speed = NumberRange.new(0)
    _particle.Parent = _parent
	_particle:Emit(10)

    TaskService.createDelayed(2, function(_task)
        _particle:Clear()
        _parent:Destroy()
    end):run()
end

LeftFoot.Touched:Connect(function()
    if _metadata:has("left:cooldown") then return end
    _metadata:addExpirable("left:cooldown", 0.2)
    create2(LeftFoot.Position)
end)
RightFoot.Touched:Connect(function()
    if _metadata:has("right:cooldown") then return end
    _metadata:addExpirable("right:cooldown", 0.2)
    create2(RightFoot.Position)
end)