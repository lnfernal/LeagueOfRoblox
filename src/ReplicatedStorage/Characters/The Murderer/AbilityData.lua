local module = {
	A = {
		Name = "Murder Mystery",
		Desc = "The Murderer throws his knife straight forward, dealing <damage> damage to the first opponent hit and slowing them <percent>% per 1% of their missing health for <duration> seconds. Lower health enemies are slowed more.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 4,
			Skillz = 0.5,
		},
		percent = {
			AbilityLevel = 0.35
		},
		duration = {
			Base = 2.25,
		},
	},
	B = {
		Name = "You're next!",
		Desc = "The Murderer dashes to the nearest enemy and deals <damage> damage to them. The maximum range of this ability is <range> studs.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 3,
			Skillz = 0.2,
		},
		range = {
			Base = 30,
			AbilityLevel = 2,
		},
	},
	C = {
		Name = "The Mad Murderer",
		Desc = "The Murderer throws 3 knifes in front of him dealing <damage> damage over <duration> seconds, while also dealing 1% bonus damage per 1% of the target's missing health.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 3,
			Skillz = 0.15
		},
		duration = {
			Base = 2.5,
		},
	},
	D = {
		Name = "The Big Reveal",
		Desc = "The Murderer strikes in front of him, instantly killing foes whose health is lower than <percent>%. If their health is greater than <percent>%, they take <damage> true damage instead.",
		MaxLevel = 3,
		damage = {
			AbilityLevel = 7.5,
			Skillz = 0.35
		},
		percent = {
			AbilityLevel = 12.5,
		},
	}
}
return module
