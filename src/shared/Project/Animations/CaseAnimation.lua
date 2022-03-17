local class = {}
-- IMPORTS
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local Library = require(game.ReplicatedStorage.Library.Library)
local TaskService = Library.getService("TaskService")
local AssetLocation = Library.getService("AssetLocation")
local TweenService = game:GetService("TweenService")
-- STARTS


function class.startEggAnimation(_type : string, _name : string, _id : string)
    _G.caseAnimation = true

    -- Creates screen.
    local screen = Instance.new("ScreenGui")
    screen.IgnoreGuiInset = true
    screen.Parent = game.Players.LocalPlayer.PlayerGui

    -- Creates viewport.
    local viewport = Instance.new("ViewportFrame")
    viewport.AnchorPoint = Vector2.new(0.5, 0.5)
    viewport.Size = UDim2.new(1, 0, 1, 0)
    viewport.Position = UDim2.new(0.5, 0, 0.5, 0)
    viewport.BackgroundColor3 = Color3.new(1, 1, 1)
    viewport.BorderSizePixel = 0
    viewport.BackgroundTransparency = 1
    viewport.Parent = screen

    -- Creates camera.
    local camera = Instance.new("Camera")
    camera.CFrame = CFrame.new(0,0,0)
    camera.Parent = viewport
    viewport.CurrentCamera = camera

    -- Creates case model.
    local case_model = _type == "PREMIUM" and AssetLocation.Models.Egg.Premium:Clone() or AssetLocation.Models.Egg.Normal:Clone()
    case_model.Egg.Position = Vector3.new(0, 0, -50)
    case_model.Neon.Position = Vector3.new(0, 0, -50)
    case_model.Parent = viewport
    
    -- Animates egg model.
    local _tween_info = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(case_model.Egg, _tween_info, {Position = Vector3.new(0, 0, -10)}):Play()
    TweenService:Create(case_model.Neon, _tween_info, {Position = Vector3.new(0, 0, -10)}):Play()

    -- Creates blur effect.
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = game.Lighting

    -- Animates blur.
    TweenService:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 20 }):Play()

    -- Waits.
    task.wait(1)

    local direction = false
    for _ = 1, 3, 1 do
        -- Declares required fields.
        direction = not direction
        local _goal = { Orientation = Vector3.new(0, 0, direction and 25 or -25) }
        _tween_info = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        -- Animates egg model.
        TweenService:Create(case_model.Egg, _tween_info, _goal):Play()
        TweenService:Create(case_model.Neon, _tween_info, _goal):Play()

        -- Waits.
        task.wait(0.3)
    end

    -- Sets egg model orientation.
    case_model.Egg.Orientation = Vector3.new(0, 0, 0)
    case_model.Neon.Orientation = Vector3.new(0, 0, 0)

    -- Declares required fields.
    _tween_info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- Animates egg model.
    TweenService:Create(case_model.Egg, _tween_info, { Position = Vector3.new(0, 0, -80) }):Play()
    TweenService:Create(case_model.Neon, _tween_info, { Position = Vector3.new(0, 0, -80) }):Play()

    -- Waits
    task.wait(0.2)

    -- Declares required fields.
    _tween_info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- Animates egg model.
    TweenService:Create(case_model.Egg, _tween_info, { Position = Vector3.new(0, 0, -10) }):Play()
    TweenService:Create(case_model.Neon, _tween_info, { Position = Vector3.new(0, 0, -10) }):Play()

    -- Waits
    task.wait(0.3)

    -- Sets viewport background to more opaque.
    viewport.BackgroundTransparency = 0.3
    -- Animates viewport opaque.
    TweenService:Create(viewport, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()

    -- Destorys egg model.
    case_model:Destroy()

    -- Creates pet model.
    local model_pet = AssetLocation.Models.Pets[tostring(_id)]:Clone()
    model_pet.Position = Vector3.new(0, 0, -50)
    model_pet.Parent = viewport

    -- Animates pet model.
    TweenService:Create(
        model_pet,
        TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Position = Vector3.new(0, 0, -10) }
    ):Play()

    -- Sets pet mode transparenct.
    model_pet.Transparency = 0

    -- Creates pet name text.
    local text = Instance.new("TextLabel")
    text.AnchorPoint = Vector2.new(0.5, 0.5)
    text.Position = UDim2.new(0.5, 0, 0.85, 0)
    text.Text = _name
    text.TextColor3 = Color3.fromRGB(0, 255, 255)
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.TextSize = 50
    text.Font = "DenkOne"
    text.Parent = viewport

    -- Declares required fields.
    local Y_axis_rotation = 45
    local duration = 0

    -- Handles animation with repeating task
    TaskService.createRepeating(0.01, function(_task)
        -- Increasment.
        Y_axis_rotation += 2
        duration += 0.01

        -- Safety check.
        if Y_axis_rotation >= 180 then Y_axis_rotation = -180 end

        -- Handles timer.
        if duration >= 3 then
            -- Destroying all instances.
            screen:Destroy()
            blur:Destroy()
            screen = nil
            blur = nil
            -- Cancels task.
            _task:cancel()

            _G.caseAnimation = nil
            return
        end

        -- Sets pet model orientation to create an animation.
        model_pet.Orientation = Vector3.new(model_pet.Orientation.X, Y_axis_rotation, model_pet.Orientation.Z)
    end):run()
end


-- ENDS
return class