local module = {
	A = {
		Name = "Very Wow",
		Desc = "Using a powerful doge-speak known as 'very wow', Doge fires his flawless head at enemies, dealing <damage> damage and applying a 'Doged' effect. If this move is used on a Doged enemy, then the head explodes, spreading the 'Doged' effect and damage to nearby enemies.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 3,
			H4x = 0.25,
		}
	},
	B = {
		Name = "'keep ur hands away from me'",
		Desc = "Doge wants to keep 'ur hands away from' him. He creates an AOE at his location, dealing <damage> damage and giving the 'Doged' effect to all nearby enemies. Enemies that are already 'Doged' are slowed by <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 5,
			H4x = 0.3,
		},
		slow = {
			Base = 30,
			AbilityLevel = 5,
		},
		duration = {
			Base = 2.25,
		}
	},
	C = {
		Name = "'What r you doing'",
		Desc = "Doge wants to know what your doing. That's kinda hard from away, so he charges to your location dealing <damage> damage to you and knocking you airborne. If you happen to be 'Doged', then the cooldown of the move will be drastically decreased.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			H4x = 0.25,
		}
	},
	D = {
		Name = "'so scare'",
		Desc ="Doge scares everyone in front of him. All enemies which are not 'Doged' are slowed by <slow>% for <duration> seconds. However, all 'Doged' enemies are stunned for <duration> seconds.",
		MaxLevel = 3,
		duration = {
			Base = 1.5,
			AbilityLevel = .5,
		},
		slow = {
			Base = 25,
			AbilityLevel = 10,
		}
	}
}
return module
