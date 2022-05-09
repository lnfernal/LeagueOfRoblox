function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.125 - (1.125 * d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/GuestBasicFinal-item?id=260609436")
	d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	
	wait(0.05)
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.35
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Toughness", d.PLAYER)
		end 
	end
	d.DS.Melee:Invoke(hrp, team, onHit,10,6)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 20)
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/GingerbreadmanAbility1-item?id=436920863")
	wait(0.5)
	
	local percent = ability:C(data.percent)/100
	local percentheal = d.HUMAN.MaxHealth * percent
	d.ST.StatBuff:Invoke(d.HUMAN, "HealthRegen", percentheal, 1)
	
	d.SFX.Explosion:Invoke(d.HRP.Position, 5, "White")
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_SOUND(d.HUMAN, 12222200, 1)
	
	local damage = ability:C(data.damage)
	
	
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 24
	local speed = 20 * 2
	local width = 0
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
	end
	local function onStep(p, dt)
		d.HRP.CFrame = CFrame.new(p.Position, p.Position + p.Direction)
	end
	local function onEnd(p)
		local center = p.Position
		local radius = 13
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
			d.DS.KnockAirborne:Invoke(enemy, 16, 1)
		end
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/GingerbreadmanAbility2-item?id=436955081")
		wait(.3)
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Explosion:Invoke(center, radius, "Bright red")
		d.PLAY_SOUND(d.HUMAN, 12222084, nil, 3)
	end
	d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.Shockwave:Invoke(d.FLAT(d.HRP.Position), 4, "Bright red")
	end

script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	
	local debuff = -ability:C(data.debuff)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DogeSoScareFinal-item?id=263118210")
	wait(0.5)
	
	local position = d.CHAR.Head.Position
	local direction = d.HRP.CFrame.lookVector
	local range = ability:C(data.range)
	local width = 6
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		 if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then 
				d.ST.StatBuff:Invoke(enemy, "Skillz", debuff, 5)
				d.ST.StatBuff:Invoke(enemy, "H4x", debuff, 5) 
				 
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	 end 
	if not game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then 
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
	end 	 
	end
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	d.SFX.Line:Invoke(position, direction, range, width, "Really red")
	d.PLAY_SOUND(d.HUMAN, 379698301, nil, 4)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local GumDrop = game.ReplicatedStorage.Items.GumDrop:Clone()
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 70 - (70 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 24, {BrickColor = d.C("Bright green")})
	local a = d.HRP.Position
	local b = d.MOUSE_POS 
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	local range = 50
	local damage = ability:C(data.damage)
	local center = d.DS.Targeted:Invoke(a, range, b)
	
	
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/GingerbreadmanAbility4-item?id=437020076")
	
	local pos = d.EasyTarget(50)
	
	for t = 0.3, 1.185, 0.3 do
		d.SFX.ReverseExplosion:Invoke(center, 20, "Dark green", t)
		d.SFX.ReverseExplosion:Invoke(center, 4, "Bright red", t)
	end
	wait(1.25)
	
	for t = 0.2, 0.8, 0.2 do
		d.SFX.Explosion:Invoke(center, 20, "Dark green", t)
	end
	d.SFX.Artillery:Invoke(center, 4, "Bright red", 0.5)
	d.PLAY_SOUND_POS(pos, 55224766, 1)
	
	
	GumDrop.CFrame = CFrame.new(center)
	GumDrop.Parent = workspace
	d.DB(GumDrop, duration + 0.55)
	
	d.DS.AOE:Invoke(center, 20, d.CHAR.Team.Value, function(target)
		d.DS.Damage:Invoke(target, damage, "Toughness", d.PLAYER)
		
		d.DS.KnockAirborne:Invoke(target, 16, duration)
	end)
end


local abilityData = {
	A = {
		Name = "Milk and Cookies",
		Desc = "Gingerbreadman is reminded of the good memories he had, and regenerates <percent>% of his maximum health for 1 second.",
		MaxLevel = 7,
		percent = {
			Base = 9,
			AbilityLevel = 3.2,
		},
	},
	B = {
		Name = "BaD's Oven!!!",
		Desc = "Gingerbreadman unleashes his inner hate for the place he was born, running forward then dealing <damage> damage and knocking up enemies around him.",
		MaxLevel = 4,
		damage = {
			Base = 15,
			AbilityLevel = 15,
			Health = .03,
		},
	},
	C = {
		Name = "Evil Eyes",
		Desc = "Gingerbreadman's evil eyes shoot a beam dealing <damage> damage and decreases their H4x and Skillz by <debuff>, with a range of <range> studs. This scales with Gingerbreadman's maximum health.",
		MaxLevel = 4,
		damage = {
			Base = 25,
			AbilityLevel = 8.5,
			Skillz = .4,
		},
		range = {
			Base = 20.5,
			AbilityLevel = 0.5,
		},	
		debuff = {
			Health = .04,
			Base = 5,
			AbilityLevel = 5,
		},
	},
	D = {
		Name = "Gum Drop",
		Desc = "Gingerbreadman drops a giant gummy drop to the targeted location dealing <damage> damage and knocking opponents airborne for <duration> seconds.",
		MaxLevel = 3,
		damage = {
			Base = 60,
			AbilityLevel = 12.5,
			Health = .1, 
		},
		duration = {
			Base = .75,
			AbilityLevel = 0.2,
		}
	},
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 135 + level * 25
	end,
	Skillz = function(level)
		return 0
	end,
}
script.CharacterData.OnInvoke = function()
	return characterData
end

--test
