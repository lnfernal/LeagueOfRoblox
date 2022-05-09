function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.125 - (1.125 * d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_SOUND(d.HUMAN, 12222216)
	wait(0.05)
	d.PLAY_SOUND(d.HUMAN, 12222216)
	wait(0.1)	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShylockeBasicAttackFinal-item?id=263064286")
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .4
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	
	end 
d.DS.Melee:Invoke(hrp, team, onHit,10,6) 
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 11 - (11 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BuildermanBasic-item?id=155782461")
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 16, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skills.Value.Color), Transparency = 0.5}, 0.4)
	wait(0.5)
	d.PLAY_SOUND(d.HUMAN, 12222030, nil, 2)
	
	local center = d.FLAT(d.HRP.Position)
	local radius = 12
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	local function onHit(enemy)
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Shockwave:Invoke(center, radius, script.Parent.Parent.Character.Torso.Skills.Value.Color)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShylockeVoidBlade-Startup-Final-item?id=263065200")
	d.SFX.Trail:Invoke(d.CHAR["Right Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skills.Value.Color)}, 0.5, 0.75)
	wait(0.75)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShylockeVoidBlade-Active-Final-item?id=263065510")
	d.PLAY_SOUND(d.HUMAN, 12222216, nil, 1.2)
	local heal =  d.CONTROL.GetStat:Invoke("Skillz") * .3
	local range = 13
	local width = 4.5
	local healOnce = false
	local tagName = d.PLAYER.Name.."VoidAbsorption"
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		if d.ST.GetEffect:Invoke(enemy, tagName) then 
			if not healOnce then
			d.DS.Heal:Invoke(d.HUMAN, heal) 
			healOnce = true
			end      
		end
	end
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	d.SFX.Line:Invoke(d.HRP.Position, d.HRP.CFrame.lookVector, range, width, script.Parent.Parent.Character.Torso.Skills.Value.Color)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShylockeVoidBreakerFinal-item?id=263065752")
	d.PLAY_SOUND(d.HUMAN, 12222208, nil, 2)
	local tagName = d.PLAYER.Name.."VoidAbsorption"
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 24 * 4
	local width = 8
	local range = 25
	
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	
	local duration = ability:C(data.duration)
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local function onHit(projectile, enemy)
	if enemy.Parent then
				local gs = enemy.Parent:FindFirstChild("GetStat", true)
				if gs then
					local res = gs:Invoke("Toughness")
					local debuff = res * ability:C(data.debuff) / 100
				
		d.ST.StatBuff:Invoke(enemy, "Toughness", -debuff, duration)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
		d.ST.Tag:Invoke(enemy, 7, tagName,true,Color3.new(170, 0, 255))
		if enemy.Parent then
			if enemy.Parent:FindFirstChild("HumanoidRootPart") then
				d.SFX.Artillery:Invoke(d.FLAT(enemy.Parent.HumanoidRootPart.Position), 4, script.Parent.Parent.Character.Torso.Skills.Value.Color)
			end
		end
		end
		end
		end
	end
	local function onStep(projectile)
		topos = projectile.Position 
	 
	
	d.SFX.Circles:Invoke(topos, 4, script.Parent.Parent.Character.Torso.Skills.Value.Color,.2,dir)
		
	end
	local function onEnd(projectile)
		d.HRP.CFrame = projectile:CFrame()
	end
	local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25,direction,"DiamondPlate",0.039)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 60 - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShylockeVoidGate-Startup-Final-item?id=263066012")
	d.SFX.Trail:Invoke(d.CHAR["Right Arm"], Vector3.new(0, -1, 0), 2.5, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skills.Value.Color)}, 0.5, 1.1)
	wait(0.5)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ShylockeVoidGate-Active-Final-item?id=263066325")
	d.PLAY_SOUND(d.HUMAN, 12222030, nil, 2)
	wait(0.3)
	local heal =  d.CONTROL.GetStat:Invoke("Skillz") * .25
	local tagName = d.PLAYER.Name.."VoidAbsorption"
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 100
	local width = 4.5
	local range = 48
	local team = d.CHAR.Team.Value
	local percent = ability:C(data.percent) / 100
	
	local function onHit(projectile, enemy)
		local damage = (enemy.MaxHealth - enemy.Health) * percent
		d.DS.Damage:Invoke(enemy, damage, nil, d.PLAYER)
		if d.ST.GetEffect:Invoke(enemy, tagName) then 
			d.DS.Heal:Invoke(d.HUMAN, heal) 
			
		end
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 3, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.5)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Void Locke",
		Desc = "Shylocke creates a shockwave which slows <slow>% nearby enemies for <duration> seconds as well as dealing <damage> damage.",
		MaxLevel = 5,
		slow = {
			Base = 50,
			
			
		},
		damage = {
			Base = 15,
			AbilityLevel = 10,
			Skillz = 0.25,
		},
		duration = {
			Base = 1.5,
		},
	},
	B = {
		Name = "Void Blade",
		Desc = "Shylocke strikes in front of him, dealing <damage> damage to enemies hit. Enemy champions with Void Absorption will heal you by 30% of your Skillz.",
		MaxLevel = 5,
		damage = {
			Base = 25,
			AbilityLevel = 10,
			Skillz = 0.85,
		},
	},
	C = { 
		Name = "Void Breaker",
		Desc = "[Innate] Void Absorption is a mark that Shylocke can apply only to enemy champions, this gives Shylocke a self-heal as a reward for doing his dirty work. [Active] Shylocke dashes a short distance forward. Enemies hit suffer <damage> damage and have their Toughness reduced by <debuff>% for <duration> seconds. This also applies Void Absorption to enemy champions who get in his way.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 7.5,
			Skillz = 0.3,
		},
		debuff = {
			Base = 20,
			
			
		},
		duration = {
			Base = 3,
		},
	},
	D = {
		Name = "Void Gate",
		Desc = "Shylocke fires a short-range projectile. The targets hit takes damage equal to <percent>% of their missing health, meaning that lower health produces more damage. Enemy champions with Void Absorption will heal you by 25% of your Skillz.",
		MaxLevel = 3,
		percent = {
			Base = 45,
			AbilityLevel = 5,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 155 + level * 7.5
	end,
	Skillz = function(level)
		return 5 + level * 1
	end,
	Toughness = function(level)
		return 5 + level * 0.25
	end,
	Resistance = function(level)
		return 5 + level * 0.35
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test