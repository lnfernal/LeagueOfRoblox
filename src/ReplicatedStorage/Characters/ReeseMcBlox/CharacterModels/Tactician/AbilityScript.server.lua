function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ReeseBasicAttackFinal-item?id=259902250")
	wait(.15)
	d.PLAY_SOUND(d.HUMAN, 101157919, nil, 1)
	
	wait(0.15)
	
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
	part.Shape = "Ball"
	part.Size = Vector3.new(1, 1, 1)
	part.BrickColor = BrickColor.new(d.CHAR.Torso.Basic.Value.Color)
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 13.5 - (13.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ReeseModerateFinal-item?id=259907568")
	d.SFX.Trail:Invoke(d.CHAR["Right Arm"], Vector3.new(0, -1, -2.5), 1, {BrickColor = d.C(d.CHAR.Torso.Skills.Value.Color)}, 0.35, 0.8)
	wait(0.35)
	d.PLAY_SOUND(d.HUMAN, 48577326, nil, 0.85)
	wait(0.35)
	
	local position = d.CHAR.Staff.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 75
	local width = 4
	local range = 48
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Shape = "Ball"
	part.Size = Vector3.new(2, 2, 2)
	part.BrickColor = BrickColor.new("Buttermilk")
	part.Parent = workspace
	d.DB(part)
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.SFX.Bolt:Invoke(enemy.Parent:FindFirstChild("HumanoidRootPart").Position, 1,d.CHAR.Torso.Skills.Value.Color, 0.35)
		d.SFX.Explosion:Invoke(enemy.Parent:FindFirstChild("HumanoidRootPart").Position, 8, d.CHAR.Torso.Skills.Value.Color)
		d.SFX.Shockwave:Invoke(d.FLAT(projectile.Position), 4, d.CHAR.Torso.Skills.Value.Color)
		d.ST.Stun:Invoke(enemy, duration)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 17.5)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ReeseReorganizeFinal-item?id=259912809")
	wait(.15)
	d.PLAY_SOUND(d.HUMAN, 2101144, nil, 1)
	
	local center = d.HRP.Position
	local range = 18
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local heal = ability:C(data.heal)
	local function onHit(ally)
		d.DS.Heal:Invoke(ally, heal)
		local Half = ally.MaxHealth / 2
				if ally.Health <= Half then 
					local buff = (10/100*ally.MaxHealth) 
					  d.ST.StatBuff:Invoke(ally, "Shields", buff, 4)
					local hrp = ally.Parent:FindFirstChild("HumanoidRootPart")
				if hrp then
					local s = Instance.new("Fire", hrp)
					s.Color = d.CHAR.Torso.Basicult.Value.Color
					 delay(4, function()
						s:Destroy()
					end)    
					end
				end
	end
	d.DS.AOE:Invoke(center, range, team, onHit)
	
	d.SFX.Explosion:Invoke(center, range, "Pastel green")
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 13.5 - (13.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ReeseTeamSpiritFinal-item?id=259923830")
	d.PLAY_SOUND(d.HUMAN, 35971258, nil, 1)
	
	local center = d.HRP.Position
	local range = 18
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local speed = ability:C(data.speed) / 100
	local duration = ability:C(data.duration)
	local function onHit(ally)
		d.ST.MoveSpeed:Invoke(ally, speed, duration)
		local Half = ally.MaxHealth / 2
				if ally.Health <= Half then 
					local buff = (10/100*ally.MaxHealth) 
					  d.ST.StatBuff:Invoke(ally, "Shields", buff, 4)
					local hrp = ally.Parent:FindFirstChild("HumanoidRootPart")
				if hrp then
					local s = Instance.new("Fire", hrp)
					s.Color = d.CHAR.Torso.Basicult.Value.Color
					 delay(4, function()
						s:Destroy()
					end)    
					end
				end
	end
	d.DS.AOE:Invoke(center, range, team, onHit)
	
	d.SFX.Shockwave:Invoke(d.FLAT(center), range, d.CHAR.Torso.Basicult.Value)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 70 - (70 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ReeseBanFinal-item?id=259932401")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 32, {BrickColor = d.C(d.CHAR.Torso.Skills.Value.Color), Transparency = 0.5}, 0.65)
	
	wait(1.15)
	d.PLAY_SOUND(d.HUMAN, 48618583, nil, 1.25)
	
	
	local position = d.CHAR.Staff.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 64
	local width = 5
	local range = 64
	local team = d.CHAR.Team.Value
	local percent = -ability:C(data.percent) / 100
	local duration = ability:C(data.duration)
	local shred = -ability:C(data.shred) / 100
	local damage = ability:C(data.damage)
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Shape = "Ball"
	part.Size = Vector3.new(3, 3, 3)
	part.BrickColor = BrickColor.new(d.CHAR.Torso.Skills.Value.Color)
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(projectile, enemy)
		projectile.Moving = false		
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		d.DS.AOE:Invoke(projectile.Position, 16, team, function(enemy)
			d.ST.MoveSpeed:Invoke(enemy, percent, duration)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			 if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
			d.SFX.Bolt:Invoke(enemy.Parent:FindFirstChild("HumanoidRootPart").Position, 1,d.CHAR.Torso.Skills.Value.Color, 0.35)
			d.SFX.Explosion:Invoke(enemy.Parent:FindFirstChild("HumanoidRootPart").Position, 8, d.CHAR.Torso.Skills.Value.Color)
			if enemy.Parent then
				local gs = enemy.Parent:FindFirstChild("GetStat", true)
				if gs then
					local res = gs:Invoke("Resistance" and "Toughness")
					local debuff = res * ability:C(data.shred) / 100
					d.ST.StatBuff:Invoke(enemy, "Resistance", -debuff, duration)
					d.ST.StatBuff:Invoke(enemy, "Toughness", -debuff, duration)
					end
				end
		end)
		d.SFX.Shockwave:Invoke(d.FLAT(projectile.Position), 16, d.CHAR.Torso.Skills.Value.Color)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Agony",
		Desc = "Reese fires a projectile which deals <damage> damage to and stuns for <duration> seconds the first target it hits.",
		MaxLevel = 5,
		damage = {
			Base = 20, 
			AbilityLevel = 12.5,
			H4x = 0.35,
		},
		duration = {
			Base = 0.5,
			AbilityLevel = 0.3,
		},
	},
	B = {
		Name = "Revitalize",
		Desc = "Reese heals nearby allies for <heal> health. If Reese's and nearby allies health is below 50%, she will grant them a shield for 10% of their maximum health for 4 seconds.",
		MaxLevel = 5,
		heal = {
			AbilityLevel = 8,
			H4x = 0.3,
		},
	},
	C = {
		Name = "Ferocity Aura",
		Desc = "[Innate] Reese grants 'Inspire' herself and her nearby allies if their health is quite low which gives them a green fiery aura. [Active] Reese enrages nearby allies increases their speed by <speed>% for <duration> seconds. If Reese's and nearby allies health is below 50%, she will grant them a shield for 10% of their maximum health for 4 seconds.",
		MaxLevel = 5,
		speed = {
			Base = 15,
			AbilityLevel = 5,
			
		},
		duration = {
			Base = 4,
		},
	},
	D = {
		Name = "Atonement",
		Desc = "Reese fires a projectile which explodes, dealing <damage> damage and slowing nearby enemies by <percent>% for <duration> seconds as well as reducing their defense by <shred>% for the duration.",
		MaxLevel = 3,
		percent = {
			Base = 35,
			
		},
		duration = {
			Base = 3,
			
		},
		shred = {
			Base = 50,
			
			
		},
		damage = {
			Base = 60,
			AbilityLevel = 10,
			H4x = 0.25,
				
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 150 + level * 12.5
	end,
	H4x = function(level)
		return 4 + level * 2
	end,
	Toughness = function(level)
		return 5 + 0.5 * level
	end,
	Resistance = function(level)
		return 5 + 0.5 * level
	end,
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test