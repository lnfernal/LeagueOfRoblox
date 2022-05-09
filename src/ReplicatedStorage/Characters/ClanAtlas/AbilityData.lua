local module = {
	A = {
		Name = "Iron Ring",
		Desc = "ClanAtlas places an iron ring with a <diameter>-stud diameter at his feet. If an enemy steps on it, they are slowed by <slow>% for <duration> seconds as well as taking <damage> damage.",
		MaxLevel = 5,
		slow = {
			Base = 25,
			AbilityLevel = 5,
			
		},
		duration = {
			Base = 3,
		},
		damage = {
			Base = 10,
			AbilityLevel = 10,
			H4x = 0.2,
		},
		diameter = {
			Base = 6.75,
			AbilityLevel = .25,
		}
	},
	B = {
		Name = "Across the Atlas",
		Desc = "ClanAtlas dashes <range> studs forward. This ability has a short cooldown, but slows him by <slow>% for <duration> seconds after using it.",
		MaxLevel = 5,
		range = {
			Base = 12,
			AbilityLevel = 6,
		},
		slow = {
			AbilityLevel = 4
		},
		duration = {
			Base = 2.25
		},
	},
	C = {
		Name = "Regenerate",
		Desc = "ClanAtlas casts a regenerative spell at a targeted area, healing allies within for <heal> health and increasing their toughness and resistance by <buff> for <duration> seconds. The heal is increased by 50% and the buff duration is increased by 100% on minions,",
		MaxLevel = 5,
		heal = {
			Base = 3,
			AbilityLevel = 6,
			H4x = 0.25,
			},
		buff = {
			Base = 20,
			AbilityLevel = 5,
			H4x = .2
		},
		duration = {
			Base = 4
		},
	},
	D = {
		Name = "Clan",
		Desc = "ClanAtlas summons an allied minion in an explosion at the targeted point, dealing <damage> damage to enemies caught.",
		MaxLevel = 3,
		damage = {
			AbilityLevel = 10,
			H4x = 0.3,
			},
	}
}
return module
