local class = {}
-- STARTS


-- Shallow copies table.
-- @param target Table to copy.
-- @return Copied new table. [TABLE]
function class.copy(target : table)
    -- Object nil checks.
    assert(target ~= nil, "Table to copy cannot be nil")

    -- If it is not table, just returns it.
    if type(target) ~= 'table' then return target end

    local result = {}
    for key, value in pairs(target) do
        result[class.copy(key)] = class.copy(value)
    end

    return result
end

-- Deep copies table.
-- @param target Table to copy.
-- @param _context Context of deep copy table. (DO NOT TOUCH IT)
-- @return Copied new table. [TABLE]
function class.deepCopy(target : table, _context : table)
    -- Object nil checks.
    assert(target ~= nil, "Table to copy cannot be nil")

    -- If it is not table, just returns it.
    if type(target) ~= 'table' then return target end
    -- Handles deep copy context.
    if _context and _context[target] then return _context[target] end

    -- Declares required fields.
    local _seen = _context or {}
    local result = {}
    _seen[target] = result

    for key, value in pairs(target) do 
        result[class.deepCopy(key, _seen)] = class.deepCopy(value, _seen)
    end

    -- Sets metatable of result then returns it.
    return setmetatable(result, getmetatable(target))
end

-- Inverts table.
-- @param table Table to invert.
-- @return Inverted table. [TABLE]
function class.invert(table : table)
    -- Object nil checks.
    assert(table ~= nil, "Table to invert cannot be nil")

	local result = {}

	for key, value in pairs(table) do
		result[value] = key
	end

	return result
end

-- Merges source to target.
--
-- NOTE: It will not copy the source table,
-- it will just append it as "key = value" to target table.
--
-- @param origin Origin table.
-- @param source Source table.
-- @param overwrite Should overwrite key or not. (DEFAULT = FALSE)
-- @return Merged table. (base of target)
function class.merge(origin : table, source : table, overwrite : boolean)
    -- Object nil checks.
    assert(origin ~= nil, "Origin table cannot be nil")
    assert(source ~= nil, "Source table cannot be nil")

    -- If 'overwrite' is nil, converts it to 'false' as default.
    if overwrite == nil then overwrite = false end
    
    local result = {}

    -- Handles origin.
    for key, value in pairs(origin) do
        result[key] = value
    end

    -- Handles source.
    for key, value in pairs(source) do
        -- Handles overwrite.
        if not overwrite and class.containsKey(result, key) then continue end
        result[key] = value
    end

    return result
end

-- Checks if key is exists in table or not.
-- @param _table Table to search in.
-- @param _key Key to search in table.
-- @return If key is exists in table or not.
function class.containsKey(_table : table, _key : string)
    -- Object nil checks.
    assert(_table ~= nil, "Table to search in cannot be nil")
    assert(_key ~= nil, "Key to search in table cannot be nil")

    return _table[_key] ~= nil
end

-- Checks if value is exists in table or not.
-- @param _table Table to search in.
-- @param _value Value to search in table.
-- @return If value is exists in table or not.
function class.containsValue(_table : table, _value : string)
    -- Object nil checks.
    assert(_table ~= nil, "Table to search in cannot be nil")
    assert(_value ~= nil, "Value to search in table cannot be nil")

    for _, value in pairs(_table) do
        if value == _value then
            return true
        end
    end
    return false
end

-- Gets size of table.
-- @param _table Table to check its size.
-- @return Size of table.
function class.size(_table : table)
    -- Object nil checks.
    assert(_table ~= nil, "Table to check its size cannot be nil")

    local size = 0
    for _, _ in pairs(_table) do
        size = size + 1
    end
    return size
end

-- Gets key by value.
-- @param _table Table to search in.
-- @param _value Value to search in table.
-- @return If value exists its key, otherwise nil.
function class.getKeyByValue(_table : table, _value : ObjectValue)
    -- Object nil checks.
    assert(_table ~= nil, "Table to check its size cannot be nil")
    assert(_value ~= nil, "Value to search in table cannot be nil")

    for key, value in pairs(_table) do
        if value == _value then
            return key
        end
    end
    return nil
end

-- Gets keys of target table.
-- @param _table Target table.
-- @return Table keys.
function class.keys(_table : table)
    -- Object nil checks.
    assert(_table ~= nil, "Target table cannot be nil")

    local result = {}
    for key, _ in pairs(_table) do
		table.insert(result, key)
    end
    return result
end

-- Gets values of target table.
-- @param _table Target table.
-- @return Table values.
function class.values(_table : table)
    -- Object nil checks.
    assert(_table ~= nil, "Target table cannot be nil")

	local result = {}
	for _, value in pairs(_table) do
		table.insert(result, value)
	end
	return result
end


-- ENDS
return class