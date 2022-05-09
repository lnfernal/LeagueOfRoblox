local module = {
	A = {
		Name = "Double Shot",
		Desc = "OstrichSized fires two fast basic attacks and gains <speed>% bonus speed per hit for 3.5 seconds.",
		MaxLevel = 5,
		speed = {
			Base = 5,
			AbilityLevel = 3,
		},
	},
	B = {
		Name = "Sneak Attack",
		Desc = "OstrichSized dashes straight forward and creates a flash which slows nearby enemies by <slow>% for <duration> seconds.",
		MaxLevel = 5,
		slow = {
			Base = 35,
			AbilityLevel = 4,
		},
		duration = {
			Base = 3,
		},
	},
	C = {
		Name = "Disappear",
		Desc = "OstrichSized turns invisible for <duration> seconds.",
		MaxLevel = 5,
		duration = {
			Base = 2,
			AbilityLevel = 0.4,
		},
	},
	D = {
		Name = "Barrage",
		Desc = "OstrichSized spins rapidly in a circle for 5 seconds, shooting projectiles around him in a circle. Each does <damage> damage.",
		MaxLevel = 3,
		damage = {
			AbilityLevel = 2,
			Skillz = 0.1,
		},
	}
}
return module
