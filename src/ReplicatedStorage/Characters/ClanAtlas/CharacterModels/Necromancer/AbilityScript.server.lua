function basicAttack(d)
if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
d.CONTROL.AbilityCooldown:Invoke("Q", 1.2 - (1.2 * d.CONTROL.GetStat:Invoke("BasicCDR")))
d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ClanBasicAttackFinal-item?id=263096961")
d.PLAY_SOUND(d.HUMAN, 16211041)
local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
local position = d.CHAR["Right Arm"].Position
local direction = d.HRP.CFrame.lookVector
local range = 32
local speed = 80
local width = 3.5
local team = d.CHAR.Team.Value
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
d.SFX.ProjShrink:Invoke(p:ClientArgs(), 1,  script.Parent.Parent.Character.Torso.Skills.Value.Color, 0.25)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
local data = d.ABILITY_DATA.A
local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
d.CONTROL.AbilityCooldown:Invoke("A", 15  - (15 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ClanIronRingFinal-item?id=263097249")
wait(0.15)
d.PLAY_SOUND(d.HUMAN, 13510737)
local damage = ability:C(data.damage)
local slow = -ability:C(data.root)/100
local duration = ability:C(data.duration)
local pos = d.HRP.Position - Vector3.new(0, 3, 0)
d.SFX.ReverseExplosion:Invoke(pos, 12, "Black", 0.1) 
local ring = d.CHAR.Ring:clone()
ring.Transparency = 0
local ringdia = ability:C(data.diameter)
d.CW(ring)
ring.Shape = "Block"
ring.Size = Vector3.new(ringdia, ringdia, ringdia)
ring.Mesh.Scale = Vector3.new(ringdia, ringdia, ringdia)
ring.Anchored = true
ring.CFrame = CFrame.new(pos, d.HRP.Position)
ring.Parent = workspace
d.DB(ring, 45)
ring.Touched:connect(function(part)
local hrp = d.GET_HRP(part)
if hrp then
local enemy = hrp.Parent:FindFirstChild("Humanoid")
local team = hrp.Parent:FindFirstChild("Team")
if not game:GetService("Players"):GetPlayerFromCharacter(enemy.Parent) then return end
if enemy and team then
if team.Value ~= d.CHAR.Team.Value then
d.ST.MoveSpeed:Invoke(enemy, slow, duration,"Rooted!")
d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
d.SFX.Artillery:Invoke(d.FLAT(hrp.Position), 4, script.Parent.Parent.Character.Torso.Skills.Value.Color)
ring:Destroy()
end
end
end
end)
end
script.Ability1.OnInvoke = ability1

local dmaxstack = 3
local dstack = dmaxstack

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12  - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	local range = ability:C(data.range)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 64
	local width = 0
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
	end
	local function onStep(p, dt)
	end
	local function onEnd(p)
		d.SFX.ReverseExplosion:Invoke(p.Position, 7.5, script.Parent.Parent.Character.Torso.Skills.Value.Color)
		d.ST.MoveSpeed:Invoke(d.HUMAN, slow, duration)
		d.HRP.CFrame = p:CFrame()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	local args = p:ClientArgs()
	d.SFX.ProjDash:Invoke(args, d.HRP)
	d.SFX.ProjShrink:Invoke(args, 2.5, script.Parent.Parent.Character.Torso.Skills.Value.Color, range / speed)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 17.5)
wait(0.3)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/ClanRegenerateFinal-item?id=263097615")
	
	local heal = ability:C(data.heal)
	local minionheal = heal * 1.5
	local buff = ability:C(data.buff)
	local duration = ability:C(data.duration)
	local minionduration = duration * 2
	
	local a = d.HRP.Position
	local range = 32
	local b = d.MOUSE_POS
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 16
	local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	local function onHit(ally)
		if game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then
		d.DS.Heal:Invoke(ally, heal)
		d.ST.StatBuff:Invoke(ally, "Shields", buff, duration)
			
		elseif d.IS_MINION(ally.Parent) then
			d.DS.Heal:Invoke(ally, minionheal)
		d.ST.StatBuff:Invoke(ally, "Toughness", buff, minionduration)
			d.ST.StatBuff:Invoke(ally, "Resistance", buff, minionduration)
		end
		end
	
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Bolt:Invoke(d.FLAT(center), 0.5, "Bright green")
	d.SFX.Explosion:Invoke(d.FLAT(center), radius, "Bright green")
	d.PLAY_SOUND_POS(d.FLAT(center), 12222030, 1)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 25  - (20 * d.CONTROL.GetStat:Invoke("CooldownReduction")))

	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DusekPowerful-item?id=155953604")
	
	local damage = ability:C(data.damage)
	
	local teamObj = d.GET_TEAM_OBJ(d.HUMAN)
	local spawn = teamObj.SpawnPosition + Vector3.new(0, 4, 0)
	local minion = game.ServerStorage.NecroClanMinion:Clone()
	minion.Parent = workspace
	minion:MoveTo(spawn)
	local minteam = Instance.new("StringValue")
	minteam.Parent = minion
	minteam.Value = d.CHAR.Team.Value
	minteam.Name = "Team"
	local minhealth = Instance.new("NumberValue")
	minhealth.Parent = minion
	minhealth.Name = "Health"
	minhealth.Value = ability:C(data.health)
	local mindamage = Instance.new("NumberValue")
	mindamage.Parent = minion
	mindamage.Name = "Damage"
	mindamage.Value = ability:C(data.miniondamage)
	minion:MakeJoints()
	delay(60,function()
		if minion then
			minion:Destroy()
		end
	end)
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 48, {BrickColor = teamObj.Color}, 0.75)
	wait(1)
	game.ServerScriptService.MinionAndTurretSpawn.AddMinion:Invoke(minion)
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/StickPowerful-item?id=158944818")
	local a = d.HRP.Position
	local range = 32
	local b = d.GET_MOUSE_POS:InvokeClient(d.PLAYER)
	local center = d.DS.Targeted:Invoke(a, range, b)
	local radius = 16
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		d.ST.MoveSpeed:Invoke(enemy, -.3, 1.25) 
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	minion:MoveTo(center)
	d.SFX.Artillery:Invoke(center, radius, teamObj.Color.Name)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Iron Ring",
		Desc = "ClanAtlas places an iron ring with a <diameter>-stud diameter at his feet. If an enemy steps on it, they are rooted for <duration> seconds as well as taking <damage> damage.",
		MaxLevel = 5,
		root = {
			Base = 100,
			
			
		},
		duration = {
			Base = 2,
		},
		damage = {
			Base = 30,
			AbilityLevel = 7.5,
			H4x = 0.35,
		},
		diameter = {
			Base = 12,
			AbilityLevel = .6,
		}
	},
	B = {
		Name = "Across the Atlas",
		Desc = "ClanAtlas dashes <range> studs forward. Afterwards, it slows him by <slow>% for <duration> seconds after using it.",
		MaxLevel = 5,
		range = {
			Base = 25,
			AbilityLevel = 4,
		},
		slow = {
			AbilityLevel = 4
		},
		duration = {
			Base = 2.25
		},
	},
	C = {
		Name = "Regenerate",
		Desc = "ClanAtlas casts a regenerative spell at a targeted area, healing allies within for <heal> health and instantly granting them <buff> health as a shield <buff> for <duration> seconds. The heal is increased by 50%, grants defenses instead of a shield, and the duration is increased by 100% on minions,",
		MaxLevel = 5,
		heal = {
			Base = 10,
			AbilityLevel = 6,
			H4x = 0.2,
			},
		buff = {
			Base = 20,
			AbilityLevel = 5,
			H4x = .3
		},
		duration = {
			Base = 3
		},
	},
	D = {
		Name = "Necromancy",
		Desc = "ClanAtlas summons a zombified allied minion with <health> health and deals <miniondamage> damage on hit in an explosion at the targeted point, dealing <damage> damage and slows 30% to enemies caught for 1.25 seconds.",
		MaxLevel = 3,
		damage = {
			Base = 25,
			AbilityLevel = 15,
			H4x = 0.4,
		},
		health = {
			Base = 335,
			AbilityLevel = 10,
			H4x = 0.3,
		},
		miniondamage = {
			Base = 12,
			AbilityLevel = 2,
			H4x = 0.05,
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