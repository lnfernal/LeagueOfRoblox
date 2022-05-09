local module = {
	A = {
		Name = "Portal",
		Desc = "FlareBlast creates a portal fluctuation at the targeted location. After a short delay, the fluctation stabilizes and carries nearby enemies to FlareBlast. This journey through his underworld is not very comfortable, and so enemies take <damage> damage and are slowed by 80% for .5 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 2.5,
			H4x = 0.2,
		},
	},
	B = {
		Name = "Breath of Death",
		Desc = "FlareBlast breathes the icy breath of death in a straight line ahead of him. Players hit take <damage> damage and are slowed <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 4,
			H4x = 0.3,
		},
		slow = {
			Base = 25,
			AbilityLevel = 5,
		},
		duration = {
			Base = 3,
		}
	},
	C = {
		Name = "Deep Freeze",
		Desc = "FlareBlast unleashes a frost wave, stunning nearby opponents for <duration> seconds while dealing <damage> damage to them. Frost which freezes enemies returns to FlareBlast, toughening his armor and increasing his Toughness and Resistance by <buff> for <buffDuration> seconds.",
		MaxLevel = 5,
		duration = {
			Base = 1,
			AbilityLevel = 0.1,
		},
		damage = {
			AbilityLevel = 5,
			H4x = 0.225,
		},
		buff = {
			Base = 3,
			AbilityLevel = 3,
			H4x= 0.225,
		},
		buffDuration = {
			Base = 5,
		},
	},
	D = {
		Name = "Death's Blizzard",
		Desc = "For the next <duration> seconds, every second, FlareBlast deals <damage> damage and slows <slow>% nearby enemies.",
		MaxLevel = 3,
		duration = {
			Base = 2,
			AbilityLevel = 1,
		},
		damage = {
			Base = 2,
			AbilityLevel = 2,
			H4x = 0.05,
		},
		slow = {
			Base = 0,
			AbilityLevel = 15,
		}
	}
}
return module
