local module = {
	A = {
		Name = "Gathering Strikes",
		Desc = "Davidii strikes out 3 times, dealing <damage> damage split into 3 to enemies who dare to face him, as well as healing <heal> split into 3 if it hits a target.",
		MaxLevel = 1,
		damage = {
			Skillz = .5,
			 
		},
		heal = {
			Skillz = .35,
		},
	},
	B = {
		Name = "Cleave of Rejuvination",
		Desc = "Davidii spins in a circle, dealing <damage> damage to targets around him. If he hits a non-player target, he heals himself for either <heal2> (based on level) or <heal> (based on maximum health), based on the bigger value. If he hits a player, the damage is multiplied by 1.5x.",
		MaxLevel = 9,
		damage = {
			AbilityLevel = 4.5,
			Skillz = 0.15,
		},
		heal = {
			Health = 0.08,
		},
		heal2 = {
			Level = 8,
		},
	},
	C = {
		Name = "Claim Territory",
		Desc = "Davidii throws his axe forward. It poisons the target, dealing <damage> damage over <duration> seconds. The target is also slowed <slow>% during this poison.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 10,
			Skillz = 0.3,
		},
		duration = {
			Base = 3,
		},
		slow = {
			Base = 25,
			AbilityLevel = 5,
		}
	},
	D = {
		Name = "Ultimate Survivor",
		Desc = "If Davidii drops below <baseline> health, this ability is activated. He gains <duration> seconds of invincibility, gains 15% missing health as health regen over 3 seconds, and his basics will grant <heal> health per hit. The empowered attacks last 5 seconds.",
		MaxLevel = 3,
		duration = {
			Base = 2.5,
			AbilityLevel = .25,
		},
		heal = {
			AbilityLevel = 20,
			Skillz = .1,
		},
		baseline = {
			Health = .2
		}
	},
}
return module
