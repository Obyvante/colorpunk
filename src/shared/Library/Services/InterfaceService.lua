local class = {}
-- IMPORTS
local Interface = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Interface"):WaitForChild("Interface"))
-- STARTS


-- VARIABLES
local _addons = {}
local _interfaces = {}
-- STATICS
class.VIEWPORTS = {
    PC = Vector2.new(3840, 2160),
    MOBILE = Vector2.new(1366, 1024)
}

-- Gets addon by its name.
-- @param _name Addon name.
-- @return Addon. [CLASS]
function class.getAddon(_name : string)
    -- Object nil checks.
    assert(_name ~= nil, "Addon name cannot be null")
	assert(_addons[_name], "Invalid addon name: " .. _name)
	return require(_addons[_name])
end

-- Saves addon.
-- @param _instance Instance(Module Script) to save.
function class.saveAddon(_instance : Instance)
    -- Object nil checks.
    assert(_instance ~= nil, "Instance to search in cannot be null")
    assert(_addons[_instance.Name] == nil, "More than one module script is using the name: " .. _instance.Name)
    assert(_instance:IsA("ModuleScript"), "Tried to save not module script addon(" .. _instance.Name .. ")")

    -- Saves instance(addon) to distionary.
    _addons[_instance.Name] = _instance
end

-- Saves addons inside of the instance.
-- @param _instance Instance to search in.
function class.saveAddons(_instance : Instance)
    -- Object nil checks.
    assert(_instance ~= nil, "Instance to search in cannot be null")

    for _, descendant in ipairs(_instance:GetDescendants()) do
        if not descendant:IsA("ModuleScript") then continue end
        -- Saves addon.
        class.saveAddon(descendant)
    end
end


----------
-- INITIALIZATION
----------

class.saveAddons(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Interface"):WaitForChild("Addons"))


----------
-- API CALLS
----------

-- Gets interface by its id.
-- @param _id Interface id.
-- @return Interface. (NULLABLE)
function class.get(_id : string)
    -- Object nil check.
    assert(_id ~= nil, "Interface id cannot be null")
    return _interfaces[_id]
end

-- Creates an interface for screen gui.
-- @param _id Interface id.
-- @param _viewport Interface viewport. (BASED ON)
-- @return Created interface.
function class.createScreen(_id : string, _viewport : Vector2, _proirty : number)
    -- Object nil check.
    assert(_id ~= nil, "Interface id cannot be null")
    assert(_viewport ~= nil, "Interface(" .. _id .. ") viewport cannot be null")
    assert(_interfaces[_id] == nil, "Interface(" .. _id .. ") is already exist")

    -- Creates an interface.
    local interface = Interface.createScreen(_id, _viewport, _proirty)
    -- Adds created interface to the list.
    _interfaces[_id] = interface

    return interface
end

-- Creates an interface for billboard gui.
-- @param _id Interface id.
-- @param _viewport Interface viewport. (BASED ON)
-- @return Created interface.
function class.createBillboard(_id : string, _viewport : Vector2, _properties : table)
    -- Object nil check.
    assert(_id ~= nil, "Interface id cannot be null")
    assert(_viewport ~= nil, "Interface(" .. _id .. ") viewport cannot be null")
    assert(_interfaces[_id] == nil, "Interface(" .. _id .. ") is already exist")

    -- Creates an interface.
    local interface = Interface.createBillboard(_id, _viewport, _properties)
    -- Adds created interface to the list.
    _interfaces[_id] = interface

    return interface
end

-- Deletes interface by its id.
-- @param _id Interface id.
function class.delete(_id : string)
    -- Object nil check.
    assert(_id ~= nil, "Interface id cannot be null")
    assert(_interfaces[_id] ~= nil, "Interface(" .. _id .. ") is not exist")

    _interfaces[_id]:destroy()
    _interfaces[_id] = nil
end


----------
-- UTILS
----------

-- Checks if it is clicked or not.
-- @param _type Enum input type.
-- @param _state Input state
-- @return If it is clicked or not.
function class.isClicked(_type : Enum, _state : Enum)
    if _state ~= Enum.UserInputState.End then return false end
    return _type == Enum.UserInputType.MouseButton1 or _type == Enum.UserInputType.Touch
end


-- ENDS
return class