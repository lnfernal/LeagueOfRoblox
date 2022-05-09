local module = {
	A = {
		Name = "Psycho Crush",
		Desc = "NeverEnding plans to trick his foes and becomes immobile for 0.625 seconds then releases dark purple explosion that stuns nearby enemies for <stun> seconds and deals <damage> damage. Then affected enemies will be tagged 'Wacky' that lasts for 7 seconds, which is essential to his second ability. The radius of this ability is 14 studs. ",
		MaxLevel = 5,
		stun = {
			Base = 1,
			AbilityLevel = 0.15
		},
		damage = {
			AbilityLevel = 6,
			H4x = 0.275
		},
	},
	B = {
		Name = "SUPPPPER WACKY!",
		Desc = "NeverEnding makes nearby allies go SUPPPPER WACKY! By increasing their speed by <speed>% for 3 seconds, plus this will apply a DoT to nearby enemies dealing <damage> for 2.5 seconds. Hitting enemies who have the tag 'Wacky' will suffer brain damage, dealing true damage and slowing them by 35% for 2.5 seconds.",
		MaxLevel = 5,
		speed = {
			Base = 5,
			AbilityLevel = 4,
			H4x = 0.035
		},
		damage = {
			AbilityLevel = 6,
			H4x = 0.3
		},
		duration = {
			Base = 4
		},
	},
	C = {
		Name = "Replenish",
		Desc = "NeverEnding replenishes nearby allies health by <percentage>% of their missing health and <heal> health, meaning that the lower their health is, the more it heals.",
		MaxLevel = 5,
		heal = {
			Base = 5,
			AbilityLevel = 6.5,
			H4x = 0.25
		},
		percentage = {
			Base = 15,
			
				
		},
	},
	D = {
		Name = "Revival",
		Desc = "NeverEnding shoots a tiny golden projectile that marks his targeted ally with a golden sparkle aura for <duration> seconds. If the marked ally dies then the marked ally is immediately force fielded for 1.5s, their health is set at <percentage>% of their max health, and revived right beside NeverEnding.If the duration of the sparkles is near finished and the ally dies, the ally instead gets 40% of their max health as health and obtains 2.5s of forcefield but does not teleport back to NeverEnding. If NeverEnding misses the projectile, the cooldown is reduced by <cooldownreduction>s.",
		MaxLevel = 3,
		duration = {
			Base = 7,
			AbilityLevel = 1	
		},
		cooldownreduction = {
			Base = 10,
			AbilityLevel = 5	
		},
		percentage = {
			Base = 25,
			AbilityLevel = 5	
		},
	}
}
return module
