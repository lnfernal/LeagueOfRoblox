
local fireColors = {"Bright red", "Neon orange", "Bright yellow"}
function fireColor()
	return fireColors[math.random(1, #fireColors)]
end

function fireEffect(effect, position, radius)
	for index = 1, 3 do
		effect:Invoke(position, radius * (1 / index), fireColors[index])
	end
end
local basicCooldown = 1.125
local basicCDR = 0
local basicBrutal = false
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", basicCooldown - (basicCooldown * basicCDR) - (basicCooldown * d.CONTROL.GetStat:Invoke("BasicCDR")/2))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NightBasicAttackFinal-item?id=263062940")
	d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	wait(0.2)
	if basicBrutal then
		local data = d.ABILITY_DATA.D
		local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	
	end
	
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .4
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		
		
		if basicBrutal then
			d.ST.MoveSpeed:Invoke(enemy, -.15, 1)
			
		end
	end
	d.DS.Melee:Invoke(hrp, team, onHit,10,6)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12.5 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
local center = d.HRP.Position
	d.SFX.ReverseExplosion:Invoke(center, 6,"Bright red", 0.15)
    wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NightAdvanceFinal-item?id=263063203")
	d.PLAY_SOUND(d.HUMAN, 12222200)
	
	local position = d.HRP.Position
	local b = d.MOUSE_POS
	local maxRange = 48
	local target = d.DS.Targeted:Invoke(position, maxRange, b)
	target = Vector3.new(target.X, position.Y, target.Z)
	local direction = (target - position).unit
	local speed = 100
	local width = 8
	local range = (target - position).magnitude
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local radius = 18
	local function onHit(projectile, enemy)
	end
	local function onStep(projectile)
	end
	local function onEnd(projectile)
		d.HRP.CFrame = projectile:CFrame()
		
		d.PLAY_SOUND(d.HUMAN, 12222084, nil, 2)
		local center = d.HRP.Position
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.Explosion:Invoke(center, radius, "Bright red")
	end
	local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjLeap:Invoke(p:ClientArgs(), d.HRP, 32)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12.5 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	local fire = d.CHAR:FindFirstChild("AssaultFire", true)
	
	d.PLAY_SOUND(d.HUMAN, 12221944, nil, 2)
	
	d.SFX.Artillery:Invoke(fire.Parent.Position, 4, "Bright blue")
	local circles = 0
	local topos = fire.Parent.Position
	local dir = fire.Parent.Rotation
	local cdr = ability:C(data.percent) / 100
	local dur = ability:C(data.duration)
	 d.SFX.Circles:Invoke(topos, 6, fireColor(),.2,dir)
	d.ST.MoveSpeed:Invoke(d.HUMAN, .2, dur)
	basicCDR = cdr
	fire.Enabled = true
	wait(dur)
	basicCDR = 0
	fire.Enabled = false
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12)

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/NightBattlecryFinal-item?id=263063477")
	d.PLAY_SOUND(d.HUMAN, 12222253)
	wait(0.15)
	local center = d.HRP.Position
	local radius = 18
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local heal = ability:C(data.heal)
	local hits = 0
	local function onHit(enemy)
		
			d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
				
				if hits < 4 then
			d.DS.Heal:Invoke(d.HUMAN, heal) 
		hits = hits + 1
		
		
		end 
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Explosion:Invoke(center, radius, "White")
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 35 - (27.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	basicBrutal = true
	d.CHAR:FindFirstChild("BrutalFire", true).Enabled = true
	local duration = ability:C(data.duration)
	local buff = d.CONTROL.GetStat:Invoke("Skillz") * .2
	d.ST.StatBuff:Invoke(d.HUMAN, "Skillz", buff, duration)
	wait(duration)
	
	basicBrutal = false
	d.CHAR:FindFirstChild("BrutalFire", true).Enabled = false
	
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Advance",
		Desc = "Nightgaladeld leaps to a target location and deals <damage> damage to nearby enemies when he lands. If he kills an enemy champion, the move's cooldown will be reset.",
		MaxLevel = 5,
		damage = {
			Base = 22.5,
			AbilityLevel = 7.5,
			Skillz = 0.25,
		},
	},
	B = {
		Name = "Assault",
		Desc = "Nightgaladeld gains 20% increased movement speed and reduces his basic attack cooldown by <percent>% for <duration> seconds.",
		MaxLevel = 5,
		percent = {
			Base = 20,
			AbilityLevel = 2,
		},
		duration = {
			Base = 5,
		},
	},
C = {
		Name = "Battlecry",
		Desc = "Nightgaladeld releases a patriotic battlecry, dealing <damage> damage to nearby enemies as well as healing himself <heal> health per enemy hit up to a max of 4.",
		MaxLevel = 5,
		damage = {
			Base = 25,
			AbilityLevel = 5,
			Skillz = 0.3,
		},
		heal = {
			
			Health = .04,
		},
	},
	D = {
		Name = "Brutality",
		Desc = "Nightgaladeld empowers his basic attacks and increasing his Skillz by 20% for <duration> seconds, granting him a 15% slow for 1.5 seconds.",
		MaxLevel = 3,
		slow = {
			Base = 15,
		},
		duration = {
			Base = 3,
			AbilityLevel = 1,
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 155 + level * 10
	end,
	Skillz = function(level)
		return 5 + level * 2
	end,
	Toughness = function(level)
		return 5 + level
	end,
	Resistance = function(level)
		return 5 + 0.25 * level
	end,
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test