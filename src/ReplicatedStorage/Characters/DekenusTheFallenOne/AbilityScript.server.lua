function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DekenusBasicAttackFinal-item?id=263076638")
	d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	
	wait(0.2)
	
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
	end
	d.DS.Melee:Invoke(hrp, team, onHit,10,6) 
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local center2 = d.HRP.Position
	 d.SFX.ReverseExplosion:Invoke(center2, 6, "White",0.35)
wait(0.35)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DekenusGustFinal-item?id=263077049")
	d.PLAY_SOUND(d.HUMAN, 12222208, nil, 1.35)
		
	local range = 22
	local width = 8
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local push = ability:C(data.push)
	local direction = d.HRP.CFrame.lookVector
	local position = d.HRP.Position
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		if enemy.Parent then
			local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
			if hrp then
				local position = hrp.Position
				local speed = push * 4
				local function onHit()
				end
				local function onStep(projectile)
					hrp.CFrame = CFrame.new(projectile.Position)
				end
				local function onEnd()
				end
				d.DS.AddProjectile:Invoke(position, direction, speed, 0, push, team, onHit, onStep, onEnd)
			end
		end
	end
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	d.SFX.Line:Invoke(position, direction, range, width, "White")
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 13.5 - (13.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	d.PLAY_SOUND(d.HUMAN, 84937942)
	
	local speed = ability:C(data.speed)/100
	local buff = ability:C(data.buff)
	local duration = ability:C(data.duration)
	local circles = 0
	local center = d.HRP.Position 
	local dir = d.HRP.Rotation
	local missingHealth = d.HUMAN.MaxHealth - d.HUMAN.Health
	local finalbuff = buff + (missingHealth * .1)
   
	d.ST.MoveSpeed:Invoke(d.HUMAN, speed, duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", finalbuff, duration)
	
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 24, {BrickColor = d.C(d.CHAR.Torso.Skills.Value.Color)})
  
	repeat
	
	circles = circles + 1
	d.SFX.Circles:Invoke(center, 10, d.CHAR.Torso.Skills.Value.Color, .2,dir) 
	until circles == 3
	
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 18 - (18 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DekenusCondemnFinal-item?id=263079775")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 64, {BrickColor = d.C(d.CHAR.Torso.Skills.Value.Color)}, 0.6)
	d.ST.MoveSpeed:Invoke(d.HUMAN, -.25, .6)
	wait(0.6)
	d.PLAY_SOUND(d.HUMAN, 84937942, nil, 0.8)
	
	local center = d.HRP.Position
	local radius = 15
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local function onHit(enemy)
		d.DS.KnockAirborne:Invoke(enemy, 16, 1)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Artillery:Invoke(center, radius, d.CHAR.Torso.Skills.Value.Color)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 75 - (75 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.ST.Stun:Invoke(d.HUMAN, .625)
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=396332362")
	d.SFX.Bolt:Invoke(d.HRP.Position, 0.7, "Black", 0.3)
	wait(.625)
	d.SFX.Bolt:Invoke(d.HRP.Position, 0.7, "Black", 0.3)
	local position = d.HRP.Position
	local b = d.MOUSE_POS
	local maxRange = 512
	local target = d.DS.Targeted:Invoke(position, maxRange, b)
	target = Vector3.new(target.X, position.Y, target.Z)
	local direction = (target - position).unit
	local speed = 48 * 2.5
	local width = 8
	local range = (target - position).magnitude
	d.SFX.Artillery:Invoke(target, 4, "Bright red", range / speed)
	
	d.PLAY_SOUND(d.HUMAN, 12222200)
	
	local position = d.HRP.Position
	local b = d.MOUSE_POS
	local maxRange = 512
	local target = d.DS.Targeted:Invoke(position, maxRange, b)
	target = Vector3.new(target.X, position.Y, target.Z)
	local direction = (target - position).unit
	local speed = 48 * 2.5
	local width = 8
	local range = (target - position).magnitude
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	local radius = 19.5
	
	local function onHit(projectile, enemy)
	end
	local function onStep(projectile)
		
	
	end
	local function onEnd(projectile)
		d.HRP.CFrame = projectile:CFrame()
		
		d.PLAY_SOUND(d.HUMAN, 12222084)
		local center = d.HRP.Position
		local function onHit(enemy)
			d.ST.MoveSpeed:Invoke(enemy, slow, duration)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Explosion:Invoke(center, radius, "Bright red")
	end
	local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, false)
	d.SFX.ProjLeap:Invoke(p:ClientArgs(), d.HRP, 256)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Gust",
		Desc = "DekenusTheFallenOne blows a gust of air with his wings, dealing <damage> damage and pushing enemies back <push> studs in a line in front of him.",
		MaxLevel = 5,
		damage = {
			Base = 17.5,
			AbilityLevel = 7.5,
			H4x = 0.25,
		},
		push = {
			Base = 5,
			AbilityLevel = 5,
		}
	},
	B = {
		Name = "Rush",
		Desc = "DekenusTheFallenOne increases his speed by <speed>% and boosts his toughness by <buff> for <duration> seconds. The potency of the buff is increased by 1% per 1% of missing health.",
		MaxLevel = 5,
		speed = {
			Base = 0,
			AbilityLevel = 5,
		},
		buff = {
	
			AbilityLevel = 30,
		
		},
		duration = {
			Base = 4,
			
		}
	},
	C = {
		Name = "Condemn",
		Desc = "After a brief startup, DekenusTheFallenOne knocks nearby enemies high into the air for 1 second while dealing <damage> damage to them.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 12.5,
			H4x = 0.35,
		}
	},
	D = {
		Name = "Soar",
		Desc = "After a .625 second startup, DekenusTheFallenOne flies to a distant targeted location, and deals <damage> damage to and slows <slow>% for <duration> seconds nearby enemies where he lands.",
		MaxLevel = 3,
		damage = {
			Base = 70,
			AbilityLevel = 10,
			H4x = 0.4,
		},
		slow = {
			Base = 30,
			
		},
		duration = {
			Base = 2,
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 120 + level * 22.5
	end,
	Skillz = function(level)
		return 10
	end,
	H4x = function(level)
		return 5 + level * 0.8
	end,
	Toughness = function(level)
		return 5 + level * 0.75
	end,
	Resistance = function(level)
		return 5 + level * 1.25
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test