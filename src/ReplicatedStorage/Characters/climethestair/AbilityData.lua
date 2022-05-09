local module = {
	A = {
		Name = "Nether shots",
		Desc = "climethestair fires <shots> shots that deal <damage> damage, the bolt obtains <range> range for each skill level.",
		MaxLevel = 5,
		damage = {
			H4xAbilityLevel = 0.005,
			H4x = 0.04,
			Base = 1,
			AbilityLevel = 1
		},
		shots = {
			Base = 5,
			AbilityLevel = 1
		},
		range = {
			Base = -1,
			AbilityLevel = 1
		},
	},
	B = {
		Name = "Blitening Shot",
		Desc = "climethestair fires a shot bolt that deals <damage> damage over 1s and ticks over <ticks> ticks, for each level, the bolt obtains <range> range for each skill level. The bolt has a <chance> chance to apply a crystal which explodes after 2 seconds that deals <damage> * 1.5 damage and stuns nearby enemies by 1.5s.",
		MaxLevel = 5,
		damage = {
			H4xAbilityLevel = 0.005,
			H4x = 0.1,
			Base = 5,
			AbilityLevel = 2.5,
		},
		chance = {
			Base = 70,
			AbilityLevel = 1,
		},
		ticks = {
			Base = 3,
			
		},
		range = {
			Base = -2,
			AbilityLevel = 2
		},
	},
	C = {
		Name = "Nether Bolt",
		Desc = "climethestair fires a fast bolt that deals <damage> damage, for each level, the bolt obtains <range> range.",
		MaxLevel = 7,
		damage = {
			H4xAbilityLevel = 0.015,
			H4x = 0.25,
			Base = 4,
			AbilityLevel = 4
		},
		range = {
			Base = -2,
			AbilityLevel = 2
		},
	},
	D = {
		Name = "Abyssal Gate",
		Desc = "climethestair builds a teleporter in a specified location, the teleporter will teleport any ally who touches it to him. and has a duration of 2 minutes",
		MaxLevel = 1,
	}
}
return module
