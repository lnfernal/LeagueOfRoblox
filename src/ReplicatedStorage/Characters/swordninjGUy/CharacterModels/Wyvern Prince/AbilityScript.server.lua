local attackNumber = 1
local MESH = Instance.new("SpecialMesh")
MESH.MeshId = "rbxassetid://536464250"
MESH.TextureId = "rbxassetid://536464253"
MESH.VertexColor = Vector3.new(1,0,0)		
local transformed = false
local fireColors = {"Bright red", "Neon orange", "Bright yellow"}
function fireColor()
	return fireColors[math.random(1, #fireColors)]
end
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	local hrp = d.HRP
	local damage
	local team = d.CHAR.Team.Value
	
		if attackNumber == 1 or attackNumber == 2 then
		damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.4
		d.PLAY_SOUND(d.HUMAN, 12222216)
			d.CONTROL.AbilityCooldown:Invoke("Q", 0.65 - (0.325 * d.CONTROL.GetStat:Invoke("BasicCDR")/2))
			d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/swordBasic1-item?id=447329219")
			local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			end
		d.DS.Melee:Invoke(hrp, team, onHit,10,6) 
		elseif attackNumber == 3 and not transformed then
		damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.4
		d.CONTROL.AbilityCooldown:Invoke("Q", 1 - (1 * d.CONTROL.GetStat:Invoke("BasicCDR")/2))
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/swordBasic2-3-item?id=447333663")
			
		local shuriken = Instance.new("Part")
		shuriken.Anchored = true
		shuriken.CanCollide = false
		shuriken.TopSurface = "Smooth"
		shuriken.BottomSurface = "Smooth"
		shuriken.Size = Vector3.new(1, 1, 2)
		shuriken.Parent = game.ReplicatedStorage
		d.DB(shuriken)
		
		local mesh = MESH:clone()
		mesh.Parent = shuriken
		
		local position = d.CHAR["Left Arm"].Position
		local direction = d.HRP.CFrame.lookVector
		local speed = 100
		local width = 3
		local range = 32
		local team = d.CHAR.Team.Value
		local function onHit(projectile, enemy)
			projectile.Moving = false
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			d.PLAY_SOUND(enemy, 12222046, 0.25)
		end
		local function onStep(projectile)
		end
		local function onEnd(projectile)
		end
		local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
		d.SFX.ProjPart:Invoke(p:ClientArgs(), shuriken, CFrame.Angles(0, math.pi, 0))
		elseif attackNumber == 3 and transformed then
		d.CONTROL.AbilityCooldown:Invoke("Q", 1 - (1 * d.CONTROL.GetStat:Invoke("BasicCDR")/2))	
		damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.25
		local position = d.CHAR["Head"].Position
		local direction = d.HRP.CFrame.lookVector
		local speed = 100
		local width = 3
		local range = 32
		local team = d.CHAR.Team.Value
		local function onHit(projectile, enemy)
			projectile.Moving = false
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		end
		local function onStep(projectile)
		end
		local function onEnd(projectile)
		end
		local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
		
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 1, fireColor(), 0.2)
		end
	
	attackNumber = attackNumber + 1
	if attackNumber > 3 then
		attackNumber = 1
	end
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/swordAbility1-item?id=447505907")
	d.PLAY_SOUND(d.HUMAN, 220834000, 1, 1)
	delay(0.75, function()
	d.PLAY_SOUND(d.HUMAN, 220834000, 1, 1)
	end)
	local center = d.HRP.Position
	local range = 13
	local width = 4
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local explodetime = 4
	local radius = 12
	local damage2 = ability:C(data.damage2)
	local num = 2
	
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage / 1.5, "Toughness", d.PLAYER)
			local effect = game.ReplicatedStorage.Items.X:Clone()
			local w = Instance.new("Weld")
			w.Parent = effect
			w.Part0 = effect
			w.Part1 = enemy.Parent.Head
			w.C1 = CFrame.new(0,5,0)
			effect.Parent = enemy.Parent
			game:GetService("Debris"):AddItem(effect, 4)
			delay(explodetime, function()
				local function onHitt(enemy)
					d.DS.Damage:Invoke(enemy, damage2 / 1.5, "Toughness", d.PLAYER)
				end
				local pos = enemy.Torso.Position
				if pos ~= nil then
				d.DS.AOE:Invoke(pos, radius, team, onHitt)
				d.SFX.Explosion:Invoke(pos, radius,d.CHAR.Torso.Skills.Value.Color)
				end
			end)
	end
	repeat
	num = num  - 1
	local direction = d.HRP.CFrame.lookVector
	d.DS.Line:Invoke(d.CHAR["Right Arm"], range, width, team, onHit, false,direction)
	d.SFX.Line:Invoke(d.CHAR["Right Arm"].Position, d.HRP.CFrame.lookVector, range, width,d.CHAR.Torso.Skills.Value.Color)
	wait(0.5)
	until num == 0
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/swordAbility2-item?id=447499877")
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 415700134, 1.5, 0.85)
	
	local range = 18
	local width = 5
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local stun = ability:C(data.duration)
	local function onHit(enemy)
		d.ST.Stun:Invoke(enemy, stun)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	local direction = d.HRP.CFrame.lookVector
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit,direction)
	d.SFX.Line:Invoke(d.HRP.Position, d.HRP.CFrame.lookVector, range, width,d.CHAR.Torso.Skills.Value.Color)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local duration = ability:C(data.duration)
	local percent = ability:C(data.percent)/100
	local damage = ability:C(data.damage)
	local range = 10
	local width = 4
	local team = d.CHAR.Team.Value
	
	d.CONTROL.AbilityCooldownLag:Invoke("Q", duration + 0.05)
	d.DS.Stealth:Invoke(d.CHAR, duration)
	d.ST.MoveSpeed:Invoke(d.HUMAN, percent, duration)
	
	delay(duration, function()
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end
	local direction = d.HRP.CFrame.lookVector
	d.DS.Line:Invoke(d.CHAR["Right Arm"], range, width, team, onHit, false,direction)
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/swordBasic1-item?id=447329219")
	d.SFX.Line:Invoke(d.CHAR["Right Arm"].Position, d.HRP.CFrame.lookVector, range, width,d.CHAR.Torso.Skills.Value.Color)
	end)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 60 - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/swordUltimate-item?id=447371407")
	d.ST.Stun:Invoke(d.HUMAN, 1)
	d.PLAY_SOUND(d.HUMAN, 181004943, 0.9, 1)
	wait(1)
	
	local center = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 56
	local speed = 52
	local width = 4
	local radius = 14
	local team = d.CHAR.Team.Value
	local num = 3
	local pos
	
	
	
	
	local function onHit(projectile, enemy)
		projectile.Moving = true
	end
	
	local function onHitt(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	end
	local function onStep(p, dt)
		pos = p.Position
	end
	local function onEnd(p)
	end
	local p = d.DS.AddProjectile:Invoke(center, direction, speed, width, range, team, onHit, onStep, onEnd)
	while num > 0 do
		wait(.25)
		num = num - 1
		d.SFX.Artillery:Invoke(pos, radius,d.CHAR.Torso.Skills.Value.Color)
		d.DS.AOE:Invoke(pos, radius, team, onHitt)
	end
	if game.ServerStorage.ExtraCharacters["Dragon Form"].RequiredLevel.Value == 2 then
		--
		local oldshirt = d.CHAR.Shirt.ShirtTemplate
		local oldpants = d.CHAR.Pants.PantsTemplate
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DekenusPassiveFinal-item?id=263174279")
		for _,parts in pairs(d.CHAR:GetChildren()) do
			if parts.Name:match("Dragon") == "Dragon" then
				parts.Transparency = 0
			elseif parts.Name:match("Human")  == "Human" and parts.Name ~= "HumanoidRootPart" and parts.Name ~= "Humanoid"  then
				parts.Transparency = 1
			end
		end
	d.CHAR.Head.BrickColor = BrickColor.new("Really Black")
	transformed = true
	d.CHAR.Shirt.ShirtTemplate = "rbxassetid://203629968"
	d.CHAR.Pants.PantsTemplate = "rbxassetid://203629974"
	d.SFX.Explosion:Invoke(d.CHAR.Torso.Position, 10,d.CHAR.Torso.Skills.Value.Color)
	d.SFX.Artillery:Invoke(d.CHAR.Torso.Position, 8,d.CHAR.Torso.Skills.Value.Color)
	delay(30,function()
	game.ReplicatedStorage.Remotes.StopAnimation:FireClient(d.PLAYER,d.HUMAN, "http://www.roblox.com/DekenusPassiveFinal-item?id=263174279")
	transformed = false
	d.SFX.Explosion:Invoke(d.CHAR.Torso.Position, 10,d.CHAR.Torso.Skills.Value.Color)
	d.SFX.Artillery:Invoke(d.CHAR.Torso.Position, 8,d.CHAR.Torso.Skills.Value.Color)
	for _,parts in pairs(d.CHAR:GetChildren()) do
			if parts.Name:match("Dragon") == "Dragon" then
				parts.Transparency = 1
			elseif parts.Name:match("Human")  == "Human" and parts.Name ~= "HumanoidRootPart" and parts.Name ~= "Humanoid" then
				parts.Transparency = 0
			end
		end
	d.CHAR.Head.BrickColor = BrickColor.new("Pastel brown")	
	d.CHAR.Shirt.ShirtTemplate = oldshirt
	d.CHAR.Pants.PantsTemplate = oldpants
	end)
	end
end
script.Ability4.OnInvoke = ability4


local abilityData = {
	A = {
		Name = "Xross",
		Desc = "swordninjGUy unleashes two violent slashes in a line, dealing <damage> to enemies hit and marking them with an X. After 4 seconds, all marked targets explode, dealing <damage2> damage to all nearby targets.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			Skillz = 0.15,
		},
		damage2 = {
			AbilityLevel = 5,
			Skillz = 0.15,
		},
	},
	B = {
		Name = "Suppress",
		Desc = "swordninjGUy suppresses opponents in a line, dealing <damage> damage and briefly stunning for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 7.5,
			Skillz = 0.3,
		},
		duration = {
			Base = 1.25,
		
		},
	},
	C = {
		Name = "Shadow Meld",
		Desc = "swordninjGUy bends shadows around him, cloaking him for <duration> seconds. During this time, he moves <percent>% faster. At the end of the cloak, he strikes out at opponents in front of him, dealing <damage> damage.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			Skillz = 0.35,
		},
		duration = {
			Base = 2,
			AbilityLevel = 0.15,
		},
		percent = {
			Base = 20,
			AbilityLevel = 3,
		},
	},
	D = {
		Name = "Oath",
		Desc = tostring("\"").."Oh dear sister, I will slay he who has wronged us."..tostring("\"").." The wyvern prince channels his rage into energy in one spot, and after 1 second, he unleashes the energy in front of him, firing 3 pillars of rage foward that deal <damage> per pillar.",
		MaxLevel = 3,
		damage = {
			Base = 6,
			AbilityLevel = 8,
			Skillz = 0.35,
		},
		
	}--Well tostring isnt really needed i think
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 160 + level * 10
	end,
	Skillz = function(level)
		return 6 + level * 1.5
	end,
	Toughness = function(level)
		return 5 + 0.75 * level
	end,
	Resistance = function(level)
		return 5 + 0.5 * level
	end,
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test