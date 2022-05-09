function color(num, d)
	if num == 1 then
		return tostring(d.CHAR.Torso.BrickColor)
	end
	
	if num == 2 then
		return tostring(d.CHAR.Head.BrickColor)
	end
end

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/1x1x1x1BasicAttackFinal-item?id=627070330")
	d.PLAY_SOUND(d.HUMAN, 12222152, nil, 0.4)
	
	wait(0.5)
	
	local position = d.CHAR.RingFace.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
	local part = game.ReplicatedStorage.Items.Rufaro:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
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
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(-math.pi/2,0,0))
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"Bright blue", 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/1x1x1x1IPTraceFinal-item?id=261278294")
	d.PLAY_SOUND(d.HUMAN, 12222152, nil, 0.2)
	d.SFX.Trail:Invoke(d.CHAR.RingFace, Vector3.new(), 1.25, {BrickColor = d.C(color(2, d))}, 0.5, 0.45)
	wait(0.45)
	
	local position = d.CHAR.RingFace.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 52.5
	local width = 4
	local range = 48
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	local part = game.ReplicatedStorage.Items.Rufaro:Clone()
	local dir = d.HRP.Rotation
	local circles = 0
	part.Size = Vector3.new(2,.2,2)
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	local function onHit(hook, enemy)
		hook.Moving = false
		
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then
			d.SFX.Explosion:Invoke(hrp.Position,12,"Bright blue")
			d.CHAR:MoveTo(hrp.Position)
			d.SFX.Shockwave:Invoke(hrp.Position, 6, color(1, d)) 
		end
		
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end
	end
	local function onStep(projectile)
		topos = projectile.Position
	end
	local function onEnd(projectile)
	part:Destroy()	
	end 
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(-math.pi/2,0,0))
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"Bright blue", 0.25,dir,"Neon",0.039)
	repeat 
	wait(.1) 
	circles = circles + 1
	d.SFX.Circles:Invoke(topos, 14,"Bright blue",.2,dir) 
	until circles == 6
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 18 - (18 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C("Really black"), Transparency = 0.5}, 0.5)
	wait(0.3)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/1x1x1x1DataminingFinal-item?id=261282176")
	d.PLAY_SOUND(d.HUMAN, 12222084, nil, 2.5)
	
	local center = d.HRP.Position
	local radius = 16
	local team = d.CHAR.Team.Value
	local steal = ability:C(data.steal)
	local steal2 = ability:C(data.steal2)
	local duration = ability:C(data.duration)
	local function onHit(enemy)
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
		d.ST.StatBuff:Invoke(enemy, "Toughness", -steal, duration)
		d.ST.StatBuff:Invoke(enemy, "Resistance", -steal2, duration)
		d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", steal, duration)
		d.ST.StatBuff:Invoke(d.HUMAN, "Resistance", steal2, duration)
		else 
		if not game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
		d.ST.StatBuff:Invoke(enemy, "Toughness", -steal/2, duration)
		d.ST.StatBuff:Invoke(enemy, "Resistance", -steal2/2, duration)
		d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", steal/2, duration)
		d.ST.StatBuff:Invoke(d.HUMAN, "Resistance", steal2/2, duration)
		end
		end
		end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Shockwave:Invoke(center, radius, color(1, d))
	wait(.05)
	d.SFX.Trail:Invoke(d.CHAR["Left Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C("Really black")}, 0.5, 0.4)
		d.SFX.Trail:Invoke(d.CHAR["Orb"], Vector3.new(0, 0, 0), 1, {BrickColor = d.C("Really black")}, 0.5, 0.4)
	end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 14 - (14 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local center2 = d.HRP.Position
d.SFX.ReverseExplosion:Invoke(center2, 6, tostring(color(1,d)), 0.3)
wait(0.45)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/item.aspx?id=261601315")
	d.PLAY_SOUND(d.HUMAN, 12222084)
	
	local center = d.HRP.Position
	local radius = 16
	local team = d.CHAR.Team.Value
	local duration = ability:C(data.duration)
	local damage = ability:C(data.damage)
	local function onHit(enemy)
		d.ST.Stun:Invoke(enemy, duration)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Artillery:Invoke(center, radius, color(1, d))
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 90)
	d.SFX.Artillery:Invoke(d.HRP.Position, 10, "Bright blue")
    d.ST.MoveSpeed:Invoke(d.HUMAN, -.7, 1.25)
    d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/1x1x1x1UnbannableFinal-item?id=627088336")
	d.CONTROL.AbilityCooldownLag:Invoke("Q", 1.25)
	d.CONTROL.AbilityCooldownLag:Invoke("A", 1.25)
	d.CONTROL.AbilityCooldownLag:Invoke("B", 1.25)
	d.CONTROL.AbilityCooldownLag:Invoke("C", 1.25)
	wait(1.25)
	local effect = game.ReplicatedStorage.Items.EmmaWater:Clone()
		effect.BrickColor = BrickColor.new("Bright yellow")
		effect.Position = d.HRP.Position
		effect.Transparency = 0.5
		effect.Size = Vector3.new(12,12,12)
		effect.Material = "Neon"
		local w = Instance.new("Weld")
		w.Parent = effect
		w.Part0 = effect
		w.Part1 = d.CHAR.Head
		w.C1 = CFrame.new(0,-2,0)
		effect.Parent = d.CHAR
	local percent = ability:C(data.percent)/100
	local heal = d.HUMAN.MaxHealth * percent
	d.ST.StatBuff:Invoke(d.HUMAN, "HealthRegen", heal, 1)
	wait (.5)
	wait (2)
	effect:Destroy()
	d.SFX.Explosion:Invoke(d.HRP.Position,12,"Bright yellow")
	d.PLAY_SOUND(d.HUMAN, 12222030)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "IP Trace",
		Desc = "1x1x1x1 launches a projectile. If it hits an enemy, 1x1x1x1 teleports to their position as they take <damage> damage and suffer a <slow>% slow for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 10,
			H4x = 0.35,
		},
		slow = {
			Base = 35,
			AbilityLevel = 2,
		},
		duration = {
			Base = 2,
		
		}
	},
	B = {
		Name = "Datamining",
		Desc = "1x1x1x1 send out a shockwave of energy which steals <steal> Toughness and <steal2> Resistance from each enemy hit for <duration> seconds. However, it's only half as effective against non-players.",
		MaxLevel = 5,
		steal = {
			
			AbilityLevel = 15,
			
		},
		steal2 = {
			
			AbilityLevel = 15,
			
		},
		duration = {
			Base = 2.5,
			
		}
	},
	C = {
		Name = "Crash",
		Desc = "1x1x1x1 stuns nearby enemies for <duration> seconds. He also deals <damage> damage to them.",
		MaxLevel = 5,
		duration = {
			Base = .75,
			AbilityLevel = 0.25,
		},
		damage = {
			Base = 20,
			AbilityLevel = 12.5,
			H4x = 0.3,
		}
	},
	D = {
		Name = "Unbannable",
		Desc = "After a brief 1.25 second startup with a 70% slow, 1x1x1x1 recovers <percent>% of his maximum health.",
		MaxLevel = 3,
		percent = {
			AbilityLevel = 25,
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 180 + level * 17.5
	end,
	H4x = function(level)
		return 4 + level * 1.5
	end,
	Toughness = function(level)
		return 5 + level * 0.5
	end,
	Resistance = function(level)
		return 5 + level * 1.25
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test