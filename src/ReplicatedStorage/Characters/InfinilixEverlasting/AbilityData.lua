local module = {
	A = {
		Name = "Rainbow Time",
		Desc = "InfinilixEverlasting uses his rainbow powers to grant himself <regen> health regen and allies <regen2> health regen for <duration> seconds.",
		MaxLevel = 5,
		regen = {
			Base = 2,
			AbilityLevel = 3,
			H4x = .12
		},
		regen2 = {
			Base = 1.5,
			AbilityLevel = 2.25,
			H4x = .115
		},
		duration = {
			Base = 4,
			
		},
	},
	B = {
		Name = "Taste the Rainbow",
		Desc = "InfinilixEverlasting creates an area in which allies gain <percent>% bonus speed while inside it. Every enemy inside the area feeds the rainbow, and if too many feed the rainbow, the rainbow stuns all enemies who enter the area briefly, but only once. This lasts <duration> seconds.",
		MaxLevel = 5,
		percent = {
			Base = 7.5,
			AbilityLevel = 2.5,
		},
		duration = {
			Base = 2.75,
			AbilityLevel = .25,
		},
	},
	C = {
		Name = "Rainbows Never Die",
		Desc = "InfinilixEverlasting revives his used rainbows and explodes them on nearby enemies, dealing <damage> true damage over 3 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 7.5,
			H4x = .15,
		},
	},
	D = {
		Name = "Double Rainbow",
		Desc = "InfinilixEverlasting pushes themself to the limit and fires two big rainbows foward, dealing <damage> damage per beam and stunning for <duration> seconds against hit enemies.",
		MaxLevel = 3,
		damage = {
			Base = 2.5,
			AbilityLevel = 5,
			H4x = .175,
		},
		duration = {
			Base = 1,
			AbilityLevel = .25,
		},
	},
}
return module
