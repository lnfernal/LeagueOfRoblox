local DISC = Instance.new("Part")
DISC.Anchored = true
DISC.CanCollide = false
DISC.FormFactor = "Custom"
DISC.Size = Vector3.new(1, 0.2, 1)
DISC.BrickColor = BrickColor.new("Camo")
Instance.new("CylinderMesh", DISC)

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/CupcakeBasicAttackFinal-item?id=263092714")
	d.PLAY_SOUND(d.HUMAN, 97848313, nil, 0.8)
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.4
		
	local position = d.CHAR.GunBarrel.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 32
	local width = 3.5
	local speed = 64
	local team = d.CHAR.Team.Value
	local part = DISC:clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		
	end
	local function onStep(p, dt)
	end
	local function onEnd()
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,d.CHAR.Torso.Basic.Value.Color, 0.25,direction,"Neon",0.039)
	d.SFX.Explosion:Invoke(position, 2, d.CHAR.Torso.Skills.Value.Color)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 10  - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local center = d.CHAR.GunBarrel.Position
d.SFX.ReverseExplosion:Invoke(center, 6, tostring(d.CHAR.Torso.Basic.Value), 0.1)
wait(0.2)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/CupcakeSpreadFireFinal-item?id=263093013")
	d.PLAY_SOUND(d.HUMAN, 97848313, nil, 0.6)
	
	local damage = ability:C(data.damage)
	
	local position = d.CHAR.GunBarrel.Position
	local range = 40
	local width = 4.5
	local speed = 64
	local team = d.CHAR.Team.Value
	local part = DISC:clone()
			part.Parent = game.ReplicatedStorage
			d.DB(part)
			
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
	end
	local function onStep(p, dt)
	end
	local function onEnd()
		part:Destroy()
	end
	
	local spread = math.pi / 9
	for theta = -spread, spread, spread do
		local position = d.CHAR.GunBarrel.Position
		local direction = (d.HRP.CFrame * CFrame.Angles(0, theta * 0.5, 0)).lookVector
		local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(-math.pi / 2, 0, 0))
		
			d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,d.CHAR.Torso.Basic.Value.Color, 0.25,direction,"Neon",0.039)
				 end 
			 d.SFX.Explosion:Invoke(position, 4, d.CHAR.Torso.Skills.Value.Color)
				
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12.5  - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/CupcakeMagnumRoundFinal-item?id=263093194")
	d.PLAY_SOUND(d.HUMAN, 97848313, nil, 1.3)
	
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
		local part = DISC:clone()
			part.Parent = game.ReplicatedStorage
			d.DB(part)
	local position = d.CHAR.GunBarrel.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 40
	local width = 4
	local speed = 64
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	local function onStep(p, dt)
	end
	local function onEnd()
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(-math.pi / 2, 0, 0))
	d.SFX.Explosion:Invoke(position, 6, d.CHAR.Torso.Skills.Value.Color)
	d.SFX.ProjZap:Invoke(p:ClientArgs(), 0.6, d.CHAR.Torso.Skills.Value.Color, 0.2)
	
	local position = d.HRP.Position
	local direction = -d.HRP.CFrame.lookVector
	local range = 18
	local speed = 64
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local function onHit()
	end
	local function onStep(p, dt)
		topos = p.Position 
	 
	
	
	end
	local function onEnd(p, dt)
		d.HRP.CFrame = p:CFrame()
	end
	p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
	repeat 
	wait(.1)
	circles = circles + 1
	d.SFX.Circles:Invoke(topos, 6,"Camo",.2,dir)
	until circles == 3
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 17.5)
		
	local percent = ability:C(data.percent)/100
	local missing = d.HUMAN.MaxHealth - d.HUMAN.Health
	local percentheal = missing * percent
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/CupcakeMuffinTimeFinal-item?id=263093417")
	wait(0.3)
	
	d.DS.Heal:Invoke(d.HUMAN, percentheal)
	d.SFX.Explosion:Invoke(d.HRP.Position, 4, "Bright green")
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 35  - (35 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local center = d.CHAR.GunBarrel.Position
    d.SFX.ReverseExplosion:Invoke(center, 5, tostring(d.CHAR.Torso.Basicult.Value), 0.1)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/CupcakeSlugFinal-item?id=263093734")
	d.PLAY_SOUND(d.HUMAN, 97848313, nil, 0.4)
	wait(0.15)
	local damage = ability:C(data.damage)
	
		
	local position = d.CHAR.GunBarrel.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 40
	local width = 4.5
	local speed = 80
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		local bonus = p.Distance*ability:C(data.bonus)
		p.Moving = false
		
			d.ST.MoveSpeed:Invoke(enemy, -1, 0.5 + bonus)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	end
	local function onStep(p, dt)
		
	end
	local function onEnd()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.Explosion:Invoke(position, 2, d.CHAR.Torso.Skills.Value.Color)
	d.SFX.ProjZap:Invoke(p:ClientArgs(), 0.6, d.CHAR.Torso.Basicult.Value.Color, 0.3)

end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Spread Fire",
		Desc = "Cupcake fires 3 projectiles in a cone-like pattern. Each deal <damage> damage to the first target they hit. This skill gains damage with each kill that Cupcake gets.",
		MaxLevel = 5,
		damage = {
			Base = 12.5,
			AbilityLevel = 5,
			Skillz = 0.125,
			Kills = 5,
		},
	},
	B = {
		Name = "Magnum Round",
		Desc = "Cupcake fires a powerful shot, dealing <damage> damage to and slowing <slow>% for <duration> seconds each target the projectile passes through. The power of the shot pushes Cupcake backwards.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 10,
			Skillz = 0.3,
		},
		slow = {
			Base = 25,
	
		},
		duration = {
			Base = 2.75,
		},
	},
	C = {
		Name = "Muffin Time!",
		Desc = "Cupcake noms a muffin, healing her for <percent>% of her missing health.",
		MaxLevel = 5,
		percent = {
			Base = 20,
			AbilityLevel = 2,
		},
	},
	D = {
		Name = "Slug",
		Desc = "Cupcake fires a heavy-duty round that deals <damage> damage to the first target it hits, as well as rooting her target for 0.5 seconds. The duration of the stun increases by <bonus> seconds for each stud that the slug travels.",
		MaxLevel = 3,
		damage = {
			Base = 20,
			AbilityLevel = 12.5,
			Skillz = 0.475,
		},
		bonus = {
			Base = 0.03,
			
			
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 110 + level * 11
	end,
	Skillz = function(level)
		return 5 + level * 0.9
	end,
	Toughness = function(level)
		return 5 + level * 0.5
	end,
	Resistance = function(level)
		return 5 + level * 0.4
	end,
	Speed = function(level)
		return 14.5
	end
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