local module = {
	A = {
		Name = "Sweep",
		Desc = "Shedletsky spins in a circle, dealing <damage> damage to nearby enemies.",
		MaxLevel = 5,
		damage = {
			Base = 2.5,
			AbilityLevel = 5.5,
			Skillz = 0.2,
		},
	},
	B = {
		Name = "Impale",
		Desc = "Shedletsky stabs forward, dealing <damage> damage to enemies in front of him and slowing them by 30% for 2 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			Skillz = 0.35,
		  },
		
			 
		},	
		
	
	C = {
		Name = "Lunge",
		Desc = "Shedletsky charges forward, dealing <damage> damage to enemies caught in his path.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 2.5,
			Skillz = 0.15,
		},
	},
	D = {
		Name = "SFOTH",
		Desc = "Shedletsky creates an arena and forces nearby characters to fight in it for <duration> seconds.",
		MaxLevel = 3,
		duration = {
			Base = 5,
			AbilityLevel = 1,
		},
		
	}
}
return module
