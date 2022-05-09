local module = {
	A = {
		Name = "Admin Abuse",
		Desc = "After a brief self-stun, awesomehfhhr fires a fast projectile that travels <range> studs.  Upon the first enemy champion hit, they are brought to awesomehfhhr's location and slowed by <slow>% for <duration> seconds.",
		MaxLevel = 5,
		slow = {
			Base = 47.5,
			
		},
		duration = {
			Base = 1,
			AbilityLevel = .2,
		},
		range = {
			Base = 40,
			AbilityLevel = 1.5,
		
		},
	},
	B = {
		Name = "Overtime",
		Desc = "awesomehfhhr works into overtime, causing ally champions to gain <heal> health regen as well as 1.5% of their maximum health, while enemies take <damage> damage over time while near him for <duration> seconds.",
		MaxLevel = 5,
		heal = {
			Base = 7.5,
			AbilityLevel = 1.2,
			H4x = .07,
		},
		damage = {
			Base = 5,
			AbilityLevel = 5,
			H4x = .08,
		},
		duration = {
			Base = 5,
			
		},
	},
	C = {
		Name = "Demotion",
		Desc = "awesomehfhhr demotes his enemies, lowering the defenses of the nearest target and all enemies close to this target by <nerf>. If the target is below 50% health, the move will gain a bigger AOE and will further debuff nearby enemies by <nerf2>%. This lasts <duration> seconds.",
		MaxLevel = 5,
		nerf = {
			Base = 5,
			AbilityLevel = 5,
			H4x = .4,
		},
		nerf2 = {
			Base = 20,
			AbilityLevel = 1,
		},
		duration = {
			Base = 4.5,
		
		},
	},
	D = {
		Name = "Commend For Leadership",
		Desc = "awesomehfhhr shows his leadership powers and bring his allies together, granting <bonus>% bonus defenses as well as <bonus2> bonus defenses to nearby allies. This also grants <speedboost>% times 5 bonus speed, while the speed decays by <speedboost>% per second. This ability lasts 5 seconds.",
		MaxLevel = 3,
		bonus = {
			Base = 25,
			AbilityLevel = 5,
		},
		bonus2 = {
			AbilityLevel = 10,
			H4x = .4,
		},
		speedboost = {
			Base = 10,
			H4x = .02,
		},
	},
}
return module
