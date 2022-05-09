local CooldownBasic = 1.2
local CooldownReduction = 0
local mechanicalArm = false
local grenadeRange = 40

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", CooldownBasic - (CooldownBasic * CooldownReduction) - (CooldownBasic * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_SOUND(d.HUMAN, 12222132, nil, 1)
	
	wait(0.125)
	
	local position = d.CHAR["Rocket Exit"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 64
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.3
	
	local part = Instance.new("Part")
	local mesh = Instance.new("SpecialMesh")
	part.Anchored = true
	part.CanCollide = false
	part.Shape = "Block"
	part.Size = Vector3.new(1, 1, 2.6)
	part.BrickColor = BrickColor.new("Medium stone grey")
	mesh.Scale = Vector3.new(2,2,2)
	mesh.MeshId = "http://www.roblox.com/asset/?id=103970395"
	mesh.TextureId = d.CHAR.Weapon.Mesh.TextureId
	mesh.Parent = part
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local function onHitt(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	local function onHit(projectile, enemy)
		projectile.Moving = false
		if enemy.Parent.Name == "Turret" then
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		end
	end
	local function onStep(projectile)
		local function onStep(projectile)
		topos = projectile.Position 
	
	
	d.SFX.Circles:Invoke(topos, 8,d.CHAR.Torso.Skills.Value.Color,.2,dir)  
	end
	end
	local function onEnd(projectile)
		d.DS.AOE:Invoke(projectile.Position, 8, team, onHitt)
		d.SFX.Explosion:Invoke(projectile.Position, 8, d.CHAR.Torso.Skills.Value.Color)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,d.CHAR.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 15  - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ColdArmadaGrenadeThrow-item?id=438257396")
	d.CONTROL.AbilityCooldownLag:Invoke("Q", .8)
	d.CONTROL.AbilityCooldownLag:Invoke("B", .8)
	d.CONTROL.AbilityCooldownLag:Invoke("C", .8)
	wait(0.6)
	d.PLAY_SOUND(d.HUMAN, 13510737)
	
	local a = d.CHAR["Left Arm"].CFrame:pointToWorldSpace(Vector3.new(0, -1, 0))
	local maxRange = grenadeRange
	local b = d.DS.Targeted:Invoke(a, maxRange, d.GET_TARGET_POS())
	local vector = (b - a)
	local range = vector.magnitude
	local direction = vector.unit
	local speed = 96
	if mechanicalArm == true then
		speed = 128
	end
	local width = 0
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local damage2 = ability:C(data.damage2)
	local duration = ability:C(data.duration)
	
	local part = Instance.new("Part")
	local mesh = Instance.new("SpecialMesh")
	local fire = Instance.new("Fire")
	part.Anchored = true
	part.CanCollide = false
	part.Shape = "Block"
	part.Size = Vector3.new(1, 2, 1)
	part.BrickColor = BrickColor.new("Crimson")
	part.Transparency = 0.21
	fire.Heat = 9
	fire.Size = 2
	fire.Parent = part
	mesh.Scale = Vector3.new(1.5, 1.5, 1.4)
	mesh.MeshId = "http://www.roblox.com/asset/?id=29690481"
	mesh.Parent = part
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	
	
	local function onHit(p, enemy)
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		local position = p.Position
		local radius = 16
		if mechanicalArm == true then
			radius = 20
		end
		local function onHit(enemy)
			if mechanicalArm == true then
				d.DS.Damage:Invoke(enemy, damage * 1.2, "Toughness", d.PLAYER)
			else
				d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
				if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
			end
		end
		d.DS.AOE:Invoke(position, radius, team, onHit)
		d.SFX.Explosion:Invoke(position, radius, "Crimson")
		d.PLAY_SOUND_POS(position, 365002938, 2)
		local t = 0
		d.SFX.AreaAOEStart:Invoke(d.FLAT(position), radius, "Crimson",duration)
		while t < duration do
			local dt = wait(.25)
			t = t + dt
			local function onHit(enemy)
				if mechanicalArm == true then
					d.DS.Damage:Invoke(enemy, damage2 * .275, "Toughness", d.PLAYER)
				d.SFX.PartRandomFollow:Invoke(enemy.Parent.Torso, 3, "Crimson")
				else
					d.DS.Damage:Invoke(enemy, damage2 * .25, "Toughness", d.PLAYER)
				d.SFX.PartRandomFollow:Invoke(enemy.Parent.Torso, 1.5, "Crimson")
				end
			end
			d.DS.AOE:Invoke(position, radius, team, onHit)
			
		end
	end
	local p = d.DS.AddProjectile:Invoke(a, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(0, math.pi, 0))
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 15  - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local waittime = ability:C(data.duration)
	local stun = ability:C(data.duration2)
	local acooldown = ability:C(data.duration3)
	local damage = ability:C(data.damage)
	local damage2 = ability:C(data.damage2)
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ColdArmadaGrenadeThrow-item?id=438257396")
	d.CONTROL.AbilityCooldownLag:Invoke("Q", .8)
	d.CONTROL.AbilityCooldownLag:Invoke("A", .8)
	d.CONTROL.AbilityCooldownLag:Invoke("C", .8)
	wait(0.5)
	d.PLAY_SOUND(d.HUMAN, 13510737)
	
	local a = d.CHAR["Left Arm"].CFrame:pointToWorldSpace(Vector3.new(0, -1, 0))
	local maxRange = grenadeRange
	local b = d.DS.Targeted:Invoke(a, maxRange, d.GET_TARGET_POS())
	local vector = (b - a)
	local range = vector.magnitude
	local direction = vector.unit
	local speed = 128
	local width = 0
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		if mechanicalArm == true
		then waittime = ability:C(data.duration) --Changed waittime from 0 to ability:C(data.duration)
		end
		delay(waittime, function()
			local position = p.Position
			local radius = 15
			if mechanicalArm == true then --Added if mechanicalArm ==  true then local radius = 20(from 15)
				local radius = 30
			end
			local function onHit(enemy)
				d.ST.Stun:Invoke(enemy, stun)
				d.DS.Damage:Invoke(enemy, 0, nil, d.PLAYER, acooldown)
				d.DS.Damage:Invoke(enemy, damage2, "Toughness", d.PLAYER)
	            if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage2*1, "Toughness", d.PLAYER)
		end 
				if mechanicalArm == true then
					d.ST.DOT:Invoke(enemy, damage, 3, "Toughness", d.PLAYER, "Shocked!")
				end
			end
			d.DS.AOE:Invoke(position, radius, team, onHit)
			d.SFX.Explosion:Invoke(position, radius, "Really blue")
			d.PLAY_SOUND_POS(position, 12222084)
		end)
	end
	local p = d.DS.AddProjectile:Invoke(a, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 1, "Bright blue", 0.1)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 15  - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local duration = ability:C(data.duration)
	local duration2 = ability:C(data.duration2)
	local damage = ability:C(data.damage)
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ColdArmadaGrenadeThrow-item?id=438257396")
	d.CONTROL.AbilityCooldownLag:Invoke("Q", .8)
	d.CONTROL.AbilityCooldownLag:Invoke("A", .8)
	d.CONTROL.AbilityCooldownLag:Invoke("B", .8)
	wait(0.5)
	d.PLAY_SOUND(d.HUMAN, 13510737)
	
	local a = d.CHAR["Left Arm"].CFrame:pointToWorldSpace(Vector3.new(0, -1, 0))
	local maxRange = grenadeRange
	local b = d.DS.Targeted:Invoke(a, maxRange, d.GET_TARGET_POS())
	local vector = (b - a)
	local range = vector.magnitude
	local direction = vector.unit
	local speed = 128
	local width = 0
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		if mechanicalArm == true then
			duration2 = 0.6
		end
		delay(duration2, function()
			local position = p.Position
			local radius = 15
			local function onHit(enemy)
				d.ST.Blind:Invoke(enemy, duration)
				d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
				if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
				d.ST.DOT:Invoke(enemy, 0, 1, 0, d.PLAYER, "Blinded!")
				if mechanicalArm == true then
					d.ST.MoveSpeed:Invoke(enemy, -.4, 2)
				end
			end
			d.DS.AOE:Invoke(position, radius, team, onHit)
			d.SFX.Explosion:Invoke(position, radius, "White")
			d.PLAY_SOUND_POS(position, 12222084)
		end)
	end
	local p = d.DS.AddProjectile:Invoke(a, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 1, "White", 0.1)
	--fbmeshc.Parent = p
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 50  - (50 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local buff = ability:C(data.percent2)/100
	local buff2 = ability:C(data.bonus)
	local duration = ability:C(data.duration)
	local speedbuff = ability:C(data.percent)/100
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ColdArmadaExosuitEquip-item?id=438492332")
	
	d.ST.MoveSpeed:Invoke(d.HUMAN, -.3, 1.3)
	d.CHAR.Weapon.Transparency = 1
	d.CONTROL.AbilityCooldownLag:Invoke("Q", 1.3)
	d.CONTROL.AbilityCooldownLag:Invoke("A", 1.3)
	d.CONTROL.AbilityCooldownLag:Invoke("B", 1.3)
	d.CONTROL.AbilityCooldownLag:Invoke("C", 1.3)
	wait(1.3)
	d.CHAR.Weapon.Transparency = 0
	
	local Exosuit_Parts = d.CHAR:GetChildren()
	
	for i = 1, #Exosuit_Parts do
		if Exosuit_Parts[i].Name == "Exosuit" then
			Exosuit_Parts[i].Transparency = 0
			delay(duration, function()
				Exosuit_Parts[i].Transparency = 1
			end)
		end
	end
	d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", d.CONTROL.GetStat:Invoke("Toughness") * buff, duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "Resistance", d.CONTROL.GetStat:Invoke("Resistance") * buff, duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", buff2, duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "Resistance", buff2, duration)
	d.ST.MoveSpeed:Invoke(d.HUMAN, speedbuff, duration)
	mechanicalArm = true
	delay(duration, function()
		mechanicalArm = false
	end)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Molotov",
		Desc = "ColdArmada throws a molotov to the targeted location. This will explode on impact, dealing <damage> damage to nearby enemies. The area it lands in burns, doing extra <damage2> damage to nearby enemies for <duration> seconds. If the Exosuit is equipped, the molotov gains a larger area of damage and burn, a faster projectile speed, and slightly more overall damage.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 7.5,
			Skillz = .25,
		},
		damage2 = {
			Base = 10,
			AbilityLevel = 10,
			Skillz = .2,
		},
		duration = {
			Base = 5,
			
		}
	},
	B = {
		Name = "EMP Grenade",
		Desc = "ColdArmada throws a EMP grenade which detonates after <duration> seconds. This stuns enemies for <duration2> seconds and increases the cooldown of enemy moves by <duration3> seconds. If the Exosuit is equipped, the grenade is supercharged and as such has a larger explosion radius.",
		MaxLevel = 5,
		duration = {
			Base = 0.65,
			
		},
		duration2 = {
			Base = 1,
			AbilityLevel = .1,
		},
		duration3 = {
			Base = 3.5,
			
		},
		damage = {
			AbilityLevel = 0, --Changed 4.4 to 0
			Skillz = 0, --Changed .22 to 0
		},
		damage2 = {
			AbilityLevel = 0, --Changed 2.2 to 0
			Skillz = 0, --Changed .11 to 0
		}
	},
	C = {
		Name = "Flashbang",
		Desc = "ColdArmada throws a flashbang which explodes after <duration2> seconds, unleashing a blast to blind enemy champions for <duration> seconds while also fragmenting enemies for <damage> damage. If the Exosuit is equipped, the sheer velocity of the grenade shocks enemies into being slowed by 40% for 2 seconds.",
		MaxLevel = 5,
		duration = {
			Base = 1.25,
			AbilityLevel = .15,
		},
		duration2 = {
			Base = 0.75,
			
		},
		damage = {
			Base = 11,
			AbilityLevel = 11,
			Skillz = .2,
		},
	},
	D = {
		Name = "Exosuit",
		Desc = "After a brief startup, ColdArmada equips an exosuit, which grants <percent2>% and <bonus> bonus toughness and resistance as well as <percent>% bonus speed. The exosuit has a mechanical arm built in that causes his grenades to gain a bonus effect. Lasts <duration> seconds.",
		MaxLevel = 3,
		percent = {
			Base = 15,
			AbilityLevel = 5,
		},
		duration = {
			Base = 4.5,
			
		},
		percent2 = {
			Base = 25,
		},
		bonus = {
			Base = 20,
			AbilityLevel = 5,
			Skillz = .2,
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