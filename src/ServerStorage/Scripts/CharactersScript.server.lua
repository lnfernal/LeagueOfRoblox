local CHAR = script.Parent
local HUMAN = CHAR:WaitForChild("Humanoid")
local HRP = CHAR.HumanoidRootPart
local PLAYER = game.Players:GetPlayerFromCharacter(CHAR)

local R = game.ReplicatedStorage.Remotes

local DS = game.ServerScriptService.DamageService

--generate a model to hold statuses
local STATUSES = Instance.new("Model")
STATUSES.Name = "Statuses"
STATUSES.Parent = CHAR

wait(1)

local TEAM = CHAR:FindFirstChild("GetTeam")
if PLAYER then
	TEAM = CHAR:WaitForChild("GetTeam")
end
local TEAM_NAME = ""
if TEAM then
	TEAM = TEAM:Invoke()
	TEAM_NAME = TEAM.Name
end

local INVENTORY = Instance.new("Model", script)
INVENTORY.Name = "Inventory"

--some globals
local STUNNED = false
local GUI_PULSE = 0
local GUI_THRESH = 0.2

--ability script


--other services
local TIMER_SERVICE = game.ServerScriptService.TimerService

function Ability(id)
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
			end
			return total
		end,
		Id = id,
	}
end

if(PLAYER) then
	averageValue = game.ReplicatedStorage.GetAverageValue:Invoke(PLAYER.TeamColor);
	averageExperience = game.ReplicatedStorage.GetAverageExperience:Invoke(PLAYER.TeamColor);
end

--character information

local STATS = {
	Level = 0,
	Experience = 0,
	Skillz = 0,
	Toughness = 0,
	H4x = 0,
	Resistance = 0,
	Speed = 16,
	Health = 100,
	HealthRegen = .5,
	Tix = 450,
	Kills = 0,
	Deaths = 0,
	Assists = 0,

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
		
		
		if base < 0 then
			base = 0
		end		
		
		return base
	end,
}


if(PLAYER) then
	if(not PLAYER:FindFirstChild("AlreadyBalanced")) then
		STATS.Tix = (math.max(averageValue, 500)*.9);
		Instance.new("IntValue", PLAYER).Name = "AlreadyBalanced";
	end
end


function experienceNeeded()
	return STATS.Level * 4
end

function getBaseMoveSpeed()
	return STATS:Get("Speed")
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
	local percentMoveSpeedMod = 0
	local foundAStun = false
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
	
	--do movement speed calculations
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
	HUMAN.MaxHealth = STATS:Get("Health")
end

local bfNames = {
	"GetStat",
	"SetStat",
	"GiveExperience",
	"GiveTix",
	"GetTix",
	"GetLevel",
	"GetExperience"
}

local bfs = {}

for _, bfName in pairs(bfNames) do
	bfs[bfName] = Instance.new("BindableFunction")
	bfs[bfName].Name = bfName
end

function bfs.GetStat.OnInvoke(statName)
	return STATS:Get(statName)
end

function setHealth(value)
	local delta = value - STATS["Health"]
	STATS["Health"] = value
	delay(0.25, function()
		HUMAN.Health = HUMAN.Health + delta
	end)
end

function bfs.SetStat.OnInvoke(statName, value)
	if statName == "Health" then
		setHealth(value)
	else
		STATS[statName] = value
	end
end



function giveExperience(amount)
	STATS.Experience = STATS.Experience + amount
	
	while STATS.Experience >= STATS.Level * 4 do
		STATS.Experience = STATS.Experience - STATS.Level * 4
		STATS.Level = STATS.Level + 1
		script.LeveledUp:Fire(STATS.Level)
	end
end

bfs.GiveExperience.OnInvoke = giveExperience;

function bfs.GiveTix.OnInvoke(amount)
	STATS.Tix = STATS.Tix + amount
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



for _, bf in pairs(bfs) do
	bf.Parent = script
end

function main()
	--make sure we have everything we need
	CHAR:WaitForChild("Head")
	
	game:GetService("RunService").Heartbeat:connect(loop)
	
	if PLAYER then
		playerState{
			TeamName = TEAM_NAME
		}
		
		giveExperience(averageExperience);
	end
end

main()
