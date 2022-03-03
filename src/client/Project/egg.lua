local class = {}

local Library = require(game:GetService("ReplicatedStorage").Library.Library)
local EventService = Library.getService("EventService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local InterfaceService = Library.getService("InterfaceService")


function create(gui : BillboardGui)
    local interface = InterfaceService.get("prompt")
    if interface ~= nil then
        interface:getScreen().Enabled = true
        return
    end

    interface = InterfaceService.create("prompt", gui.AbsoluteSize)

    local body = interface:addElement({
        Name = "body",
        Type = "ImageLabel",
        Properties = {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            Image = "rbxassetid://8995981000"
        }
    })

    interface:bind(gui)
end


ProximityPromptService.PromptTriggered:Connect(function(prompt)
	print("clicked-> ", prompt.Name)
end)

ProximityPromptService.PromptShown:Connect(function(prompt, input)
	create(prompt.Parent.BillboardGui)
end)

return class