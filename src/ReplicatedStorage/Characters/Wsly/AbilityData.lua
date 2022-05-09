local module = {
	A = {
		Name = "Dash",
		Desc = "Wsly dashes, dealing <damage> damage to enemies he passes through. Each time he hits an enemy player, he earns a stack of Death Run, up to a maximum of 10. Hitting an enemy player also severely reduces the move's cooldown.",
		MaxLevel = 5,
		damage = {
			Base = 4,
			AbilityLevel = 4,
			Skillz = 0.2,
		}
	},
	B = {
		Name = "Leap",
		Desc = "Wsly jumps as he would to avoid an obstacle. Upon landing, he deals <damage> damage to surrounding enemies. At 10 stacks, the explosion stuns enemies for 1 second.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			Skillz = 0.4,
		},
	},
	C = {
		Name = "Sprint",
		Desc = "Wsly boosts his speed by <boost> for each stack of Death Run he currently has. This effect lasts <duration> seconds.",
		MaxLevel = 5,
		boost = {
			AbilityLevel = 0.35,
		},
		duration = {
			Base = 1.8,
			AbilityLevel = 0.2,
		}
	},
	D = {
		Name = "Death Run",
		Desc = "For <duration> seconds, Wsly is locked at 10 Death Run stacks. During this time, his basic attacks deal <extraDamage>% more damage.",
		MaxLevel = 3,
		duration = {
			Base = 3,
			AbilityLevel = 1,
		},
		extraDamage = {
			Base = 7.5,
			AbilityLevel = 2.5,
		}
	}
}
return module
