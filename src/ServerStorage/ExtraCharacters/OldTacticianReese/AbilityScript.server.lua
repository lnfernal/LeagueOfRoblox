local attackNumber = 1
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
		if attackNumber == 1 or attackNumber == 2 then
		local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.2
		d.PLAY_SOUND(d.HUMAN, 12222216)
		if attackNumber == 1 then
			d.CONTROL.AbilityCooldown:Invoke("Q", .4 - (.4 * d.CONTROL.GetStat:Invoke("BasicCDR")))
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShedBasicAttack1Final-item?id=259752269")
		elseif attackNumber == 2 then
			d.CONTROL.AbilityCooldown:Invoke("Q", .4 - (.4 * d.CONTROL.GetStat:Invoke("BasicCDR")))
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/item-item?id=503549092")
		end
		local team = d.CHAR.Team.Value
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		end
		d.DS.Melee:Invoke(d.HRP, team, onHit)
		elseif attackNumber == 3 then
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/item-item?id=503552239")
	wait(.15)
	d.PLAY_SOUND(d.HUMAN, 101157919, nil, 1)
	
	wait(0.15)
	local position = d.CHAR["Left Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 48
	local width = 3
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.18
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Shape = "Ball"
	part.Size = Vector3.new(1, 1, 1)
	part.BrickColor = BrickColor.new("Pastel violet")
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		end	
		attackNumber = attackNumber + 1
	if attackNumber > 3 then
		attackNumber = 1
	end
	end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 15)
	
	
	
	
	
	local speed = 64
	local width = 5
	local range = 48
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local slashdamage = ability:C(data.slashdamage)
	local duration = ability:C(data.duration)
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Shape = "Ball"
	part.Size = Vector3.new(2, 2, 2)
	part.BrickColor = BrickColor.new("Lapis")
	part.Parent = workspace
	d.DB(part)
	
		
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.SFX.Shockwave:Invoke(d.FLAT(projectile.Position), 4, "Lapis")
		d.SFX.Bolt:Invoke(enemy.Parent:FindFirstChild("HumanoidRootPart").Position, 1,"Pastel light blue", 0.35)
		d.ST.Stun:Invoke(enemy, duration)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
	end
	local function onHitLine(enemy)
		d.DS.Damage:Invoke(enemy, slashdamage, "Resistance", d.PLAYER)
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
		for i = 1, 4 do
		wait(.25)
		if i == 1 then
			d.PLAY_SOUND(d.HUMAN, 12222216)
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DavidiiGatheringStrikeFinal-item?id=263046551")
			d.SFX.Line:Invoke(d.HRP.Position, d.HRP.CFrame.lookVector, 12, 3, "Lapis")
		d.DS.Line:Invoke(d.HRP, 12, 3, team, onHitLine)
		end
		if i == 2 then
			d.PLAY_SOUND(d.HUMAN, 12222216)
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DavidiiBasicAttack1Final-item?id=262277934")
			d.SFX.Line:Invoke(d.HRP.Position, d.HRP.CFrame.lookVector, 12, 3, "Lapis")
		d.DS.Line:Invoke(d.HRP, 12, 3, team, onHitLine)
		end
		if i == 3 then
			d.PLAY_SOUND(d.HUMAN, 12222216)
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DavidiiBasicAttack2Final-item?id=262278459")
			d.SFX.Line:Invoke(d.HRP.Position, d.HRP.CFrame.lookVector, 12, 3, "Lapis")
		d.DS.Line:Invoke(d.HRP, 12, 3, team, onHitLine)
		end
		if i == 4 then
			
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ReeseModerateFinal-item?id=503556025")
	d.SFX.Trail:Invoke(d.CHAR["Left Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C("Lapis")}, 0.5, 0.4)
	wait(0.35)
	d.PLAY_SOUND(d.HUMAN, 48577326, nil, 0.85)
	wait(0.35)
	local position = d.CHAR["Left Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		end
		
	end
	
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 22.5)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ReeseReorganizeFinal-item?id=259912809")
	wait(.1)
	d.PLAY_SOUND(d.HUMAN, 2101144, nil, 1)
	
	local center = d.HRP.Position
	local range = 16
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local heal = ability:C(data.heal)
	local regen = ability:C(data.healthregen)
	local function onHit(ally)
		d.DS.Heal:Invoke(ally, heal)
		d.ST.StatBuff:Invoke(ally, "HealthRegen", regen, 3)
	end
	d.DS.AOE:Invoke(center, range, team, onHit)
	
	d.SFX.Explosion:Invoke(center, range, "Pastel green")
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 13.5)

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ReeseTeamSpiritFinal-item?id=259923830")
	d.PLAY_SOUND(d.HUMAN, 35971258, nil, 1)
	
	local center = d.HRP.Position
	local range = 16
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local speed = ability:C(data.speed) / 100
	local attackspeed = ability:C(data.attackspeed) / 100
	local duration = ability:C(data.duration)
	local function onHit(ally)
		d.ST.MoveSpeed:Invoke(ally, speed, duration)
		d.ST.StatBuff:Invoke(ally, "BasicCDR", attackspeed, duration)
	end
	d.DS.AOE:Invoke(center, range, team, onHit)
	
	d.SFX.Shockwave:Invoke(d.FLAT(center), range, "Bright red")
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 45)
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=503558150")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 32, {BrickColor = d.C("Pastel orange"), Transparency = 0.5}, 0.65)
	
	wait(1)
	d.PLAY_SOUND(d.HUMAN, 48618583, nil, 1.25)
	
	
	local position = d.CHAR["Left Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 64
	local width = 6
	local range = 64
	local team = d.CHAR.Team.Value
	local percent = -ability:C(data.percent) / 100
	local duration = ability:C(data.duration)
	local damage = ability:C(data.damage)
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Shape = "Ball"
	part.Size = Vector3.new(3, 3, 3)
	part.BrickColor = BrickColor.new("Pastel light blue")
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(projectile, enemy)
		projectile.Moving = false		
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		d.DS.AOE:Invoke(projectile.Position, 16, team, function(enemy)
			d.SFX.Bolt:Invoke(enemy.Parent:FindFirstChild("HumanoidRootPart").Position, 1,"Pastel light blue", 0.35)
			d.ST.MoveSpeed:Invoke(enemy, percent, duration)
			d.DS.Damage:Invoke(enemy, damage,0, d.PLAYER)
		end)
		d.SFX.Shockwave:Invoke(d.FLAT(projectile.Position), 16, "Pastel light blue")
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Agony",
		Desc = "Reese does a 3 slash combo dealing <slashdamage> damage after which she fires a projectile which deals <damage> damage to and stuns for <duration> seconds the first target it hits.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 5,
			H4x = 0.2,
		},
		slashdamage = {
			AbilityLevel = 5,
			H4x = 0.07,
		},
		duration = {
			Base = 0.5,
			AbilityLevel = 0.3,
		},
	},
	B = {
		Name = "Revitalize",
		Desc = "Reese heals nearby allies for <heal> health and applies <healthregen> bonus healthregen for 3 seconds.",
		MaxLevel = 5,
		heal = {
			AbilityLevel = 8,
			H4x = 0.2,
		},
		healthregen = {
			AbilityLevel = 2,
			H4x = 0.04,
		},
	},
	C = {
		Name = "Ferocity Aura",
		Desc = "Reese increases the speed of nearby allies by <speed>% and decreases the attack speed of nearby allies by <attackspeed>% for <duration> seconds.",
		MaxLevel = 5,
		speed = {
			Base = 12.5,
			AbilityLevel = 3.5,
		},
		duration = {
			Base = 3.5,
		},
		attackspeed = {
			Base = 12.5,
			AbilityLevel = 3.5,
		},
	},
	D = {
		Name = "Atonement",
		Desc = "Reese fires a projectile which explodes, slowing nearby enemies by <percent>% for <duration> seconds as well as dealing <damage> true damage.",
		MaxLevel = 3,
		percent = {
			Base = 30,
			AbilityLevel = 5
		},
		duration = {
			Base = 3.25,
			AbilityLevel = .25,
		},
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.25,
		}
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
		return 4 + level * 2
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