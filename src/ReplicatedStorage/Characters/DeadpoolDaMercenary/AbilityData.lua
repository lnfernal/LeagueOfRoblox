local module = {
A = {
		Name = "Frenzied Strike",
		Desc = "DeadpoolDaMercenary strikes in front of him, dealing <damage> damage as a melee strike and gaining <speed> speed for <duration> seconds if it strikes a target. This ability has a very low cooldown, but costs <Percentrecoil>% + <recoil> health to use.",
		MaxLevel = 5,
		damage = {
			Base = 2.5,
			AbilityLevel = 2.5,
			Skillz = 0.04,
		},
		speed = {
			AbilityLevel = 1.3,
		},
		duration = {
			Base = 2,
		},
		Percentrecoil = {
			Base = 4,
		},
		recoil = {
			Base = 0,
			AbilityLevel = 2,
		}
	},
	B = {
		Name = "Cyclone Dash",
		Desc = "DeadpoolDaMercenary dashes straight forward. Either at the end of the dash or when he hits an enemy, he stops and deals <damage> damage in an area. If he does hit an enemy, he heals <heal> health.",
		MaxLevel = 5,
		damage = {
			Base = 7.5,
			AbilityLevel = 2.5,
			Skillz = 0.1,
		},
		heal = {
			AbilityLevel = 5,
			Health = 0.04,
		},
	},
	C = {
		Name = "Rampage",
		Desc = "For the next <duration> seconds, DeadpoolDaMercenary's basic attacks heal <heal> health if they hit a target.",
		MaxLevel = 5,
		duration = {
			Base = 3.5,
			AbilityLevel = 0.5
		},
		heal = {
			AbilityLevel = 2,
			Health = 0.025,
		}
	},
	D = {
		Name = "Annihilate",
		Desc = "DeadpoolDaMercenary fires a projectile which pierces enemies. It deals <damage> damage to targets it hits, as well as slowing them <slow>% for <duration> seconds. If it hits at least one target, it heals him for <heal> health. This ability has a short cooldown but its cooldown becomes longer the more it is used in rapid succession.",
		MaxLevel = 3,
		damage = {
			AbilityLevel = 5,
			Skillz = 0.1,
		},
		slow = {
			Base = 20,
			
		},
		duration = {
			Base = 1.5,
		},
		heal = {
			AbilityLevel = 5,
			Health = 0.03,
		}
	}
}
return module
