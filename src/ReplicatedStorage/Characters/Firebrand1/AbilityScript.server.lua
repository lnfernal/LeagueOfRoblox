--some special stuff for firebrand
local enemiesOnFire = {}
function setEnemyOnFire(enemy)
	table.insert(enemiesOnFire, enemy)
	if enemy.Parent then
		local tor = enemy.Parent:FindFirstChild("Torso")
		if tor then
			local Fire = Instance.new("Fire", tor)
			
			Fire.Color = script.Parent.Parent.Character.Torso.Flames.Value
			return Fire
		end
	end
	local Fire = Instance.new("Fire")
		Fire.Color = script.Parent.Parent.Character.Torso.Flames.Value
	return Fire
end
function setEnemyNotOnFire(enemy, fire)
	if fire then
		fire:Destroy()
	end
	
	for index, enemyOnFire in pairs(enemiesOnFire) do
		if enemyOnFire == enemy then
			table.remove(enemiesOnFire, index)
			break
		end
	end
end
--/special stuff

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/FirebrandBasicAttackFinal-item?id=263094840")
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 83674171, nil, 2)
	
	local position = d.CHAR.Sword.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 0.75, d.CHAR.Torso.Skills.Value.Color, 0.2)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,d.CHAR.Torso.Skills.Value.Color, 0.25,direction,"Granite",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 20 - (20 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/FirebrandFiredUpFinal-item?id=263095059")
	d.PLAY_SOUND(d.HUMAN, 83674171, nil, 0.8)
	
	local buff = ability:C(data.buff)
	local duration = ability:C(data.duration)
	
	local center = d.HRP.Position
	local range = 15
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local function onHit(ally)
		if game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then
			d.ST.StatBuff:Invoke(ally, "Skillz", buff, duration)
			d.ST.StatBuff:Invoke(ally, "H4x", buff, duration)
			d.SFX.Trail:Invoke(d.CHAR["Right Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C(d.CHAR.Torso.Skills.Value.Color)}, 0.5, duration)
			local hrp = ally.Parent:FindFirstChild("Right Arm")
				if hrp then
					local s = Instance.new("Fire", hrp)
					s.Color = d.CHAR.Torso.Skills.Value.Color
					 delay(duration, function()
						s:Destroy()
					end)   
					end
		end
	end
	d.DS.AOE:Invoke(center, range, team, onHit)
	d.SFX.Artillery:Invoke(center, range, d.CHAR.Torso.Skills.Value.Color)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 16 - (16 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/FirebrandWildfireFinal-item?id=263095611")
	d.PLAY_SOUND(d.HUMAN, 83674171, nil, 1.4)
	
	local Initialdamage = ability:C(data.Initialdamage)
	local DOTdamage = ability:C(data.DOTdamage)
	local duration = ability:C(data.duration)

	local range = 15
	local team = d.CHAR.Team.Value
	
	local function wildfire(center)
		local function onHit(enemy)
			if d.IN(enemy, enemiesOnFire) then return end
			
			local fire = setEnemyOnFire(enemy)
			delay(5, function()
				setEnemyNotOnFire(enemy, fire)
			end)
			
			if enemy.Parent then
				local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
				if hrp then
					delay(0.85, function()
						d.PLAY_SOUND(hrp, 83674171, nil, 1.4)
						wildfire(hrp.Position)
					end)
				end
			end
			
			d.DS.Damage:Invoke(enemy, Initialdamage, "Resistance", d.PLAYER)
			d.ST.DOT:Invoke(enemy, DOTdamage, duration, "Resistance", d.PLAYER, "Fire!")
			if enemy.Parent.Name == "Minion" then
			d.ST.DOT:Invoke(enemy, DOTdamage*1,duration, "Resistance", d.PLAYER)
		end 
		end
		d.DS.AOE:Invoke(center, range, team, onHit)
		d.SFX.Shockwave:Invoke(d.FLAT(center), range, d.CHAR.Torso.Skills.Value.Color)
	end
	wildfire(d.HRP.Position)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 18 - (18 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/FirebrandFeedtheFireFinal-item?id=263095824")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C(d.CHAR.Torso.Skills.Value.Color)}, 0.5)
	wait(0.5)
	d.PLAY_SOUND(d.HUMAN, 84937942)
	
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	
	for _, enemy in pairs(enemiesOnFire) do		
		local hrp = d.GET_HRP(enemy)
		if hrp then
			d.PLAY_SOUND(enemy, 83674171)
			d.ST.Stun:Invoke(enemy, duration)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
			d.SFX.Artillery:Invoke(hrp.Position, 4, d.CHAR.Torso.Skills.Value.Color)
		end
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 65)
	wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/FirebrandEnemysHearthFinal-item?id=263096055")
	d.PLAY_SOUND(d.HUMAN, 84937942, nil, 1.5)
	local regen = ability:C(data.regen)
	local radius = 18
	local duration = ability:C(data.duration)
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	for _, enemy in pairs(enemiesOnFire) do
	local hrp = d.GET_HRP(enemy)
	if hrp and game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
	
	local duration = ability:C(data.duration)
	local t = 0
	d.SFX.AreaAOEFollow:Invoke(hrp, radius, d.CHAR.Torso.Skills.Value.Color,duration)
	while t < duration do
	
	local dt = .425
	t = t + dt
	delay(t,function()
	local center = hrp.Position
	
	local function onHit(ally)
	d.ST.StatBuff:Invoke(ally, "HealthRegen", regen, dt)
	d.SFX.PartRandomFollow:Invoke(ally.Parent.Torso, 1.5, d.CHAR.Torso.Skills.Value.Color)
	end
	d.DS.AOE:Invoke(center, radius, team, onHit, dt)
	
	end)
	end		
	end
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Fired Up!",
		Desc = "Firebrand1 gets himself and his nearby allies fired up for the battle, increasing Skillz and H4x by <buff> for <duration> seconds.",
		MaxLevel = 5,
		buff = {
			Base = 10,
			AbilityLevel = 12.5,
			H4x = 0.3,
		},
		duration = {
			Base = 5,
		},
	},
	B = {
		Name = "Wildfire",
		Desc = "Firebrand1 creates a blaze at his location, lighting nearby enemies on fire for <duration> seconds and dealing <Initialdamage> damage to them, they then continue to burn for <duration> seconds and suffer <DOTdamage> damage. After 1 second, wildfire is cast at their location. Enemies on fire are not affected by wildfire.",
		MaxLevel = 5,
		Initialdamage = {
			
			AbilityLevel = 5,
			H4x = 0.1,
		},
		DOTdamage = {
			Base = 10,
			AbilityLevel = 20,
			H4x = 0.2,
		},
		duration = {
			Base = 3,
			
			
			
		},
	},
	C = {
		Name = "Feed the Fire",
		Desc = "Firebrand1 conflagrates the fires he has set on enemies, dealing <damage> damage to them and stunning them for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 25,
			AbilityLevel = 10,
			H4x = 0.35,
		},
		duration = {
			Base = 1,
			AbilityLevel = 0.15,
		}
	},
	D = {
		Name = "Enemy's Hearth",
		Desc = "Firebrand1 uses the fire on his enemies to cast healing auras around enemy players for <duration> seconds. These auras increase the regen of allies by <regen> as long as long as they continue to stand in them. Heals from multiple enemies can stack.",
		MaxLevel = 3,
		regen = {
			Base = 40,
			AbilityLevel = 5,
			H4x = 0.15,
			},
		duration = {
			Base = 3,
			
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 120 + level * 17.5
	end,
	H4x = function(level)
		return 5 + level * 0.7
	end,
	Toughness = function(level)
		return 5 + level * 0.6
	end,
	Resistance = function(level)
		return 5 + level * 0.7
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test