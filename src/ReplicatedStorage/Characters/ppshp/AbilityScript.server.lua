local PickElement = false
local Fire = true --ppshp always starts with fire so its impossible to have no elements
local Wind = false
local Ice = false
local Earth = false
local FireImbued = false
local WindImbued = false
local IceImbued = false
local EarthImbued = false
local ROCK = Instance.new("Part")
ROCK.Anchored = true
ROCK.CanCollide = false
ROCK.FormFactor = "Custom"
ROCK.Size = Vector3.new(1, 1, 1)
local mesh = Instance.new("SpecialMesh", ROCK)
mesh.MeshId = "http://www.roblox.com/asset/?id=1290033"
mesh.TextureId = "http://www.roblox.com/asset/?id=1290030"
mesh.Scale = Vector3.new(0.5, 0.5, 0.5)
local skillColors = {"Bright red","White","Toothpaste","Brown"}
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	local firedamage = d.CONTROL.GetStat:Invoke("H4x") * 0.2
	local earthdamage = d.CONTROL.GetStat:Invoke("H4x") * 0.125
	local winddamage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	local icedamage = d.CONTROL.GetStat:Invoke("H4x") * 0.2
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	if Fire then
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498381858")
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 1.8)
	local function onHit(p, enemy)
		p.Moving = false
		if enemy.Parent.Name == "Turret" then
		d.ST.DOT:Invoke(enemy,firedamage, 1, "Resistance", d.PLAYER, "Fire!")
		else
		d.ST.DOT:Invoke(enemy,(enemy.MaxHealth * .01) + firedamage, 2.5, "Resistance", d.PLAYER, "Fire!")	
		end
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 1, skillColors[1], 0.1)
	elseif Wind then
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498381858")
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 1.8)
	local function onHitExplode(enemy)
	d.DS.Damage:Invoke(enemy, winddamage * 0.3, "Resistance", d.PLAYER)	--Naturally weak anyway		
	end
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Damage:Invoke(enemy, winddamage, "Resistance", d.PLAYER)
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		d.DS.AOE:Invoke(p.Position, 6, team, onHitExplode) --Radius increased so it wont bother.
		d.SFX.Explosion:Invoke(p.Position, 6, skillColors[2])
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 1, skillColors[2], 0.1)
	
	end
if Ice then
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498381858")
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 1.8)
	speed = 64
	local function onHit(p, enemy)
		if enemy.Parent.Name == "Turret" then
		p.Moving = false
		d.DS.Damage:Invoke(enemy, icedamage, "Resistance", d.PLAYER)
		else
		d.DS.Damage:Invoke(enemy, icedamage, "Resistance", d.PLAYER)
		end
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		p:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 1, skillColors[3], 0.1)
elseif Earth then
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.6 - (1.6 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498381858")
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 1.8)
    local part = ROCK:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Damage:Invoke(enemy, earthdamage * 0.95, "Resistance", d.PLAYER)
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		part:Destroy()
	end
	for i = 1, 4, 1 do
		local direction = (d.HRP.CFrame * CFrame.Angles(0, ((i / 4) * (math.pi / 7)), 0)).lookVector
		local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
		d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(math.pi/2, 0, 0))
	end
	
end
	
	end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	if not PickElement then
		d.CONTROL.AbilityCooldown:Invoke("A", 14 - (14 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
			d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498389957")
			d.SFX.ReverseExplosion:Invoke(d.HRP.Position, 6,d.CHAR.Torso.Basic.Value.Color, 0.25) 
			d.SFX.ReverseExplosion:Invoke(d.DS.Targeted:Invoke(d.HRP.Position, 32,d.MOUSE_POS), 12, d.CHAR.Torso.Basic.Value.Color, 0.5)
		wait(.5)
		local a = d.HRP.Position
	local range = 32
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 12
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local colors = skillColors[1]
	local hit = 0
	local bonus
	if FireImbued then
		damage = damage * 1.5
	elseif WindImbued then
	colors = {skillColors[1],skillColors[2]}
	bonus = function(enemy)
	local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then
			local position = hrp.Position
			local direction = (position - d.HRP.Position).unit
			direction = Vector3.new(direction.X, 0, direction.Z).unit
			local speed = 64
			local width = 4
			local range = 16
			local function onHit(projectile, enemy)
			end
			local function onStep(projectile)
				hrp.CFrame = CFrame.new(projectile.Position)
			end
			local function onEnd(projectile)
			end
			d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)				
		end	
	end
	elseif IceImbued then
	colors = {skillColors[1],skillColors[3]}
	bonus = function(enemy)
	d.ST.MoveSpeed:Invoke(enemy, -.2, 2)	
	end
	elseif EarthImbued then
	colors = {skillColors[1],skillColors[4]}	
	bonus = function(enemy)
	d.DS.Damage:Invoke(enemy,damage * 0.25, "Resistance", d.PLAYER)			
	end
	end
	local function onHit(enemy)
		if game.Players:GetPlayerFromCharacter(enemy.Parent) then
			hit = hit + 1
			damage = damage + ((damage * 0.1) * hit)
		end
		d.ST.DOT:Invoke(enemy,(enemy.MaxHealth * .05) + damage, 2.5, "Resistance", d.PLAYER, "Fire!")
		
		if type(bonus) == "function" then
		bonus(enemy)
	end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Artillery:Invoke(center, radius, colors)
		FireImbued = false
		WindImbued = false
		EarthImbued = false
		IceImbued = false	
		
	else
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498394642")
		d.CONTROL.AbilityCooldown:Invoke("D", 2)
		d.CONTROL.AbilityCooldown:Invoke("A", 2)
		d.CONTROL.AbilityCooldown:Invoke("B", 2)
		d.CONTROL.AbilityCooldown:Invoke("C", 2)
		d.CONTROL.AbilityCooldown:Invoke("Q", 2)
		Fire = true
		Wind = false
		Ice = false
		Earth = false
		PickElement = false	
		FireImbued = true
		WindImbued = false
		EarthImbued = false
		IceImbued = false
		local color1 = BrickColor.new(skillColors[1]).Color
local color2 = Color3.new(255/255,102/255,102/255)
local sequence = ColorSequence.new(color1,color2)
d.CHAR["Right Arm"].Flames.Color = sequence
	end
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	if not PickElement  then	
	d.CONTROL.AbilityCooldown:Invoke("B", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.ReverseExplosion:Invoke(d.HRP.Position, 6,d.CHAR.Torso.Basicult.Value.Color, 0.25) 
	wait(.35)
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 60
	local width = 4.5
	local range = 40
	local damage = ability:C(data.damage)
	local team = d.CHAR.Team.Value
	local colors = skillColors[2]
	local bonus
	local bonus2
	if FireImbued then
	colors = {skillColors[1],skillColors[2]}	
	bonus = function(enemy)
		d.ST.DOT:Invoke(enemy,(enemy.MaxHealth * .035) + (damage * 0.35), 2.5, "Resistance", d.PLAYER, "Fire!")
	end
	elseif WindImbued then
		bonus = function(enemy)
		local windbubble = game.ReplicatedStorage.Items.EmmaWater:Clone()
		windbubble.BrickColor = BrickColor.new(skillColors[2])
		local w = Instance.new("Weld")
			w.Parent = windbubble
			w.Part0 = windbubble
			w.Part1 = enemy.Parent.Head
			w.C1 = CFrame.new(0,-2,0)
			windbubble.Parent = enemy.Parent
			game:GetService("Debris"):AddItem(windbubble, 1)
			delay(1.1, function()
				local function onHitt(enemy)
					d.DS.Damage:Invoke(enemy, damage * 0.65, "Resistance", d.PLAYER)
				end
				if enemy.Parent ~= nil then
				local pos = enemy.Parent:FindFirstChild("Torso")
				if pos ~= nil then
				d.DS.AOE2:Invoke(pos.Position, 12, team, onHitt)
				d.SFX.Explosion:Invoke(pos.Position, 12, skillColors[2])
				end
				end
			end)	
		end
	elseif IceImbued then
	colors = {skillColors[2],skillColors[3]}
	bonus = function(enemy)
	d.ST.MoveSpeed:Invoke(enemy, -.2, 2)	
	end
	bonus2 = function(enemy)
	d.ST.MoveSpeed:Invoke(enemy, -.15, 2)	
	end
	elseif EarthImbued then
	colors = {skillColors[2],skillColors[4]}	
	bonus2 = function(enemy)

	end
	end
	local function onHit(p,enemy)
		p.Moving = false
	end
	local function onStep(p,dt)
		
	end
	local function onEnd(p)
	local function OnHit(enemy)
		d.DS.Damage:Invoke(enemy,damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then	
			
		delay(1,function()
			local function Pull(enemies)
					if enemies == enemy then return end
					local main = enemies.Parent:FindFirstChild("HumanoidRootPart")
					if main then					
					local position = hrp.Position
					local vector = (p.Position - position)
					local direction = vector.unit
					local distance = vector.magnitude
					direction = Vector3.new(direction.X, 0, direction.Z).unit
					local speed = 32
					local width = 1
					local range = distance
					local function onHitz(projectile, enemyz)
						if enemyz == enemies then return end
						projectile.Moving = false
					end
					local function onStepz(projectile)
						hrp.CFrame = CFrame.new(projectile.Position)
					end
					local function onEndx(projectile)
						if type(bonus2) == "function" then
							bonus2(enemies)
						end
					end
					local x = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHitz, onStepz, onEndx)
					d.SFX.ProjTrail:Invoke(x:ClientArgs(), .2,colors, 0.25,direction,"Neon",0.039)
					end
			end	
		d.DS.AOE2:Invoke(hrp.Position, 17.5, team, Pull)
		end)
		
		end
	if type(bonus) == "function" then
		bonus(enemy)
	end
	
	end	
	d.DS.AOE:Invoke(p.Position, 14, team, OnHit)
	d.SFX.Explosion:Invoke(p.Position, 14, d.CHAR.Torso.Basicult.Value.Color)
	delay(1,function()
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShedSweepFinal-item?id=259771831")
	end)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 3.5, colors, 0.2)
	
	FireImbued = false
	WindImbued = false
	EarthImbued = false
	IceImbued = false
	else
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498394642")
		d.CONTROL.AbilityCooldown:Invoke("D", 2)
		d.CONTROL.AbilityCooldown:Invoke("A", 2)
		d.CONTROL.AbilityCooldown:Invoke("B", 2)
		d.CONTROL.AbilityCooldown:Invoke("C", 2)
		d.CONTROL.AbilityCooldown:Invoke("Q", 2)
		Fire = false
		Wind = true
		Ice = false
		Earth = false
		PickElement = false	
		FireImbued = false
		WindImbued = true
		EarthImbued = false
		IceImbued = false
		local color1 = BrickColor.new(skillColors[2]).Color
local color2 = Color3.new(255/255,255/255,255/255)
local sequence = ColorSequence.new(color1,color2)
d.CHAR["Right Arm"].Flames.Color = sequence
		end
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	if not PickElement then
		d.CONTROL.AbilityCooldown:Invoke("C", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498381858")
		d.SFX.ReverseExplosion:Invoke(d.HRP.Position, 6,d.CHAR.Torso.Skill3.Value.Color, 0.25) 
		wait(.35)
	local position = d.CHAR["Right Arm"].Position
	local speed = 60
	local width = 4.5
	local range = 40
	local team = d.CHAR.Team.Value
	local slow = -ability:C(data.slow)/100
	local damage = ability:C(data.damage)
	local frostbite = ability:C(data.frostbite)
	local colors = skillColors[3]
	local bonus
	if FireImbued then
	colors = {skillColors[1],skillColors[3]}	
	bonus = function(enemy)
	d.ST.DOT:Invoke(enemy,frostbite * 0.5 + (enemy.MaxHealth * .03) , 2.5, "Resistance", d.PLAYER, "Frostfire!")	
	end
	elseif IceImbued then
	bonus = function(enemy)
	local function OnShock(enemy)
	d.ST.MoveSpeed:Invoke(enemy, -.1, 2)	
	d.DS.Damage:Invoke(enemy, damage * 0.45, "Resistance", d.PLAYER)
		
	end
	local center = enemy.Parent.HumanoidRootPart.Position
	local range = 12
	d.DS.AOE:Invoke(center, range, team, OnShock)
	d.SFX.Shockwave:Invoke(center, range, colors)
	end	
	elseif WindImbued then
	colors = {skillColors[2],skillColors[3]}
	bonus = function(enemy)
	local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then
			local position = hrp.Position
			local direction = (position - d.HRP.Position).unit
			direction = Vector3.new(direction.X, 0, direction.Z).unit
			local speed = 64
			local width = 4
			local range = 12
			local function onHit(projectile, enemy)
			end
			local function onStep(projectile)
				hrp.CFrame = CFrame.new(projectile.Position)
			end
			local function onEnd(projectile)
			end
			d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)				
		end	
	end
	elseif EarthImbued then
	colors = {skillColors[3],skillColors[4]}
	bonus = function(enemy)
		d.DS.Damage:Invoke(enemy, damage * 0.35, "Resistance", d.PLAYER)
		
	end	
	end
	local function onHit(p, enemy)	
		
		d.ST.DOT:Invoke(enemy,frostbite, 2.5, "Resistance", d.PLAYER, "Freezing!")
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		d.ST.MoveSpeed:Invoke(enemy, slow, 2)
		if type(bonus) == "function" then
		bonus(enemy)
		end			
		end

	local function onStep(projectile)
	end
	
	local function onEnd(p)		
	end
	local direction = d.HRP.CFrame.lookVector
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrinkBrick:Invoke(p:ClientArgs(), 2, colors, 0.2)
	FireImbued = false
		WindImbued = false
		EarthImbued = false
		IceImbued = false
	else
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498394642")
		d.CONTROL.AbilityCooldown:Invoke("D", 2)
		d.CONTROL.AbilityCooldown:Invoke("Q", 2)
		d.CONTROL.AbilityCooldown:Invoke("A", 2)
		d.CONTROL.AbilityCooldown:Invoke("B", 2)
		d.CONTROL.AbilityCooldown:Invoke("C", 2)
		Ice = true
		Fire = false
		Wind = false
		Earth = false
		EarthImbued = false
		FireImbued = false
		IceImbued = true
		WindImbued = false
		PickElement = false	
		local color1 = BrickColor.new(skillColors[3]).Color
local color2 = Color3.new(170/255,255/255,255/255)
local sequence = ColorSequence.new(color1,color2)
d.CHAR["Right Arm"].Flames.Color = sequence
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 0.1)
	if not PickElement then
		PickElement = true
	else
		Earth = true
		Fire = false
		Wind = false
		Ice = false
		EarthImbued = true
		FireImbued = false
		IceImbued = false
		WindImbued = false
		PickElement = false
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498394642")
		d.CONTROL.AbilityCooldown:Invoke("D", 2)
		d.CONTROL.AbilityCooldown:Invoke("A", 2)
		d.CONTROL.AbilityCooldown:Invoke("B", 2)
		d.CONTROL.AbilityCooldown:Invoke("C", 2)
		d.CONTROL.AbilityCooldown:Invoke("Q", 2)  
		local color1 = BrickColor.new(skillColors[4]).Color
local color2 = Color3.new(158/255,122/255,64/255)
local sequence = ColorSequence.new(color1,color2)
d.CHAR["Right Arm"].Flames.Color = sequence
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Immolation",
		Desc = "Ppshp charges up and summons a blazing blast at targeted location, dealing <damage> damage as well as taking 5% of their maximum health in the area. The damage of this ability increases by 10% based how many enemy champs have been hit. ",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.3,
		},
		
	},
	B = {
		Name = "Wind Blast",
		Desc = "Ppshp throws a ball of wind that explodes on contact, dealing <damage> damage to enemies caught in it and applies a wind force on them. After 1 second, he will spin his body which will create a backdraft around targets with the wind force, pulling nearby enemies around towards wind force targets.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 7.5,
			H4x = 0.35,
		},
		
	},
	C = {
		Name = "Frostbite",
		Desc = "Ppshp shoots an ice wave that pierces through enemies, dealing <damage> damage and adds a chill effect to them. The chill effect bites through their cold heart, reducing their movement speed by <slow>% while dealing <frostbite> tick damage per second for 2.5 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			H4x = 0.25,
		},
		slow = {
			Base = 32.5,
			
		},
		frostbite = {
			Base = 5,
			AbilityLevel = 5,
			H4x = 0.25,
		}
	},
	D = {
		Name = "Elemental Affinity",
		Desc = "[Innate] The next skill you cast has the attributes of the latest element you have, causing a elemental fusion. Ppshp's basic attack changes element depending on which element ability was currently used, giving utility to each elemental basic attack. Fire deals <fire> damage as well as dealing <percentage> maximum health as damage. Ice pierces through targets and deals <ice> damage. Wind deals <wind> damage and creates a mini wind explosion dealing <explosion> H4x damage. Earth deals <earth> damage and spreads into 4 different rocks",
		MaxLevel = 1,
		fire = {
			H4x = 0.35,
		},
		percentage = {			--Numbers are just for show
			Base = 2.5
		},
		ice = {
			H4x = 0.35,
		},
		wind = {
			H4x = 0.4,
		},
		explosion = {
			H4x = 0.1,
		},
		earth = {
			H4x = 0.125,
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

local backpack = script.Parent
local controlScript = backpack:WaitForChild("ControlScript")

	local data = controlScript.GetData:Invoke()
	local t = data.CHAR.Torso
	
	skillColors = {tostring(t:WaitForChild("Basic").Value),tostring(t:WaitForChild("Basicult").Value),tostring(t:WaitForChild("Skill3").Value),tostring(t:WaitForChild("Skills").Value)}
	