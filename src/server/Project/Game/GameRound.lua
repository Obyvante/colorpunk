local class = {}
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.content = {
	[1] = {
		duration = 8,
		money = 10
	},
	[2] = {
		duration = 8,
		money = 15
	},
	[3] = {
		duration = 7,
		money = 20
	},
	[4] = {
		duration = 7,
		money = 25
	},
	[5] = {
		duration = 7,
		money = 30
	},
	[6] = {
		duration = 6,
		money = 35
	},
	[7] = {
		duration = 6,
		money = 40
	},
	[8] = {
		duration = 6,
		money = 45
	},
	[9] = {
		duration = 5,
		money = 50
	},
	[10] = {
		duration = 5,
		money = 100
	},
	[11] = {
		duration = 5,
		money = 110
	},
	[12] = {
		duration = 5,
		money = 120
	},
	[13] = {
		duration = 4,
		money = 130
	},
	[14] = {
		duration = 4,
		money = 140
	},
	[15] = {
		duration = 4,
		money = 150
	},
	[16] = {
		duration = 4,
		money = 175
	},
	[17] = {
		duration = 4,
		money = 200
	},
	[18] = {
		duration = 3,
		money = 225
	},
	[19] = {
		duration = 2,
		money = 250
	},
	[20] = {
		duration = 1,
		money = 1000
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