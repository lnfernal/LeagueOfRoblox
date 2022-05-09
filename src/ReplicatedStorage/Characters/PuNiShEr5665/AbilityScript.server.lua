function jumpHeight(distance, height, current)
	local funcHeight = (distance/2)^2
	local func = -current * (current - distance)
	func = func / funcHeight
	func = func * height
	return Vector3.new(0, func, 0)
end
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.125 - (1.125 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/PunisherBasicAttackFinal-item?id=263070683")
	d.PLAY_SOUND(d.HUMAN, 12222216)
	wait(0.45)
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("Skillz")*.4
	local function onHit(enemy)
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			d.DS.Heal:Invoke(d.HUMAN, d.HUMAN.MaxHealth * 0.02)
		elseif enemy.Parent.Name ~= "Turret" then
			d.DS.Heal:Invoke(d.HUMAN, d.HUMAN.MaxHealth * 0.01)
		end
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	
	end
	d.DS.Melee:Invoke(hrp, team, onHit,10,6)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
  wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/PunisherDoomSweepFinal-item?id=263071125")
	d.PLAY_SOUND(d.HUMAN, 12222225, nil, 0.75)
	
	local center = d.HRP.Position
	local range = 14
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local recoilraw = ability:C(data.recoil)
	local duration = ability:C(data.duration)
	local speed = 5 / 100

	local recoil = true
		local health = d.HUMAN.Health
		local recoilbase = recoilraw * d.HUMAN.MaxHealth/100
		if health > recoilbase then 
			recoil = recoilbase
		elseif health <= d.HUMAN.MaxHealth then
			recoil = health - 1
		end
		
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		d.ST.StatBuff:Invoke(d.HUMAN, "Speed", 0.05, duration)
	end
	d.DS.AOE:Invoke(center, range, team, onHit)
	d.SFX.Shockwave:Invoke(d.FLAT(center), range, tostring(d.CHAR.Torso.Skills.Value))
	
	d.DS.Damage:Invoke(d.HUMAN, recoil)
	local bonus = (d.CONTROL.GetStat:Invoke("Skillz")/100)*recoilraw
	d.ST.StatBuff:Invoke(d.HUMAN, "Skillz", bonus, 2)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12)
wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/PunisherSoulSiphonFinal-item?id=263071327")
	d.PLAY_SOUND(d.HUMAN, 12222030, nil, 3)
	
	local center = d.HRP.Position
	local radius = 15
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local heal = ability:C(data.heal)
	local recoilraw = ability:C(data.recoil)
	local count = 0
	local function onHit(enemy)
		if count < 4 then
		count = count + 1
		d.ST.StatBuff:Invoke(d.HUMAN, "HealthRegen", heal, 2)
		end
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.ReverseExplosion:Invoke(center, radius, tostring(d.CHAR.Torso.Skills.Value))
	local bonus = (d.CONTROL.GetStat:Invoke("Skillz")/100)*recoilraw
	d.ST.StatBuff:Invoke(d.HUMAN, "Skillz", bonus, 2)
end
script.Ability2.OnInvoke = ability2


function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 18 - (18 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "hhttp://www.roblox.com/PunisherCursedSoilFinal-item?id=263071608")
	d.PLAY_SOUND(d.HUMAN, 12222030)
	    d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C(tostring(d.CHAR.Torso.Skills.Value))}, 0.1)
	local a = d.HRP.Position
	local range = 32
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b) 
	d.SFX.ReverseExplosion:Invoke(center, 18,tostring(d.CHAR.Torso.Skills.Value), 0.35)
    wait(0.45)
	local radius = 18
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	local recoil = ability:C(data.recoil)
	local slow = -ability:C(data.slow)/100
	
	d.DS.Damage:Invoke(d.HUMAN, recoil/100*d.HUMAN.MaxHealth)
	d.ST.StatBuff:Invoke(d.HUMAN, "Skillz", recoil, 2)
	d.SFX.AreaAOEStart:Invoke(center, radius, tostring(d.CHAR.Torso.Skills.Value),duration)
	local t = 0
	while t < duration do
		local dt = wait(0.3)
		t = t + dt
		
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage * dt, "Toughness", d.PLAYER)
			d.ST.StatBuff:Invoke(enemy, "Speed", slow, duration)
			d.SFX.PartRandomFollow:Invoke(enemy.Parent.Torso, 1.5, tostring(d.CHAR.Torso.Skills.Value))
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 70 - (70 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	local position = d.FLAT(d.HRP.Position) + Vector3.new(0, 2, 0)
	local range = 32
	local team = d.CHAR.Team.Value
	local target = d.DS.NearestTarget:Invoke(position, range, team)
	local percent = ability:C(data.percent)/100
	local recoilraw = ability:C(data.recoil)
	local requiredtocooldown = ability:C(data.threshold)
	local reduceamount = ability:C(data.amount)

	local recoil = true
		local health = d.HUMAN.Health
		local recoilbase = recoilraw * d.HUMAN.MaxHealth/100
		if health > recoilbase then 
			recoil = recoilbase
		elseif health <= d.HUMAN.MaxHealth then
			recoil = health - 1
		end
	if target ~= nil then
		d.DS.Damage:Invoke(d.HUMAN, recoil)
		local bonus = (d.CONTROL.GetStat:Invoke("Skillz")/100)*recoilraw
		d.ST.StatBuff:Invoke(d.HUMAN, "Skillz", bonus, 2)
		
		local hrp = d.GET_HRP(target)
		for warningPulses = 1, 4 do
			d.SFX.ReverseExplosion:Invoke(hrp.Position, 8, tostring(d.CHAR.Torso.Skills.Value), 0.25)
			d.SFX.Explosion:Invoke(d.HRP.Position, 8, tostring(d.CHAR.Torso.Skills.Value), 0.25)
			wait(0.25)
		end
		
		local tp = d.FLAT(target.Parent.HumanoidRootPart.Position) + Vector3.new(0, 2.5, 0)
		local vc = (tp - position)
		local rn = vc.magnitude
		local dr = vc.unit
		local sp = rn * 4
		local function onStep(p,dt)
		end
		local function onHit()
		end
		local function onEnd(p)
			d.HRP.CFrame = p:CFrame()
			
			local damage = target.Health * percent
			if damage >= requiredtocooldown then
				d.CONTROL.AbilityCooldownReduce:Invoke("D", reduceamount - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
			end
			d.DS.Damage:Invoke(target, damage, nil, d.PLAYER)
			d.PLAY_SOUND(d.HUMAN, 12222200)
			d.SFX.Artillery:Invoke(tp, 6, tostring(d.CHAR.Torso.Skills.Value))
			if game:GetService("Players"):GetPlayerFromCharacter(target.Parent) then 
			d.DS.Heal:Invoke(d.HUMAN, d.HUMAN.MaxHealth * .25)
			d.STEADY()
			end
		end
		local p = d.DS.AddProjectile:Invoke(position, dr, sp, 0, rn, team, onHit, onStep, onEnd)
		d.SFX.ProjLeap:Invoke(p:ClientArgs(), d.HRP, 32)
	else
		d.CONTROL.AbilityCooldownReduce:Invoke("D", 45 - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Doom Sweep",
		Desc = "PuNiShEr5665 sweeps his scythe in a wide circle, dealing <damage> damage. Costs <recoil>% maximum health to use, but boosts Skillz by <recoil>% for 2 seconds and will never drop Punisher below 1 health. For every enemy hit PuNiShEr5665 gains a 5% movespeed bonus for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 5,
			Skillz = 0.45,
		},
		recoil = {
			Base = 5,
			AbilityLevel = 1,
		},
		duration = {
			Base = 3,
			AbilityLevel = 0.4,
			
		},
		
	},
	B = {
		Name = "Soul Siphon",
		Desc = "PuNiShEr5665 draws in the souls of nearby enemies, dealing <damage> damage to them and granting himself <heal> health regen for every enemy hit, a maximum of four. Boosts Skillz by <recoil>% for 2 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			Skillz = 0.25,
			},
		heal = {
			Base = 4,
			AbilityLevel = 1.5,
			Skillz = 0.06,
		},
		recoil = {
			Base = 3,
			AbilityLevel = 1,
		},
	},
	C = {
		Name = "Cursed Soil",
		Desc = "PuNiShEr5665 creates a cursed area on the ground at a targeted location, dealing 30% of the damage (<damage>) every 0.3 seconds, also slowing by <slow>% for <duration> seconds. Costs <recoil>% maximum health to use, but boosts Skillz by <recoil>% for 2 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 10, 
			AbilityLevel = 7.5,
			Skillz = 0.15,
		},
		slow = {
			Base = 10,
			AbilityLevel = 3,
		},
		duration = {
			Base = 5.5,
			
		},
		recoil = {
			Base = 5,
			AbilityLevel = 1.5,
		},
	},
	D = {
		Name = "Cut Down to Size",
		Desc = "PuNiShEr5665 leaps to the nearest enemy, heals Punisher by 25% of his maximum health if the target is a player and deals <percent>% of their maximum health as true damage, if the damage dealt is greater than or equal to <threshold> then the cooldown is reduced by <amount> seconds. This means that more damage is dealt when the target has higher health. Costs <recoil>% maximum health to use, but boosts Skillz by <recoil>% for 2 seconds and will never drop Punisher below 1 health.",
		MaxLevel = 3,
		percent = {
			Base = 25,
			AbilityLevel = 2.5,
		},
		recoil = {
			Base = 15,
			
		},
		threshold = {
			Base = 500,
			AbilityLevel = -15,
		},
		amount = {
			AbilityLevel = 7.5,
		},
		
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 145 + level * 12.5
	end,
	Skillz = function(level)
		return 3 + level * 1.25
	end,
	H4x = function(level)
		return 5 + level * 0.75
	end,
	Toughness = function(level)
		return 5 + level * 0.5
	end,
	Resistance = function(level)
		return 5 + level * 0.5
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test