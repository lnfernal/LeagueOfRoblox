local basic1 = true
local basic2 = false
local CooldownBasic = 1.2
local CooldownReduction = 0
local basicRange = 32
local basicSpeed = 80
local basicWidth = 3.5
local shots = 0
local bubbles = false
local bubbles2 = false
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", CooldownBasic - CooldownReduction - (CooldownBasic * d.CONTROL.GetStat:Invoke("BasicCDR")))
	if shots == 0 then
		basic1 = true
		basic2 = false
		shots = 0
	end
	if basic1 == true then
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/EmmaBasic-item?id=439846683")
		wait(.3)
	end
	if basic2 == true then
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/EmmaBasicThrow-item?id=439859781")
		wait(.4)
	end

	local range = basicRange
	local speed = basicSpeed
	local width = basicWidth
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	local team = d.CHAR.Team.Value
	local part = Instance.new("Part")
	local part2 = Instance.new("Part")
	if basic1 == true then
		part.Anchored = true
		part.CanCollide = false
		part.FormFactor = "Symmetric"
		part.Size = Vector3.new(1.5, 1.5, 1.5)
		part.Shape = "Ball"
		part.BrickColor =  d.CHAR.Torso.Skills.Value
		part.TopSurface = "Smooth"
		part.BottomSurface = "Smooth"
		part.Parent = game.ReplicatedStorage
		d.DB(part)
	elseif basic2 == true then
		basicRange = 32
		basicWidth = 3.5
	end
	
	local damage = d.CONTROL.GetStat:Invoke("H4x") * .25
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	local damage2 = ability:C(data.percent)
	
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		if (bubbles == true or bubbles2 == true) and enemy.Parent.Name ~= "Turret" then
		local effect = game.ReplicatedStorage.Items.EmmaWater:Clone()
		effect.BrickColor = d.CHAR.Torso.Skills.Value
			local w = Instance.new("Weld")
			w.Parent = effect
			w.Part0 = effect
			w.Part1 = enemy.Parent.Head
			w.C1 = CFrame.new(0,-2,0)
			effect.Parent = enemy.Parent
			game:GetService("Debris"):AddItem(effect, 1)
			delay(1, function()
				local function onHitt(enemy)
					d.DS.Damage:Invoke(enemy, damage * 0.65, "Resistance", d.PLAYER)
				end
				if enemy.Parent ~= nil then
				local pos = enemy.Parent:FindFirstChild("Torso")
				if pos ~= nil then
				d.DS.AOE:Invoke(pos.Position, 12, team, onHitt)
				d.SFX.Explosion:Invoke(pos.Position, 12, d.CHAR.Torso.Skills.Value.Color)
				end
				end
			end)
		end
	end
	local function onHitLine(enemy)
		d.DS.Damage:Invoke(enemy, damage2, "Resistance", d.PLAYER)
		if (bubbles == true or bubbles2 == true) and enemy.Parent.Name ~= "Turret" then
		local effect = game.ReplicatedStorage.Items.EmmaWater:Clone()
		effect.BrickColor = d.CHAR.Torso.Skills.Value
			local w = Instance.new("Weld")
			w.Parent = effect
			w.Part0 = effect
			w.Part1 = enemy.Parent.Head
			w.C1 = CFrame.new(0,-2,0)
			effect.Parent = enemy.Parent
			game:GetService("Debris"):AddItem(effect, 2)
			delay(1, function()
				local function onHitt(enemy)
				d.DS.Damage:Invoke(enemy, damage2 * 0.9, "Resistance", d.PLAYER)
				if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*0.9, "Resistance", d.PLAYER)
		end 
				end
				if enemy.Parent ~= nil then
				local pos = enemy.Parent:FindFirstChild("Torso")
				if pos ~= nil then
				d.DS.AOE:Invoke(pos.Position, 12, team, onHitt)
				d.SFX.Explosion:Invoke(pos.Position, 12, d.CHAR.Torso.Skills.Value.Color)
				end
				end
			end)
		end
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		d.PLAY_SOUND_POS(projectile.Position, 137304720)
		part:Destroy()
	end
	if basic1 == true then
		local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
		d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,d.CHAR.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
	elseif basic2 == true and shots > 0 then
	d.SFX.KillEmmaShots:Invoke(d.HRP,shots)
	shots = shots - 1
	d.DS.Line:Invoke(d.CHAR["Right Arm"], range, width, team, onHitLine, false,direction)
	d.SFX.Line:Invoke(position, direction, range, width, d.CHAR.Torso.Skills.Value.Color)
	end
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C(d.CHAR.Torso.Skill3.Value.Color)}, 0.1)
	--d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/EmmaAbility1-item?id=439849373")
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/EmmaAbility3-item?id=440279204")
	wait(0.45)
	local damage = ability:C(data.damage)
	local stun = ability:C(data.duration)
--	local center = d.HRP.Position
--	local radius = 15
	local team = d.CHAR.Team.Value
	local position = d.CHAR["Right Arm"].Position
	local speed = 57.5
	local width = 6
	local range = 48
	local part = game.ReplicatedStorage.Items.Wave:Clone()
	part.BrickColor = d.CHAR.Torso.Skills.Value
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	local function onHit(p,enemy)
		d.ST.Stun:Invoke(enemy, stun)
		d.ST.DOT:Invoke(enemy, damage, 1.5, "Resistance", d.PLAYER, "Drowning!")
		if enemy.Parent.Name == "Minion" then
			d.ST.DOT:Invoke(enemy, damage*1,1.5, "Resistance", d.PLAYER)
		end 
	end
	local function onStep(projectile)
	end
	
	local function onEnd(p)
		part:Destroy()		
	end
	--d.DS.AOE:Invoke(center, radius, team, onHit)
	--d.SFX.Explosion:Invoke(center, radius, "Bright blue")
	local direction = d.HRP.CFrame.lookVector
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.PLAY_SOUND_POS(position, 137304720)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 16 - (16 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.Artillery:Invoke(d.HRP.Position, 3, "Bright blue")
	local sparkles = Instance.new("Sparkles")
	sparkles.Parent = d.CHAR.Torso
	sparkles.Color = d.CHAR.Torso.Skills.Value.Color
	sparkles.Enabled = true
	
	d.SFX.Artillery:Invoke(d.HRP.Position, 3, d.CHAR.Torso.Skill3.Value.Color)
	sparkles.Enabled = false
	local duration = ability:C(data.duration)
	bubbles = true
	basic2 = true
	basic1 = false
	shots = 4
	d.SFX.ProjEmma:Invoke(d.HRP, d.CHAR.Torso.Skills.Value.Color, duration)
	delay(duration,function()
		bubbles = false
		basic2 = false
		basic1 = true
		shots = 0
		--beep:Disconnect()
	end)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/EmmaAbility3-item?id=440279204")
	wait(0.15)
		
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 32
	local speed = range * 2
	local width = 4
	local slow = -ability:C(data.percent)/100
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		d.ST.MoveSpeed:Invoke(enemy, slow, 2.5)
	end
	local function onStep(p, dt)
		d.HRP.CFrame = CFrame.new(p.Position, p.Position + p.Direction)
		
	end
	local function onEnd(p)
		p:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjZap:Invoke(p:ClientArgs(), 0.1, d.CHAR.Torso.Skills.Value.Color, 0.1)
	d.SFX.ProjZap:Invoke(p:ClientArgs(), 0.1, d.CHAR.Torso.Skills.Value.Color, 0.1)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 1,d.CHAR.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
	bubbles2 = true
	wait(5)
	bubbles2 = false

end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 42.5 - (42.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/EmmaUltimate-item?id=439835781")
	d.CONTROL.AbilityCooldownLag:Invoke("Q", 2.45)
	d.CONTROL.AbilityCooldownLag:Invoke("A", 2.45)
	d.CONTROL.AbilityCooldownLag:Invoke("B", 2.45)
	wait(0.625)
	
	local left = false
	local CanActiveBoost = true
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local position
	local Half = d.HUMAN.MaxHealth / 2
	local t = 0
	while t < 2 do
		local dt = wait(1/10)
		t = t + dt
		local range = 32
		local width = 8
		if d.HUMAN.Health <= Half then
			if CanActiveBoost == true then
				CanActiveBoost = false
				damage = damage * 1
			end
		end
		if left == false then
			position = d.CHAR["Right Arm"]
			
		else
			position = d.CHAR["Left Arm"]
		end
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage * dt, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1*dt, "Resistance", d.PLAYER)
		end 
		end
		if left == false then
			left = true
		else
			left = false
		end
	d.DS.Line:Invoke(position, range, width, team, onHit,false,d.HRP.CFrame.lookVector)
	d.SFX.Line:Invoke(position.Position, d.HRP.CFrame.lookVector, range, width, d.CHAR.Torso.Skill3.Value.Color)
	end
	CanActiveBoost = true
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Tidal Wave",
		Desc = "Emma swamps opponents in a tidal wave of water, stunning them for <duration> seconds and dealing <damage> damage over 1.5 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 10,
			H4x = .35,
		},
		duration = {
			Base = .5,
			AbilityLevel = .1,
		},
	},
	B = {
		Name = "Grand Tidal",
		Desc = "Emma summons 4 water balls around her that turn her attacks into a piercing water beam that deal <percent> damage, if this beam hits, the enemies are encased within a bubble that deal 85% of basic damage. These water balls last for <duration> seconds and last for 4 shots, if the 4 shots are fired,her basic attack will apply bubbles instead.",
		MaxLevel = 5,
		percent = {
			H4x = .125,
			H4xAbilityLevel = .02,
		},
		duration = {
			Base = 6.5,
			
		}
	},
	C = {
		Name = "Surf's Up!",
		Desc = "Emma acts like she's surfing and moves forward in a straight line. Enemies who get near her are slowed <percent>% for 2.5 seconds. She also temporarily imbues her basic attacks for 5 seconds with bubbles that explode dealing 75% of basic damage.",
		MaxLevel = 5,
		percent = {
			Base = 20,
			AbilityLevel = 3,
		}
	},
	D = {
		Name = "Sunshine",
		Desc = "Emma brings out the power of the sun and strikes opponents with a beam that deals <damage> damage per second, for 2 seconds. The beam follows your mouse.",
		MaxLevel = 3,
		damage = {
			Base = 20,
			AbilityLevel = 10,
			H4x = .4,
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