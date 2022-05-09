local module = {
	A = {
		Name = "Shield Charge",
		Desc = "DailyBasis charges forward, shield raised, dealing <damage> damage to targets hit. He also increases his toughness by <buff>% for <duration> seconds for each target hit. This bonus is halfed on non-players.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 3.5,
			Toughness = 0.4,
		},
		buff = {
			Base = 15,
			
		},
		duration = {
			Base = 5,
		}
	},
	B = {
		Name = "King of Bronze",
		Desc = "DailyBasis creates a magical field <range> studs in radius which grants his allies a moment of invincibility.",
		MaxLevel = 5,
		range = {
			Base = 12,
			AbilityLevel = 2,
		}
	},
	C = {
		Name = "Shield Bash",
		Desc = "DailyBasis bashes with his shield. He deals <damage> damage as a melee attack and stuns the target for <duration> seconds. Also, he permanently gains 2 Toughness. The bonus is halfed on non-players.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 6,
			Toughness = 0.45,
		},
		duration = {
			Base = 0.625,
			AbilityLevel = 0.125,
		},
	},
	D = {
		Name = "Bell of Bronze",
		Desc = "DailyBasis creates a sound wave with his shield. It travels straight forward, stunning enemies it hits for <duration> seconds.",
		MaxLevel = 3,
		duration = {
			Base = 1.05,
			AbilityLevel = 0.4,
		}
	}
}
return module
