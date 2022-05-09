local duckMesh = Instance.new("SpecialMesh")
duckMesh.MeshType = "FileMesh"
duckMesh.MeshId = "http://www.roblox.com/asset/?id=9419831"
duckMesh.TextureId = "http://www.roblox.com/asset/?id=9419827"

local satMesh = Instance.new("SpecialMesh")
satMesh.MeshType = "FileMesh"
satMesh.MeshId = "http://www.roblox.com/asset/?id=1064328"
satMesh.TextureId = "http://www.roblox.com/asset/?id=1064329"
satMesh.Scale = Vector3.new(0.25, 0.25, 0.25)

local potMesh = Instance.new("SpecialMesh")
potMesh.MeshType = "FileMesh"
potMesh.MeshId = "http://www.roblox.com/asset/?id=1045320"
potMesh.Scale = Vector3.new(3,3,3)

local teapot = Instance.new("Part")
teapot.BrickColor = BrickColor.new("Sand blue")
teapot.Size = Vector3.new(2, 1, 1)
teapot.CanCollide = false
potMesh.Parent = teapot

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.15 - (1.15 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ClockBasicAttackFinal-item?id=263082062")
	d.PLAY_SOUND(d.HUMAN, 101157919, nil, 1.2)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 64
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
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
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 1, script.Parent.Parent.Character.Torso.Basic.Value.Color, 0.1)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,script.Parent.Parent.Character.Torso.Basic.Value.Color, 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 2  - (2 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ClockTeapotRainFinal-item?id=263082327")
	
	local part = teapot:Clone()
	part.Anchored = true
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local pos = d.EasyTarget(38)
	local p = d.EasyProjectile{
		Position = pos + Vector3.new(0, 64, 0),
		Direction = Vector3.new(1, -1000, 0).unit,
		Range = 50,
		Speed = 90, 
		Solid = false,
		OnEnd = function(p)
			local hit = false
			d.DS.AOE:Invoke(pos, 9, d.CHAR.Team.Value, function(target)
				d.DS.Damage:Invoke(target, damage, "Resistance", d.PLAYER)
				hit = true
			end)
			if hit then
				
			end
			d.SFX.Explosion:Invoke(pos, 9, script.Parent.Parent.Character.Torso.Skills.Value.Color)
			d.PLAY_SOUND_POS(pos, 119877855)
		end
	}
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(
		math.random() * math.pi * 2,
		math.random() * math.pi * 2,
		math.random() * math.pi * 2
	))
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 20  - (20 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	local h4x = ability:C(data.h4xBuff)
	local speed = ability:C(data.speedBuff)
	local duration = ability:C(data.duration)
	
	d.ST.StatBuff:Invoke(d.HUMAN, "H4x", h4x, duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "Speed", speed, duration)
	
	d.PLAY_SOUND(d.HUMAN, 35966712)
	d.SFX.Trail:Invoke(d.CHAR.Head, Vector3.new(0, 0.5, 0), 1, {BrickColor = d.C("White")}, 0.6, duration)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12  - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
		wait(0.2)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ClockDuckFinal-item?id=263082819")
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	duckMesh:Clone().Parent = part
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local p = d.EasyProjectile{
		Position = d.CHAR["Right Arm"].Position,
		Direction = d.HRP.CFrame.lookVector,
		Range = 40,
		Speed = 40,
		OnHit = function(p, target)
			d.PLAY_SOUND_POS(p.Position, 9413306, 1)
			d.DS.Damage:Invoke(target, damage, "Resistance", d.PLAYER)
			d.ST.MoveSpeed:Invoke(target, slow, duration)
		end
	}
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 75  - (75 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	local a = d.HRP.Position
	local b = d.MOUSE_POS
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	local range = 80
	local damagePerSecond = ability:C(data.damagePerSecond)
	local center = d.DS.Targeted:Invoke(a, range, b)
	local slow = -.25
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ClockSatelliteCrashFinal-item?id=263083176")
	
	local pos = d.EasyTarget(32)
	
	for t = 0.3, 2.1, 0.3 do
		d.SFX.ReverseExplosion:Invoke(center, 30, "Bright red", t)
		d.SFX.ReverseExplosion:Invoke(center, 14, script.Parent.Parent.Character.Torso.Skills.Value.Color, t)
	end
	wait(2.1)
	
	for t = 0.2, 0.8, 0.2 do
		d.SFX.Explosion:Invoke(center, 30, "Bright red", t)
	end
	d.SFX.Artillery:Invoke(center, 14, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.5)
	d.PLAY_SOUND_POS(pos, 55224766, 1)
	
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	satMesh:Clone().Parent = part
	part.CFrame = CFrame.new(center) * CFrame.Angles(
		math.random() * math.pi * 2,
		math.random() * math.pi * 2,
		math.random() * math.pi * 2
	)
	part.Parent = workspace
	d.DB(part, duration + 1)
	
	d.DS.AOE:Invoke(center, 30, d.CHAR.Team.Value, function(target)
		d.DS.Damage:Invoke(target, damage, "Resistance", d.PLAYER)
		d.DS.KnockAirborne:Invoke(target, 16, 0.5)
	end)
	
	d.DS.AOE:Invoke(center, 14, d.CHAR.Team.Value, function(target)
		d.ST.MoveSpeed:Invoke(target, slow, duration)
	end)
	
	local t = 0
	d.SFX.AreaAOEStart:Invoke(center, 27, "Neon orange",duration,"Neon")
	while t < duration do
		local dt = wait(0.25)
		t = t + dt
		
		
		d.DS.AOE:Invoke(center, 27, d.CHAR.Team.Value, function(target)
			d.DS.Damage:Invoke(target, damagePerSecond * dt, "Resistance", d.PLAYER)
			d.SFX.PartRandomFollow:Invoke(target.Parent.Torso, 3, script.Parent.Parent.Character.Torso.Skills.Value.Color)
		end)
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Teapot Rain",
		Desc = "Clockwork drops a teapot from the sky, dealing <damage> damage in a small area after a short delay.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 5,
			H4x = 0.2,
		}
	},
	B = {
		Name = "Boil Over",
		Desc = "Clockwork boils over, increasing his H4x by <h4xBuff> and his Speed by <speedBuff> for <duration> seconds.",
		MaxLevel = 5,
		h4xBuff = {
			AbilityLevel = 5,
			H4x = 0.25,
		},
		speedBuff = {
			AbilityLevel = 1
		},
		duration = {
			Base = 2.25,
			AbilityLevel = 0.25,
		}
	},
	C = {
		Name = "Duck",
		Desc = "Calling upon ancient powers beyond understanding, Clockwork pierces his foes with a duck, dealing <damage> damage and slowing <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 25,
			AbilityLevel = 4,
			H4x = 0.25,
		},
		slow = {
			Base = 35,
			
		},
		duration = {
			Base = 2,
			AbilityLevel = 0.25,
		}
	},
	D = {
		Name = "Satellite Crash",
		Desc = "Clockwork sacrifices his signature satellite to crash at a nearby targeted area, knocking nearby enemies airborne for .5 seconds, dealing <damage> damage on impact and dealing <damagePerSecond> damage per second for <duration> seconds. Enemies caught within the inner explosion also receive a 25% slow for the entire duration of the move.",
		MaxLevel = 3,
		damage = {
			Base = 10,
			AbilityLevel = 10,
			H4x = 0.4
		},
		duration = {
			Base = 3.8,
			AbilityLevel = .4,
		},
		damagePerSecond = {
			Base = 10,
			AbilityLevel = 6,
			H4x = 0.1,
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