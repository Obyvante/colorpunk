-- IMPORTS
local TweenService = game:GetService("TweenService")
local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local SignalService = Library.getService("SignalService")
local TaskService = Library.getService("TaskService")
local InterfaceService = Library.getService("InterfaceService")
local Metadata = Library.getTemplate("Metadata")
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")

require(script.Parent.egg)

local screenGui
local Blur

UserInputService.InputBegan:Connect(function(input)
    
	if input.KeyCode == Enum.KeyCode.Q then
        

        return
    end

	if input.KeyCode == Enum.KeyCode.T then
        local interface = InterfaceService.create("box_open", Vector2.new(3840, 2160))

        local body = interface:addElement({
            Name = "body",
            Type = "ImageLabel",
            Properties = {
                Custom = {
                    Size = Vector2.new(1854, 1323),
                    Position = Vector2.new(992, 417)
                },

                AnchorPoint = Vector2.new(0.5, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,

                Image = "rbxassetid://8992906693"
            },

            BuildWith = {
                "AspectRatio"
            }
        })

        body:addElement({
            Name = "title",
            Type = "TextLabel",
            Properties = {
                Custom = {
                    Size = Vector2.new(1536, 132),
                    Position = Vector2.new(159, 132),
                    FontSize = 120
                },

                AnchorPoint = Vector2.new(0.5, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                
                RichText = true,
                Font = "DenkOne",
                TextColor3 = Color3.fromRGB(30, 255, 218),
                Text = "<b>Are you sure?</b>"
            }
        })

        body:addElement({
            Name = "body_text",
            Type = "TextLabel",
            Properties = {
                Custom = {
                    Size = Vector2.new(1536, 559),
                    Position = Vector2.new(159, 380),
                    FontSize = 100
                },

                AnchorPoint = Vector2.new(0.5, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                
                Text =
[[
Buy and open a <font color="rgb(40, 246, 243)">Premium Egg</font> for 
<font color="rgb(250, 206, 68)">1,000 Golds</font>?
]],
                TextColor3 = Color3.fromRGB(255, 255, 255),
                LineHeight = 1,
                RichText = true,
                Font = "DenkOne"
            }
        })
        
        body:addElement({
            Name = "decline",
            Type = "ImageLabel",
            Properties = {
                Custom = {
                    Size = Vector2.new(593, 204),
                    Position = Vector2.new(320, 875)
                },

                AnchorPoint = Vector2.new(0.5, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,

                Image = "rbxassetid://8992907433"
            }
        }):addElement({
            Name = "text",
            Type = "TextLabel",
            Properties = {
                Custom = {
                    Size = Vector2.new(300, 82),
                    Position = Vector2.new(146, 47),
                    FontSize = 75
                },

                AnchorPoint = Vector2.new(0.5, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                
                Text = "DECLINE",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = "DenkOne"
            }
        })
        
        body:addElement({
            Name = "accept",
            Type = "ImageLabel",
            Properties = {
                Custom = {
                    Size = Vector2.new(593, 204),
                    Position = Vector2.new(942, 875)
                },

                AnchorPoint = Vector2.new(0.5, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,

                Image = "rbxassetid://8992907836"
            }
        }):addElement({
            Name = "text",
            Type = "TextLabel",
            Properties = {
                Custom = {
                    Size = Vector2.new(300, 82),
                    Position = Vector2.new(146, 47),
                    FontSize = 75
                },

                AnchorPoint = Vector2.new(0.5, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                
                Text = "ACCEPT",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = "DenkOne"
            }
        })

        interface:bind(Player.PlayerGui)
        return
    end

	if input.KeyCode == Enum.KeyCode.R then
        if screenGui ~= nil then
            screenGui:Destroy()
            Blur:Destroy()
            screenGui = nil
            Blur = nil
            return
        end

        screenGui = Instance.new("ScreenGui")
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = Player.PlayerGui

        local viewportFrame = Instance.new("ViewportFrame")
        viewportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        viewportFrame.Size = UDim2.new(1, 0, 1, 0)
        viewportFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        viewportFrame.BackgroundColor3 = Color3.new(1, 1, 1)
        viewportFrame.BorderSizePixel = 0
        viewportFrame.BackgroundTransparency = 1
        viewportFrame.Parent = screenGui

        local viewportCamera = Instance.new("Camera")
        viewportCamera.CFrame = CFrame.new(0,0,0)
        viewportCamera.Parent = viewportFrame
        viewportFrame.CurrentCamera = viewportCamera
        
        local part = Instance.new("Part")
        part.Material = Enum.Material.Concrete
        part.Color = Color3.new(1, 0.250980, 0.250980)
        part.Position = Vector3.new(0, 0, -50)
        part.Parent = viewportFrame
        TweenService:Create(part, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = Vector3.new(0, 0, -10)
        }):Play()

        local Mesh = Instance.new("SpecialMesh")
        Mesh.MeshType = Enum.MeshType.FileMesh
        Mesh.MeshId = "http://www.roblox.com/asset/?id=76608021"
        Mesh.TextureId = "http://www.roblox.com/asset/?id=149960205"
        Mesh.VertexColor = Vector3.new(1, 1, 1)
        Mesh.Scale *= 2.5
        Mesh.Parent = part

        Blur = Instance.new("BlurEffect")
        Blur.Size = 0
        Blur.Parent = game.Lighting
        TweenService:Create(Blur, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = 20
        }):Play()

        task.wait(1)

        local direction = false
        for i = 1, 3, 1 do
            direction = not direction

            local cameraGoal = {
                Orientation = Vector3.new(0, 0, direction and 25 or -25)
            }
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(part, tweenInfo, cameraGoal)
            tween:Play()
            task.wait(0.3)
        end
        part.Orientation = Vector3.new(0, 0, 0)

        TweenService:Create(part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = Vector3.new(0, 0, -80)
        }):Play()
        task.wait(0.2)

        TweenService:Create(part, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = Vector3.new(0, 0, -10)
        }):Play()
        task.wait(0.3)

        viewportFrame.BackgroundTransparency = 0.3
        TweenService:Create(viewportFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play()

        Mesh.MeshId = "rbxassetid://8995098350"
        Mesh.TextureId = "rbxassetid://8995102969"
        Mesh.Scale = Vector3.new(0.2, 0.2, 0.2)
        Mesh.Offset = Vector3.new(0, 0, 0)
        part.Transparency = 0

        local text = Instance.new("TextLabel")
        text.AnchorPoint = Vector2.new(0.5, 0.5)
        text.Position = UDim2.new(0.5, 0, 0.85, 0)
        text.Text = "Petito Deniz"
        text.TextColor3 = Color3.fromRGB(0, 255, 255)
        text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        text.TextSize = 50
        text.Font = "DenkOne"
        text.Parent = viewportFrame
        
        local q = 45
        TaskService.createRepeating(0.01, function(_task)
            q += 1
            if q >= 180 then
                q = -180
            end
            part.Orientation = Vector3.new(part.Orientation.X, q, part.Orientation.Z)
        end):run()
	end
end)

SignalService.create("Premium Egg Interact")
print("created 1")