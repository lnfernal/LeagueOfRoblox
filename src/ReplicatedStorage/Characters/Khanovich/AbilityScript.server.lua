local SPEAR = Instance.new("Part")
SPEAR.Anchored = true
SPEAR.CanCollide = false
SPEAR.FormFactor = "Custom"
SPEAR.Size = Vector3.new(1, 1, 1)
local mesh = Instance.new("SpecialMesh", SPEAR)
mesh.MeshId = "http://www.roblox.com/asset/?id=38164532"
mesh.TextureId = "http://www.roblox.com/asset/?id=38162038"
mesh.Scale = Vector3.new(1, 1, 1)


local lastAbility = "Q"

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_SOUND(d.HUMAN, 12222216)
	wait(.2)
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.25
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	
	end
	
	  
	d.DS.Melee:Invoke(hrp, team, onHit,8.5,6)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/KhanovichBasicAttackFinal-item?id=270213299")
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	lastAbility = "A"
	
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
		
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
		
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/KhanovichSpearThrowFinal-item?id=270202340")
	wait(0.3)
	d.PLAY_SOUND(d.HUMAN, 12222200, 1)

	d.CHAR.Spear.Transparency = 1
	
	local part = SPEAR:Clone()
	--d.CW(part)
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local position = d.CHAR.Spear.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 48
	local speed = 64
	local width = 4
	
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	end
	local function onStep(p, dt)
		
	end
	local function onEnd(p)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(0, math.pi, 0))
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"Really red", 0.25,direction,"DiamondPlate",0.039)
	wait(0.3)
	d.CHAR.Spear.Transparency = 0
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 13 - (13 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	lastAbility = "B"

	local damage = ability:C(data.damage)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/KhanovichBearChargeFinal-item?id=263057592")
	wait(0.25)
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 32
	local speed = range / 0.75
	local width = 6

	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		local hrp = d.GET_HRP(enemy)
		if hrp then
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			d.SFX.Artillery:Invoke(d.FLAT(hrp.Position), 8, "Reddish brown")
			d.PLAY_SOUND(enemy, 84937942, nil, 1.5)
		end
	end
	local function onStep(p, dt)
		
	end
	local function onEnd(p)
		d.HRP.CFrame = p:CFrame()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 17.5 - (17.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	lastAbility = "C"
	local damage = ability:C(data.damage)
	local function PickStunDuration()
		local Values = {1, 1.1, 1.2, 1.3, 1.4, 1.5}
		return Values[math.random(1, #Values)]
	end
	
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C("Brown"), Transparency = 0.5}, 0.5)
	wait(0.625)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/KhanovichImABearFinal-item?id=263058016")
	d.PLAY_SOUND(d.HUMAN, 12222084)
	
	local center = d.HRP.Position
	local radius = ability:C(data.radius)
	local team = d.CHAR.Team.Value
	local stun = PickStunDuration()
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		d.ST.Stun:Invoke(enemy, stun)
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Explosion:Invoke(center, radius, "Reddish brown")
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", ability:C(data.cooldown) - (ability:C(data.cooldown) * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.CONTROL.AbilityCooldownReduce:Invoke(lastAbility, 120)
	if lastAbility == "A" then
		ability1(d)
	elseif lastAbility == "B" then
		ability2(d)
	else
		ability3(d)
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Spear Throw",
		Desc = "Khanovich throws his spear, dealing <damage> damage to each enemy it passes through. It also slows them <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 5,
			Skillz = 0.3
		},
		slow = {
			Base = 25,
			AbilityLevel = 2
		},
		duration = {
			Base = 2.25,
			
		}
	},
	B = {
		Name = "Bear Charge",
		Desc = "Khanovich charges forward, dealing <damage> damage to each enemy hit. This ability's damage increases with Khanovich's maximum health.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 10,
			Health = 0.065,
		},
	},
	C = {
		Name = "I'M A BEAR!",
		Desc = "Khanovich's trusty steed lets out a battle roar, dealing <damage> damage and stunning nearby enemies for anywhere from 1 to 1.5 seconds. The radius of this ability is <radius> studs.",
		MaxLevel = 5,
		radius = {
			Base = 13,
			AbilityLevel = 0.75
			
			},
		damage = {
			Base = 10,
			AbilityLevel = 5,
			Skillz = 0.325,
		}
	},
	D = {
		Name = "Unstoppable",
		Desc = "Khanovich repeats the last ability he used. This ability's cooldown is <cooldown> seconds.",
		MaxLevel = 3,
		cooldown = {
			Base = 26,
			AbilityLevel = -2
			
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