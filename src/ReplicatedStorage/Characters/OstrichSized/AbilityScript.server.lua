local basicIsLeft = false
local boost = 0

local DISC = Instance.new("Part")
DISC.Anchored = true
DISC.CanCollide = false
DISC.FormFactor = "Custom"
DISC.Size = Vector3.new(1, 0.2, 1)
DISC.BrickColor = BrickColor.new("Camo")
Instance.new("CylinderMesh", DISC)

function basicAttack(d,basic)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", .5 - (.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local position
	if basicIsLeft then
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/OstrichLeftShootBasicAttackFinal-item?id=270229075")
		position = d.CHAR.GunLeft.Position
	else
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/OstrichRightShootBasicAttackFinal-item?id=270230456")
		position = d.CHAR.GunRight.Position
	end
	basicIsLeft = not basicIsLeft
	d.PLAY_SOUND(d.HUMAN, 11900833)
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.25

	local part = DISC:clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local direction = d.HRP.CFrame.lookVector
	local range = 32
	local speed = 80
	local width = 3.5
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		p.Moving = false
		if enemy.Parent.Name == "Turret" then
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		else
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*0.5, "Toughness", d.PLAYER)
		end 
		end 
		if basic then
			d.ST.MoveSpeed:Invoke(d.HUMAN, boost, 3.5)			
		end 
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,d.CHAR.Torso.Basic.Value.Color, 0.25,direction,"Neon",0.039) 
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 7 - (7 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	boost = ability:C(data.speed)/100
	
	local function quickBasic()
		d.CONTROL.AbilityCooldownReduce:Invoke("Q", 5)
		basicAttack(d,true)
		
	end
	
	quickBasic()
	quickBasic()
	d.CONTROL.AbilityCooldownLag:Invoke("Q", .5)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_SOUND(d.HUMAN, 12222200, 1)
	
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	local damage = ability:C(data.damage)
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 28
	local speed = range / 0.5
	local width = 0
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
	end
	local function onStep(p, dt)
		d.HRP.CFrame = CFrame.new(p.Position, p.Position + p.Direction)
	end
	local function onEnd(p)
		local center = p.Position
		local radius = 12
		local function onHit(enemy)
			d.ST.MoveSpeed:Invoke(enemy, slow, duration)
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Explosion:Invoke(center, radius, "Really black")
		d.PLAY_SOUND(d.HUMAN, 12222084, nil, 3)
	end
	d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd) 
	d.SFX.Shockwave:Invoke(d.FLAT(d.HRP.Position), 4, "Really black")
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 16 - (16 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local duration = ability:C(data.duration)
	local buff = ability:C(data.buff)
	d.ST.StatBuff:Invoke(d.HUMAN, "Skillz", buff, duration)
	--stealth
	d.DS.Stealth:Invoke(d.CHAR, duration)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 60 - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.CONTROL.AbilityCooldown:Invoke("Q", 7)
	
	local damage = ability:C(data.damage)

	local function shoot(gun, theta, rotator)
		local part = DISC:Clone()
		part.Parent = game.ReplicatedStorage
		d.DB(part)
		local position = gun.Position
		local direction = (d.HRP.CFrame * CFrame.Angles(0, theta + math.pi / 4 * rotator, 0)).lookVector
		local range = 24
		local speed = 48
		local width = 4
		local team = d.CHAR.Team.Value
		local function onHit(p, enemy)
			p.Moving = false
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			
		end
		local function onStep(p, dt)
		end
		local function onEnd(p)
			part:Destroy()
		end
		local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
		d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,d.CHAR.Torso.Basic.Value.Color, 0.25,direction,"Neon",0.039) 
	end
	
	for _ = 1, 5 do
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/OstrichBarrageFinal-item?id=263059875")
		for rotator = 1, 8 do
			shoot(d.CHAR.GunLeft, math.pi * 0.5, rotator)
			shoot(d.CHAR.GunRight, math.pi * 1.5, rotator)
			d.PLAY_SOUND(d.HUMAN, 11900833, nil, 1.5)
			
			wait(1/8)
		end
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Double Shot",
		Desc = "OstrichSized fires two fast basic attacks and gains <speed>% bonus speed per hit for 3.5 seconds.",
		MaxLevel = 5,
		speed = {
			Base = 5,
			AbilityLevel = 3,
		},
	},
	B = {
		Name = "Sneak Attack",
		Desc = "OstrichSized dashes straight forward and creates a flash which deals <damage> damage and slows nearby enemies by <slow>% for <duration> seconds.",
		MaxLevel = 5,
		slow = {
			Base = 27.5,
			AbilityLevel = 2.5,
		},
		duration = {
			Base = 2.5,
		},
		damage = {
			Base = 10,
			AbilityLevel = 10, 
			Skillz = 0.2,
			},
	},
	C = {
		Name = "Disappear",
		Desc = "OstrichSized turns invisible and gains <buff> Skillz for <duration> seconds.",
		MaxLevel = 5,
		duration = {
			Base = 2.5,
			AbilityLevel = 0.3,
		},
		buff = {
			Base = 5, 
			AbilityLevel = 5,
			Skillz = .25, 
	
		},
	},
	D = {
		Name = "Barrage",
		Desc = "OstrichSized spins rapidly in a circle for 5 seconds, shooting projectiles around him in a circle. Each does <damage> damage.",
		MaxLevel = 3,
		damage = {
			
			AbilityLevel = 4, 
			Skillz = 0.05,
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

local backpack = script.Parent
local controlScript = backpack:WaitForChild("ControlScript")

	local data = controlScript.GetData:Invoke()
	local color = data.CHAR.Torso:WaitForChild("Basic")
	DISC.BrickColor = color.Value

--test