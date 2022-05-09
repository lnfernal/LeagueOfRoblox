local module = {
	A = {
		Name = "Spear Throw",
		Desc = "Khanovich throws his spear, dealing <damage> damage to each enemy it passes through. It also slows them <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 7,
			AbilityLevel = 3,
			Skillz = 0.3
		},
		slow = {
			Base = 25,
			AbilityLevel = 2
		},
		duration = {
			Base = 2.25,
			
		}
	},
	B = {
		Name = "Bear Charge",
		Desc = "Khanovich charges forward, dealing <damage> damage to each enemy hit. This ability's damage increases with Khanovich's maximum health.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			Health = 0.05,
		},
	},
	C = {
		Name = "I'M A BEAR!",
		Desc = "Khanovich's trusty steed lets out a battle roar, stunning nearby enemies for anywhere from 1 to 2 seconds. The radius of this ability is <radius> studs.",
		MaxLevel = 5,
		radius = {
			Base = 16,
			AbilityLevel = 0.75
			
		}
	},
	D = {
		Name = "Unstoppable",
		Desc = "Khanovich repeats the last ability he used. This ability's cooldown is <cooldown> seconds.",
		MaxLevel = 3,
		cooldown = {
			Base = 26,
			AbilityLevel = -2
			
		},
	}
}
return module
