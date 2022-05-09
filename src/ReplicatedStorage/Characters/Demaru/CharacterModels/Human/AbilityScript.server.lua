function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NobleBasicAttackFinal-item?id=263050452")
	d.PLAY_SOUND(d.HUMAN, 12222216)
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .4
	local team = d.CHAR.Team.Value
	local hrp = d.HRP
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
	d.CONTROL.AbilityCooldown:Invoke("A", 22.5 - (22.5 * d.CONTROL.GetStat:Invoke("CooldownReduction"))) --2.25 b/c the duration between each flame is 0.75, * 3 = 2.25 so cd is 20
	
	wait(0.325)
	
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	
	local position = d.CHAR.Head.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 40
	local speed = range / 0.8
	local width = 3
	local team = d.CHAR.Team.Value
	local tofire = 3
	
	local function onHit(p, enemy)
		p.Moving = false
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		local center = p.Position - Vector3.new(0,2,0)
		local radius = 10
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
			d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Shockwave:Invoke(center, radius, "Bright yellow")
	end
	repeat
	position = d.CHAR.Head.Position
	direction = d.HRP.CFrame.lookVector
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/DemAbility1-item?id=446544283")
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 0.85, "Bright yellow", 0.25)
	tofire = tofire - 1
	wait(0.75)
	until tofire == 0
	tofire = 3
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local t = 0 + d.HRP.Position.Y
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 24, {BrickColor = d.C("Black")}, 0.35)
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/DemAbility2-item?id=446548144")
	wait(.5) --animation duration
	d.DS.KnockAirborne:Invoke(d.HUMAN, 32, 0.65)
	wait(0.15)
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
		end
	end
	
	local a = d.HRP.Position
	local b = d.GET_MOUSE_POS:InvokeClient(d.PLAYER)
	local maxRange = 48
	local target = d.DS.Targeted:Invoke(a, maxRange, b)
	target = Vector3.new(target.X, t, target.Z)
	local position = a
	local direction = (target - position).unit
	local range = (target - position).magnitude
	local speed = range + 40
	local width = 0
	
	local function onHit()
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		d.HRP.CFrame = p:CFrame()
		
		local center = d.HRP.Position
		local radius = 12
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
			d.DS.KnockAirborne:Invoke(enemy, 12, duration)
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Shockwave:Invoke(center, radius, "Really black")
		d.PLAY_SOUND(d.HUMAN, 12222084)
		
		d.STEADY()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	local args = p:ClientArgs()
	d.SFX.ProjDash:Invoke(args, d.HRP)
	d.SFX.ProjMeander:Invoke(args, 2, "Black", 0.2)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 20 - (20 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	local duration = ability:C(data.duration)
	local speed = ability:C(data.percent)/100
	local damage = ability:C(data.damage)
	local team = d.CHAR.Team.Value
	local otherteam = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local t = 0
	local radius = 12
	d.SFX.AreaAOEFollow:Invoke(d.CHAR.Torso, radius, "Mulberry",duration)
	while t < duration do
		local dt = wait(duration/6)
		t = t + dt
		
		local center = d.HRP.Position
		local function onHit(enemy)
			if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
				if enemy.Parent then
				local gs = enemy.Parent:FindFirstChild("GetStat", true)
				if gs then
					local res = gs:Invoke("Resistance" and "Toughness")
					local debuff = res * ability:C(data.percent) / 100
					d.ST.StatBuff:Invoke(enemy, "Resistance", -debuff, duration)
					d.ST.StatBuff:Invoke(enemy, "Toughness", -debuff, duration)
					end
				end
			end
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
			d.SFX.PartRandomFollow:Invoke(enemy.Parent.Torso, 3, "Mulberry")
			
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		local function onHit(ally)
			d.ST.MoveSpeed:Invoke(ally, speed, duration)
		end
		d.DS.AOE:Invoke(center, radius, otherteam, onHit)
		
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 70 - (70 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local truedamage = ability:C(data.damage2)
	local center = d.HRP.Position
	d.SFX.ReverseExplosion:Invoke(center, 12, "Bright yellow", 1.25)
	d.ST.Stun:Invoke(d.HUMAN, 1.25)
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/DemUltimate-item?id=447115334")
	wait(1.25)
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local width = 8
	local range = 256
	local speed = 128
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		d.DS.Damage:Invoke(enemy, truedamage, 0, d.PLAYER)
	end
	local function onStep(p)
	end
	local function onEnd(p)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 8, "Bright yellow", 1.2)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Overheat",
		Desc = "Demaru conjures his flames within his Big head, releasing three targeted strikes with a delay between each strike to the targeted position at the time, dealing <damage> damage and slowing <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 5,
			Skillz = .25,
		},
		slow = {
			Base = 15,
			
		},
		duration = {
			Base = 1,
		},
	},
	B = {
		Name = "Quake",
		Desc = "Demaru flies to the targeted location, dealing <damage> damage and knocking opponents airborne for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 10,
			Skillz = 0.3,
		},
		duration = {
			Base = 1,
			
		},
	},
	C = {
		Name = "Blazing Fury",
		Desc = "Demaru creates an aura around them for <duration> seconds, buffing allied speed by <percent>% per pulse as long as they stay in the aura. Enemies standing in this aura will be burned, dealing <damage> damage and losing <percent>% defense per pulse.",
		MaxLevel = 5,
		duration = {
			Base = 1.75,
			AbilityLevel = .25,
		},
		percent = {
			Base = 5,
			
		},
		damage = {
			Base = 5,
			AbilityLevel = 5,
			Skillz = .08,
		}
	},
	D = {
		Name = "Human Heart",
		Desc = "After a self stun of 1.25 seconds, Demaru shoots a blue flame that has incredible range, dealing <damage> damage to all enemies hit, while also dealing an extra <damage2> true damage from the intense heat.",
		MaxLevel = 3,
		damage = {
			Base = 20,
			AbilityLevel = 10,
			Skillz = .45,
		},
		damage2 = {
			AbilityLevel = 10,
			Skillz = .125,
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