local module = {
	A = {
		Name = "Axe Throw",
		Desc = "pspjohn1 throws his axes in front of him, enemies who get hit will take <damage> damage and will be wounded, dealing <bleed> bleed damage for 2 seconds per axe.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			Skillz = 0.3,
		},
		bleed = {
			Base = 15,
			AbilityLevel = 5,
			Skillz = 0.2,
		}
	},
	B = {
		Name = "Axe Spin",
		Desc = "pspjohn1 spins his axes in a circle, dealing <damage> damage and slows 30% to nearby enemies immediately, and <percent>% of their max health over 5 seconds. However, if this ability hits no targets, it grants pspjohn1 a <speed>% speed boost for <duration> seconds. The bleed is only 25% as effective when used on non-players.",
		MaxLevel = 5,
		damage = {
			Base = 7.5,
			AbilityLevel = 5,
			Skillz = 0.2,
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
		Name = "Conquer",
		Desc = "pspjohn1 calls on his nearby allies to regroup and finish the battle once and for all, increasing his and their health regeneration by <regen> for <duration> seconds and causing nearby enemies to bleed by <bleed> damage as well as slowing them down by <slow>% for 2 seconds.",
		MaxLevel = 5,
		regen = {
			Base = 6.25,
			AbilityLevel = 2.5,
			Health = .0315,
		},
		bleed = {
			Base = 15,
			AbilityLevel = 2.5,
			Skillz = .15,
		},
		slow = {
			Base = 15,
			AbilityLevel = 5,
		},
		duration = {
			Base = 4,
			
		}
	},
	D = {
		Name = "Epic Comeback",
		Desc = "pspjohn1 calls upon his last piece of strength in dire need, increasing his health regen by <regen> for <duration> seconds and enemies who are nearby will take <damage> damage, bleeding enemies will take <bleed>% extra damage. This amount is increased by <percent>% for each 1% of health he is missing.",
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
		},
		damage = {
			Base = 15,
			AbilityLevel = 5,
			Skillz = .15,
		},
		bleed = {
			AbilityLevel = 16.67,
		}
	}
}
return module
