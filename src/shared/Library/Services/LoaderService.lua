local class = {}
-- STARTS


-- VARIABLES
local _modules = {}


-- Gets module by its name.
-- @param _name Module name.
-- @return Module. [CLASS]
function class.getModule(_name : string)
    -- Object nil checks.
    assert(_name ~= nil, "Module name cannot be null")
	assert(_modules[_name], "Invalid module name: " .. _name)
	return require(_modules[_name])
end

-- Saves module.
-- @param _instance Instance(Module Script) to save.
function class.saveModule(_instance : Instance)
    -- Object nil checks.
    assert(_instance ~= nil, "Instance to search in cannot be null")
    assert(_modules[_instance.Name] == nil, "More than one module script is using the name: " .. _instance.Name)
    assert(_instance:IsA("ModuleScript"), "Tried to save not module script module(" .. _instance.Name .. ")")

    -- Saves instance(module) to distionary.
    _modules[_instance.Name] = _instance
end

-- Saves modules inside of the instance.
-- @param _instance Instance to search in.
function class.saveModules(_instance : Instance)
    -- Object nil checks.
    assert(_instance ~= nil, "Instance to search in cannot be null")

    for _, descendant in ipairs(_instance:GetDescendants()) do
        if not descendant:IsA("ModuleScript") then continue end
        -- Saves module.
        class.saveModule(descendant)
    end
end

-- Gets and waits child by dot notation.
--
-- WARNING: This function is using Roblox's 'WaitForChild' method
-- to handle calls. It'll freeze the main thread.
--
-- @param _instance Instance to search in.
-- @param _path Path.
-- @param shouldRequire (OPTIONAL) Should require child or not. Default is 'false'.
-- @return Target child.
function class.waitChild(_instance : Instance, _path : string, shouldRequire : boolean)
    -- Object nil checks.
    assert(_instance ~= nil, "Instance to search in cannot be nil")
    assert(_path ~= nil, "Path cannot be nil")

    -- If 'shouldRequire' is nil, converts it to 'false' as default.
    if shouldRequire == nil then shouldRequire = false end

	-- Splits path.
	local paths = string.gmatch(_path, "([^.]+)")

	-- Loops through path keys.
	for key in paths do
		-- Waits for next child. (YIELDS!)
		_instance = _instance:WaitForChild(key)
	end

	return shouldRequire and require(_instance) or _instance
end


-- ENDS
return class