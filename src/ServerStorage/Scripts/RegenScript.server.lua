local CHAR = script.Parent
CHAR:WaitForChild("CharacterScript")
local HUMAN = CHAR:WaitForChild("Humanoid")
local HRP = CHAR.HumanoidRootPart
local PLAYER = game.Players:GetPlayerFromCharacter(CHAR)
local R = game.ReplicatedStorage.Remotes
local DS = game.ServerScriptService.DamageService
local STATUSES = CHAR:FindFirstChild("Statuses")
local PASSIVE = CHAR:FindFirstChild("Passives")
local TEAM = CHAR:FindFirstChild("GetTeam")
local CONTROL = CHAR:FindFirstChild("CharacterScript")
local Stats = require(game.ReplicatedStorage.PlayerStats:WaitForChild(CHAR.Name))
local Shields = Instance.new("NumberValue")
Shields.Parent = CHAR
Shields.Name = "Shield"
local MaxShields = Instance.new("NumberValue")
MaxShields.Parent = CHAR
MaxShields.Name = "MaxShields"
if PLAYER then
	TEAM = CHAR:WaitForChild("GetTeam")
end
local TEAM_NAME = ""
if TEAM then
	TEAM = TEAM:Invoke()
	TEAM_NAME = TEAM.Name
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

local function playerGet(key)
	local bp = PLAYER.Backpack
	local ps = bp:FindFirstChild("PlayerState")
	if ps and ps:FindFirstChild(key) then
		return ps[key].Value
	end
	return nil
end
local STUNNED = false
function loop(dt)
	local percentMoveSpeedMod = 0
	local foundAStun = false
	
	for _, status in pairs(STATUSES:GetChildren()) do
		--perform some logic based upon the type
	
		
		if status.Effect.Value == "Stun" then
			foundAStun = true
		end
		
		if status.Effect.Value == "DOT" then
			local dur = status.MaxTime.Value 
			local dps = status.Amount.Value
			local source = status.Source.Value
			local type = status.DamageType.Value
			DS.Damage:Invoke(HUMAN, (dps * dt), type, source,nil,nil,nil,true)
			
			
		end
		
		--deteriorate the effect's timer
		if status:FindFirstChild("TimeLeft") then
		if status then
		status.TimeLeft.Value = status.TimeLeft.Value - dt
		if status.TimeLeft.Value <= 0 then
			status:Destroy()
		end
		end
		end
		end
	
	for _, status in pairs(PASSIVE:GetChildren()) do
		--perform some logic based upon the type
		if status.Effect.Value == "PercentMoveSpeed" then
			percentMoveSpeedMod = percentMoveSpeedMod + status.Amount.Value
		end
		
		--deteriorate the effect's timer
		
	end
	
	MaxShields.Value = Stats.StatsGet("Shields")
	game.ServerScriptService.DamageService.Heal:Invoke(HUMAN, Stats.StatsGet("HealthRegen") * dt)
	--do movement speed calculations
	
	
		local spawnDistance = getSpawnDistance()
		local enSpawnDistance = getEnemySpawnDistance()
		
		local dead = HUMAN:FindFirstChild("Dead") ~= nil
		
		
		if spawnDistance < 24 then
			game.ServerScriptService.DamageService.Heal:Invoke(HUMAN, HUMAN.MaxHealth * .4 * dt)
		end
		
		if enSpawnDistance < 60 then
			game.ServerScriptService.DamageService.Damage:Invoke(HUMAN, HUMAN.MaxHealth)
		end
	
	if HRP.Position.Y < -10 then
		local gt = HUMAN.Parent:FindFirstChild("GetTeam")
		game.ServerScriptService.DamageService.Damage:Invoke(HUMAN, HUMAN.MaxHealth * .8)
		if gt then
			local team = gt:Invoke()
			if team then
				HUMAN.Parent:MoveTo(team:GetRandomSpawnPosition())
			end
		end
		end
	
	
end
game:GetService("RunService").Heartbeat:connect(loop)
HUMAN.HealthChanged:connect(function(health)
	if CHAR:FindFirstChild("Head") then
		local teamGui = CHAR.Head:FindFirstChild("TeamGui")
		if teamGui then
			local ratio = health / (HUMAN.MaxHealth + Shields.Value)
			local shieldratio = Shields.Value/(HUMAN.MaxHealth + Shields.Value)
			teamGui.HealthBar.Size = UDim2.new(teamGui.HealthFrame.Size.X.Scale * ratio, 0, teamGui.HealthFrame.Size.Y.Scale, 0)
			teamGui.ShieldBar.Size = UDim2.new(teamGui.HealthFrame.Size.X.Scale * shieldratio, 0, teamGui.HealthBar.Size.Y.Scale, 0)
			teamGui.ShieldBar.Position = UDim2.new(teamGui.HealthFrame.Size.X.Scale * ratio, 0, teamGui.HealthBar.Position.Y.Scale , 0)
		end
	end
end)
MaxShields.Changed:connect(function(value)
	if value > Shields.Value then
		Shields.Value = Shields.Value + (value - Shields.Value)
	elseif value < Shields.Value then
		Shields.Value = value
	end
end)
Shields.Changed:connect(function(value)
	if CHAR:FindFirstChild("Head") then
		local teamGui = CHAR.Head:FindFirstChild("TeamGui")
		if teamGui and HUMAN.Health == HUMAN.MaxHealth then
			local ratio = HUMAN.Health / (HUMAN.MaxHealth + Shields.Value)
			local shieldratio = Shields.Value/(HUMAN.MaxHealth + Shields.Value)
			teamGui.HealthBar.Size = UDim2.new(teamGui.HealthFrame.Size.X.Scale * ratio, 0, teamGui.HealthFrame.Size.Y.Scale, 0)
			teamGui.ShieldBar.Size = UDim2.new(teamGui.HealthFrame.Size.X.Scale * shieldratio, 0, teamGui.HealthBar.Size.Y.Scale, 0)
			teamGui.ShieldBar.Position = UDim2.new(teamGui.HealthFrame.Size.X.Scale * ratio, 0, teamGui.HealthBar.Position.Y.Scale , 0)
		end
	end
end)
STATUSES.ChildAdded:connect(function(status)
	if status:FindFirstChild("TimeLeft") then
			delay(status:FindFirstChild("TimeLeft").Value,function()
				if status then
					status:Destroy()
				end
			end)
		end
end)