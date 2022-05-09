local NOTE = Instance.new("Part")
NOTE.Anchored = true
NOTE.CanCollide = false
NOTE.FormFactor = "Custom"
NOTE.Size = Vector3.new(1, 1, 1)
local mesh = Instance.new("SpecialMesh", NOTE)
mesh.MeshId = "http://www.roblox.com/asset/?id=1088207"
mesh.TextureId = "http://www.roblox.com/asset/?id=1088099"
mesh.Scale = Vector3.new(0.1, 0.1, 0.1)

local NOTE2 = Instance.new("Part")
NOTE2.Anchored = true
NOTE2.CanCollide = false
NOTE2.FormFactor = "Custom"
NOTE2.Size = Vector3.new(1, 1, 1)
local mesh2 = Instance.new("SpecialMesh", NOTE2)
mesh2.MeshId = "http://www.roblox.com/asset/?id=151980473"
mesh2.TextureId = "http://www.roblox.com/asset/?id=151980512"
mesh2.Scale = Vector3.new(1.1,1.1,1.1)

function guitarSoundId()
	local list = {
		1089404,
		1089405,
		1089406,
		1089403,
		1089410,
		1089407,
	}
	return list[math.random(1, #list)]
end

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/JackBasicFinal-item?id=261998996")
	d.PLAY_SOUND(d.HUMAN, guitarSoundId(), 1)

	local position = d.CHAR.Guitar.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
	local part = NOTE:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(math.pi/2, 0, 0))
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,"Eggplant", 0.25,direction,"Neon",0.039) 
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 10)

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/JackBasicFinal-item?id=261998996")
	d.PLAY_SOUND(d.HUMAN, guitarSoundId(), 1, 1.2)
	
	local damage = ability:C(data.damage)
	local heal = ability:C(data.heal)
	
	local center = d.HRP.Position
	local radius = 15
	local tagName = d.PLAYER.Name.."POWER!"
	local team = d.CHAR.Team.Value
	local function onHit(enemy) 
	d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER) 
	if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	local team = d.GET_OTHER_TEAM:Invoke(team)
	local function onHit(ally)
		d.DS.Heal:Invoke(ally, heal)
		local hrp = d.GET_HRP(ally)
		if hrp then
			if d.ST.GetEffect:Invoke(ally, tagName) then
				d.DS.Heal:Invoke(ally, heal*0.5)
			
		
		
			end 
			end
	end 
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Explosion:Invoke(center, radius, "White")
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 18 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	local duration = ability:C(data.duration)
	local speed = ability:C(data.speed)/100
	local buff = ability:C(data.buff)
	local tagName = d.PLAYER.Name.."POWER!"
	local radius = 15
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	
	local t = 0
	while t < duration do
		local dt = wait(0.5)
		t = t + dt
		
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/JackBasicFinal-item?id=261998996")
		d.PLAY_SOUND(d.HUMAN, guitarSoundId(), 1, 0.9)
		
		local center = d.HRP.Position
			 
		local function onHit(ally)
		
		if game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then 
			d.ST.MoveSpeed:Invoke(ally, speed, dt)
			d.ST.StatBuff:Invoke(ally, "Resistance", buff, dt) 
			else
			d.ST.MoveSpeed:Invoke(ally, speed, dt)   
			end 
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Explosion:Invoke(d.FLAT(center), radius, "White")
	end
end
script.Ability2.OnInvoke = ability2
function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 18 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local center2 = d.HRP.Position
d.SFX.ReverseExplosion:Invoke(center2, 14, "Eggplant", 0.2) 
    
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/JackBasicFinal-item?id=261998996")
	d.PLAY_SOUND(d.HUMAN, guitarSoundId(), 1, 1)
	local a = d.HRP.Position
	local range = 32
	local damage = ability:C(data.damage)
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
		d.SFX.Shockwave:Invoke(center, 18, "Eggplant",.45)
		wait(0.45)
	local radius = 18
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local team2 = d.CHAR.Team.Value
	local duration = 4
	local debuff = -ability:C(data.debuff)
	local tagName = d.PLAYER.Name.."POWER!"
	local t = 0
	d.SFX.AreaAOEStart:Invoke(d.FLAT(center), radius, "Eggplant",duration)
	while t < duration do
		local dt = wait(0.5)
		t = t + dt 

		local function onHit(enemy)
			if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then 
			d.ST.StatBuff:Invoke(enemy, "Skillz", debuff, dt)
				d.ST.StatBuff:Invoke(enemy, "H4x", debuff, dt) 
				d.ST.MoveSpeed:Invoke(enemy, -.15, dt)
				d.DS.Damage:Invoke(enemy, damage*dt, "Resistance", d.PLAYER)  
				if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*0.5, "Toughness", d.PLAYER)
		end 
				d.SFX.PartRandomFollow:Invoke(enemy.Parent.Torso, 1.5, "Eggplant")
			else
				d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)   
				end
		
		end
		d.DS.AOE:Invoke(center, radius, team2, onHit)
		local function onHit(ally)
			d.ST.Tag:Invoke(ally, 5, tagName,"POWER!") 
			
		end
		
		
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Artillery:Invoke(center, 4, "Eggplant", 0.5)
		
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 60 - (50 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 16, {BrickColor = d.C("Sea green")}, 0.375)
	local duration = ability:C(data.duration)
	
	local a = d.HRP.Position
	local range = 128
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 18.4
	local team = d.CHAR.Team.Value
	--local damage = ability:C(data.damage)
	local function onHit(enemy)
		--d.ST.DOT:Invoke(enemy, damage, 1, "Resistance", d.PLAYER, "POWER!")
		d.DS.KnockAirborne:Invoke(enemy, 18.4, duration)
	end
	d.SFX.Artillery:Invoke(center, 4, "Bright green", 0.75)
	wait(0.75)
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Artillery:Invoke(center, radius, "Dark green", duration)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Guitars Are Better Than Trees",
		Desc = "JacksSmirkingRevenge plays a power chord on his guitar, dealing <damage> damage to nearby enemies but healing <heal> health nearby allies. If your allies and yourself are within the field, activating this ability will heal you and your allies 50% more.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 5,
			H4x = .3,
		},
		heal = {
			Base = 5,
			AbilityLevel = 3.5,
			H4x = 0.2,
		},
	},
	B = {
		Name = "Solo",
		Desc = "JacksSmirkingRevenge plays a solo on his guitar for <duration> seconds, increasing the speed of nearby allies by <speed>% and buffing their Resistance by <buff>.",
		MaxLevel = 5,
		duration = {
			Base = 4.5,
			
		},
		speed = {
			Base = 12.5,
			AbilityLevel = 3.5,
			
		},
		buff = {
			Base = 10,
			AbilityLevel = 35,
			
			
		},
	},
	C = {
		Name = "Up To Eleven",
		Desc = "[Innate] POWER! empowers his power chord (Guitars Are Better Than Trees). [Active] JacksSmirkingRevenge summons the field of POWER! which grants POWER! to allies and himself. Enemies within the field will be slowed by 15%, take <damage> per second, get <debuff> decreased Skillz and H4x for <duration> seconds.",
		MaxLevel = 5,
		debuff = {
			Base = 12,
			AbilityLevel = 4,
			H4x = 0.25,
		},
		duration = {
			Base = 4
			}, 
		damage = { 
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.15, 
		   
			
		},
	},
	D = {
		Name = "The B.A.",
		Desc = "The B.A. drops in from orbit and uses his ship to hold airborne enemies at the targeted location for <duration> seconds.",
		MaxLevel = 3,
		duration = {
			Base = .8,
			AbilityLevel = 0.4
		},
		
		--[[damage = {
			Base = 40,
			AbilityLevel = 9,
			H4x = 0.3,
		 }, ]]
	    
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 150 + level * 12.5
	end,
	H4x = function(level)
		return 4 + level * 1.5
	end,
	Toughness = function(level)
		return 5 + 0.5 * level
	end,
	Resistance = function(level)
		return 5 + 0.5 * level
	end,
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test