local module = {
	A = {
		Name = "IP Trace",
		Desc = "1x1x1x1 launches a projectile. If it hits an enemy, 1x1x1x1 teleports to their position as they take <damage> damage and suffer a <slow>% slow for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 2.5,
			AbilityLevel = 7.5,
			H4x = 0.35,
		},
		slow = {
			Base = 35,
			AbilityLevel = 2,
		},
		duration = {
			Base = 2,
			AbilityLevel = 0.1,
		}
	},
	B = {
		Name = "Datamining",
		Desc = "1x1x1x1 send out a shockwave of energy which steals <steal> Toughness and <steal2> Resistance from each enemy hit for <duration> seconds. However, it's only half as effective against non-players.",
		MaxLevel = 5,
		steal = {
			AbilityLevel = 18,
			
		},
		steal2 = {
			AbilityLevel = 18,
			
		},
		duration = {
			Base = 3,
			AbilityLevel = 0.1,
		}
	},
	C = {
		Name = "Crash",
		Desc = "1x1x1x1 stuns nearby enemies for <duration> seconds. He also deals <damage> damage to them.",
		MaxLevel = 5,
		duration = {
			Base = .75,
			AbilityLevel = 0.25,
		},
		damage = {
			Base = 5,
			AbilityLevel = 4.5,
			H4x = 0.3,
		}
	},
	D = {
		Name = "Unbannable",
		Desc = "After a brief 1.25 second startup with a 70% slow, 1x1x1x1 recovers <percent>% of his maximum health.",
		MaxLevel = 3,
		percent = {
			AbilityLevel = 25,
		}
	}
}
return module
