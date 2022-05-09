local basicRange = 32
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.125 -(1.125 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/SorcusBasicAttackFinal-item?id=261285178")
	wait(0.1)
	d.PLAY_SOUND(d.HUMAN, 16211041)

	local position = d.CHAR.Bow.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = basicRange
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.4
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Custom"
	part.Size = Vector3.new(0.2, 0.2, 1.6)
	part.BrickColor = BrickColor.new("Brown")
	part.Material = "Wood"
	part.Parent = game.ReplicatedStorage
	Instance.new("Fire", part).Size = 5
	d.DB(part)
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		local bonus = projectile.Distance / 1 / 100 + 0.81
		d.DS.Damage:Invoke(enemy, damage * bonus, "Toughness", d.PLAYER)
		
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, range <= 32)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,d.CHAR.Torso.Skill3.Value.Color, 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 7 - (7 * d.CONTROL.GetStat:Invoke("CooldownReduction"))) 

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/SorcusPiercingArrowFinal-item?id=261285442")
	wait(0.15)
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 1.1)

	local position = d.CHAR.Bow.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 64
	local width = 3.5
	local range = basicRange
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)

	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Custom"
	part.Size = Vector3.new(0.3, 0.3, 1.8)
	part.BrickColor = BrickColor.new("Brown")
	part.Material = "Wood"
	part.Parent = game.ReplicatedStorage
	Instance.new("Fire", part).Size = 5
	d.DB(part)
	
	local function onHit(projectile, enemy)
			local center = projectile.Position
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		d.SFX.Explosion:Invoke(center, 2, "Bright orange")
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,d.CHAR.Torso.Skill3.Value.Color, 0.25,direction,"Neon",0.039)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

    d.SFX.Artillery:Invoke(d.HRP.Position, 3, "Really red")
	
	local range = ability:C(data.range)
	local duration = ability:C(data.duration)
	local sparkles = d.CHAR:FindFirstChild("Sharpshooter", true)
	
	basicRange = basicRange + range
	sparkles.Enabled = true
	wait(duration)
	basicRange = 32
	sparkles.Enabled = false
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/SorcusExplosiveArrowFinal-item?id=261291611")
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 0.8)
	local center2 = d.CHAR.Bow.Position
	    d.SFX.ReverseExplosion:Invoke(center2, 4, "Really red",0.2)
	--d.SFX.Artillery:Invoke(d.DS.Targeted:Invoke(d.HRP.Position, 45,d.MOUSE_POS), 9,script.Parent.Parent.Character.Torso.Skill3.Value.Color , 0.5)
		

	
	local a = d.HRP.Position
	local range = 45
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	d.SFX.ReverseExplosion:Invoke(center, 12, script.Parent.Parent.Character.Torso.Skill3.Value.Color,.45)
		wait(0.6)
	local radius = ability:C(data.size)
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	local function onHit(enemy)
		d.DS.KnockAirborne:Invoke(enemy, 16, duration)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Artillery:Invoke(center, radius,  script.Parent.Parent.Character.Torso.Skill3.Value.Color)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/SorcusArrowofRedcliffFinal-item?id=261293949")
	d.CONTROL.AbilityCooldownLag:Invoke("Q", 1)
	d.CONTROL.AbilityCooldownLag:Invoke("A", 1)
	d.CONTROL.AbilityCooldownLag:Invoke("B", 1)
	d.CONTROL.AbilityCooldownLag:Invoke("C", 1)
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skill3.Value.Color)}, 0.5)
    wait(.75)
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 1.5)

	local position = d.CHAR.Bow.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 85
	local width = 4
	local range = 1024
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Custom"
	part.Size = Vector3.new(1, 0.8, 3)
	part.BrickColor = BrickColor.new("Tan")
	part.Material = "Wood"
	part.Parent = game.ReplicatedStorage
	Instance.new("Fire", part).Size = 5
	d.DB(part)
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		local center = projectile.Position
		local bonus = projectile.Distance / 10 / 100 + 1.5
		d.DS.Damage:Invoke(enemy, damage * bonus, "Toughness", d.PLAYER) 
		d.SFX.Explosion:Invoke(center, 6, "Really red")
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,d.CHAR.Torso.Skill3.Value.Color, 0.25,direction,"Neon",0.039)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Piercing Arrow",
		Desc = "Sorcus fires an arrow which deals <damage> damage to targets it passes through. This ability copies Sorcus' basic attack range.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 10,
			Skillz = 0.35,
		},
	},
	B = {
		Name = "Sharpshooting",
		Desc = "[Innate] Typically based on Sorcus' hunter instinct, Sorcus basic attacks deal more damage based on how far it travels, meaning the further away his target is, the more impact it will do. [Active] Sorcus increases his basic attack range by <range> studs for <duration> seconds. During this time, he cannot hit turrets.",
		MaxLevel = 5,
		range = {
			Base = 4,
			AbilityLevel = 2.5,
		},
		duration = {
			Base = 8,
		},
	},
	C = {
		Name = "Explosive Arrow",
		Desc = "Sorcus fires an exploding arrow to the targeted location, dealing <damage> damage and knocking up targets for <duration> seconds. The size of the explosion is <size> studs.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 12.5,
			Skillz = 0.25,
		},
		duration = {
			Base = 0.5,
			AbilityLevel = 0.1,
		},
		size = {
			Base = 12,
			
		}
	},
	D = {
		Name = "Arrow of Redcliff",
		Desc = "Sorcus fires a white-hot arrow which has no range restriction. The arrow strikes the target's vitals, dealing <damage> damage to the first target hit and gains 1.5% extra damage for every 10 studs it travels, meaning that distant targets take more damage.",
		MaxLevel = 3,
		damage = {
			Base = 10,
			AbilityLevel = 10,
			Skillz = 0.45,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 160 + level * 10
	end,
	Skillz = function(level)
		return 4 + level * 0.9
	end,
	Toughness = function(level)
		return 5 + level * 0.5
	end,
	Resistance = function(level)
		return 5 + level * 0.25
	end,
	Speed = function(level)
		return 14.5
	end,
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test