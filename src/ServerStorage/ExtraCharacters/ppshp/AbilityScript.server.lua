local PickElement = false
local Fire = true --ppshp always starts with fire so its impossible to have no elements
local Wind = false
local Ice = false
local Earth = false
local ROCK = Instance.new("Part")
ROCK.Anchored = true
ROCK.CanCollide = false
ROCK.FormFactor = "Custom"
ROCK.Size = Vector3.new(1, 1, 1)
	local mesh = Instance.new("SpecialMesh", ROCK)
mesh.MeshId = "http://www.roblox.com/asset/?id=1290033"
mesh.TextureId = "http://www.roblox.com/asset/?id=1290030"
mesh.Scale = Vector3.new(0.5, 0.5, 0.5)

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	local firedamage = d.CONTROL.GetStat:Invoke("H4x") * 0.35
	local earthdamage = d.CONTROL.GetStat:Invoke("H4x") * 0.15
	local winddamage = d.CONTROL.GetStat:Invoke("H4x") * 0.3
	local icedamage = d.CONTROL.GetStat:Invoke("H4x") * 0.4
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 64
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	if Fire == true then
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
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 1, "Really red", 0.1)
	elseif Wind == true then
	d.CONTROL.AbilityCooldown:Invoke("Q", 0.8 - (0.8 * d.CONTROL.GetStat:Invoke("BasicCDR")))
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
		d.SFX.Explosion:Invoke(p.Position, 6, "White")
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 1, "White", 0.1)
	
	end
if Ice == true then
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.3 - (1.3 * d.CONTROL.GetStat:Invoke("BasicCDR")))
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
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 1, "Toothpaste", 0.1)
elseif Earth == true then
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
	if PickElement == false then
		d.CONTROL.AbilityCooldown:Invoke("A", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
			d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498381858")
		local firedamage = ability:C(data.firedamage)
		local icedamage = ability:C(data.icedamage)
		local earthdamage = ability:C(data.earthdamage)
		local winddamage = ability:C(data.winddamage)
		local color = "Bright red"
		local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 52.5
	local width = 4
	local range = 40
	local team = d.CHAR.Team.Value
	if Ice == true then
		color = "Toothpaste"	
		end
		if Earth == true then
		color = "Brown"
		end
		if Wind == true then
		color = "White"	
		end
	local function onHit(p)
		p.Moving = false
	end
	local function onHitEarth(enemy)	
	if Earth == true then
		d.DS.Damage:Invoke(enemy, earthdamage * 0.3, "Resistance", d.PLAYER)	
		end	
	end
	local function onHitDamage(enemy)	
		if Fire == true then
		d.ST.DOT:Invoke(enemy,(enemy.MaxHealth * .035) + firedamage, 2.5, "Resistance", d.PLAYER, "Fire!")
		end
		if Ice == true then
		d.DS.Damage:Invoke(enemy, icedamage, "Resistance", d.PLAYER)
		d.ST.MoveSpeed:Invoke(enemy, -.3, 2)			
		end
		if Earth == true then
		d.DS.Damage:Invoke(enemy, earthdamage, "Resistance", d.PLAYER)	
		end
		if Wind == true then
			d.DS.Damage:Invoke(enemy, winddamage, "Resistance", d.PLAYER)	
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
	end
	local function onStep(projectile)
	end
	
	local function onEnd(p)	
		if Earth == true then
	d.DS.AOE:Invoke(p.Position, 6, team, onHitEarth)
	d.SFX.Explosion:Invoke(p.Position, 6, color)		
	end
	local center = p.Position
	local radius = 10
	d.DS.AOE:Invoke(center, radius, team, onHitDamage)
	d.SFX.Explosion:Invoke(center, radius, color)		
	
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 2, color, 0.2)
	else
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498394642")
		d.CONTROL.AbilityCooldown:Invoke("D", 5)
		d.CONTROL.AbilityCooldown:Invoke("A", 5)
		d.CONTROL.AbilityCooldown:Invoke("B", 5)
		d.CONTROL.AbilityCooldown:Invoke("C", 5)
		d.CONTROL.AbilityCooldown:Invoke("Q", 5)
		Fire = true
		Wind = false
		Ice = false
		Earth = false
		PickElement = false	
		local color1 = Color3.new(224/255,255/255,156/255)
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
	if PickElement == false then	
		d.CONTROL.AbilityCooldown:Invoke("B", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498389957")
		wait(.2)
		local firedamage = ability:C(data.firedamage)
		local icedamage = ability:C(data.icedamage)
		local earthdamage = ability:C(data.earthdamage)
		local winddamage = ability:C(data.winddamage)
		local color = "Bright red"
		local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local team = d.CHAR.Team.Value
	local center = d.HRP.Position
	local range = 16
	if Ice == true then
		color = "Toothpaste"	
		end
		if Earth == true then
		color = "Brown"
		end
		if Wind == true then
		color = "White"	
		end
	local function onHit(enemy)	
		if Fire == true then
		d.ST.DOT:Invoke(enemy,(enemy.MaxHealth * .075) + firedamage, 2.5, "Resistance", d.PLAYER, "Fire!")
		end
		if Ice == true then
		d.DS.Damage:Invoke(enemy, icedamage, "Resistance", d.PLAYER)
		d.ST.MoveSpeed:Invoke(enemy, -.2, 2)			
		end
		if Earth == true then
		d.DS.Damage:Invoke(enemy, earthdamage, "Resistance", d.PLAYER)	
		
		end
		if Wind == true then
			d.DS.Damage:Invoke(enemy, winddamage, "Resistance", d.PLAYER)	
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
		end	
	
	

	d.DS.AOE:Invoke(center, range, team, onHit)
	d.SFX.Artillery:Invoke(center, range, color)
	else
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498394642")
		d.CONTROL.AbilityCooldown:Invoke("D", 5)
		d.CONTROL.AbilityCooldown:Invoke("A", 5)
		d.CONTROL.AbilityCooldown:Invoke("B", 5)
		d.CONTROL.AbilityCooldown:Invoke("C", 5)
		d.CONTROL.AbilityCooldown:Invoke("Q", 5)
		Wind = true
		Fire = false
		Ice = false
		Earth = false
		PickElement = false	
		local color1 = Color3.new(234/255,255/255,230/255)
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
	if PickElement == false then
		d.CONTROL.AbilityCooldown:Invoke("C", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
			d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498381858")
			local firedamage = ability:C(data.firedamage)
		local icedamage = ability:C(data.icedamage)
		local earthdamage = ability:C(data.earthdamage)
		local winddamage = ability:C(data.winddamage)
		local color = "Bright red"
		local position = d.CHAR["Right Arm"].Position
	local speed = 48
	local width = 6
	local range = 48
	local team = d.CHAR.Team.Value
	if Ice == true then
		color = "Toothpaste"	
		end
		if Earth == true then
		color = "Brown"
		end
		if Wind == true then
		color = "White"	
		end
	

	local function onHit(p, enemy)	
		if Fire == true then
		d.ST.DOT:Invoke(enemy,(enemy.MaxHealth * .035) + firedamage, 2.5, "Resistance", d.PLAYER, "Fire!")
		end
		if Ice == true then
		d.DS.Damage:Invoke(enemy, icedamage, "Resistance", d.PLAYER)
		d.ST.MoveSpeed:Invoke(enemy, -.2, 2)			
		end
		if Earth == true then
		d.DS.Damage:Invoke(enemy, earthdamage, "Resistance", d.PLAYER)	
		d.DS.KnockAirborne:Invoke(enemy, 16, 1)
		end
		if Wind == true then
			d.DS.Damage:Invoke(enemy, winddamage, "Resistance", d.PLAYER)	
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
		end

	local function onStep(projectile)
	end
	
	local function onEnd(p)		
	end
	local direction = d.HRP.CFrame.lookVector
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
		d.SFX.ProjShrinkBrick:Invoke(p:ClientArgs(), 2, color, 0.2)
	else
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498394642")
		d.CONTROL.AbilityCooldown:Invoke("D", 5)
		d.CONTROL.AbilityCooldown:Invoke("Q", 5)
		d.CONTROL.AbilityCooldown:Invoke("A", 5)
		d.CONTROL.AbilityCooldown:Invoke("B", 5)
		d.CONTROL.AbilityCooldown:Invoke("C", 5)
		Ice = true
		Fire = false
		Wind = false
		Earth = false
		PickElement = false	
		local color1 = Color3.new(193/255,188/255,255/255)
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
	if PickElement == false then
		PickElement = true
	else
		Earth = true
		Fire = false
		Wind = false
		Ice = false
		PickElement = false
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=498394642")
		d.CONTROL.AbilityCooldown:Invoke("D", 5)
		d.CONTROL.AbilityCooldown:Invoke("A", 5)
		d.CONTROL.AbilityCooldown:Invoke("B", 5)
		d.CONTROL.AbilityCooldown:Invoke("C", 5)
		d.CONTROL.AbilityCooldown:Invoke("Q", 5)
		local color1 = Color3.new(255/255,248/255,149/255)
local color2 = Color3.new(158/255,122/255,64/255)
local sequence = ColorSequence.new(color1,color2)
d.CHAR["Right Arm"].Flames.Color = sequence
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Elemental Blast",
		Desc = "Ppshp summons a elemental blast that damages each enemy caught in the blast and applies the corresponding effects on such. Fire applies <firedamage> + 3%Max Hp as DPS, Ice applies <icedamage> damage and a 30% slow for 2 seconds, Wind applies <winddamage> damage and pushes the enemy back, and Earth applies <earthdamage> damage + a smaller aoe that deals 30% of its original value.",
		MaxLevel = 5,
		firedamage = {
			Base = 10,
			AbilityLevel = 3.5,
			H4x = 0.3,
		},
		earthdamage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.35,
		},
		icedamage = {
			Base = 15,
			AbilityLevel = 3,
			H4x = 0.3,
		},
		winddamage = {
			Base = 10,
			AbilityLevel = 7.5,
			H4x = 0.3,
		},
	},
	B = {
		Name = "Elemental Aura",
		Desc = "ppshp surrounds himself with a element, dealing elemental damage to any enemy near him.Fire applies <firedamage> + 7.5%Max Hp as DPS, Ice applies <icedamage> damage and a 20% slow for 2 seconds, Wind applies <winddamage> damage and pushes the enemy back, and Earth applies <earthdamage> damage and stuns the enemy for 1 second.",
		MaxLevel = 5,
		firedamage = {
			Base = 5,
			AbilityLevel = 3,
			H4x = 0.3,
		},
		earthdamage = {
			
			AbilityLevel = 10,
			H4x = 0.4,
		},
		icedamage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.3,
		},
		winddamage = {
			Base = 10,
			AbilityLevel = 4,
			H4x = 0.3,
		},
	},
	C = {
		Name = "Elemental Wave",
		Desc = "ppshp fires a elemental shockwave, dealing the corresponding elemental damage to such.Fire applies <firedamage> + 2%Max Hp as DPS, Ice applies <icedamage> damage and a 20% slow for 2 seconds, Wind applies <winddamage> damage and pushes the enemy back, and Earth applies <earthdamage> damage and stuns the enemy for 1 second.",
		MaxLevel = 5,
		firedamage = {
			Base = 5,
			AbilityLevel = 3,
			H4x = 0.3,
		},
		earthdamage = {
			Base = 10,
			AbilityLevel = 4.5,
			H4x = 0.35,
		},
		icedamage = {
			Base = 12.5,
			AbilityLevel = 5,
			H4x = 0.3,
		},
		winddamage = {
			Base = 15,
			AbilityLevel = 3,
			H4x = 0.3,
		},
	},
	D = {
		Name = "Elemental Affinity",
		Desc = "ppshp commands the elements in his hand, ppshp switches his elements affecting his 1st,2nd,and 3rd skill with a corresponding element. To pick a element simply toggle the ultimate and click a different number button ranging from 1-4 in order fire,wind,ice,earth.",
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