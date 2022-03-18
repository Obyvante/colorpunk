local class = {}
-- IMPORTS
local ClientPlayer = require(game.ReplicatedStorage.Project.Player.ClientPlayer)
local Library = require(game.ReplicatedStorage.Library.Library)
local TableService = Library.getService("TableService")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.Sounds = {
    9059061304,
    9066349322,
    9066346635,
    9066347601,
    9066345919,
    9094621883,
    9066344525
}

class.Order = #class.Sounds
class.Playing = nil
class.Event = nil

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- METHODS (STARTS)
------------------------

-- Shuffles sounds list.
function class.shuffle()
    class.Sounds = TableService.shuffle(class.Sounds)
    class.Order = 0
end

-- Waits song to be ended.
function class.waitNextTrack()
    class.Event = class.Playing.Ended:Connect(function()
        task.wait(5)
        class.Event:Disconnect()
        class.Event = nil

        class.Playing:Destroy()
        class.Playing = nil
    end)
end

------------------------
-- METHODS (ENDS)
------------------------


------------------------
-- LOOP (STARTS)
------------------------

task.spawn(function()
    while true do
        task.wait(0.5)

        -- If there is a song currently playing, no need to continue.
        if class.Playing ~= nil then
            class.Playing.Volume = ClientPlayer.getSettings().get("MUSIC")
            continue
        end

        -- Shuffles playlist to avoid same musics to play again.
        if class.Order >= #class.Sounds then class.shuffle() end
        class.Order += 1

        -- Sets playing music.
        class.Playing = Instance.new("Sound")
        class.Playing.SoundId = "rbxassetid://" .. class.Sounds[class.Order]
        class.Playing.Parent = game.Workspace
        class.Playing.Volume = 1
        class.Playing:Play()

        -- Waits song to be ended.
        class.waitNextTrack()
    end
end)

------------------------
-- LOOP (ENDS)
------------------------


-- ENDS
return class