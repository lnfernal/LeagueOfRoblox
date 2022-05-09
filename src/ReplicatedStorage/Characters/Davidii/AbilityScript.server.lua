local basicIsFirst = true
local basicHeal = 0
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .4
	
	if basicIsFirst then
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DavidiiBasicAttack1Final-item?id=262277934")
		d.PLAY_SOUND(d.HUMAN, 12222216, nil, 1.2)
	else
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DavidiiBasicAttack2Final-item?id=262278459")
		d.PLAY_SOUND(d.HUMAN, 12222216, nil, 1.4)
	end
	basicIsFirst = not basicIsFirst
	wait(0.19)
	
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			d.DS.Heal:Invoke(d.HUMAN, basicHeal)
		else
			damage = d.CONTROL.GetStat:Invoke("Skillz") * .5
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			d.DS.Heal:Invoke(d.HUMAN, basicHeal)
		end
	end
	d.DS.Melee:Invoke(d.HRP, team, onHit,10,6)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12.5)
	d.ST.MoveSpeed:Invoke(d.HUMAN, .5,0.75)
	local damage = ability:C(data.damage)
	local heal = ability:C(data.heal)
local percent = 0.3/100 
	d.PLAY_SOUND(d.HUMAN, 32656754, nil, 2)
	local range = 13
	local width = 4
	local team = d.CHAR.Team.Value
	local hits = 0
	local function onHit(enemy)
		local missingHealthPercent = ((enemy.MaxHealth - enemy.Health) / enemy.MaxHealth) * 100
		local slow = -percent * missingHealthPercent
		  
		d.DS.Damage:Invoke(enemy, damage * 0.33, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*0.33, "Toughness", d.PLAYER)
		end 
			d.ST.MoveSpeed:Invoke(enemy, slow, 2)
			if hits < 3 then
				d.DS.Heal:Invoke(d.HUMAN, heal * 0.33)
				hits = hits + 1
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
				if hrp then
					local s = Instance.new("Smoke", hrp)
					s.Color = Color3.new(0, 170, 0)
					 delay(2, function()
						s:Destroy()
					end)   
				end
				end
	end 
	
	for i = 1, 3 do
		wait(.25)
		if i == 1 then
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DavidiiGatheringStrikeFinal-item?id=263046551")
		end
		if i == 2 then
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DavidiiBasicAttack1Final-item?id=262277934")
		end
		if i == 3 then
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DavidiiBasicAttack2Final-item?id=262278459")
		end
		d.SFX.Line:Invoke(d.HRP.Position, d.HRP.CFrame.lookVector, range, width, script.Parent.Parent.Character.Torso.Skills.Value.Color)
		d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	end
	
	
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12.5)
	wait(0.15)
	local percent = 0.7/100 
	local damage = ability:C(data.damage)
	local heal = ability:C(data.heal)
	local heal2 = ability:C(data.heal2)
	local hitAPlayer = false
	local hitAnEnemy = false
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DavidiiCleaveofRejuvinationFinal-item?id=263047034")
	d.PLAY_SOUND(d.HUMAN, 12222225)
	
	local center = d.HRP.Position
	local radius = 14
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		hitAnEnemy = true
		
		if not hitAPlayer then
			hitAPlayer = game.Players:GetPlayerFromCharacter(enemy.Parent) ~= nil
		end
		local missingHealthPercent = ((enemy.MaxHealth - enemy.Health) / enemy.MaxHealth) * 100
		local slow = -percent * missingHealthPercent
		d.ST.MoveSpeed:Invoke(enemy, slow, 2)
		d.DS.Damage:Invoke(enemy, damage * 1.5, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then
					local s = Instance.new("Smoke", hrp)
					s.Color = Color3.new(0, 170, 0)
					 delay(2, function()
						s:Destroy()
					end)   
					end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Shockwave:Invoke(center, radius, script.Parent.Parent.Character.Torso.Skills.Value.Color) 
	
	if not hitAPlayer and hitAnEnemy then
		if heal >= heal2 then
			d.DS.Heal:Invoke(d.HUMAN, heal)
		elseif heal2 >= heal then
			d.DS.Heal:Invoke(d.HUMAN, heal2)
		end
		d.SFX.Explosion:Invoke(center, 8,script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.5)
	end
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12.5)
	
	local axe = d.CHAR.StoneAxe2

	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 16, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skills.Value.Color)}, 0.3)
	
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	local slow = -ability:C(data.slow)/100
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DavidiiClaimTerritoryFinal-item?id=263047338")
	wait(0.5)
	
	local part = axe:Clone()
	d.CW(part)
	part.Anchored = true
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local position = axe.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 40
	local speed = 54
	local width = 4

	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		p.Moving = false
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then 
			d.ST.DOT:Invoke(enemy, damage, duration,"Toughness", d.PLAYER, "Poisoned!")  
		elseif not game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			d.ST.DOT:Invoke(enemy, damage, duration,"Toughness", d.PLAYER, "Poisoned!")
		end
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
	end
	local function onStep(p, dt)
	
	 
	
	
	end
	local function onEnd(p)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,"Earth green", 0.25,direction,"Neon",0.039)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(0, math.pi, 0),
		
		{Spin = CFrame.Angles(1/4, 0, 0)}
	)
    
	axe.Transparency = 1
	wait(0.5)
	axe.Transparency = 0
	
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 90)
	
	local duration = ability:C(data.duration)
	local baseline = ability:C(data.baseline)
	local heal = ability:C(data.heal)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DavidiiUltimateSurvivorFinal-item?id=263048092")
	d.PLAY_SOUND(d.HUMAN, 84937942, nil, 0.9)
	
	d.SFX.ReverseExplosion:Invoke(d.HRP.Position, 8, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25)
	d.DB(Instance.new("ForceField", d.CHAR), duration)
	local missingHealth = d.HUMAN.MaxHealth - d.HUMAN.Health
	d.ST.StatBuff:Invoke(d.HUMAN, "HealthRegen", missingHealth * .05, 3)
	basicHeal = heal
	wait(5)
	basicHeal = 0
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Gathering Strikes",
		Desc = "Davidii strikes out 3 times which he gains increased speed, dealing <damage> damage split into 3 to enemies who dare to face him, he leaves his enemies debilitated which weakens their movement speed by 0.3% per 1% of their missing health for 2 seconds, as well as healing <heal> split into 3 if it hits a target.",
		MaxLevel = 1,
		damage = {
			Skillz = .5,
			 
		},
		heal = {
			Skillz = .4,
		},
	},
	B = {
		Name = "Cleave of Rejuvination",
		Desc = "Davidii spins in a circle, dealing <damage> damage to targets around him. If he hits a non-player target, he heals himself for either <heal2> (based on level) or <heal> (based on maximum health), based on the bigger value. If he hits a player, the damage is multiplied by 1.5x and he will leave his enemies debilitated, weakening their movement speed by 0.7% per 1% of their missing health for 2 seconds.",
		MaxLevel = 9,
		damage = {
			Base = 15,
			AbilityLevel = 10,
			Skillz = 0.25,
		},
		heal = {
			Health = 0.08,
		},
		heal2 = {
			Level = 8,
		},
	},
	C = {
		Name = "Claim Territory",
		Desc = "Davidii throws his axe forward. It poisons the target, dealing <damage> damage over <duration> seconds. The target is also slowed <slow>% during this poison.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 12.5,
			Skillz = 0.4, 
		},
		duration = {
			Base = 3,
		},
		slow = {
			Base = 25,
			AbilityLevel = 5,
		}
	},
	D = {
		Name = "Ultimate Survivor",
		Desc = "[Innate] If Davidii drops below <baseline> health, this ability is activated. He gains <duration> seconds of invincibility, gains 15% missing health as health regen over 3 seconds.",
		MaxLevel = 3,
		duration = {
			Base = 2.5,
			AbilityLevel = .25,
		},
		heal = {
			
			Skillz = 0,
		},
		baseline = {
			Health = .2
		}
	},
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