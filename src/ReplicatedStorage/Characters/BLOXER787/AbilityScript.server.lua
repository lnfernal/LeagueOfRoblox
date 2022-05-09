local LOCK = true
script.UnlockUltimate.Event:connect(function()
	LOCK = false
end)

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.125 -(1.125 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/GuestBasicFinal-item?id=260609436")
	d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	
	wait(.05)
	
	local damage = d.CONTROL.GetStat:Invoke("H4x") * .25
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
		if LOCK == false then
			d.ST.MoveSpeed:Invoke(d.HUMAN, .1, 3)
		end
	end
	d.DS.Melee:Invoke(hrp, team, onHit,10,6)  
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 16 - (16 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local teamObj = d.GET_TEAM_OBJ(d.HUMAN)
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C(teamObj.Color.Name)}, 0.4)
	wait(.4)
	
	local damage = ability:C(data.damage)
	
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	local tagName = d.PLAYER.Name.."Hired"
	local team = d.CHAR.Team.Value
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 56
	local width = 4.5
	local range = 45
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Symmetric"
	part.Size = Vector3.new(2, 2, 2)
	part.Shape = "Ball"
	part.BrickColor = BrickColor.new(teamObj.Color.Name)
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
	part.Parent = workspace
	local topos = Vector3.new(0,0,0)
	local circles = 0
	d.DB(part)
	local dir = d.HRP.Rotation
	local function onHit(p, enemy)
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			p.Moving = false
			d.ST.DOT:Invoke(enemy, damage, 2 + duration, "Resistance", d.PLAYER, "Hired!")
			d.ST.Tag:Invoke(enemy, 16, tagName)
			part:Destroy()
			wait(2)
			d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		end
	end
	local function onStep(projectile)
		topos = projectile.Position
	end
	local function onEnd(projectile)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,(teamObj.Color.Name), 0.25,direction,"Neon",0.039)
	repeat 
	wait(.1) 
	circles = circles + 1
	d.SFX.Circles:Invoke(topos, 4.5,(teamObj.Color.Name),.2,dir) 
	until circles == 6
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
		wait(0.35)

	local damage = ability:C(data.damage)
	local center = d.HRP.Position
	local radius = 15
	local team = d.CHAR.Team.Value
	local tagName = d.PLAYER.Name.."Hired"
	local duration = ability:C(data.duration)
	
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		local hrp = d.GET_HRP(enemy)
		if hrp then
			if d.ST.GetEffect:Invoke(enemy, tagName) then
				d.ST.Stun:Invoke(enemy, duration)
			end
		end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Explosion:Invoke(center, radius, d.CHAR.Torso.Skills.Value.Color)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 13.5 - (13.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/1x1x1x1DataminingFinal-item?id=261282176")
	local tagName = d.PLAYER.Name.."Hired"
	local damage = ability:C(data.damage)
	local range = ability:C(data.range)
	local damageamp = ability:C(data.percent)/100
	local teamObj = d.GET_TEAM_OBJ(d.HUMAN)

	local pos = d.HRP.Position
	local tem = d.CHAR.Team.Value
	local target = d.DS.NearestTarget:Invoke(d.HRP.Position, range, tem)
	if target then
		local hrp = d.GET_HRP(target)
		if hrp then
			wait(.5)
			d.DS.Damage:Invoke(target, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
			if d.ST.GetEffect:Invoke(target, tagName) then
				d.DS.Damage:Invoke(target, damageamp * damage, nil, d.PLAYER)
				end
			d.SFX.Artillery:Invoke(hrp.Position, 4, "Black")
			d.SFX.Artillery:Invoke(d.HRP.Position, 4, "White")
		end
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 60 - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local bonusdamage = ability:C(data.bonusdamage)
	local duration = ability:C(data.duration)
	local debuff = -ability:C(data.debuff)
	local tagName = d.PLAYER.Name.."Hired"
	local teamObj = d.GET_TEAM_OBJ(d.HUMAN)
	
	local a = d.HRP.Position
	local range = 128
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 24
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		local hrp = d.GET_HRP(enemy)
		if hrp then
			if d.ST.GetEffect:Invoke(enemy, tagName) then
				d.ST.StatBuff:Invoke(enemy, "Skillz", debuff, duration)
				d.ST.StatBuff:Invoke(enemy, "H4x", debuff, duration)
				d.DS.Damage:Invoke(enemy, bonusdamage, "Resistance", d.PLAYER)
			end
		end
	end
	d.SFX.Artillery:Invoke(center, 6, teamObj.Color.Name, 1.5)
	wait(1.75)
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Artillery:Invoke(center, radius, d.CHAR.Torso.Skills.Value.Color)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Hiring",
		Desc = "BLOXER787 forcefully hires an enemy champion to work for his team, causing them to take <damage> damage over <duration2> seconds. After 2 seconds they are slowed <slow>% for <duration> seconds from the pain. This also marks them with the 'Hired' effect.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 10,
			H4x = .3,
		},
		slow = {
			Base = 27.5,
			AbilityLevel = 2.5,
		},
		duration = {
			Base = 1.25,
			AbilityLevel = .25,
		},
		duration2 = {
			Base = 3.25,
			AbilityLevel = .25,
		},
	},
	B = {
		Name = "Work",
		Desc = "BLOXER787 begins working, causing enemies nearby to start going crazy and take <damage> damage. If an enemy hit is his 'Hired' balancer, they will help him work, stopping them for <duration> seconds while working.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = .25,
		},
		duration = {
			Base = 1,
		
		},
	},
	C = {
		Name = "Redesign",
		Desc = "BLOXER787 redesigns a nearby enemy within <range> studs, causing them to take <damage> damage in the process. If the target is 'Hired', the redesign will become a virus, dealing <percent>% extra true damage to the target",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 5,
			H4x = .35,
		},
		percent = {
			Base = 25,
			
		},
		range = {
			Base = 20,
			AbilityLevel = 4,
		},
	},
	D = {
		Name = "Judgement of the Balancer",
		Desc = "[Innate] Landing a successful hit on BLOXER787's basic attack will grant him 10% increased movement speed. [Active] BLOXER787 'balances' all enemies in an area, dealing <damage> damage. If the enemy hit is his 'Hired' balancer, they will also get debuffed by <debuff> of their Skillz and H4x for <duration> seconds and take an extra <bonusdamage> damage.",
		MaxLevel = 3,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = .3,
		},
		bonusdamage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = .3,
		},
		
		debuff = {
			AbilityLevel = 15,
			H4x = .2,
		},
		duration = {
			Base = 1,
			AbilityLevel = 1,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 150 + level * 15
	end,
	Skillz = function(level)
		return 6 + level * 2
	end,
	H4x = function(level)
		return 6 + level * 2
	end,
	Toughness = function(level)
		return 9.5 + level * 1.5
	end,
	Resistance = function(level)
		return 9.5 + level * 1.5
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test