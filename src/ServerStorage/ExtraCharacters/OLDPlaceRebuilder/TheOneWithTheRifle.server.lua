local AmmoEvent = game.ReplicatedStorage.Remotes.PlaceBulletCount
local MaximumAmmo = 10
local CurrentAmmo = 10
local MissingAmmo
local Reloading = false
local ExtraSpeed = 0
local ExtraSpeed2  = 0
local randombullets = false
local EquipRifle = false
local Reduce = 0
function Reload(d)
	Reloading = true
	for i = 1, MissingAmmo, 1 do
		CurrentAmmo = CurrentAmmo + 1
		AmmoEvent:FireClient(d.PLAYER, CurrentAmmo, MaximumAmmo)
		d.PLAY_SOUND(d.HUMAN, 254833653, 0.5, 1)
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceRebuilderReload-item?id=461289944")
		wait(0 - Reduce  - ((0 - Reduce) * ExtraSpeed) - ((0 - Reduce) * ExtraSpeed2)- ((0 - Reduce) * d.CONTROL.GetStat:Invoke("BasicCDR")))
		if CurrentAmmo == MaximumAmmo then
			break
		end
	end
	Reloading = false
end




function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") or Reloading then return end
	if CurrentAmmo <= 0 and not Reloading then return Reload(d) end
	CurrentAmmo = CurrentAmmo - 1
	MissingAmmo = MaximumAmmo - CurrentAmmo
	AmmoEvent:FireClient(d.PLAYER, CurrentAmmo, MaximumAmmo)
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - Reduce - ((1.2 - Reduce) * d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceRebuilderPassive-item?id=461889122")
	if EquipRifle == true then
		d.PLAY_SOUND(d.HUMAN, 304523927, 0.5, 0.95)
	else
		d.PLAY_SOUND(d.HUMAN, 138083993, 0.5, 0.95)
	end
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.084
	if EquipRifle == true then
	damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.1 --So he wont be so broken and stuff	
	end
	
		
	local bullet = Instance.new("Part")
	local mesh = Instance.new("SpecialMesh")
		bullet.Anchored = false
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
	local width = 3
	local speed = 64
	local team = d.CHAR.Team.Value
	local function PickRandomEffect()
		local Values = {1, 2, 3}
		return Values[math.random(1, #Values)]
	end
	local function onHitExplode(enemy)
		if EquipRifle == true then
		d.DS.Damage:Invoke(enemy, damage * 0.75, "Toughness", d.PLAYER)	--Naturally weak anyway	
		else
		d.DS.Damage:Invoke(enemy, damage * 0.3, "Toughness", d.PLAYER)	--So aoe damage wont be broken
			end	
	end
	local Bullets = PickRandomEffect()
	local function onHit(p, enemy)	
		p.Moving = false
		if enemy.Parent.Name == "Turret" then
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)	
		else
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if randombullets == true then -- So turrets dont get affected :D
			if Bullets == 1 then
				if EquipRifle == true then
				d.ST.DOT:Invoke(enemy, damage * 0.75, 1, "Toughness", d.PLAYER, "Fire!")	
				else
				d.ST.DOT:Invoke(enemy, damage * 0.4, 1, "Toughness", d.PLAYER, "Fire!")	--No to brokenness 
					end	
			elseif Bullets == 2 then
				d.ST.MoveSpeed:Invoke(enemy, -.1, 1)	--seems balanced
	
			end
			
		end	
		end
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		bullet:Destroy()
	if Bullets == 3 and randombullets == true then	
		if EquipRifle == true then
			d.DS.AOE:Invoke(p.Position, 6, team, onHitExplode) --Radius increased so it wont bother.
		d.SFX.Explosion:Invoke(p.Position, 6, "Bright orange")
			else
		d.DS.AOE:Invoke(p.Position, 4, team, onHitExplode) --Radius decreased since 4 shells are fired.
		d.SFX.Explosion:Invoke(p.Position, 4, "Bright orange")
		end
	end
	end
	if EquipRifle == false then
	for i = 1, 4, 1 do
		local direction = (d.HRP.CFrame * CFrame.Angles(0, ((i / 4) * (math.pi / 7)), 0)).lookVector
		local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
		d.SFX.ProjPart:Invoke(p:ClientArgs(), bullet,  CFrame.Angles(math.pi / 2, 0, 0))
			d.SFX.ProjShrink:Invoke(p:ClientArgs(), 1, "Bright orange", 0.25)
	d.SFX.Explosion:Invoke(position, 2, "Neon orange")
	end
	else
		local direction = d.HRP.CFrame.lookVector
		local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
		d.SFX.ProjPart:Invoke(p:ClientArgs(), bullet,  CFrame.Angles(math.pi / 2, 0, 0))
		d.SFX.ProjShrink:Invoke(p:ClientArgs(), 1, "Bright orange", 0.25)
		d.SFX.Explosion:Invoke(position, 1, "Neon orange")
	end
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") or Reloading then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 22.5) 
	d.CONTROL.AbilityCooldown:Invoke("Q", 1)
	if d.CHAR.Shotgun.Transparency == 1 then
		d.CHAR.Rifle.Transparency = 1
	else
		d.CHAR.Shotgun.Transparency = 1
	end
	
	d.CHAR.Pillz.Transparency = 0
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceRebuilderAbility1-item?id=461284226")
	wait(0.3)
	
	local torestore = ability:C(data.percent)/100
	local duration = ability:C(data.duration)
	
	local missing = d.HUMAN.MaxHealth - d.HUMAN.Health
	local percentheal = missing * torestore
	
	
	d.ST.StatBuff:Invoke(d.HUMAN, "Shields", percentheal, duration)
	wait(0.1)
	if d.CHAR.Shotgun.Transparency == 1 and EquipRifle == true then
		d.CHAR.Rifle.Transparency = 0
	else
		d.CHAR.Shotgun.Transparency = 0
	end
	d.CHAR.Pillz.Transparency = 1
	
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") or Reloading then return end
	
	local duration = ability:C(data.duration)
	randombullets = true
	d.CONTROL.AbilityCooldown:Invoke("B", (duration + 10) - ((duration + 10) * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local bonus = ability:C(data.amount)
	
	ExtraSpeed = 0.1
	MaximumAmmo = MaximumAmmo + bonus
	CurrentAmmo = CurrentAmmo + bonus
	AmmoEvent:FireClient(d.PLAYER, CurrentAmmo, MaximumAmmo)
	
	delay(duration, function()
	ExtraSpeed = 0
	MaximumAmmo = MaximumAmmo - bonus
	CurrentAmmo = CurrentAmmo - bonus
	if CurrentAmmo < 0 then
		CurrentAmmo = 0
	elseif CurrentAmmo > MaximumAmmo then
		CurrentAmmo = MaximumAmmo
	end
	randombullets = false
	AmmoEvent:FireClient(d.PLAYER, CurrentAmmo, MaximumAmmo)
	end)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") or Reloading then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 17.5 - (17.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.CONTROL.AbilityCooldown:Invoke("Q", 2)	
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C("Medium stone grey")}, 0.15)
	local damage = ability:C(data.damage)
	local duration = 0.5
	local position = d.CHAR.GunBarrel.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 32
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
		
	if d.CHAR.Shotgun.Transparency == 1 then
		d.CHAR.Rifle.Transparency = 1
	else
		d.CHAR.Shotgun.Transparency = 1
	end
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceRebuilderAbility3-item?id=461300222")
	wait(0.35)
	if d.CHAR.Shotgun.Transparency == 1 and EquipRifle == true then
		d.CHAR.Rifle.Transparency = 0
	else
		d.CHAR.Shotgun.Transparency = 0
	end
	
	local function onHitExplode(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		
			
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
		if enemy.Parent or game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) and enemy.Parent.Name ~= "Turret" then
				local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
				if hrp then
					local position = hrp.Position
					local vector = (p.Position - position)
					local direction = vector.unit
					local distance = vector.magnitude
					direction = Vector3.new(direction.X, 0, direction.Z).unit
					local speed = distance / 0.25
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
	d.CONTROL.AbilityCooldown:Invoke("D", 60 - (60 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
		local bonus = ability:C(data.amount)
	local duration = ability:C(data.duration)
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C("Dark stone grey")}, 0.15)
	Reduce = 1.1
	EquipRifle = true
	d.CHAR.Shotgun.Transparency = 1
	d.CHAR.Rifle.Transparency = 0
	ExtraSpeed2 = 0.4
	MaximumAmmo = MaximumAmmo + bonus
	CurrentAmmo = CurrentAmmo + bonus
	wait(duration)
	ExtraSpeed2 = 0
	MaximumAmmo = MaximumAmmo - bonus
	CurrentAmmo = CurrentAmmo - bonus
	if CurrentAmmo < 0 then
		CurrentAmmo = 0
	elseif CurrentAmmo > MaximumAmmo then
		CurrentAmmo = MaximumAmmo
	end
	Reduce = 0
	EquipRifle = false
	d.CHAR.Shotgun.Transparency = 0
	d.CHAR.Rifle.Transparency = 1
	
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
			Base = 3.5,
			AbilityLevel = 0.5,
		},
	},
	B = {
		Name = "Extra Shells",
		Desc = "Sometimes,PlaceRebuilder being the excellent survivor does'nt bring up his title,He leaves his safehouse unprepared by picking up randomly imbued bullets. His shells temporarily turn into randomly imbued shells and he gains <amount> shells. Reload speed is increased by 10% for <duration> seconds. The cooldown of this move increases with the duration, but the total wait time stays the same. The effects are incendiary, slow and aoe.",
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
		Desc = "PlaceRebuilder throws a pipebomb that attracts these strange creatures he thinks are zombies, his pipebomb explodes after 0.5 seconds dealing <damage> to anyone in the area.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 7.5,
			Skillz = 0.3,
		},
	},
	D = {
		Name = "Equip Assault Rifle",
		Desc = "PlaceRebuilder equips his trusty Assault rifle, the Assault Rifle has a damage of 8% of Skillz, a duration of <duration>s and grants <amount> bonus ammo.",
		MaxLevel = 3,
		duration = {
			Base = 15,
			AbilityLevel = 5,
		},
		amount = {
			Base = 15,
			AbilityLevel = 5,
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