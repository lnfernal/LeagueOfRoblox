local attackNumber = 1
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	local damage = d.CONTROL.GetStat:Invoke("H4x") * .25
	
	local part = d.CHAR.Hammer2:Clone()
	d.CW(part)
	part.Anchored = true
	part.CanCollide = false
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	
	local position
	local direction
	
	if attackNumber == 1 then
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/awesomeBasic-item?id=435089583")
		wait(.775) --time for the keyframes of animation to get set to proper position to throw hammer
		position = d.CHAR["Hammer2"].CFrame:pointToWorldSpace(Vector3.new(1, 0, 0))
		direction = d.HRP.CFrame.lookVector
		attackNumber = 2
	elseif attackNumber == 2 then
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/awesomeBasic2-item?id=435303833")
		wait(.775)
		position = d.CHAR["Hammer1"].CFrame:pointToWorldSpace(Vector3.new(1, 0, 0))
		direction = d.HRP.CFrame.lookVector
		attackNumber = 1
	end
	
	d.PLAY_SOUND(d.HUMAN, 166423113)
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
		d.PLAY_SOUND(enemy, 318985812)
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		p:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"Hot pink", 0.25,direction,"Neon",0.039)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.Angles(0, math.pi, 0),
		{Spin = CFrame.Angles(1/4, 0, 0)}
	)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12 - (6 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/awesomeAbility1-item?id=435318016")
	wait() -- equal to .029999999999 repeating
	
	local position = d.CHAR["Hammer1"].CFrame:pointToWorldSpace(Vector3.new(0, 1, 0))
	local direction = d.HRP.CFrame.lookVector
	local speed = 69
	local width = 4
	local range = ability:C(data.range)
	local team = d.CHAR.Team.Value
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	d.ST.Stun:Invoke(d.HUMAN, .2)
	wait(.2)
	local function onHit(p, enemy)
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			p.Moving = false
			d.ST.MoveSpeed:Invoke(enemy, slow, duration)
			local hrp = d.GET_HRP(enemy)
			if hrp then
				local delta = hrp.Position - p.Position
				delta = Vector3.new(delta.X, 8, delta.Z)
				hrp.Parent:MoveTo(d.HRP.Position + delta)
			end
		end
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjZap:Invoke(p:ClientArgs(), 1.2, "Hot pink", 0.2)
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,"Hot pink", 0.25,direction,"Neon",0.039)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 25)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/PspEpicComebackFinal-item?id=263103564")
	wait(0.65)
	
	local heal = ability:C(data.heal)
	local damage = ability:C(data.damage)
	local radius = 15
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local team2 = d.CHAR.Team.Value
	local duration = ability:C(data.duration)
	
	d.ST.MoveSpeed:Invoke(d.HUMAN, .15, duration)

	local t = 0
			while t < duration do
			local dt = wait(.5)
			t = t + dt
			
			local center = d.HRP.Position
			
			local function onHit(ally)
				d.ST.StatBuff:Invoke(ally, "HealthRegen", heal/2, 1)
				d.ST.StatBuff:Invoke(ally, "HealthRegen", ally.MaxHealth * .01, 1)
			end
			d.DS.AOE:Invoke(center, radius, team, onHit)
			d.SFX.ReverseExplosion:Invoke(d.FLAT(center), radius, "Pastel brown")
			
			local function onHit(enemy)
				d.ST.DOT:Invoke(enemy, damage, 3, "Resistance", d.PLAYER, "Overworked!")
				if enemy.Parent.Name == "Minion" then
			d.ST.DOT:Invoke(enemy, damage*1,3, "Resistance", d.PLAYER)
		end 
			end
			d.DS.AOE:Invoke(center, radius, team2, onHit)
			d.SFX.ReverseExplosion:Invoke(d.FLAT(center), radius, "Bright red")
		end
	end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 15 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.CONTROL.AbilityCooldownLag:Invoke("Q", 0.286)
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/awesomeAbility3-item?id=435340564")
	wait(0.285)
	
	local range = 36
	local nerf = -ability:C(data.nerf)
	local nerf2 = -ability:C(data.nerf2)/100
	local duration = ability:C(data.duration)
	local teamObj = d.GET_TEAM_OBJ(d.HUMAN)
	local missingHealth
	local radius = 14
	
	local pos = d.HRP.Position
	local tem = d.CHAR.Team.Value
	local target = d.DS.NearestTarget:Invoke(d.HRP.Position, range, tem)
	if target then
		local hrp = d.GET_HRP(target)
		missingHealth = target.MaxHealth - target.Health
		if hrp then
			local function onHit(enemy)
				if missingHealth > target.Health then
					d.ST.StatBuff:Invoke(enemy, "Toughness", d.CONTROL.GetStat:Invoke("Toughness") * nerf2, duration)
					d.ST.StatBuff:Invoke(enemy, "Resistance", d.CONTROL.GetStat:Invoke("Resistance") * nerf2, duration)
					radius = 18
				end
				d.ST.StatBuff:Invoke(enemy, "Toughness", nerf, duration)
				d.ST.StatBuff:Invoke(enemy, "Resistance", nerf, duration)
			end
			d.DS.AOE:Invoke(hrp.Position, radius, tem, onHit)
			d.SFX.Artillery:Invoke(hrp.Position, radius, "Magenta")
		end
	elseif target == nil then
		d.CONTROL.AbilityCooldownReduce:Invoke("C", 6.5)
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 75 - (75 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.CONTROL.AbilityCooldownLag:Invoke("Q", 0.5)
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/awesomeUltimate-item?id=435344067")
	wait(0.425)
	
	local tagName = d.PLAYER.Name.."Bolstered"
	local center = d.HRP.Position
	local radius = 24
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local buff = ability:C(data.bonus)/100
	local buff2 = ability:C(data.bonus2)
	local speedboost = ability:C(data.speedboost)/100
	
	local function onHit(ally)
		if game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then
			d.ST.StatBuff:Invoke(ally, "Toughness", d.CONTROL.GetStat:Invoke("Toughness") * buff, 5)
			d.ST.StatBuff:Invoke(ally, "Resistance", d.CONTROL.GetStat:Invoke("Toughness") * buff, 5)
			d.ST.StatBuff:Invoke(ally, "Toughness", buff2, 5)
			d.ST.StatBuff:Invoke(ally, "Resistance", buff2, 5)
			d.ST.MoveSpeed:Invoke(ally, speedboost * 5, 5)
			d.ST.Tag:Invoke(ally, 5, tagName)
			delay(1, function()
				d.ST.MoveSpeed:Invoke(ally, -speedboost, 4)
				delay(1, function()
					d.ST.MoveSpeed:Invoke(ally, -speedboost, 3)
					delay(1, function()
						d.ST.MoveSpeed:Invoke(ally, -speedboost, 2)
						delay(1, function()
							d.ST.MoveSpeed:Invoke(ally, -speedboost, 1)
						end)
					end)
				end)
			end)
		end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Shockwave:Invoke(center, radius, "Magenta")
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Admin Abuse",
		Desc = "After a brief self-stun, awesomehfhhr fires a fast projectile that travels <range> studs.  Upon the first enemy champion hit, they are brought to awesomehfhhr's location and slowed by <slow>% for <duration> seconds.",
		MaxLevel = 5,
		slow = {
			Base = 47.5,
			
		},
		duration = {
			Base = 1,
			AbilityLevel = .2,
		},
		range = {
			Base = 40,
			AbilityLevel = 1.5,
		
		},
	},
	B = {
		Name = "Overtime",
		Desc = "awesomehfhhr works into overtime, causing ally champions to gain <heal> health regen as well as 1% of their maximum health, while enemies take <damage> damage over time while near him for <duration> seconds.",
		MaxLevel = 5,
		heal = {
			Base = 7.5,
			AbilityLevel = 1.2,
			H4x = .1,
		},
		damage = {
			Base = 15,
			AbilityLevel = 7.5,
			H4x = .08,
		},
		duration = {
			Base = 4,
			
		},
	},
	C = {
		Name = "Demotion",
		Desc = "awesomehfhhr demotes his enemies, lowering the defenses of the nearest target and all enemies close to this target by <nerf>. If the target is below 50% health, the move will gain a bigger AOE and will further debuff nearby enemies by <nerf2>%. This lasts <duration> seconds.",
		MaxLevel = 5,
		nerf = {
			Base = 5,
			AbilityLevel = 5,
			H4x = .1,
		},
		nerf2 = {
			Base = 20,
			AbilityLevel = 1,
		},
		duration = {
			Base = 3,
		
		},
	},
	D = {
		Name = "Commend For Leadership",
		Desc = "awesomehfhhr shows his leadership powers and bring his allies together, granting <bonus>% bonus defenses as well as <bonus2> bonus defenses to nearby allies. This also grants <speedboost>% times 5 bonus speed, while the speed decays by <speedboost>% per second. This ability lasts 5 seconds.",
		MaxLevel = 3,
		bonus = {
			Base = 25,
			AbilityLevel = 5,
		},
		bonus2 = {
			AbilityLevel = 10,
			H4x = .25,
		},
		speedboost = {
			Base = 10,
		
		},
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
