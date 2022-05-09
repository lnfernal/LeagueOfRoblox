local module = {
	A = {
		Name = "Hat Trick",
		Desc = "Ozzypig throws out his hat, which deals <damage> damage to enemies it passes through. Once the hat reaches the end of its range, it returns to Ozzypig, dealing damage on the way back.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 3,
			H4x = 0.15,
		},
	},
	B = {
		Name = "In the Hat",
		Desc = "Ozzypig hides under his hat, applying a shield with <buff> defense while becoming immobile for 1 second. The potency of the buff is doubled if Ozzy is below 50% health. After that, an explosion emnates from Ozzypig, knocking nearby enemie airborne and dealing <damage> damage.",
		MaxLevel = 5,
		buff = {
			AbilityLevel = 3,
			H4x = .225,
	},
		damage = {
			Base = 2.5,
			AbilityLevel = 2.5,
			H4x = 0.175
		},
	},
	C = {
		Name = "Bowties are Cruel",
		Desc = "Ozzypig hurls his bowtie, dealing <damage> damage and stunning for <duration> seconds to the first target hit.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			H4x = 0.45,
		},
		duration = {
			Base = 0.8,
			AbilityLevel = 0.1,
		},
	},
	D = {
		Name = "Hi There!",
		Desc = "Ozzypig blinks to a target location and gains <buff> H4x for <duration> seconds. If an enemy is near where he appears, the cooldown of this ability is reduced by half.",
		MaxLevel = 3,
		buff = {
			AbilityLevel = 10,
			H4x = 0.3,
		},
		duration = {
			AbilityLevel = 1.25,
		}
	}
}
return module
