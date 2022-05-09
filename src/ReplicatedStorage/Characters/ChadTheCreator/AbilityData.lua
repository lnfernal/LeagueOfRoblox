local module = {
	A = {
		Name = "Armor Piercing Round",
		Desc = "ChadTheCreator fires a fast-moving magnum armor-piercing round which deals <damage> damage to enemies in a line and reduces their Toughness by <debuff>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 4,
			AbilityLevel = 4,
			Skillz = 0.2,
		},
		debuff = {
			Base = 25,
			AbilityLevel = 5,
		},
		duration = {
			Base = 3.5,
		}
	},
	B = {
		Name = "Fragmentation Grenade",
		Desc = "ChadTheCreator throws a frag grenade to the targeted location. Enemies hit by the ensuing explosion take <damage> damage and are slowed <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 6,
			AbilityLevel = 6,
			Skillz = .3,
		},
		slow = {
			Base = 25,
			AbilityLevel = 5,
		},
		duration = {
			Base = 2.5,
		}
	},
	C = {
		Name = "Headshot",
		Desc = "ChadTheCreator guarantees a headshot on the target nearest the center of a targeted area up to <range> studs away. This headshot deals 150% basic attack damage.",
		MaxLevel = 5,
		range = {
			Base = 46,
			AbilityLevel = 2,
			
		}
	},
	D = {
		Name = "The Flash",
		Desc = "ChadTheCreator unleashes an atomic bomb on the map, causing all enemies to be launched into the air for <duration> seconds.",
		MaxLevel = 3,
		duration = {
			AbilityLevel = 0.35,
		},
	}
}
return module
