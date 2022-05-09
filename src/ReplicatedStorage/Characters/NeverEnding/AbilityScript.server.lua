function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.125 -(1.125 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/GuestBasicFinal-item?id=260609436")
	d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	
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
	d.CONTROL.AbilityCooldown:Invoke("A", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.ST.MoveSpeed:Invoke(d.HUMAN, -.2, 0.625)
	wait(0.625)
	local center = d.HRP.Position
	local radius = 15
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local stun = ability:C(data.stun)
	local tagName = d.PLAYER.Name.."Wacky!"
	local function onHit(enemy)
		d.ST.Stun:Invoke(enemy, stun)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			d.ST.Tag:Invoke(enemy, 7, tagName)
		end
	end
	 	
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/GuestSafeChatFinal-item?id=260610843")
	d.PLAY_SOUND(d.HUMAN, 12222084, nil, 1.5)
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Explosion:Invoke(center, radius, "Mulberry")
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.PLAY_SOUND(d.HUMAN, 35971258, nil, 1)
	wait(0.4)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/item.aspx?id=506091146")
	local center = d.HRP.Position
	local range = 15
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local enemyteam = d.CHAR.Team.Value
	local speed = ability:C(data.speed) / 100
	local duration = ability:C(data.duration)
	local damage = ability:C(data.damage)
	local tagName = d.PLAYER.Name.."Wacky!"
	local function onHit(ally)
		d.ST.MoveSpeed:Invoke(ally, speed, duration)
	end
	local function onHitenemy(enemy)
		local hrp = d.GET_HRP(enemy)
		if hrp then
			if d.ST.GetEffect:Invoke(enemy, tagName) then
			d.ST.DOT:Invoke(enemy, damage, 2.5, "Resistance", d.PLAYER, "Insane!")	
			d.ST.MoveSpeed:Invoke(enemy, -35/100, 2.5)		
			else
			d.ST.DOT:Invoke(enemy, damage, 2.5, "Resistance", d.PLAYER, "Wacky!")
			if enemy.Parent.Name == "Minion" then
			d.ST.DOT:Invoke(enemy, damage*1,2.5, "Resistance", d.PLAYER)
		end 
			end	
			end
	end
	d.DS.AOE:Invoke(center, range, team, onHit)
	d.DS.AOE:Invoke(center, range, enemyteam, onHitenemy)
	d.SFX.Shockwave:Invoke(d.FLAT(center), range, "Plum")
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 17.5)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ReeseReorganizeFinal-item?id=259912809")
	local center = d.HRP.Position
	local range = 16
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local heal = ability:C(data.heal)
	local percent = ability:C(data.percentage)/100
	local function onHit(ally)
		local missing = ally.MaxHealth - ally.Health
		local heal2 = missing * percent
		d.DS.Heal:Invoke(ally, heal + heal2)
	end
	d.DS.AOE:Invoke(center, range, team, onHit)
	d.SFX.Explosion:Invoke(center, range, "Lime green")
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 70 - (70 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ObliviousSelf-ReplicatingCodeFinal-item?id=263090611")
	local duration = ability:C(data.duration)
	local tagName = "Revival"
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 6
	local range = 64
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Symmetric"
	part.Size = Vector3.new(1, 1, 1)
	part.Shape = "Ball"
	part.BrickColor = BrickColor.new("Bright yellow")
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
	part.Parent = workspace
	d.DB(part)
	local hit = false
	local function onHit(p, ally)
		if not game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then return end
		if game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) ~= game:GetService("Players"):GetPlayerFromCharacter(d.CHAR) then
			p.Moving = false
			d.ST.TagOtherEffect:Invoke(ally, duration, tagName,d.CHAR.Name, ability:C(data.percentage))
			part:Destroy()
			hit = true
		end
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
		if hit == false then
	d.CONTROL.AbilityCooldownReduce:Invoke("D", ability:C(data.cooldownreduction))
	end
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	
	
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Psycho Crush",
		Desc = "NeverEnding plans to trick his foes by releasing dark purple explosion, afrer a self-slow, he stuns nearby enemies for <stun> seconds and deals <damage> damage. Then affected enemies will be tagged 'Wacky' that lasts for 7 seconds, which is essential to his second ability. The radius of this ability is 16 studs. ",
		MaxLevel = 5,
		stun = {
			Base = 1,
			AbilityLevel = 0.15
		},
		damage = {
			Base = 15,
			AbilityLevel = 6,
			H4x = 0.4
		},
	},
	B = {
		Name = "SUPPPPER WACKY!",
		Desc = "NeverEnding makes nearby allies go SUPPPPER WACKY! By increasing their speed by <speed>% for <duration> seconds, plus this will apply a DoT to nearby enemies dealing <damage> for 2.5 seconds. Hitting enemies who have the tag 'Wacky' will suffer brain damage, slowing them by 35% for 2.5 seconds.",
		MaxLevel = 5,
		speed = {
			Base = 14,
			AbilityLevel = 4,
			
		},
		damage = {
			Base = 15,
			AbilityLevel = 10,
			H4x = 0.3 
		},
		duration = {
			Base = 4
		},
	},
	C = {
		Name = "Replenish",
		Desc = "NeverEnding replenishes nearby allies health by <percentage>% of their missing health and <heal> health, meaning that the lower their health is, the more it heals.",
		MaxLevel = 5,
		heal = {
			Base = 5,
			AbilityLevel = 6.5,
			H4x = 0.3
		},
		percentage = {
			Base = 10,
			
				
		},
	},
	D = {
		Name = "Revival",
		Desc = "NeverEnding shoots a tiny golden projectile that marks his targeted ally with a golden sparkle aura for <duration> seconds. If the marked ally dies then the marked ally is immediately force fielded for 1.5s, their health is set at <percentage>% of their max health, and revived right beside NeverEnding.If the duration of the sparkles is near finished and the ally dies, the ally instead gets 40% of their max health as health and obtains 2.5s of forcefield but does not teleport back to NeverEnding. If NeverEnding misses the projectile, the cooldown is reduced by <cooldownreduction>s.",
		MaxLevel = 3,
		duration = {
			Base = 7,
			AbilityLevel = 1	
		},
		cooldownreduction = {
			Base = 30,
			
		},
		percentage = {
			Base = 25,
			AbilityLevel = 5	
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