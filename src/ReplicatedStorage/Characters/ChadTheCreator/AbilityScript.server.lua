local basicRange = 32
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.4
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChadBasicAttackFinal-item?id=263177240")
	wait(0.1)
	d.PLAY_SOUND(d.HUMAN, 97848313, nil, 0.85)
	
	local position = d.CHAR.Gun.CFrame:pointToWorldSpace(Vector3.new(0, 0, -2))
	local direction = d.HRP.CFrame.lookVector
	local range = basicRange
	local speed = 80
	local width = 3.5
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		
		
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,tostring(d.CHAR.Torso.Basic.Value), 0.25,direction,d.CHAR.Torso.Materials.Value,0.039)
	d.SFX.Explosion:Invoke(position, 1, tostring(d.CHAR.Torso.Basic.Value))
	
	wait(0.1)
	d.PLAY_SOUND(d.HUMAN, "13510737")
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12  - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	
	local duration = ability:C(data.duration)
	local center =  d.CHAR.Gun.CFrame:pointToWorldSpace(Vector3.new(0, 0, -2))
	d.SFX.ReverseExplosion:Invoke(center, 2, tostring(d.CHAR.Torso.Skills.Value), 0.3)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChadArmorPiercingRound-Startup-Final-item?id=263177659")
	wait(0.3)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChadArmorPiercingRound-Active-Final-item?id=263177850")
	wait(0.15)
	d.PLAY_SOUND(d.HUMAN, 97848313)

	local position = d.CHAR.Gun.CFrame:pointToWorldSpace(Vector3.new(0, 0, -2))
	local direction = d.HRP.CFrame.lookVector
	local range = 35
	local width = 5
	local team = d.CHAR.Team.Value
		d.ST.StatBuff:Invoke(d.HUMAN, "BasicCDR", .15, 3)
	local function onHit(enemy)
		
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		if enemy.Parent then
				local gs = enemy.Parent:FindFirstChild("GetStat", true)
				if gs then
					local res = gs:Invoke("Toughness")
					local debuff = res * ability:C(data.debuff) / 100
				
					d.ST.StatBuff:Invoke(enemy, "Toughness", -debuff, duration)
				end 
				end 
	end
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	d.SFX.Line:Invoke(position, direction, range, width, tostring(d.CHAR.Torso.Basic.Value))
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12.5  - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 16, {BrickColor = d.C(tostring(d.CHAR.Torso.Skills.Value))}, 0.3)
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChadFragmentationGrenadeFinal-item?id=263178017")
	wait(0.6)
	d.PLAY_SOUND(d.HUMAN, 13510737)
	
	local a = d.CHAR["Left Arm"].CFrame:pointToWorldSpace(Vector3.new(0, -1, 0))
	local maxRange = 40
	local b = d.DS.Targeted:Invoke(a, maxRange, d.GET_TARGET_POS())
	local vector = (b - a)
	local range = vector.magnitude
	local direction = vector.unit
	local speed = 128
	local width = 0
	local team = d.CHAR.Team.Value
	
	local function onHit(p, enemy)
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		delay(0.6, function()
			local position = p.Position
			local radius = 14
			local function onHit(enemy)
				d.ST.MoveSpeed:Invoke(enemy, slow, duration)
				d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
				if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
			end
			d.DS.AOE:Invoke(position, radius, team, onHit)
			d.SFX.Explosion:Invoke(position, radius, tostring(d.CHAR.Torso.Skills.Value))
			d.PLAY_SOUND_POS(position, 12222084)
		end)
	end
	local p = d.DS.AddProjectile:Invoke(a, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 1, tostring(d.CHAR.Torso.Skill3.Value), 0.1)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 20  - (20 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
		d.ST.Stun:Invoke(d.HUMAN, 0.75)
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.4
	local range = ability:C(data.range)
	local center = d.CHAR.Gun.CFrame:pointToWorldSpace(Vector3.new(0, 0, -2))
	d.SFX.ReverseExplosion:Invoke(center, 10, tostring(d.CHAR.Torso.Skills.Value), 0.75)
	local a = d.HRP.Position
	local b = d.GET_MOUSE_POS:InvokeClient(d.PLAYER)
	local target = d.DS.Targeted:Invoke(a, range, b)
	local team = d.CHAR.Team.Value
	local radius = 12
	local enemy = d.DS.NearestTarget:Invoke(target, radius, team)
	local hrp = d.GET_HRP(enemy)
	local tohit = true
	if hrp then
		--fancy animation
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChadHeadshotFinal-item?id=263178135")
		b = hrp.Position
		local vector = b - a
		local range = 1
		local direction = vector.unit
		local speed = range / 0.1
		local width = 0
		local function onHit()
		end
		local function onStep()
		end
		local function onEnd()
		end
		local p = d.DS.AddProjectile:Invoke(a, direction, speed, width, range, team, onHit, onStep, onEnd)
		d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
		wait(0.75)
		d.PLAY_SOUND(d.HUMAN, 97848313, nil, 1.2)
		--/fancy animation
		
		local position = d.CHAR.Gun.CFrame:pointToWorldSpace(Vector3.new(0, 0, -2))
		local vector = hrp.Position - position
		local range = vector.magnitude
		local direction = vector.unit
		local speed = range / 0.25
		local width = 1
		local function onHit2(p,real)
			p.Moving = false
			d.DS.Damage:Invoke(real, damage, "Toughness", d.PLAYER)
			tohit = false
			print(tohit)
		end
		local function onStep()
		end
		local function onEnd2()
			print(tohit)
			if tohit then
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			end
		end
		local pz = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit2, onStep, onEnd2)
		d.SFX.ProjShrink:Invoke(pz:ClientArgs(), 0.5, d.CHAR.Torso.Basic.Value.Color, 0.25)
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 80  - (80 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local center = d.HRP.Position
	local duration = ability:C(data.duration)
d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 16, {BrickColor = d.C(tostring(d.CHAR.Torso.Skills.Value))}, 1)
d.CONTROL.AbilityCooldownLag:Invoke("B", 1.5)
	d.CONTROL.AbilityCooldownLag:Invoke("A", 1.5)
	d.CONTROL.AbilityCooldownLag:Invoke("C", 1.5)
wait(1.25)
	local radius = 512
	local step = 0.1
	for percent = step, 1, step do
		d.SFX.Explosion:Invoke(Vector3.new(), radius, "White", 2 * percent)
		
	
	end
	
	local team = d.CHAR.Team.Value

	local function onHit(enemy)
		d.DS.KnockAirborne:Invoke(enemy, 16, duration)
	d.ST.MoveSpeed:Invoke(enemy, -.25, 2.5)
		
	end
	d.DS.AOE:Invoke(Vector3.new(), radius, team, onHit)
	
	d.PLAY_SOUND(workspace, 12222084)
end


local abilityData = {
	A = {
		Name = "Armor Piercing Round",
		Desc = "ChadTheCreator gains 15% increased attack speed for 3 seconds while firing a fast-moving magnum armor-piercing round which deals <damage> damage to enemies in a line and reduces their Toughness by <debuff>% for <duration> seconds.",
		MaxLevel = 7,
		damage = {
			Base = 10,
			AbilityLevel = 8,
			Skillz = 0.25,
		},
		debuff = {
			Base = 20,
		
		},
		duration = {
			Base = 3.5,
		}
	},
	B = {
		Name = "Fragmentation Grenade",
		Desc = "ChadTheCreator throws a frag grenade to the targeted location. Enemies hit by the ensuing explosion take <damage> damage and are slowed <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 10,
			Skillz = .35,
		},
		slow = {
			Base = 25,
			
		},
		duration = {
			Base = 2.5,
		}
	},
	C = {
		Name = "Headshot",
		Desc = "ChadTheCreator stands still and guarantees a headshot on the first target it hits <range> studs away. This headshot deals 40% of Skillz as damage.",
		MaxLevel = 5,
		range = {
			Base = 46,
			AbilityLevel = 0.5,
			
		}
	},
	D = {
		Name = "The Flash",
		Desc = "ChadTheCreator unleashes an atomic bomb on the map, causing all enemies to be launched into the air for <duration> seconds and slows them down by 25% for 2.5 seconds.",
		MaxLevel = 1,
		duration = {
			Base = 0.5,
		
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


--test