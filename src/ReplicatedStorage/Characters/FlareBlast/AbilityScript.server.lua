function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/FlareBlastBasicAttackFinal-item?id=263072642")
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 32656754, nil, 1)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Symmetric"
	part.Size = Vector3.new(1, 1, 1)
	part.Shape = "Ball"
	part.Transparency = 0.5
	part.BrickColor = BrickColor.new(tostring(d.CHAR.Torso.Skills.Value))
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
	part.Material = "Foil"
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
		local chosen = math.random(1,100)
		print(chosen)
		if (chosen < 25) then
			
			d.ST.MoveSpeed:Invoke(enemy, -.15, 2)
		end
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,tostring(d.CHAR.Torso.Skills.Value), 0.25,direction,"DiamondPlate",0.039) 
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 18 - (18 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
		d.SFX.Bolt:Invoke(d.HRP.Position, 0.4, tostring(d.CHAR.Torso.Skills.Value), 0.35)
		d.ST.MoveSpeed:Invoke(d.HUMAN, -.4, 1.15)
	wait(.6)
		

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/FlareblastTeleportFinal-item?id=263072855")
	d.PLAY_SOUND(d.HUMAN, 84937942)
	
	local damage = ability:C(data.damage)
	
	local a = d.HRP.Position
	local range = 22
	local b = d.DS.Targeted:Invoke(a, range, d.GET_MOUSE_POS:InvokeClient(d.PLAYER))
	local radius = 11
	d.PLAY_SOUND_POS(b, 84937942)
	d.SFX.Shockwave:Invoke(b, radius, tostring(d.CHAR.Torso.Skills.Value), 0.65)
	wait(0.65)
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		local hrp = d.GET_HRP(enemy)
		if hrp then
			local delta = hrp.Position - b
			delta = Vector3.new(delta.X, 8, delta.Z)
			hrp.Parent:MoveTo(d.HRP.Position + delta)
		end
	end
	d.DS.AOE:Invoke(b, radius, team, onHit)
	d.PLAY_SOUND_POS(b, 84937942)
	d.SFX.Artillery:Invoke(b, radius, tostring(d.CHAR.Torso.Skills.Value))
	d.SFX.Artillery:Invoke(d.FOOT(), radius, tostring(d.CHAR.Torso.Skills.Value))
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/FlareblastBreathofDeathFinal-item?id=263073388")
	d.PLAY_SOUND(d.HUMAN, 32656754, nil, 0.4)
	
	local position = d.CHAR.Head.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 30
	local width = 6.5
	local range = 64
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Symmetric"
	part.Size = Vector3.new(7, 7, 7)
	part.Shape = "Ball"
	part.Transparency = 0.75
	part.BrickColor = BrickColor.new(tostring(d.CHAR.Torso.Skills.Value))
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
	part.Material = "Foil"
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(projectile, enemy)
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
	end
	local function onStep(projectile)
		
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 18 - (18 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/FlareblastDeepFreezeFinal-item?id=263073705")
	d.SFX.Bolt:Invoke(d.HRP.Position, 0.5, tostring(d.CHAR.Torso.Skills.Value), 0.35)
	wait(0.425)
	d.PLAY_SOUND(d.HUMAN, 84937942)
	
	local center = d.HRP.Position
	local radius = 15
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	local buff = ability:C(data.buff)
	local buffDuration = ability:C(data.buffDuration)
	local hits = 0
	local function onHit(enemy)
		d.ST.Stun:Invoke(enemy, duration)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		if hits < 4 then
		d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", buff, buffDuration)
		d.ST.StatBuff:Invoke(d.HUMAN, "Resistance", buff, buffDuration)
		hits = hits + 1
		end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Artillery:Invoke(center, radius, tostring(d.CHAR.Torso.Skills.Value))
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 75 - (75 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local duration = ability:C(data.duration)
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100

	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 24, 48, {BrickColor = d.C(tostring(d.CHAR.Torso.Skills.Value))}, 1)
	wait(1)
	

	
	local t = 0
	local radius = 24
	d.SFX.AreaAOEFollow:Invoke(d.HRP, radius, tostring(d.CHAR.Torso.Skills.Value),duration)
	while t < duration do
		local dt = wait(0.5)
		t = t + dt
		
		d.PLAY_SOUND(d.HUMAN, 84937942, 2.5)
		
		local center = d.HRP.Position
		
		local team = d.CHAR.Team.Value
		local function onHit(enemy)
			d.ST.MoveSpeed:Invoke(enemy, slow, dt)
			d.DS.Damage:Invoke(enemy, damage * dt, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
			d.SFX.PartRandomFollow:Invoke(enemy.Parent.Torso, 1.5, tostring(d.CHAR.Torso.Skills.Value))
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Portal",
		Desc = "FlareBlast creates a portal fluctuation at the targeted location. After a short delay, the fluctation stabilizes and carries nearby enemies to FlareBlast. This journey through his underworld is not very comfortable, and so enemies take <damage> damage.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 10,
			H4x = 0.275,
		},
	},
	B = {
		Name = "Breath of Death",
		Desc = "FlareBlast breathes the icy breath of death in a straight line ahead of him. Players hit take <damage> damage and are slowed <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 25,
			AbilityLevel = 15,
			H4x = 0.225,
		},
		slow = {
			Base = 30,
		
		},
		duration = {
			Base = 3,
		}
	},
	C = {
		Name = "Deep Freeze",
		Desc = "FlareBlast unleashes a frost wave, stunning nearby opponents for <duration> seconds while dealing <damage> damage to them. Frost which freezes enemies returns to FlareBlast, toughening his armor which increases his Toughness and Resistance by <buff> for <buffDuration> seconds.",
		MaxLevel = 5,
		duration = {
			Base = 1,
			AbilityLevel = 0.1,
		},
		damage = {
			Base = 20,
			AbilityLevel = 10,
			H4x = 0.2,
		},
		buff = {
			
			AbilityLevel = 25,
		
		},
		buffDuration = {
			Base = 4,
		},
	},
	D = {
		Name = "Death's Blizzard",
		Desc = "[Innate] FlareBlast's basic attack has a 25% chance to slow his enemy by 15% for 2 second. [Active] For the next <duration> seconds, every second, FlareBlast deals <damage> damage and slows <slow>% nearby enemies.",
		MaxLevel = 3,
		duration = {
			Base = 2,
			AbilityLevel = 1,
		},
		damage = {
			Base = 15,
			AbilityLevel = 7.5,
			H4x = .1,
		},
		slow = {
			Base = 20,
			
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 160 + level * 20
	end,
	H4x = function(level)
		return 4 + level * 0.5
	end,
	Toughness = function(level)
		return 5 + level * 1
	end,
	Resistance = function(level)
		return 5 + level * 0.75
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test