local module = {
	A = {
		Name = "Self-replicating Code",
		Desc = "ObliviousPanther fires a code bolt which deals <damage> damage to the first target it hits, and then infects that target. After 3 seconds, the target replicates this spell. A target cannot be affected twice by this.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 3,
			H4x = 0.4,
		}
	},
	B = {
		Name = "Syntactic Sight",
		Desc = "ObliviousPanther damages enemies in a line in front of him for <damage> damage.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 4,
			H4x = 0.2,
		},
	},
	C = {
		Name = "Compression Algorithm",
		Desc = "ObliviousPanther fires a bolt which, upon reaching the end of its range or hitting an enemy, deals <damage> damage to targets in an area and draws them to it.",
		MaxLevel = 5,
		damage = {
			Base = 6,
			AbilityLevel = 3,
			H4x = 0.25,
		},
	},
	D = {
		Name = "Data Sweep",
		Desc = "ObliviousPanther deals <damage> damage in an area at the targeted location. This ability has a short cooldown.",
		MaxLevel = 3,
		damage = {
			Base = 2,
			AbilityLevel = 6,
			H4x = 0.3,
		},
	}
}
return module
