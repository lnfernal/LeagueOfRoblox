local module = {
	A = {
		Name = "Hiring",
		Desc = "BLOXER787 forcefully hires an enemy champion to work for his team, causing them to take <damage> damage over <duration2> seconds. After 2 seconds they are slowed <slow>% for <duration> seconds from the pain. This also marks them with the 'Hired' effect.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 10,
			H4x = .275,
		},
		slow = {
			Base = 27.5,
			AbilityLevel = 2.5,
		},
		duration = {
			Base = 1.25,
			AbilityLevel = .25,
		},
		duration2 = {
			Base = 3.25,
			AbilityLevel = .25,
		},
	},
	B = {
		Name = "Work",
		Desc = "BLOXER787 begins working, causing enemies nearby to start going crazy and take <damage> damage. If an enemy hit is his 'Hired' balancer, they will help him work, stopping them for <duration> seconds while working.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = .3,
		},
		duration = {
			Base = .75,
			AbilityLevel = .15,
		},
	},
	C = {
		Name = "Redesign",
		Desc = "BLOXER787 redesigns a nearby enemy within <range> studs, causing them to take <damage> damage in the process. If the target is 'Hired', the redesign will become a virus, dealing <percent>% extra true damage to the target",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 5,
			H4x = .35,
		},
		percent = {
			Base = 25,
			
		},
		range = {
			Base = 20,
			AbilityLevel = 4,
		},
	},
	D = {
		Name = "Judgement of the Balancer",
		Desc = "BLOXER787 'balances' all enemies in an area, dealing <damage> damage. If the enemy hit is his 'Hired' balancer, they will also get debuffed by <debuff> of their Skillz and H4x for <duration> seconds and take an extra <bonusdamage> damage.",
		MaxLevel = 3,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = .35,
		},
		bonusdamage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = .35,
		},
		
		debuff = {
			AbilityLevel = 15,
			H4x = .4,
		},
		duration = {
			Base = 1,
			AbilityLevel = 1,
		},
	}
}
return module
