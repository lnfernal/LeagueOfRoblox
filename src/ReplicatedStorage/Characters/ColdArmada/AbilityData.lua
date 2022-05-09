local module = {
	A = {
		Name = "Molotov",
		Desc = "ColdArmada throws a molotov to the targeted location. This will explode on impact, dealing <damage> to nearby enemies. The area it lands in burns, doing extra <damage2> damage to nearby enemies for <duration> seconds. If the Exosuit is equipped, the molotov gains a larger area of damage and burn, a faster projectile speed, and slightly more overall damage.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 2.2,
			Skillz = .11,
		},
		damage2 = {
			AbilityLevel = 3,
			Skillz = .12,
		},
		duration = {
			Base = 3.75,
			AbilityLevel = .25
		}
	},
	B = {
		Name = "EMP Grenade",
		Desc = "ColdArmada throws a EMP grenade which detonates after <duration> seconds. This stuns enemies for <duration2> seconds and increases the cooldown of enemy moves by <duration3> seconds. If the Exosuit is equipped, the grenade is supercharged and as such has a larger explosion radius.",
		MaxLevel = 5,
		duration = {
			Base = 0.6,
			
		},
		duration2 = {
			Base = 1,
			AbilityLevel = .1,
		},
		duration3 = {
			Base = 3.5,
			
		},
		damage = {
			AbilityLevel = 0, --Changed 4.4 to 0
			Skillz = 0, --Changed .22 to 0
		},
		damage2 = {
			AbilityLevel = 0, --Changed 2.2 to 0
			Skillz = 0, --Changed .11 to 0
		}
	},
	C = {
		Name = "Flashbang",
		Desc = "ColdArmada throws a flashbang which explodes after <duration2> seconds, unleashing a blast to blind enemy champions for <duration> seconds while also fragmenting enemies for <damage> damage. If the Exosuit is equipped, the sheer velocity of the grenade shocks enemies into being slowed by 40% for 3 seconds.",
		MaxLevel = 5,
		duration = {
			Base = 1.25,
			AbilityLevel = .15,
		},
		duration2 = {
			Base = 0.6,
			
		},
		damage = {
			AbilityLevel = 2.2,
			Skillz = .11,
		},
	},
	D = {
		Name = "Exosuit",
		Desc = "After a brief startup, ColdArmada equips an exosuit, which grants <percent2>% and <bonus> bonus toughness and resistance as well as <percent>% bonus speed. The exosuit has a mechanical arm built in that causes his grenades to explode instantly and gain a bonus effect. Lasts <duration> seconds.",
		MaxLevel = 3,
		percent = {
			Base = 15,
			AbilityLevel = 5,
		},
		duration = {
			Base = 4,
			AbilityLevel = 2,
		},
		percent2 = {
			Base = 50,
		},
		bonus = {
			Base = 20,
			AbilityLevel = 10,
			Skillz = .25,
		}
	}
}
return module
