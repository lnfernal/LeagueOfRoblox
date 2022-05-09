local module = {
	A = {
		Name = "Radioactive Waste",
		Desc = "[Innate] Whenever PlaceRebuilder lands his basic attack or Radioactive Waste on radiation burned enemies, it causes a small explosion, spreading the radiation to nearby enemies around the radiation burned enemy. [Active] PlaceRebuilder gets lock'd and load for an incoming surprise, he fires an arrow with goo around it, making it look like a green projectile, which deals <damage> damage to enemies on impact. This marks ".."\"".."Radiation Burn".."\"".." to enemies which deals <radiationdamage> true damage for 3 seconds. The mark itself will last 5 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			Skillz = 0.2
		},
		radiationdamage = {
			Base = 12,
			AbilityLevel = 3,
			Skillz = 0.15
		},
	},
	B = {
		Name = "Adrenaline Rush",
		Desc = "PlaceRebuilder takes an adrenaline rush that takes him into a new thrilling ride! He is shielded by <shields>% of his health for 3 seconds and gains 25% increased speed for 2 seconds. Afterwards he becomes hyped, he randomly shoots 3 quickarrows, dealing <damage> damage per shot to the first enemy it hits, the final arrow pierces through enemies and applies a bleed dealing 3% of enemies Max Health over 2 seconds.",
		MaxLevel = 5,
		shields = {
			Base = 6,
			AbilityLevel = 2,
		},
		damage = {
			Base = 10,
			AbilityLevel = 7.5,  
			Skillz = .15
		},
	},
	C = {
		Name = "Arrow Airstrike",
		Desc = "PlaceRebuilder fires a bunch of exploding arrows into the air then it rains down to the targeted location, dealing <damage> damage and slows enemies by <slow>% for 2 seconds. Radiation burned enemies will cause an explosion which also spreads radiation to nearby enemies.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			Skillz = 0.15,
		},
		slow = {
			Base = 15,
				
		}
	},
	D = {
		Name = "Cheers!",
		Desc = "After being rescued, PlaceRebuilder will always make sure the zombies will never forget him. PlaceRebuilder shines his teeth which fires a beam in a straight line that deals <damage> damage. Radiation Burned enemies will be stunned for <duration> seconds.",
		MaxLevel = 3,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			Skillz = .4
		},
		duration = {
			Base = 1,
			AbilityLevel = .15,
		},
	}
}
return module
