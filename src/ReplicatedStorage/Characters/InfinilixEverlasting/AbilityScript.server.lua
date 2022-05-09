local Colors = {"Really red","Really blue","New Yeller","Teal","Br. yellowish orange", "Institutional white"}
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1 - (1 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	local ChosenColor = Colors[math.random(1, #Colors)]
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/InfiBasic-item?id=444868070")
	--d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	
	wait(.4)
	
	local damage = d.CONTROL.GetStat:Invoke("H4x") * .25
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local width = 3.5
	local range = 32
	local speed = 80
	local team = d.CHAR.Team.Value
	
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		p:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 1, ChosenColor, 0.125)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,ChosenColor, 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 23)
	local ChosenColor = Colors[math.random(1, #Colors)]
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/InfiAbility1-item?id=443699214")
	wait(0.3)
	
	local regen = ability:C(data.regen)
	local allyregen = ability:C(data.regen2)
	local duration = ability:C(data.duration)
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local center = d.HRP.Position
	local radius = 18
	local tagName = d.PLAYER.Name.."Rainbow'd"
		
	d.ST.Tag:Invoke(d.HUMAN, 1, tagName)
	local function onHit(ally)
		if d.ST.GetEffect:Invoke(ally, tagName) then
			d.ST.StatBuff:Invoke(ally, "HealthRegen", regen, duration)
		else
			d.ST.StatBuff:Invoke(ally, "HealthRegen", allyregen, duration)
		end 
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Artillery:Invoke(center, radius, ChosenColor)	
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 20 - (20 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/InfiAbility2-item?id=443700694")
	wait(0.3)
	
	local a = d.HRP.Position
	local range = 28.5
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 19
	local team = d.CHAR.Team.Value
	local team2 = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local duration = ability:C(data.duration)
	local speedbuff = ability:C(data.percent)/100
	local tagName = d.PLAYER.Name.."Rainbow"
	local rainbow = 0
	local debuff = -(d.CONTROL.GetStat:Invoke("H4x") * .25)
	local t = 0
	d.SFX.AreaAOEStart:Invoke(d.FLAT(center), radius, Colors[math.random(1, #Colors)],duration)

	while t < duration do
		local dt = wait(1/4)
		t = t + dt
		local ChosenColor = Colors[math.random(1, #Colors)]
		
		local function onHit(enemy)
			if not game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			elseif game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
				if rainbow >= 8 then
					if d.ST.GetEffect:Invoke(enemy, tagName) then
						d.DS.Damage:Invoke(enemy, 0, 0, d.PLAYER)
						
					elseif not d.ST.GetEffect:Invoke(enemy, tagName) then
						d.ST.Stun:Invoke(enemy, 1)
						d.ST.StatBuff:Invoke(enemy, "Toughness", debuff, 1)
				d.ST.StatBuff:Invoke(enemy, "Resistance", debuff, 1)
					end
				d.ST.Tag:Invoke(enemy, duration, tagName)
				end
				rainbow = rainbow + 1
				d.SFX.PartRandomFollow:Invoke(enemy.Parent.Torso, 1.5, ChosenColor)
			end
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		
		local function onHit(ally)
			d.ST.MoveSpeed:Invoke(ally, speedbuff * .5, 1)
		end
		d.DS.AOE:Invoke(center, radius, team2, onHit)
		
	end
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 13 - (13 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local ChosenColor = Colors[math.random(1, #Colors)]
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/InfiAbility3-item?id=443702862")
	wait(0.4)
	
	local radius = 15
	local center = d.HRP.Position
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	 
	local function onHit(enemy)
		  
		d.ST.DOT:Invoke(enemy, damage, 2, "Resistance", d.PLAYER, "Rainbowsssss")
		if enemy.Parent.Name == "Minion" then
			d.ST.DOT:Invoke(enemy, damage*1,2, "Resistance", d.PLAYER)
		end 
			d.ST.MoveSpeed:Invoke(enemy, -.35, 2.5) 
		 
	
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Explosion:Invoke(center, radius, ChosenColor)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 70 - (70 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local ChosenColor = Colors[math.random(1, #Colors)]
	local ChosenColor2 = Colors[math.random(1, #Colors)]
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/InfiAbility4Test-item?id=443712933")
	wait(.75)
	
	local range = 40
	local width = 8
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	local left = false
	
	if left == false then
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
			d.ST.Stun:Invoke(enemy, duration)
		end
	d.DS.Line:Invoke(d.CHAR["Right Arm"], range, width, team, onHit,false,d.HRP.CFrame.lookVector)
	d.SFX.Line:Invoke(d.CHAR["Right Arm"].Position, d.HRP.CFrame.lookVector, range, width, ChosenColor)
	end
	
	left = true
	
	if left == true then
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			d.ST.Stun:Invoke(enemy, duration)
		end
	d.DS.Line:Invoke(d.CHAR["Left Arm"], range, width, team, onHit,false,d.HRP.CFrame.lookVector)
	d.SFX.Line:Invoke(d.CHAR["Left Arm"].Position, d.HRP.CFrame.lookVector, range, width, ChosenColor2)
	end
	
	left = false
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Rainbow Time",
		Desc = "InfinilixEverlasting uses his rainbow powers to grant himself <regen> health regen and allies <regen2> health regen for <duration> seconds.",
		MaxLevel = 5,
		regen = {
			Base = 5,
			AbilityLevel = 3,
			H4x = .1
		},
		regen2 = {
			Base = 5,
			AbilityLevel = 2.25,
			H4x = .1
		},
		duration = {
			Base = 4, 
			
		},
	},
	B = {
		Name = "Taste the Rainbow",
		Desc = "InfinilixEverlasting creates an area in which allies gain <percent>% bonus speed while inside it. Every enemy inside the area feeds the rainbow, and if too many feed the rainbow, the rainbow stuns all enemies who enter the area briefly and eats their defenses by 25% of your H4x, but only once. This lasts <duration> seconds.",
		MaxLevel = 5,
		percent = {
			Base = 7.5,
			AbilityLevel = 2.5,
		},
		duration = {
			Base = 2.75,
			AbilityLevel = .25,
		},
	},
	C = {
		Name = "Rainbows Never Die",
		Desc = "InfinilixEverlasting revives his used rainbows and explodes them on nearby enemies, dealing <damage> damage over 2 seconds and slows them by 35% for 2.5 seconds. ",
		MaxLevel = 5,
		damage = {
			Base = 25,
			AbilityLevel = 7.5,
			H4x = .35,
		},
	},
	D = {
		Name = "Double Rainbow",
		Desc = "InfinilixEverlasting pushes themself to the limit and fires two big rainbows foward, dealing <damage> damage per beam and stunning for <duration> seconds against hit enemies.",
		MaxLevel = 3,
		damage = {
			Base = 30,
			AbilityLevel = 15,
			H4x = .20,
		},
		duration = {
			Base = 1,
			AbilityLevel = .25,
		},
	},
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