local module = {
	A = {
		Name = "Fire Breath",
		Desc = "NobleDragon spews a fireball which explodes if it hits a target. The explosion deals 5% of hit enemies max health as well as <damage> true damage over 3 seconds and slows <slow>% for 2.5 seconds.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 5,
			Skillz = .15,
		},
		slow = {
			Base = 25,
			AbilityLevel = 3.5,
		},
	},
	B = {
		Name = "Break Ranks",
		Desc = "NobleDragon charges forward in a fiery spin, dealing <damage> damage to them and knocking them aside.",
		MaxLevel = 5,
		damage = {
			Base = 2,
			AbilityLevel = 4,
			Skillz = 0.3,
		},
	},
	C = {
		Name = "Noble Flight",
		Desc = "NobleDragon blasts off from the ground. After a moment in the air, he crashes to the ground at the targeted location, dealing <damage> damage and knocking airborne to enemies he hits. This damage scales with NobleDragon's maximum health.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			Health = 0.05,
			Skillz = 0.2,
		},
	},
	D = {
		Name = "Dragonblend Coffee Chug",
		Desc = "NobleDragon temporarily increases his movement speed by <speed>% and increases his health by <health>% of max health for <duration> seconds. The speed buff only lasts for one quarter of the duration.",
		MaxLevel = 3,
		speed = {
			Base = 1,
			AbilityLevel = 33,
		},
		health = {
			AbilityLevel = 10,
		},
		duration = {
			Base = 15,
		},
	}
}
return module
