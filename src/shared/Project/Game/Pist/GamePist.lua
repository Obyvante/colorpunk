local class = {}
-- IMPORTS
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
-- STARTS


-- Resets blocks.
function class.reset()
	local _blocks = game.Workspace.World.Arena.Pist

	-- Loops through "x" and "y" axises.
	for x = 1, 48, 1 do
		-- Declares required fields.
		local x_section = _blocks[x < 10 and "0" .. x or x]

		-- Handles "y" axis.
		for y = 1, 48, 1 do
			-- Declares required fields.
			local target_block = x_section[y < 10 and "0" .. y or y]

			-- Saves block into block index.
			target_block.Transparency = 1
			target_block.CanCollide = false
		end
	end
end

-- Resets blocks with color.
function class.restWithColor()
	local _blocks = game.Workspace.World.Arena.Pist

	-- Loops through "x" and "y" axises.
	for x = 1, 48, 1 do
		-- Declares required fields.
		local x_section = _blocks[x < 10 and "0" .. x or x]

		-- Handles "y" axis.
		for y = 1, 48, 1 do
			-- Declares required fields.
			local target_block = x_section[y < 10 and "0" .. y or y]

			-- Saves block into block index.
			target_block.Color = Color3.fromRGB(17, 17, 17)
			target_block.Transparency = 0
			target_block.CanCollide = true
		end
	end
end

-- Applies whitelist.
function class.whitelist(id, target_color)
	local _blocks = game.Workspace.World.Arena.Pist

	-- Gets current pist.
	local pist = require(game.ReplicatedStorage.Pists[id])
	local parts = pist.texture.parts

	-- Loops through "x" and "y" axises.
	for x = 1, 48, 1 do
		-- Declares required fields.
		local x_section = _blocks[x < 10 and "0" .. x or x]
		local x_texture = parts[tostring(x)]

		-- Handles "y" axis.
		for y = 1, 48, 1 do
			-- Declares required fields.
			local target_block = x_section[y < 10 and "0" .. y or y]
			local texture_color = x_texture[tostring(y)].color
			local brick_color = BrickColor.new(Color3.fromRGB(texture_color.r, texture_color.g, texture_color.b)).Name

			-- If block color is in whitelist, no need to continue.
			if (target_color == brick_color) then continue end

			-- Sets target block color.
			target_block.Transparency = 1
			target_block.CanCollide = false
		end
	end
end

-- Builds pist.
function class.load(pist_id, target_color)
	local _blocks = game.Workspace.World.Arena.Pist

	-- Gets current pist.
	local pist = require(game.ReplicatedStorage.Pists[pist_id])
	local parts = pist.texture.parts

    -- Declares required fields.
    local _products = ClientPlayer.getInventory().getProduct()
    local _goggles = _products.has(1248410359)

	-- Loops through "x" and "y" axises.
	for x = 1, 48, 1 do
		-- Declares required fields.
		local x_section = _blocks[x < 10 and "0" .. x or x]
		local x_texture = parts[tostring(x)]

		-- Handles "y" axis.
		for y = 1, 48, 1 do
			-- Declares required fields.
			local target_block = x_section[y < 10 and "0" .. y or y]
			local texture_color = x_texture[tostring(y)].color

			-- Sets target block color.
			target_block.Transparency = 0
			target_block.CanCollide = true
			target_block.Color = Color3.fromRGB(texture_color.r, texture_color.g, texture_color.b)

			-- Handles goggles.
			if _goggles then
				-- Declares required fields.
				local brick_color = BrickColor.new(Color3.fromRGB(texture_color.r, texture_color.g, texture_color.b)).Name
				-- If block color is in whitelist, no need to continue.
				if (target_color == brick_color) then continue end

				-- Sets transparency.
				target_block.Transparency = 0.7
			end
		end
	end
end


-- ENDS
return class