local module = {
	A = {
		Name = "Teapot Rain",
		Desc = "Clockwork drops a teapot from the sky, dealing <damage> damage in a small area after a short delay.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 2,
			H4x = 0.25,
		}
	},
	B = {
		Name = "Boil Over",
		Desc = "Clockwork boils over, increasing his H4x by <h4xBuff> and his Speed by <speedBuff> for <duration> seconds.",
		MaxLevel = 5,
		h4xBuff = {
			AbilityLevel = 5,
			H4x = 0.25,
		},
		speedBuff = {
			AbilityLevel = 1
		},
		duration = {
			Base = 2.25,
			AbilityLevel = 0.25,
		}
	},
	C = {
		Name = "Duck",
		Desc = "Calling upon ancient powers beyond understanding, Clockwork pierces his foes with a duck, dealing <damage> damage and slowing <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 2,
			AbilityLevel = 4,
			H4x = 0.2,
		},
		slow = {
			Base = 25,
			AbilityLevel = 5,
		},
		duration = {
			Base = 2,
			AbilityLevel = 0.25,
		}
	},
	D = {
		Name = "Satellite Crash",
		Desc = "Clockwork sacrifices his signature satellite to crash at a nearby targeted area, knocking nearby enemies airborne for .5 seconds, dealing <damage> damage on impact and dealing <damagePerSecond> damage per second for <duration> seconds. Enemies caught within the inner explosion also receive a 40% slow for the entire duration of the move.",
		MaxLevel = 3,
		damage = {
			Base = 10,
			AbilityLevel = 10,
			H4x = 0.3
		},
		duration = {
			Base = 3.8,
			AbilityLevel = .4,
		},
		damagePerSecond = {
			Base = 3,
			AbilityLevel = 3,
			H4x = 0.1,
		}
	}
}
return module
