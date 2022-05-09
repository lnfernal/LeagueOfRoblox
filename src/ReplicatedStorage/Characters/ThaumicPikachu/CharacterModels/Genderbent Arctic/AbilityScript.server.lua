local Part = Instance.new("Part")
Part.Size = Vector3.new(1, 1, 1.5)
Part.CanCollide = false
Part.Anchored = true
local mesh = Instance.new("SpecialMesh")
mesh.MeshId = "http://www.roblox.com/asset/?id=56343678"
mesh.Scale = Vector3.new(0.75, 0.75, 1)
mesh.TextureId = "http://www.roblox.com/asset/?id=56343726"
mesh.Parent = Part

local function Pick()
	local choices = {"Poison", "Rage", "Regular"}
	return choices[math.random(1, #choices)]
end


function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.1 - (1.1 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local choice = Pick()
	
	
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ThaumicBasic-item?id=456863073")
	
	wait(0.3)
	local part = Part:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	if choice == "Regular" then
		part.Mesh.VertexColor = Vector3.new(0.25, 0.8, 0.95)
	elseif choice == "Rage" then
		part.Mesh.VertexColor = Vector3.new(0.85, 0.5, 0.25)
	else --Poison
		part.Mesh.VertexColor = Vector3.new(1, 0.1, 0.8)		
	end
	d.PLAY_SOUND(d.HUMAN, 12222216, nil, 1.25)
	d.CHAR.Potion.Transparency = 1
	
	
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	local ragedamage = d.CONTROL.GetStat:Invoke("H4x") * 0.3
	
	local position = d.CHAR.Potion.Position + Vector3.new(0,3,0)
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 31
	local team = d.CHAR.Team.Value
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		if choice == "Regular" then
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		elseif choice == "Rage" then
		d.DS.Damage:Invoke(enemy, ragedamage, "Resistance", d.PLAYER)
		else
		d.ST.DOT:Invoke(enemy, damage, 2, "Resistance", d.PLAYER, "Poisoned!")
		end
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
		d.CHAR.Potion.Transparency = 0
	end
	
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(math.pi/2, 0, 0), {Spin = CFrame.Angles(0, 1/3, 0)})
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	--if d.CONTROL.GetStat:Invoke("Mana") <= ability:C(data.mana) then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	--d.CONTROL.SetStat:Invoke("Mana", d.CONTROL.GetStat:Invoke("Mana") - ability:C(data.mana))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ThaumicBasic-item?id=456863073")
	
	--d.PLAY_SOUND(d.HUMAN, 12222084, nil, 1.5)
	
	local part = Part:Clone()
	part.Parent = game.ReplicatedStorage
	part.Mesh.VertexColor = Vector3.new(0.25, 0.8, 0.95)
	wait(0.3)
	d.DB(part)
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	local slow = -ability:C(data.slow)/100
	local center = part.Position
	local radius = 12
	local team = d.CHAR.Team.Value
	local position = d.CHAR.Potion.Position + Vector3.new(0,3,0)
	local direction = d.HRP.CFrame.lookVector
	local speed = 50
	local width = 4
	local range = 40
	local created = false
	local function onHitt(enemy)
		d.ST.DOT:Invoke(enemy, damage, duration, "Resistance", d.PLAYER, "Freezing!")
		if enemy.Parent.Name == "Minion" then
			d.ST.DOT:Invoke(enemy, damage*1,duration, "Resistance", d.PLAYER)
		end 
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
	end
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		center = projectile.Position
		if created == false then
		created = true
		d.DS.AOE:Invoke(center, radius, team, onHitt)
		d.SFX.Cloud:Invoke(center, radius, "Pastel blue-green", duration)
		end
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		center = projectile.Position - Vector3.new(0,3,0)
		if created == false then
		created = true
		d.DS.AOE:Invoke(center, radius, team, onHitt)
		d.SFX.Cloud:Invoke(center, radius, "Pastel blue-green")
		end
	end

	
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(math.pi/2, 0, 0), {Spin = CFrame.Angles(0, 1/3, 0)})
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	--if d.CONTROL.GetStat:Invoke("Mana") <= ability:C(data.mana) then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	--d.CONTROL.SetStat:Invoke("Mana", d.CONTROL.GetStat:Invoke("Mana") - ability:C(data.mana))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ThaumicBasic-item?id=456863073")
	--d.PLAY_SOUND(d.HUMAN, 12221944)
	wait(0.3)
	local part = Part:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	part.Mesh.VertexColor = Vector3.new(0.25, 0.8, 0.95)
	
	local shred = -ability:C(data.shred)
	local duration = ability:C(data.duration)
	local radius = 11
	local team = d.CHAR.Team.Value
	local position = d.CHAR.Potion.Position + Vector3.new(0,3,0)
	local direction = d.HRP.CFrame.lookVector
	local speed = 50
	local width = 4
	local range = 48
	local created = false
	
	local function onHitt(enemy)
		d.ST.StatBuff:Invoke(enemy, "Toughness", shred, duration)
		d.ST.StatBuff:Invoke(enemy, "Resistance", shred, duration)
		d.DS.Damage:Invoke(enemy, (enemy.MaxHealth * .05), nil, d.PLAYER)
	end
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		center = projectile.Position
		if created == false then
		created = true
		d.ST.StatBuff:Invoke(enemy, "Toughness", shred, duration)
		d.ST.StatBuff:Invoke(enemy, "Resistance", shred, duration)
		d.DS.AOE:Invoke(center, radius, team, onHitt)
		d.SFX.Explosion:Invoke(center, radius, "Pastel blue-green")
		end
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		center = projectile.Position
		if created == false then
		created = true
		d.DS.AOE:Invoke(center, radius, team, onHitt)
		d.SFX.Explosion:Invoke(center, radius, "Pastel blue-green")
		end
	end
	
	
	
	
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(math.pi/2, 0, 0), {Spin = CFrame.Angles(0, 1/3, 0)})
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	--if d.CONTROL.GetStat:Invoke("Mana") <= ability:C(data.mana) then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 17.5)
	--d.CONTROL.SetStat:Invoke("Mana", d.CONTROL.GetStat:Invoke("Mana") - ability:C(data.mana))
	
	local heal = ability:C(data.heal)
	local buff = ability:C(data.amount)
	local duration = ability:C(data.duration)
	
	local part = Part:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	part.Mesh.VertexColor = Vector3.new(0.85, 0.5, 0.25)
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ThaumicAbility3-item?id=456867666")
	wait(0.3)
	--d.PLAY_SOUND(d.HUMAN, 12222208, nil, 0.7)
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 1
	local speed = 12.5
	local width = 1
	local radius = 18
	local center = d.CHAR.HumanoidRootPart.Position
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local function onHit(ally)
		d.DS.Heal:Invoke(ally, heal)
		d.ST.StatBuff:Invoke(ally, "Toughness", buff, duration)
		d.ST.StatBuff:Invoke(ally, "Resistance", buff, duration)
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Explosion:Invoke(center, radius, "Bright red")
	end
	local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, nil, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(math.pi/2, 0, 0), {Spin = CFrame.Angles(0, 1/3, 0)})
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	--if d.CONTROL.GetStat:Invoke("Mana") <= ability:C(data.mana) then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 70 - (70 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	--d.CONTROL.SetStat:Invoke("Mana", d.CONTROL.GetStat:Invoke("Mana") - ability:C(data.mana))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ThaumicUltimate-item?id=456870509")
	wait(0.7)
	local function throwpoison()
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ThaumicBasic-item?id=456863073")
	
	--d.PLAY_SOUND(d.HUMAN, 12222084, nil, 1.5)
	
	local part = Part:Clone()
	part.Parent = game.ReplicatedStorage
	part.Mesh.VertexColor = Vector3.new(0.25, 0.8, 0.95)
	wait(0.3)
	d.DB(part)
	local damage = ability:C(data.poisondamage)
	local duration = 1.5
	local slow = -ability:C(data.slow)/100
	local center = part.Position
	local radius = 14
	local team = d.CHAR.Team.Value
	local position = d.CHAR.Potion.Position + Vector3.new(0,3,0)
	local direction = d.HRP.CFrame.lookVector
	local speed = 50
	local width = 4
	local range = 40
	local created = false
	local function onHitt(enemy)
		d.ST.DOT:Invoke(enemy, damage, duration, "Resistance", d.PLAYER, "Freezing!")
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
	end
	
	local function onHit(projectile, enemy)
	projectile.Moving = false
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		center = projectile.Position - Vector3.new(0,3,0)
		d.DS.AOE:Invoke(center, radius, team, onHitt)
		d.SFX.Cloud:Invoke(center, radius, "Pastel blue-green")
		end
	

	
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(math.pi/2, 0, 0), {Spin = CFrame.Angles(0, 1/3, 0)})	
	end
	local function throwdebuff()
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ThaumicBasic-item?id=456863073")
	--d.PLAY_SOUND(d.HUMAN, 12221944)
	wait(0.3)
	local part = Part:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	part.Mesh.VertexColor = Vector3.new(0.25, 0.8, 0.95)
	
	local shred = -ability:C(data.debuff)/100
	local duration = 1.5
	local radius = 16
	local team = d.CHAR.Team.Value
	local position = d.CHAR.Potion.Position + Vector3.new(0,3,0)
	local direction = d.HRP.CFrame.lookVector
	local speed = 50
	local width = 4
	local range = 48
	
	local function onHitt(enemy)
		if enemy.Parent:FindFirstChild("GetStat",true) then
		d.ST.StatBuff:Invoke(enemy, "Toughness",enemy.Parent:FindFirstChild("GetStat",true):Invoke("Toughness") * (shred / 2), duration)
		d.ST.StatBuff:Invoke(enemy, "Resistance", enemy.Parent:FindFirstChild("GetStat",true):Invoke("Resistance") * (shred / 2), duration)
		d.DS.Damage:Invoke(enemy, (enemy.MaxHealth * .05), nil, d.PLAYER)
		end
	end
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		center = projectile.Position
		d.DS.AOE:Invoke(center, radius, team, onHitt)
		d.SFX.Explosion:Invoke(center, radius, "Pastel blue-green")
		
	end
	
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(math.pi/2, 0, 0), {Spin = CFrame.Angles(0, 1/3, 0)})	
	end
	local function throwdamage()
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ThaumicBasic-item?id=456863073")
	--d.PLAY_SOUND(d.HUMAN, 12221944)
	wait(0.3)
	local part = Part:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	part.Mesh.VertexColor = Vector3.new(0.85, 0.5, 0.25)
	
	local damage = ability:C(data.damage)
	local duration = 1.5
	local radius = 16
	local team = d.CHAR.Team.Value
	local position = d.CHAR.Potion.Position + Vector3.new(0,3,0)
	local direction = d.HRP.CFrame.lookVector
	local speed = 50
	local width = 4
	local range = 40
	local created = false
	
	local function onHitt(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		
	end
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		center = projectile.Position
		d.DS.AOE:Invoke(center, radius, team, onHitt)
		d.SFX.Explosion:Invoke(center, radius, "Bright red")
		
	end
	
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(math.pi/2, 0, 0), {Spin = CFrame.Angles(0, 1/3, 0)})	
	end
	local tosses = {throwdamage,throwdebuff,throwpoison}
	d.PLAY_SOUND(d.HUMAN, 144884907, nil , 0.85)
	
	local buff = ability:C(data.buff)/100
	local debuff = -ability:C(data.debuff)/100
	local duration = ability:C(data.duration)
	
	
	d.ST.StatBuff:Invoke(d.HUMAN, "Skillz", d.CONTROL.GetStat:Invoke("H4x") * buff, duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "H4x", d.CONTROL.GetStat:Invoke("H4x") * buff, duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", d.CONTROL.GetStat:Invoke("Toughness") * buff, duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "Resistance", d.CONTROL.GetStat:Invoke("Resistance") * buff, duration)
	d.ST.StatBuff:Invoke(d.HUMAN, "BasicCDR", buff/3, duration)
	d.ST.MoveSpeed:Invoke(d.HUMAN, buff, duration)
	delay(duration + 0.01, function()
	d.ST.StatBuff:Invoke(d.HUMAN, "Skillz", d.CONTROL.GetStat:Invoke("H4x") * debuff, duration / 2)
	d.ST.StatBuff:Invoke(d.HUMAN, "H4x", d.CONTROL.GetStat:Invoke("H4x") * debuff, duration / 2)
	d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", d.CONTROL.GetStat:Invoke("Toughness") * debuff, duration / 2)
	d.ST.StatBuff:Invoke(d.HUMAN, "Resistance", d.CONTROL.GetStat:Invoke("Resistance") * debuff, duration  / 2)
	d.ST.StatBuff:Invoke(d.HUMAN, "BasicCDR",debuff, duration  / 2)
	d.ST.MoveSpeed:Invoke(d.HUMAN, debuff, duration / 2)
	end)
	local t = -1
	while t < duration do
		t = t + 1
		delay(t,function()
		tosses[math.random(1,#tosses)]()
		end)
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Winter's Bite",
		Desc = "ThaumicPikachu throws a freezing potion which explodes upon reaching it's maximum range, it creates a freezing field which slows by <slow>% for <duration> seconds dealing <damage> over <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 10,
			H4x = 0.35,
		},
		duration = {
			Base = 2.25
			
		},
		slow = {
			Base = 25,
		
		},
	},
	B = {
		Name = "Frozen Vial",
		Desc = "ThaumicPikachu throws a vial that eats away at the target's and nearby enemies defenses by <shred>%, it also deals  dealing 5% of their maximum health as true damage. This lasts <duration> seconds.",
		MaxLevel = 5,
		shred = {
			Base = 20,
			AbilityLevel = 3,
			H4x = 0.02,
		},
		duration = {
			Base = 4.5,
			
		},
	},
	C = {
		Name = "Warming Potion",
		Desc = "ThaumicPikachu throws a heating potion at the ground releasing it's heaty goodiness, healing allies for <heal> health and buffing defenses by <amount> for <duration> seconds.",
		MaxLevel = 5,
		heal = {
			Base = 9,
			AbilityLevel = 3,
			H4x = 0.25,
		},
		amount = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.2,
		},
		duration = {
			Base = 4.5,
		},
	},
	D = {
		Name = "Mad Chemist",
		Desc = "ThaumicPikachu consumes an unkown vial which grants her <buff>% to all stats, after <duration> seconds, she starts to feel side-effects reducing her stats by <debuff>% for half the duration. After which she starts to toss random potions every 1 second for <duration> seconds from poison(<poisondamage> damage for 2.5 seconds and <slow>% for 1.5 seconds) ,debuff (<debuff>% of resistance and toughness),bonus damage (<damage> damage)",
		MaxLevel = 3,
		buff = {
			Base = 30,
		},
		poisondamage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.1,
		},
		damage = {
			Base = 15,
			AbilityLevel = 5,
			H4x = 0.125,
		},
		slow = {
			Base = 20,
			
		},
		buff = {
			Base = 30,
		},
		debuff = {
			Base = 15,
			AbilityLevel = 1,
		},
		duration = {
			Base = 4.5,
			AbilityLevel = 0.5,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 180 + level * 32.5
	end,
	Skillz = function(level)
		return 5 + level * 0.75
	end,
	Toughness = function(level)
		return 5 + level * 1
	end,
	Resistance = function(level)
		return 5 + level * 0.75
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test