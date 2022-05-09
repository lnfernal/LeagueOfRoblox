local module = {
	A = {
		Name = "Pentatone",
		Desc = "Resyncable fires five notes in a fan-shaped pattern which deal <damage> damage apiece on contact and slow the first enemy hit by <slow>% for <duration> seconds. In symphony mode, Resyncable gains 4 volleys of shots to fire over the course of 3 seconds. However, each shot does 50% of its normal damage.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 2,
			H4x = 0.1,
		},
		slow = {
			Base = 15,
			
		},
		duration = {
			Base = 1.5
		}
	},
	B = {
		Name = "Staccato",
		Desc = "Resyncable sends a sound wave forward which detonates, dealing <damage> damage to nearby enemies and reducing their toughness and resistance by <debuff> for <duration> seconds. In symphony mode, this move gains a larger enveloping aoe which stuns enemies for 1.25 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 5,
			H4x = 0.225,
		},
		debuff = {
			Base = 5,
			AbilityLevel = 5,
			H4x = 0.3,
		},
		duration = {
			Base = 4.5,
		}
	},
	C = {
		Name = "Accelerando",
		Desc = "Resyncable increases the movement speed of nearby allies by <bonus> for <duration> seconds. In symphony mode, the duration of the speed boost is automatically refreshed once when it runs out.",
		MaxLevel = 5,
		bonus = {
			Base = 5.5,
			AbilityLevel = .9,
		},
		duration = {
			Base = 3,
			
		}
	},
	D = {
		Name = "Symphony",
		Desc = "Resyncable begins to sense the rhythm of his music and enters symphony mode for 5 seconds. During this period, the next ability cast by Resyncable gains enhanced properties. The cooldown of this move is <cooldown> seconds.",
		MaxLevel = 3,
		cooldown = {
			Base = 55,
			AbilityLevel = -5,
		}
	}
}
return module
