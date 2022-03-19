local class = {}
-- IMPORTS
local player = game:GetService("Players").LocalPlayer
-- STARTS


local images = {
    -- GAME INTERFACE
    9038585313,
    9039056428,
    9039056588,
    9039056256,
    9042912452,
    9042912328,
    9042912582,
    9042912152,
    9042912701,
    9039522875,
    9039522723,
    9039522532,
    9039522298,

    -- INFORMATIVE INTERFACE
    9101166641,
    9101165654,
    9101165940,

    -- AGREEMENT INTERFACE
    9045139741,
    9045140032,
    9045140215,

    -- INVENTORY INTERFACE
    9115355868,
    9115359289,
    9115359389,
    9115370284,
    9115355956,
    9115501441,
    9115355201,
    9115356025,
    9115355344,
    9115354880,
    9115355041,
    9115356106
}

local screen = player.PlayerGui:WaitForChild("ScreenGui", 999)
local image_label = screen:WaitForChild("ImageLabel", 999)

for _, asset_id in pairs(images) do
    image_label.Image = "rbxassetid://" .. asset_id
    task.wait(0.001)
end

screen:Destroy()


-- ENDS
return class