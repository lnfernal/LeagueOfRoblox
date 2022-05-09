local upgrade = false
local enemiesBinded = {}
local notbase = 0
local baseregen = 0

function setenemiesBinded(enemy)
	table.insert(enemiesBinded, enemy)
end
function setenemiesNotBinded(enemy)
	for index, enemiesBinded2 in pairs(enemiesBinded) do
		if enemiesBinded2 == enemy then
			table.remove(enemiesBinded, index)
			break
		end
	end
end




function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 -(1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/GuestBasicFinal-item?id=260609436")
	d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	
	wait(.05)
	
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
local function s()
	return -0.2 + math.random() * 0.2
end
function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 10  - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local center = d.HRP.Position
		d.SFX.ReverseExplosion:Invoke(center,6,d.CHAR.Torso.Skills.Value.Color, 0.2)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ChiefStompofJustusFinal-item?id=260348188")
	wait(.45)
	local centers = d.HRP.Position
	local radius = 14
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	if upgrade ~= false then
		d.CONTROL.AbilityCooldownLag:Invoke("B", 2)
		d.CONTROL.AbilityCooldownLag:Invoke("C", 2)
		upgrade = false
		d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 32, {BrickColor = BrickColor.new(d.CHAR.Torso.Skills.Value.Color)}, 0.45)
	local function spread(center)
		
	local function onHit(enemy)
		if d.IN(enemy, enemiesBinded) then return end
			
			local fire = setenemiesBinded(enemy)
			delay(1.7, function()
				setenemiesNotBinded(enemy)
			end)
		if enemy.Parent then
				local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
				if hrp then
					delay(0.5, function()
						spread(hrp.Position)
					end)
				end
			end
		d.ST.Stun:Invoke(enemy, duration)
		d.ST.DOT:Invoke(enemy, damage, 2.5, "Resistance", d.PLAYER, "Binded!")
		
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Shockwave:Invoke(d.FLAT(center), radius, d.CHAR.Torso.Skills.Value.Color)
	end
	spread(d.HRP.Position)
	else
	local function onHit(enemy)
		d.ST.Stun:Invoke(enemy, duration)
		d.ST.DOT:Invoke(enemy, damage, 2.5, "Resistance", d.PLAYER, "Binded!")
	end
	d.DS.AOE:Invoke(centers, radius, team, onHit)
	d.SFX.Shockwave:Invoke(d.FLAT(centers), radius, d.CHAR.Torso.Skills.Value.Color)	
		end
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 8.5  - (8.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local speed = 56
	d.CHAR.Bow.Transparency = 0
	local width = 3.5
	local range = 44
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local position
	local direction
	local part = game.ReplicatedStorage.Items.MagicalArrow:Clone()
	part.BrickColor = d.CHAR.Torso.Skills.Value
	part.Parent = game.ReplicatedStorage
	
	if upgrade ~= false then
		upgrade = false
		d.CONTROL.AbilityCooldownLag:Invoke("A", 2)
		d.CONTROL.AbilityCooldownLag:Invoke("C", 2)
		local tofire = 2
	
	local function onHit(p, enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
	
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		local center = p.Position - Vector3.new(0,2,0)
		local radius = 16
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage * 0.5, 0, d.PLAYER)
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Explosion:Invoke(center, radius, d.CHAR.Torso.Skills.Value.Color)
		part:Destroy()
	end
	repeat
	
	d.DB(part)
	position = d.CHAR["Right Arm"].Position
	direction = d.HRP.CFrame.lookVector
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,d.CHAR.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new(), 
		
		{
	Spin = CFrame.Angles(0, 0, s())})
	tofire = tofire - 1
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/SorcusArrowofRedcliffFinal-item?id=261293949")
		d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 32, {BrickColor = BrickColor.new(d.CHAR.Torso.Skills.Value.Color)}, 0.45)
	wait(0.55)
	until tofire == 0
	tofire = 2
	d.CHAR.Bow.Transparency = 1
	else
		local part = game.ReplicatedStorage.Items.MagicalArrow:Clone()
		part.BrickColor = d.CHAR.Torso.Skills.Value
	part.Parent = game.ReplicatedStorage
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/SorcusArrowofRedcliffFinal-item?id=261293949")
	local function onHit(projectile, enemy)
		
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		part:Destroy()
	end
	wait(.55)
	local position = d.CHAR["Right Arm"].Position
	local direction = d.HRP.CFrame.lookVector
	
	d.DB(part)
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,d.CHAR.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new(), 
		
		{
		
	Spin = CFrame.Angles(0, 0, s())})
	d.CHAR.Bow.Transparency = 1
	end
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 10  - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ObliviousSelf-ReplicatingCodeFinal-item?id=507998407")--dont mind the name its actually another anim
	if upgrade ~= false then
	upgrade = false
		d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 4, 32, {BrickColor = BrickColor.new(d.CHAR.Torso.Skills.Value.Color)}, 0.45)
		d.ST.MoveSpeed:Invoke(d.HUMAN, ability:C(data.slow)/100, 2.5)
	
		d.CONTROL.AbilityCooldownLag:Invoke("A", 2)
		d.CONTROL.AbilityCooldownLag:Invoke("B", 2)
		local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 28 * 4
	local width = 6
	local range = 22
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local function onHit(p, enemy)
		
	end 
	local function onStep(projectile)
		topos = projectile.Position 
	 
	
	
	end
	local function onEnd(projectile)
		d.HRP.CFrame = projectile:CFrame()
	for i = 1,5,0.5 do
	d.CHAR.Enchantment.Transparency = 1 - i/10	
	
	
	wait(0.01)
	end 		
	
	
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	

	local range = 16
	local width = 6
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage/1.5, "Resistance", d.PLAYER)
		d.ST.MoveSpeed:Invoke(enemy, slow/3, 1)
	end
	for i = 1, 3 do
		wait(0.1)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/GuestBasicFinal-item?id=260609436")
	d.PLAY_SOUND(d.HUMAN, 84937942, nil, 0.9)
	local direction = d.HRP.CFrame.lookVector
	local position = d.HRP.Position
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	d.SFX.Line:Invoke(position, direction, range, width, d.CHAR.Torso.Skills.Value.Color)

	end
	
	wait(0.3)
	
	d.CHAR.Enchantment.Transparency = 1
	end
	local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, nil, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
	repeat
		wait(.1)
		d.SFX.Circles:Invoke(topos, 6,d.CHAR.Torso.Skills.Value.Color,.2,dir) 
		circles = circles + 1
	until	circles == 3
	else
	
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 28 * 4
	local width = 6
	local range = 22
	local function onHit(p, enemy)
		
	end 
	local function onStep(projectile)
		topos = projectile.Position 
	 
	
	
	end
	local function onEnd(projectile)
		d.HRP.CFrame = projectile:CFrame()
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/GuestBasicFinal-item?id=260609436")
	d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	for i = 1,5,0.5 do
	d.CHAR.Enchantment.Transparency = 1 - i/10	
	wait(0.01)
	end
		local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local direction = d.HRP.CFrame.lookVector
	local position = d.HRP.Position

	local range = 12
	local width = 5
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		if enemy.Parent.Name == "Turret" then
			else
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		d.ST.MoveSpeed:Invoke(enemy, slow, 1.5)
		end
	end
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	d.SFX.Line:Invoke(position, direction, range, width, d.CHAR.Torso.Skills.Value.Color)
	wait(0.2)
	d.CHAR.Enchantment.Transparency = 1
	end
	local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, nil, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
	repeat
		wait(.1)
		d.SFX.Circles:Invoke(topos, 6,d.CHAR.Torso.Skills.Value.Color,.2,dir) 
		circles = circles + 1
	until	circles == 3
	end
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D",ability:C(data.cooldown)  - (ability:C(data.cooldown) * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	upgrade = true
	d.SFX.Trail:Invoke(d.HRP, Vector3.new(), 1, {BrickColor = d.C(d.CHAR.Torso.Skills.Value.Color)}, 0.5, 5)
	d.SFX.Shockwave:Invoke(d.HRP.Position, 8, d.CHAR.Torso.Skills.Value.Color)
	wait(5)
	upgrade = false
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Bind",
		Desc = "Davidscookies Binds his target for <duration> seconds and deals <damage> damage over 2.5 seconds. If The Gamer mode is on, once bind is hit, bind will spread among nearby enemies applying the same effects and damages to everyone nearby.",
		MaxLevel = 5,
		damage = {
			Base = 25,
			AbilityLevel = 7.5,
			H4x = 0.25
		},
		duration = {
			Base = 0.5,
			AbilityLevel = 0.1,
			
		}
	},
	B = {
		Name = "Magical Arrow",
		Desc = "Davidscookies shoots a piercing arrow made from magic that pierces dealing <damage> damage and travels up to 44 studs. If The Gamer mode is on, Davidscookies fires 2 arrows that explode on contact dealing <damage> damage.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 12.5,
			H4x = 0.3
		}
	},
	C = {
		Name = "Magic Strike",
		Desc = "Davidscookies coats his arm with magic and strikes his target with a powerful force dealing <damage> damage and slows by <slow>% for 1.5 seconds. If The Gamer mode is on, Davidscookies gains <slow>% movement speed for 2.5 and he strikes his target 3 times dealing <damage>/1.5 damage and slows them down by <slow>/3 for 1 second.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 10,
			H4x = 0.35
		},
		slow = {
			Base = 30,
			AbilityLevel = 2,
		}
	},
	D = {
		Name = "The Gamer",
		Desc = "Davidscookies focuses and obtains a state of mind where he can focus on whatever circumstance he is in granting him bonus <BonusH4x> H4x, <health> health, <regen> regen. These values are estimated to the nearest value. If the ability is toggled, He has the choice to upgrade on of his abilities for 5 secconds.",
		MaxLevel = 3,
		BonusH4x = {
			H4x = 0.1		--Immo these are values to help the players, the real values are on top
		},
		health = {
			Health = 0.1
		},
		regen = {
			HealthRegen = 0.2
		},
		cooldown = {
			Base = 40,
			AbilityLevel = -5
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
local Stats = require(game.ReplicatedStorage.PlayerStats:WaitForChild(script.Parent.Parent.Character.Name))

--Estimating
function numberRound(number)
local High = math.ceil(number) - number
if High >= .5 then
return math.floor(number)
else
return math.ceil(number)
end
end
--/Estimate
--Passive
function loop()
	
	local CHAR = script.Parent.Parent.Character
	local PS = game.ServerScriptService.PassiveService
	local HUMAN = script.Parent.Parent.Character.Humanoid
	local Bonus = numberRound(Stats.StatsGet("H4x") * 0.1) --here
	local regen = numberRound(Stats.StatsGet("HealthRegen") * 0.2) --there
	local health = numberRound(Stats.StatsGet("Health") * 0.1) --here
	if CHAR:FindFirstChild("Passives") and CHAR:FindFirstChild("Passives"):FindFirstChild("H4XBONUS") then
	for i,buffs in pairs(CHAR:FindFirstChild("Passives"):GetChildren()) do
		if buffs.Name == "H4XBONUS" and buffs.Amount.Value ~= Bonus then
			notbase = 0
			if #CHAR:FindFirstChild("Statuses"):GetChildren() ~= 0 then
			for i,stats in pairs(CHAR:FindFirstChild("Statuses"):GetChildren()) do
			if CHAR:FindFirstChild("Statuses") and stats:FindFirstChild("Stat") and stats:FindFirstChild("Stat").Value =="H4x" then
			notbase = notbase + numberRound(stats.Amount.Value)
			end
			end
			end
			Bonus = numberRound((Stats.StatsGet("H4x") - notbase) * 0.2) --one here
			buffs.Amount.Value = Bonus --So stat buffing wont be op
		elseif buffs.Name == "REGENBONUS" and buffs.Amount.Value ~= regen then
			baseregen = 0
			if #CHAR:FindFirstChild("Statuses"):GetChildren() ~= 0 then
			for i,stats in pairs(CHAR:FindFirstChild("Statuses"):GetChildren()) do
			if CHAR:FindFirstChild("Statuses") and stats:FindFirstChild("Stat") and stats:FindFirstChild("Stat").Value =="HealthRegen" then
			baseregen = baseregen + numberRound(stats.Amount.Value)
			end
			end
			end
			regen = numberRound((Stats.StatsGet("HealthRegen") - baseregen) * 0.2) --one here
			buffs.Amount.Value = regen
		elseif buffs.Name == "HEALTHBONUS" and buffs.Amount.Value ~= health then
			buffs.Amount.Value = health
		end
	end	
	end
end
game:GetService("RunService").Heartbeat:connect(loop)

script.UnlockUltimate.Event:connect(function()
	local CONTROL = script.Parent.Parent.Character:WaitForChild("CharacterScript")
	local CHAR = script.Parent.Parent.Character
	local PS = game.ServerScriptService.PassiveService
	local HUMAN = script.Parent.Parent.Character.Humanoid
	local Bonus = numberRound(Stats.StatsGet("H4x") * 0.1) --another
	local regen = numberRound(Stats.StatsGet("HealthRegen") * 0.2) --another
	local health = numberRound(Stats.StatsGet("Health") * 0.1) --another
	if CHAR:FindFirstChild("Passives") and CHAR:FindFirstChild("Passives"):FindFirstChild("H4XBONUS") then
	for i,buffs in pairs(CHAR:FindFirstChild("Passives"):GetChildren()) do
		if buffs.Name == "H4XBONUS" and buffs.Amount.Value ~= Bonus then
			notbase = 0
			buffs.Amount.Value = Bonus
			if #CHAR:FindFirstChild("Statuses"):GetChildren() ~= 0 then
			for i,stats in pairs(CHAR:FindFirstChild("Statuses"):GetChildren()) do
			if CHAR:FindFirstChild("Statuses") and stats:FindFirstChild("Stat") and stats:FindFirstChild("Stat").Value =="H4x" then
			notbase = notbase + numberRound(stats.Amount.Value)
			end
			end
			Bonus = numberRound((Stats.StatsGet("H4x") - notbase) * 0.1) --one here
			buffs.Amount.Value = Bonus --So stat buffing wont be op
			end
		elseif buffs.Name == "REGENBONUS" and buffs.Amount.Value ~= regen then
				baseregen = 0
			if #CHAR:FindFirstChild("Statuses"):GetChildren() ~= 0 then
			for i,stats in pairs(CHAR:FindFirstChild("Statuses"):GetChildren()) do
			if CHAR:FindFirstChild("Statuses") and stats:FindFirstChild("Stat") and stats:FindFirstChild("Stat").Value =="HealthRegen" then
			baseregen = baseregen + numberRound(stats.Amount.Value)
			end
			end
			end
			regen = numberRound((Stats.StatsGet("HealthRegen") - baseregen) * 0.2) --one here
			buffs.Amount.Value = regen
		elseif buffs.Name == "HEALTHBONUS" and buffs.Amount.Value ~= health then
			buffs.Amount.Value = health
		end
	end	
	else
	PS.StatBuff:Invoke(HUMAN, "H4x", Bonus, "H4XBONUS")
	PS.StatBuff:Invoke(HUMAN, "HealthRegen", regen, "REGENBONUS")
	PS.StatBuff:Invoke(HUMAN, "Health", health, "HEALTHBONUS")
	end
end)


local backpack = script.Parent
local controlScript = backpack:WaitForChild("ControlScript")

	local data = controlScript.GetData:Invoke()
	local color = data.CHAR.Torso:WaitForChild("Skills")
	data.CHAR.Enchantment.BrickColor = color.Value