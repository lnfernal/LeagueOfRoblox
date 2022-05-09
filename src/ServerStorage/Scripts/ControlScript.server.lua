

local PLAYER = script.Parent.Parent
if not PLAYER.Parent == game.Players then return end

local CHAR = PLAYER.Character

local HUMAN = CHAR.Humanoid
local HRP = CHAR.HumanoidRootPart

while not CHAR.Parent do wait() end
local CONTROL = CHAR:WaitForChild("CharacterScript")
local GAMEMODE = game.ReplicatedStorage.GameState.Gamemode
local GET_HUMANOIDS = game.ServerScriptService.HumanoidService.GetHumanoids
local GET_OTHER_TEAM = game.ServerScriptService.TeamScript.GetOtherTeam
local DS = game.ServerScriptService.DamageService
local PROJECTILE = DS.AddProjectile
local PLAY_ANIM = require(game.ServerStorage.PlayAnimation)
local HIT_SOUND = require(game.ServerStorage.HitSound)
local PLAY_SOUND = require(game.ServerStorage.PlaySound)
local ST = game.ServerScriptService.StatusService
local PS = game.ServerScriptService.PassiveService
local SFX = game.ServerScriptService.SFXService
local Stats = require(game.ReplicatedStorage.PlayerStats:WaitForChild(CHAR.Name))
local ABILITY_DATA
local ABILITY_POINTS = 0
local CHARACTER_DATA
local CDM = script:WaitForChild("CharacterData")

local R = game.ReplicatedStorage.Remotes

local MOUSE_POS = Vector3.new()
local MOUSE_TARG = nil

--bindable for the character script
local function playerState(...) return CONTROL.PlayerState:Invoke(...) end

--for ability abstraction
local DATA
local ABILITY_SCRIPT = script.Parent.AbilityScript

function stat(statName)
	return CONTROL.GetStat:Invoke(statName)
end

function steady()
	local function recurse(root)
		for index, child in pairs(root:GetChildren()) do
			if child:IsA("BasePart") then
				child.Velocity = Vector3.new()
			end
			recurse(child)
		end
	end
	recurse(CHAR)
end

function basicAttack()
	if CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	
	updateData()
	ABILITY_SCRIPT.BasicAttack:Invoke(DATA)
	
--	local cd = CONTROL.AbilityGetInfo:Invoke("Q").Cooldown
--	local bac = math.min(CONTROL.GetStat:Invoke("BasicAttackCooldown"), 0.6)
--	local cdr = cd * bac
--	CONTROL.AbilityCooldownReduce:Invoke("Q", cdr)
end

function ability1()
	updateData()
	ABILITY_SCRIPT.Ability1:Invoke(DATA)
end

function ability2()
	updateData()
	ABILITY_SCRIPT.Ability2:Invoke(DATA)
end

function ability3()
	updateData()
	ABILITY_SCRIPT.Ability3:Invoke(DATA)
end

function ability4()
	updateData()
	if script.Parent:FindFirstChild("PlayerState"):FindFirstChild("CharMods").Value == "Davidii" then
		--ABILITY_SCRIPT.Ability4:Invoke(DATA)
	else
		ABILITY_SCRIPT.Ability4:Invoke(DATA)
	end
end

function isRecalling()
	return CHAR:FindFirstChild("Recalling") ~= nil
end

function setRecalling(bool)
	if bool then
		local mark = Instance.new("BoolValue", CHAR)
		mark.Name = "Recalling"
	else
		while isRecalling() do
			CHAR.Recalling:Destroy()
		end
	end
end

function recall()
	if isRecalling() then return end
	
	local recallPosition = HRP.Position
	local effectPos = Vector3.new(recallPosition.X, 1.1, recallPosition.Z)
	local tolerance = 1
	local recallTime = 6
	CONTROL.AbilityCooldownLag:Invoke("Q", recallTime)
	CONTROL.AbilityCooldownLag:Invoke("A", recallTime)
	CONTROL.AbilityCooldownLag:Invoke("B", recallTime)
	CONTROL.AbilityCooldownLag:Invoke("C", recallTime)
	CONTROL.AbilityCooldownLag:Invoke("D", recallTime)

	setRecalling(true)
	
	local t = 0
	while t < recallTime and isRecalling() do
		local percent = t / recallTime
		SFX.Artillery:Invoke(effectPos, percent * 16, "Bright blue")
		
		t = t + wait(0.25)
		
		local currentPosition = HRP.Position
		local distance = (currentPosition - recallPosition).magnitude
		
		if distance > tolerance then
			setRecalling(false)
		end
	end
	
	if isRecalling() then
		local target = CHAR.GetTeam:Invoke().SpawnPosition + Vector3.new(0, 3, 0)
		local dir = (target - recallPosition).unit
		local dis = (target - recallPosition).magnitude
		local spd = 4000
		local function onHit()
		end
		local function onStep(p)
		end
		local function onEnd(p)
			HRP.CFrame = p:CFrame()
			steady()
		end
		local p = DS.AddProjectile:Invoke(recallPosition, dir, spd, 0, dis, CHAR.Team.Value, onHit, onStep, onEnd, false)
		SFX.ProjLeap:Invoke(p:ClientArgs(), HRP, 128)
		
		setRecalling(false)
	end
end

function jumpHeight(distance, height, current)
	local funcHeight = (distance/2)^2
	local func = -current * (current - distance)
	func = func / funcHeight
	func = func * height
	return Vector3.new(0, func, 0)
end

function updateData()
	DATA = {
		PLAYER = PLAYER,
		CHAR = CHAR,
		HUMAN = HUMAN,
		HRP = HRP,
		CONTROL = CONTROL,
		GET_HUMANOIDS = GET_HUMANOIDS,
		DS = DS,
		PROJECTILE = PROJECTILE,
		PLAY_ANIM = PLAY_ANIM,
		HIT_SOUND = HIT_SOUND,
		PLAY_SOUND = PLAY_SOUND,
		ST = ST,
		ABILITY_DATA = ABILITY_DATA,
		CHARACTER_DATA = CHARACTER_DATA,
		GET_OTHER_TEAM = GET_OTHER_TEAM,
		MOUSE_POS = R.GetMousePos:InvokeClient(PLAYER),
		GET_MOUSE_POS = R.GetMousePos,
		MOUSE_TARG = MOUSE_TARG,
		SFX = SFX,
		PS = PS,
		R = R,
		STEADY = steady,
		CHOOSE = function(list)
			return list[math.random(1, #list)]
		end,
		DB = function(obj, dur)
			game:GetService("Debris"):AddItem(obj, dur)
		end,
		FLAT = function(pos)
			return Vector3.new(pos.X,pos.Y - 2.5, pos.Z)
		end,
		IN = function(item, list)
			for _, check in pairs(list) do
				if check == item then
					return true
				end
			end
			return false
		end,
		GET_HRP = function(humanoid)
			if humanoid then
				if humanoid.Parent then
					return humanoid.Parent:FindFirstChild("HumanoidRootPart")
				end
			end
			return nil
		end,
		PLAY_SOUND_POS = function(position, id, volume, pitch)
			local sp = Instance.new("Part")
			sp.CanCollide = false
			sp.Anchored = true
			sp.Transparency = 1
			sp.Position = position
			sp.Parent = workspace
			game:GetService("Debris"):AddItem(sp)
			
			PLAY_SOUND(sp, id, volume, pitch)
		end,
		IS_MINION = function(char)
			if not char then
				return false
			end
			return game.Players:GetPlayerFromCharacter(char) == nil
		end,
		GET_TEAM_OBJ = function(humanoid)
			local parent = humanoid.Parent
			if parent then
				local team = parent:FindFirstChild("GetTeam")
				if team ~= nil then
					return team:Invoke()
				end
			end
			return nil
		end,
		GET_TEAM = function(humanoid)
			if not humanoid then
				return false
			end
			
			local parent = humanoid.Parent
			if parent then
				local team = parent:FindFirstChild("Team")
				if team then
					return team.Value
				end
			end
			return nil
		end,
		FOOT = function()
			return HRP.CFrame:pointToWorldSpace(Vector3.new(0, -2.5, 0))
		end,
		C = function(color)
			return BrickColor.new(color)
		end,
		GET_TARGET_POS = function()
			return R.GetMousePos:InvokeClient(PLAYER)
		end,
		LEVEL = function(a, b)
			return Vector3.new(b.X, a.Y, b.Z)
		end,
		GET_SET_BINDABLES = function(human)
			local char = human.Parent
			if char then
				local gs = char:FindFirstChild("GetStat", true)
				local ss = char:FindFirstChild("SetStat", true)
				if gs and ss then
					return gs, ss
				end
			end
		end,
		CW = function(part)
			for _, obj in pairs(part:GetChildren()) do
				if obj:IsA("Weld") or obj:IsA("Motor6D") then
					obj:Destroy()
				end
			end
		end,
		TELEPORT = function(b)
			local a = DATA.HRP.Position
			local v = (b - a)
			DATA.HRP.CFrame = CFrame.new(b, b + v) + Vector3.new(0, 2.5, 0)
		end,
		JUMP_HEIGHT = jumpHeight,
		EasyProjectile = function(args)
			return PROJECTILE:Invoke(
				args.Position or Vector3.new(),
				args.Direction or Vector3.new(),
				args.Speed or 32,
				args.Width or 6,
				args.Range or 32,
				args.Team or CHAR.Team.Value,
				args.OnHit or function() end, 
				args.OnStep or function() end,
				args.OnEnd or function() end,
				args.Solid,
				args.HitsTurrets
			)
		end,
		EasyDamage = function(enemy, damage, protection)
			DS.Damage:Invoke(enemy, damage, protection, PLAYER)
		end,
		EasyStack = function(human, name, duration)
			if ST.GetEffect:Invoke(human, name) then
				ST.Stack:Invoke(human, name)
			else
				ST.Tag:Invoke(human, duration, name)
			end
		end,
		RefreshStack = function(human, name)
			if ST.GetEffect:Invoke(human, name) then
				ST.Stack:Invoke(human, name, 0)
			end
		end,
		EasyTarget = function(range)
			return DATA.FLAT(DS.Targeted:Invoke(HRP.Position, range, DATA.MOUSE_POS))
		end
	}
end

--ability data stuff
ABILITY_DATA = ABILITY_SCRIPT.AbilityData:Invoke()
CHARACTER_DATA = {
	Health = function(level)
		return CDM.Health.Base.Value + CDM.Health.PerLevel.Value * level
	end,
	HealthRegen = function(level)
		return CDM.HealthRegen.Base.Value + CDM.HealthRegen.PerLevel.Value * level
	end,
	Skillz = function(level)
		return CDM.Skillz.Base.Value + CDM.Skillz.PerLevel.Value * level
	end,
	H4x = function(level)
		
		return CDM.H4x.Base.Value + CDM.H4x.PerLevel.Value * level
		
	end,
	Toughness = function(level)
		
			return CDM.Toughness.Base.Value + CDM.Toughness.PerLevel.Value * level
		
	end,
	Resistance = function(level)
		
			return CDM.Resistance.Base.Value + CDM.Resistance.PerLevel.Value * level
		
	end,
	Speed = function(level)
		if CDM:FindFirstChild("Speed") then
			return CDM.Speed.Base.Value + CDM.Speed.PerLevel.Value * level
		else
			return 15.5
		end
	end
}

function trunc(number)
	local str = tostring(number)
	return str:sub(1, 5)
end

function cap(str)
	return str:sub(1,1):upper()..str:sub(2)
end

function parseAML(s, ability, data)
	for match in string.gmatch(s, "<.->") do
		match = match:sub(2, -2)
		if match == "level" then
			s = string.gsub(s, "<level>", ability.Level) 
		elseif match == "heal1" then
			s = string.gsub(s, "<heal1>", math.floor(trunc(ability:C(data[match]))/.98))
		elseif match == "heal2" then
			s = string.gsub(s, "<heal2>", math.floor(trunc(ability:C(data[match]))/.96))
		else
			s = string.gsub(s, "<"..match..">", trunc(ability:C(data[match])))
		end
	end
	
	return s
end

function disconnectAll(connections)
	for _, connection in pairs(connections) do
		connection:disconnect()
	end
end

function packDescriptions(desc, extraDescs)
	local str = desc.."\n"
	for _, extra in pairs(extraDescs) do
		str = str.."\n"..extra
	end
	return str
end

local levelUpConnections = {}
function updateGui()
	local update = {}
	
	for _, aName in pairs{"A", "B", "C", "D"} do
		local data = ABILITY_DATA[aName]
		local ability = Stats.Stats.Abilities[aName]
		
		local extraDescriptions = {}
		for key, val in pairs(data) do
			if key ~= "Name" and key ~= "Desc" and key ~= "MaxLevel" then
				local desc = cap(key)..": "
				local firstStat = true
				if val.Base then
					desc = desc..val.Base
					firstStat = false
				end
				if val.AbilityLevel then
					if not firstStat then
						desc = desc.." + "
					end
					firstStat = false
					
					desc = desc..val.AbilityLevel.." per ability level"
				end
				for stat, scale in pairs(val) do
					if stat ~= "Base" and stat ~= "AbilityLevel" then
						if not firstStat then
							desc = desc.." + "
						end
						firstStat = false
						
						desc = desc..(scale * 100).."% of "..stat
					end
				end
				desc = desc.." = "..trunc(ability:C(val))
				
				table.insert(extraDescriptions, desc)
			end
		end
		
		local state = {}
		state["Ability"..aName.."Name"] = parseAML(data.Name, ability, data)
		state["Ability"..aName.."Description"] = packDescriptions(parseAML(data.Desc, ability, data), extraDescriptions)
		playerState(state)
	end
	
	playerState{
		AbilityPoints = ABILITY_POINTS
	}
end
--/ability data stuff

function updateStats(newLevel)
	if CHARACTER_DATA.Skillz then
		CONTROL.SetStat:Invoke("Skillz", CHARACTER_DATA.Skillz(newLevel))	
	end
	if CHARACTER_DATA.HealthRegen then
		CONTROL.SetStat:Invoke("HealthRegen", CHARACTER_DATA.HealthRegen(newLevel))
		end
	if CHARACTER_DATA.H4x then
		CONTROL.SetStat:Invoke("H4x", CHARACTER_DATA.H4x(newLevel))
	end
	if CHARACTER_DATA.Toughness then
		CONTROL.SetStat:Invoke("Toughness", CHARACTER_DATA.Toughness(newLevel))
	end
	if CHARACTER_DATA.Resistance then
		CONTROL.SetStat:Invoke("Resistance", CHARACTER_DATA.Resistance(newLevel))
	end
	if GAMEMODE.Value == "Ultra Rapid Fire" then
	CONTROL.SetStat:Invoke("CooldownReduction", .6)
	end
end

coroutine.resume(coroutine.create(function()
	while(true) do
		if(CHAR:FindFirstChild("j")) then
			if(game.ReplicatedStorage.GameState.Time.Value ~= 0) then --If we run some of the equations when game time is 0, then some arithmetic errors will occur
				updateStats(0);
			end
		end
		wait(10);
	end
end))

--level up stuff
function levelUp(newLevel)
	ABILITY_POINTS = ABILITY_POINTS + 1
	
	CONTROL.SetStat:Invoke("Health", CHARACTER_DATA.Health(newLevel))
	
	if CHARACTER_DATA.Speed then
		CONTROL.SetStat:Invoke("Speed", CHARACTER_DATA.Speed(newLevel))
	end
	
	updateStats(newLevel);

	updateGui()
end

function abilityLevelUp()
	ABILITY_POINTS = ABILITY_POINTS - 1
	updateGui()
end
CONTROL.LeveledUp.Event:connect(levelUp)
CONTROL.AbilityLeveledUp.Event:connect(abilityLevelUp)
CONTROL.UpdateGui.Event:connect(updateGui)
CONTROL:WaitForChild("SetStat")
CONTROL.GiveExperience:Invoke(0)
--/level up stuff

--event hookups
R.MouseButton1Down.OnServerEvent:connect(function(player, hit, target)
	if player ~= PLAYER then return end
	
	basicAttack()
end)
R.KeyDown.OnServerEvent:connect(function(player, key)
	if player ~= PLAYER then return end
	
	if key == Enum.KeyCode.One then
		ability1()
	end
	if key == Enum.KeyCode.Two then
		ability2()
	end
	if key == Enum.KeyCode.Three then
		ability3()
	end
	if key == Enum.KeyCode.Four then
		ability4()
	end
	if key == Enum.KeyCode.B then
		recall()
	end
	
	--for custom items
	for _, item in pairs(CONTROL.Inventory:GetChildren()) do
		if item:FindFirstChild("Hotkey") then
			if key == Enum.KeyCode[item.Hotkey.Value] then
				CONTROL.UseItem:Invoke(item)
				break
			end
		end
	end
end)
--/event hookups

--set in the player state each ability's maximum level
for ltr, data in pairs(ABILITY_DATA) do
	local v = Instance.new("IntValue")
	v.Name = "Ability"..ltr.."MaxLevel"
	v.Value = data.MaxLevel
	v.Parent = PLAYER.Backpack.PlayerState
end

function script.GetData.OnInvoke()
	updateData()
	return DATA
end

CHAR:WaitForChild("Humanoid").HealthChanged:connect(function(value)
	if value <= CHAR.Humanoid.MaxHealth * .2 then
		if script.Parent:FindFirstChild("PlayerState"):FindFirstChild("CharMods")and script.Parent:FindFirstChild("PlayerState"):FindFirstChild("CharMods").Value == "Davidii" then
		ABILITY_SCRIPT.Ability4:Invoke(DATA)
		end
	end
end)
--end

--finalizing everything
updateData()

game.ServerScriptService.CharacterService.ChangeCharacter:Invoke(CHAR, script.CharacterModel.Value,nil,PLAYER)
if script:FindFirstChild("CharacterModels") then
game.ServerScriptService.CharacterService.ChangeCharacter:Invoke(CHAR, script.CharacterModels.Value,true,PLAYER)
end