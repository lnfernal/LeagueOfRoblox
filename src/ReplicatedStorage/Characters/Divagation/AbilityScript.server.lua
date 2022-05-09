local robuck = Instance.new("Part")
robuck.Anchored = true
robuck.CanCollide = false
robuck.FormFactor = "Custom"
robuck.Size = Vector3.new(0.8, 0.2, 1.6)
robuck.BrickColor = BrickColor.new("Dark green")
robuck.TopSurface = "Smooth"
robuck.BottomSurface = "Smooth"

function getStackName(d)
	return d.PLAYER.Name.."CompoundInterest"
end

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	local tagName = getStackName(d)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DivagationBasicAttackFinal-item?id=263178735")
	wait(0.2)
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 2)
	
	local part = robuck:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local position = d.CHAR["Left Arm"].CFrame:pointToWorldSpace(Vector3.new(0, 1, 0))
	local direction = d.HRP.CFrame.lookVector
	local range = 32
	local speed = 80
	local width = 3.5
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
		d.RefreshStack(enemy, getStackName(d))
	end
	local function onStep() end
	local function onEnd() end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd,nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,"Camo", 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local bonus = ability:C(data.bonus)
	local tagName = getStackName(d)
	local center = d.HRP.Position
	d.SFX.ReverseExplosion:Invoke(center, 7, "Camo", .15)
	wait(0.35)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DivagationCompoundInterestFinal-item?id=263179097")
	d.SFX.Trail:Invoke(d.CHAR["Left Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C("Bright yellow")}, 0.5, 0.4)
	
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 1.75)
	
	local part = robuck:Clone()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	
	local direction = d.HRP.CFrame.lookVector
	local range = 40
	local speed = 64
	local width = 4.5
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		local count = d.ST.GetStatusCount:Invoke(enemy, tagName)
		if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
		d.EasyStack(enemy, tagName, 8)
			end
		local totalDamage = damage + bonus * count
		d.DS.Damage:Invoke(enemy, totalDamage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		end
	local function onStep() end
	local function onEnd() end
	local spread = math.pi / 9
	for theta = -spread, spread, spread do
		local position = d.CHAR["Left Arm"].CFrame:pointToWorldSpace(Vector3.new(0, 1, 0))
		local direction = (d.HRP.CFrame * CFrame.Angles(0, theta * 0.5, 0)).lookVector
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part,CFrame.Angles(-math.pi / 2, 0, 0) )
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,"Camo", 0.25,direction,"Neon",0.039)
		end
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	local damage = ability:C(data.damage)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DivagationLoanFinal-item?id=263179303")
	wait(0.45)
	d.PLAY_SOUND(d.HUMAN, 12222200, 1)
	
	local part = d.CHAR.Moneybag:Clone()
	d.CW(part)
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local position = part.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 40
	local speed = 64
	local width = 4
	local team = d.CHAR.Team.Value
	local tagName = d.PLAYER.Name.."CompoundInterest"
	local function onHit(p, enemy)
		p.Moving = false
		
		d.CONTROL.AbilityCooldownReduce:Invoke("A", 1)
		
		d.ST.MoveSpeed:Invoke(enemy, slow, duration) 
		
		local hrp = d.GET_HRP(enemy)
		if hrp then
			delay(duration, function()
				local position = hrp.Position
				local radius = 15
				local function onHit(enemy)
					d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
					if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
					 if game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
			d.EasyStack(enemy, tagName, 8)
		end
				end
				d.DS.AOE:Invoke(position, radius, team, onHit)
				d.SFX.Explosion:Invoke(position, radius, script.Parent.Parent.Character.Torso.Skills.Value.Color)
			end)
		end
	end
	local function onStep() end
	local function onEnd() end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new(), {
		Spin = CFrame.Angles(0, 1/16, 0)
	})
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local multiplier = ability:C(data.multiplier)
	local center = d.HRP.Position
	local radius = 60
	local tagName = getStackName(d)
	
	d.SFX.ReverseExplosion:Invoke(center, 5, script.Parent.Parent.Character.Torso.Skills.Value.Color, .45)
	wait(0.45)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/PunisherSoulSiphonFinal-item?id=263071327")
	
	local team = d.CHAR.Team.Value
	
	local function onHit(enemy)
		
			local stacks = d.ST.GetStatusCount:Invoke(enemy, tagName)
			local hrpenemy = d.GET_HRP(enemy)
		local damage = multiplier * stacks
		if stacks == 0 then damage = 0
			
		end
		d.PLAY_SOUND(enemy, 96626016)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 70 - (70 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local theft = ability:C(data.theft)
	local duration = ability:C(data.duration)

	local damage = ability:C(data.damage) 
	local radius = 20
	
	
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C("Bright yellow")}, 1)
	
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		 if not game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then return end 
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		local gs, ss = d.GET_SET_BINDABLES(enemy)
		local mgs, mss = d.GET_SET_BINDABLES(d.HUMAN)
		if gs and ss and mgs and mss then
			ss:Invoke("Tix", gs:Invoke("Tix") - theft)
			mss:Invoke("Tix", mgs:Invoke("Tix") + theft)
		end
	end
	
	local t = 0
	while t < duration do
		local dt = wait(1.1)
		t = t + dt
		
		local position = d.HRP.Position
		d.DS.AOE:Invoke(position, radius, team, onHit)
		d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), radius * 2, radius * 4, {BrickColor = d.C("Bright yellow")}, 1) 
	end
end
	
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Compound Interest",
		Desc = "[Innate] Compound Interest is a stack (which lasts 7 seconds) that makes some of Divagation's abilities stronger per stack, giving out more potential in a sustained fight, his basic attacks also refreshes Compound Interest. [Active] Divagation throws 3 robucks in a cone-pattern that deals <damage> damage to all enemies it hits. It then applies a stack of Compound Interest to all enemy players. For each stack of Compound Interest, the robuck deals <bonus> bonus damage.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 2,
			H4x = 0.1,
		},
		bonus = {
			Base = 5,
			AbilityLevel = 1,
			H4x = 0.065,
		}
	},
	B = {
		Name = "Loan",
		Desc = "Divagation throws a moneybag that attaches to a target, slowing them <slow>% for <duration> seconds. After the slow ends, the moneybag explodes on the target, dealing <damage> damage in an area and giving 1 stack of Compound interest to all players.",
		MaxLevel = 5,
		slow = {
			Base = 25,
			AbilityLevel = 5,
		},
		duration = {
			Base = 1.25,
		},
		damage = {
			Base = 5,
			AbilityLevel = 5,
			H4x = 0.2,
		}
	},
	C = {
		Name = "'Capital' Punishment",
		Desc = "Divagation demands punishment for all of his 'business partners', and deals <multiplier> damage for each stack on each enemy who are within 60 studs.",
		MaxLevel = 5,
		multiplier = {
			Base = 5,
			AbilityLevel = 7.5,
			H4x = .125
		}
	},
	D = {
		Name = "Ponzi Scheme",
		Desc = "Divagation, being the financial genius that he is, creates a ponzi scheme which deals <damage> damage to nearby enemy champions and steals <theft> Tix from them.", 
		MaxLevel = 3,
		theft = {
			Base = 20,
			AbilityLevel = 5,
			H4x = 0.1,
			
		},
		duration = {
			Base = 1, 
		},	
		damage = {
		    Base = 20,
			AbilityLevel = 10,
			H4x = 0.4,
		
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


--test--