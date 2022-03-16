local class = {}
class.__index = class
-- IMPORTS
local InterfaceElement = require(script.Parent:WaitForChild("InterfaceElement"))
-- STARTS


-- Creates an interface for billboard gui.
-- @param _id Interface id.
-- @param _viewport Interface viewport. (BASED ON)
-- @return Created interface.
function class.createBillboard(_id : string, _viewport : Vector2, _properties : table)
    -- Object nil checks.
    assert(_id ~= nil, "Interface id cannot be null")
    assert(_viewport ~= nil, "Interface(" .. _id .. ") viewport cannot be null")

    local _screen = Instance.new("BillboardGui")
    _screen.Name = _id
    _screen.ResetOnSpawn = false

    -- Sets billboard properties.
    if _properties then
        for key, value in pairs(_properties) do
            _screen[key] = value
        end
    end

    -- Sets metatable then returns it.
    return setmetatable({
        ["id"] = _id,
        ["screen"] = _screen,
        ["viewport"] = _viewport,
        ["elements"] = {},
        ["functions"] = {}
    }, class)
end

-- Creates an interface for screen gui.
-- @param _id Interface id.
-- @param _viewport Interface viewport. (BASED ON)
-- @param _priority Interface priority. (HIGHER)
-- @return Created interface.
function class.createScreen(_id : string, _viewport : Vector2, _proirity : number)
    -- Object nil checks.
    assert(_id ~= nil, "Interface id cannot be null")
    assert(_viewport ~= nil, "Interface(" .. _id .. ") viewport cannot be null")

    local _screen = Instance.new("ScreenGui")
    _screen.Name = _id
    _screen.IgnoreGuiInset = true
    _screen.ResetOnSpawn = false
    _screen.DisplayOrder = _proirity == nil and 0 or _proirity

    -- Sets metatable then returns it.
    return setmetatable({
        ["id"] = _id,
        ["screen"] = _screen,
        ["viewport"] = _viewport,
        ["elements"] = {},
        ["functions"] = {}
    }, class)
end

-- Gets interface metadata.
-- @return Metadata.
function class:getMetadata()
    if not self.metadata then
        self.metadata = require(script.Parent.Parent:WaitForChild("Templates"):WaitForChild("Metadata")).new()
    end
    return self.metadata
end

-- Gets interface id.
-- @return Interface id.
function class:getId()
    return self.id
end

-- Gets interface screen.
-- @return Interface screen. (Screen Gui, Billboard Gui etc.)
function class:getScreen()
    return self.screen
end

-- Gets interface viewport.
-- @return Interface viewport. (VECTOR2)
function class:getViewport()
    return self.viewport
end

-- Gets interface elements.
-- @return Interface elements.
function class:getElements()
    return self.elements
end

-- Gets interface element by its id.
-- @param _id Interface element id.
-- @return Interface element. (NULLABLE)
function class:getElement(_id : string)
    -- Object nil checks.
    assert(_id ~= nil, "Interface element id cannot be null")
    return self.elements[_id]
end

-- Gets interface element by path.
-- @param _path Interface element path.
-- @return Interface element. (NULLABLE)
function class:getElementByPath(_path : string)
    -- Object nil checks.
    assert(_path ~= nil, "Interface element path cannot be null")

    local paths = string.split(_path, ".")
    local current
    for i = 1, #paths, 1 do
        current = if i == 1 then self.elements[paths[i]] else current:getElements()[paths[i]]
        if current == nil then return nil end
    end

    return current
end

-- Adds an interface element to the screen.
-- @param _id Interface element id.
-- @param _properties Properties of interface element.
-- @return Created interface element.
function class:addElement(_data : string)
    -- Object nil checks.
    assert(_data ~= nil, "Interface element data cannot be null")

    local _id = _data.Name
    if self.elements[_id] ~= nil then error("Tried to create an interface(" .. self.id .. ") element with same id of " .. _id) end

    local element = InterfaceElement.new(self, _data)
    self.elements[_id] = element

    return element
end

-- Gets interface function by its id.
-- @param _id Interface function id.
-- @return Interface function. (NULLABLE)
function class:getFunction(_id : string)
    -- Object nil checks.
    assert(_id ~= nil, "Interface funtion id cannot be null")
    return self.functions[_id]
end

-- Adds a function to the interface.
-- @param _id Function id.
-- @param _function Function.
-- @return Interface function.
function class:addFunction(_id : string, _function)
    -- Object nil checks.
    assert(_id ~= nil, "Interface function id cannot be null")
    assert(_function ~= nil, "Interface function cannot be null")
    if self.functions[_id] ~= nil then error("Tried to create an interface(" .. self.id .. ") function with same id of " .. _id) end

    self.functions[_id] = _function
    return _function
end

-- Runs interface function by its id.
-- @param _id Interface function id.
-- @return Function output.
function class:runFunction(_id : string, ...)
    local _function = self:getFunction(_id)
    return _function(self, ...)
end

-- Gets if interface is bound or not.
-- @return If interface is bound or not.
function class:isBound()
    return self.parent ~= nil
end

-- Binds interface to target instance.
-- @param instance Instance to bind to.
function class:bind(instance : Instance)
    -- Object nil checks.
    assert(instance ~= nil, "Interface(" .. self.id .. ") instance cannot be null")

    self.parent = instance
    self.screen.Parent = instance
    for _, value in pairs(self.elements) do value:onBind() end
end

-- Unbinds interface.
function class:unbind()
    if self.parent == nil then return end
    for _, value in pairs(self.elements) do value:onUnbind() end
    self.parent = nil
    self.screen.Parent = nil
end

-- Destroys interface.
function class:destroy()
    if self.metadata then self.metadata:reset() end
    for _, value in pairs(self.elements) do value:destroy() end

    self.screen:Destroy()

    setmetatable(self, nil)
end


-- ENDS
return class