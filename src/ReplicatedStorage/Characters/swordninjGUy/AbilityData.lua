local module = {
	A = {
		Name = "Xross",
		Desc = "swordninjGUy unleashes two violent slashes in a line, dealing <damage> to enemies hit and marking them with an X. After 4 seconds, all marked targets explode, dealing <damage2> damage to all nearby targets.",
		MaxLevel = 5,
		damage = {
			Base = 4,
			AbilityLevel = 3.5,
			Skillz = 0.2,
		},
		damage2 = {
			AbilityLevel = 3,
			Skillz = 0.15,
		},
	},
	B = {
		Name = "Suppress",
		Desc = "swordninjGUy suppresses opponents in a line, dealing <damage> damage and briefly stunning for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 4,
			Skillz = 0.2,
		},
		duration = {
			AbilityLevel = .17,
		},
	},
	C = {
		Name = "Shadow Meld",
		Desc = "swordninjGUy bends shadows around him, cloaking him for <duration> seconds. During this time, he moves <percent>% faster. At the end of the cloak, he strikes out at opponents in front of him, dealing <damage> damage.",
		MaxLevel = 5,
		damage = {
			Skillz = 0.45,
		},
		duration = {
			Base = 2,
			AbilityLevel = 0.15,
		},
		percent = {
			Base = 20,
			AbilityLevel = 3,
		},
	},
	D = {
		Name = "Tenebris Contero",
		Desc = "swordninjGUy charges the nearby dark energy into one spot, and after 1 second, he unleashes the dark energy in front of him, firing 3 pillars of darkness foward that deal <damage> per pillar.",
		MaxLevel = 3,
		damage = {
			Base = 6,
			AbilityLevel = 8,
			Skillz = 0.4,
		},
	}
}
return module

