local module = {
		A = {
		Name = "Immolation",
		Desc = "Ppshp charges up and summons a blazing blast at targeted location, dealing <damage> damage as well as taking 5% of their maximum health in the area. The damage of this ability increases by 10% based how many enemy champs have been hit. ",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.35,
		},
		
	},
	B = {
		Name = "Wind Blast",
		Desc = "Ppshp throws a ball of wind that explodes on contact, dealing <damage> damage to enemies caught in it and applies a wind force on them. After 1 second, he will spin his body which will create a backdraft around targets with the wind force, pulling nearby enemies around towards wind force targets.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 7.5,
			H4x = 0.4,
		},
		
	},
	C = {
		Name = "Frostbite",
		Desc = "Ppshp shoots an ice wave that pierces through enemies, dealing <damage> damage and adds a chill effect to them. The chill effect bites through their cold heart, reducing their movement speed by <slow>% while dealing <frostbite> tick damage per second for 2.5 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			H4x = 0.3,
		},
		slow = {
			Base = 32.5,
			
		},
		frostbite = {
			Base = 5,
			AbilityLevel = 5,
			H4x = 0.2,
		}
	},
	D = {
		Name = "Elemental Affinity",
		Desc = "[Innate] The next skill you cast has the attributes of the latest element you have, causing a elemental fusion. Ppshp's basic attack changes element depending on which element ability was currently used, giving utility to each elemental basic attack. Fire deals <fire> damage as well as dealing <percentage> maximum health as damage. Ice pierces through targets and deals <ice> damage. Wind deals <wind> damage and creates a mini wind explosion dealing <explosion> H4x damage. Earth deals <earth> damage and spreads into 4 different rocks",
		MaxLevel = 1,
		fire = {
			H4x = 0.35,
		},
		percentage = {			--Numbers are just for show
			Base = 2.5
		},
		ice = {
			H4x = 0.35,
		},
		wind = {
			H4x = 0.4,
		},
		explosion = {
			H4x = 0.1,
		},
		earth = {
			H4x = 0.125,
		},
	}
}
return module
