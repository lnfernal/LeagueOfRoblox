local CHAR = script.Parent
CHAR:WaitForChild("CharacterScript")
local HUMAN = CHAR:WaitForChild("Humanoid")
local HRP = CHAR.HumanoidRootPart
local PLAYER = game.Players:GetPlayerFromCharacter(CHAR)
local R = game.ReplicatedStorage.Remotes
local DS = game.ServerScriptService.DamageService
local TEAM = CHAR:FindFirstChild("GetTeam")
local CONTROL = CHAR:FindFirstChild("CharacterScript")

local TEAM = CHAR:FindFirstChild("GetTeam")
TEAM = CHAR:WaitForChild("GetTeam")

local TEAM_NAME = ""
if TEAM then
	TEAM = TEAM:Invoke()
	TEAM_NAME = TEAM.Name
end


local Stats = require(game.ReplicatedStorage.PlayerStats:WaitForChild(CHAR.Name))
local getType = require(game.ReplicatedStorage.GetType)
local STATS = Stats.Stats
function playerState(args)
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
function getSpawnDistance()
	local a = HRP.Position
	local b = TEAM.SpawnPosition
	
	return (b - a).magnitude
end
function experienceNeeded()
	return STATS.Level * 4
end

function loop(dt)
	local spawnDistance = getSpawnDistance()
		
		local dead = HUMAN:FindFirstChild("Dead") ~= nil
		
		playerState{
			--Health = HUMAN.Health,
			--MaxHealth = HUMAN.MaxHealth,
			--Speed = HUMAN.WalkSpeed,
			--Skillz = Stats.StatsGet("Skillz"),
			--H4x = Stats.StatsGet("H4x"),
			--Toughness = Stats.StatsGet("Toughness"),
			--Resistance = Stats.StatsGet("Resistance"),
			--Level = STATS.Level,
			--MaxExp = experienceNeeded(),
			--Exp = STATS.Experience,
			--Tix = STATS.Tix,
			TeamKills = TEAM:GetTeamStat("Kills"),
			EnTeamKills = TEAM:GetOtherTeam():GetTeamStat("Kills"),
			Kills = STATS.Kills,
			Deaths = STATS.Deaths,
			Assists = STATS.Assists,
			InShopRange = (spawnDistance < 96) or dead,
			--HealthRegen = Stats.StatsGet("HealthRegen"),
		}
end
game:GetService("RunService").Heartbeat:connect(loop)