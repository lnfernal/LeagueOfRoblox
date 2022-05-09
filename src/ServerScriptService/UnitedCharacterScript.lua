local Monster = {}
Monster.Mobs = {}


function Monster:CharacterScript(character)
local CHAR = character
local HUMAN = CHAR:WaitForChild("Humanoid")
local HRP = CHAR.HumanoidRootPart


local R = game.ReplicatedStorage.Remotes

local DS = game.ServerScriptService.DamageService

--generate a model to hold statuses
local STATUSES = Instance.new("Model")
STATUSES.Name = "Statuses"
STATUSES.Parent = CHAR


local TEAM = CHAR:FindFirstChild("GetTeam")
local TEAM_NAME = ""
if TEAM then
	TEAM = TEAM:Invoke()
	TEAM_NAME = TEAM.Name
end

local INVENTORY = Instance.new("Model", CHAR)
INVENTORY.Name = "Inventory"

--some globals
local STUNNED = false


--ability script


--other services
local TIMER_SERVICE = game.ServerScriptService.TimerService




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





function getBaseMoveSpeed()
	return STATS:Get("Speed")
end




local function psVal(t, n, p)
	local val = Instance.new(t.."Value")
	val.Name = n
	val.Parent = p
end

local getType = require(game.ReplicatedStorage.GetType)





local function loop(dt)
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
	--print(HUMAN.MaxHealth)

end



local bfs = {}



function bfs:GetStat(statName)
	return STATS:Get(statName)
end


function bfs:SetStat(statName, value)
	if statName == "Health" then
			local delta = value - STATS["Health"]
	
	STATS["Health"] = value
	
	delay(0.25, function()
		HUMAN.Health = HUMAN.Health + delta
	end)
		
	else
		STATS[statName] = value
		
	end
end




	



	--make sure we have everything we need
	
	local min = game:GetService("RunService").Heartbeat:connect(loop)
	HUMAN.Died:connect(function()
	min:Disconnect()
	end)
	table.insert(Monster.Mobs,{Character = CHAR, Functions = bfs,Stats = STATS})

end

return Monster