local module = {
	A = {
		Name = "Doom Sweep",
		Desc = "PuNiShEr5665 sweeps his scythe in a wide circle, dealing <damage> damage. Costs <recoil>% maximum health to use, but boosts Skillz by <recoil>% for 2 seconds and will never drop Punisher below 1 health. For every enemy hit PuNiShEr5665 gains a 5% movespeed bonus for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			Skillz = 0.5,
		},
		recoil = {
			Base = 5,
			AbilityLevel = 1.5,
		},
		duration = {
			Base = 5,
			AbilityLevel = -0.5,
		},
		
	},
	B = {
		Name = "Soul Siphon",
		Desc = "PuNiShEr5665 draws in the souls of nearby enemies, dealing <damage> damage to them and granting himself <heal> health regen for every enemy hit, a maximum of four. Boosts Skillz by <recoil>% for 2 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 4,
			Skillz = 0.25,
			},
		heal = {
			Base = 4,
			AbilityLevel = 1.5,
			Skillz = 0.06,
		},
		recoil = {
			Base = 3,
			AbilityLevel = 2,
		},
	},
	C = {
		Name = "Cursed Soil",
		Desc = "PuNiShEr5665 creates a cursed area on the ground at a targeted location, dealing 30% of the damage (<damage>) every 0.3 seconds, also slowing by <slow>% for <duration> seconds. Costs <recoil>% maximum health to use, but boosts Skillz by <recoil>% for 2 seconds.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 5,
			Skillz = 0.15,
		},
		slow = {
			Base = 10,
			AbilityLevel = 3,
		},
		duration = {
			Base = 5.5,
			
		},
		recoil = {
			Base = 5,
			AbilityLevel = 1,
		},
	},
	D = {
		Name = "Cut Down to Size",
		Desc = "PuNiShEr5665 leaps to the nearest enemy, heals Punisher by 25% of his maximum health if the target is a player and deals <percent>% of their maximum health as true damage, if the damage dealt is greater than or equal to <threshold> then the cooldown is reduced by <amount> seconds. This means that more damage is dealt when the target has higher health. Costs <recoil>% maximum health to use, but boosts Skillz by <recoil>% for 2 seconds and will never drop Punisher below 1 health.",
		MaxLevel = 3,
		percent = {
			Base = 17.5,
			AbilityLevel = 2.5,
		},
		recoil = {
			Base = 15,
			
		},
		threshold = {
			Base = 500,
			AbilityLevel = -15,
		},
		amount = {
			AbilityLevel = 10,
		},
		
	}
}
return module
