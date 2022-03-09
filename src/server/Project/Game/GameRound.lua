local class = {}
-- STARTS


------------------------
-- VARIABLES (STARTS)
------------------------

class.content = {
	[1] = {
		Duration = 3,
		Money = 10
	},
	[2] = {
		Duration = 3,
		Money = 15
	},
	[3] = {
		Duration = 3,
		Money = 20
	},
	[4] = {
		Duration = 3,
		Money = 25
	},
	[5] = {
		Duration = 3,
		Money = 30
	},
	[6] = {
		Duration = 3,
		Money = 35
	},
	[7] = {
		Duration = 3,
		Money = 40
	},
	[8] = {
		Duration = 3,
		Money = 45
	},
	[9] = {
		Duration = 3,
		Money = 50
	},
	[10] = {
		Duration = 3,
		Money = 100
	},
	[41] = {--TODO: CHANGE
		Duration = 3,
		Money = 110
	},
	[12] = {
		Duration = 3,
		Money = 120
	},
	[13] = {
		Duration = 3,
		Money = 130
	},
	[14] = {
		Duration = 3,
		Money = 140
	},
	[15] = {
		Duration = 3,
		Money = 150
	},
	[16] = {
		Duration = 3,
		Money = 175
	},
	[17] = {
		Duration = 3,
		Money = 200
	},
	[18] = {
		Duration = 3,
		Money = 225
	},
	[19] = {
		Duration = 3,
		Money = 250
	},
	[20] = {
		Duration = 3,
		Money = 1000
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