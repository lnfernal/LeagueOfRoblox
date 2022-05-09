local module = {
	A = {
		Name = "Anonymity",
		Desc = "Being anonymous, the guest turns invisible for <duration> seconds. He also gains <percent>% move speed during this effect.",
		MaxLevel = 5,
		duration = {
			Base = 2,
			
		},
		percent = {
			Base = 40,
			AbilityLevel = 10,
		},
	},
	B = {
		Name = "Safe Chat",
		Desc = "The guest says a safe chat, bothering nearby enemies to deal <damage> h4x damage, and slow them by <percent>% for 2 seconds. Each enemy hit also reduces this ability's cooldown by 0.5 seconds, because the guest, of course, gains energy from annoying many people.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			H4x = 0.2,
		},
		percent = {
			Base = 25,
			AbilityLevel = 5,
		},
	},
	C = {
		Name = "Ignorance",
		Desc = "The guest ignores the rules of the League of ROBLOX and thusly he becomes stronger. He gains <buff> H4x, Toughness and Resistance for <duration> seconds.",
		MaxLevel = 5,
		buff = {
			AbilityLevel = 8,
			H4x = .15, 
		},
		duration = {
			Base = 4
		},
	},
	D = {
		Name = "Report Abuse",
		Desc = "No one is safe from a reporting guest. No one. He fires a short-range piercing projectile which stuns each enemy hit for <duration> seconds as well as dealing <damage> h4x damage.",
		MaxLevel = 3,
		duration = {
			Base = 1,
			AbilityLevel = .5,
		},
		damage = {
			Base = 7.5,
			AbilityLevel = 7.5,
			H4x = 0.3,
		},
	}
}
return module
