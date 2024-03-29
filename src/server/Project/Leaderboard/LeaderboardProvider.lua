local class = {}
-- IMPORTS
local Leaderboard = require(script.Parent.Leaderboard)
local Library = require(game.ReplicatedStorage.Library.Library)
local TaskService = Library.getService("TaskService")
local TableService = Library.getService("TableService")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.content = {
    Win = Leaderboard.new("WIN"),
    Donator = Leaderboard.new("ROBUX_SPENT"),
    Money = Leaderboard.new("GOLD_EARNED")
}

class.Locations = {
    Win = {
        Self = game.Workspace.World.Lobby["Top Lists"]["1"].Leaderboard.SurfaceGui.screen.body
    },
    Donator = {
        Self = game.Workspace.World.Lobby["Top Lists"]["2"].Leaderboard.SurfaceGui.screen.body
    },
    Money = {
        Self = game.Workspace.World.Lobby["Top Lists"]["3"].Leaderboard.SurfaceGui.screen.body
    },

    Stand = {
        [1] = game.Workspace.World.Lobby["Rank Stands"]["Rig"]["1"],
        [2] = game.Workspace.World.Lobby["Rank Stands"]["Rig"]["2"],
        [3] = game.Workspace.World.Lobby["Rank Stands"]["Rig"]["3"]
    }
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- METHODS (STARTS)
------------------------

-- Updates rank stands.
function class.updateRankStands()
    task.spawn(function()
        -- Gets winner content.
        local content = TableService.values(class.content.Win:getContent())

        if #content < 3 then return end

        -- Updates leaderboard stands.
        for i = 1, 3, 1 do
            local appearance = game.Players:GetHumanoidDescriptionFromUserId(tonumber(content[i].id))
            class.Locations.Stand[i].Humanoid:ApplyDescription(appearance)
        end
    end)
end

-- Resets leaderboard building.
function class.reset()
    for i = 1, 100, 1 do
        for key, _ in pairs(class.content) do
            class.Locations[key][i] = class.Locations[key].Self["text_" .. string.format("%03d", i)]
            class.Locations[key][i].posision.text.Text = "#" .. i
            class.Locations[key][i].name.text.Text = ""
            class.Locations[key][i].value.text.Text = ""
        end
    end

    for key, _ in pairs(class.content) do
        class.Locations[key][1].posision.text.TextColor3 = Color3.fromRGB(235, 37, 37)
        class.Locations[key][1].name.text.TextColor3 = Color3.fromRGB(235, 37, 37)
        class.Locations[key][1].value.text.TextColor3 = Color3.fromRGB(235, 37, 37)

        class.Locations[key][2].posision.text.TextColor3 = Color3.fromRGB(255, 145, 0)
        class.Locations[key][2].name.text.TextColor3 = Color3.fromRGB(255, 145, 0)
        class.Locations[key][2].value.text.TextColor3 = Color3.fromRGB(255, 145, 0)

        class.Locations[key][3].posision.text.TextColor3 = Color3.fromRGB(157, 255, 0)
        class.Locations[key][3].name.text.TextColor3 = Color3.fromRGB(157, 255, 0)
        class.Locations[key][3].value.text.TextColor3 = Color3.fromRGB(157, 255, 0)
    end
end

-- Writes data to leaderboard building.
-- @param _type Statistic type.
-- @param _position Leaderboard position.
-- @param _info Entry info.
function class.write(_type : string, _position : number, _info : table)
    class.Locations[_type][_position].posision.text.Text = "#" .. _position
    class.Locations[_type][_position].name.text.Text = _info.name
    class.Locations[_type][_position].value.text.Text = _info.score
end

------------------------
-- METHODS (ENDS)
------------------------


------------------------
-- LOOP (STARTS)
------------------------

-- Resets surface guis.
class.reset()

-- Leaderboard loop.
TaskService.createRepeating(90, function(_task)
    for key, value in pairs(class.content) do
        -- Updates leaderboard.
        value:update()
        -- Updates leaderboard buildings.
        for position, data in pairs(value:getContent()) do class.write(key, tonumber(position), data) end
    end

    -- Updates rank stands.
    -- TODO: will open when it's done.
    --class.updateRankStands()
end):run()

------------------------
-- LOOP (ENDS)
------------------------



-- ENDS
return class