-- Start
local class = {}


-- Max image size.
local max_image_size = 1024

-- Plays declared spritesheet.
-- @param image Image label.
-- @param width Image width.
-- @param height Image height.
-- @param rows Spritesheet rows.
-- @param columns Spritesheet columns.
-- @param frames Spritesheet frames. (TOTAL PLAYABLE OBJECT)
-- @param assetId Roblox asset id.
-- @param FPS Expected Frame Per Second.
function class.play(image: ImageLabel, width : number, height : number, rows : number, columns : number, frames : number, assetId : number, FPS : number)
	-- Declares target image.
	if assetId then image.Image = "http://www.roblox.com/asset/?id=" .. assetId end
	
	-- Creates real width and height fields.
	local real_width, real_height
	
	-- Compensate roblox size
	if math.max(width, height) > max_image_size then
		-- Gets longest part of the image size.
		local longest = width > height and "Width" or "Height"
		
		-- Handles the longest part.
		if longest == "Width" then
			-- Calculates image part sizes.
			real_width = max_image_size
			real_height = (real_width / width) * height
		elseif longest == "Height" then
			-- Calculates image part sizes.
			real_height = max_image_size
			real_width = (real_height / height) * width
		end
	else
		-- If there is no problem with Roblox maximum size, set it as a default.
		real_width, real_height = width, height
	end
	
	-- Calculates frame size.
	local frame_size = Vector2.new(real_width / columns, real_height / rows)
	-- Sets image rect size field as calcualted frame size.
	image.ImageRectSize = frame_size
	
	-- Declares required fields.
	local current_row, current_column = 0,0
	local offsets = {}
	
	-- Loops through frames. (CALCULATORS)
	for frame_index = 1, frames do
		-- Calcualtes column and rows size.
		local current_x = current_column * frame_size.X
		local current_y = current_row * frame_size.Y
		
		-- Insets table with new currents.
		table.insert(offsets, Vector2.new(current_x, current_y))
		
		-- Increases current column.
		current_column += 1
		
		-- If current column is higher than columns, we can skip for the next column.
		if current_column >= columns then
			current_column = 0
			current_row += 1
		end

	end
	
	-- Declares time interval.
	local interval = FPS and 1/FPS or 0.1
	local index = 0
	
	-- Creates new task.
	task.spawn(function()
		-- Loops through all descendant childs in image.
		while task.wait(interval) and image:IsDescendantOf(game) do
			-- Increases index.
			index += 1
			
			-- Sets image rect offset field with target offset index.
			image.ImageRectOffset = offsets[index]
			
			-- If index is higher than frames, resets it.
			if index >= frames then
				index = 0
			end
		end
	end)
end


-- End
return class