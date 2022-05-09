function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/JoelBasicAttackFinal-item?id=263083946")
	d.PLAY_SOUND(d.HUMAN, 12222216)
	wait(0.25)
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .4
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	
	end   
	d.DS.Melee:Invoke(hrp, team, onHit,10,6)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 18.5 - (18.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	local duration = ability:C(data.duration)
	local damage = ability:C(data.damage)
	d.CONTROL.AbilityCooldown:Invoke("Q", duration)
	d.CONTROL.AbilityCooldown:Invoke("Q", duration)
	local radius = 14
	local t = 0
	d.SFX.AreaAOEFollow:Invoke(d.CHAR.Torso, radius, tostring(d.CHAR.Torso.Skills.Value),duration,"Neon")
	d.SFX.PartRandomFollow:Invoke(d.CHAR.Part, 3, tostring(d.CHAR.Torso.Skills.Value,duration,"Neon"))
	while t < duration do
		local dt = wait(1/4)
		t = t + dt
		d.SFX.PartRandomFollow:Invoke(d.CHAR.Part, 3, tostring(d.CHAR.Torso.Skills.Value,duration,"Neon"))
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/JoelVortexofPowerFinal-item?id=263084209")
		d.PLAY_SOUND(d.HUMAN, 12222225, nil, 0.75)
		
		local center = d.HRP.Position
		
		local team = d.CHAR.Team.Value
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage * dt, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*0.5*dt, "Toughness", d.PLAYER)
		end 
			d.SFX.PartRandomFollow:Invoke(enemy.Parent.Torso, 3, tostring(d.CHAR.Torso.Skills.Value,0.2,"Neon"))
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Shockwave:Invoke(center, radius, d.CHAR.Torso.Skills.Value.Color,0.2,"Neon")
	end
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/JoelBowtoCaesarFinal-item?id=263084698")
	d.PLAY_SOUND(d.HUMAN, 12222253)
	
	local center = d.HRP.Position
	local radius = 15
	local team = d.CHAR.Team.Value
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	local function onHit(enemy)
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Shockwave:Invoke(d.FLAT(center), radius, script.Parent.Parent.Character.Torso.Skills.Value.Color,0.2,"Neon")
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/JoelMarkofCaesarFinal-item?id=263085136")
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 32656754)
	
	local position = d.CHAR.Sword.Position
	local direction = d.HRP.CFrame.lookVector
	local range = ability:C(data.range)
	local speed = 65
	local width = 4.5
	local team = d.CHAR.Team.Value
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Symmetric"
	part.Size = Vector3.new(1, 1, 1)
	part.Shape = "Ball"
	part.Material = "Marble"
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
	part.BrickColor =  d.CHAR.Torso.Skills.Value
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(p, enemy)
		d.ST.Stun:Invoke(enemy, 1)
		p.Moving = false
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
		
		d.TELEPORT(projectile.Position)
		d.PLAY_SOUND(d.HUMAN, 84937942)
		d.SFX.Artillery:Invoke(projectile.Position, 4, script.Parent.Parent.Character.Torso.Skills.Value.Color)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 60 - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction"))) --Changed cooldown from 52.5 to 75 Seconds
wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/JoelRetributionFinal-item?id=263085370")
	d.PLAY_SOUND(d.HUMAN, 12222084)

	local center = d.FLAT(d.HRP.Position)
	local radius = 24
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local percent = ability:C(data.percent)/100
	local function onHit(ally)
		local missing = ally.MaxHealth - ally.Health
		local heal = missing * percent
		
		d.DS.Heal:Invoke(ally, heal)
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Shockwave:Invoke(center, radius, script.Parent.Parent.Character.Torso.Skills.Value.Color,0.2,"Neon")
	d.SFX.Explosion:Invoke(center, radius / 2,script.Parent.Parent.Character.Torso.Skills.Value.Color)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Vortex of Power",
		Desc = "JoelMatGarcia spins repeatedly, dealing <damage> damage per second to nearby enemies for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 10,
			Skillz = 0.55,
		},
		duration = {
			Base = 3,
			
		},
	},
	B = {
		Name = "Bow to Caesar",
		Desc = "JoelMatGarcia demands respect from nearby enemies, slowing them <slow>% for <duration> seconds.",
		MaxLevel = 5,
		slow = {
			Base = 30,
			AbilityLevel = 3
		},
		duration = {
			Base = 2.25,
		},
	},
	C = {
		Name = "Mark of Caesar",
		Desc = "JoelMatGarcia throws a projectile in a line which travels up to <range> studs. When it either hits a target or reaches the end of its range, JoelMatGarcia teleports to its location and stuns the first target it hits for 1 second.",
		MaxLevel = 5,
		range = {
			Base = 27,
			AbilityLevel = 3,
		},
	},
	D = {
		Name = "Requite",
		Desc = "JoelMatGarcia heals nearby allies for <percent>% of their missing health, meaning that allies with less health are healed more.",
		MaxLevel = 3,
		percent = {
			Base = 40,
			AbilityLevel = 2.5,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 160 + level * 12.5
	end,
	Skillz = function(level)
		return 5 + level * 0.75
	end,
	Toughness = function(level)
		return 5 + level * 0.75
	end,
	Resistance = function(level)
		return 5 + level * 0.5
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test