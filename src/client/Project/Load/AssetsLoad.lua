local class = {}
-- IMPORTS
local ContentProvider = game:GetService("ContentProvider")
local player = game:GetService("Players").LocalPlayer
-- STARTS




local Model = Instance.new("SpecialMesh")
Model.MeshId = "rbxassetid://8995275932"
Model.TextureId = "rbxassetid://8995276153"

local Egg = Instance.new("SpecialMesh")
Egg.MeshId = "rbxassetid://76608021"
Egg.TextureId = "rbxassetid://149960205"

print("assets loading...")
ContentProvider:PreloadAsync({Model, Egg})
print("assets loaded")

print("images loading...")
local images = {
    "8992906693",
    "8992907433",
    "8992907836"
}

local screen = player.PlayerGui:WaitForChild("ScreenGui", 999)
local image_label = screen:WaitForChild("ImageLabel", 999)

for index, asset_id in pairs(images) do
    print("aasd -> ", asset_id)
    image_label.Image = "rbxassetid://" .. asset_id
    task.wait(0.001)
end

screen:Destroy()

print("images loaded")


-- ENDS
return class