function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.3 - (1.3 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .25
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DailyBasicAttackFinal-item?id=263112711")
	d.PLAY_SOUND(d.HUMAN, 12222216, nil, 1.25)
	wait(0.3)
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.PLAY_SOUND(enemy, 96667969)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Toughness", d.PLAYER)
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
	local damage = ability:C(data.damage)
	local buff = ability:C(data.buff)/100
	local duration = ability:C(data.duration)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DailyShieldDashFinal-item?id=271406264")
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 32
	local speed = range / 0.75
	local width = 6
	local team = d.CHAR.Team.Value
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local function onHit(p, enemy)
		local hrp = d.GET_HRP(enemy)
		if hrp then
			d.SFX.Explosion:Invoke(hrp.Position, 3, tostring(d.CHAR.Torso.Skills.Value))
			d.PLAY_SOUND(enemy, 92597264)
		end
		
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", d.CONTROL.GetStat:Invoke("Toughness") * buff, duration)
		else
			buff = buff/2
			d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", d.CONTROL.GetStat:Invoke("Toughness") * buff, duration)
		end
	end
	local function onStep(p, dt)
		topos = p.Position 

	end
	local function onEnd(p, dt)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
	repeat
	wait(.1)
	circles = circles + 1
	d.SFX.Circles:Invoke(topos, 6,tostring(d.CHAR.Torso.Skills.Value),.2,dir)
	until circles == 4
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 15  - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 16, {BrickColor = d.C(tostring(d.CHAR.Torso.Skills.Value))}, 0.3)
	wait(0.3)
	local position = d.HRP.Position
	local radius = ability:C(data.range)
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local function onHit(ally)
		d.DB(Instance.new("ForceField", ally.Parent), 1)
	end
	local myteam = d.CHAR.Team.Value
	local function onHitEnemy(enemy)
		d.ST.MoveSpeed:Invoke(enemy, -.25, 3) 
	end
	d.DS.AOE:Invoke(position, radius, team, onHit)
	d.DS.AOE:Invoke(position, radius, myteam, onHitEnemy)
	d.SFX.Explosion:Invoke(position, radius, tostring(d.CHAR.Torso.Skills.Value))
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 15  - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DailyShieldBashFinal-item?id=263113149")
	wait(0.15)
local hrp = d.HRP
	
	local team = d.CHAR.Team.Value
	local function onHit(enemy) 
		d.PLAY_SOUND(enemy, 96626016)
		d.ST.Stun:Invoke(enemy, duration)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			d.CONTROL.PermBuff:Invoke("Toughness", 1)
		else
			d.CONTROL.PermBuff:Invoke("Toughness", 0.5)
		end
	end
	d.DS.Melee:Invoke(hrp, team, onHit,8.5,7) 	
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 60  - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local duration = ability:C(data.duration)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DailyBellofBronzeFinal-item?id=263113445")
	wait(0.5)
	d.PLAY_SOUND(d.HUMAN, 138258242)
	
	local position = d.CHAR.DailyShield.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 25
	local range = speed * 4
	local width = 9
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		d.ST.MoveSpeed:Invoke(enemy, -1, duration)
	end
	local function onStep(p, dt)
	end
	local function onEnd(p, dt)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 10, tostring(d.CHAR.Torso.Skills.Value), 0.1)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "DONKEY!",
		Desc = "Shrek charges forward, shield raised, dealing <damage> damage to targets hit. He also increases his toughness by <buff>% for <duration> seconds for each target hit. The bonus is halfed on non-players.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 10,
			Skillz = 0.4,
		},
		buff = {
			Base = 20,
			
		},
		duration = {
			Base = 4,
		}
	},
	B = {
		Name = "Orges Have Layers",
		Desc = "Shrek creates a magical field of LAYERS <range> studs in radius which grants his allies a moment of invincibility. Enemies who are nearby will be slowed by 25% for 3 seconds.",
		MaxLevel = 5,
		range = {
			Base = 12,
			AbilityLevel = 1,
		}
	},
	C = {
		Name = "Get Shrekt",
		Desc = "Shrek bashes with his shield. He deals <damage> damage as a melee attack and stuns the target for <duration> seconds. Also, he permanently gains 1 Toughness. The bonus is halfed on non-players.",
		MaxLevel = 5,
		damage = {
			Base = 40,
			AbilityLevel = 15,
			Toughness = 0.5,
		},
		duration = {
			Base = 1.5,
			
		},
	},
	D = {
		Name = "Better Out Than In",
		Desc = "Shrek creates a sound wave with his shield. It travels straight forward, rooting enemies it hits for <duration> seconds.",
		MaxLevel = 3,
		duration = {
			Base = 1.05,
			AbilityLevel = 0.4,
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
	Skillz = function(level)
		return 0
	end,
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test