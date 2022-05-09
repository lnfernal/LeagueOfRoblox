function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.125 - (1.125 * d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/GuestBasicFinal-item?id=260609436")
	d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	
	wait(0.05)
	
	local damage = d.CONTROL.GetStat:Invoke("H4x") * .25
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
	d.CONTROL.AbilityCooldown:Invoke("A", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 16, {BrickColor = d.C(("Baby blue"))}, 0.3)
	wait(0.3)
	d.SFX.Shockwave:Invoke(d.FLAT(d.HRP.Position), 8, "Baby blue")
	
	
	local duration = ability:C(data.duration)
	local moveBoost = ability:C(data.percent)/100
	d.DS.Stealth:Invoke(d.CHAR, duration)
	d.ST.MoveSpeed:Invoke(d.HUMAN, moveBoost, duration)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
  wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/GuestSafeChatFinal-item?id=260610843")
	
	local center = d.HRP.Position
	local radius = 14
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.percent)/100
	local function onHit(enemy)
		d.CONTROL.AbilityCooldownReduce:Invoke("B", 0.3)
			d.CONTROL.AbilityCooldownReduce:Invoke("D", 0.3)
		d.ST.MoveSpeed:Invoke(enemy, slow, 2)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Explosion:Invoke(center, radius, "Baby blue")
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/GuestIgnoranceFinal-item?id=260626191")
	d.PLAY_SOUND(d.HUMAN, 12221944)
	
	local buff = ability:C(data.buff)
	local duration = ability:C(data.duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", buff, duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "Resistance", buff, duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "H4x", buff, duration)
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 32, {BrickColor = d.C("Baby blue")}, 0.25)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 55 - (55 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/GuestReportAbuseFinal-item?id=260632538")
	d.SFX.Bolt:Invoke(d.HRP.Position, 0.4, "Black", 0.25)
	wait(0.25)
	d.PLAY_SOUND(d.HUMAN, 12222152, nil, 1.25)
	d.SFX.Bolt:Invoke(d.HRP.Position, 0.4, "Black", 0.35)
	wait(0.35)

	
	local position = d.CHAR["Head"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 64
	local width = 6
	local range = 30
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	local function onHit(projectile, enemy)
		d.SFX.Artillery:Invoke(d.FLAT(projectile.Position), 4, "Baby blue")
		d.ST.Stun:Invoke(enemy, duration)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 3, "Baby blue", 0.4)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Anonymity",
		Desc = "Being anonymous, the guest turns invisible for <duration> seconds. He also gains <percent>% move speed during this effect.",
		MaxLevel = 5,
		duration = {
			Base = 2,
			
		},
		percent = {
			Base = 40,
			AbilityLevel = 10,
		},
	},
	B = {
		Name = "Safe Chat",
		Desc = "The guest says a safe chat, bothering nearby enemies to deal <damage> h4x damage, and slow them by <percent>% for 2 seconds. Each enemy hit also reduces Safe Chat and Report Abuse's cooldown by 0.3 seconds, because the guest, of course, gains energy from annoying many people.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 20,
			H4x = 0.3,
		},
		percent = {
			Base = 45,
	
		},
	},
	C = {
		Name = "Ignorance",
		Desc = "The guest ignores the rules of the League of ROBLOX and thusly he becomes stronger. He gains <buff> H4x, Toughness and Resistance for <duration> seconds.",
		MaxLevel = 5,
		buff = {
			AbilityLevel = 8,
			H4x = .15, 
		},
		duration = {
			Base = 4
		},
	},
	D = {
		Name = "Report Abuse",
		Desc = "No one is safe from a reporting guest. No one. He fires a short-range piercing projectile which stuns each enemy hit for <duration> seconds as well as dealing <damage> h4x damage.",
		MaxLevel = 3,
		duration = {
			Base = 1.75,
			AbilityLevel = .25,
		},
		damage = {
			Base = 30,
			AbilityLevel = 15,
			H4x = 0.4,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 150 + level * 20
	end,
	Skillz = function(level)
		return 10
	end,
	H4x = function(level)
		return 4 + 2.75 * level
	end,
	Toughness = function(level)
		return 5 + 0.5 * level
	end,
	Resistance = function(level)
		return 5 + 0.75 * level
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test