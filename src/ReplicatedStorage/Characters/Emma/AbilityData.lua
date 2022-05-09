local module = {
	A = {
		Name = "Tidal Wave",
		Desc = "Emma swamps opponents in a tidal wave of water, stunning them for <duration> seconds and dealing <damage> damage over 2.5 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			H4x = .3,
		},
		duration = {
			Base = .5,
			AbilityLevel = .1,
		},
	},
	B = {
		Name = "Grand Tidal",
		Desc = "Emma summons 4 water balls around her that turn her attacks into a piercing water beam that deal <percent>% of her H4x, if this beam hits, the enemies are encased within a bubble that deal 65% of basic damage. These water balls last for <duration> seconds and last for 4 shots, if the 4 shots are fired,her basic attack will apply bubbles instead.",
		MaxLevel = 5,
		percent = {
			Base = 12.5,
			AbilityLevel = 1,
		},
		duration = {
			Base = 6,
			
		}
	},
	C = {
		Name = "Surf's Up!",
		Desc = "Emma acts like she's surfing and moves forward in a straight line. Enemies who get near her are slowed <percent>% for 2.5 seconds. She also temporarily imbues her basic attacks for 5 seconds with bubbles that explode dealing 75% of basic damage.",
		MaxLevel = 5,
		percent = {
			Base = 20,
			AbilityLevel = 5,
		}
	},
	D = {
		Name = "Sunshine",
		Desc = "Emma brings out the power of the sun and strikes opponents with a beam that deals <damage> damage per second, for 2 seconds. The beam follows your mouse.",
		MaxLevel = 3,
		damage = {
			Base = 5,
			AbilityLevel = 6,
			H4x = .4,
		}
	}
}
return module
