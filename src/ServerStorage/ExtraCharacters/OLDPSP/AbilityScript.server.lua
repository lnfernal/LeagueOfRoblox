function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.1 - (1.1 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/PspBasicAttackFinal-item?id=263102264")
	d.PLAY_SOUND(d.HUMAN, 12222216)
	wait(0.45)
	local hrp = d.HRP
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .4
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	end
	d.DS.Melee:Invoke(hrp, team, onHit,8.5,7)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local enemiesHit = {}
	local function throwAxe(axe)
		d.PLAY_SOUND(d.HUMAN, 12222200, 1)
		
		local part = axe:Clone()
		d.CW(part)
		part.Parent = game.ReplicatedStorage
		d.DB(part)
		local position = part.Position
		local direction = d.HRP.CFrame.lookVector
		local range = 48
		local speed = 64
		local width = 3
		local team = d.CHAR.Team.Value
		local function onHit(p, enemy)
			if not d.IN(enemy, enemiesHit) then
				p.Moving = false
			end
			
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			table.insert(enemiesHit, enemy)
		end
		local function onStep()
		end
		local function onEnd(p)
			part:Destroy()
		end
		local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
		d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(-math.pi / 2, 0, 0),
			{Spin = CFrame.Angles(-1/6, 0, 0)}
		)
	end
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/PspAxeThrowFinal-item?id=263102461")
	wait(0.3)
	throwAxe(d.CHAR.AxeRight)
	wait(0.2)
	throwAxe(d.CHAR.AxeLeft)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 20 - (20 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local speed = ability:C(data.speed)/100
	local duration = ability:C(data.duration)
	local percent = ability:C(data.percent)/100
	local hit = false
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/PspAxeSpinFinal-item?id=263102786")
	
	local center = d.HRP.Position
	local radius = 14
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		hit = true
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		d.ST.DOT:Invoke(enemy, enemy.MaxHealth * percent, 5, "", d.PLAYER, "")	
			d.ST.MoveSpeed:Invoke(enemy, -.30, duration)
		elseif d.IS_MINION(enemy.Parent) then
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		d.ST.DOT:Invoke(enemy, enemy.MaxHealth * (percent * .25), 5, "", d.PLAYER, "")
	end	
			
		local hrp = d.GET_HRP(enemy)
		if hrp then
			d.SFX.Artillery:Invoke(hrp.Position, 3, d.CHAR.Torso.Skills.Value.Color)
		end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Shockwave:Invoke(center, radius, d.CHAR.Torso.Skills.Value.Color)
	if not hit then
		d.SFX.Artillery:Invoke(center, 4, d.CHAR.Torso.Skills.Value.Color)
		d.ST.MoveSpeed:Invoke(d.HUMAN, speed, duration)
		d.PLAY_SOUND(d.HUMAN, 84937942)
		d.PLAY_SOUND(d.HUMAN, 84937942)
	else
		d.PLAY_SOUND(d.HUMAN, 12222225)
	end
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 23)
	
	local regen = ability:C(data.regen)
	local duration = ability:C(data.duration)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/PspRegroupFinal-item?id=263103335")
	wait(0.3)
	d.PLAY_SOUND(d.HUMAN, 12222253)
	
	local center = d.HRP.Position
	local radius = 18
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local function onHit(ally)
		d.ST.StatBuff:Invoke(ally, "HealthRegen", regen, duration)
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Explosion:Invoke(d.FOOT(), radius / 2, d.CHAR.Torso.Skills.Value.Color)
	d.SFX.Shockwave:Invoke(d.FOOT(), radius, d.CHAR.Torso.Skills.Value.Color)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 60 - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local regen = ability:C(data.regen)
	local duration = ability:C(data.duration)
	local percent = ability:C(data.percent)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/PspEpicComebackFinal-item?id=263103564")
	wait(0.65)
	
	local missingHealthPercent = (d.HUMAN.MaxHealth - d.HUMAN.Health) / d.HUMAN.MaxHealth * 100
	local percentBoost = percent * missingHealthPercent
	percentBoost = percentBoost / 100 + 1
	d.ST.StatBuff:Invoke(d.HUMAN, "HealthRegen", regen * percentBoost, duration)
	
	local step = math.pi / 8
	for theta = step, math.pi * 2, step do
		d.SFX.Line:Invoke(d.HRP.Position, CFrame.Angles(0, theta, 0).lookVector, 8, 2, d.CHAR.Torso.Skills.Value.Color, 0.4)
		d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 3, 32, {BrickColor = d.C(d.CHAR.Torso.Skills.Value.Color), Transparency = 0.25}, duration)
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Axe Throw",
		Desc = "pspjohn1 throws his axes in sequence, each dealing <damage> damage to the first target hit. If a target has already been hit by an axe, the axe will not stop.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			Skillz = 0.3,
		}
	},
	B = {
		Name = "Axe Spin",
		Desc = "pspjohn1 spins his axes in a circle, dealing <damage> damage and slows 30% to nearby enemies immediately, and <percent>% of their max health over 5 seconds. However, if this ability hits no targets, it grants pspjohn1 a <speed>% speed boost for <duration> seconds. The bleed is only 25% as effective when used on non-players.",
		MaxLevel = 5,
		damage = {
			Base = 7.5,
			AbilityLevel = 5,
			Skillz = 0.2,
		},
		speed = {
			Base = 27.5,
			AbilityLevel = 2.5,
		},
		duration = {
			Base = 2.5,
		},
		percent = {
			Base = 7.5,
			AbilityLevel = 2.5,
			
		}
	},
	C = {
		Name = "Regroup",
		Desc = "pspjohn1 calls on his nearby allies to regroup and repel the assault, increasing his and their health regeneration by <regen> for <duration> seconds.",
		MaxLevel = 5,
		regen = {
			Base = 6.25,
			AbilityLevel = 2.5,
			Health = .0315,
		},
		duration = {
			Base = 4,
			
		}
	},
	D = {
		Name = "Epic Comeback",
		Desc = "pspjohn1 calls upon his last piece of strength in dire need, increasing his health regen by <regen> for <duration> seconds. This amount is increased by <percent>% for each 1% of health he is missing.",
		MaxLevel = 3,
		regen = {
			Base = 10,
			AbilityLevel = 5,
			Health = .05,
		},
		duration = {
			Base = 2.5,
			AbilityLevel = .5
		},
		percent = {
			AbilityLevel = .25,
		}
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


--test