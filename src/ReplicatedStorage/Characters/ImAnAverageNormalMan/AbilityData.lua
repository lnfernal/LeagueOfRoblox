local module = {

	A = {
		Name = "Slide",
		Desc = "ImAnAverageNormalMan takes off in a sprint, gaining <percent>% bonus movespeed for 1.5 seconds. After which he does a sliding kick dealing <damage> damage and slowing them down by <slow>% for 2.5s",
		MaxLevel = 5,
		percent = {
			Base = 25,
			AbilityLevel = 5,
		},
		slow = {
			Base = 30,
			AbilityLevel = 2,
		},
		damage = {
			AbilityLevel = 4,
			Skillz = .3,
		},
	},
	B = {
		Name = "Kick",
		Desc = "ImAnAverageNormalMan kicks his opponents, dealing <damage> damage and knocking them back <knockback> studs.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 4,
			Skillz = .3, -- Double kick uses this but x 0.45
		},
		sweepdamage = {
			Base = 5,
			AbilityLevel = 2,
			Skillz = .2,
		},
		knockback = {
			Base = 5,
			AbilityLevel = 2,
		}
	},
	C = {
		Name = "Uppercut",
		Desc = "ImAnAverageNormalMan uppercuts his opponents, dealing <damage> damage and throwing them in the air for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 6,
			Skillz = .4,
		},
		stundamage = {
			AbilityLevel = 5,
			Skillz = .2, --this is for the stun kick, the dancing combo also uses this but the 1st uppercut is *0.7 and the 2 punches are 0.4
		},
		duration = {
			Base = .5,
			AbilityLevel = .1,
		}
	},
	D = {
		Name = "All-out Brawling",
		Desc = "ImAnAverageNormalMan chugs some random fluid and goes into a frenzy. Any attack that lands will gain one of the following effects: 35% bonus true damage, 35% slow for 2.5 seconds, or a 1 second stun. Lasts <duration> seconds, and the cooldown is <duration2> seconds.",
		MaxLevel = 3,
		duration = {
			Base = 3,
			AbilityLevel = 1,
		},
		duration2 = {
			Base = 45,
			AbilityLevel = -5,
		}
	}
}
return module
