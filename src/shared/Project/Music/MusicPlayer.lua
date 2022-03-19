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
    9066337211,
    9066337831,
    9066338273,
    9066339611,
    9066344525,
    9066345919,
    9066346635,
    9066347601,
    9066349322,
    9066351119,
    9079231365,
    9094601386,
    9094603270,
    9094604689,
    9094606507,
    9094609025,
    9094610474,
    9094613849,
    9094615828,
    9094617208,
    9094618920,
    9094621883
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
        if class.Wait then return end

        -- If there is a song currently playing, no need to continue.
        if class.Playing ~= nil then
            class.Playing.Volume = if ClientPlayer.getSettings().get("MUSIC") == 1 then 0.5 else 0
            continue
        end

        -- Shuffles playlist to avoid same musics to play again.
        if class.Order >= #class.Sounds then class.shuffle() end
        class.Order += 1

        class.Wait = true
        while true do
            -- Sets playing music.
            local success, message = pcall(function()
                class.Playing = Instance.new("Sound")
                class.Playing.SoundId = "rbxassetid://" .. class.Sounds[class.Order]
                class.Playing.Parent = game.Workspace
                class.Playing.Volume = 0.5
                class.Playing:Play()
            end)

            -- Handles not succeed musics.
            if not success then
                -- Handles broken playing music.
                if class.Playing then
                    class.Playing:Destroy()
                    class.Playing = nil
                end

                -- Informs user about it.
                warn("Couldn't load music!" .. message)
            else
                class.Wait = nil
                break
            end
        end

        -- Waits song to be ended.
        class.waitNextTrack()
    end
end)

------------------------
-- LOOP (ENDS)
------------------------


-- ENDS
return class