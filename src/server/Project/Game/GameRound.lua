local class = {}
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.content = {
    [1] = {
        Duration = 8,
        Money = 10
    },
    [2] = {
        Duration = 8,
        Money = 15
    },
    [3] = {
        Duration = 8,
        Money = 20
    },
    [4] = {
        Duration = 7,
        Money = 25
    },
    [5] = {
        Duration = 7,
        Money = 30
    },
    [6] = {
        Duration = 7,
        Money = 35
    },
    [7] = {
        Duration = 6,
        Money = 40
    },
    [8] = {
        Duration = 6,
        Money = 45
    },
    [9] = {
        Duration = 6,
        Money = 50
    },
    [10] = {
        Duration = 5,
        Money = 55
    },
    [11] = {
        Duration = 5,
        Money = 60
    },
    [12] = {
        Duration = 5,
        Money = 65
    },
    [13] = {
        Duration = 4,
        Money = 70
    },
    [14] = {
        Duration = 4,
        Money = 75
    },
    [15] = {
        Duration = 4,
        Money = 80
    },
    [16] = {
        Duration = 3,
        Money = 85
    },
    [17] = {
        Duration = 3,
        Money = 90
    },
    [18] = {
        Duration = 3,
        Money = 95
    },
    [19] = {
        Duration = 3,
        Money = 100
    },
    [20] = {
        Duration = 3,
        Money = 125
    }
}

------------------------
-- VARIABLES (ENDS)
------------------------

-- Gets round information by round.
-- @param _round Round.
-- @return Round information.
function class.get(_round : number)
    assert(_round ~= nil, "Round cannot be nil")
    return class.content[_round]
end


-- ENDS
return class