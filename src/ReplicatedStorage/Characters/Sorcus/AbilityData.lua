local module = {
	A = {
		Name = "Piercing Arrow",
		Desc = "Sorcus fires an arrow which deals <damage> damage to targets it passes through. This ability copies Sorcus' basic attack range.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 4,
			Skillz = 0.3,
		},
	},
	B = {
		Name = "Sharpshooting",
		Desc = "Sorcus increases his basic attack range by <range> studs for <duration> seconds. During this time, he cannot hit turrets.",
		MaxLevel = 5,
		range = {
			Base = 4,
			AbilityLevel = 2.5,
		},
		duration = {
			Base = 5,
		},
	},
	C = {
		Name = "Explosive Arrow",
		Desc = "Sorcus fires an exploding arrow to the targeted location, dealing <damage> damage and knocking targets airborne for <duration> seconds. The size of the explosion is <size> studs.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 2.5,
			Skillz = 0.2,
		},
		duration = {
			Base = 0.5,
			AbilityLevel = 0.1,
		},
		size = {
			Base = 12,
			
		}
	},
	D = {
		Name = "Arrow of Redcliff",
		Desc = "Sorcus fires a white-hot arrow which has no range restriction. The arrow strikes the target's vitals, dealing <damage> damage to the first target hit and gains 1.5% extra damage for every 10 studs it travels, meaning that distant targets take more damage.",
		MaxLevel = 3,
		damage = {
			AbilityLevel = 5,
			Skillz = 0.5,
		},
	}
}
return module
