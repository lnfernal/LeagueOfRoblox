local uppercut = false
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	
	if uppercut then
		d.CONTROL.AbilityCooldown:Invoke("Q", 1.75 - (d.CONTROL.GetStat:Invoke("BasicCDR") * 1.75))
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChiefBasicAttack2Final-item?id=260275049")
	else
		d.CONTROL.AbilityCooldown:Invoke("Q", 0.25)
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChiefBasicAttack1Final-item?id=260264300")
	end
	uppercut = not uppercut
	
	d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	
	wait(0.05)
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .3
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*0.25, "Toughness", d.PLAYER)
		end 
	end
	d.DS.Melee:Invoke(hrp, team, onHit,10,6) 
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12.5  - (8.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChiefAppearFinal-item?id=260294073")
	wait(.1)
    d.SFX.Bolt:Invoke(d.HRP.Position, 0.7,script.Parent.Parent.Character.Torso.Skills.Value.Color , 0.3)
	d.PLAY_SOUND(d.HUMAN, 12222030, nil, 3)
	local a = d.HRP.Position
	local range = 48
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 14
	local team = d.CHAR.Team.Value
	local buff = 10/100*d.HUMAN.MaxHealth
	d.ST.StatBuff:Invoke(d.HUMAN, "Shields", buff, 4)
	local damage = ability:C(data.damage)
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	d.SFX.Shockwave:Invoke(center, radius,script.Parent.Parent.Character.Torso.Skills.Value.Color , 0.5)
	wait(0.8)

	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Explosion:Invoke(center, radius, script.Parent.Parent.Character.Torso.Skills.Value.Color)
		
	d.TELEPORT(center)
	
	
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12.5  - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChiefStompofJustusFinal-item?id=260348188")
	d.ST.Stun:Invoke(d.HUMAN, .25)
	d.PLAY_SOUND(d.HUMAN, 12222200)
	wait(.215)
	
	local center = d.HRP.Position
	local radius = ability:C(data.range)
	local team = d.CHAR.Team.Value
	local slow = -ability:C(data.slow) / 100
	local duration = ability:C(data.duration)
	
	local function onHit(enemy)
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then
			local position = hrp.Position
			local vector = (d.HRP.Position - position)
			local direction = vector.unit
			local distance = vector.magnitude
			direction = Vector3.new(direction.X, 0, direction.Z).unit
			local speed = distance / 0.2
			local width = 4
			local range = distance
			d.ST.MoveSpeed:Invoke(enemy, slow, duration)
			d.DS.KnockAirborne:Invoke(enemy, 0, .15)
			local function onHit(projectile, enemy)
			end
			local function onStep(projectile)
				hrp.CFrame = CFrame.new(projectile.Position)
			end
			local function onEnd(projectile)
			end
			d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
		end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Shockwave:Invoke(d.FLAT(center), radius, script.Parent.Parent.Character.Torso.Skills.Value.Color)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12.5  - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChiefFistsofJustusFinal-item?id=260394087")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 32, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skills.Value.Color)}, 0.4)
	wait(0.625)
	d.PLAY_SOUND(d.HUMAN, 12222084, nil, 1.5)
	
	local center = d.HRP.Position
	local radius = 12
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
			d.DS.KnockAirborne:Invoke(enemy, 16, 1)
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Artillery:Invoke(center, radius, script.Parent.Parent.Character.Torso.Skills.Value.Color)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 50  - (50 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChiefForGreatJustusFinal-item?id=260660596")
	wait(.15)
	d.SFX.Bolt:Invoke(d.HRP.Position, 1, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.35)
	
	local center = d.HRP.Position
	local radius = 30
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local buff = ability:C(data.buff)
	local duration = ability:C(data.duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "Skillz", buff/2, 4)
	
	local function onHit(ally)
		if not game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then return end
		if game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) == game:GetService("Players"):GetPlayerFromCharacter(d.CHAR) then
		else
		d.ST.StatBuff:Invoke(ally, "Skillz", buff, duration)
		d.ST.StatBuff:Invoke(ally, "H4x", buff, duration)
		end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Shockwave:Invoke(center, radius, script.Parent.Parent.Character.Torso.Skills.Value.Color)
	d.SFX.Explosion:Invoke(center, radius / 2, script.Parent.Parent.Character.Torso.Skills.Value.Color)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Appear",
		Desc = "ChiefJustus appears at the target location in a flash, dealing <damage> damage. As he prepares to appear at the targeted location, he provides himself with some backup by converting 10% of his maximum health as a shield for 4 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 10,
			Skillz = 0.35,
			
		}
	},
	B = {
		Name = "Stomp of Justus",
		Desc = "ChiefJustus draws enemies within <range> studs to himself and slows them by <slow>% for <duration> seconds.",
		MaxLevel = 5,
		range = {
			Base = 16,
			AbilityLevel = 0.75,
		},
			slow = {
			Base = 35,
			
		},
		duration = {
			Base = 2.25,
			
		}
	},
	C = {
		Name = "Fists of Justus",
		Desc = "ChiefJustus deals <damage> damage to nearby enemies and knocks them airborne briefly.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 15,
			Skillz = 0.45,
		}
	},
	D = {
		Name = "For Great Justus",
		Desc = "ChiefJustus increases the H4x and Skillz of nearby allies by <buff> for <duration> seconds while granting himself half of it for 4 seconds.",
		MaxLevel = 3,
		buff = {
			
			AbilityLevel = 20,
			Skillz = 0.5,
		},
		duration = {
			Base = 2.5,
			
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 145 + level * 15
	end,
	Skillz = function(level)
		return 3 + level * .75
	end,
	H4x = function(level)
		return 3 + level * 1
	end,
	Toughness = function(level)
		return 5 + 0.75 * level
	end,
	Resistance = function(level)
		return 5 + 0.5 * level
	end,
	Speed = function(level)
		return 15.75 + level * 0.125
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test