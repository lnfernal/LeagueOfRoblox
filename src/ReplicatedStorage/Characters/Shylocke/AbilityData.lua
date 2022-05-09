local module = {
	A = {
		Name = "Void Locke",
		Desc = "Shylocke creates a shockwave which slows <slow>% nearby enemies for <duration> seconds as well as dealing <damage> damage.",
		MaxLevel = 5,
		slow = {
			Base = 50,
			AbilityLevel = 4,
		},
		damage = {
			Base = 7.5,
			AbilityLevel = 2.5,
			Skillz = 0.3,
		},
		duration = {
			Base = 1.55,
		},
	},
	B = {
		Name = "Void Blade",
		Desc = "Shylocke strikes in front of him, dealing <damage> damage to enemies hit.",
		MaxLevel = 5,
		damage = {
			Base = 25,
			AbilityLevel = 5,
			Skillz = 0.75,
		},
	},
	C = {
		Name = "Void Breaker",
		Desc = "Shylocke dashes a short distance forward. Enemies hit suffer <damage> damage and have their Toughness reduced by <debuff> for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 7.5,
			AbilityLevel = 2.5,
			Skillz = 0.2,
		},
		debuff = {
			AbilityLevel = 5,
			Skillz = .2
		},
		duration = {
			Base = 3,
		},
	},
	D = {
		Name = "Void Gate",
		Desc = "Shylocke fires a short-range projectile. The targets hit takes damage equal to <percent>% of their missing health, meaning that lower health produces more damage.",
		MaxLevel = 3,
		percent = {
			Base = 37.5,
			AbilityLevel = 12.5,
		},
	}
}
return module
