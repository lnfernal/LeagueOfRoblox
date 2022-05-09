local LastMoon
local MoonDuration
local ROCK = Instance.new("Part")
ROCK.Anchored = true
ROCK.CanCollide = false
ROCK.Shape = "Ball"
ROCK.Size = Vector3.new(1, 1, 1)
ROCK.BrickColor = BrickColor.new("White")

local MOONS = {}
local function remMoon(moonToRemove)
	for index, moon in pairs(MOONS) do
		if moon == moonToRemove then
			table.remove(MOONS, index)
		end
	end
	moonToRemove:Destroy()
end
local function addMoon(cframe, part, duration)
	part.Anchored = true
	part.CanCollide = false
	part.CFrame = cframe
	part.Parent = workspace
	
	LastMoon = part
	
	table.insert(MOONS, part)
	game:GetService("Debris"):AddItem(part, duration)
	delay(duration, function()
		remMoon(part)
		LastMoon = nil
	end)
end

local function s()
	return -0.2 + math.random() * 0.2
end

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/SpeedyBasicAttackFinal-item?id=263111263")
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 0.9)
	wait(0.2)
	
	local part = ROCK:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local position = d.CHAR.Head.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 32
	local speed = 80
	local width = 3.5
	local team = d.CHAR.Team.Value
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
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"White", 0.25,direction,"Neon",0.039)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new(), {
		Spin = CFrame.Angles(s(), s(), s())
	})
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 6 - (6 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	MoonDuration = ability:C(data.duration)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/SpeedyLOLMoonFinal-item?id=263111785")
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 1.8)
	
	local part = d.CHAR.Moon:Clone()
	part.Transparency = 0
	for i,v in pairs(part:GetChildren()) do
		if v:IsA("Decal") then
		v.Transparency = 0
		end
	end
	d.CW(part)
	part.Anchored = true
	part.CanCollide = false
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local a = d.CHAR.Head.Position
	local maxRange = 32
	local b = d.LEVEL(a, d.DS.Targeted:Invoke(a, maxRange, d.GET_TARGET_POS()))
	local vector = (b - a)
	local direction = vector.unit
	local range = vector.magnitude
	local speed = 36
	local width = 4
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		weldto = enemy.Parent.HumanoidRootPart
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		addMoon(p:CFrame(), part:Clone(), MoonDuration)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(a, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"White", 0.25,direction,"Neon",0.039)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	if LastMoon == nil then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.ReverseExplosion:Invoke(center, 6, "White", 0.4)
	wait(0.45)
	local range = ability:C(data.range)
	local slow = ability:C(data.slow)
	local damage = ability:C(data.damage)
	local part = d.CHAR.Moon:Clone()
	part.Transparency = 0
	for i,v in pairs(part:GetChildren()) do
		if v:IsA("Decal") then
		v.Transparency = 0
		end
	end
	d.CW(part)
	part.Anchored = true
	part.CanCollide = false
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	if LastMoon ~= nil then
	local a = LastMoon.Position
	local maxRange = range
	local b = d.LEVEL(a, d.DS.Targeted:Invoke(a, maxRange, d.GET_TARGET_POS()))
	local vector = (b - a)
	local direction = vector.unit
	local range = vector.magnitude
	local speed = 36
	local width = 4
	local slow = -ability:C(data.slow)/100
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		weldto = enemy.Parent.HumanoidRootPart
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		d.ST.MoveSpeed:Invoke(enemy, slow, 2.5)
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		addMoon(p:CFrame(), part:Clone(), MoonDuration)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(a, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"White", 0.25,direction,"Neon",0.039)
	end
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 16 - (16 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local center = d.HRP.Position
	d.SFX.Shockwave:Invoke(center, 6, "White", 0.3)
	wait(0.3)
	local function helper(moon)
		local position = moon.Position
		local radius = 15
		local team = d.CHAR.Team.Value
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		end
		d.DS.AOE:Invoke(position, radius, team, onHit)
		d.SFX.Explosion:Invoke(position, radius, "White")
		d.PLAY_SOUND_POS(position, 12222084)
		delay(0, function()
			remMoon(moon)
		end)
	end
	for _, moon in pairs(MOONS) do
		helper(moon)
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 95 - (95 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local myTeam = d.CHAR.Team.Value
	
	local function helper(player)
		local char = player.Character
		if char then
			local team = char:FindFirstChild("Team")
			if team then
				if team.Value ~= myTeam then
					local enemy = char:FindFirstChild("Humanoid")
					local hrp = char:FindFirstChild("HumanoidRootPart")
					if enemy then
						local t = 0
						while t < 2.5 do
							t = t + wait(0.25)
							d.SFX.Artillery:Invoke(hrp.Position, 1, "Lily white")
						end
						d.PLAY_SOUND(enemy, 84937942)
						d.SFX.Artillery:Invoke(hrp.Position, 6, "White")
						d.DS.Damage:Invoke(enemy, damage, 0, d.PLAYER)
					end
				end
			end
		end
	end
	
	for _, player in pairs(game.Players:GetPlayers()) do
		delay(0, function()
			helper(player)
		end)
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "LOL snowball",
		Desc = "speedydude900 deploys a LOL snowball to the targeted location. As it travels, it deals <damage> damage to targets nearby. The LOL snowball stays there for <duration> seconds, and can be used by speedydude900's other abilities.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 6,
			H4x = 0.3,
		},
		duration = {
			AbilityLevel = 3.6,
		}
	},
	B = {
		Name = "LOL Gravity",
		Desc = "speedydude900 manipulates gravity around his last snowball created, allowing create another snowball from it and move it <range> studs, dealing <damage> slowing all hit by <slow>% for 2.5 seconds.",
		MaxLevel = 5,
		range = {
			Base = 10,
			AbilityLevel = 5,
		},
		slow = {
			Base = 30,
			AbilityLevel = 2,
			
		},
		damage = {
			Base = 10,
			AbilityLevel = 6,
			H4x = 0.35,
			},   
	},
	C = {
		Name = "Core Shatter",
		Desc = "speedydude900 shatters his LOL snowballs for the LOLs. Enemies nearby take <damage> damage but the snowballs are destroyed.",
		MaxLevel = 5,
		damage = {
			Base = 7.5,
			AbilityLevel = 7.5,
			H4x = 0.4,
		}
	},
	D = {
		Name = "LOL Blizzard",
		Desc = "After a short delay, all enemy players take <damage> damage, regardless of distance.",
		MaxLevel = 3,
		damage = {
			Base = 10,
			AbilityLevel = 7.5,
			H4x = 0.3,
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