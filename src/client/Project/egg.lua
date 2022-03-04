local class = {}

local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local EventService = Library.getService("EventService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local InterfaceService = Library.getService("InterfaceService")
local Location = game.Workspace.World.Lobby.Pedestal.Left["1"].Chest.Action


function create()
    local interface = InterfaceService.get("prompt")
    if interface ~= nil then
        return
    end

    interface = InterfaceService.createBillboard("prompt", Vector2.new(680, 775), {
        Adornee = Location,
        Size = UDim2.fromScale(18, 19.68),
        StudsOffset = Vector3.new(0, 12, 0),
        MaxDistance = 100
    })

    local body = interface:addElement({
        Name = "body",
        Type = "ImageLabel",
        Properties = {
            Custom = {
                Size = Vector2.new(680, 775),
                Position = Vector2.new(0, 0)
            },
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            Image = "rbxassetid://9001118772"
        }
    })

    local viewport = body:addElement({
        Name = "box_1",
        Type = "ViewportFrame",
        Properties = {
            Custom = {
                Size = Vector2.new(173, 173),
                Position = Vector2.new(72, 79)
            },
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(233, 213, 100),
            BackgroundTransparency = 1
        }
    })

    local camera = viewport:addElement({
        Name = "camera",
        Type = "Camera",
        Properties = {
            CFrame = CFrame.new(0,0,0)
        }
    })
    viewport:getInstance().CurrentCamera = camera:getInstance()

    local box_model = viewport:addElement({
        Name = "box_1_model",
        Type = "Part",
        Properties = {
            Material = Enum.Material.SmoothPlastic,
            Position = Vector3.new(7, 0, -35),
            Rotation = Vector3.new(0, 120, 0)
        }
    })

    local mesh = box_model:addElement({
        Name = "mesh",
        Type = "SpecialMesh",
        Properties = {
            MeshType = Enum.MeshType.FileMesh,
            MeshId = "rbxassetid://8995098350",
            TextureId = "rbxassetid://8995102969"
        }
    })

    interface:bind(game.Players.LocalPlayer.PlayerGui)
end


ProximityPromptService.PromptTriggered:Connect(function(prompt)
	print("clicked-> ", prompt.Name)
end)

ProximityPromptService.PromptShown:Connect(function(prompt, input)
	create()
end)

return class