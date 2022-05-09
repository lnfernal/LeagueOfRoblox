local module = {
	A = {
		Name = "Index",
		Desc = "Matt Dusek fires a fast-moving projectile which deals <damage> damage to the first enemy it hits. If this ability is used under System Modification, the speed is increased, and this move creates an explosion at the impact zone, spreading the damage to nearby targets.",
		MaxLevel = 6,
		damage = {
			Base = 7.5,
			AbilityLevel = 2.5,
			H4x = 0.8,
		},
	},
	B = {
		Name = "Array",
		Desc = "Matt Dusek creates an explosion at a target location which deals <damage> damage to enemies caught within. If this ability is used under System Modification, the area is increased slightly and the damage is changed to true damage.",
		MaxLevel = 5,
		damage = {
			Base = 7,
			AbilityLevel = 6,
			H4x = 0.3,
		},
	},
	C = {
		Name = "Binary Search",
		Desc = "Matt Dusek fires a piercing bolt of code which deals <damage> damage to each enemy it passes through. It additionally gains speed and range as it passes through enemies. If this ability is used under System Modification, the damage increases by 15% of the current damage per enemy hit while also reducing its cooldown by 1 per enemy hit.",
		MaxLevel = 6,
		damage = {
			Base = 5,
			AbilityLevel = 4.5,
			H4x = 0.35,
		},
	},
	D = {
		Name = "System Modification",
		Desc = "Passive ability. Matt Dusek charges his staff per successful attack he lands. After accumulating 4 stacks, Matt's next ability will gain an additional effect. Basic grant .4, Index grants .8, Array grants .4 against champs and .2 against minions, Binary Search grants .4 against champs and .2 against minions. Using superpowered moves puts other moves on cooldown due to their sheer power.",
		MaxLevel = 1,
	}
}
return module
