local class = {}
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

local random = Random.new()
local letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}

------------------------
-- VARIABLES (ENDS)
------------------------


-- Uppercases the first letter of the string.
-- @param _string Target string.
-- @return Capitalized string.
function class.capitalize(_string : string)
    -- Object nil checks.
    assert(_string ~= nil, "String to check cannot be null")
	return _string:gsub("^%a", string.upper)
end

-- Returns whether or not text is only whitespace.
-- @param _string String to check.
-- @return Answer. (BOOLEAN)
function class.isWhitespace(_string : string)
    -- Object nil checks.
    assert(_string ~= nil, "String to check cannot be null")
	return _string == "" or string.match(_string, "[%s]+") == _string
end

-- Returns if a string ends with a postfix.
-- @param _string String to check in.
-- @param _postfix String to check.
-- @return Answer. (BOOLEAN)
function class.endsWith(_string, _postfix)
    -- Object nil checks.
    assert(_string ~= nil, "String to check in cannot be null")
    assert(_postfix ~= nil, "String to check cannot be null")

	return _string:sub(-#_postfix) == _postfix
end

-- Returns if a string starts with a postfix.
-- @param _string String to check in.
-- @param _prefix String to check.
-- @return Answer. (BOOLEAN)
function class.startsWith(_string, _prefix)
    -- Object nil checks.
    assert(_string ~= nil, "String to check in cannot be null")
    assert(_prefix ~= nil, "String to check cannot be null")

	return _string:sub(1, #_prefix) == _prefix
end

-- Gets random letter.
-- @return Char.
function class.randomLetter()
	return letters[random:NextInteger(1,#letters)]
end

-- Gets random string.
-- @param length String length.
-- @param includeCapitals Should include capitals or not.
-- @return Random string.
function class.random(length, includeCapitals)
	length = length or 10
	local string = ''
	for i=1,length do
		local randomLetter = class.randomLetter()
		if includeCapitals and random:NextNumber() > .5 then
			randomLetter = string.upper(randomLetter)
		end
		string = string .. randomLetter
	end
	return string
end


-- ENDS
return class