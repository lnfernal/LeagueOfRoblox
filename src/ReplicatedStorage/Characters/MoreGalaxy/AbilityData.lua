local module = {
	A = {
		Name = "Scr1pt 3rr0r",
		Desc = "MoreGalaxy character script has a major error causing him to teleport <distance> studs in front of him, dealing <damage> damage to anyone in his path. If he hits someone he injects a virus into him. If the target already has the virus he takes <virusdamage> damage and slowed for <slow>% for 2s and reducing the cooldown of this move by 2.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 5,
			H4x = .25,
		},
		slow = {
			Base = 20,
			AbilityLevel = 2,
		},
		distance = {
			Base = 20,
			AbilityLevel = 2,
		},
		virusdamage = {
			Base = 5,
			H4x = .05,
		},
	},
		B = {
		Name = "1nj3ct0r",
		Desc = "MoreGalaxy dashes, if he hits someone he injects a virus into him dealing <damage> damage + 5% of enemy max health over 2.5 seconds, but if he doesn't hit someone he gains <speed>% speed for 2.5s.After which the virus explodes infecting nearby enemies with it. If the target already has a virus he is stunned for 1.5 seconds ,takes <virusdamage> damage and  cooldown for this move is reduced by 2 for each enemy hit",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 5,
			H4x = .2,
		},
		stun = {
			Base = 0.15,
			AbilityLevel = 0.15,
		},
		distance = {
			Base = 30,
			AbilityLevel = 4,
		},
		virusdamage = {
			Base = 5,
			H4x = .07,
		},
		speed = {
			Base = 30,
			AbilityLevel = 2,
		},
	},
	C = {
		Name = ".d11",
		Desc = "MoreGalaxy shoots 5 .d11 script in front of him, dealing <damage> damage. If the target already has a virus, the target is slown down  by <slow>% for 2s, takes <virusdamage> damage and reduces the cooldown of this ability by 2s for each enemy hit.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 2,
			H4x = .1,
		},
		slow = {
			Base = 0,
			AbilityLevel = 2,
		},
		virusdamage = {
			Base = 1,
			H4x = .02,
		},
	},
	D = {
		Name = "H4ck3rs p0w3r",
		Desc = "MoreGalaxy calls down a strike dealing <damage> damage to any enemy hit in the radius, if the enemy has a virus, they take bonus <virusdamage> damage, slowed by <slow>% for 2s, and the cooldown of this move is reduced by 5",
		MaxLevel = 3,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = .25,
		},
		virusdamage = {
			Base = 5,
			AbilityLevel = 5,
			H4x = .1,
		},
		slow = {
			Base = 10,
			AbilityLevel = 5,
		},
	}
}
return module
