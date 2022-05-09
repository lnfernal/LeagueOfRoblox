local module = {
	A = {
		Name = "Gizmo Bomb",
		Desc = "ejob throws out a gizmo bomb which explodes on contact with an enemy or when it reaches the end of its range. It deals <damage> damage to each enemy hit, and also cools down each of his other spells by 0.5 seconds for each enemy hit.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.3,
		},
	},
	B = {
		Name = "Type-4 HealGel Dispersion Device",
		Desc = "ejob deploys a device which flies forward in a line, healing allies it comes near for <heal>.",
		MaxLevel = 5,
		heal = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.45,
		},
	},
	C = {
		Name = "Auto-deploy Emergency Armor System",
		Desc = "ejob applies shields to nearby allies, giving them <buff> protection for <duration> seconds. The potency of the buff increases by <percent>% per 1% of ejob's missing health as well as allies missing health, meaning the lower your health is, the more effective the buff becomes.",
		MaxLevel = 5,
		buff = {
			Base = 7.5,
			AbilityLevel = 2.5,
			H4x = 0.3,
		},
		duration = {
			Base = 4,
		},
		percent = {
			Base = 3
		},
	},
	D = {
		Name = "Hyperion Sky-cannon Barrage",
		Desc = "ejob targets a strike from his Hyperion Sky-cannon, dealing <damage> damage and slowing <slow>% for <duration> seconds in a huge area at the targeted location. This ability can be targeted at a great distance.",
		MaxLevel = 3,
		damage = {
			Base = 5,
			AbilityLevel = 10,
			H4x = 0.35,
		},
		slow = {
			Base = 12.5,
			AbilityLevel = 12.5,
		},
		duration = {
			Base = 3,
		},
	}
}
return module
