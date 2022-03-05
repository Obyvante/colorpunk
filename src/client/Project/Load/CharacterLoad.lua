local class = {}
-- IMPORTS
local player = game:GetService("Players").LocalPlayer
-- STARTS


-- Loading player's character and humanoid parts.
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid", 999)
local humanoid_root = character:WaitForChild("HumanoidRootPart", 999)

-- Configures client's default characters.
humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)


-- ENDS
return class