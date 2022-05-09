local module = 	{
	A = {
		Name = "Appear",
		Desc = "ChiefJustus appears at the target location in a flash, dealing <damage> damage.",
		MaxLevel = 5,
		damage = {
			Base = 2.5,
			AbilityLevel = 2.5,
			Skillz = 0.225,
			
		}
	},
	B = {
		Name = "Stomp of Justus",
		Desc = "ChiefJustus draws enemies within <range> studs to himself and slows them by <slow>% for <duration> seconds.",
		MaxLevel = 5,
		range = {
			Base = 10.5,
			AbilityLevel = 1.5,
		},
			slow = {
			Base = 25,
			AbilityLevel = 5,
		},
		duration = {
			Base = 1,
			AbilityLevel = .25,
		}
	},
	C = {
		Name = "Fists of Justus",
		Desc = "ChiefJustus deals <damage> damage to nearby enemies.",
		MaxLevel = 5,
		damage = {
			
			AbilityLevel = 7.5,
			Skillz = 0.35,
		}
	},
	D = {
		Name = "For Great Justus",
		Desc = "ChiefJustus increases the H4x and Skillz of nearby allies by <buff> for <duration> seconds.",
		MaxLevel = 3,
		buff = {
			AbilityLevel = 10,
			Skillz = 0.6,
		},
		duration = {
			Base = 3.5,
			AbilityLevel = 0.5,
		},
	}
}
return module
