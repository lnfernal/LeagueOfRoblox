local Usage = 0
local hit = true
local shot = Instance.new("Part")
	shot.Anchored = true
	shot.CanCollide = false
	shot.FormFactor = "Symmetric"
	shot.Size = Vector3.new(1.59, 1.59, 1.59)
	shot.Shape = "Ball"
	shot.Transparency = 0.6
	shot.BrickColor = BrickColor.new("Lime green")
	local particleem = Instance.new("ParticleEmitter")
	particleem.Parent = shot
	particleem.LightEmission = 0.66
	local numberstrans = {NumberSequenceKeypoint.new(0,0.481),
		NumberSequenceKeypoint.new(0.202,0.494),
		NumberSequenceKeypoint.new(0.303,1),
		NumberSequenceKeypoint.new(0.405,0),
		NumberSequenceKeypoint.new(0.599,0.506),
		NumberSequenceKeypoint.new(0.698,1),
		NumberSequenceKeypoint.new(0.798,0.506),
		NumberSequenceKeypoint.new(0.899,0.481),
		NumberSequenceKeypoint.new(1,1),}
	particleem.Size = NumberSequence.new(0.813,1.44)
	particleem.Transparency = NumberSequence.new(numberstrans)
	particleem.Texture = "http://www.roblox.com/asset/?id=300899453"
	local colors = {ColorSequenceKeypoint.new(0, Color3.fromRGB(63,255,10))
		,ColorSequenceKeypoint.new(0.209, Color3.fromRGB(13,59,16))
		,ColorSequenceKeypoint.new(0.524, Color3.fromRGB(12,255,0))
		,ColorSequenceKeypoint.new(0.727, Color3.fromRGB(236,255,20))
		,ColorSequenceKeypoint.new(1, Color3.fromRGB(33,138,25))}
	particleem.Color = ColorSequence.new(colors)
	particleem.EmissionDirection = "Top"
	particleem.Lifetime = NumberRange.new(1)
	particleem.Rate = 50 
	particleem.Rotation = NumberRange.new(-360,360)
	particleem.RotSpeed = NumberRange.new(-360,360)
	particleem.Speed = NumberRange.new(0)
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/OzzyBasicAttackFinal-item?id=263074811")
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 32656754, nil, 1)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
	local part = shot:Clone()
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
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"Lime green", 0.25,direction,"Neon",0.039) 
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	
	
	local speed = 64

	local width = 4.5
	local range = 44 + ability:C(data.range)
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	
	
	
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		end
	local function onStep(projectile)
	end
	
	for i = 1, ability:C(data.shots) do
	wait(0.2)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ObliviousSelf-ReplicatingCodeFinal-item?id=263090611")
	d.PLAY_SOUND(d.HUMAN, 32656754, nil, 1)
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local part = game.ReplicatedStorage.Items.BasicClime.Rapid:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"Lime green", 0.25,direction,"Neon",0.039)
	end
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ProfessorBasicFinal-item?id=263180005")
	d.PLAY_SOUND(d.HUMAN, 32656754, nil, 1)
	local center =  d.CHAR["Right Arm"].Position
	d.SFX.Explosion:Invoke(center, 10,"Lime green", 0.25)
    wait(0.35)
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 48

	local width = 4.5
	local range = 42 + ability:C(data.range)
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	
	
	local part = game.ReplicatedStorage.Items.BasicClime.Clime2nd:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(projectile, enemy)
		local chosen = math.random(1,100)
		print(chosen)
if (chosen < ability:C(data.chance)) then
local effect = game.ReplicatedStorage.Items.BasicClime.Crystal:Clone()
			local w = Instance.new("Weld")
			w.Parent = effect
			w.Part0 = effect
			w.Part1 = enemy.Parent.Head
			w.C1 = CFrame.new(0,5,0)
			effect.Parent = enemy.Parent
			game:GetService("Debris"):AddItem(effect, 2)
			delay(2, function()
				local function onHitt(enemy)
					d.DS.Damage:Invoke(enemy, damage * 1.5, "Resistance", d.PLAYER)
				
					d.ST.Stun:Invoke(enemy, 1.5)
				end
				local pos = enemy.Torso.Position
				if pos ~= nil then
				d.DS.AOE:Invoke(pos, 15, team, onHitt)
				d.SFX.Explosion:Invoke(pos, 15, "Lime green")
				end
			
			end)
end
		projectile.Moving = false
		for i = 1, ability:C(data.ticks) do
			wait(.75)
			if enemy.Health > 0 and enemy.Parent:FindFirstChild("HumanoidRootPart") and enemy.Parent:FindFirstChild("Head") then --Just incase
			d.ST.DOT:Invoke(enemy, damage, 1, "Resistance", d.PLAYER, "Blite!")
			if enemy.Parent.Name == "Minion" then
			d.ST.DOT:Invoke(enemy, damage*1,1, "Resistance", d.PLAYER)
		end 
			end
		end	
end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"Lime green", 0.25,direction,"Neon",0.039)
end

script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 14 - (14 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local center = d.HRP.Position
	d.SFX.ReverseExplosion:Invoke(center, 6,"Lime green", 0.3)
    wait(0.4)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ObliviousCompressionAlgorithmFinal-item?id=263091170")
	d.PLAY_SOUND(d.HUMAN, 32656754, nil, 1)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 52.5

	local width = 4.5
	local range = 48 + ability:C(data.range)
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	
	
	local part = game.ReplicatedStorage.Items.BasicClime.DragonsHead:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		d.ST.MoveSpeed:Invoke(enemy, -.35, 2.5)
		end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"Lime green", 0.25,direction,"Neon",0.039)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 180 - (180 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local teleport = game.ServerStorage.Teleporter:clone()
	teleport.Owner.Value = d.CHAR.Name
	teleport.Parent = workspace
	local a = d.HRP.Position + Vector3.new(0,-2.5,0)
	local range = 16
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local teamObj = d.GET_TEAM_OBJ(d.HUMAN)
	local spawn = teamObj.SpawnPosition + Vector3.new(0, 4, 0)
	teleport:MoveTo(spawn)
	wait(0.8)
	teleport:MoveTo(center)
	delay(180,function()
		if teleport then
			teleport:Destroy()
		end
	end)
	local function onHit(ally)
	if hit == false then
		
	else
		
		local hrp = d.GET_HRP(ally)
		if not game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then return end
		if game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) ~= game:GetService("Players"):GetPlayerFromCharacter(d.CHAR)and ally.Parent.Team.Value == d.CHAR.Team.Value then
		if hrp then
			
		local delta = Vector3.new(0, 0, -2)
			hrp.Parent:MoveTo(d.HRP.Position + delta)
			Usage = Usage + 1
			d.SFX.Bolt:Invoke(ally.Parent:FindFirstChild("HumanoidRootPart").Position, 1,"Lime green", 0.35)
			d.SFX.Explosion:Invoke(ally.Parent:FindFirstChild("HumanoidRootPart").Position, 8, "Lime green")
			hit = false
			wait(4)
		hit = true	
		end
		
		end	
		
		end
	end
teleport.Teleport.Touched:connect(onHit)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Nether shots",
		Desc = "climethestair fires <shots> shots that deal <damage> damage, the bolt obtains <range> range for each skill level.",
		MaxLevel = 5,
		damage = {
			H4xAbilityLevel = 0.01,
			H4x = 0.1,
			Base = 15,
			AbilityLevel = 3
		},
		shots = {
			Base = 5,
			
		},
		range = {
			Base = -1,
			AbilityLevel = 1
		},
	},
	B = {
		Name = "Blitening Shot",
		Desc = "climethestair fires a shot bolt that deals <damage> damage over 1s and ticks over <ticks> ticks, for each level, the bolt obtains <range> range for each skill level. The bolt has a <chance> chance to apply a crystal which explodes after 2 seconds that deals <damage> * 1.5 damage and stuns nearby enemies by 1.5s.",
		MaxLevel = 5,
		damage = {
			H4xAbilityLevel = 0.005,
			H4x = 0.1,
			Base = 10,
			AbilityLevel = 2.5,
		},
		chance = {
			Base = 70,
			AbilityLevel = 1,
		},
		ticks = {
			Base = 3,
			
		},
		range = {
			Base = -2,
			AbilityLevel = 2
		},
	},
	C = {
		Name = "Nether Bolt",
		Desc = "climethestair fires a fast bolt that deals <damage> damage and slows the first target it hits by 35% for 2.5 seconds, for each level, the bolt obtains <range> range.",
		MaxLevel = 7,
		damage = {
			H4xAbilityLevel = 0.015,
			H4x = 0.3,
			Base = 10,
			AbilityLevel = 10
		},
		range = {
			Base = -2,
			AbilityLevel = 2
		},
	},
	D = {
		Name = "Abyssal Gate",
		Desc = "climethestair builds a teleporter in a specified location, the teleporter will teleport any ally who touches it to him. and has a duration of 3 minutes",
		MaxLevel = 1,
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