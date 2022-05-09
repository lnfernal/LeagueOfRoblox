local module = {
	A = {
		Name = "Fired Up!",
		Desc = "Firebrand1 gets himself and his nearby allies fired up for the battle, increasing Skillz and H4x by <buff> for <duration> seconds.",
		MaxLevel = 5,
		buff = {
			Base = 2,
			AbilityLevel = 4,
			H4x = 0.4,
		},
		duration = {
			Base = 5,
		},
	},
	B = {
		Name = "Wildfire",
		Desc = "Firebrand1 creates a blaze at his location, lighting nearby enemies on fire for <duration> seconds and dealing <Initialdamage> damage to them, they then continue to burn for <duration> seconds and suffer <DOTdamage> damage. After 1 second, wildfire is cast at their location. Enemies on fire are not affected by wildfire.",
		MaxLevel = 5,
		Initialdamage = {
			AbilityLevel = 3,
			H4x = 0.1,
		},
		DOTdamage = {
			AbilityLevel = 10,
			H4x = 0.3,
		},
		duration = {
			Base = 2.5,
			AbilityLevel = 0.5,
			
			
		},
	},
	C = {
		Name = "Feed the Fire",
		Desc = "Firebrand1 conflagrates the fires he has set on enemies, dealing <damage> damage to them and stunning them for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 8,
			H4x = 0.25,
		},
		duration = {
			Base = 0.5,
			AbilityLevel = 0.2,
		}
	},
	D = {
		Name = "Enemy's Hearth",
		Desc = "Firebrand1 uses the fire on his enemies to cast healing auras around enemy players for <duration> seconds. These auras increase the regen of allies by <regen> as long as long as they continue to stand in them. Heals from multiple enemies can stack.",
		MaxLevel = 3,
		regen = {
			Base = 40,
			AbilityLevel = 5,
			H4x = 0.5,
			},
		duration = {
			Base = 2.5,
			AbilityLevel = .5
		}
	}
}
return module
