local fireColors = {"Bright red", "Neon orange", "Bright yellow"}
function fireColor()
	return fireColors[math.random(1, #fireColors)]
end

function fireEffect(effect, position, radius)
	for index = 1, 3 do
		effect:Invoke(position, radius * (1 / index), fireColors[index])
	end
end

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NobleBasicAttackFinal-item?id=263050452")
	d.PLAY_SOUND(d.HUMAN, 12222216)
	local hrp = d.HRP
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.25
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
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
	d.CONTROL.AbilityCooldown:Invoke("A", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NobleFireBreath-Startup-Final-item?id=263050899")
	d.SFX.ReverseExplosion:Invoke(d.CHAR.Head.CFrame:pointToWorldSpace(Vector3.new(0, 0, -1)), 2, "White")
	wait(0.3)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NobleFireBreath-Active-Final-item?id=263051271")
	d.PLAY_SOUND(d.HUMAN, 83674171)
	wait(0.1)
	
	local slow = -ability:C(data.slow)/100
	local damage = ability:C(data.damage)
	
	local hitAnEnemy = false
	
	local position = d.CHAR.Head.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 48
	local speed = range / 0.8
	local width = 3.5
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		hitAnEnemy = true
		p.Moving = false
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		if hitAnEnemy then 
			local center = p.Position
			local radius = 15
			local function onHit(enemy)
				d.ST.MoveSpeed:Invoke(enemy, slow, 2.5)
				d.ST.DOT:Invoke(enemy, (enemy.MaxHealth * .05) + damage, 2, "Toughness", d.PLAYER, "rest in pieces life")
			end
			d.DS.AOE:Invoke(center, radius, team, onHit)
			fireEffect(d.SFX.Explosion, center, radius)
		end
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 1, fireColor(), 0.2)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NobleBreakRanks-Startup-Final-item?id=263051817")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 12, {BrickColor = d.C("Neon orange")}, 0.35)
	wait(0.5)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NobleBreakRanks-Active-Final-item?id=263052109")
	d.PLAY_SOUND(d.HUMAN, 83674171)
	
	local damage = ability:C(data.damage)
	
	
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 48
	local speed = range / 0.4
	local width = 6
	local team = d.CHAR.Team.Value
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local function onHit(p, enemy)
		local hrp = d.GET_HRP(enemy)
		if hrp then
			local spin = d.CHOOSE({math.pi / 4, -math.pi / 4})
			local position = hrp.Position
			local direction = (p:CFrame() * CFrame.Angles(0, spin, 0)).lookVector
			local range = 16
			local speed = range / 0.2
			local width = 0
			local function onHit()
			end
			local function onStep(p, dt)
				hrp.CFrame = p:CFrame()
			
	 
			end
			local function onEnd()
			end
			d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
		end
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	local function onStep(p, dt)
			topos = p.Position 
	 
	

	end
	local function onEnd(p)
		d.HRP.CFrame = p:CFrame()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	local args = p:ClientArgs()
	d.SFX.ProjDash:Invoke(args, d.HRP)
	d.SFX.ProjMeander:Invoke(args, 2, fireColor(), 0.2)
	repeat
	wait(.1)
	circles = circles + 1
	d.SFX.Circles:Invoke(topos, 6,"Bright red",.2,dir)
	until circles == 4
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 17.5 - (17.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local t = 0 + d.HRP.Position.Y
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NobleNobleFlight-Startup-Final-item?id=263052472")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 24, {BrickColor = d.C("Bright yellow")}, 0.35)
	wait(0.5)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NobleNobleFlight-Active-Final-item?id=263052705")
	d.PLAY_SOUND_POS(d.HRP.Position, 84937942)
	
	local damage = ability:C(data.damage)
	
	
	
	local center = d.HRP.Position
	local radius = 14
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		local hrp = d.GET_HRP(enemy)
		if hrp then
			local position = hrp.Position
			local direction = (position - center).unit
			local range = 48
			local speed = range / 0.2
			local width = 0
			local function onHit()
			end
			local function onStep(p, dt)
				hrp.CFrame = p:CFrame()
			end
			local function onEnd()
			end
			--d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, false)
		end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.DS.KnockAirborne:Invoke(d.HUMAN, 32, .75)
	fireEffect(d.SFX.Explosion, center, radius)
	wait(.75)
	local a = d.HRP.Position
	local b = d.GET_MOUSE_POS:InvokeClient(d.PLAYER)
	
	local maxRange = 75
	local target = d.DS.Targeted:Invoke(a, maxRange, b)
	target = Vector3.new(target.X, t, target.Z)
	local position = a
	local direction = (target - position).unit
	local range = (target - position).magnitude
	local speed = 96
	local width = 0
	local function onHit()
	end
	local function onStep(p, dt)
		
		
	end
	local function onEnd(p)
		d.HRP.CFrame = p:CFrame()
		
		local center = d.HRP.Position
		local radius = 16
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
			d.DS.KnockAirborne:Invoke(enemy, 16, 1)
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		fireEffect(d.SFX.Shockwave, center, radius)
		d.PLAY_SOUND(d.HUMAN, 12222084)
		
		d.STEADY()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	local args = p:ClientArgs()
	d.SFX.ProjDash:Invoke(args, d.HRP)
	d.SFX.ProjMeander:Invoke(args, 2, fireColor(), 0.2)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 90)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NobleDragonblendCoffeeFinal-item?id=263053005")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 12, 48, {BrickColor = d.C("Bright red")}, 0.2)
	
	local speed = ability:C(data.speed)/100
	local health = ability:C(data.health)/100
	local duration = ability:C(data.duration)
	
	local boost = health * d.HUMAN.MaxHealth
	d.ST.StatBuff:Invoke(d.HUMAN, "Health", boost, duration)
	d.ST.MoveSpeed:Invoke(d.HUMAN, speed, duration * 0.25)
	delay(0.35, function()
		d.DS.Heal:Invoke(d.HUMAN, boost)
	end)
	
	d.DB(Instance.new("Fire", d.CHAR.Torso), duration)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Fire Breath",
		Desc = "NobleDragon spews a fireball which explodes if it hits a target. The explosion deals 5% of hit enemies max health as well as <damage> damage over 3 seconds and slows <slow>% for 2.5 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 10,
			Skillz = .3,
		},
		slow = {
			Base = 25,
			AbilityLevel = 3.5,
		},
	},
	B = {
		Name = "Break Ranks",
		Desc = "NobleDragon charges forward in a fiery spin, dealing <damage> damage to them and knocking them aside.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 15,
			Skillz = 0.35,
		},
	},
	C = {
		Name = "Noble Flight",
		Desc = "NobleDragon blasts off from the ground. After a moment in the air, he crashes to the ground at the targeted location, dealing <damage> damage and knocking airborne to enemies he hits. This damage scales with NobleDragon's maximum health.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 10,
			Health = 0.06,
	
		},
	},
	D = {
		Name = "Dragonblend Coffee Chug",
		Desc = "NobleDragon temporarily increases his movement speed by <speed>% and increases his health by <health>% of max health for <duration> seconds. The speed buff only lasts for one quarter of the duration.",
		MaxLevel = 3,
		speed = {
			
			AbilityLevel = 25,
		},
		health = {
			AbilityLevel = 10,
		},
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