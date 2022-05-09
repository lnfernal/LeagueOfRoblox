function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.15 - (1.15 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .4
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BooBasicAttackFinal-item?id=263104493")
	wait(0.3)
	d.PLAY_SOUND(d.HUMAN, 12814239, 1)
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		
		
	end
	d.DS.Melee:Invoke(hrp, team, onHit,10,6)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 9 - (9 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BooBonkFinal-item?id=263104972")
	wait(0.62)
	d.PLAY_SOUND(d.HUMAN, 12814239, 1, 0.7)
	
	local range = 12
	local width = 6
	local team = d.CHAR.Team.Value
	local direction = d.HRP.CFrame.lookVector
	local position = d.HRP.Position
	local function onHit(enemy)
		d.ST.Stun:Invoke(enemy, duration)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	d.SFX.Line:Invoke(position, direction, range, width, "Br. yellowish green")
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 20 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	local slow = -ability:C(data.slow)/100
	local heal = ability:C(data.heal)
	local numofbites = ability:C(data.bites)
	local slowduration = 1.25
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BooNom-Startup-Final-item?id=263105325")
	wait(0.4)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BooNom-Active-Final-item?id=263105545")
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 30
	local speed = 60
	local width = 6
	local team = d.CHAR.Team.Value
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local function onHit(p, enemy)
		p.Moving = false
		
		local hrp = d.GET_HRP(enemy)
		if hrp then
			d.ST.Stun:Invoke(d.HUMAN, duration)
			d.ST.MoveSpeed:Invoke(enemy, slow, slowduration)
			d.SFX.Attachment:Invoke(hrp, d.HRP, CFrame.new(0, 0, 1), duration)
			
			for i = 1, numofbites do
				d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BooNom-Eating-Final-item?id=263105949")
				d.PLAY_SOUND(d.HUMAN, 13075805, 1, 0.9 + math.random() * 0.2)
				
				d.DS.Heal:Invoke(d.HUMAN, heal)
				d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
				wait(duration)
			end
		end
	end
	local function onStep(p)
		topos = p.Position 
	end
	local function onEnd(p)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
	repeat
	wait(.1)
	circles = circles + 1
	d.SFX.Circles:Invoke(topos, 6,"White",.2,dir, "Neon") 
	until circles == 3
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 16 - (16 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BooBadBreath-Startup-Final-item?id=263106163")
	d.SFX.ReverseExplosion:Invoke(d.CHAR.Head.CFrame:pointToWorldSpace(Vector3.new(0, 0, -1)), 2, "White")
	wait(0.3)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BooBadBreath-Active-Final-item?id=263106477")
	wait(0.1)
	
	local shred = -ability:C(data.shred) / 100
	local duration = ability:C(data.duration)
	
	local position = d.CHAR.Head.Position
	local direction = d.HRP.CFrame.lookVector
	local damage = ability:C(data.poison)/100 * d.HUMAN.MaxHealth
	local range = 48
	local speed = range / 1
	local width = 8
	local team = d.CHAR.Team.Value
		local function onHit(p, enemy)
			d.ST.DOT:Invoke(enemy, damage, 2, "Toughness", d.PLAYER, "Suffocating!")
			if enemy.Parent.Name == "Minion" then
			d.ST.DOT:Invoke(enemy, damage*1,2, "Toughness", d.PLAYER)
		end 
		if enemy.Parent then
			local gs = enemy.Parent:FindFirstChild("GetStat", true)
			if gs then
				local res = gs:Invoke("Skillz" and "H4x")
				local debuff = res * ability:C(data.shred)/100
				d.ST.StatBuff:Invoke(enemy, "Skillz", -debuff, duration)
				d.ST.StatBuff:Invoke(enemy, "H4x", -debuff, duration) 
				end
			end
		end
	local function onStep(p, dt)
	end
	local function onEnd(p)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 4, "Pastel green", 0.1)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 45 - (45 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BooBellyFlop-Startup-Final-item?id=263106831")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 24, {BrickColor = d.C("White")}, 0.75)
	d.SFX.Shockwave:Invoke(d.HRP.Position, 4, "White")
	wait(0.625)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BooBellyFlop-Active-Final-item?id=263107081")
d.CONTROL.AbilityCooldownLag:Invoke("A", 0.8)
	d.CONTROL.AbilityCooldownLag:Invoke("B", 0.8)
	d.CONTROL.AbilityCooldownLag:Invoke("C", 0.8)
	local position = d.HRP.Position
	local b = d.MOUSE_POS
	local maxRange = 56
	local target = d.DS.Targeted:Invoke(position, maxRange, b)
	target = Vector3.new(target.X, position.Y, target.Z)
	local direction = (target - position).unit
	local range = (target - position).magnitude
	local speed = 80
	local width = 8
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local radius = 15
	local function onHit(projectile, enemy)
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		d.HRP.CFrame = projectile:CFrame()
		
		d.PLAY_SOUND(d.HUMAN, 12222124, nil, 1)
		local center = d.HRP.Position
		local function onHit(enemy)
			d.DS.KnockAirborne:Invoke(enemy, 24, duration)
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Shockwave:Invoke(d.HRP.Position, 16, "White")
	end
	local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjLeap:Invoke(p:ClientArgs(), d.HRP, 32)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Bonk!",
		Desc = "bOOandya bonks everyone immediately in front of him, dealing <damage> damage and stunning them for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 7.5,
			Skillz = 0.325,
		},
		duration = {
			Base = 0.75,
			AbilityLevel = 0.25,
		}
	},
	B = {
		Name = "Nom Nom Brainz",
		Desc = "bOOandya dashes forward. The first target he hits, he attaches to and noms their brains, dealing <damage> damage and slowing them <slow>% for 1.25 seconds, he noms <bites> time/s each bite taking <duration> seconds to complete. Each bite also heals him for <heal> health.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			Skillz = 0.05
		},
		slow = {
			Base = 50,
		
		},
		heal = {
			Health = .04,
		},
		bites = {
			Base = 5, 	
		},
		duration = {
			Base = 0.25,
		
		}
	},
	C = {
		Name = "Bad Breath",
		Desc = "bOOandya breathes noxious fumes ahead of him. The bad air puts enemies hit in a bad, bad way, causing their Skillz and H4x to drop by <shred>% for <duration> seconds. The foul fumes also deal <poison>% of b00andya's health as damage for 2 seconds.",
		MaxLevel = 5,
		shred = {
			Base = 25,
			
		},
		poison = {
			Base = 8,  
		},
		duration = {
			Base = 2.75,
			AbilityLevel = 0.25,
		},
	},
	D = {
		Name = "Belly Flop!",
		Desc = "bOOandya belly flops onto the targeted location. Where he lands, enemies are knocked airborne for <duration> seconds, as well as taking <damage> damage.",
		MaxLevel = 3,
		duration = {
			Base = 1.25,
			
		},
		damage = {
			Base = 55,
			AbilityLevel = 17.5,
			Health = 0.09,
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