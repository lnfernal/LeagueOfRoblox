local module = {
	A = {
		Name = "Guitars Are Better Than Trees",
		Desc = "JacksSmirkingRevenge plays a power chord on his guitar, dealing <damage> damage to nearby enemies but healing <heal> health nearby allies. If your allies and yourself are within the field, activating this ability will break any type of CC and will heal you and your allies 50% more.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 3.5,
			H4x = .225,
		},
		heal = {
			Base = 5,
			AbilityLevel = 3.5,
			H4x = 0.225,
		},
	},
	B = {
		Name = "Solo",
		Desc = "JacksSmirkingRevenge plays a solo on his guitar for <duration> seconds, increasing the speed of nearby allies by <speed>% and buffing their Resistance by <buff>.",
		MaxLevel = 5,
		duration = {
			Base = 4.5,
			
		},
		speed = {
			Base = 15,
			AbilityLevel = 5,
			H4x = .02
		},
		buff = {
			Base = 5,
			AbilityLevel = 4,
			H4x = 0.4,
			
		},
	},
	C = {
		Name = "Up To Eleven",
		Desc = "[Innate] POWER! empowers his power chord (Guitars Are Better Than Trees) and can be essential for helping allies in tough situations. [Active] JacksSmirkingRevenge summons the field of POWER! which grants POWER! to allies and himself. Enemies within the field will be slowed by 20% and get <debuff> decreased Skillz and H4x for <duration> seconds.",
		MaxLevel = 5,
		debuff = {
			Base = 12,
			AbilityLevel = 4,
			H4x = 0.4,
		},
		duration = {
			Base = 4
			}, 
		damage = {
			
			AbilityLevel = 5,
			H4x = 0.1,
		  
			
		},
	},
	D = {
		Name = "The B.A.",
		Desc = "The B.A. drops in from orbit and uses his ship to hold airborne enemies at the targeted location for <duration> seconds.",
		MaxLevel = 3,
		duration = {
			Base = .8,
			AbilityLevel = 0.4
		},
		
		--[[damage = {
			Base = 40,
			AbilityLevel = 9,
			H4x = 0.3,
		 }, ]]
	    
	}
}
return module
