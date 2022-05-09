function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/OzzyBasicAttackFinal-item?id=263074811")
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 12221990, 0.25, 0.5)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 64
	local width = 3
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.35
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Symmetric"
	part.Size = Vector3.new(1, 1, 1)
	part.Shape = "Ball"
	part.BrickColor = BrickColor.new(script.Parent.Parent.Character.Torso.Basicult.Value.Color)
	part.Parent = game.ReplicatedStorage
	d.DB(part)

	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2, "Bright blue", 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 8 - (8 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/OzzyHatTrickFinal-item?id=263075089")
	wait(0.55)
	d.PLAY_SOUND(d.HUMAN, 12222200)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 64
	local width = 4
	local range = 48
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	
	local part = d.CHAR.Hat:Clone()
	d.CW(part)
	part.Anchored = true
	part.CanCollide = false
	part.Parent = workspace
	d.DB(part)
	
	local function onHit(projectile, enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
	end
	local function onStep(projectile)
		part.CFrame = CFrame.new(projectile.Position) * CFrame.Angles(0, projectile.Distance, 0)
	end
	local function onEnd(projectile)
		local position = projectile.Position
		local vector = (d.HRP.Position - position)
		local direction = vector.unit
		local range = 320
		
		local function onHit(projectile, enemy)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		end
		local function onStep(projectile)
			part.CFrame = CFrame.new(projectile.Position) * CFrame.Angles(0, projectile.Distance, 0)
			local vector = (d.HRP.Position - projectile.Position)
			projectile.Direction = vector.unit
			
			if vector.magnitude < 4 then
				projectile.Moving = false
			end
		end
		local function onEnd(projectile)
			part:Destroy()
			d.CHAR.Hat.Transparency = 0
		end
		
		d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	end
	d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	
	d.CHAR.Hat.Transparency = 1
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local buff = ability:C(data.buff)
	local criticalbuff = buff * 2
	local healthPercent = d.HUMAN.Health / d.HUMAN.MaxHealth
	
	d.PLAY_SOUND(d.HUMAN, 12221990, 0.25, 0.75)
	d.SFX.Explosion:Invoke(d.CHAR.Head.Position, 16, script.Parent.Parent.Character.Torso.Basicult.Value.Color)
	
	d.CHAR.Hat.Mesh.Scale = Vector3.new(11,12,11)
	
	d.CHAR.Hat.Transparency = 0
	d.ST.Stun:Invoke(d.HUMAN, 1)
	if healthPercent < .5 then
	d.ST.StatBuff:Invoke(d.HUMAN, "Shields", criticalbuff, 1)
	else
	d.ST.StatBuff:Invoke(d.HUMAN, "Shields", buff, 1)
	end
	wait(0.85)
	d.CHAR.Hat.Mesh.Scale = Vector3.new(1.5, 1.5, 1.5)
	
	d.PLAY_SOUND(d.HUMAN, 12222084, nil, 1.5)
	
	local center = d.HRP.Position
	local radius = 14
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local function onHit2(enemy)
		d.DS.KnockAirborne:Invoke(enemy, 16, 0.75)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
	end
	d.DS.AOE:Invoke(center, radius, team, onHit2)
	d.SFX.Artillery:Invoke(center, radius, "Bright red")
	end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/OzzypigBowtiesAreCruelFinal-item?id=263075431")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 32, {BrickColor = script.Parent.Parent.Character.Torso.Basicult.Value}, 0.45)
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 12222200)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 50
	local width = 4
	local range = 48
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	
	local part = d.CHAR.Bowtie:clone()
	d.CW(part)
	part.Mesh.Scale = Vector3.new(1.5, 1.5, 1.5)
	part.Anchored = true
	part.CanCollide = false
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	d.CHAR.Bowtie.Transparency = 1
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		d.ST.Stun:Invoke(enemy, duration)
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
		d.CHAR.Bowtie.Transparency = 0
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2, "Really red", 0.25,direction,"Neon",0.039)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 35 - (35 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local hitSomeone = false
	local buff = ability:C(data.buff)
	local duration = ability:C(data.duration)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DusekPowerful-item?id=155953604")
	wait(0.085)
	local a = d.HRP.Position
	local range = 64
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 12
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		hitSomeone = true
	end
	
	d.SFX.Shockwave:Invoke(center, radius, script.Parent.Parent.Character.Torso.Basicult.Value.Color, 0.5)
	wait(0.5)
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Bolt:Invoke(center, 1, script.Parent.Parent.Character.Torso.Basicult.Value.Color)
	d.SFX.Explosion:Invoke(center, radius, script.Parent.Parent.Character.Torso.Basicult.Value.Color)
	d.PLAY_SOUND(d.HUMAN, 12221990, 0.5, 1)
	
	d.TELEPORT(center)
	
	d.ST.StatBuff:Invoke(d.HUMAN, "H4x", buff, duration)
	if hitSomeone then
		d.CONTROL.AbilityCooldownReduce:Invoke("D", 17.5 - (29.16 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Hat Trick",
		Desc = "Ozzypig throws out his hat, which deals <damage> damage to enemies it passes through. Once the hat reaches the end of its range, it returns to Ozzypig, dealing damage on the way back.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 3,
			H4x = 0.2,
		},
	},
	B = {
		Name = "In the Hat",
		Desc = "Ozzypig hides under his hat, applying a shield with <buff> defense while becoming immobile for 1 second. The potency of the buff is doubled if Ozzy is below 50% health. After that, an explosion emnates from Ozzypig, knocking nearby enemie airborne and dealing <damage> damage.",
		MaxLevel = 5,
		buff = {
			AbilityLevel = 3,
			H4x = .225,
	},
		damage = {
			Base = 20,
			AbilityLevel = 5,
			H4x = 0.3
		},
	},
	C = {
		Name = "Bowties are Cruel",
		Desc = "Ozzypig hurls his bowtie, dealing <damage> damage and stunning for <duration> seconds to the first target hit.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.45,
		},
		duration = {
			Base = 0.8,
			AbilityLevel = 0.1,
		},
	},
	D = {
		Name = "Hi There!",
		Desc = "Ozzypig blinks to a target location and gains <buff> H4x for <duration> seconds. If an enemy is near where he appears, the cooldown of this ability is reduced by half.",
		MaxLevel = 3,
		buff = {
			AbilityLevel = 10,
			H4x = 0.3,
		},
		duration = {
			AbilityLevel = 1.25,
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 160 + level * 7.5
	end,
	H4x = function(level)
		return 3
	end,
	Toughness = function(level)
		return 5
	end,
	Resistance = function(level)
		return 5 + 0.25 * level
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test