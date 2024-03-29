local class = {}
-- IMPORTS
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local SpamService = Library.getService("SpamService")
local EventService = Library.getService("EventService")
local TableService = Library.getService("TableService")
-- EVENTS
local InterfaceActionEvent = EventService.get("Interface.InterfaceAction")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

-- Interface asset ids.
local asset_ids = {
    PANEL = {
        DEFAULT = 9115355868,
        BODY = 9115359289,
        BODY_REMOVE = 9115359389,
        BODY_ACTIVE = 9115370284,
        FOOTER = 9115355956,
        FOOTER_ACTIVE = 9115501441
    },
    ICON = {
        TRAIL = 9115355201,
        FEET = 9115356025,
        PET = 9115355344,

        UNEQUIP = 9115354880,
        TRASH = 9115355041,

        ACCEPT = 9132658393,
    },
    BUTTON = {
        EXIT = 9115356106
    }
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- METHODS (STARTS)
------------------------
------------------------
-- METHODS (ENDS)
------------------------


------------------------
-- BUNDLES (STARTS)
------------------------

function createBodyPanel(_parent, _name : string, _position : Vector2, _status : string)
    -- Declares target asset.
    local target_asset
    if _status == "ACTIVE" then
        target_asset = asset_ids.PANEL.ACTIVE
    elseif _status == "REMOVE" then
        target_asset = asset_ids.PANEL.REMOVE
    else
        target_asset = asset_ids.PANEL.BODY
    end

    -- Creates body pnale.
    return _parent:addElement({
        Name = "panel_" .. _name,
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(250, 251)
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0,

            Image = "rbxassetid://" .. target_asset
        },

        Events = {
            {
                Name = "click",
                Event = "InputBegan",
                Consumer = function(_binder, _event)
                    if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end
                    
                    print(_binder:getParent():getId())
                end
            }
        }
    }):addElement({
        Name = "icon",
        Type = "ImageLabel",
        Properties = {
            Size = UDim2.fromScale(0.77, 0.77),
            Position = UDim2.fromScale(0.5, 0.5),

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 1
        }
    }):getParent()
end

function createFooterPanel(_parent, _name : string, _position : Vector2, _status : string)
    -- Footer panel.
    return _parent:addElement({
        Name = "panel_" .. _name,
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Position = _position,
                Size = Vector2.new(252, 256)
            },

            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 0,

            Image = "rbxassetid://" .. (_status == "ACTIVE" and asset_ids.PANEL.FOOTER_ACTIVE or asset_ids.PANEL.FOOTER)
        }
    })
end

------------------------
-- BUNDLES (ENDS)
------------------------


------------------------
-- AUTOMATION (STARTS)
------------------------

-- Checks spam.
-- @return Should block or not.
function spamCheck()
    return SpamService.handle("inventory", 20, 30)
end

------------------------
-- AUTOMATION (ENDS)
------------------------


-- Creates interface.
local interface = InterfaceService.createScreen("inventory", InterfaceService.VIEWPORTS.PC)

-- Base panel.
local panel = interface:addElement({
    Name = "panel",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(655, 360),
            Size = Vector2.new(2530, 1440)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 0,
        Active = true,
        LayoutOrder = 1,

        Image = "rbxassetid://" .. asset_ids.PANEL.DEFAULT
    },

    BuildWith = {
        "AspectRatio"
    }
})

-- Panel title.
panel:addElement({
    Name = "title",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(737, 66),
            Size = Vector2.new(1025, 122),
            FontSize = 160
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        
        RichText = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "<b>INVENTORY</b>",
    }
})

-- Exit button.
panel:addElement({
    Name = "exit",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(2304, 47),
            Size = Vector2.new(160, 160)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BackgroundTransparency = 1,
        Active = true,

        Image = "rbxassetid://" .. asset_ids.BUTTON.EXIT
    },

    Events = {
        {
            Name = "click",
            Event = "InputBegan",
            Consumer = function(_binder, _event)
                if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end
                interface:unbind()
            end
        }
    }
})

------------------------
-- BODY (STARTS)
------------------------

-- Creates body.
local body = panel:addElement({
    Name = "body",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(90, 318),
            Size = Vector2.new(2330, 747)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    }
})

-- Inventory update function.
interface:addFunction("updateInventory", function(_interface)
    -- Declares content.
    local _content = {}
    local _category = interface:getMetadata():get("category", "TRAIL")

    -- Handles category content.
    if _category == "PET" then
        _content = TableService.values(ClientPlayer.getInventory().getPet().getContent())
    else
        -- Adds trails by its type to content table.
        for _, value in pairs(ClientPlayer.getInventory().getTrail().getContent()) do
            if _category == "TRAIL" and value:getType() == "FOLLOW" then
            table.insert(_content, value)
            elseif _category == "FEET" and value:getType() == "FEET" then
                table.insert(_content, value)
            end
        end
    end

    -- Sort by active.
    table.sort(_content, function(A, B)
        return A:isActive() and not B:isActive()
    end)

    -- Handles category footer icon.
    local trail_footer_panel = _interface:getElementByPath("panel.panel_TRAIL")
    trail_footer_panel:updateProperties({ Image = "rbxassetid://" .. (_category == "TRAIL" and asset_ids.PANEL.FOOTER_ACTIVE or asset_ids.PANEL.FOOTER) })

    local feet_footer_panel = _interface:getElementByPath("panel.panel_FEET")
    feet_footer_panel:updateProperties({ Image = "rbxassetid://" .. (_category == "FEET" and asset_ids.PANEL.FOOTER_ACTIVE or asset_ids.PANEL.FOOTER) })

    local pet_footer_panel = _interface:getElementByPath("panel.panel_PET")
    pet_footer_panel:updateProperties({ Image = "rbxassetid://" .. (_category == "PET" and asset_ids.PANEL.FOOTER_ACTIVE or asset_ids.PANEL.FOOTER) })

    -- Declares required fields.
    local _trash = interface:getMetadata():get("trash", false)
    local _selected = interface:getMetadata():get("selected", {})
    if _trash then
        local delete_footer_panel = _interface:getElementByPath("panel.panel_DELETE")
        local delete_footer_icon = delete_footer_panel:getElement("icon")
        
        if #_selected > 0 then
            delete_footer_panel:updateProperties({ ImageTransparency = 0 })
            delete_footer_icon:updateProperties({ ImageTransparency = 0 })
        else
            delete_footer_panel:updateProperties({ ImageTransparency = 1 })
            delete_footer_icon:updateProperties({ ImageTransparency = 1 })
        end
    end

    local current = 1
    for _ = 1, 3, 1 do
        for _ = 1, 9, 1 do
            -- Declares required fields.
            local _panel = _interface:getElementByPath("panel.body.panel_" .. current)
            local _slot = _panel:getElementByPath("icon")
            local _item = _content[current]
            if not _slot:getMetadata():get("image_color") then _slot:getMetadata():set("image_color", _slot:getInstance().ImageColor3) end
            if not _panel:getMetadata():get("image_color") then _panel:getMetadata():set("image_color", _panel:getInstance().ImageColor3) end

            -- Clears previous events.
            if _panel:getEventBinder():get("click") then _panel:getEventBinder():unbind("click") end

            -- Reset panel morph.
            _panel:updateProperties({
                ImageColor3 = _panel:getMetadata():get("image_color")
            })
            _slot:updateProperties({
                ImageColor3 = _slot:getMetadata():get("image_color")
            })
            -- Resets icon.
            _slot:updateProperties({
                Image = "",
                ImageTransparency = 1
            })

            -- Handles item.
            if _item then
                if _trash and TableService.containsValue(_selected, _item:getUID()) then
                    _slot:updateProperties({
                        ImageColor3 = Color3.fromRGB(255, 0, 0)
                    })
                else
                    -- If item is currently active, change panel morph.
                    if _item:isActive() then
                        _panel:updateProperties({
                            ImageColor3 = Color3.fromRGB(20, 168, 0)
                        })
                    else
                        _slot:updateProperties({
                            ImageColor3 = _slot:getMetadata():get("image_color")
                        })
                        _panel:updateProperties({
                            ImageColor3 = _panel:getMetadata():get("image_color")
                        })
                    end
                end

                -- Updates item icon.
                _slot:updateProperties({
                    Image = "rbxassetid://" .. _item:getAssetId(),
                    ImageTransparency = 0
                })

                -- Events.
                _panel:updateEvents({
                    {
                        Name = "click",
                        Event = "InputBegan",
                        Consumer = function(_binder, _event)
                            if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end

                            -- Declares required fields.
                            _trash = interface:getMetadata():get("trash", false)
                            _selected = interface:getMetadata():get("selected")

                            -- Handles trash mode.
                            if _trash then
                                if _item:isActive() then return end
                                if TableService.containsValue(_selected, _item:getUID()) then
                                    table.remove(_selected, TableService.getKeyByValue(_selected, _item:getUID()))
                                else
                                    table.insert(_selected, _item:getUID())
                                end
                                interface:runFunction("updateInventory")
                                return
                            end
                      
                            -- Handles categories.
                            if _category == "PET" then
                                ClientPlayer.getInventory().getPet().stateRequest({
                                    {
                                        UID = _item:getUID(),
                                        STATE = not _item:isActive()
                                    }
                                })
                            else
                                ClientPlayer.getInventory().getTrail().stateRequest({
                                    {
                                        UID = _item:getUID(),
                                        STATE = not _item:isActive()
                                    }
                                })
                            end
                        end
                    }
                })
            end
            current += 1
        end
    end
end)

local X = 0
local Y = 0
local current = 1

for row = 1, 3, 1 do
    for column = 1, 9, 1 do
        createBodyPanel(body, current, Vector2.new(X + ((column - 1) * 260), Y + ((row - 1) * 248)))
        current += 1
    end
end

------------------------
-- BODY (ENDS)
------------------------


------------------------
-- FOOTER (STARTS)
------------------------

-- Creates delete footer panel.
local delete_footer_panel = createFooterPanel(panel, "DELETE", Vector2.new(114, 1159))
delete_footer_panel:updateProperties({
    ImageTransparency = 1,
    Active = false,
})
-- Icon.
local delete_footer_icon = delete_footer_panel:addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(46, 48),
            Size = Vector2.new(160, 160)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BackgroundTransparency = 1,
        ImageTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.ACCEPT
    }
})
-- Button.
delete_footer_panel:updateEvents({
    {
        Name = "click",
        Event = "InputBegan",
        Consumer = function(_binder, _event)
            if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end
            if delete_footer_panel:getInstance().ImageTransparency == 1 then return end

            -- Declares required fields.
            local _category = interface:getMetadata():get("category")
            local _trash = interface:getMetadata():get("trash", false)
            if not _trash then return end
            local _selected = interface:getMetadata():get("selected")

            if #_selected > 0 then
                interface:runFunction("updateCategory", interface:getMetadata():get("category"))
                
                if _category == "PET" then
                    ClientPlayer.getInventory().getPet().removeRequest(_selected)
                else
                    ClientPlayer.getInventory().getTrail().removeRequest(_selected)
                end
            end
        end
    }
})

-- Creates trail footer panel.
local trail_footer_panel = createFooterPanel(panel, "TRAIL", Vector2.new(863, 1159))
-- Icon.
trail_footer_panel:addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(49, 45),
            Size = Vector2.new(155, 158)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.TRAIL
    }
})
-- Button.
trail_footer_panel:updateEvents({
    {
        Name = "click",
        Event = "InputBegan",
        Consumer = function(_binder, _event)
            if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end
            interface:runFunction("updateCategory", "TRAIL")
        end
    }
})

-- Creates feet footer panel.
local feet_footer_panel = createFooterPanel(panel, "FEET", Vector2.new(1124, 1159))
-- Icon.
feet_footer_panel:addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(37, 36),
            Size = Vector2.new(177, 177)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.FEET
    }
})
-- Button.
feet_footer_panel:updateEvents({
    {
        Name = "click",
        Event = "InputBegan",
        Consumer = function(_binder, _event)
            if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end
            interface:runFunction("updateCategory", "FEET")
        end
    }
})

-- Creates pet footer panel.
local pet_footer_panel = createFooterPanel(panel, "PET", Vector2.new(1384, 1159))
-- Icon.
pet_footer_panel:addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(42, 48),
            Size = Vector2.new(167, 152)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.PET
    }
})
-- Button.
pet_footer_panel:updateEvents({
    {
        Name = "click",
        Event = "InputBegan",
        Consumer = function(_binder, _event)
            if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end
            interface:runFunction("updateCategory", "PET")
        end
    }
})

-- Creates unequip footer panel.
local unequip_footer_panel = createFooterPanel(panel, "UNEQUIP", Vector2.new(1907, 1159))
-- Icon.
unequip_footer_panel:addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(34, 48),
            Size = Vector2.new(184, 153)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.UNEQUIP
    }
})
-- Button.
unequip_footer_panel:updateEvents({
    {
        Name = "click",
        Event = "InputBegan",
        Consumer = function(_binder, _event)
            if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end

            -- Declares content.
            local _content = {}
            local _category = interface:getMetadata():get("category", "TRAIL")

            -- Handles category content.
            if _category == "PET" then
                for _, value in pairs(ClientPlayer.getInventory().getPet().getContent()) do
                    if not value:isActive() then continue end

                    table.insert(_content, {
                        UID = value:getUID(),
                        STATE = false
                    })
                end

                if #_content > 0 then
                    ClientPlayer.getInventory().getPet().stateRequest(_content)
                end
            else
                -- Adds trails by its type to content table.
                for _, value in pairs(ClientPlayer.getInventory().getTrail().getContent()) do
                    if not value:isActive() then continue end

                    if _category == "TRAIL" and value:getType() == "FOLLOW" then
                        table.insert(_content, {
                            UID = value:getUID(),
                            STATE = false
                        })
                    elseif _category == "FEET" and value:getType() == "FEET" then
                        table.insert(_content, {
                            UID = value:getUID(),
                            STATE = false
                        })
                    end
                end

                if #_content > 0 then
                    ClientPlayer.getInventory().getTrail().stateRequest(_content)
                end
            end
        end
    }
})

-- Creates trash footer panel.
local trash_footer_panel = createFooterPanel(panel, "TRASH", Vector2.new(2164, 1159))
-- Icon.
trash_footer_panel:addElement({
    Name = "icon",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(59, 48),
            Size = Vector2.new(134, 152)
        },

        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BackgroundTransparency = 1,

        Image = "rbxassetid://" .. asset_ids.ICON.TRASH
    }
})
-- Button.
trash_footer_panel:updateEvents({
    {
        Name = "click",
        Event = "InputBegan",
        Consumer = function(_binder, _event)
            if not InterfaceService.isClicked(_event.UserInputType, _event.UserInputState) then return end

            local _active = interface:getMetadata():get("trash", false)
            interface:getMetadata():set("trash", not _active)
            interface:getMetadata():set("selected", {})

            if _active then
                -- Updates properties.
                delete_footer_panel:updateProperties({ ImageTransparency = 1 })
                delete_footer_icon:updateProperties({ ImageTransparency = 1 })
                trash_footer_panel:updateProperties({ Image = "rbxassetid://" .. asset_ids.PANEL.FOOTER })

                -- Updates inventory with running function.
                interface:runFunction("updateInventory")
            else
                trash_footer_panel:updateProperties({ Image = "rbxassetid://" .. asset_ids.PANEL.FOOTER_ACTIVE })
            end
        end
    }
})

-- Handles trail category.
interface:addFunction("updateCategory", function(_interface, _category : string)
    -- Sets metadata values.
    interface:getMetadata():set("category", _category)
    interface:getMetadata():set("trash", false)
    interface:getMetadata():set("selected", {})

    -- Updates properties.
    delete_footer_panel:updateProperties({ ImageTransparency = 1 })
    delete_footer_icon:updateProperties({ ImageTransparency = 1 })
    trash_footer_panel:updateProperties({ Image = "rbxassetid://" .. asset_ids.PANEL.FOOTER })

    -- Updates inventory with running function.
    interface:runFunction("updateInventory")
end)

-- Sets default category.
interface:runFunction("updateCategory", "PET")

------------------------
-- FOOTER (ENDS)
------------------------


-- ENDS
return class