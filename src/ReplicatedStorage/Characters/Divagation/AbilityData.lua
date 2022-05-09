local module = {
	A = {
		Name = "Compound Interest",
		Desc = "[Innate] Compound Interest is a stack (which lasts 7 seconds) that makes some of Divagation's abilities stronger per stack, giving out more potential in a sustained fight, his basic attacks also refreshes Compound Interest. [Active] Divagation throws 3 robucks in a cone-pattern that deals <damage> damage to all enemies it hits. It then applies a stack of Compound Interest to all enemy players. For each stack of Compound Interest, the robuck deals <bonus> bonus damage.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 2,
			H4x = 0.15,
		},
		bonus = {
			Base = 5,
			AbilityLevel = 1,
			H4x = 0.065,
		}
	},
	B = {
		Name = "Loan",
		Desc = "Divagation throws a moneybag that attaches to a target, slowing them <slow>% for <duration> seconds. After the slow ends, the moneybag explodes on the target, dealing <damage> damage in an area and giving 1 stack of Compound interest to all players.",
		MaxLevel = 5,
		slow = {
			Base = 25,
			AbilityLevel = 5,
		},
		duration = {
			Base = 1.25,
		},
		damage = {
			Base = 5,
			AbilityLevel = 5,
			H4x = 0.3,
		}
	},
	C = {
		Name = "'Capital' Punishment",
		Desc = "Divagation demands punishment for all of his 'business partners', and deals <multiplier> damage for each stack on each nearby enemy.",
		MaxLevel = 5,
		multiplier = {
			Base = 5,
			AbilityLevel = 7.5,
			H4x = .15
		}
	},
	D = {
		Name = "Ponzi Scheme",
		Desc = "Divagation, being the financial genius that he is, creates a ponzi scheme which deals <damage> damage to nearby enemy champions and steals <theft> Tix from them.", 
		MaxLevel = 3,
		theft = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.1,
			
		},
		duration = {
			Base = 1, 
		},	
		damage = {
		    Base = 5,
			AbilityLevel = 8,
			H4x = 0.35,
		
		} 
	}	
}
return module
