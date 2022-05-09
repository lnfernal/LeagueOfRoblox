local module = {
		A = {
		Name = "Elemental Blast",
		Desc = "Ppshp summons a elemental blast that damages each enemy caught in the blast and applies the corresponding effects on such. Fire applies <firedamage> + 2%Max Hp as DPS, Ice applies <icedamage> damage and a 30% slow for 2 seconds, Wind applies <winddamage> damage and pushes the enemy back, and Earth applies <earthdamage> damage + a smaller aoe that deals 30% of its original value.",
		MaxLevel = 5,
		firedamage = {
			Base = 5,
			AbilityLevel = 3,
			H4x = 0.15,
		},
		earthdamage = {
			Base = 2,
			AbilityLevel = 2,
			H4x = 0.3,
		},
		icedamage = {
			Base = 4,
			AbilityLevel = 2,
			H4x = 0.25,
		},
		winddamage = {
			Base = 3,
			AbilityLevel = 1,
			H4x = 0.2,
		},
	},
	B = {
		Name = "Elemental Aura",
		Desc = "ppshp surrounds himself with a element, dealing elemental damage to any enemy near him.Fire applies <firedamage> + 3.5%Max Hp as DPS, Ice applies <icedamage> damage and a 20% slow for 2 seconds, Wind applies <winddamage> damage and pushes the enemy back, and Earth applies <earthdamage> damage and stuns the enemy for 1 second.",
		MaxLevel = 5,
		firedamage = {
			Base = 5,
			AbilityLevel = 3,
			H4x = 0.3,
		},
		earthdamage = {
			Base = 2,
			AbilityLevel = 2,
			H4x = 0.3,
		},
		icedamage = {
			Base = 4,
			AbilityLevel = 2,
			H4x = 0.3,
		},
		winddamage = {
			Base = 3,
			AbilityLevel = 1,
			H4x = 0.3,
		},
	},
	C = {
		Name = "Elemental Wave",
		Desc = "ppshp fires a elemental shockwave, dealing the corresponding elemental damage to such.Fire applies <firedamage> + 2%Max Hp as DPS, Ice applies <icedamage> damage and a 20% slow for 2 seconds, Wind applies <winddamage> damage and pushes the enemy back, and Earth applies <earthdamage> damage and stuns the enemy for 1 second.",
		MaxLevel = 5,
		firedamage = {
			Base = 5,
			AbilityLevel = 3,
			H4x = 0.3,
		},
		earthdamage = {
			Base = 2,
			AbilityLevel = 2,
			H4x = 0.3,
		},
		icedamage = {
			Base = 4,
			AbilityLevel = 2,
			H4x = 0.3,
		},
		winddamage = {
			Base = 3,
			AbilityLevel = 1,
			H4x = 0.3,
		},
	},
	D = {
		Name = "Elemental Affinity",
		Desc = "ppshp commands the elements in his hand, ppshp switches his elements affecting his 1st,2nd,and 3rd skill with a corresponding element. To pick a element simply toggle the ultimate and click a different number button ranging from 1-4 in order fire,wind,ice,earth.",
		MaxLevel = 1,
	}
}
return module
