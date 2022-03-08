local class = {}
-- IMPORTS
local Library = require(game.ReplicatedStorage.Library.Library)
local EventService = Library.getService("EventService")
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.Requirements = {
    MINIMUM_PLAYER = 1, -- 10
    QUEUE_TIMER = 10 -- 30
}

class.Round = {
    Current = 1,
    Time = 0
}

class.Status = {
    Started = false,
    Paused = false
}

------------------------
-- VARIABLES (ENDS)
------------------------


------------------------
-- INITIALIZATION (STARTS)
------------------------


------------------------
-- INITIALIZATION (ENDS)
------------------------


-- ENDS
return class