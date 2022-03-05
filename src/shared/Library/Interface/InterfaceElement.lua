local class = {}
class.__index = class
-- IMPORTS
local TableService = require(script.Parent.Parent:WaitForChild("Services"):WaitForChild("TableService"))
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
    if _data.Events then
        _element["event_binder"] = EventBinder.new(_element)
        for _, _event in ipairs(_data.Events) do
            if _event.BindTo ~= nil then
                _element["event_binder"]:bind(_event.BindTo, _event)
            else
                _element["event_binder"]:bind(_element["instance"][_event.Event], _event)
            end
        end
    end

    -- Adds builds to the created instance.
    if _data.BuildWith then
        for _, _build in ipairs(_data.BuildWith) do
            if _build == "AspectRatio" then
                -- Gets abosule sizes as default.
                local X = _element.instance.AbsoluteSize.X
                local Y = _element.instance.AbsoluteSize.Y

                -- If there are custom sizes, declares it.
                if _element.properties.Custom then
                    X = _element.properties.Custom.Size.X
                    Y = _element.properties.Custom.Size.Y
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

-- Gets interface element properties.
-- @return Interface element properties.
function class:getProperties()
    return self.properties
end

-- Updates interface element instance.
-- @param _properties Interface element instance properties.
-- @return Interface element. (BUILDER)
function class:updateProperties(_properties : table)
    -- Object nil checks.
    assert(_properties ~= nil, self:getLogPrefix() .. " properties cannot be null[update properties]")
    self.properties = TableService.deepCopy(_properties)

    -- Saves properties to the instance.
    for key, value in pairs(_properties) do
        -- If it is custom property, no need to continue.
        if key == "Custom" then continue end

        self.instance[key] = value
    end

    -- Handls custom properties.
    if _properties.Custom then
        -- Declares required fields.
        local viewport = self.interface:getViewport()
        local ratio = viewport.X / viewport.Y
        local anchor_point = _properties.AnchorPoint
        local should_calculate_anchor = anchor_point ~= nil and (anchor_point.X ~= 0 or anchor_point.Y ~= 0)
        local has_parent = self.parent ~= nil
        local parent_properties, parent_properties_custom
        if has_parent then
            parent_properties = self.parent:getProperties()
            parent_properties_custom = parent_properties.Custom
        end

        -- Handles custom size.
        if _properties.Custom.Size then
            -- Early check to handle safety.
            assert(_properties.Custom.Position ~= nil, "To set custom size, there must be also a custom position")

            local _data = _properties.Custom.Size
            local X, Y

            if has_parent then
                -- Early check to handle safety.
                assert(parent_properties_custom ~= nil and parent_properties_custom.Size ~= nil, "To set custom size with parent, there must be also a custom sized parent")

                local parent_size = parent_properties_custom.Size

                X = _data.X / parent_size.X
                Y = _data.Y / parent_size.Y
            else
                X = _data.X / viewport.X
                Y = _data.Y / viewport.Y
            end

            self.instance.Size = UDim2.fromScale(X, Y)
        end

        -- Handles custom size.
        if _properties.Custom.Position then
            -- Early check to handle safety.
            assert(_properties.Custom.Size ~= nil, "To set custom position, there must be also a custom size")

            local _data = _properties.Custom.Position
            local X, Y
                
            if has_parent then
                -- Early check to handle safety.
                assert(parent_properties_custom ~= nil and parent_properties_custom.Size ~= nil, "To set custom position with parent, there must be also a custom sized parent")

                local parent_size = parent_properties_custom.Size

                if should_calculate_anchor then
                    X = _data.X + (_properties.Custom.Size.X * anchor_point.X)
                    Y = _data.Y + (_properties.Custom.Size.Y * anchor_point.Y)

                    X = X / parent_size.X
                    Y = Y / parent_size.Y
                else
                    X = _data.X / parent_size.X
                    Y = _data.Y / parent_size.Y
                end
            else
                if should_calculate_anchor then
                    X = _data.X + (_properties.Custom.Size.X * anchor_point.X)
                    Y = _data.Y + (_properties.Custom.Size.Y * anchor_point.Y)

                    X = X / viewport.X
                    Y = Y / viewport.Y
                else
                    X = _data.X / viewport.X
                    Y = _data.Y / viewport.Y
                end
            end

            self.instance.Position = UDim2.fromScale(X, Y)
        end

        -- Handles custom font size.
        -- TODO: will add custom font size.
        if _properties.Custom.FontSize then
            -- Early check to handle safety.
            assert(parent_properties_custom ~= nil and parent_properties_custom.Size ~= nil, "To set custom font size, there must be also a custom sized parent")

            local font_size = _properties.Custom.FontSize
            self.instance.TextTransparency = 1

            -- Sets text size to 1 since we are going to use tricky "UIScale" to scale our font size.
            self.instance.TextSize = 1

            -- Creates UI scale consumer.
            local _consumer = function(_binder)
                -- Waits heartbeat to update viewport size.
                game:GetService("RunService").Heartbeat:Wait()

                -- Calculates font size ratio.
                local font_size_ratio = self.parent:getInstance().AbsoluteSize.X / parent_properties_custom.Size.X

                -- Updates font size with using "UISize" object. (HACKY SOLUTION)
                _binder:getParent():updateProperties({
                    Scale = font_size * font_size_ratio
                })
            end

            -- Adds text scale element.
            local text_scale = self:addElement({
                Name = "TextScale",
                Type = "UIScale",
                Properties = {
                    Scale = font_size * self.parent:getInstance().AbsoluteSize.X / parent_properties_custom.Size.X,
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
                _consumer(text_scale:getEventBinder())
                self.instance.TextTransparency = _properties.TextTransparency or 0
            end)
        end
    end

    return self
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
    assert(_id ~= nil, self:getLogPrefix() .. " id cannot be null")
    return self.elements[_id]
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


-- ENDS
return class