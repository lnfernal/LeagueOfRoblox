local module = {
	A = {
		Name = "Lesson",
		Desc = "The Professor teaches a lesson, granting <experience> experience to nearby allies.",
		MaxLevel = 5,
		experience = {
			AbilityLevel = 0.6,
		}
	},
	B = {
		Name = "Corny Joke",
		Desc = "The Professor (as usual) tells a corny joke, dealing <damage> damage over time to nearby enemies and of course they stop and laugh for <duration> seconds. This is functionally equivalent to a stun.",
		MaxLevel = 5,
		duration = {
			Base = 1,
			AbilityLevel = 0.125,
			},
		damage = {
			Base = 10,
			AbilityLevel = 6,
			H4x = 0.2,
		}
	},
	C = {
		Name = "Lab Supervisor",
		Desc = "The Professor is an exceptional lab supervisor capable of getting around... almost as if he teleports. He teleports to the targeted location and surprises nearby enemies into losing <debuff> H4x and Skillz for <duration> seconds.",
		MaxLevel = 5,
		debuff = {
			Base = 3,
			AbilityLevel = 5,
			H4x = 0.6,
		},
		duration = {
			Base = 4.5,
			
		}
	},
	D = {
		Name = "Beach Party Friday!",
		Desc = "If it weren't FINALLY Friday, you'd probably wonder what the heck Beach Party Friday is. Regardless, the Professor gives his allies <speed>% move speed for <duration> seconds.",
		MaxLevel = 3,
		speed = {
			Base= 20,
			AbilityLevel = 20,
			H4x = 0.075,
			},
		duration = {
			Base = 2.5,
			AbilityLevel = .5,
		}
	}
}
return module
