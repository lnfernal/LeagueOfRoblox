local CHAR = script.Parent
local HUMAN = CHAR:WaitForChild("Humanoid")
local HRP = CHAR.HumanoidRootPart
local PLAYER = game.Players:GetPlayerFromCharacter(CHAR)
local permbuffs = {}
local R = game.ReplicatedStorage.Remotes

local DS = game.ServerScriptService.DamageService

--generate a model to hold statuses
local STATUSES = Instance.new("Model")
STATUSES.Name = "Statuses"
STATUSES.Parent = CHAR

local PASSIVE = Instance.new("Model")
PASSIVE.Name = "Passives"
PASSIVE.Parent = CHAR

local Aggro = Instance.new("BoolValue")
Aggro.Name = "Aggro"
Aggro.Parent = CHAR

wait(1)

local TEAM = CHAR:FindFirstChild("GetTeam")

	TEAM = CHAR:WaitForChild("GetTeam")

local TEAM_NAME = ""
if TEAM then
	TEAM = TEAM:Invoke()
	TEAM_NAME = TEAM.Name
end

local INVENTORY = Instance.new("Model", script)
INVENTORY.Name = "Inventory"
local Stats = require(game.ReplicatedStorage.PlayerStats:WaitForChild(CHAR.Name))
--some globals
local STUNNED = false
local GUI_PULSE = 0
local GUI_THRESH = 0.2

--ability script
local ABILITY_SCRIPT, ABILITY_DATA

	ABILITY_SCRIPT = PLAYER:WaitForChild("Backpack"):WaitForChild("AbilityScript")
	ABILITY_DATA = ABILITY_SCRIPT.AbilityData:Invoke()
game.ReplicatedStorage.Remotes.UpdateData:FireClient(PLAYER,ABILITY_DATA)

--other services
local TIMER_SERVICE = game.ServerScriptService.TimerService
function getSpawnDistance()
	local a = HRP.Position
	local b = TEAM.SpawnPosition
	
	return (b - a).magnitude
end
--[[function Ability(id)
	return {
		OnCooldown = false,
		CooldownLeft = 0,
		Cooldown = 1,
		Level = 0,
		C = function(self, data)
			local total = 0
			for stat, scale in pairs(data) do
				if stat == "Base" then
					total = total + scale
				elseif stat == "AbilityLevel" then
					total = total + self.Level * scale
				else
					total = total + self:Get(stat) * scale
				end
				if stat == "H4xAbilityLevel" then
					total = total + (self:Get("H4x") * scale) *  self.Level 
				end
				end
			return total
		end,
		Id = id,
	}
end]]

if(PLAYER) then
	averageValue = game.ReplicatedStorage.GetAverageValue:Invoke(PLAYER.TeamColor);
	averageExperience = game.ReplicatedStorage.GetAverageExperience:Invoke(PLAYER.TeamColor);
end
local Kills = 0

--character information
--[[local STATS = {
	Level = 0,
	Experience = 0,
	Skillz = 0,
	Toughness = 0,
	H4x = 0,
	Resistance = 0,
	Speed = 16,
	Health = 100,
	HealthRegen = 1,
	Tix = 450,
	Kills = 0,
	Deaths = 0,
	Assists = 0,
	Abilities = {
		Q = Ability("Q"),
		A = Ability("A"),
		B = Ability("B"),
		C = Ability("C"),
		D = Ability("D"),
	},
		Get = function(self, statName)
		local base = self[statName] or 0
		
		
		
		--check for stat buffs
		for _, status in pairs(STATUSES:GetChildren()) do
			if status.Effect.Value == "StatBuff" then
				if status.Stat.Value == statName then
				
					base = base + status.Amount.Value
					
				end
			end
		end
		
		for _, status in pairs(PASSIVE:GetChildren()) do
			if status.Effect.Value == "StatBuff" then
				if status.Stat.Value == statName then
					base = base + status.Amount.Value
				end
			end
		end
		
		
		--check for stat boosting items
		for _, item in pairs(INVENTORY:GetChildren()) do
			local statEffect = item.Effects:FindFirstChild(statName)
			if (item.Name == "Ghostwalker" or item.Name == "Exploiter's Rapier") and statEffect then
			base = base + (statEffect.Value + (20 * Kills))
			elseif statEffect then
				base = base + statEffect.Value
			end
			
		end	
		if base < -100 then
			base = -100
		end
		return base
	end,
}]]
local STATS = Stats.Stats
if(PLAYER) then
	if(not PLAYER:FindFirstChild("AlreadyBalanced")) then
		STATS.Tix = (math.max(averageValue, 450)*1);
		game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,"Tix",STATS.Tix)
		Instance.new("IntValue", PLAYER).Name = "AlreadyBalanced";
	end
end

STATS.Abilities.Q.Level = 1
for _, ability in pairs(STATS.Abilities) do
	ability.Stats = function()
		return STATS
	end
	ability.Get = function(self, ...)
		return Stats.StatsGet(...)
	end
end

function experienceNeeded()
	return STATS.Level * 4
end

function getBaseMoveSpeed()
	return Stats.StatsGet("Speed")
end

function getInventoryString()
	local str = ""
	
	for _, item in pairs(INVENTORY:GetChildren()) do
		str = str..item.Name..", "
	end
	
	str = str:sub(1, -3)
	
	return str
end

function getSpawnDistance()
	local a = HRP.Position
	local b = TEAM.SpawnPosition
	
	return (b - a).magnitude
end

function getEnemySpawnDistance()
	local a = HRP.Position
	local b = TEAM:GetOtherTeam().SpawnPosition
	
	return (b - a).magnitude
end

local function psVal(t, n, p)
	local val = Instance.new(t.."Value")
	val.Name = n
	val.Parent = p
end

local getType = require(game.ReplicatedStorage.GetType)

local function playerState(args)
	local bp = PLAYER.Backpack
	local ps = bp:FindFirstChild("PlayerState")
	if not ps then
		ps = Instance.new("Model")
		ps.Name = "PlayerState"
		ps.Parent = bp
	end
	
	for key, val in pairs(args) do
		if not ps:FindFirstChild(key) then
			local v = Instance.new(getType(val).."Value")
			v.Name = key
			v.Parent = ps
		end
		
		ps[key].Value = val
	end
end
script.PlayerState.OnInvoke = playerState

local function playerGet(key)
	local bp = PLAYER.Backpack
	local ps = bp:FindFirstChild("PlayerState")
	if ps and ps:FindFirstChild(key) then
		return ps[key].Value
	end
	return nil
end
function loop(dt)
	--Kills = STATS["Kills"]
	local foundAStun = false
	local percentMoveSpeedMod = 0
	for _, status in pairs(STATUSES:GetChildren()) do
		--perform some logic based upon the type
			if status.Effect.Value == "PercentMoveSpeed" then
			percentMoveSpeedMod = percentMoveSpeedMod + status.Amount.Value
		end
		if status.Effect.Value == "Stun" then
			foundAStun = true
		end
		end
	STUNNED = foundAStun
	--do ability cooldowns
	for index, ability in pairs(STATS.Abilities) do
		if ability.OnCooldown then
			ability.CooldownLeft = ability.CooldownLeft - dt
			if ability.CooldownLeft <= 0 then
				ability.CooldownLeft = 0
				ability.OnCooldown = false
			end
		end
	end
	if percentMoveSpeedMod < -1 then
		percentMoveSpeedMod = -1
	end
	local baseMoveSpeed = getBaseMoveSpeed()
	local moveSpeedMod = percentMoveSpeedMod * baseMoveSpeed
	local moveSpeed = baseMoveSpeed + moveSpeedMod
	if STUNNED then
		moveSpeed = 0
	end
	HUMAN.WalkSpeed = moveSpeed
	--set the health, perform health regen
	HUMAN.MaxHealth = Stats.StatsGet("Health")
	
	
	
	--kill players that fell off the map the appropriate way
	
	if CHAR:FindFirstChild("Head") then
		local teamGui = CHAR.Head:FindFirstChild("TeamGui")
		if teamGui then
			teamGui.LevelLabel.Text = Stats.StatsGet("Level")
		end
		end	
	
	
	--handle GUI stuff
	
--local spawnDistance = getSpawnDistance()
		
		--local dead = HUMAN:FindFirstChild("Dead") ~= nil
		
		--[[playerState{
			Health = HUMAN.Health,
			MaxHealth = HUMAN.MaxHealth,
			Speed = HUMAN.WalkSpeed,
			Skillz = Stats.StatsGet("Skillz"),
			BasicCDR = Stats.StatsGet("BasicCDR"),
			H4x = Stats.StatsGet("H4x"),
			Toughness = Stats.StatsGet("Toughness"),
			Resistance = Stats.StatsGet("Resistance"),
			Level = STATS.Level,
			MaxExp = experienceNeeded(),
			Exp = STATS.Experience,
			TeamName = TEAM_NAME,
			TeamColor = TEAM.Color,
			Tix = STATS.Tix,
			TeamKills = TEAM:GetTeamStat("Kills"),
			EnTeamColor = TEAM:GetOtherTeam().Color,
			EnTeamKills = TEAM:GetOtherTeam():GetTeamStat("Kills"),
			Kills = STATS.Kills,
			Deaths = STATS.Deaths,
			Assists = STATS.Assists,
			InShopRange = (spawnDistance < 96) or dead,
			HealthRegen = Stats.StatsGet("HealthRegen"),
		}]]
		--[[for ltr, ability in pairs(STATS.Abilities) do
			local state = {}
			local id = "Ability"..ltr
			state[id.."MaxCooldown"] = ability.Cooldown
			state[id.."Cooldown"] = ability.CooldownLeft
			state[id.."Level"] = ability.Level
			playerState(state)
		end]]
		
	
	end

	--billboard stuff


local bfNames = {
	"GetStat",
	"SetStat",
	"PermBuff",
	"AbilityOnCooldown",
	"AbilityCooldown",
	"AbilityCooldownReduce",
	"AbilityCooldownLag",
	"AbilityLevelUp",
	"AbilityGetInfo",
	"GiveExperience",
	"GiveTix",
	"GetTix",
	"AttemptShopBuy",
	"AttemptShopBuyNoLimit",
	"AttemptShopSell",
	"UseItem",
	"GetLevel",
	"GetExperience"
}

local bfs = {}

for _, bfName in pairs(bfNames) do
	bfs[bfName] = Instance.new("BindableFunction")
	bfs[bfName].Name = bfName
end

function bfs.GetStat.OnInvoke(statName)
	return Stats.StatsGet(statName)
end

function setHealth(value)
	if permbuffs["Health"] == nil then permbuffs["Health"] = 0 end
	local delta = value - STATS["Health"] + permbuffs["Health"]
	STATS["Health"] = value + permbuffs["Health"]
	game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,"Health",value + permbuffs["Health"])
	delay(0.25, function()
		HUMAN.Health = HUMAN.Health + delta
	end)
end

function bfs.SetStat.OnInvoke(statName, value)
	if statName == "Health" then
		setHealth(value)
	elseif Stats.BaseStatGet(statName) > value then
		if permbuffs[statName] == nil then permbuffs[statName] = 0 end
		local s = value + permbuffs[statName]
		STATS[statName] = s
		game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,statName,s)
	else
		STATS[statName] = value
		game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,statName,value)
	end
end
function bfs.PermBuff.OnInvoke(statName,value)
local s = Stats.BaseStatGet(statName)
	if permbuffs[statName] == nil then permbuffs[statName] = 0 end
	permbuffs[statName] = permbuffs[statName] + value
	value = value + s
	STATS[statName] = value
	game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,statName,value)
end
function bfs.AbilityOnCooldown.OnInvoke(ability)
	if STUNNED then return true end
	if STATS.Abilities[ability].Level < 1 then return true end
	
	return STATS.Abilities[ability].OnCooldown
end

function bfs.AbilityCooldown.OnInvoke(ability, cooldown)
	game.ReplicatedStorage.Remotes.AbilityCooldown:FireClient(PLAYER,ability,cooldown)
	if STATS.Abilities[ability].OnCooldown == true then
	STATS.Abilities[ability].OnCooldown = true
	STATS.Abilities[ability].CooldownLeft = math.max(STATS.Abilities[ability].CooldownLeft, cooldown)
	STATS.Abilities[ability].Cooldown = STATS.Abilities[ability].CooldownLeft + cooldown	
	else
	STATS.Abilities[ability].OnCooldown = true
	STATS.Abilities[ability].CooldownLeft = math.max(STATS.Abilities[ability].CooldownLeft, cooldown)
	STATS.Abilities[ability].Cooldown = cooldown
	end
end

function bfs.AbilityCooldownReduce.OnInvoke(ability, reduction)
	game.ReplicatedStorage.Remotes.AbilityCooldownReduce:FireClient(PLAYER,ability,reduction)
	local ability = STATS.Abilities[ability]
	ability.CooldownLeft = ability.CooldownLeft - reduction
	if ability.CooldownLeft <= 0 then
		ability.CooldownLeft = 0
		ability.OnCooldown = false
	end
end

function bfs.AbilityCooldownLag.OnInvoke(ability, increase)
	game.ReplicatedStorage.Remotes.AbilityCooldownLag:FireClient(PLAYER,ability,increase)
	local ability = STATS.Abilities[ability]
	ability.CooldownLeft = ability.CooldownLeft
	if ability.CooldownLeft < increase then
		ability.CooldownLeft = increase
		ability.Cooldown = increase
		ability.OnCooldown = true
	end
	end

function bfs.AbilityLevelUp.OnInvoke(ability)
	game.ReplicatedStorage.Remotes.AbilityLevelUp:FireClient(PLAYER,ability)
	if playerGet("AbilityPoints") >= 1 then
		local ability = STATS.Abilities[ability]
		if ability.Level < ABILITY_DATA[ability.Id].MaxLevel then
			ability.Level = ability.Level + 1
			script.AbilityLeveledUp:Fire(ability)
		end
	end
end

function bfs.AbilityGetInfo.OnInvoke(ability)
	return STATS.Abilities[ability]
end

	  

function giveExperience(amount)
	STATS.Experience = STATS.Experience + amount
	game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,"Experience",STATS.Experience)
	if STATS.Level == 20 then
		STATS.Experience = 0
		game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,"Experience",STATS.Experience)
		end    
	while STATS.Experience >= STATS.Level * 4 do
		STATS.Experience = STATS.Experience - STATS.Level * 4
		STATS.Level = STATS.Level + 1
		script.LeveledUp:Fire(STATS.Level)
		game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,"Level",STATS.Level)
		game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,"Experience",STATS.Experience)
	end
end

bfs.GiveExperience.OnInvoke = giveExperience;

function bfs.GiveTix.OnInvoke(amount)
	STATS.Tix = STATS.Tix + amount
	game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,"Tix",STATS.Tix)
end

function bfs.GetTix.OnInvoke()
	return STATS.Tix;
end

function bfs.GetLevel.OnInvoke()
	return STATS.Level;
end

function bfs.GetExperience.OnInvoke()
	return STATS.Experience;
end

function assignHotkey(item)
	if not item:FindFirstChild("UseScript") then return end
	
	if item:FindFirstChild("Hotkey") then
		item.Hotkey:Destroy()
	end

	local hotkeys = {"Z", "X", "C", "V", "F"}
	local hotkeysInUse = {}
	for _, item in pairs(INVENTORY:GetChildren()) do
		if item:FindFirstChild("Hotkey") then
			table.insert(hotkeysInUse, item.Hotkey.Value)
		end
	end
	
	local function inUse(hotkey)
		for _, hotkeyInUse in pairs(hotkeysInUse) do
			if hotkey == hotkeyInUse then
				return true
			end
		end
		return false
	end
	
	for _, hotkey in ipairs(hotkeys) do
		if not inUse(hotkey) then
			local sv = Instance.new("StringValue", item)
			sv.Name = "Hotkey"
			sv.Value = hotkey
			
			break
		end
	end
end
local numberofattackspeed = 0
local numberofdagger = 0
local spam = 0
local rage = 0
local golden = 0
local lich = 0
--Finds the total cost of a item
local function checkcost(item)
	local builds = {}
	local cost = 0
	cost = item.Cost.Value
	if item:FindFirstChild("Req") then
		for i,req in pairs(item.Req:GetChildren()) do
			table.insert(builds,game.ReplicatedStorage.Shop:FindFirstChild(req.Name).Cost.Value)
			if game.ReplicatedStorage.Shop:FindFirstChild(req.Name):FindFirstChild("Req") then
				local others = checkcost(game.ReplicatedStorage.Shop:FindFirstChild(req.Name))
				for i,v in pairs(others) do
					table.insert(builds,v)
				end
			end
		end
	end
	for i,v in pairs(builds) do
		cost = cost + v
	end
return builds,cost
end
--//Finds the total cost of a item
--Get all possible requirements
local function getrequirements(item)
	local builds = {}
	
	if item:FindFirstChild("Req") then
		for i,req in pairs(item.Req:GetChildren()) do
			table.insert(builds,req.Name)
			if game.ReplicatedStorage.Shop:FindFirstChild(req.Name):FindFirstChild("Req") then
				local others = getrequirements(game.ReplicatedStorage.Shop:FindFirstChild(req.Name))
				for i,v in pairs(others) do
					table.insert(builds,v)
				end
			end
		end
	end
return builds
end
--//Get all possible requirements
function bfs.AttemptShopBuy.OnInvoke(shopItem)
if not playerGet("InShopRange") then return end
	local _,cost = checkcost(shopItem)
	local tc = 0
	tc = tc + cost
	local real = getrequirements(shopItem)
	local requirements = real
	local canPurchase = true
local todelete = {}
local tocheck = {}
local numberofitems = 0
for _, item in pairs(INVENTORY:GetChildren()) do
			canPurchase = true
			if shopItem:FindFirstChild("Unique") then
				if item:FindFirstChild("Unique") then
			local itemIdz = item:FindFirstChild("Unique")
			local other = shopItem:FindFirstChild("Unique")
			if itemIdz.Value == other.Value then
				numberofitems = numberofitems + 1
			end
				end
				end
			end
	if shopItem:FindFirstChild("Unique") then
		local id = shopItem.Unique.Value
		for _, item in pairs(INVENTORY:GetChildren()) do
			local itemId = item:FindFirstChild("Unique")
			if itemId then
				itemId = itemId.Value
				if numberofitems < 1 and id == "Attack Speed" then
				elseif numberofitems >= 1  then
					canPurchase = false
				if shopItem:FindFirstChild("Req") then
						if shopItem.Req:FindFirstChild(item.Name) and (not INVENTORY:FindFirstChild(shopItem.Name) or id == "Attack Speed") then
							canPurchase = true
							break
						end
					end
				end

			end
			
				
			end
		end
	
	local reqItems = shopItem:FindFirstChild("Req")
	if reqItems then
		
		local copy = INVENTORY:Clone()
		
		local function tabledelete(tabl,check)
			for i,v in pairs(tabl) do
				if v == check then
					table.remove(tabl,i)
					return true
					
				end
			end
		end
		local function realtablefind(tabl,check)
			for i,v in pairs(tabl) do
				if v == check then
					return true
				end
			end
		end

		local function finditems(itemtocheck)
		for index, reqItemName in pairs(itemtocheck.Req:GetChildren()) do
			for i,reqItem in pairs(copy:GetChildren()) do
			--and not copy:FindFirstChild(reqItemName.Parent.Parent.Name)
			if reqItem.Name == reqItemName.Name and not reqItem:FindFirstChild("Mark") and realtablefind(requirements,reqItem.Name) then
				tabledelete(requirements,reqItemName.Name)
				if reqItem:FindFirstChild("Req") then
					for _, requirementsmore in pairs(getrequirements(reqItem)) do
						tabledelete(requirements,requirementsmore)
					end
				end
				local Mark = Instance.new("BoolValue")
				Mark.Name = "Mark"
				Mark.Parent = reqItem
				local _,pz = checkcost(reqItem)
				tc = tc - pz
				table.insert(todelete,reqItem.Name)
				break
			
			end
			
			end

			end
		
		for index, reqItemName in pairs(itemtocheck.Req:GetChildren()) do
			for i,reqItem in pairs(copy:GetChildren()) do
			if game.ReplicatedStorage.Shop:FindFirstChild(reqItemName.Name):FindFirstChild("Req") and realtablefind(requirements,reqItemName.Name) then
			for _, requirementsmore in pairs(getrequirements(reqItem)) do
						tabledelete(requirements,requirementsmore) 
					end
			finditems(game.ReplicatedStorage.Shop:FindFirstChild(reqItemName.Name))	
			end
			end
		end
		end
		finditems(shopItem)
		copy:Destroy()
	end
	if STATS.Tix < tc then
		canPurchase = false
	end
	
	if canPurchase then
		local newItem = shopItem:Clone()
		newItem.Parent = INVENTORY
		assignHotkey(newItem)
		if reqItems then
		--[[	for _, reqItemName in pairs(requirements) do
				print(reqItemName)
			end]]
			for _, reqItemName in pairs(todelete) do
				--print(reqItemName)
				local reqItem = INVENTORY:FindFirstChild(reqItemName)
				if reqItem then
					reqItem:Destroy()
				end
			end
		end
		--print(tc)
		STATS.Tix = STATS.Tix - tc
		game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,"Tix",STATS.Tix)
		script.UpdateGui:Fire()
		R.UpdateBackpack:FireClient(PLAYER)
	end
end

function bfs.AttemptShopBuyNoLimit.OnInvoke(shopItem)
	if not playerGet("InShopRange") then return end
	local _,cost = checkcost(shopItem)
	local tc = 0
	tc = tc + cost
	local real = getrequirements(shopItem)
	local requirements = real
	local canPurchase = true
local todelete = {}
local tocheck = {}
local numberofitems = 0
for _, item in pairs(INVENTORY:GetChildren()) do
			canPurchase = true
			if shopItem:FindFirstChild("Unique") then
				if item:FindFirstChild("Unique") then
			local itemIdz = item:FindFirstChild("Unique")
			local other = shopItem:FindFirstChild("Unique")
			if itemIdz.Value == other.Value then
				numberofitems = numberofitems + 1
			end
				end
				end
			end
	if shopItem:FindFirstChild("Unique") then
		local id = shopItem.Unique.Value
		for _, item in pairs(INVENTORY:GetChildren()) do
			local itemId = item:FindFirstChild("Unique")
			if itemId then
				itemId = itemId.Value
				if numberofitems < 1 and id == "Attack Speed" then
					if numberofitems >= 1 then
					canPurchase = false
					if shopItem:FindFirstChild("Req") then
						if shopItem.Req:FindFirstChild(item.Name) then
							canPurchase = true
							break
						end
					end
					end
				elseif numberofitems >= 2 and id ~= "Shoes"  and id ~= "Utility" then
			
					canPurchase = false
					if shopItem:FindFirstChild("Req") then
						if shopItem.Req:FindFirstChild(item.Name) then
							canPurchase = true
							break
						end
					end
				elseif numberofitems >= 1 and (id == "Shoes" or id == "Utility") then
					canPurchase = false
				if shopItem:FindFirstChild("Req") then
						if shopItem.Req:FindFirstChild(item.Name) then
							canPurchase = true
							break
						end
					end
				end

			end
			
				
			end
		end
	
	local reqItems = shopItem:FindFirstChild("Req")
	if reqItems then
		
		local copy = INVENTORY:Clone()
		
		local function tabledelete(tabl,check)
			for i,v in pairs(tabl) do
				if v == check then
					table.remove(tabl,i)
					return true
					
				end
			end
		end
		local function realtablefind(tabl,check)
			for i,v in pairs(tabl) do
				if v == check then
					return true
				end
			end
		end

		local function finditems(itemtocheck)
		for index, reqItemName in pairs(itemtocheck.Req:GetChildren()) do
			for i,reqItem in pairs(copy:GetChildren()) do
			--and not copy:FindFirstChild(reqItemName.Parent.Parent.Name)
			if reqItem.Name == reqItemName.Name and not reqItem:FindFirstChild("Mark") and realtablefind(requirements,reqItem.Name) then
				tabledelete(requirements,reqItemName.Name)
				if reqItem:FindFirstChild("Req") then
					for _, requirementsmore in pairs(getrequirements(reqItem)) do
						tabledelete(requirements,requirementsmore)
					end
				end
				local Mark = Instance.new("BoolValue")
				Mark.Name = "Mark"
				Mark.Parent = reqItem
				local _,pz = checkcost(reqItem)
				tc = tc - pz
				table.insert(todelete,reqItem.Name)
				break
			
			end
			
			end

			end
		
		for index, reqItemName in pairs(itemtocheck.Req:GetChildren()) do
			for i,reqItem in pairs(copy:GetChildren()) do
			if game.ReplicatedStorage.Shop:FindFirstChild(reqItemName.Name):FindFirstChild("Req") and realtablefind(requirements,reqItemName.Name) then
			for _, requirementsmore in pairs(getrequirements(reqItem)) do
						tabledelete(requirements,requirementsmore)
					end
			finditems(game.ReplicatedStorage.Shop:FindFirstChild(reqItemName.Name))	
			end
			end
		end
		end
		finditems(shopItem)
		copy:Destroy()
	end
	if STATS.Tix < tc then
		canPurchase = false
	end
	
	if canPurchase then
		local newItem = shopItem:Clone()
		newItem.Parent = INVENTORY
		assignHotkey(newItem)
		if reqItems then
		--[[	for _, reqItemName in pairs(requirements) do
				print(reqItemName)
			end]]
			for _, reqItemName in pairs(todelete) do
				--print(reqItemName)
				local reqItem = INVENTORY:FindFirstChild(reqItemName)
				if reqItem then
					reqItem:Destroy()
				end
			end
		end
		--print(tc)
		STATS.Tix = STATS.Tix - tc
		game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,"Tix",STATS.Tix)
		script.UpdateGui:Fire()
		R.UpdateBackpack:FireClient(PLAYER)
	end
end

function bfs.AttemptShopSell.OnInvoke(item)
	if not playerGet("InShopRange") then return end
	if item == nil then return end
	--get the total cost of the item
	local cost = 0
	
	local function recurse(item)
		if not item then return end
		
		cost = cost + item.Cost.Value
		
		if item:FindFirstChild("Req") then
			for _, itemName in pairs(item.Req:GetChildren()) do
				recurse(game.ReplicatedStorage.Shop:FindFirstChild(itemName.Name))
			end
		end
	if item.Name =="Bot Network" then
		for i = 1,4 do
			local SFX = game.ServerScriptService.SFXService
			SFX.ProjRotateDead:Invoke(HRP,i,"Bot")
		end
	end
	end
	recurse(item)
	
	--delete the item
	item:Destroy()
	
	--now give back some of the tix
	STATS.Tix = STATS.Tix + cost * 0.8
	game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,"Tix",STATS.Tix)
	--rerender the whole dang thing
	script.UpdateGui:Fire()
	R.UpdateBackpack:FireClient(PLAYER)
end

function bfs.UseItem.OnInvoke(itemToUse)
	local data = PLAYER.Backpack.ControlScript.GetData:Invoke()
	if itemToUse:FindFirstChild("UseScript") then
		
	
	itemToUse.UseScript.Use:Invoke(itemToUse, data)
	
	for _, item in pairs(INVENTORY:GetChildren()) do
		if item:FindFirstChild("UseScript") and not item:FindFirstChild("Hotkey") then
			assignHotkey(item)
		end
	end
	
	R.UpdateBackpack:FireClient(PLAYER)
end
end
for _, bf in pairs(bfs) do
	bf.Parent = script
end

function main()
	--make sure we have everything we need
	CHAR:WaitForChild("Head")
	
	game:GetService("RunService").Heartbeat:connect(loop)
	
	if PLAYER then
		playerState{
			TeamName = TEAM_NAME,EnTeamColor = TEAM:GetOtherTeam().Color,TeamColor = TEAM.Color,
		}
		
		giveExperience(averageExperience);
	end
	--[[while wait(1.35) do
	STATS.Tix = STATS.Tix + 1
	end]]
end

main()
