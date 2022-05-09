local basicSpin = false
local basicHeal = 0
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 0.75 - (0.375 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local hrp = d.HRP
	if basicSpin then
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DeadpoolBasicAttack1Final-item?id=263086897")
		d.PLAY_SOUND(d.HUMAN, 83674171, nil, 1.2)
	else
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DeadpoolBasicAttack2Final-item?id=263087072")
		d.PLAY_SOUND(d.HUMAN, 12222216, nil, 1.6)
	end
	
	basicSpin = not basicSpin
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.4
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Heal:Invoke(d.HUMAN, basicHeal)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	
		
	end     
	d.DS.Melee:Invoke(hrp, team, onHit,10,6)
	
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 2 - (2 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DeadpoolFrenziedStrikeFInal-item?id=263087281")
	d.PLAY_SOUND(d.HUMAN, 83674171, nil, 1.35)
	
	
	
	
	local damage = ability:C(data.damage)
	local speed = ability:C(data.speed)
	local duration = ability:C(data.duration)
	local recoil = ability:C(data.recoil)
	local Percentrecoil = ability:C(data.Percentrecoil)
local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.ST.StatBuff:Invoke(d.HUMAN, "Speed", speed, duration)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end

	
	d.DS.Damage:Invoke(d.HUMAN, recoil)
	
	d.DS.Damage:Invoke(d.HUMAN, Percentrecoil/100*d.HUMAN.MaxHealth)
	d.DS.Melee:Invoke(hrp, team, onHit,10,6)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	local damage = ability:C(data.damage)
	local heal = ability:C(data.heal)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DeadpoolCycloneDashFinal-item?id=263087529")
	d.PLAY_SOUND(d.HUMAN, 12222208, nil, 1.5)
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local width = 5
	local range = 40
	local speed = range / 0.25
	local team = d.CHAR.Team.Value
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Heal:Invoke(d.HUMAN, heal)
	end
	local function onStep(p, dt)
		topos = p.Position 
	 
	
	d.SFX.Circles:Invoke(topos, 5,script.Parent.Parent.Character.Torso.Skills.Value.Color,.2,dir)
	end
	local function onEnd(p)
		d.HRP.CFrame = p:CFrame()
		
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DeadpoolCycloneDash-Contact-Final-item?id=263088060")
		d.PLAY_SOUND(d.HUMAN, 83674171, nil, 1.2)
		
		local center = d.HRP.Position
		local radius = 12
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Shockwave:Invoke(d.FLAT(center), radius, script.Parent.Parent.Character.Torso.Skills.Value.Color)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 18 - (13 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 16, {BrickColor = d.C( script.Parent.Parent.Character.Torso.Skills.Value.Color)}, 0.3)
	local spark = d.CHAR:FindFirstChild("RampageSparkles", true)
wait(0.15)
	local duration = ability:C(data.duration)
	local heal = ability:C(data.heal)
	
	spark.Enabled = true
	basicHeal = heal
	wait(duration)
	spark.Enabled = false
	basicHeal = 0
end
script.Ability3.OnInvoke = ability3

local dCooldownMin = 1
local dCooldown = dCooldownMin
local dCooldownReset = 0
function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", dCooldown - (dCooldown * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DeadpoolAnnihilateFinal-item?id=263088484")
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 0.45)
	wait(0.15)
	
		
	dCooldown = dCooldown + 1.25
	dCooldownReset = dCooldown + 2.5

	
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	local heal = ability:C(data.heal)
	
	local hitAnEnemy = false
	
	local position = d.CHAR.RightSword.Position
	local direction = d.HRP.CFrame.lookVector
	local width = 5
	local range = 32
	local speed = 80
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		if not hitAnEnemy then
			d.DS.Heal:Invoke(d.HUMAN, heal)
			hitAnEnemy = true
		end
	
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	local function onStep(p, dt)
	end
	local function onEnd()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 2.25, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.5)
	end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Frenzied Strike",
		Desc = "DeadpoolDaMercenary strikes in front of him, dealing <damage> damage as a melee strike and gaining <speed> speed for <duration> seconds if it strikes a target. This ability has a very low cooldown, but costs <Percentrecoil>% + <recoil> health to use.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			Skillz = 0.1,
		},
		speed = {
			AbilityLevel = 1.3,
		},
		duration = {
			Base = 1,
		},
		Percentrecoil = {
			Base = 5,
		},
		recoil = {
			Base = 0,
			AbilityLevel = 2,
		}
	},
	B = {
		Name = "Cyclone Dash",
		Desc = "DeadpoolDaMercenary dashes straight forward. Either at the end of the dash or when he hits an enemy, he stops and deals <damage> damage in an area. If he does hit an enemy, he heals <heal> health.",
		MaxLevel = 5,
		damage = {
			Base = 25,
			AbilityLevel = 10,
			Skillz = 0.25,
		},
		heal = {
			AbilityLevel = 5,
			Health = 0.025,
		},
	},
	C = {
		Name = "Rampage",
		Desc = "For the next <duration> seconds, DeadpoolDaMercenary's basic attacks heal <heal> health if they hit a target.",
		MaxLevel = 5,
		duration = {
			Base = 3.5,
			AbilityLevel = 0.5
		},
		heal = {
			AbilityLevel = 4,
			Health = 0.015,
		}
	},
	D = {
		Name = "Annihilate",
		Desc = "DeadpoolDaMercenary fires a projectile which pierces enemies. It deals <damage> damage to targets it hits, as well as slowing them <slow>% for <duration> seconds. If it hits at least one target, it heals him for <heal> health. This ability has a short cooldown but its cooldown becomes longer the more it is used in rapid succession.",
		MaxLevel = 3,
		damage = {
			Base = 15,
			AbilityLevel = 7.5,
			Skillz = 0.125,
		},
		slow = {
			Base = 30,
			
		},
		duration = {
			Base = 1.5,
		},
		heal = {
			AbilityLevel = 5,
			Health = 0.015,
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 155 + level * 15
	end,
	Skillz = function(level)
		return 5 + level * 0.75
	end,
	Toughness = function(level)
		return 5 + level * 0.75
	end,
	Resistance = function(level)
		return 5 + level * 0.75
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end

--special loop
while true do
	local dt = wait(0.5)
	dCooldownReset = dCooldownReset - dt
	if dCooldownReset <= 0 then
		dCooldownReset = 0
		dCooldown = dCooldownMin
	end
end


--test