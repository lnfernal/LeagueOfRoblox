local module = {
	A = {
		Name = "Bind",
		Desc = "Davidscookies Binds his target for <duration> seconds and deals <damage> damage over 2.5 seconds. If The Gamer mode is on, once bind is hit, bind will spread among nearby enemies applying the same effects and damages to everyone nearby.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.2
		},
		duration = {
			Base = 0.6,
			AbilityLevel = 0.1,
		}
	},
	B = {
		Name = "Magical Arrow",
		Desc = "Davidscookies shoots a piercing arrow made from magic that pierces dealing <damage> damage and travels up to 44 studs. If The Gamer mode is on, Davidscookies fires 3 arrows that explode on contact dealing <damage> damage.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			H4x = 0.25
		}
	},
	C = {
		Name = "Magic Strike",
		Desc = "Davidscookies coats his arm with magic and strikes his target with a powerful force dealing <damage> damage and slows by <slow>% for 1.5 seconds. If The Gamer mode is on, Davidscookies gains <slow>% movement speed for 2.5 and he strikes his target 3 times dealing <damage>/2 damage and slows them down by <slow>/3 for 1 second.",
		MaxLevel = 5,
		damage = {
			
			AbilityLevel = 7.5,
			H4x = 0.35
		},
		slow = {
			Base = 30,
			AbilityLevel = 2,
		}
	},
	D = {
		Name = "The Gamer",
		Desc = "Davidscookies focuses and obtains a state of mind where he can focus on whatever circumstance he is in granting him bonus <BonusH4x> H4x, <health> health, <regen> regen. These values are estimated to the nearest value. If the ability is toggled, He has the choice to upgrade on of his abilities for 5 secconds.",
		MaxLevel = 3,
		BonusH4x = {
			H4x = 0.1		--Immo these are values to help the players, the real values are on top
		},
		health = {
			Health = 0.1
		},
		regen = {
			HealthRegen = 0.2
		},
		cooldown = {
			Base = 60,
			AbilityLevel = -5
		}
	}
}
return module
