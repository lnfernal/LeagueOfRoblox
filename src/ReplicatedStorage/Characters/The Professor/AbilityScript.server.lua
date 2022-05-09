function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ProfessorBasicFinal-item?id=263180005")
	d.PLAY_SOUND(d.HUMAN, 34315534)
	
	local position = d.CHAR["Right Arm"].CFrame:pointToWorldSpace(Vector3.new(0, 1, 0))
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
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
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjZap:Invoke(p:ClientArgs(), 1, d.CHAR.Torso.Skills.Value.Color, 0.1)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,d.CHAR.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 20 - (20 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local experience = ability:C(data.experience)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ProfessorLessonFinal-item?id=263180218")
	wait(1)
	d.PLAY_SOUND(d.HUMAN, 81116570)
	
	local position = d.HRP.Position
	local radius = 20
	local cRadius = radius * 2
	local cTeam = d.CHAR.Team.Value
	local team = d.GET_OTHER_TEAM:Invoke(cTeam)
	local buff = d.CONTROL.GetStat:Invoke("H4x") * 0.2
	local function onHit(ally)
		if not game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then return end  
		local char = ally.Parent
		local hrp = d.GET_HRP(ally)
		if char and hrp then
			local giveExp = char:FindFirstChild("GiveExperience", true)
			if giveExp then
				giveExp:Invoke(experience)
				d.SFX.RisingMessage:Invoke(
					hrp.Position + Vector3.new(0, 3, 0),
					"+"..experience.." Experience!",
					1,
					{TextColor3 = Color3.new(1, 1, 1)}
				)
					local chosen = math.random(1,100)
		
			d.ST.StatBuff:Invoke(ally, "Skillz", buff, 10)
			d.ST.StatBuff:Invoke(ally, "H4x", buff, 10)
		end
		end
	end
	d.DS.AOE:Invoke(position, radius, team, onHit)
	d.SFX.Explosion:Invoke(position, radius, d.CHAR.Torso.Skills.Value.Color)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 10 - (6 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local duration = ability:C(data.duration)
	d.ST.MoveSpeed:Invoke(d.HUMAN, -.3, 0.95)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ProfessorCornyJokeFinal-item?id=263180535")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 5, 32, {BrickColor = d.C(d.CHAR.Torso.Skills.Value.Color), Transparency = 0.5}, 0.7)
	d.CONTROL.AbilityCooldownLag:Invoke("C", .7)
	wait(0.7)
	d.PLAY_SOUND(d.HUMAN, 122572625)
	
	local position = d.HRP.Position
	local radius = 16.5
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local function onHit(enemy)
		local char = enemy.Parent
		if char then
			local head = char:FindFirstChild("Head")
			if head then
				d.ST.DOT:Invoke(enemy, damage, 1.625, "Resistance", d.PLAYER)
				if enemy.Parent.Name == "Minion" then
			d.ST.DOT:Invoke(enemy, damage*1,1.625, "Resistance", d.PLAYER)
		end 
				d.ST.Stun:Invoke(enemy, duration)
				delay(0, function()
					local t = 0
					while t < duration do
						t = t + wait(0.25)
						d.SFX.RisingMessage:Invoke(
							head.Position + Vector3.new(0, 1, 0),
							"Ha!",
							0.6,
							{TextColor3 = Color3.new(1, 1, 1)}
						)
					end
				end)
			end
		end
	end
	d.DS.AOE:Invoke(position, radius, team, onHit)
	d.SFX.Artillery:Invoke(position, radius, d.CHAR.Torso.Skills.Value.Color)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 14 - (11 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local debuff = -ability:C(data.debuff)
	local duration = ability:C(data.duration)
    d.CONTROL.AbilityCooldownLag:Invoke("B", 0.64)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ProfessorLabSupervisorFinal-item?id=263180810")
	d.PLAY_SOUND(d.HUMAN, 122572625, nil, 0.8)
	local center2 = d.HRP.Position
	d.SFX.ReverseExplosion:Invoke(center2, 14, d.CHAR.Torso.Skills.Value.Color, 0.2)
	wait(0.085)
	local a = d.HRP.Position
	local range = 48
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 18.5
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
     if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then 
		d.ST.StatBuff:Invoke(enemy, "Skillz", debuff, duration)
		d.ST.StatBuff:Invoke(enemy, "H4x", debuff, duration)
	end	
	end
	d.SFX.Explosion:Invoke(center, radius,d.CHAR.Torso.Skills.Value.Color , 0.5)
	wait(0.55)
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Explosion:Invoke(center, radius, d.CHAR.Torso.Skills.Value.Color)
	
	d.TELEPORT(center)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 50 - (50 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local speed = ability:C(data.speed)/100
	local duration = ability:C(data.duration)
	wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ProfessorBeachPartyFridayFinal-item?id=263181016")
	d.PLAY_SOUND(d.HUMAN, 12222253)
	
	local position = d.HRP.Position
	local radius = 24
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local function onHit(ally)
		d.ST.MoveSpeed:Invoke(ally, speed, duration)
	end
	d.DS.AOE:Invoke(position, radius, team, onHit)
	for t = 1, 4 do
		d.SFX.Shockwave:Invoke(d.FOOT(), radius, d.CHAR.Torso.Skills.Value.Color, 0.2 * t)
	end
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Lesson",
		Desc = "[Active] The Professor teaches a lesson, granting <experience> experience and a 20% damage boost to nearby allies for 10 seconds.",
		MaxLevel = 5,
		experience = {
			AbilityLevel = 0.8,
		}
	},
	B = {
		Name = "Corny Joke",
		Desc = "The Professor (as usual) tells a corny joke, dealing <damage> damage over time to nearby enemies and of course they stop and laugh for <duration> seconds. This is functionally equivalent to a stun.",
		MaxLevel = 5,
		duration = {
			Base = 1,
			AbilityLevel = 0.125,
			},
		damage = {
			Base = 25,
			AbilityLevel = 15,
			H4x = 0.45,
		}
	},
	C = {
		Name = "Lab Supervisor",
		Desc = "The Professor is an exceptional lab supervisor capable of getting around... almost as if he teleports. He teleports to the targeted location and surprises nearby enemies into losing <debuff> H4x and Skillz for <duration> seconds.",
		MaxLevel = 5,
		debuff = {
			Base = 10,
			AbilityLevel = 5,
			H4x = 0.3,
		},
		duration = {
			Base = 4.5,
			
		}
	},
	D = {
		Name = "Beach Party Friday!",
		Desc = "If it weren't FINALLY Friday, you'd probably wonder what the heck Beach Party Friday is. Regardless, the Professor gives his allies <speed>% move speed for <duration> seconds.",
		MaxLevel = 3,
		speed = {
			Base= 20,
			AbilityLevel = 20,
			
			},
		duration = {
			Base = 2.5,
			AbilityLevel = .5,
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