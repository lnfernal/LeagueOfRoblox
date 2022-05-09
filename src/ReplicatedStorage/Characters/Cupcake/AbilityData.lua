local module = {
	A = {
		Name = "Spread Fire",
		Desc = "Cupcake fires 3 projectiles in a cone-like pattern. Each deal <damage> damage to the first target they hit. This skill gains damage with each kill that Cupcake gets.",
		MaxLevel = 5,
		damage = {
			Base = 2.5,
			AbilityLevel = 2.5,
			Skillz = 0.175,
			Kills = 5,
		},
	},
	B = {
		Name = "Magnum Round",
		Desc = "Cupcake fires a powerful shot, dealing <damage> damage to and slowing <slow>% for <duration> seconds each target the projectile passes through. The power of the shot pushes Cupcake backwards.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 3.5,
			Skillz = 0.3,
		},
		slow = {
			Base = 3,
			AbilityLevel = 7.5,
		},
		duration = {
			Base = 2.75,
		},
	},
	C = {
		Name = "Muffin Time!",
		Desc = "Cupcake noms a muffin, healing her for <percent>% of her missing health.",
		MaxLevel = 5,
		percent = {
			Base = 20,
			AbilityLevel = 2,
		},
	},
	D = {
		Name = "Slug",
		Desc = "Cupcake fires a heavy-duty round that deals <damage> damage to the first target it hits, as well as stunning them for 0.375 seconds. The duration of the stun increases by <bonus> seconds for each stud that the slug travels.",
		MaxLevel = 3,
		damage = {
			Base = 12.5,
			AbilityLevel = 7.5,
			Skillz = 0.375,
		},
		bonus = {
			Base = 0.005,
			AbilityLevel = .015
			
		}
	}
}
return module
