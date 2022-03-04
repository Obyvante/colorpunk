local class = {}
-- SPRITESHEET FUNCTION TO RUN.
-- play(script.Parent, 2500, 3000, 6, 5, 30, assetId -> 8577311230, 60)
-- IMPORTS
local TweenService = game:GetService("TweenService")
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local InterfaceService = Library.getService("InterfaceService")
local SpritesheetService = Library.getService("SpritesheetService")
local TaskService = Library.getService("TaskService")
local player = game.Players.LocalPlayer
-- STARTS


------------------------
-- METHODS (STARTS)
------------------------

function class.destroy()
    class.schduled_task:cancel()
    InterfaceService.delete("loading")
end

------------------------
-- METHODS (ENDS)
------------------------


------------------------
-- INTERFACES (STARTS)
------------------------

-- Starts warning screen.
function class.startWarning()
    TweenService:Create(class.spritesheet:getInstance(), TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 1
    }):Play()

    TweenService:Create(class.text:getInstance(), TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1
    }):Play()

    task.wait(1)

    class.warning_body = class.frame:addElement({
        Name = "warning_body",
        Type = "Frame",
        Properties = {
            Custom = {
                Position = Vector2.new(315, 599),
                Size = Vector2.new(3210, 962)
            },
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0
        },

        BuildWith = {
            "AspectRatio"
        }
    })

    -- Warning text title.
    class.warning_title = class.warning_body:addElement({
        Name = "warning_title",
        Type = "TextLabel",
        Properties = {
            Custom = {
                Position = Vector2.new(344, 0),
                Size = Vector2.new(2523, 227),
                FontSize = 200
            },
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            
            TextColor3 = Color3.fromRGB(255, 0, 0),
            Font = "DenkOne",
            TextTransparency = 1,
            Text = "WARNING: RISK OF SEIZURE",
        }
    })

    -- Warning text title.
    class.warning_text = class.warning_body:addElement({
        Name = "warning_text",
        Type = "TextLabel",
        Properties = {
            Custom = {
                Position = Vector2.new(0, 312),
                Size = Vector2.new(3210, 650),
                FontSize = 75
            },
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = "DenkOne",
            RichText = true,
            TextTransparency = 1,
            Text =
[[
In this game you will encounter a variety of visual effects (e.g. flashing lights during
braindance sequences) that may provoke seizures or loss of consciousness in a minority
of people. If you or someone in your family has ever displayed symptoms of epilepsy in the
presence of flashing lights, please consult your physician before playing Colorpunk.
If you or someone you know experiences any of the above symptoms while playing, stop
and seek medical attention immediately.
]],
        }
    })


    TweenService:Create(class.warning_title:getInstance(), TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    TweenService:Create(class.warning_text:getInstance(), TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()

    task.wait(9999)

    print("yey!")
end

------------------------
-- INTERFACES (ENDS)
------------------------


------------------------
-- INITIALIZATION (STARTS)
------------------------

-- Creates loading screen.
class.interface = InterfaceService.createScreen("loading", InterfaceService.VIEWPORTS.PC)

-- Black screen.
class.frame = class.interface:addElement({
    Name = "frame",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(0, 0),
            Size = InterfaceService.VIEWPORTS.PC,
        },
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0,
        BorderSizePixel = 0
    }
})


class.body = class.frame:addElement({
    Name = "body",
    Type = "Frame",
    Properties = {
        Custom = {
            Position = Vector2.new(1670, 830),
            Size = Vector2.new(500, 1224)
        },
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    },

    BuildWith = {
        "AspectRatio"
    }
})

-- Running man.
class.spritesheet = class.body:addElement({
    Name = "spritesheet",
    Type = "ImageLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(0, 0),
            Size = Vector2.new(500, 500),
        },
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    }
})

-- Loading text
class.text = class.body:addElement({
    Name = "text",
    Type = "TextLabel",
    Properties = {
        Custom = {
            Position = Vector2.new(0, 997),
            Size = Vector2.new(500, 227),
            FontSize = 120
        },
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = "DenkOne",
        Text = "Loading",
    }
})

-- Enables created interface. (BIND)
class.interface:bind(player.PlayerGui)
-- Deletes old black screen.
player.PlayerGui.loading:Destroy()

-- Plays running man sprite sheet.
SpritesheetService.play(class.spritesheet:getInstance(), 2500, 3000, 6, 5, 30, 8577311230, 60)

-- Creates stage to handle dot.
local stage = -1
-- Creates task to handle dot animation.
class.schduled_task = TaskService.createRepeating(0.5, function(_task)
    -- Increases or resets dot size.
    stage = stage > 3 and 0 or stage + 1

    -- Updates dot text.
    class.text:updateProperties({
        Text = "Loading" .. string.rep(".", stage)
    })
end):run()

task.wait(5)

------------------------
-- INITIALIZATION (ENDS)
------------------------


-- ENDS
return class