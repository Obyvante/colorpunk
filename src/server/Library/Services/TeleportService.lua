local class = {}
-- STARTS


-- Teleports player to target location.
--
-- NOTE: Player character and its humanoid must be
-- loaded beforehand! Otherwise, you'll probably
-- encounter a lot of console errors 😔 
--
-- @param _player Player.
-- @param _location Target tocation.
-- @param _orientation Orientation. (OPTIONAL)
function class.teleport(_player : Player, _location : Vector3, _orientation : Vector3)
    -- Declares required fields.
	local character = _player.Character
	local humanoid = _player.Character.Humanoid
    local walk_speed = humanoid.WalkSpeed
    local jump_power = humanoid.JumpPower

    -- Freezes player.
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0

	-- Calculate height of root part from character base
	local rootPartY
	if humanoid.RigType == Enum.HumanoidRigType.R15 then
		rootPartY = (humanoid.RootPart.Size.Y * 0.5) + humanoid.HipHeight
	else
		rootPartY = (humanoid.RootPart.Size.Y * 0.5) + humanoid.Parent.LeftLeg.Size.Y + humanoid.HipHeight
	end

	-- Calculates locations.
	local position = CFrame.new(_location + Vector3.new(0, rootPartY, 0))
	local orientation = _orientation and CFrame.Angles(_orientation.X, _orientation.Y, _orientation.Z) or CFrame.Angles(0, 90, 0)

	-- Teleports player to target location.
	character:SetPrimaryPartCFrame(position * orientation)

	-- Unfreezes character
    humanoid.WalkSpeed = walk_speed
    humanoid.JumpPower = jump_power
end


-- ENDS
return class