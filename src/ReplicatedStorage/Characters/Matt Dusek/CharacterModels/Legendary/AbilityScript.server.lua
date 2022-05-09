local systemStacks = 0
local systemModification = false
local sparkles = Instance.new("Sparkles")
sparkles.Parent = script.Parent.Parent.Character.Torso
sparkles.Color = Color3.new(128,0,255)
sparkles.Enabled = false
local LOCK = true
local SECOND_LOCK = false

--Matt Stack Function--
function SystemStacks(value)
	if LOCK == false then
	if systemStacks < 8 then
	systemStacks = systemStacks + value
	end
	if systemStacks >= 8 then
		if sparkles.Enabled == false then
		sparkles.Enabled = true
		end
		systemModification = true
	end
	--return print(systemStacks, "stack value")
	end
end

--Unlock Ultimate Passive--
script.UnlockUltimate.Event:connect(function()
	LOCK = false
end)
-----------------------

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/MattBasicAttackFinal-item?id=260025264")
	wait(0.45)
	
	d.PLAY_SOUND(d.HUMAN, 12222152, nil, 0.65)
	local position = d.CHAR.Staff.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Symmetric"
	part.Size = Vector3.new(1, 1, 1)
	part.BrickColor = BrickColor.new("White")
	part.Parent = workspace
	d.DB(part)
	sparkles.Parent = d.CHAR.Staff
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
		SystemStacks(.4)
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjZap:Invoke(p:ClientArgs(), 1, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.1)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/MattIndexFinal-item?id=260064524")
	d.PLAY_SOUND(d.HUMAN, 12222152, nil, 1.35)
	d.SFX.Trail:Invoke(d.CHAR.Staff, Vector3.new(0, 3, 0), 1, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skills.Value.Color)}, 0.5, 0.55)
	 
	if systemModification == true then
		d.CONTROL.AbilityCooldown:Invoke("Q", 2)
		d.CONTROL.AbilityCooldown:Invoke("B", 2)
		d.CONTROL.AbilityCooldown:Invoke("C", 2)
	end
	
	wait(.5)
	
	local position = d.CHAR.Staff.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	if systemModification == true then
		speed = 90
	end
	local width = 4
	local range = 48
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local tagName2 = d.PLAYER.Name.."Derped"
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Symmetric"
	part.Size = Vector3.new(1.5, 1.5, 1.5)
	part.BrickColor = BrickColor.new(script.Parent.Parent.Character.Torso.Skills.Value.Color)
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(p,enemy)
	p.Moving = false
	d.DS.Damage:Invoke(enemy,damage,"Resistance",d.PLAYER)
	if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*0.5, "Resistance", d.PLAYER)
		end 
	if systemModification then
	systemModification = false
	systemStacks = 0
	sparkles.Enabled = false
	local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
	if hrp then
	local expos = hrp.Position
	local radius = 15
	local function onExHit(enemies)
	if enemy == enemies then return end
	d.DS.Damage:Invoke(enemies,damage,"Resistance",d.PLAYER)
	end
	d.DS.AOE:Invoke(expos,radius,team,onExHit)
	d.SFX.Explosion:Invoke(expos,radius,d.CHAR.Torso.Skills.Value.Color)
	end
	end
	SystemStacks(.8)
	end
	local function onStep(projectile)
		topos = projectile.Position
		
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
	repeat
	wait(.1)
	circles = circles + 1
	d.SFX.Circles:Invoke(topos, 1,script.Parent.Parent.Character.Torso.Skills.Value.Color,.2,dir)
	until circles == 6 
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 9 - (9 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/MattArrayFinal-item?id=260089259")
	d.SFX.Trail:Invoke(d.CHAR["Left Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skills.Value.Color)}, 0.5, 0.65)
	d.PLAY_SOUND(d.HUMAN, 12222030, nil, 2)
	if systemModification == true then
		d.CONTROL.AbilityCooldown:Invoke("Q", .8)
		d.CONTROL.AbilityCooldown:Invoke("A", .8)
		d.CONTROL.AbilityCooldown:Invoke("C", .8)
	end
	
	local a = d.HRP.Position
	local range = 32
	local damageamp = 35/100
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 14
	if systemModification == true then
		radius = 16
	end
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		if systemModification == true then
			d.DS.Damage:Invoke(enemy,damageamp *  damage, nil, d.PLAYER)
			systemStacks = 0
			systemModification = false
			sparkles.Enabled = false
		end
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			SystemStacks(0.4)
		else
			SystemStacks(0.2)
		end
	end
	d.SFX.Artillery:Invoke(center, 2, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.8)
	wait(0.8)
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Artillery:Invoke(center, radius, script.Parent.Parent.Character.Torso.Skills.Value.Color)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/MattBinarySearchFinal-item?id=260109125")
	d.PLAY_SOUND(d.HUMAN, 12222152, nil, 0.25)
	
	if systemModification == true then
		d.CONTROL.AbilityCooldown:Invoke("Q", 3)
		d.CONTROL.AbilityCooldown:Invoke("A", 3)
		d.CONTROL.AbilityCooldown:Invoke("B", 3)
	else
		SECOND_LOCK = true
	end
	
	wait(0.45)
	
	local position = d.CHAR.Staff.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 45
	local width = 5
	local range = 64
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)

	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Symmetric"
	part.Size = Vector3.new(4, 4, 4)
	part.BrickColor = BrickColor.new(script.Parent.Parent.Character.Torso.Skills.Value.Color)
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(projectile, enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		d.ST.MoveSpeed:Invoke(enemy, -.2, 2.5)
		if systemModification == true then
			damage = damage * 1.15
			d.CONTROL.AbilityCooldownReduce:Invoke("C", 1)
		end
		projectile.Range = projectile.Range + 16
		projectile.Speed = projectile.Speed + 8
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			SystemStacks(.4)
		else
			SystemStacks(.2)
		end
	end
	local function onStep(projectile)
		
	end
	local function onEnd(projectile)
		part:Destroy()
		if systemModification == true and SECOND_LOCK == false then
			systemModification = false
			systemStacks = 0
			sparkles.Enabled = false
		end
		SECOND_LOCK = false
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 0.1)
end
--script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Index",
		Desc = "Matt Dusek fires a fast-moving projectile which deals <damage> damage to the first enemy it hits. If this ability is used under System Modification, the speed is increased, and this move creates an explosion at the impact zone, spreading the damage to nearby targets.",
		MaxLevel = 6,
		damage = {
			Base = 10,
			AbilityLevel = 10,
			H4x = 0.7,
		},
	},
	B = {
		Name = "Array",
		Desc = "Matt Dusek creates an explosion at a target location which deals <damage> damage to enemies caught within. If this ability is used under System Modification, the area is increased slightly and the damage is changed to true damage.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 10,
			H4x = 0.35,
		},
	},
	C = {
		Name = "Binary Search",
		Desc = "Matt Dusek fires a piercing bolt of code which deals <damage> damage and slowing by 20% for 2.5 seconds to each enemy it passes through. It additionally gains speed and range as it passes through enemies. If this ability is used under System Modification, the damage increases by 15% of the current damage per enemy hit while also reducing its cooldown by 1 per enemy hit.",
		MaxLevel = 6,
		damage = {
			Base = 20,
			AbilityLevel = 10,
			H4x = 0.45,
		},
	},
	D = {
		Name = "System Modification",
		Desc = "Passive ability. Matt Dusek charges his staff per successful attack he lands. After accumulating 4 stacks, Matt's next ability will gain an additional effect. Basic grant .4, Index grants .8, Array grants .4 against champs and .2 against minions, Binary Search grants .4 against champs and .2 against minions. Using superpowered moves puts other moves on cooldown due to their sheer power.",
		MaxLevel = 1,
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 120 + level * 15
	end,
	H4x = function(level)
		return 5 + level * 2.5
	end,
	Toughness = function(level)
		return 5 + 0.25 * level
	end,
	Resistance = function(level)
		return 5 + 0.25 * level
	end,
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test