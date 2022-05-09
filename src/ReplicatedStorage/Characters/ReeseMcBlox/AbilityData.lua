local module = {
	A = {
		Name = "Moderate",
		Desc = "Reese fires a projectile which deals <damage> damage to and stuns for <duration> seconds the first target it hits.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 5,
			H4x = 0.3,
		},
		duration = {
			Base = 0.5,
			AbilityLevel = 0.3,
		},
	},
	B = {
		Name = "Reorganize",
		Desc = "Reese heals nearby allies for <heal> health.",
		MaxLevel = 5,
		heal = {
			AbilityLevel = 8,
			H4x = 0.4,
		},
	},
	C = {
		Name = "Team Spirit",
		Desc = "Reese increases the speed of nearby allies by <speed>% for <duration> seconds.",
		MaxLevel = 5,
		speed = {
			Base = 12.5,
			AbilityLevel = 3.5,
			H4x = 0.05,
		},
		duration = {
			Base = 3.5,
		},
	},
	D = {
		Name = "Ban",
		Desc = "Reese fires a projectile which explodes, dealing <damage> damage and slowing nearby enemies by <percent>% for <duration> seconds as well as reducing their defense by <shred>% for the duration.",
		MaxLevel = 3,
		percent = {
			Base = 40,
			AbilityLevel = 5
		},
		duration = {
			Base = 3.25,
			AbilityLevel = .25,
		},
		shred = {
			Base = 60,
			AbilityLevel = 5,
			
		},
		damage = {
			Base = 15,
			AbilityLevel = 5,
			H4x = 0.2,
				
		}
	}
}
return module
