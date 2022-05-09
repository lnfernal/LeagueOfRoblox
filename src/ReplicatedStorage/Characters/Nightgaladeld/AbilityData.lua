local module = {
	A = {
		Name = "Advance",
		Desc = "Nightgaladeld leaps to a target location and deals <damage> damage to nearby enemies when he lands. If he kills an enemy champion, the move's cooldown will be reset.",
		MaxLevel = 5,
		damage = {
			Base = 7.5,
			AbilityLevel = 5,
			Skillz = 0.25,
		},
	},
	B = {
		Name = "Assault",
		Desc = "Nightgaladeld reduces his basic attack cooldown by <percent>% for <duration> seconds.",
		MaxLevel = 5,
		percent = {
			Base = 20,
			AbilityLevel = 3,
		},
		duration = {
			Base = 5,
		},
	},
C = {
		Name = "Battlecry",
		Desc = "Nightgaladeld releases a patriotic battlecry, dealing <damage> damage to nearby enemies and healing himself <heal>. This bonus is doubled on enemy champions.",
		MaxLevel = 5,
		damage = {
			Base = 7.5,
			AbilityLevel = 2.5,
			Skillz = 0.35,
		},
		heal = {
			Base = 5,
			AbilityLevel = 7.5,
			Health = .035,
		},
	},
	D = {
		Name = "Brutality",
		Desc = "Nightgaladeld empowers his basic attacks for <duration> seconds, granting a <slow>% slow for 1.5 seconds to his basic attacks, while also dealing 20% more damage on his basics.",
		MaxLevel = 3,
		slow = {
			Base = 22.5,
		},
		duration = {
			Base = 3,
			AbilityLevel = 1,
		}
	}
}
return module
