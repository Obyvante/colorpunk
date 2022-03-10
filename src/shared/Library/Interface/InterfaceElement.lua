local class = {}
class.__index = class
-- IMPORTS
local EventBinder = require(script.Parent.Parent:WaitForChild("Templates"):WaitForChild("EventBinder"))
local Metadata = require(script.Parent.Parent:WaitForChild("Templates"):WaitForChild("Metadata"))
-- STARTS


-- Creates an interface element.
-- @param _interface Interface.
-- @param _id Interface element id.
-- @param _data Interface instance data.
-- @param _parent Interface element parent.
-- @return Created interface element.
function class.new(_interface : ModuleScript, _data : table, _parent : Folder)
    -- Object nil checks.
    assert(_interface ~= nil, "Interface cannot be null")
    assert(_data ~= nil, "Interface element data cannot be null")

    -- Creates an interface element table.
    local _element = setmetatable({}, class)
    _element["interface"] = _interface
    _element["parent"] = _parent
    _element["id"] = _data.Name
    _element["elements"] = {}

    -- Creates an instance based on interface element type.
    local instance = Instance.new(_data.Type)
    instance.Name = _data.Name
    _element["instance"] = instance

    -- Adds properties to the created instance.
    if _data.Properties then
        _element:updateProperties(_data.Properties)
    end
    
    instance.Parent = if not _parent then _interface:getScreen() else _parent:getInstance()

    -- Adds events to the created instance.
    if _data.Events then _element:updateEvents(_data.Events) end

    -- Adds builds to the created instance.
    if _data.BuildWith then
        for _, _build in ipairs(_data.BuildWith) do
            if _build == "AspectRatio" then
                -- Gets abosule sizes as default.
                local X = _element.instance.AbsoluteSize.X
                local Y = _element.instance.AbsoluteSize.Y

                -- If there are custom sizes, declares it.
                if _element.Size then
                    X = _element.Size.X
                    Y = _element.Size.Y
                end

                -- Adds an element to the list with calculated properties.
                _element:addElement({
                    Type = "UIAspectRatioConstraint",
                    Name = "AspectRatio",
                    Properties = {
                        AspectRatio = X / Y,
                        AspectType = "FitWithinMaxSize",
                        DominantAxis = "Width"
                    }
                })
            else
                warn(_element:getLogPrefix() .. " build with(" .. _build .. ") is not exist")
            end
        end
    end

    return _element
end

-- Gets interface element metadata.
-- @return Metadata.
function class:getMetadata()
    if not self.metadata then
        self.metadata = Metadata.new()
    end
    return self.metadata
end

-- Gets event binder.
-- @return Interface element event binder.
function class:getEventBinder()
    if not self.event_binder then self.event_binder = EventBinder.new(self) end
    return self.event_binder
end

-- Gets log prefix.
-- @return Log prefix. (STRING)
function class:getLogPrefix()
    return "Interface(" .. self.interface:getId() .. ") element(" .. self.id .. ")"
end

-- Gets interface.
-- @return Interface.
function class:getInterface()
    return self.interface
end

-- Gets parent of the interface element.
-- @return Interface element. (NULLABLE)
function class:getParent()
    return self.parent
end

-- Gets interface element id.
-- @return Interface element id.
function class:getId()
    return self.id
end

-- Gets interface element instance.
-- @return Instance.
function class:getInstance()
    return self.instance
end


------------------------
-- PIXEL BASED (STARTS)
------------------------

-- Gets interface element size. (Pixel based)
-- @return Interface element size. (Vector2)
function class:getSize()
    return self.Size
end

-- Calculates interface element size. (Pixel based)
-- @param _x X-axis.
-- @param _y Y-axis.
-- @return Calculation result. (Vector2)
function class:getSizeCalculation(_x : number, _y : number)
    -- Object nil checks.
    assert(_x ~= nil, self:getLogPrefix() .. " X-axis size cannot be null")
    assert(_y ~= nil, self:getLogPrefix() .. " Y-axis size cannot be null")

    -- Declares required fields.
    local X, Y
    local viewport = self.interface:getViewport()
    local has_parent = self.parent ~= nil

    -- Handles parent and child.
    if has_parent then
        -- Early check to handle safety.
        assert(self.parent:getSize() ~= nil, "To set custom size with parent, there must be also a custom sized parent")

        local parent_size = self.parent:getSize()

        X = _x / parent_size.X
        Y = _y / parent_size.Y
    else
        X = _x / viewport.X
        Y = _y / viewport.Y
    end

    return Vector2.new(X, Y)
end

-- Sets interface element size. (Pixel based)
-- @param _x X-axis.
-- @param _y Y-axis.
-- @return Interface element. (BUILDER)
function class:setSize(_x : number, _y : number)
    local result = self:getSizeCalculation(_x, _y)
    -- Updates instance with calculated size.
    self.instance.Size = UDim2.fromScale(result.X, result.Y)
    -- Saves size information.
    self.Size = Vector2.new(_x, _y)
    return self
end

-- Gets interface element position. (Pixel based)
-- @return Interface element position. (table: X, Y)
function class:getPosition()
    return self.Position
end

-- Calculates interface element position. (Pixel based)
-- @param _x X-axis.
-- @param _y Y-axis.
-- @return Calculation result. (Vector2)
function class:getPositionCalculation(_x : number, _y : number)
    -- Object nil checks.
    assert(_x ~= nil, self:getLogPrefix() .. " X-axis size cannot be null")
    assert(_y ~= nil, self:getLogPrefix() .. " Y-axis size cannot be null")
    -- Safety check.
    assert(self.Size ~= nil, self:getLogPrefix() .. ", to set position(pixel-based), interface element must has pixel-based size!")

    -- Declares required fields.
    local X, Y
    local viewport = self.interface:getViewport()
    local anchor_point = self.instance.AnchorPoint
    local should_calculate_anchor = anchor_point ~= nil and (anchor_point.X ~= 0 or anchor_point.Y ~= 0)

    -- Handles parent and child.
    if self.parent ~= nil then
        -- Early check to handle safety.
        assert(self.parent ~= nil and self.parent:getSize() ~= nil, self:getLogPrefix() .. ", to set position(pixel-based) with parent, interface element parent must has pixel-based size!")

        local parent_size = self.parent:getSize()

        if should_calculate_anchor then
            X = _x + (self.Size.X * anchor_point.X)
            Y = _y + (self.Size.Y * anchor_point.Y)

            X = X / parent_size.X
            Y = Y / parent_size.Y
        else
            X = _x / parent_size.X
            Y = _y / parent_size.Y
        end
    else
        if should_calculate_anchor then
            X = _x + (self.Size.X * anchor_point.X)
            Y = _y + (self.Size.Y * anchor_point.Y)

            X = X / viewport.X
            Y = Y / viewport.Y
        else
            X = _x / viewport.X
            Y = _y / viewport.Y
        end
    end

    return Vector2.new(X, Y)
end

-- Sets interface element position. (Pixel based)
-- @param _x X-axis.
-- @param _y Y-axis.
-- @return Interface element. (BUILDER)
function class:setPosition(_x : number, _y : number)
    local result = self:getPositionCalculation(_x, _y)
    -- Updates instance with calculated position.
    self.instance.Position = UDim2.fromScale(result.X, result.Y)
    -- Saves position information.
    self.Position = Vector2.new(_x, _y)
    return self
end

-- Gets interface element font size. (Pixel based)
-- @return Interface element font size.
function class:getFontSize()
    return self.FontSize
end

-- Sets interface element font size. (Pixel based)
-- @param _x X-axis.
-- @param _y Y-axis.
-- @return Interface element. (BUILDER)
function class:setFontSize(_size : number)
    -- Object nil checks.
    assert(_size ~= nil, self:getLogPrefix() .. " font size cannot be null")
    -- Safety check.
    assert(self.parent ~= nil and self.parent:getSize() ~= nil, self:getLogPrefix() .. ", to set font size(pixel-based), interface element parent must has pixel-based size!")

    -- Declares required fields.
    local parent_size = self.parent:getSize()

    -- Creates UI scale consumer.
    local _consumer = function(_binder)
        -- Waits heartbeat to update viewport size.
        game:GetService("RunService").Heartbeat:Wait()

        -- Safety check.
        if self.parent:getInstance() == nil then return end

        -- Calculates font size ratio.
         local font_size_ratio = self.parent:getInstance().AbsoluteSize.X / parent_size.X

        -- Updates font size with using "UISize" object. (HACKY SOLUTION)
        _binder:getParent():updateProperties({
              Scale = self:getFontSize() * font_size_ratio
        })
    end

    local previous_transparency = self.instance.TextTransparency
    self.instance.TextTransparency = 1

    -- Handles previous font size.
    if self:getFontSize() == nil then
        -- Configures default text size and transparency to wait process to be done.
        self.instance.TextSize = 1
    
        -- Adds text scale element.
        local text_scale = self:addElement({
            Name = "scale",
            Type = "UIScale",
            Properties = {
                Scale = _size * self.parent:getInstance().AbsoluteSize.X / parent_size.X,
            },
            Events = {
                {
                    Name = "Font Size Calculation",
                    BindTo = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),
                    Consumer = _consumer
                }
            }
        })
    
        -- Handles text rescale.
        task.spawn(function()
            -- Calls consumer function.
            _consumer(text_scale:getEventBinder())
            -- Safety check.
            if self.parent:getInstance() == nil then return end

            -- Makes text previous text transparency.
            self.instance.TextTransparency = previous_transparency
        end)
    else
        -- Handles text rescale.
        task.spawn(function()
            -- Calls consumer function.
            _consumer(self:getElement("scale"):getEventBinder())
            -- Safety check.
            if self.parent:getInstance() == nil then return end

            -- Makes text previous text transparency.
            self.instance.TextTransparency = previous_transparency
        end)
    end

    -- Saves size information.
    self.FontSize = _size

    return self
end

------------------------
-- PIXEL BASED (ENDS)
------------------------


------------------------
-- ELEMENTS (STARTS)
------------------------

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
    assert(_id ~= nil, self:getLogPrefix() .. " id cannot be null")
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
    assert(_data ~= nil, self:getLogPrefix() .. " data cannot be null")

    local _id = _data.Name
    if self.elements[_id] ~= nil then error("Tried to create an interface(" .. self.interface:getId() .. ") element with same id of " .. _id) end

    local element = class.new(self.interface, _data, self)
    self.elements[_id] = element

    return element
end

------------------------
-- ELEMENTS (ENDS)
------------------------


------------------------
-- ACTIONS (STARTS)
------------------------

-- Updates interface events.
-- @param _events Events.
-- @return Interface element. (BUILDER)
function class:updateEvents(_events : table)
    -- Object nil checks.
    assert(_events ~= nil, self:getLogPrefix() .. " events cannot be null")

    local event_binder = self:getEventBinder()
    for _, _event in ipairs(_events) do
        if _event.BindTo ~= nil then
            event_binder:bind(_event.BindTo, _event)
        else
            event_binder:bind(self.instance[_event.Event], _event)
        end
    end

    return self
end

-- Updates interface element instance.
-- @param _properties Interface element instance properties.
-- @return Interface element. (BUILDER)
function class:updateProperties(_properties : table)
    -- Object nil checks.
    assert(_properties ~= nil, self:getLogPrefix() .. " properties cannot be null[update properties]")

    -- Saves properties to the instance.
    for key, value in pairs(_properties) do
        -- If it is custom property, no need to continue.
        if key == "Custom" then continue end
        self.instance[key] = value
    end

    -- Handls custom properties.
    if _properties.Custom then
        -- Handles custom size.
        if _properties.Custom.Size then self:setSize(_properties.Custom.Size.X, _properties.Custom.Size.Y) end
        -- Handles custom position.
        if _properties.Custom.Position then self:setPosition(_properties.Custom.Position.X, _properties.Custom.Position.Y) end
        -- Handles custom position.
        if _properties.Custom.FontSize then self:setFontSize(_properties.Custom.FontSize) end
    end

    return self
end

-- Destroys interface element.
function class:destroy()
    if self.metadata then self.metadata:reset() end
    if self.event_binder then self.event_binder:destroy() end
    for _, value in pairs(self.elements) do value:destroy() end
    self.instance:Destroy()

    -- Removes interface element from the parent elements list.
    if self.parent ~= nil then
        self.parent:getElements()[self.id] = nil
    else
        self.interface:getElements()[self.id] = nil
    end

    setmetatable(self, nil)
end

------------------------
-- ACTIONS (ENDS)
------------------------


------------------------
-- ACTION HANDLERS (STARTS)
------------------------

-- Be triggered on bind action.
function class:onBind()
    -- Updating font size since it doesn't support changes.
    if self:getFontSize() then self:setFontSize(self:getFontSize()) end
    -- Triggers bind action for all sub elements.
    for _, value in pairs(self.elements) do value:onBind() end
end

-- Be triggered on unbind action.
function class:onUnbind()
    -- Triggers unbind action for all sub elements.
    for _, value in pairs(self.elements) do value:onUnbind() end
end

------------------------
-- ACTION HANDLERS (ENDS)
------------------------


-- ENDS
return class