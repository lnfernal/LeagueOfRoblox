local LOCK = true
math.randomseed(os.time())
local random = math.random
local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end
function chance() 
	local x = random(1,100)
	
	if x <= 14 then
		return true
	else
		return false
	end
end

local allEnemiesHit = {}
local function check(enemy)
for i,v in pairs(allEnemiesHit) do
		if v[1] == enemy then
		return true
		end
end
return false
end
script.UnlockFirst.Event:connect(function()
	LOCK = false
end)
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ObliviousBasicAttackFinal-item?id=263090208")
	d.PLAY_SOUND(d.HUMAN, 130113322, 0.25, 0.8)

	local position = d.CHAR.Orb.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 80
	local width = 3.5
	local range = 32
	local team = d.CHAR.Team.Value
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
	end
	local function onStep(projectile, dt)
	end
	local function onEnd(projectile) 
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjZap:Invoke(p:ClientArgs(), 0.5, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.1)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 8 - (8 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
    d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skills.Value.Color)}, 0.1)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ObliviousSelf-ReplicatingCodeFinal-item?id=263090611")
	d.PLAY_SOUND(d.HUMAN, 130113322, 0.25, 0.6)
wait(0.15)
	local enemiesHit = {}
	local team = d.CHAR.Team.Value
	local tem = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local damage = ability:C(data.damage)
	
	local function projectile(position, direction)
		local speed = 60
		local width = 3.5
		local range = 48
		local function onHit(p, enemy)
			if d.IN(enemy, enemiesHit) then return end
			table.insert(enemiesHit, enemy)
			
			p.Moving = false
			
			if enemy.Parent then
				local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
				if hrp then
					local s = Instance.new("Sparkles", hrp)
					s.Color = Color3.new(0, 0, 1)
					
					d.SFX.Trail:Invoke(hrp, Vector3.new(), 1, {BrickColor = d.C("Bright blue")}, 0.5, 3)
					delay(0.75, function()
						s:Destroy() 
						d.PLAY_SOUND(enemy, 130113322, 0.25, 0.6)
						projectile(hrp.Position, hrp.CFrame.lookVector)
					end)
				end
			end
			
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		end
		local function onStep(p, enemy)
		end
		local function onEnd(p)
		end
		local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
		d.SFX.ProjZap:Invoke(p:ClientArgs(), 1, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.1)
		d.SFX.ProjTrail:Invoke(p:ClientArgs(), .2, script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25,direction,"Neon",0.039)
	end
	
	projectile(d.CHAR.Orb.Position, d.HRP.CFrame.lookVector)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 7 - (7 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local range = 40
	local width = 4
	local color = script.Parent.Parent.Character.Torso.Skills.Value.Color
	d.SFX.Line:Invoke(d.CHAR.Glasses.Position, d.HRP.CFrame.lookVector, range, 0.5, script.Parent.Parent.Character.Torso.Skills.Value.Color)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ObliviousSyntacticSightFinal-item?id=263090973")
	local function projectile(hrp,pos,char)
	wait(0.5)
	d.PLAY_SOUND(d.HUMAN, 84937942, nil, 0.9)

	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		if check(enemy) == true or LOCK == true or chance() == false then return end
			local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
			if hrp then
			local uuid = uuid()
			table.insert(allEnemiesHit, {enemy,uuid})
			delay(0.01,function()			
			projectile(hrp,hrp.Position,enemy.Parent)
			end)
			delay(3,function()
				for i,v in pairs(allEnemiesHit) do
					if v[2] == uuid then
						table.remove(allEnemiesHit,i)
					end
				end
			end)
			end	
	end
	d.SFX.Line:Invoke(char.Head.Position, hrp.CFrame.lookVector, range, width, color)
	d.DS.Line:Invoke(hrp, range, width, team, onHit,false,hrp.CFrame.lookVector)
	end
	projectile(d.HRP,d.HRP.Position,d.CHAR)
end
script.Ability2.OnInvoke = ability2


function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 9 - (9 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	local speed = 45
	local width = 3.5
	local range = 44
	local color = script.Parent.Parent.Character.Torso.Skills.Value.Color
	local damage = ability:C(data.damage)
	local team = d.CHAR.Team.Value
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ObliviousCompressionAlgorithmFinal-item?id=263091170")
	
	local function projectile(hrp,pos,char)
	d.PLAY_SOUND(char.Humanoid, 130113322, 0.25, 0.5)
	local position = char["Right Arm"].Position
	local direction = hrp.CFrame.lookVector
	
	
	
	local function onHit(projectile, enemy)
		projectile.Moving = false
	end
	local function onStep(p)
	end
	local function onEnd(p)
		local center = p.Position
		local radius = 10
		local function onHit(enemy)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
			if enemy.Parent then
				local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
				if hrp then
					local position = hrp.Position
					local vector = (p.Position - position)
					local direction = vector.unit
					local distance = vector.magnitude
					direction = Vector3.new(direction.X, 0, direction.Z).unit
					local speed = distance / 0.2
					local width = 3.5
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
		if check(enemy) == true or LOCK == true or chance() == false then return end
			local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
			if hrp then
			local uuid = uuid()
			table.insert(allEnemiesHit, {enemy,uuid})
			delay(0.01,function()			
			projectile(hrp,hrp.Position,enemy.Parent)
			end)
			delay(3,function()
				for i,v in pairs(allEnemiesHit) do
					if v[2] == uuid then
						table.remove(allEnemiesHit,i)
					end
				end
			end)
			end
		end
		d.DS.AOE:Invoke(center, radius, team, onHit)
		d.SFX.ReverseExplosion:Invoke(center, radius, color)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjZap:Invoke(p:ClientArgs(), 1.25, color, 0.25)
	end
projectile(d.HRP,d.HRP.Position,d.CHAR)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 8 - (8 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ObliviousDataSweepFinal-item?id=263091493")
	
	d.CONTROL.AbilityCooldownLag:Invoke("Q", 1)
	d.CONTROL.AbilityCooldownLag:Invoke("A", 1)
	d.CONTROL.AbilityCooldownLag:Invoke("B", 1)
	d.CONTROL.AbilityCooldownLag:Invoke("C", 1)
	
	
	local range = 48
	local b = d.MOUSE_POS
	local color = script.Parent.Parent.Character.Torso.Skills.Value.Color
	local radius = 10
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local function projectile(hrp,pos,char)
		d.PLAY_SOUND(char.Humanoid, 84937942, nil, 1.2)

	local center = d.DS.Targeted:Invoke(pos, range, b)
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		if check(enemy) == true or LOCK == true or chance() == false then return end
			local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
			if hrp then
			local uuid = uuid()
			table.insert(allEnemiesHit, {enemy,uuid})
			delay(0.01,function()			
			projectile(hrp,hrp.Position,enemy.Parent)
			end)
			delay(3,function()
				for i,v in pairs(allEnemiesHit) do
					if v[2] == uuid then
						table.remove(allEnemiesHit,i)
					end
				end
			end)
			end
	end
	d.SFX.Artillery:Invoke(center, 2, color, 0.6)
	wait(0.6)
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Artillery:Invoke(center, radius, color)
	end
	projectile(d.HRP,d.HRP.Position,d.CHAR)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Self-replicating Code",
		Desc = "[Innate] All skills have a chance to replicate towards the enemy but they could not be infected twice. ObliviousPanther fires a code bolt which deals <damage> damage to the first target it hits, and then infects that target. Afterwards, the target replicates this spell. A target cannot be affected twice by this.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 5,
			H4x = 0.4,
		}
	},
	B = {
		Name = "Syntactic Sight",
		Desc = "ObliviousPanther damages enemies in a line in front of him for <damage> damage.", 
		MaxLevel = 5,
		damage = {
			Base = 22.5,
			AbilityLevel = 6,
			H4x = 0.35,
		},
	},
	C = {
		Name = "Compression Algorithm",
		Desc = "ObliviousPanther fires a bolt which, upon reaching the end of its range or hitting an enemy, deals <damage> damage to targets in an area and draws them to it.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 5,
			H4x = 0.3,
		},
	},
	D = {
		Name = "Data Sweep",
		Desc = "ObliviousPanther deals <damage> damage in an area at the targeted location. This ability has a short cooldown.",
		MaxLevel = 3,
		damage = {
			Base = 25,
			AbilityLevel = 5.5,
			H4x = 0.35,
		},
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 120 + level * 12.5
	end,
	H4x = function(level)
		return 10 + level * 0.2
	end,
	Toughness = function(level)
		return 5 + level * 0.5
	end,
	Resistance = function(level)
		return 5 + level * 0.5
	end,
	Speed = function(level)
		return 14.5
	end
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test