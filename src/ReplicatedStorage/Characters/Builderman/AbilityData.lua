local module = {
	A = {
		Name = "Hammer Swing",
		Desc = "Builderman swings his hammer in a circle, dealing <damage> damage to and knocking back <range> units enemies he hits.",
		MaxLevel = 5,
		damage = {
			Base = 4,
			AbilityLevel = 4,
			Skillz = 0.2,
		},
		range = {
			Base = 10,
			AbilityLevel = 2,
		},
	},
	B = {
		Name = "Rebuilderman",
		Desc = "Builderman heals himself for <heal>% of his maximum health and he applies a shield to himself for <toughness>% of his maximum health for <duration> seconds.",
		MaxLevel = 5,
		heal = {
			Base = 5,
			AbilityLevel = 1.5,
		},
		duration = {
			Base = 4,
			AbilityLevel = 0.2, 
			 
		},
		toughness = {
			Base = 10,
			AbilityLevel = 2,
		},
	},
	C = {
		Name = "Hard Hat",
		Desc = "Builderman charges forward helmet first, slamming into enemies. They take <damage> damage and are slowed <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 2.5,
			Skillz = 0.3,
		},
		slow = {
			Base = 10,
			AbilityLevel = 10,
		},
		duration = {
			Base = 2.25,
		},
	},
	D = {
		Name = "Shake the Baseplate",
		Desc = "Builderman deals <damage> damage to nearby enemy champions and knocks them airborne.",
		MaxLevel = 3,
		damage = {
			Base = 15,
			AbilityLevel = 10,
			Skillz = 0.3,
		},
	}
}
return module
