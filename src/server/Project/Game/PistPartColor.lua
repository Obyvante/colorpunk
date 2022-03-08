local class = {}
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.content = {
	WHITE = {
		name = "White",
		brick_color = "Institutional white",
		color = Color3.fromRGB(248, 248, 248)
	},
	BLACK = {
		name = "Black",
		brick_color = "Really black",
		color = Color3.fromRGB(17, 17, 17)

	},
	ORANGE = {
		name = "Orange",
		brick_color = "Flame reddish orange",
		color = Color3.fromRGB(234, 92, 0)
	},
	MAGENTA = {
		name = "Magenta",
		brick_color = "Magenta",
		color = Color3.fromRGB(156, 0, 167)
	},
	DARK_BLUE = {
		name = "Dark Blue",
		brick_color = "Dark blue",
		color = Color3.fromRGB(0, 16, 176)
	},
	LIGHT_BLUE = {
		name = "Light Blue",
		brick_color = "Deep blue",
		color = Color3.fromRGB(33, 84, 185)
	},
	YELLOW = {
		name = "Yellow",
		brick_color = "Bright yellow",
		color = Color3.fromRGB(245, 205, 48)
	},
	LIME = {
		name = "Lime Green",
		brick_color = "Lime green",
		color = Color3.fromRGB(0, 255, 0 )
	},
	PINK = {
		name = "Pink",
		brick_color = "Pink",
		color = Color3.fromRGB(255, 102, 204)
	},
	DARK_GRAY = {
		name = "Dark Gray",
		brick_color = "Dark stone grey",
		color = Color3.fromRGB(99, 95, 98)
	},
	LIGHT_GRAY = {
		name = "Light Gray",
		brick_color = "Fossil",
		color = Color3.fromRGB(159, 161, 172)
	},
	CYAN = {
		name = "Cyan",
		brick_color = "Cyan",
		color = Color3.fromRGB(4, 175, 236)
	},
	PURPLE = {
		name = "Purple",
		brick_color = "Bright violet",
		color = Color3.fromRGB(107, 50, 124)
	},
	BROWN = {
		name = "Brown",
		brick_color = "Burnt Sienna",
		color = Color3.fromRGB(106, 57, 9)
	},
	DARK_GREEN = {
		name = "Dark Green",
		brick_color = "Parsley green",
		color = Color3.fromRGB(24, 97, 22 )
	},
	RED = {
		name = "Red",
		brick_color = "Really red",
		color = Color3.fromRGB(255, 0, 0)
	},
}

------------------------
-- VARIABLES (ENDS)
------------------------

-- Gets pist part color from brick color.
-- @param _brick_color Brick color. (Color3)
-- @return Pist part color.
function class.fromBrickColor(_brick_color : Color3)
	for _, data in pairs(class.content) do
		if data.brick_color == _brick_color then return data end
	end
end


-- ENDS
return class