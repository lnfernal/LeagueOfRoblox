local symphonymode = false
local stack = 3

local NOTE = Instance.new("Part")
NOTE.Anchored = true
NOTE.CanCollide = false
NOTE.FormFactor = "Custom"
NOTE.Size = Vector3.new(1, 1, 1)
local mesh = Instance.new("SpecialMesh", NOTE)
mesh.MeshId = "http://www.roblox.com/asset/?id=1088207"
mesh.TextureId = "http://www.roblox.com/asset/?id=1088099"
mesh.Scale = Vector3.new(0.1, 0.1, 0.1)

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ResyncableBasicAttackFinal-item?id=263109223")
	d.PLAY_SOUND(d.HUMAN, 163667963, 1, 1)
	wait(0.3)

	local position = d.CHAR.Wand.Position
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
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,d.CHAR.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack


local dmaxstack = 4
local dstack = dmaxstack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	local cooldown = true
	
	if symphonymode then
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 7, 32, {BrickColor = d.C("Really black"), Transparency = 0.5}, .25)
		d.CONTROL.AbilityCooldownLag:Invoke("B", 3.25)
		d.CONTROL.AbilityCooldownLag:Invoke("C", 3.25)
	dstack = dstack - 1
	if dstack >= 1 then
		 cooldown = .1
		end
	if dstack < 1 then
		cooldown = 8
		symphonymode = false
		delay(4, function()
		dstack = dstack + 4
		end)
	end
	d.CONTROL.AbilityCooldown:Invoke("A", cooldown)
	delay(3, function()
		if dstack >= 1 then
			symphonymode = false
			d.CONTROL.AbilityCooldown:Invoke("A", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
			dstack = 4
		end
	end)
	end
	
	if not symphonymode then
	d.CONTROL.AbilityCooldown:Invoke("A", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	end
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ResyncablePentatoneFinal-item?id=263109476")
	wait(0.05)
	d.PLAY_SOUND(d.HUMAN, 163668086, 1, 2)
	
	local function fireProjectile(theta)
		local position = d.CHAR.Wand.Position
		local direction = (d.HRP.CFrame * CFrame.Angles(0, theta, 0)).lookVector
		local speed = 52.5
		local width = 4
		local range = 48
		local team = d.CHAR.Team.Value
		local damage = true
		if symphonymode then
	 damage = ability:C(data.damage) * .5
		end
		if not symphonymode then
	 damage = ability:C(data.damage)
	end
		local part = NOTE:Clone()
		part.Parent = game.ReplicatedStorage
		d.DB(part)
		
		local function onHit(p, enemy)
			p.Moving = false
			d.ST.MoveSpeed:Invoke(enemy, slow, duration)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		end
		local function onStep(p, dt)
			
		end
		local function onEnd(p)
			part:Destroy()
		end
		local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
		d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(math.pi/2, 0, 0))
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,d.CHAR.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
	end
	
	local dTheta = math.pi / 13
	local theta = dTheta * -2
	while theta <= dTheta * 2 do
		fireProjectile(theta)
		theta = theta + dTheta
		wait(0.1)
	end
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 14 - (14 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	if symphonymode then
		d.CONTROL.AbilityCooldownLag:Invoke("A", 2)
		d.CONTROL.AbilityCooldownLag:Invoke("C", 2)
	end
	
	local damage = ability:C(data.damage)
	local debuff = -ability:C(data.debuff)/ 100
	local duration = ability:C(data.duration)
	local hitAnEnemy = false
	
	if symphonymode then
		d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 7, 32, {BrickColor = d.C(d.CHAR.Torso.Skills.Value.Color), Transparency = 0.5}, .25)
		wait(0.35)
	end
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ResyncableStaccatoFinal-item?id=263109898")
	wait(0.35)
	d.PLAY_SOUND(d.HUMAN, 163667849, 12)
	
	local position = d.CHAR.Wand.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 52.5
	local width = 5
	local range = 40
	local team = d.CHAR.Team.Value
	local part = NOTE:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(p, enemy)
		p.Moving = false
		hitAnEnemy = true
	end
	local function onStep(p, dt)
		
	end
	local function onEnd(p)
		p.Moving = false
		hitAnEnemy = true
		part:Destroy()
		if hitAnEnemy then
			local center = p.Position
			local radius = 14
			local stunradius = 20
			local intradius = 15
			local function onHit(enemy)  
				if enemy.Parent then
				local gs = enemy.Parent:FindFirstChild("GetStat", true)
				if gs then
					local res = gs:Invoke("Resistance" and "Toughness")
					local debuff = res * ability:C(data.debuff) / 100
				d.ST.StatBuff:Invoke(enemy, "Toughness", -debuff, duration)
				d.ST.StatBuff:Invoke(enemy, "Resistance", -debuff, duration)
				d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
				if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
				end 
				end  
			end
			if not symphonymode then
			d.DS.AOE:Invoke(center, radius, team, onHit)
			d.SFX.Explosion:Invoke(center, radius, "Really black")
			end
			d.PLAY_SOUND(d.HUMAN, 163667849, nil, 2)
			if symphonymode then
				symphonymode = false
				local function onExteriorHit(enemy)
					if enemy.Parent then
				local gs = enemy.Parent:FindFirstChild("GetStat", true)
				if gs then
					local res = gs:Invoke("Resistance" and "Toughness")
					local debuff = res * ability:C(data.debuff) / 100
					d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
					d.ST.StatBuff:Invoke(enemy, "Toughness", -debuff, duration)
					d.ST.StatBuff:Invoke(enemy, "Resistance", -debuff, duration) 
					d.ST.Stun:Invoke(enemy, 1.25)
				end
				end 
				end
				local function onInteriorHit(enemy)
					d.ST.Stun:Invoke(enemy, 1.25)
				end
			d.DS.AOE:Invoke(center, intradius, team, onInteriorHit)
			d.DS.AOE:Invoke(center, stunradius, team, onExteriorHit)
			d.SFX.Explosion:Invoke(center, stunradius, d.CHAR.Torso.Skills.Value.Color)
			d.SFX.Explosion:Invoke(center, intradius, "Really black")
			end
		end
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,d.CHAR.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
	for m = 1, 3 do
		d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(math.pi/2, math.pi*(2/3)*m, 0),
			
			{Spin = CFrame.Angles(0, 1/4, 0)}
		)
		end
	if symphonymode then
				d.SFX.ProjShrink:Invoke(p:ClientArgs(), 1.5, d.CHAR.Torso.Skills.Value.Color, .3)
				d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,d.CHAR.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
	end
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	if symphonymode then
	d.CONTROL.AbilityCooldownLag:Invoke("A", 1)
		d.CONTROL.AbilityCooldownLag:Invoke("B", 1)
		end
	
	local bonus = ability:C(data.bonus)
	local duration = ability:C(data.duration)
	local tagName = d.PLAYER.Name.."Accelerated"
	
	if symphonymode then
		d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 7, 32, {BrickColor = d.C("Lime green"), Transparency = 0.5}, .25)
		wait(.25)
	end
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ResyncableAccelerandoFinal-item?id=263110216")
	wait(0.1)
	d.PLAY_SOUND(d.HUMAN, 163667849, 1, 1.5)
	
	local center = d.HRP.Position
	local radius = 16
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local function onHit(ally)
		if game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then
		d.ST.StatBuff:Invoke(ally, "Speed", bonus, duration)
		d.ST.StatBuff:Invoke(ally, "BasicCDR", .1, duration)
		if symphonymode then
			 if game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then
			d.ST.Tag:Invoke(ally, duration, tagName)
			delay (.5, function() 
			symphonymode = false	
			end)
			end
			end 
		end
		
		local hrp = d.GET_HRP(ally)
		if hrp then
			if symphonymode then
			d.SFX.Artillery:Invoke(hrp.Position, 4, "Lime green")
			end
			if not symphonymode then
			d.SFX.Artillery:Invoke(hrp.Position, 4, "Camo")
			end
		end
	if d.ST.GetEffect:Invoke(ally, tagName) then
		delay(duration, function()
		local position = hrp.Position
		d.ST.StatBuff:Invoke(ally, "Speed", bonus, duration)
		d.ST.StatBuff:Invoke(ally, "BasicCDR", .1, duration)
		d.SFX.Artillery:Invoke(hrp.Position, 4, "Lime green")
	end)
	end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	if not symphonymode then
	d.SFX.Shockwave:Invoke(d.FOOT(), radius, "Camo")
	end
	if symphonymode then
	d.SFX.Shockwave:Invoke(d.FOOT(), radius, "Lime green")
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", ability:C(data.cooldown) - (ability:C(data.cooldown) * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local duration = 5
	symphonymode = true
		d.SFX.Artillery:Invoke(d.HRP.Position, 4, d.CHAR.Torso.Skills.Value.Color)
	d.SFX.Shockwave:Invoke(d.HRP.Position, 8, d.CHAR.Torso.Skills.Value.Color)
	d.PLAY_SOUND(d.HUMAN, 163667849, 1, 1.25)
	if symphonymode then
		d.SFX.Trail:Invoke(d.HRP, Vector3.new(), 2, {BrickColor = d.C(d.CHAR.Torso.Skills.Value.Color)}, 0.5, duration)
		
	end
	wait(duration)
	symphonymode = false
	
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Pentatone",
		Desc = "Resyncable fires five notes in a fan-shaped pattern which deal <damage> damage apiece on contact and slow the first enemy hit by <slow>% for <duration> seconds. In symphony mode, Resyncable gains 4 volleys of shots to fire over the course of 3 seconds. However, each shot does 50% of its normal damage.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.115, 
		},
		slow = {
			Base = 15,
			
		},
		duration = {
			Base = 1.5
		}
	},
	B = {
		Name = "Staccato",
		Desc = "Resyncable sends a sound wave forward which detonates, dealing <damage> damage to nearby enemies and reducing their toughness and resistance by <debuff>% for <duration> seconds. In symphony mode, this move gains a larger enveloping aoe which stuns enemies for 1.25 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 5,
			H4x = 0.4,
		},
		debuff = {
			Base = 35,
		AbilityLevel = 3,
			
		},
		duration = {
			Base = 3.5,
		}
	},
	C = {
		Name = "Accelerando",
		Desc = "Resyncable increases the movement speed of nearby allies by <bonus> and increases their attack speed by 10% for <duration> seconds. In symphony mode, the duration of the speed boost is automatically refreshed once when it runs out.",
		MaxLevel = 5,
		bonus = {
			Base = 2,
			AbilityLevel = .9,
		},
		duration = {
			Base = 3,
			
		}
	},
	D = {
		Name = "Symphony",
		Desc = "Resyncable begins to sense the rhythm of his music and enters symphony mode for 5 seconds. During this period, the next ability cast by Resyncable gains enhanced properties. The cooldown of this move is <cooldown> seconds.",
		MaxLevel = 3,
		cooldown = {
			Base = 60,
			AbilityLevel = -5,
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