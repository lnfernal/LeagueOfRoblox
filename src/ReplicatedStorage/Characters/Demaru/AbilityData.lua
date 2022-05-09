local module = {
	A = {
		Name = "Overheat",
		Desc = "Demaru conjures his flames within his dragon heart, releasing three targeted strikes with a delay between each strike to the targeted position at the time, dealing <damage> damage and slowing <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 4,
			Skillz = .2,
		},
		slow = {
			Base = 10,
			AbilityLevel = 1,
		},
		duration = {
			Base = 2.5,
		},
	},
	B = {
		Name = "Quake",
		Desc = "Demaru flies to the targeted location, dealing <damage> damage and knocking opponents airborne for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 4,
			Skillz = 0.2,
		},
		duration = {
			Base = .7,
			AbilityLevel = .1,
		},
	},
	C = {
		Name = "Blazing Fury",
		Desc = "Demaru creates an aura around them for <duration> seconds, buffing allied speed by <percent>% per pulse as long as they stay in the aura. Enemies standing in this aura will be burned, dealing <damage> damage and losing <percent>% defense per pulse.",
		MaxLevel = 5,
		duration = {
			Base = 1.75,
			AbilityLevel = .25,
		},
		percent = {
			Base = 5,
			AbilityLevel = 1,
		},
		damage = {
			AbilityLevel = 2,
			Skillz = .06,
		}
	},
	D = {
		Name = "Dragon Heart",
		Desc = "After a self stun of 1.25 seconds, Demaru shoots a blue flame that has incredible range, dealing <damage> damage to all enemies hit, while also dealing an extra <damage2> true damage from the intense heat.",
		MaxLevel = 3,
		damage = {
			AbilityLevel = 10,
			Skillz = .35,
		},
		damage2 = {
			AbilityLevel = 10,
			Skillz = .07,
		},
	}
}
return module
