
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/StickBasicAttackFinal-item?id=261345732")
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 1.8)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
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
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 1, script.Parent.Parent.Character.Torso.gale.Value.Color, 0.1)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2, script.Parent.Parent.Character.Torso.gale.Value.Color, 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 25 - (25 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/StickLightningStormFinal-item?id=261344825")
	
	d.ST.MoveSpeed:Invoke(d.HUMAN, -.2, 3)
	for t = 0, 2.25, 0.75 do
		delay(t, function()
			local a = d.HRP.Position
			local range = 34
			local b = d.GET_MOUSE_POS:InvokeClient(d.PLAYER)
			local center = d.DS.Targeted:Invoke(a, range, b)
			local radius = 10
			local team = d.CHAR.Team.Value
			local damage = ability:C(data.damage)
			local function onHit(enemy)
				d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
				if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
			end
			d.DS.AOE:Invoke(center, radius, team, onHit)
			d.SFX.Bolt:Invoke(d.FLAT(center), 1,  script.Parent.Parent.Character.Torso.lightning.Value.Color)
			d.SFX.Explosion:Invoke(d.FLAT(center), radius, script.Parent.Parent.Character.Torso.lightning.Value.Color)
			d.PLAY_SOUND_POS(d.FLAT(center), 12222030, 2)
		end)
	end
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	d.PLAY_SOUND(d.HUMAN, 12221984, nil, 0.4)
	
	local damage = ability:C(data.damage)
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 48
	local speed = range / 1
	local width = 16
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		local hrp = d.GET_HRP(enemy)
		if hrp then
			d.DS.KnockAirborne:Invoke(enemy, 8, 0.25)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
			d.SFX.Shockwave:Invoke(d.FLAT(hrp.Position), 8, script.Parent.Parent.Character.Torso.underground.Value.Color)
		end
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		d.SFX.Shockwave:Invoke(d.FLAT(d.HRP.Position), 12, script.Parent.Parent.Character.Torso.underground.Value.Color)
		d.PLAY_SOUND(d.HUMAN, 12221984, nil, 0.55)
		d.HRP.CFrame = p:CFrame()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.DS.Stealth:Invoke(d.CHAR, range / speed)
	d.SFX.Shockwave:Invoke(d.FLAT(d.HRP.Position), 12, script.Parent.Parent.Character.Torso.underground.Value.Color)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
	d.ST.Stun:Invoke(d.HUMAN, range/speed)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 14 - (14 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	    d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C(script.Parent.Parent.Character.Torso.underground.Value.Color)}, 0.1)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/StickGaleForceFinal-item?id=261346177")
	wait(.2)
	d.PLAY_SOUND(d.HUMAN, 16211041, nil, 1.6)
	
	local hit = false
	local damage = ability:C(data.damage)
	
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 52.5
	local width = 5
	local range = 32
	local team = d.CHAR.Team.Value
	
	local function onHit(p, enemy)
		p.Moving = false
		hit = true
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		local hitAnEnemy = false
		
		local center = p.Position
		local radius = 10
		local function onHit(enemy)
			local hrp = d.GET_HRP(enemy)
			if hrp then
				local position = hrp.Position
				local direction = p.Direction
				local range = 24
				local speed = range / 0.2
				local width = 0
				local function onHit()
				end
				local function onStep(p, dt)
					hrp.CFrame = CFrame.new(p.Position, p.Position + p.Direction)
				end
				local function onEnd()
				end
				d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
				d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
				if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
			end
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Explosion:Invoke(center, radius, script.Parent.Parent.Character.Torso.gale.Value.Color)
		d.PLAY_SOUND_POS(center, 32656754)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjMeander:Invoke(p:ClientArgs(), 1.5, script.Parent.Parent.Character.Torso.gale.Value.Color, 0.15)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 60 - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/StickMeteorStrikeFinal-item?id=261368710")
	d.SFX.Trail:Invoke(d.CHAR["Left Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C(script.Parent.Parent.Character.Torso.meteor.Value.Color)}, 0.5, 0.4)
		d.SFX.Trail:Invoke(d.CHAR["Right Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C(script.Parent.Parent.Character.Torso.meteor.Value.Color)}, 0.5, 0.4)
	
	local damage = ability:C(data.damage)
	
	local height = 512
	local a = d.HRP.Position
	local range = 256
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local position = center + Vector3.new(0, height, 0)
	local direction = Vector3.new(0, -1, 0)
	local range = height
	local speed = range / 2
	local width = 0
	local team = d.CHAR.Team.Value
	local function onHit()
	end
	local function onStep(p, dt)
	end
	local function onEnd(p, dt)
		local radius = 24
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		for m = 0.5, 1, 0.25 do
			d.SFX.Explosion:Invoke(center, radius, script.Parent.Parent.Character.Torso.meteor2.Value.Color, 1 / m)
		end
		d.PLAY_SOUND_POS(center, 12222084, 1, 0.8)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 20, script.Parent.Parent.Character.Torso.meteor2.Value.Color, 0.5)
	d.SFX.Artillery:Invoke(center, 24, script.Parent.Parent.Character.Torso.meteor3.Value.Color, 2)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Lightning Storm",
		Desc = "Stickmasterluke calls upon a lightning storm, dealing <damage> damage with each strike on the targeted area for 4 strikes.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 5,
			H4x = 0.2,
		},
	},
	B = {
		Name = "Underground War",
		Desc = "Stickmasterluke burrows underground and causes an earthquake as he tunnels forward, dealing <damage> damage and knocking airborne each enemy he passed beneath.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 5,
			H4x = 0.25,
		},
	},
	C = {
		Name = "Gale Force",
		Desc = "Stickmasterluke hurls a compressed ball of wind. When it reaches the end of its range, it explodes, dealing <damage> damage and pushing back each enemy hit.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 7.5,
			H4x = 0.35,
		},
	},
	D = {
		Name = "Meteor Strike",
		Desc = "Stickmasterluke summons a huge meteor at a targeted location. It crashes into the ground and deals <damage> damage in an area.",
		MaxLevel = 3,
		damage = {
			Base = 10,
			AbilityLevel = 15,
			H4x = 0.65,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 120 + level * 17.5
	end,
	H4x = function(level)
		return 5 + level * 2
	end,
	Toughness = function(level)
		return 5 + 0.25 * level
	end,
	Resistance = function(level)
		return 5 + 0.25 * level
	end,
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test