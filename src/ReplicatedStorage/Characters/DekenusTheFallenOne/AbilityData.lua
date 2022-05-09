local module = {
	A = {
		Name = "Gust",
		Desc = "DekenusTheFallenOne blows a gust of air with his wings, dealing <damage> damage and pushing enemies back <push> studs in a line in front of him.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 2.5,
			H4x = 0.3,
		},
		push = {
			Base = 5,
			AbilityLevel = 5,
		}
	},
	B = {
		Name = "Rush",
		Desc = "DekenusTheFallenOne increases his speed by <speed>% and boosts his toughness by <buff> for <duration> seconds. The potency of the buff is increased by 1% per 1% of missing health.",
		MaxLevel = 5,
		speed = {
			Base = 5,
			AbilityLevel = 5,
		},
		buff = {
			Base = 10,
			AbilityLevel = 5,
			H4x = .4,
		},
		duration = {
			Base = 4,
			
		}
	},
	C = {
		Name = "Condemn",
		Desc = "After a brief startup, DekenusTheFallenOne knocks nearby enemies high into the air for 1 second while dealing <damage> damage to them.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 4.5,
			H4x = 0.25,
		}
	},
	D = {
		Name = "Soar",
		Desc = "After a .625 second startup, DekenusTheFallenOne flies to a distant targeted location, and deals <damage> damage to and slows <slow>% for <duration> seconds nearby enemies where he lands.",
		MaxLevel = 3,
		damage = {
			Base = 20,
			AbilityLevel = 6.5,
			H4x = 0.3,
		},
		slow = {
			Base = 25,
			AbilityLevel = 12.5,
		},
		duration = {
			Base = 1.25,
		}
	}
}
return module
