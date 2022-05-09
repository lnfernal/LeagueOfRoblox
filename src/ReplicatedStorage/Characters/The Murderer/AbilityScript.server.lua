local unlock = false
script.UnlockFirst.Event:connect(function()
	unlock = true
end)
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.125 - (1.125 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local position = d.HRP.Position
	local hrp = d.HRP
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/MurdererBasicAttackFinal-item?id=263099572")
	d.PLAY_SOUND(d.HUMAN, 12222216, nil, 2)

	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .4
	
	local damage2 = d.CONTROL.GetStat:Invoke("Skillz") * .05
	
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	
		
	 
	if enemy.Health < enemy.MaxHealth * 0.5 and unlock and enemy.Parent.Name ~= "Turret" then
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		 local center = hrp.Position 
		
		d.DS.Damage:Invoke(enemy, damage2, 0, d.PLAYER)
		d.SFX.Artillery:Invoke(center, 3, tostring(d.CHAR.Torso.Skills.Value))
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
	
	local damage = ability:C(data.damage)
	local percent = ability:C(data.percent)/100
	local duration = ability:C(data.duration)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/MurdererMurderMysteryFinal-item?id=263100017")
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 12222200, 1)
	
	local knife = d.CHAR.Handle:Clone()
	d.CW(knife)
	knife.Parent = game.ReplicatedStorage
	d.DB(knife)
	
	local pos = d.CHAR.Handle.Position
	local dir = d.HRP.CFrame.lookVector
	local rng = 40
	local spd = rng / 0.5
	local wid = 4
	local tem = d.CHAR.Team.Value
	local function onHit(p, enemy)
		p.Moving = false
		local center = p.Position 
		local missingHealthPercent = ((enemy.MaxHealth - enemy.Health) / enemy.MaxHealth) * 100
		local slow = -percent * missingHealthPercent
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		d.SFX.Shockwave:Invoke(center, 6, tostring(d.CHAR.Torso.Skills.Value))
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		knife:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(pos, dir, spd, wid, rng, tem, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), knife, CFrame.Angles(-math.pi / 2, 0, 0))
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,tostring(d.CHAR.Torso.Skills.Value), 0.25,dir,d.CHAR.Torso.Materials.Value,0.039)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
wait(0.15)
	local damage = ability:C(data.damage)
	local range = ability:C(data.range)

	local pos = d.HRP.Position
	local tem = d.CHAR.Team.Value
	local target = d.DS.NearestTarget:Invoke(d.HRP.Position, range, tem)
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	if target then
		local hrp = d.GET_HRP(target)
		if hrp then
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/MurdererMurder-Final-item?id=263100386")
			d.PLAY_SOUND(d.HUMAN, 12222208, nil, 2)

			local vector = (hrp.Position - pos)
			local rng = vector.magnitude - 2
			local dir = vector.unit
			local spd = 100
			local wid = 0
			local function onHit(p, enemy)
			end
			local function onStep(p, enemy)
				topos = p.Position
		d.SFX.Circles:Invoke(topos, 4,"Black",.2,dir)
			end
			local function onEnd(p)
				d.HRP.CFrame = p:CFrame()
				d.DS.Damage:Invoke(target, damage, "Toughness", d.PLAYER)
				if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
				d.SFX.Artillery:Invoke(hrp.Position, 4, "Black")
			end
			local p = d.DS.AddProjectile:Invoke(pos, dir, spd, wid, rng, tem, onHit, onStep, onEnd)
			d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
		end
	end
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	
	local range = 40
	local speed = 80
	local width = 4
	local team = d.CHAR.Team.Value
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/MurdererMurderMysteryFinal-item?id=263100017")
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 12222200, 1)
	
	local knife = d.CHAR.Handle:Clone()
	d.CW(knife)
	knife.Parent = game.ReplicatedStorage
	d.DB(knife)
	
	local function onHit(p, enemy)
		p.Moving = true
		local missingHealthPercent = ((enemy.MaxHealth - enemy.Health) / (enemy.MaxHealth * 1)) 
		local bonus = damage * missingHealthPercent
		d.ST.DOT:Invoke(enemy, (damage + bonus), duration, "Toughness", d.PLAYER, "Poisoned!")
		if enemy.Parent.Name == "Minion" then
			d.ST.DOT:Invoke(enemy, (damage*1 + bonus),duration, "Toughness", d.PLAYER)
		end 
	end
	
	local function onStep(p, dt)
	end
	local function onEnd(p)
		knife:Destroy()
	end
	
	local spread = math.pi / 9
	for theta = -spread, spread, spread do
		local position = d.CHAR.Handle.Position
		local direction = (d.HRP.CFrame * CFrame.Angles(0, theta * 0.5, 0)).lookVector
		local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), knife, CFrame.Angles(-math.pi / 2, 0, 0))
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,tostring(d.CHAR.Torso.Skills.Value), 0.25,direction,d.CHAR.Torso.Materials.Value,0.039)
	end
	
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 60 - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/MurdererTheBigRevealFinal-item?id=263100855")
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 84937942, nil, 0.9)
	
	local threshold = ability:C(data.percent)/100
	local damage = ability:C(data.damage)

	local range = 20
	local width = 6
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		local healthPercent = enemy.Health / enemy.MaxHealth
		if healthPercent < threshold then
			d.DS.Damage:Invoke(enemy, enemy.MaxHealth, nil, d.PLAYER)
		else
			d.DS.Damage:Invoke(enemy, damage, nil, d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		end
	end
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	for idx, color in pairs{"Bright red", "Bright blue", "Black"} do
		d.SFX.Line:Invoke(d.CHAR.Head.Position, d.HRP.CFrame.lookVector, range, width / idx, color)
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Murder Mystery",
		Desc = "[Innate] If The Murderer's target is below 50% of their health, his basic attacks will deal 5% extra true damage. [Active] The Murderer throws his knife straight forward, dealing <damage> damage to the first opponent hit and slowing them <percent>% per 1% of their missing health for <duration> seconds. Lower health enemies are slowed more.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 5,
			Skillz = 0.5,
		},
		percent = {
			Base = 0.1, 
			AbilityLevel = 0.25
		},
		duration = {
			Base = 2.25,
		},
	},
	B = {
		Name = "Murder!",
		Desc = "The Murderer dashes to the nearest enemy and deals <damage> damage to them. The maximum range of this ability is <range> studs.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 10,
			Skillz = 0.25,
		},
		range = {
			Base = 30,
			AbilityLevel = 2,
		},
	},
	C = {
		Name = "The Mad Murderer",
		Desc = "The Murderer throws 3 knifes in front of him dealing <damage> damage over <duration> seconds, while also dealing 1% bonus damage per 1% of the target's missing health.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 7.5,
			Skillz = 0.15
		},
		duration = {
			Base = 2,
		},
	},
	D = {
		Name = "The Big Reveal",
		Desc = "The Murderer strikes in front of him, instantly killing foes whose health is lower than <percent>%. If their health is greater than <percent>%, they take <damage> true damage instead.",
		MaxLevel = 3,
		damage = {
			Base = 10,
			AbilityLevel = 10,
			Skillz = 0.4
		},
		percent = {
			AbilityLevel = 12.5,
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