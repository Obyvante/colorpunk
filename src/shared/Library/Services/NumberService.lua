local class = {}
-- STARTS


-- Abbriviations.
local abbriviations = {
	K = 4, -- Thousand
	M = 7, -- Million
	B = 10, -- Billion
	T = 13, -- Trillion
	Qa = 16, -- Quadrillion
	Qi = 19, -- Quintillion
	SI = 22, -- Sextillion
	SP = 25, -- Septillion
	Oc = 28, -- Octillion
	N = 31, -- Nonillion
	DC = 34 -- Decillion+
}  

-- Formats number.
-- @param number Number.
-- @return Formatted number. (STRING)
function class.format(number)
	-- Converts number to a text.
	local text = tostring(math.floor(number))
	
	-- Creates emppty abbriviation field to handle number.
	local chosen_abbriviation
	
	-- Loops through abbriviations.
	for abbriviation, digits in pairs(abbriviations) do
		-- If text is fits for current abbrivitation, chooses it.
		if #text >= digits and #text < (digits + 3) then
			chosen_abbriviation = abbriviation
			break
		end
	end
	
	-- If there is a fit abbriviation.
	if chosen_abbriviation then
		-- Gets digits.
		local digits = abbriviations[chosen_abbriviation]
		
		-- Calculates rounded.
		local rounded = math.floor(number / 10 ^ (digits - 2)) * 10 ^ (digits - 2)
		-- Configures string format.
		text = string.format("%.1f", rounded / 10 ^ (digits - 1)) .. chosen_abbriviation
		
		-- Returns calculated number as a string format.
		return text
	end
	
	-- If there is no fit for number, returns pure.
	return number
end


-- ENDS
return class