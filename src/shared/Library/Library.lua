local class = {}
-- IMPORTS
local RunService = game:GetService("RunService")
-- STARTS


-- VARIABLES
local _services = {}
local _templates = {}


-- Saves templates inside of the instance.
-- @param _instance Instance to search in.
function class.saveTemplates(_instance : Instance)
    -- Object nil checks.
    assert(_instance ~= nil, "Instance to search in cannot be null")

    for _, descendant in ipairs(_instance:GetDescendants()) do
        if not descendant:IsA("ModuleScript") then continue end
        -- Saves service.
        class.saveTemplate(descendant)
    end
end

-- Saves service.
-- @param _instance Instance(Module Script) to save.
function class.saveService(_instance : Instance)
    -- Object nil checks.
    assert(_instance ~= nil, "Instance to search in cannot be null")
    assert(_services[_instance.Name] == nil, "More than one module script is using the name: " .. _instance.Name)
    assert(_instance:IsA("ModuleScript"), "Tried to save not module script service(" .. _instance.Name .. ")")

    -- Saves instance(service) to distionary.
    _services[_instance.Name] = _instance
end

-- Saves services inside of the instance.
-- @param _instance Instance to search in.
function class.saveServices(_instance : Instance)
    -- Object nil checks.
    assert(_instance ~= nil, "Instance to search in cannot be null")

    for _, descendant in ipairs(_instance:GetDescendants()) do
        if not descendant:IsA("ModuleScript") then continue end
        -- Saves service.
        class.saveService(descendant)
    end
end

-- Gets template by its name.
-- @param _name Template name.
-- @return Template. [CLASS]
function class.getTemplate(_name : string)
    -- Object nil checks.
    assert(_name ~= nil, "Template name cannot be null")
	assert(_templates[_name], "Invalid template name: " .. _name)
	return require(_templates[_name])
end

-- Saves template.
-- @param _instance Instance(Module Script) to save.
function class.saveTemplate(_instance : Instance)
    -- Object nil checks.
    assert(_instance ~= nil, "Instance to search in cannot be null")
    assert(_templates[_instance.Name] == nil, "More than one module script is using the name: " .. _instance.Name)
    assert(_instance:IsA("ModuleScript"), "Tried to save not module script template(" .. _instance.Name .. ")")

    -- Saves instance(template) to distionary.
    _templates[_instance.Name] = _instance
end

-- Gets service by its name.
-- @param _name Service name.
-- @return Service. [CLASS]
function class.getService(_name : string)
    -- Object nil checks.
    assert(_name ~= nil, "Service name cannot be null")
	assert(_services[_name], "Invalid service name: " .. _name)
	return require(_services[_name])
end

----------
-- INITIALIZATION
----------

-- Handles client and server side libraries.
if RunService:IsClient() then
    class.saveServices(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Services"))
    class.saveTemplates(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Templates"))
elseif RunService:IsServer() then
    class.saveServices(game.ReplicatedStorage.Library.Services)
    class.saveServices(game.ServerScriptService.Library.Services)
    class.saveTemplates(game.ReplicatedStorage.Library.Templates)
    class.saveTemplates(game.ServerScriptService.Library.Templates)
end

-- Informs console that library has been loaded.
print("Barden Roblox Library(" .. (RunService:IsClient() and "client" or "server") .. ") has been initialized!")


-- ENDS
return class