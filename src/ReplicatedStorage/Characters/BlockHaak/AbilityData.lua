local module = {
	A = {
		Name = "Disc Launcher",
		Desc = "BlockHaak rapidly fires discs from his disc launcher, firing <shots> shots, each doing <damage> damage to the first enemy they hit.",
		MaxLevel = 7,
		shots = {
			Base = 5,
			AbilityLevel = 1
		},
		damage = {
			Base = 5,
			AbilityLevel = 1,
			Skillz = 0.055,
		},
	},
	B = {
		Name = "Game Jumping",
		Desc = "BlockHaak leaps to a target location, dealing <damage> damage and slowing <slow>% for 1.5 seconds enemies hit. For the next three seconds, he can reactivate this ability to return to his original location.",
		MaxLevel = 5,
		damage = {
			Base = 4,
			AbilityLevel = 4,
			Skillz = 0.25,
		},
		slow = {
			Base = 10,
			AbilityLevel = 5
		}
	},
	C = {
		Name = "Intimidate",
		Desc = "BlockHaak stares down his enemies, causing them to become stunned for <duration> seconds.",
		MaxLevel = 5,
		duration = {
			Base = 0.75,
			AbilityLevel = 0.1
		}
	},
	D = {
		Name = "The Beard",
		Desc = "BlockHaak grows his beard out a little bit, permanently increasing his Skillz by <boost>. The cooldown is decreased by 1.5 per kill (30 second cap).", -- Removed "and increased by 1.5 per death"
		MaxLevel = 1,
		boost = {
			Base = 3
		},
		cooldown = {
			Base = 45,
			Kills = -1.5,
			
		}
	}
}
return module
