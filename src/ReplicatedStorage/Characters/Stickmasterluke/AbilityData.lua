local module = {
	A = {
		Name = "Lightning Storm",
		Desc = "Stickmasterluke calls upon a lightning storm, dealing <damage> damage with each strike on the targeted area for 4 strikes.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 2,
			H4x = 0.2,
		},
	},
	B = {
		Name = "Underground War",
		Desc = "Stickmasterluke burrows underground and causes an earthquake as he tunnels forward, dealing <damage> damage and knocking airborne each enemy he passed beneath.",
		MaxLevel = 5,
		damage = {
			Base = 4,
			AbilityLevel = 4,
			H4x = 0.3,
		},
	},
	C = {
		Name = "Gale Force",
		Desc = "Stickmasterluke hurls a compressed ball of wind. When it reaches the end of its range, it explodes, dealing <damage> damage and pushing back each enemy hit.",
		MaxLevel = 5,
		damage = {
			Base = 6,
			AbilityLevel = 3,
			H4x = 0.3,
		},
	},
	D = {
		Name = "Meteor Strike",
		Desc = "Stickmasterluke summons a huge meteor at a targeted location. It crashes into the ground and deals <damage> damage in an area.",
		MaxLevel = 3,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.6,
		},
	}
}
return module
