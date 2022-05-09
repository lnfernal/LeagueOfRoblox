local module = {
	A = {
		Name = "Vortex of Power",
		Desc = "JoelMatGarcia spins repeatedly, dealing <damage> damage per second to nearby enemies for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 3,
			Skillz = 0.5,
		},
		duration = {
			Base = 2.75,
			AbilityLevel = 0.25,
		},
	},
	B = {
		Name = "Bow to Caesar",
		Desc = "JoelMatGarcia demands respect from nearby enemies, slowing them <slow>% for <duration> seconds.",
		MaxLevel = 5,
		slow = {
			Base = 30,
			AbilityLevel = 5
		},
		duration = {
			Base = 2.25,
		},
	},
	C = {
		Name = "Mark of Caesar",
		Desc = "JoelMatGarcia throws a projectile in a line which travels up to <range> studs. When it either hits a target or reaches the end of its range, JoelMatGarcia teleports to its location.",
		MaxLevel = 5,
		range = {
			Base = 27,
			AbilityLevel = 3,
		},
	},
	D = {
		Name = "Requite",
		Desc = "JoelMatGarcia heals nearby allies for <percent>% of their missing health, meaning that allies with less health are healed more.",
		MaxLevel = 3,
		percent = {
			Base = 40,
			AbilityLevel = 2.5,
		},
	}
}
return module
