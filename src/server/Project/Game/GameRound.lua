local class = {}
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.content = {
    [1] = {
        Duration = 8,
        Money = 0
    },
    [2] = {
        Duration = 7,
        Money = 10
    },
    [3] = {
        Duration = 6,
        Money = 20
    },
    [4] = {
        Duration = 5,
        Money = 30
    },
    [5] = {
        Duration = 5,
        Money = 40
    },
    [6] = {
        Duration = 5,
        Money = 50
    },
    [7] = {
        Duration = 4,
        Money = 60
    },
    [8] = {
        Duration = 4,
        Money = 80
    },
    [9] = {
        Duration = 4,
        Money = 100
    },
    [10] = {
        Duration = 3,
        Money = 125
    },
    [11] = {
        Duration = 3,
        Money = 150
    },
    [12] = {
        Duration = 2,
        Money = 200
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

-- Calculates total earned money.
-- @param _round Current round.
-- @return Total earned money.
function class.totalEarnedMoney(_round : number, _multiple : number)
    local summary = 0
    for i = 1, math.min(_round, 12), 1 do
        summary += class.content[i].Money * (_multiple or 1)
    end
    return summary
end


-- ENDS
return class