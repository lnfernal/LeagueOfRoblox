local module = {
		A = {
		Name = "LOL Moon",
		Desc = "speedydude900 deploys a LOL moon to the targeted location. As it travels, it deals <damage> damage to targets nearby. The LOL moon stays there for <duration> seconds, and can be used by speedydude900's other abilities.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 3,
			H4x = 0.3,
		},
		duration = {
			AbilityLevel = 3.6,
		}
	},
	B = {
		Name = "LOL Gravity",
		Desc = "speedydude900 manipulates gravity around his last moon created, allowing create another moon from it and move it <range> studs, slowing all hit by <slow>% for 2.5 seconds.",
		MaxLevel = 5,
		range = {
			Base = 10,
			AbilityLevel = 5,
		},
		slow = {
			Base = 42.5,
			AbilityLevel = 4,
		},
		
	},
	C = {
		Name = "Core Shatter",
		Desc = "speedydude900 shatters his LOL moons for the LOLs. Enemies nearby take <damage> damage but the moons are destroyed.",
		MaxLevel = 5,
		damage = {
			Base = 7.5,
			AbilityLevel = 7.5,
			H4x = 0.5,
		}
	},
	D = {
		Name = "LOL Moonlight",
		Desc = "After a short delay, all enemy players take <damage> damage, regardless of distance.",
		MaxLevel = 3,
		damage = {
			AbilityLevel = 7.5,
			H4x = 0.3,
		}
	}
}
return module
