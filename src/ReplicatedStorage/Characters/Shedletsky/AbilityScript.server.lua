--.5, .5, 1
local attackNumber = 1
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	local hrp = d.HRP
	
	if attackNumber == 1 or attackNumber == 2 then
		local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.4
		d.PLAY_SOUND(d.HUMAN, 12222216)
		if attackNumber == 1 then
			d.CONTROL.AbilityCooldown:Invoke("Q", 1 - (1* d.CONTROL.GetStat:Invoke("BasicCDR")))
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShedBasicAttack1Final-item?id=259752269")
		elseif attackNumber == 2 then
			d.CONTROL.AbilityCooldown:Invoke("Q", 1 - (1* d.CONTROL.GetStat:Invoke("BasicCDR")))
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShedBasicAttack2Final-item?id=259752762")
		end
		
		wait(0.15)
		
		local team = d.CHAR.Team.Value
		local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	
		end
		d.DS.Melee:Invoke(hrp, team, onHit,10,6) 
	elseif attackNumber == 3 then
		d.CONTROL.AbilityCooldown:Invoke("Q", 1 - (1 * d.CONTROL.GetStat:Invoke("BasicCDR")))
		local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.4
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShedBasicAttack3Final-Knife-item?id=259752690")
		d.PLAY_SOUND(d.HUMAN, 12222216, nil, 1.25)
		
		wait(0.15)
		
		local knife = Instance.new("Part")
		knife.Anchored = true
		knife.CanCollide = false
		knife.TopSurface = "Smooth"
		knife.BottomSurface = "Smooth"
		knife.Size = Vector3.new(1, 1, 2)
		knife.Parent = game.ReplicatedStorage
		d.DB(knife)
		
		local mesh = d.CHAR.Knife.Mesh:clone()
		mesh.Parent = knife
		
		local position = d.CHAR["Left Arm"].Position
		local direction = d.HRP.CFrame.lookVector
		local speed = 80
		local width = 5
		local range = 32
		local team = d.CHAR.Team.Value
		local function onHit(projectile, enemy)
			projectile.Moving = false
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		
			d.PLAY_SOUND(enemy, 12222046, 0.25)
		end
		local function onStep(projectile)
		end
		local function onEnd(projectile)
		end
		local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"White", 0.25,direction,"Neon",0.039)
		d.SFX.ProjPart:Invoke(p:ClientArgs(), knife, CFrame.Angles(0, math.pi, 0))
	end
	
	attackNumber = attackNumber + 1
	if attackNumber > 3 then
		attackNumber = 1
	end
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 7 - (5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShedSweepFinal-item?id=259771831")
	d.PLAY_SOUND(d.HUMAN, 12222225, nil, 0.75)
		d.PLAY_SOUND(d.HUMAN, 130759239)
		d.PLAY_SOUND(d.HUMAN, 496928925)

	
	local center = d.HRP.Position
	local range = 12
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	d.DS.AOE:Invoke(center, range, team, onHit)
	d.SFX.Shockwave:Invoke(center, range, script.Parent.Parent.Character.Torso.Skills.Value.Color)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 8 - (5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShedImpaleFinal-item?id=259792395")
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 12222208)
		d.PLAY_SOUND(d.HUMAN, 130759239)
				d.PLAY_SOUND(d.HUMAN, 496928925)



	local range = 14
	local width = 5
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	
	local function onHit(enemy)	
					d.ST.MoveSpeed:Invoke(enemy, -.3, 2,"Impale", true)	
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	d.SFX.Line:Invoke(d.HRP.Position,d.HRP.CFrame.lookVector, range, width, script.Parent.Parent.Character.Torso.Skills.Value.Color)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 7 - (5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShedLungeFinal-item?id=259811290")
	d.PLAY_SOUND(d.HUMAN, 12222208)
		d.PLAY_SOUND(d.HUMAN, 130759239)
				d.PLAY_SOUND(d.HUMAN, 496928925)


	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 28 * 4
	local width = 6
	local range = 25
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local function onHit(projectile, enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
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
	d.SFX.Circles:Invoke(topos, 6,"White",.2,dir)
	until circles == 3
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 45 - (45 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShedSFOTHFinal-item?id=259813829")
	d.PLAY_SOUND(d.HUMAN, 130759239)
			d.PLAY_SOUND(d.HUMAN, 496928925)

	d.ST.StatBuff:Invoke(d.HUMAN, "BasicCDR", .1, 6)
	local center = d.HRP.Position
	local range = 30
	local team = nil
	local function onHit(enemy)
		d.DS.KnockAirborne:Invoke(enemy, 4, .1)
		d.DS.KnockAirborne:Invoke(d.HUMAN, 4, .1)
	end
	d.DS.AOE:Invoke(center, range, team, onHit)
	
	local arena = nil
	if d.CHAR.RequiredLevel.Value == 20 then
	arena = game.ServerStorage.ShedletskyArena2
	elseif d.CHAR.RequiredLevel.Value == 45 then
	arena = game.ServerStorage.ShedletskyArena3	
	else
    arena = game.ServerStorage.ShedletskyArena
		end
	local position = d.HRP.Position
	local constructionTime = .35
	local duration = ability:C(data.duration)
	d.DS.ConstructArena:Invoke(arena, position, constructionTime, duration)
end
script.Ability4.OnInvoke = ability4


local abilityData = {
	A = {
		Name = "Sweep",
		Desc = "Shedletsky spins in a circle, dealing <damage> damage to nearby enemies.",
		MaxLevel = 7,
		damage = {
			Base = 25,
			AbilityLevel = 7.5,
			Skillz = 0.225,
		},
	},
	B = {
		Name = "Impale",
		Desc = "Shedletsky stabs forward, dealing <damage> damage to enemies in front of him and slowing them by 30% for 2 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 8,
			Skillz = 0.35,
		  },
		
			 
		},	
		
	
	C = {
		Name = "Lunge",
		Desc = "Shedletsky charges forward, dealing <damage> damage to enemies caught in his path.",
		MaxLevel = 5,
		damage = {
			Base = 30,
			AbilityLevel = 9,
			Skillz = 0.25,
		},
	},
	D = {
		Name = "SFOTH",
		Desc = "Shedletsky creates an arena and forces nearby characters to fight in it for <duration> seconds. While Shedletsky is in his arena, he gains 10% increased Attackspeed Reduction.",
		MaxLevel = 1,
		duration = {
			Base = 6,
			
		},
		
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 160 + level * 10
	end,
	Skillz = function(level)
		return 6 + level * 1.5
	end,
	Toughness = function(level)
		return 5 + 0.75 * level
	end,
	Resistance = function(level)
		return 5 + 0.5 * level
	end,
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test