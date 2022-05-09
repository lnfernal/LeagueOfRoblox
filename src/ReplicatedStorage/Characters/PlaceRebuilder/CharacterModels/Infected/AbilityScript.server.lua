local shot = Instance.new("Part")
	local mesh = Instance.new("SpecialMesh")
		shot.Anchored = true
		shot.CanCollide = false
		shot.Size = Vector3.new(0.2, 0.2, 2.5)
		mesh.MeshId = "rbxassetid://220392363"
		mesh.TextureId = "rbxassetid://220392328"
		mesh.Scale = Vector3.new(1.2,1.2,1)
		mesh.Parent = shot

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2  - (1.2* d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceShoot-item?id=583728467")
	d.PLAY_SOUND(d.HUMAN, 99204505)
	wait(.15)
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.5
	local radiationburn = damage/2.67
	local bullet = shot:Clone()
	bullet.Parent = game.ReplicatedStorage
	d.DB(bullet)
	local position = d.CHAR.GunBarrel.Position
	local tagName = d.PLAYER.Name.."Radiation!"
	local range = 32
	local width = 3.5
	local speed = 64
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)	
		p.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)		
		if d.ST.GetEffect:Invoke(enemy, tagName) then
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then
		local function AOEHit(enemies)
			if not d.ST.GetEffect:Invoke(enemies, tagName) then	
			d.ST.Tag:Invoke(enemies, 5, tagName,true,Color3.new(85,255,0))
			d.ST.DOT:Invoke(enemies, radiationburn,3, 0, d.PLAYER, "Radiated!")
			elseif d.ST.GetEffect:Invoke(enemies, tagName) then
			d.DS.Damage:Invoke(enemies, radiationburn/3, 0, d.PLAYER)	
			end
			end
		d.DS.AOE:Invoke(hrp.Position, 14, team, AOEHit)
		d.SFX.Explosion:Invoke(hrp.Position, 14, "Bright green")
		end
		end
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		bullet:Destroy()
	end
	local direction = d.HRP.CFrame.lookVector		
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), bullet, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2, "White", 0.25,direction,"Plastic",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 10) 
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceLoad-item?id=583876406")
	local center = d.CHAR.GunBarrel.Position
	d.SFX.ReverseExplosion:Invoke(center, 4, "Bright green", 0.3)
	wait(.2)
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceShoot-item?id=583728467")
	d.PLAY_SOUND(d.HUMAN, 99204505)
	wait(.15)
	local damage = ability:C(data.damage)
	local radiationburn = ability:C(data.radiationdamage)
	local bullet = shot:Clone()
	bullet.Parent = game.ReplicatedStorage
	bullet.Mesh.VertexColor = Vector3.new(0,1,0)
	d.DB(bullet)
	local position = d.CHAR.GunBarrel.Position
	local tagName = d.PLAYER.Name.."Radiation!"
	local range = 48
	local width = 3.5
	local speed = 64
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)	
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)		
		if d.ST.GetEffect:Invoke(enemy, tagName) then
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then
		local function AOEHit(enemies)
			if not d.ST.GetEffect:Invoke(enemies, tagName) then	
			d.ST.Tag:Invoke(enemies, 5, tagName,true,Color3.new(85,255,0))
			d.ST.DOT:Invoke(enemies, radiationburn,3, 0, d.PLAYER, "Radiated!")
			elseif d.ST.GetEffect:Invoke(enemies, tagName) then
			d.DS.Damage:Invoke(enemies, radiationburn/3, 0, d.PLAYER)	
			end
			end
		d.DS.AOE:Invoke(hrp.Position, 14, team, AOEHit)
		d.SFX.Explosion:Invoke(hrp.Position, 14, "Bright green")
		
		end
		else
		d.ST.Tag:Invoke(enemy, 5, tagName,true,Color3.new(85,255,0))
		d.ST.DOT:Invoke(enemy, radiationburn,3, 0, d.PLAYER, "Radiated!")
		end
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		bullet:Destroy()
	end
	local direction = d.HRP.CFrame.lookVector		
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, false)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), bullet, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2, "Bright green", 0.25,direction,"Neon",0.039)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 15 - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceAdrenaline.aspx?id=583868742")
	d.CONTROL.AbilityCooldown:Invoke("Q", .6)
	d.CHAR.Crossbow.Transparency = 1
	d.CHAR.Adrenaline.Transparency = 0
	wait(.6)
	d.CHAR.Crossbow.Transparency = 0
	d.CHAR.Adrenaline.Transparency = 1
	local shields = ability:C(data.shields)/100 * d.HUMAN.MaxHealth
	d.ST.StatBuff:Invoke(d.HUMAN, "Shields", shields, 3)
	d.ST.MoveSpeed:Invoke(d.HUMAN, .25, 2)
	local sparkles = d.CHAR:FindFirstChild("Fire", true)
	
	
	sparkles.Enabled = true
	
	
	
	wait(1.5)
	sparkles.Enabled = false  
	local damage = ability:C(data.damage)
	local bullet = shot:Clone()
	bullet.Parent = game.ReplicatedStorage
	d.DB(bullet)
	local range = 45
	local width = 3.5
	local speed = 64
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)	
		p.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)		
		
	end
	local function onHitFinale(p, enemy)	
		local bleed = enemy.MaxHealth * 0.03
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		d.ST.DOT:Invoke(enemy, bleed,2, 0, d.PLAYER, "Bleeding!")		
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		bullet:Destroy()
	end
	for i = 1,3 do
	
	if i == 3 then
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceShoot-item?id=583728467")
	d.PLAY_SOUND(d.HUMAN, 99204505)
	wait(.1)
	local direction = d.HRP.CFrame.lookVector
	local position = d.CHAR.GunBarrel.Position
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHitFinale, onStep, onEnd, nil)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), bullet, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2, "Bright red", 0.25,direction,"Plastic",0.039)	
	else
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceShoot-item?id=583728467")
	d.PLAY_SOUND(d.HUMAN, 99204505)
	wait(.1)
	local direction = d.HRP.CFrame.lookVector
	local position = d.CHAR.GunBarrel.Position		
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), bullet, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2, "White", 0.25,direction,"Plastic",0.039)
	end
	wait()
	end
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.CONTROL.AbilityCooldown:Invoke("Q", 1)	
	math.randomseed(tick())
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C("Bright red")}, 0.15)
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/PlaceArrowRain.aspx?id=583903427")
	local tagName = d.PLAYER.Name.."Radiation!"
	local a = d.HRP.Position
	local range = 45
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	d.SFX.Artillery:Invoke(center, 8, "Bright red",.6)
	wait(.6)
	local radius = 12
	local team = d.CHAR.Team.Value
	
	local damage = ability:C(data.damage)
	local radata = d.ABILITY_DATA.A
	local radability = d.CONTROL.AbilityGetInfo:Invoke("A")
	local radiationburn = radability:C(radata.radiationdamage)
	local bullet = shot:Clone()
	bullet.Parent = game.ReplicatedStorage
	d.DB(bullet)
	local direction = Vector3.new(0, -1, 0)
	
	for i = 1,3 do
	local function onHit()
		
	end
	local function onStep()
		
	end
	local function onEnd(p)
	local function onHit(enemy)	
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)	
		
		if d.ST.GetEffect:Invoke(enemy, tagName) then
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then
		local function AOEHit(enemies)
			if not d.ST.GetEffect:Invoke(enemies, tagName) then	
			d.ST.Tag:Invoke(enemies, 5, tagName,true,Color3.new(85,255,0))
			d.ST.DOT:Invoke(enemies, radiationburn,2, 0, d.PLAYER, "Radiated!")
			elseif d.ST.GetEffect:Invoke(enemies, tagName) then
				
			end
			end
		d.DS.AOE2:Invoke(hrp.Position, 14, team, AOEHit)
		d.SFX.Explosion:Invoke(hrp.Position, 14, "Bright green")
		
		end
		end
	end
	d.DS.AOE:Invoke(p.Position, radius, team, onHit)
	d.SFX.Artillery:Invoke(p.Position, radius,  "Bright red")
	end
	local pos = center + Vector3.new(math.random(0,5),128,math.random(0,5))
	local p = d.DS.AddProjectile:Invoke(pos, direction, 256, 0, 256, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), bullet, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2, "Bright red", 0.25,direction,"Neon",0.039)	
	
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 35 - (35 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.Trail:Invoke(d.CHAR.Head, Vector3.new(0, -0.05, 0), 1, {BrickColor = d.C("White")}, 0.5, 1.1)
	d.SFX.Explosion:Invoke(d.CHAR.Head.Position, 16, "White")
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DogeSoScareFinal-item?id=263118210")
	wait(0.45)
	local tagName = d.PLAYER.Name.."Radiation!"
	local position = d.CHAR.Head.Position
	local direction = d.HRP.CFrame.lookVector
	local slow = -(ability:C(data.slow))/100
	local speed = 100
	local width = 5
	local range = 40
	local healOnce = false
	local team = d.CHAR.Team.Value
	
	local damage = ability:C(data.damage)
	local function onHit(projectile, enemy)
	d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)	
		d.ST.MoveSpeed:Invoke(enemy, slow, 2)
		if d.ST.GetEffect:Invoke(enemy, tagName) then	
				if not healOnce then
	   d.DS.Heal:Invoke(d.HUMAN, damage) 
	healOnce = true
	end
		end
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 2.5, "Pastel yellow", 0.5)	
	
end
script.Ability4.OnInvoke = ability4




local abilityData = {
	A = {
		Name = "Radioactive Waste",
		Desc = "[Innate] Whenever PlaceRebuilder lands his basic attack on radiation burned enemies, it causes a small explosion, spreading the radiation to nearby enemies around the radiation burned enemy. [Active] PlaceRebuilder gets lock'd and load for an incoming surprise, he fires an arrow with goo around it, making it look like a green projectile, which deals <damage> damage to enemies on impact. This marks ".."\"".."Radiation Burn".."\"".." to enemies which deals <radiationdamage> true damage for 3 seconds. The mark itself will last 5 seconds.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 5,
			Skillz = 0.2
		},
		radiationdamage = {
	
			Skillz = 0.1
		},
	},
	B = {
		Name = "Adrenaline Rush",
		Desc = "PlaceRebuilder takes an adrenaline rush that takes him into a new thrilling ride! He is shielded by <shields>% of his health for 3 seconds and gains 25% increased speed for 2 seconds. Afterwards he becomes hyped, he randomly shoots 3 quickarrows, dealing <damage> damage per shot to the first enemy it hits, the final arrow pierces through enemies and applies a bleed dealing 3% of enemies Max Health over 2 seconds.",
		MaxLevel = 5,
		shields = {
			Base = 6,
			AbilityLevel = 2,
		},
		damage = {
			Base = 10,
			AbilityLevel = 7.5,  
			Skillz = .2
		},
	},
	C = {
		Name = "Arrow Airstrike",
		Desc = "PlaceRebuilder fires a bunch of exploding arrows into the air then it rains down to the targeted location, dealing <damage> damage. Radiation burned enemies will cause an explosion which also spreads radiation to nearby enemies.",
		MaxLevel = 5,
		damage = {
			Base = 10,
			AbilityLevel = 5,
			Skillz = 0.175,
		
				
		}
	},
	D = {
		Name = "Owraghw!",
		Desc = "After being infected, PlaceRebuilder will always make sure the humans will never forget him. PlaceRebuilder shines his rotten teeth which fires a beam in a straight line that deals <damage> damage and slows them by <slows>% for 2 seconds. Hitting an enemy with Radiation will heal you <damage> health.",
		MaxLevel = 3,
		damage = {
			Base = 20,
			AbilityLevel = 5,
			Skillz = .35
		},
		slow = {
			Base = 25,
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