function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/EjobBasicAttackFinal-item?id=263067721")
	d.PLAY_SOUND(d.HUMAN, 13510737, nil, 2)

	wait(0.35)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Shape = "Ball"
	part.Material = d.CHAR.Torso.Materials.Value
	part.Size = Vector3.new(1, 1, 1)
	part.BrickColor = BrickColor.new(script.Parent.Parent.Character.Torso.attack.Value.Color)
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
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
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/EjobGizmoBombFinal-item?id=263068246")
	d.PLAY_SOUND(d.HUMAN, 13510737, nil, 1.5)
	d.SFX.Trail:Invoke(d.CHAR["Right Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skills.Value.Color)}, 0.25, 0.35)
	wait(0.35)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 50
	local width = 4.5
	local range = 40
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Shape = "Ball"
	part.Material = d.CHAR.Torso.Materials.Value
	part.Size = Vector3.new(2, 2, 2)
	part.BrickColor = BrickColor.new(script.Parent.Parent.Character.Torso.Devices.Value.Color)
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
	end
	local function onStep(projectile)
		part.CFrame = CFrame.new(projectile.Position)
	end
	local function onEnd(projectile)
		d.PLAY_SOUND(part, 12222084, nil, 2)
		
		local center = projectile.Position
		local radius = 15
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
			d.CONTROL.AbilityCooldownReduce:Invoke("B", 0.5)
			d.CONTROL.AbilityCooldownReduce:Invoke("C", 0.5)
			d.CONTROL.AbilityCooldownReduce:Invoke("D", 0.5)
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Explosion:Invoke(center, radius, script.Parent.Parent.Character.Torso.Skills.Value.Color)
		
		part.Transparency = 1
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 25)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/EjobHealGelFinal-item?id=263068598")
	d.PLAY_SOUND(d.HUMAN, 13510737, nil, 1.25)

	wait(0.35)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 50
	local width = 12
	local range = 48
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local heal = ability:C(data.heal)
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Shape = "Ball"
	part.Material = d.CHAR.Torso.Materials.Value
	part.Size = Vector3.new(2, 2, 2)
	part.BrickColor = BrickColor.new(script.Parent.Parent.Character.Torso.Devices.Value.Color)
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	if d.CHAR.RequiredLevel.Value == 1 then
		part.Material = "DiamondPlate"
	end
	--[[local missingHealth = (d.HUMAN.MaxHealth - d.HUMAN.Health) / d.HUMAN.MaxHealth * 1 
	local finalheal = missingHealth 
	finalheal = heal + missingHealth / 100 + 1]]

	local function onHit(projectile, ally)
		d.DS.Heal:Invoke(ally, heal)     
		d.ST.MoveSpeed:Invoke(ally, .3, 4.5)
		
		if ally.Parent then
			if ally.Parent:FindFirstChild("HumanoidRootPart") then
				d.SFX.Artillery:Invoke(d.FLAT(ally.Parent.HumanoidRootPart.Position), 6, script.Parent.Parent.Character.Torso.Skills.Value.Color)
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
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 25 - (25 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.3)
	local percent = ability:C(data.percent)
	local missingHealthPercent = (d.HUMAN.MaxHealth - d.HUMAN.Health) / d.HUMAN.MaxHealth * 100
	local percentBoost = percent * missingHealthPercent
	percentBoost = percentBoost / 100 + 1

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/EjobEmergencyArmorFinal-item?id=263069193")
	d.PLAY_SOUND(d.HUMAN, 13510737, nil, 0.75)

	local center = d.HRP.Position
	local radius = 16
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local buff = ability:C(data.buff)
	local duration = ability:C(data.duration)
	local function onHit(ally)
		if ally.Parent:FindFirstChild("Shield") then
		d.ST.StatBuff:Invoke(ally, "Shields", buff* percentBoost, duration)
		end
	end
	d.SFX.Shockwave:Invoke(d.FLAT(center), radius, script.Parent.Parent.Character.Torso.Skills.Value.Color)
	
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 75 - (75 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/EjobHyperionSkyCannonFinal-item?id=263069495")
	wait(0.15)
	local a = d.HRP.Position
	local range = 256
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 34
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	local function onHit(enemy)
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
	end
	d.SFX.Artillery:Invoke(center, 8, script.Parent.Parent.Character.Torso.Skills.Value.Color, 2)
	wait(2)
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Artillery:Invoke(center, radius, script.Parent.Parent.Character.Torso.Skills.Value.Color)

	local sp = Instance.new("Part")
	sp.Anchored = true
	sp.CanCollide = false
	sp.Transparency = 1
	sp.Position = d.FLAT(center)
	sp.Parent = workspace
	d.DB(sp)
	d.PLAY_SOUND(sp, 12222084, 1, 0.8)
end


local abilityData = {
	A = {
		Name = "Gizmo Bomb",
		Desc = "ejob throws out a gizmo bomb which explodes on contact with an enemy or when it reaches the end of its range. It deals <damage> damage to each enemy hit, and also cools down each of his other spells by 0.5 seconds for each enemy hit.",
		MaxLevel = 5,
		damage = {
			Base = 25,
			AbilityLevel = 10,
			H4x = 0.3,
		},
	},
	B = {
		Name = "Type-4 HealGel Dispersion Device",
		Desc = "ejob deploys a device which flies forward in a line, healing allies it comes near for <heal> and granting them a 30% speed buff for 4.5 seconds.",
		MaxLevel = 5,
		heal = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.35,
		},
	},
	C = {
		Name = "Auto-deploy Emergency Armor System",
		Desc = "ejob applies shields to nearby allies, giving them <buff> protection for <duration> seconds. The potency of the buff increases by <percent>% per 1% of ejob's missing health as well as allies missing health, meaning the lower your health is, the more effective the buff becomes.",
		MaxLevel = 5,
		buff = {
			Base = 7.5,
			AbilityLevel = 2.5,
			H4x = 0.3,
		},
		duration = {
			Base = 3,
		},
		percent = {
			Base = 2
		},
	},
	D = {
		Name = "Hyperion Sky-cannon Barrage",
		Desc = "ejob targets a strike from his Hyperion Sky-cannon, dealing <damage> damage and slowing <slow>% for <duration> seconds in a huge area at the targeted location. This ability can be targeted at a great distance.",
		MaxLevel = 3,
		damage = {
		    Base = 40,
			AbilityLevel = 15, 
			H4x = 0.45,
		},
		slow = {
			Base = 22.5,
			AbilityLevel = 10,
		},
		duration = {
			Base = 3,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 140 + level * 20
	end,
	H4x = function(level)
		return 4 + 0.75 * level
	end,
	Toughness = function(level)
		return 5 + 0.75 * level
	end,
	Resistance = function(level)
		return 5 + 0.5 * level
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test