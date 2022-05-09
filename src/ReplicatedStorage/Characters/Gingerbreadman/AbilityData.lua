local module = {
A = {
		Name = "Milk and Cookies",
		Desc = "Gingerbreadman is reminded of the good memories he had, and is healed <percent>% of his maximum health.",
		MaxLevel = 5,
		percent = {
			Base = 15,
			AbilityLevel = 2,
		},
	},
	B = {
		Name = "BaD's Oven!!!",
		Desc = "Gingerbreadman unleashes his inner hate for the place he was born, running forward then dealing <damage> damage and knocking up enemies around him.",
		MaxLevel = 5,
		damage = {
			Base = 4,
			AbilityLevel = 4,
			Skillz = .25,
		},
	},
	C = {
		Name = "Evil Eyes",
		Desc = "Gingerbreadman's evil eyes shoot a beam dealing <damage> true damage and decreases their H4x and Skillz by <debuff>, with a range of <range> studs. This scales with Gingerbreadman's maximum health.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 2.5,
			Health = .05,
		},
		range = {
			Base = 20.5,
			AbilityLevel = 0.5,
		},	
		debuff = {
			Health = .04,
			Base = 5,
			AbilityLevel = 5,
		},
	},
	D = {
		Name = "Gum Drop",
		Desc = "Gingerbreadman drops a giant gummy drop to the targeted location dealing <damage> damage and knocking opponents airborne for <duration> seconds.",
		MaxLevel = 3,
		damage = {
			Base = 9,
			AbilityLevel = 9,
			Skillz = .3
		},
		duration = {
			Base = .75,
			AbilityLevel = 0.2,
		}
	},
}
return module
