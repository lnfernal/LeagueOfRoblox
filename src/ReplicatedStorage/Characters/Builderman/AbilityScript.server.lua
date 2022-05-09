function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BuildermanBasicFinal-item?id=259631781")
	
	wait(0.20)
	d.PLAY_SOUND(d.HUMAN, 12222216, nil, 0.75)
	wait(.20)
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .25
	--local damage = d.CONTROL.GetStat:Invoke("H4x") * 3
	
	
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy) 
		
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
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
	d.CONTROL.AbilityCooldown:Invoke("A", 10  - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BuildermanHammerSwingFinal-item?id=259632676")
	d.PLAY_SOUND(d.HUMAN, 12222084, nil, 1.5)
	
	local damage = ability:C(data.damage)
	local center = d.HRP.Position
	local radius = 12
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then
			local position = hrp.Position
			local direction = (position - d.HRP.Position).unit
			direction = Vector3.new(direction.X, 0, direction.Z).unit
			local speed = 64
			local width = 4
			local range = ability:C(data.range)
			local function onHit(projectile, enemy)
				local center = projectile.Position
				d.SFX.Explosion:Invoke(center, 4, d.CHAR.Torso.Skills.Value.Color)
			end
			local function onStep(projectile)
				hrp.CFrame = CFrame.new(projectile.Position)
			end
			local function onEnd(projectile)
			end
			d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
		end
		
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Shockwave:Invoke(d.FLAT(center), radius, d.CHAR.Torso.Skills.Value.Color)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 20)
	wait(0.3)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BuildermanRebuildermanFinal-item?id=259633186")     
	d.PLAY_SOUND(d.HUMAN, 12221944)
	
	local center = d.HRP.Position
	local heal = ability:C(data.heal)/100*d.HUMAN.MaxHealth
	
	local buff = (ability:C(data.shield)/100*d.HUMAN.MaxHealth) 
	local duration = ability:C(data.duration)
	d.DS.Heal:Invoke(d.HUMAN, heal)
	d.ST.StatBuff:Invoke(d.HUMAN, "Shields", buff, duration)
	  for t = 0.01, 0.15, 0.01 do
		d.SFX.ReverseExplosion:Invoke(center, 12, d.CHAR.Torso.Skill3.Value.Color, t)
		d.SFX.Explosion:Invoke(center, 12, d.CHAR.Torso.Skills.Value.Color, 0.2)  
		end
	
	
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 17.5  - (17.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BuildermanHardHatFinal-item?id=259633443")
	d.ST.Stun:Invoke(d.HUMAN, 1.5)
	wait(0.5)
	d.PLAY_SOUND(d.HUMAN, 12222208, nil, 0.7)
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 35
	local speed = range / 0.5625
	local width = 7
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local team = d.CHAR.Team.Value
	local function onHit(projectile, enemy)
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		local hrp = d.GET_HRP(enemy)
		if hrp then
			d.SFX.Shockwave:Invoke(hrp.Position, 4, d.CHAR.Torso.Skills.Value.Color)
		end
	end
	local function onStep(projectile)
		topos = projectile.Position 
	end
	local function onEnd(projectile)
		d.HRP.CFrame = projectile:CFrame()
	end
	local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
	repeat
	wait(.1)
	circles = circles + 1
	d.SFX.Circles:Invoke(topos, 6,d.CHAR.Torso.Skills.Value.Color,.2,dir)
	until circles == 4
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 70  - (70 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BuildermanShaketheBaseplateFinal-item?id=259635679")
	wait(1.3)
	d.PLAY_SOUND(d.HUMAN, 12222084)
	
	local center = d.HRP.Position
	local radius = 22
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local function onHit(enemy)
		d.DS.KnockAirborne:Invoke(enemy, 32, 1.25)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Shockwave:Invoke(d.FLAT(center), radius, d.CHAR.Torso.Skills.Value.Color)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Hammer Swing",
		Desc = "Builderman swings his hammer in a circle, dealing <damage> damage to and knocking back <range> units enemies he hits.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 10,
			Skillz = 0.2,
		},
		range = {
			Base = 10,
			AbilityLevel = 2,
		},
	},
	B = {
		Name = "Rebuilderman",
		Desc = "Builderman heals himself for <heal>% of his maximum health and he applies a shield to himself for <shield>% of his maximum health for <duration> seconds.",
		MaxLevel = 5,
		heal = {
			Base = 5,
			AbilityLevel = 1.5,
		},
		duration = {
			Base = 3,
			
			 
		},
		shield = {
			Base = 10,
			AbilityLevel = 1,
			
		},
	},
	C = {
		Name = "Hard Hat",
		Desc = "Builderman charges forward helmet first, slamming into enemies. They take <damage> damage and are slowed <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 15,
			Skillz = 0.35,
		},
		slow = {
			Base = 25,
			AbilityLevel = 5,
		},
		duration = {
			Base = 2.5,
		},
	},
	D = {
		Name = "Shake the Baseplate",
		Desc = "Builderman deals <damage> damage to nearby enemy champions and knocks them airborne.",
		MaxLevel = 3,
		damage = {
			Base = 120,
			AbilityLevel = 15,
			Skillz = 0.5,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 180 + level * 32.5
	end,
	Skillz = function(level)
		return 5 + level * 0.75
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