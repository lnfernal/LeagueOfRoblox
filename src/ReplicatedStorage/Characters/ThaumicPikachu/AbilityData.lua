local module = {
	A = {
		Name = "Toxic Concoction",
		Desc = "ThaumicPikachu throws a poisonous potion which explodes upon reaching it's maximum range, it creates a poisonous field which slows by <slow>% for <duration> seconds dealing <damage> over <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.3,
		},
		duration = {
			Base = 2.25
			
		},
		slow = {
			Base = 30,
			AbilityLevel = 3,
		},
	},
	B = {
		Name = "Corrosion Vial",
		Desc = "ThaumicPikachu throws a vial that eats away at the target's defenses by <shred>%, it also create an effect which lowers nearby enemies defenses by half of <shred>% also dealing 5% of their maximum health as true damage. This lasts <duration> seconds.",
		MaxLevel = 5,
		shred = {
			Base = 20,
			AbilityLevel = 3,
			H4x = 0.02,
		},
		duration = {
			Base = 4.5,
			
		},
	},
	C = {
		Name = "Healing Potion",
		Desc = "ThaumicPikachu throws a healing potion at the ground releasing it's healing goodiness, healing allies for <heal> health and buffing defenses by <amount> for <duration> seconds.",
		MaxLevel = 5,
		heal = {
			Base = 9,
			AbilityLevel = 3,
			H4x = 0.3,
		},
		amount = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.2,
		},
		duration = {
			Base = 4.5,
		},
	},
	D = {
		Name = "Mad Chemist",
		Desc = "ThaumicPikachu consumes an unkown vial which grants him <buff>% to all stats, after <duration> seconds, he starts to feel side-effects reducing his stats by <debuff>% for half the duration.",
		MaxLevel = 3,
		buff = {
			Base = 30,
		},
		debuff = {
			Base = 15,
			AbilityLevel = 1,
		},
		duration = {
			Base = 4.5,
			AbilityLevel = 0.5,
		},
	}
}
return module
