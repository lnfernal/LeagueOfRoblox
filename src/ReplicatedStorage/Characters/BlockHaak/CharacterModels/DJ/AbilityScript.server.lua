local Colors = {"Really red","Really blue","Teal"}
local DISC = Instance.new("Part")
DISC.Anchored = true
DISC.CanCollide = false
DISC.FormFactor = "Custom"
DISC.Size = Vector3.new(1, 0.2, 1)
DISC.BrickColor = BrickColor.new("Camo")
DISC.Material = "Neon"
Instance.new("CylinderMesh", DISC)
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 -(1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BlockBasicAttackFinal-item?id=261309405")
	d.PLAY_SOUND(d.HUMAN, 11900833)

	local position = d.CHAR.GunBarrel.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.4
	
	local part = DISC:clone()
	part.BrickColor = BrickColor.new(Colors[math.random(1, #Colors)])
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
	
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,Colors[math.random(1, #Colors)], 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local center = d.HRP.Position
	d.SFX.ReverseExplosion:Invoke(center, 6,Colors[math.random(1, #Colors)], 0.1)
	wait(0.15)
	local shots = ability:C(data.shots)
	local damage = ability:C(data.damage)
	local team = d.CHAR.Team.Value
	local dt = 1 / shots
	for shot = 1, shots do
		delay(dt * shot, function()
			d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BlockDiscLauncherFinal-item?id=261309803")
			d.PLAY_SOUND(d.HUMAN, 11900833, nil, 1.5)
		
			local position = d.CHAR.GunBarrel.Position
			local direction = d.HRP.CFrame.lookVector
			local speed = 80
			local width = 3.5
			local range = 35
			
			local part = DISC:clone()
			part.BrickColor = BrickColor.new(Colors[math.random(1, #Colors)])
			part.Parent = game.ReplicatedStorage
			d.DB(part)
			
			local function onHit(projectile, enemy)
				projectile.Moving = false
				d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
				if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
				local center = projectile.Position
				d.SFX.Explosion:Invoke(center, 2,Colors[math.random(1, #Colors)])
			end
			local function onStep(projectile)
			end
			local function onEnd(projectile)
				part:Destroy()
			end
			local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
			d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
			d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2,Colors[math.random(1, #Colors)], 0.25,direction,"Neon",0.039)
		end)
	end
end
script.Ability1.OnInvoke = ability1

local ability2Position = nil
function ability2NoPosition(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	d.CONTROL.AbilityCooldown:Invoke("B", 1)
local center = d.HRP.Position
	d.SFX.ReverseExplosion:Invoke(center, 6,Colors[math.random(1, #Colors)], 0.1)
    wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BlockGameJumping-Advancing-Final-item?id=261316243")
	d.PLAY_SOUND(d.HUMAN, 12222200)
	d.PLAY_SOUND(d.HUMAN, 130768080,0.5,1,10)
	
	local position = d.HRP.Position
	local b = d.MOUSE_POS
	local maxRange = 50
	local target = d.DS.Targeted:Invoke(position, maxRange, b)
	target = Vector3.new(target.X, position.Y, target.Z)
	local direction = (target - position).unit
	local speed = 64
	local width = 8
	local range = (target - position).magnitude
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local radius = 16
	local function onHit(projectile, enemy)
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		d.PLAY_SOUND(d.HUMAN, 12222084, nil, 2)
		local center = projectile.Position
		local function onHit(enemy)
			d.ST.MoveSpeed:Invoke(enemy, slow, 1.5)
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Explosion:Invoke(center, radius, Colors[math.random(1, #Colors)])

		ability2Position = position
		delay(3, function()
			if ability2Position then
				ability2Position = nil
				d.CONTROL.AbilityCooldown:Invoke("B", 16.5 -(14 * d.CONTROL.GetStat:Invoke("CooldownReduction"))) 
			end
		end)
		
		d.HRP.CFrame = projectile:CFrame()
	end
	local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjLeap:Invoke(p:ClientArgs(), d.HRP, 16)
end
function ability2WithPosition(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	d.CONTROL.AbilityCooldown:Invoke("B", 16.5 - (16.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BlockGameJumping-Retreating-Final-item?id=261316330")
	d.PLAY_SOUND(d.HUMAN, 12222200)
	
	local position = d.HRP.Position
	local b = ability2Position
	local target = b
	target = Vector3.new(target.X, position.Y, target.Z)
	local direction = (target - position).unit
	local speed = 72
	local width = 8
	local range = (target - position).magnitude
	local team = d.CHAR.Team.Value
	local function onHit(projectile, enemy)
	end
	local function onStep(projectile)
		local pos = projectile.Position
		local dir = projectile.Direction
		d.HRP.CFrame = CFrame.new(pos, pos + dir) + d.JUMP_HEIGHT(range, 16, projectile.Distance)
	end
	local function onEnd(projectile)
	end
	local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	
	ability2Position = nil	
end
function ability2(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	
	if ability2Position then
		ability2WithPosition(d)
	else
		ability2NoPosition(d)
	end
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 9 - (9 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/BlockIntimidateFinal-item?id=261324497")
	wait(0.5)
	
	local range = 16
	local width = 8
	local team = d.CHAR.Team.Value
	local duration = ability:C(data.duration)
	local function onHit(enemy)
		d.ST.Stun:Invoke(enemy, duration)
	end
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	d.SFX.Line:Invoke(d.CHAR.Head.Position, d.HRP.CFrame.lookVector, range, width, Colors[math.random(1, #Colors)])
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", ability:C(data.cooldown) - (ability:C(data.cooldown) * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	if ability:C(data.cooldown) - (ability:C(data.cooldown) * d.CONTROL.GetStat:Invoke("CooldownReduction")) < (30 - (30 * d.CONTROL.GetStat:Invoke("CooldownReduction"))) then
		d.CONTROL.AbilityCooldown:Invoke("D", 30 - (30 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	end

	local boost = ability:C(data.boost)
	d.CONTROL.PermBuff:Invoke("Skillz", boost)
	d.SFX.Artillery:Invoke(d.HRP.Position, d.CONTROL.GetStat:Invoke("Skillz") * 0.1, Colors[math.random(1, #Colors)])
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Disc Launcher",
		Desc = "BlockHaak rapidly fires discs from his disc launcher, firing <shots> shots, each doing <damage> damage to the first enemy they hit.",
		MaxLevel = 7,
		shots = {
			Base = 5,
			AbilityLevel = 1
		},
		damage = {
			Base = 12.5,
			AbilityLevel = 3,
			Skillz = 0.06,
		},
	},
	B = {
		Name = "Game Jumping",
		Desc = "BlockHaak leaps to a target location, dealing <damage> damage and slowing <slow>% for 1.5 seconds enemies hit. For the next three seconds, he can reactivate this ability to return to his original location.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 10,
			Skillz = 0.3,
		},
		slow = {
			Base = 10,
			AbilityLevel = 5
		}
	},
	C = {
		Name = "Intimidate",
		Desc = "BlockHaak stares down his enemies, causing them to become stunned for <duration> seconds.",
		MaxLevel = 5,
		duration = {
			Base = 0.75,
			AbilityLevel = 0.1
		}
	},
	D = {
		Name = "The Beard",
		Desc = "BlockHaak grows his beard out a little bit, permanently increasing his Skillz by <boost>. The cooldown is decreased by 1.5 per kill (30 second cap).", -- Removed "and increased by 1.5 per death"
		MaxLevel = 1,
		boost = {
			Base = 2
		},
		cooldown = {
			Base = 45,
			Kills = -1.5,
			
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 120 + level * 10
	end,
	Skillz = function(level)
		return 5 + level * 0.85
	end,
	Toughness = function(level)
		return 5 + level * 0.6
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
local CONTROL = script.Parent.Parent.Character:WaitForChild("CharacterScript")
CONTROL:WaitForChild("LeveledUp")
local SFX = game.ServerScriptService.SFXService
local HRP = script.Parent.Parent.Character:WaitForChild("HumanoidRootPart")
local PLAY_SOUND = require(game.ServerStorage.PlayMusic)
script.Parent.Parent.Character:WaitForChild("Effect")
CONTROL.LeveledUp.Event:connect(function(Level)
SFX.Artillery:Invoke(HRP.Position, 8, Colors[math.random(1, #Colors)])
script.Parent.Parent.Character.Effect.BrickColor = BrickColor.new(Colors[math.random(1, #Colors)])
if Level % 5 == 0 then
script.Parent.Parent.Character.Head.face.Texture = "http://www.roblox.com/asset/?id=272176568"
local Music = {{525721279,294},{535243341,260}}
local MusictoPlay = Music[math.random(1,#Music)]
PLAY_SOUND(HRP.Parent.Humanoid,MusictoPlay[1] , 0.3, 1,MusictoPlay[2])
script.Parent.Parent.Character.Beatbox.Transparency = 0
end
end)

--test