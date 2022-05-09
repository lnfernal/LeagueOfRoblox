
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.125 -(1.125 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=501496166")
	d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	
	wait(.05)
	
	local damage = d.CONTROL.GetStat:Invoke("H4x") * .25
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
	end
	d.DS.Melee:Invoke(hrp, team, onHit,10,6)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local damage = ability:C(data.damage)
	wait(0.15)
	local virusdamage = ability:C(data.virusdamage)
	local distance = ability:C(data.distance)
	local team = d.CHAR.Team.Value
	local slow = -ability:C(data.slow)/100
	local tagName = d.PLAYER.Name.."Virus!"
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local cdr = 2	
	
	local function onHit(p,enemy)
	d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
	if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then 
		if d.ST.GetEffect:Invoke(enemy, tagName) then
		d.DS.Damage:Invoke(enemy, virusdamage, "Resistance", d.PLAYER)
		d.ST.MoveSpeed:Invoke(enemy, slow, 2)
		d.CONTROL.AbilityCooldownReduce:Invoke("A", 2 - (3.33 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
		d.EasyStack(enemy, tagName, 12)
		else
		d.EasyStack(enemy, tagName, 12)
		
		end
		 end	
	
	end
	local function onStep(p, dt)
		d.HRP.CFrame = CFrame.new(p.Position, p.Position + p.Direction)
	end
	local function onEnd(p)
		p:Destroy()
	end
	 d.DS.AddProjectile:Invoke(position, direction, 350, 6, distance, team, onHit, onStep, onEnd)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 18 - (18 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local damage = ability:C(data.damage)
	wait(0.15)
	local virusdamage = ability:C(data.virusdamage)
	local distance = ability:C(data.distance)
	local team = d.CHAR.Team.Value
	local speed = ability:C(data.speed)/100
	local tagName = d.PLAYER.Name.."Virus!"
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local cdr = 2
	local hit = false
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=501502690")	
	local function onHit(p,enemy)
	hit = true	
	p.Moving = false
	local hrp = d.GET_HRP(enemy)
	d.ST.DOT:Invoke(enemy,(enemy.MaxHealth * .05) + damage, 2.5, "Resistance", d.PLAYER, "Virus Injected!")	
	if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then 
	if d.ST.GetEffect:Invoke(enemy, tagName) then
	d.EasyStack(enemy, tagName, 12)
		else
	d.EasyStack(enemy, tagName, 12)
	end	
	end
		if hrp then
			delay(2, function()
				local position = hrp.Position
				local radius = 14
				local function onHit(enemy)
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then 
		if d.ST.GetEffect:Invoke(enemy, tagName) then
		d.DS.Damage:Invoke(enemy, virusdamage, "Resistance", d.PLAYER)
		d.ST.Stun:Invoke(enemy, 1.5)
		d.CONTROL.AbilityCooldownReduce:Invoke("B", 2 - (3.33 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
		d.EasyStack(enemy, tagName, 12)
		else
		d.EasyStack(enemy, tagName, 12)
		end
				end
				end
				d.DS.AOE:Invoke(position, radius, team, onHit)
				d.SFX.Explosion:Invoke(position, radius, tostring(BrickColor.random()))
			end)
		end
	end
		local function onStep(p, dt)
		d.HRP.CFrame = CFrame.new(p.Position, p.Position + p.Direction)
		end
	local function onEnd(p)
		if hit == false then
		d.ST.MoveSpeed:Invoke(d.HUMAN, speed, 2.5)
		end
	end
	d.DS.AddProjectile:Invoke(position, direction, 64, 6, distance, team, onHit, onStep, onEnd)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local damage = ability:C(data.damage)
	local virusdamage = ability:C(data.virusdamage)
	local team = d.CHAR.Team.Value
	local tagName = d.PLAYER.Name.."Virus!"
	local center = d.HRP.Position
	d.SFX.ReverseExplosion:Invoke(center, 6,colors, 0.35)
    wait(0.45)
	local position = d.HRP.Position
	local speed = 60
	local width = 4
	local range = 48
	local cdr = 2
	local function fireProjectile(theta)
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ResyncablePentatoneFinal-item?id=263109476")
	local function onHit(p,enemy)
	p.Moving = false
	if enemy.Parent.Name == "Turret" then
		else
	d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
	if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
	if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then 
		if d.ST.GetEffect:Invoke(enemy, tagName) then
		d.DS.Damage:Invoke(enemy, virusdamage, "Resistance", d.PLAYER)
		
		d.CONTROL.AbilityCooldownReduce:Invoke("C", 0.5 - (1.88 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
		d.EasyStack(enemy, tagName, 12)
		end
		 end	
	end
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		p:Destroy()
	end
	local colors = {tostring(BrickColor.random()),tostring(BrickColor.random()),tostring(BrickColor.random()),tostring(BrickColor.random())}
	local direction = (d.HRP.CFrame * CFrame.Angles(0, theta, 0)).lookVector
local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, false)
d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,colors, 0.25,direction,"Neon",0.039)
	d.SFX.ProjZap:Invoke(p:ClientArgs(), 1, colors, 0.1)
end
	local dTheta = math.pi / 18
	local theta = dTheta * -2
	while theta <= dTheta * 2 do
		fireProjectile(theta)
		theta = theta + dTheta
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 60 - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local damage = ability:C(data.damage)
	local bonusdamage = ability:C(data.virusdamage)
	local slow = -ability:C(data.slow)/100
	local tagName = d.PLAYER.Name.."Virus!"
	local a = d.HRP.Position
	local range = 128
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 24
	local team = d.CHAR.Team.Value
	local colors = {tostring(BrickColor.random()),tostring(BrickColor.random()),tostring(BrickColor.random()),tostring(BrickColor.random())}
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/StickMeteorStrikeFinal-item?id=261368710")
	d.SFX.Trail:Invoke(d.CHAR["Left Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C(tostring(BrickColor.random()))}, 0.5, 0.4)
		d.SFX.Trail:Invoke(d.CHAR["Right Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C(tostring(BrickColor.random()))}, 0.5, 0.4)
	
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		local hrp = d.GET_HRP(enemy)
		if hrp then
			if d.ST.GetEffect:Invoke(enemy, tagName) then
				d.DS.Damage:Invoke(enemy, bonusdamage, "Resistance", d.PLAYER)
				d.ST.MoveSpeed:Invoke(enemy, slow, 2)
		d.CONTROL.AbilityCooldownReduce:Invoke("D", 5 - (8.33 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
		d.EasyStack(enemy, tagName, 12)
			end
		end
	end
	d.SFX.Artillery:Invoke(center, 6,colors, 1.5)
	wait(1.5)
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Artillery:Invoke(center, radius, colors)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Scr1pt 3rr0r",
		Desc = "MoreGalaxy character script has a major error causing him to teleport <distance> studs in front of him, dealing <damage> damage to anyone in his path. If he hits someone he injects a virus into him. If the target already has the virus he takes <virusdamage> damage and slowed for <slow>% for 2s and reducing the cooldown of this move by 2.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 10,
			H4x = .2,
		},
		slow = {
			Base = 20,
			AbilityLevel = 2,
		},
		distance = {
			Base = 20,
			AbilityLevel = 2,
		},
		virusdamage = {
			Base = 5,
			H4x = .05,
		},
	},
		B = {
		Name = "1nj3ct0r",
		Desc = "MoreGalaxy dashes, if he hits someone he injects a virus into him dealing <damage> damage + 5% of enemy max health over 2.5 seconds, but if he doesn't hit someone he gains <speed>% speed for 2.5s.After which the virus explodes infecting nearby enemies with it. If the target already has a virus he is stunned for 1.5 seconds ,takes <virusdamage> damage and  cooldown for this move is reduced by 2 for each enemy hit",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 7.5,
			H4x = .275,
		},
		stun = {
			Base = 0.15,
			AbilityLevel = 0.15,
		},
		distance = {
			Base = 25,
			
		},
		virusdamage = {
			Base = 5,
			H4x = .07,
		},
		speed = {
			Base = 20,
			AbilityLevel = 2,
		},
	},
	C = {
		Name = ".d11",
		Desc = "MoreGalaxy shoots 5 .d11 script in front of him, dealing <damage> damage. If the target already has a virus, the target takes <virusdamage> damage and reduces the cooldown of this ability by 0.5s for each enemy hit.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = .1,
		
		},
		virusdamage = {
			Base = 5,
			H4x = .02,
		},
	},
	D = {
		Name = "H4ck3rs p0w3r",
		Desc = "MoreGalaxy calls down a strike dealing <damage> damage to any enemy hit in the radius, if the enemy has a virus, they take bonus <virusdamage> damage, slowed by <slow>% for 2s, and the cooldown of this move is reduced by 5",
		MaxLevel = 3,
		damage = {
			Base = 20,
			AbilityLevel = 5,
			H4x = .4,
		},
		virusdamage = {
			Base = 10,
			AbilityLevel = 5,
			H4x = .1,
		},
		slow = {
			Base = 10,
			AbilityLevel = 5,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 150 + level * 15
	end,
	Skillz = function(level)
		return 6 + level * 2
	end,
	H4x = function(level)
		return 6 + level * 2
	end,
	Toughness = function(level)
		return 9.5 + level * 1.5
	end,
	Resistance = function(level)
		return 9.5 + level * 1.5
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test