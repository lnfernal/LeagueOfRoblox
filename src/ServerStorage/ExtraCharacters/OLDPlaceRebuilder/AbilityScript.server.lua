local AmmoEvent = game.ReplicatedStorage.Remotes.PlaceBulletCount
local MaximumAmmo = 8
local CurrentAmmo = 8
local MissingAmmo
local Reloading = false
local ExtraSpeed = false


function Reload(d)
	Reloading = true
	for i = 1, MissingAmmo, 1 do
		CurrentAmmo = CurrentAmmo + 1
		AmmoEvent:FireClient(d.PLAYER, CurrentAmmo, MaximumAmmo)
		d.PLAY_SOUND(d.HUMAN, 254833653, 0.5, 1)
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceRebuilderReload-item?id=461289944")
		if ExtraSpeed == true then
		wait(0.765 - (0.765 * d.CONTROL.GetStat:Invoke("BasicCDR")))
		else
		wait(0.85 - (0.85 * d.CONTROL.GetStat:Invoke("BasicCDR")))
		end
	end
	Reloading = false
end





function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") or Reloading then return end
	if CurrentAmmo <= 0 and not Reloading then return Reload(d) end
	d.CONTROL.AbilityCooldown:Invoke("Q", 0.8 - (0.8 * d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceRebuilderPassive-item?id=461889122")
	d.PLAY_SOUND(d.HUMAN, 138083993, 0.5, 0.95)
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.2
	
	CurrentAmmo = CurrentAmmo - 1
	MissingAmmo = MaximumAmmo - CurrentAmmo
	AmmoEvent:FireClient(d.PLAYER, CurrentAmmo, MaximumAmmo)
		
	local bullet = Instance.new("Part")
	local mesh = Instance.new("SpecialMesh")
		bullet.Anchored = true
		bullet.BrickColor = BrickColor.new("Bright yellow")
		bullet.CanCollide = false
		bullet.TopSurface = "Smooth"
		bullet.BottomSurface = "Smooth"
		bullet.Size = Vector3.new(0.4, 0.8,0.4)
		mesh.MeshId = "http://www.roblox.com/asset/?id=10207677"
		mesh.Scale = Vector3.new(0.05, 0.05, 0.05)
		mesh.Parent = bullet
		bullet.Parent = game.ReplicatedStorage
		d.DB(bullet)
	

	local position = d.CHAR.GunBarrel.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 32
	local width = 2.5
	local speed = 48
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		p.Moving = false
		if enemy.Parent.Name == "Turret" then
		d.DS.Damage:Invoke(enemy, damage / 1.25, "Toughness", d.PLAYER)
		else
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		end
	end
	local function onStep(p, dt)
	end
	local function onEnd()
	end
	for i = 1, 4, 1 do
		local direction = (d.HRP.CFrame * CFrame.Angles(0, ((i / 4) * (math.pi / 7)), 0)).lookVector
		local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
		d.SFX.ProjPart:Invoke(p:ClientArgs(), bullet,  CFrame.Angles(math.pi / 2, 0, 0))
	d.SFX.Explosion:Invoke(position, 2, "Neon orange")
	end
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") or Reloading then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 22.5)
	d.CONTROL.AbilityCooldownLag:Invoke("Q", 1)
	
	d.CHAR.Shotgun.Transparency = 1
	d.CHAR.Pillz.Transparency = 0
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceRebuilderAbility1-item?id=461284226")
	wait(0.3)
	
	local torestore = ability:C(data.percent)/100
	local duration = ability:C(data.duration)
	
	local missing = d.HUMAN.MaxHealth - d.HUMAN.Health
	local percentheal = missing * torestore
	
	print(percentheal)
	
	local beforeheal = d.HUMAN.Health
	
	d.DS.Heal:Invoke(d.HUMAN, percentheal)
	
	wait(0.1)
	d.CHAR.Shotgun.Transparency = 0
	d.CHAR.Pillz.Transparency = 1
	delay(duration, function()
		local currenthealth = d.HUMAN.Health 
		if currenthealth >= beforeheal then
			d.DS.Damage:Invoke(d.HUMAN, (currenthealth - beforeheal))
		end
	end)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") or Reloading then return end
	
	local duration = ability:C(data.duration)
	
	d.CONTROL.AbilityCooldown:Invoke("B", duration + 20)
	
	local bonus = ability:C(data.amount)
	
	ExtraSpeed = true
	MaximumAmmo = MaximumAmmo + bonus
	CurrentAmmo = CurrentAmmo + bonus
	AmmoEvent:FireClient(d.PLAYER, CurrentAmmo, MaximumAmmo)
	
	delay(duration, function()
	ExtraSpeed = false
	MaximumAmmo = MaximumAmmo - bonus
	CurrentAmmo = CurrentAmmo - bonus
	AmmoEvent:FireClient(d.PLAYER, CurrentAmmo, MaximumAmmo)
	end)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") or Reloading then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 14)
		
	local damage = ability:C(data.damage)
	local duration = 1
	
	local position = d.CHAR.GunBarrel.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 28
	local width = 2.5
	local speed = 42
	local team = d.CHAR.Team.Value
	
	local aoepos
	
	
	local pipebomb = Instance.new("Part")
	local mesh = Instance.new("SpecialMesh")
		pipebomb.Anchored = true
		pipebomb.BrickColor = BrickColor.new("Medium stone grey")
		pipebomb.CanCollide = false
		pipebomb.TopSurface = "Smooth"
		pipebomb.BottomSurface = "Smooth"
		pipebomb.Size = Vector3.new(1, 2, 1)
		mesh.MeshId = "http://www.roblox.com/asset/?id=16975131"
		mesh.TextureId = "http://www.roblox.com/asset/?id=16975111"
		mesh.Scale = Vector3.new(0.6, 0.6, 0.6)
		mesh.Parent = pipebomb
		pipebomb.Parent = game.ReplicatedStorage
		d.DB(pipebomb)
		
	d.CHAR.Shotgun.Transparency = 1
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceRebuilderAbility3-item?id=461300222")
	wait(0.35)
	d.CHAR.Shotgun.Transparency = 0
	
	local function onHitExplode(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		local slow = 0.75
				d.ST.MoveSpeed:Invoke(enemy, -slow, 2)
			
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		local aoepos = p.Position
		local effpart = pipebomb:Clone()
		game:GetService("Debris"):AddItem(effpart, duration)
		effpart.Parent = workspace
		effpart.Position = aoepos - Vector3.new(0,2,0)
		
		local function onHitPull(enemy)
		if enemy.Parent and not game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then
				local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
				if hrp then
					local position = hrp.Position
					local vector = (p.Position - position)
					local direction = vector.unit
					local distance = vector.magnitude
					direction = Vector3.new(direction.X, 0, direction.Z).unit
					local speed = distance / 1.85
					local width = 4
					local range = distance
					local function onHit(projectile, enemy)
					end
					local function onStep(projectile)
						hrp.CFrame = CFrame.new(projectile.Position)
					end
					local function onEnd(projectile)
					end
					d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
				end
			end
		end
		d.DS.AOE:Invoke(aoepos, 17.5, team, onHitPull)
		
		delay(duration, function()
		d.DS.AOE:Invoke(aoepos, 17.5, team, onHitExplode)
		d.SFX.Explosion:Invoke(aoepos, 17.5, "Dark stone grey")
		end)
	end
	
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, nil, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), pipebomb, CFrame.Angles(math.pi / 4,math.pi,0))
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") or Reloading then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 40)

	d.PLAY_SOUND(d.HUMAN, 367720620, 0.85, 1)
	
	local duration = ability:C(data.duration)
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.06
	local pos = d.HRP
	local team = d.CHAR.Team.Value
	
	
	d.CONTROL.AbilityCooldownLag:Invoke("Q", duration)
	d.CONTROL.AbilityCooldownLag:Invoke("A", duration)
	d.CONTROL.AbilityCooldownLag:Invoke("B", duration)
	d.CONTROL.AbilityCooldownLag:Invoke("C", duration)
	
	d.CHAR.Chainsaw.Transparency = 0
	d.CHAR.Shotgun.Transparency = 1
	d.ST.MoveSpeed:Invoke(d.HUMAN, 0.35, duration)
	delay(duration, function()
	d.CHAR.Chainsaw.Transparency = 1
	wait(0.425)
	d.CHAR.Shotgun.Transparency = 0
	end)
	
	local t = 0
	while t < duration do
		local dt = wait(1/25)
		t = t + dt
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		end
		d.DS.Melee:Invoke(pos, team, onHit, nil, true)
	end
end
script.Ability4.OnInvoke = ability4




local abilityData = {
	A = {
		Name = "Pillz Here",
		Desc = "PlaceRebuilder, being the excellent survivor that he is, always, always has pillz, he consumes them restore <percent>% of his missing health for <duration> seconds. This will never drop PlaceRebuilder below his health before he consumed the pillz.",
		MaxLevel = 5,
		percent = {
			Base = 35,
			AbilityLevel = 5,
		},
		duration = {
			Base = 3,
			AbilityLevel = 1,
		},
	},
	B = {
		Name = "Extra Shells",
		Desc = "PlaceRebuilder, never leaves his last safehouse without arming himself with more ammo than he left with, he gains <amount> shells and, reload speed is increased by 10% for <duration> seconds. The cooldown of this move increases with the duration, but the total wait time stays the same.",
		MaxLevel = 5,
		amount = {
			Base = 1,
			AbilityLevel = 1,
		},
		duration = {
			Base = 5,
			AbilityLevel = 5,
		},
	},
	C = {
		Name = "Pipebomb",
		Desc = "PlaceRebuilder throws a pipebomb that attracts these strange creatures he thinks are zombies, his pipebomb explodes after 1 second dealing <damage> and slowing enemies by 75% for 2 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 12,
			AbilityLevel = 4,
			Skillz = 0.35,
		},
	},
	D = {
		Name = "Equip Chainsaw",
		Desc = "PlaceRebuilder equips one the most feared weapons ever created, the chainsaw has <duration> seconds of fuel, during this time PlaceRebuilder also gains a 25% speed boost. Every 0.04 seconds the chainsaw deals <damage> damage.",
		MaxLevel = 3,
		duration = {
			Base = 6,
			AbilityLevel = 3,
		},
		damage = {
			Skillz = 0.06,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 110 + level * 11
	end,
	Skillz = function(level)
		return 5 + level * 0.9
	end,
	Toughness = function(level)
		return 5 + level * 0.5
	end,
	Resistance = function(level)
		return 5 + level * 0.4
	end,
	Speed = function(level)
		return 14.5
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test