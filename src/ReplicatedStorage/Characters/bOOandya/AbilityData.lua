local module = {
	A = {
		Name = "Bonk!",
		Desc = "bOOandya bonks everyone immediately in front of him, dealing <damage> damage and stunning them for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 7.5,
			Skillz = 0.225,
		},
		duration = {
			Base = 0.75,
			AbilityLevel = 0.25,
		}
	},
	B = {
		Name = "Nom Nom Brainz",
		Desc = "bOOandya dashes forward. The first target he hits, he attaches to and noms their brains, dealing <damage> damage and slowing them <slow>% for 2.5 seconds, he noms <bites> time/s each bite taking <duration> seconds to complete. Each bite also heals him for <heal> health.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			Skillz = 0.05
		},
		slow = {
			Base = 60,
			AbilityLevel = 5,
		},
		heal = {
			Health = .02,
		},
		bites = {
			AbilityLevel = 1,	
		},
		duration = {
			Base = 1,
			AbilityLevel = -.15,
		}
	},
	C = {
		Name = "Bad Breath",
		Desc = "bOOandya breathes noxious fumes ahead of him. The bad air puts enemies hit in a bad, bad way, causing their Skillz and H4x to drop by <shred>% for <duration> seconds. The foul fumes also deal <poison>% of b00andya's health as damage.",
		MaxLevel = 5,
		shred = {
			Base = 50,
			
		},
		poison = {
			Base = 5, 
		},
		duration = {
			Base = 2.75,
			AbilityLevel = 0.25,
		},
	},
	D = {
		Name = "Belly Flop!",
		Desc = "bOOandya belly flops onto the targeted location. Where he lands, enemies are knocked airborne for <duration> seconds, as well as taking <damage> damage.",
		MaxLevel = 3,
		duration = {
			Base = 0.5,
			AbilityLevel = 0.3,
		},
		damage = {
			Base = 10,
			AbilityLevel = 17.5,
			Health = 0.09,
		}
	}
}
return module
