local module = {
	A = {
		Name = "Axe Throw",
		Desc = "pspjohn1 throws his axes in sequence, each dealing <damage> damage to the first target hit. If a target has already been hit by an axe, the axe will not stop.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			Skillz = 0.25,
		}
	},
	B = {
		Name = "Axe Spin",
		Desc = "pspjohn1 spins his axes in a circle, dealing <damage> damage to nearby enemies immediately, and <percent>% of their max health over 5 seconds. However, if this ability hits no targets, it grants pspjohn1 a <speed>% speed boost for <duration> seconds. The bleed is only 25% as effective when used on non-players.",
		MaxLevel = 5,
		damage = {
			Base = 7.5,
			AbilityLevel = 2.5,
			Skillz = 0.1,
		},
		speed = {
			Base = 27.5,
			AbilityLevel = 2.5,
		},
		duration = {
			Base = 2.5,
		},
		percent = {
			Base = 7.5,
			AbilityLevel = 2.5,
			
		}
	},
	C = {
		Name = "Regroup",
		Desc = "pspjohn1 calls on his nearby allies to regroup and repel the assault, increasing his and their health regeneration by <regen> for <duration> seconds.",
		MaxLevel = 5,
		regen = {
			Base = 6.25,
			AbilityLevel = 2.5,
			Health = .02,
		},
		duration = {
			Base = 4,
			
		}
	},
	D = {
		Name = "Epic Comeback",
		Desc = "pspjohn1 calls upon his last piece of strength in dire need, increasing his health regen by <regen> for <duration> seconds. This amount is increased by <percent>% for each 1% of health he is missing.",
		MaxLevel = 3,
		regen = {
			Base = 10,
			AbilityLevel = 5,
			Health = .05,
		},
		duration = {
			Base = 2.5,
			AbilityLevel = .5
		},
		percent = {
			AbilityLevel = .25,
		}
	}
}
return module
