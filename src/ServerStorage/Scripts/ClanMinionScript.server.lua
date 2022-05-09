wait(0.5)

local MINION = script.Parent
local HRP = MINION.HumanoidRootPart
local HUMAN = MINION.Humanoid
local teams = MINION:WaitForChild("Team").Value
local health = MINION:WaitForChild("Health").Value
local damage = MINION:WaitForChild("Damage").Value

local VISITED = {}
local CURRENT = nil
local ARRIVAL_DISTANCE = 12


local walkAnim = Instance.new("Animation")
walkAnim.AnimationId = "http://www.roblox.com/asset/?id=180426354"
walkAnim.Parent = HUMAN
local WALK = HUMAN:LoadAnimation(walkAnim)

local punchAnim = Instance.new("Animation")
punchAnim.AnimationId = "http://www.roblox.com/MinionPunchFinal-item?id=263132183"
punchAnim.Parent = HUMAN
local PUNCH = HUMAN:LoadAnimation(punchAnim)

local DS = game.ServerScriptService.DamageService

local DETECTION_DISTANCE = 2000
local MELEE_RANGE = 6

local STATE = "Pathing"

--chasing state variables
local TARGET = nil

local PAUSE_TIME = 0
local PAUSE_QUEUE = {}

local hitSound = require(game.ServerStorage.HitSound)
local getEnemies = game.ServerScriptService.HumanoidService.GetEnemies
local getClosestTeam = game.ServerScriptService.TeamScript.GetTeamByName

function getStat(statName)
	local getStat = MINION:FindFirstChild("GetStat", true)
	if getStat then
		return getStat:Invoke(statName)
	end
	
	return 7.5
end

function setStat(statName, value)
	repeat wait() until MINION:FindFirstChild("SetStat", true)
	local setStat = MINION:FindFirstChild("SetStat", true)
	if setStat then
		setStat:Invoke(statName, value)
		return true
	end
	
	
end

function distanceTo(point)
	return (point - HRP.Position).magnitude
end

function inList(value, list)
	for _, item in pairs(list) do
		if item == value then
			return true
		end
	end
	return false
end


function arrived()
	table.insert(VISITED, CURRENT)
	CURRENT = nil
end


function getNearestHumanoid()
	local humans = getEnemies:Invoke(MINION.Team.Value, true)
	
	local best = nil
	local bestDistance = DETECTION_DISTANCE
	
	for _, human in pairs(humans) do
		if human.Parent:FindFirstChild("HumanoidRootPart") and human.Parent:FindFirstChild("Team") then
			local pos = human.Parent.HumanoidRootPart.Position
			local dist = distanceTo(pos)
			if dist < bestDistance then
				best = human
				bestDistance = dist
			end
		end
	end
	
	return best
end

function moveTo(point)
	HUMAN:MoveTo(point, workspace.GlobalMover)
end

function stopMoving()
	moveTo(HRP.Position)
end

function paused()
	return PAUSE_TIME > 0
end

function pause(duration, func)
	PAUSE_TIME = duration
	if func then
		table.insert(PAUSE_QUEUE, func)
	end
end

function pauseTick(dt)
	PAUSE_TIME = PAUSE_TIME - dt
	if PAUSE_TIME <= 0 then
		PAUSE_TIME = 0
		
		for _, func in pairs(PAUSE_QUEUE) do
			func()
		end
		PAUSE_QUEUE = {}
	end
end

function tick(dt)
	if paused() then
		pauseTick(dt)
	else
		if STATE == "Pathing" then
			TARGET = getNearestHumanoid()
			if TARGET then
				STATE = "Chasing"
			end
		elseif STATE == "Chasing" then
			TARGET = getNearestHumanoid()
			if TARGET then
				local targetPos = TARGET.Parent.HumanoidRootPart.Position
				
				moveTo(targetPos)
				if distanceTo(targetPos) < MELEE_RANGE then
					WALK:Stop()
					PUNCH:Play()
					
					pcall(function() DS.Damage:Invoke(TARGET, getStat("Skillz"), "Toughness") end)
					stopMoving()
					
					pause(1, function()
						WALK:Play()
					end)
				end
			else
				STATE = "Pathing"
			end
		end
	end
end

function died()
	local ds = game.ServerScriptService.DamageService
	local center = HRP.Position
	local radius = 64
	local team = MINION.Team.Value
	local benefactors = {}
	local givenExp = 0.5
	local givenTix = 7
	local function onHit(enemy)
		if not game.Players:GetPlayerFromCharacter(enemy.Parent) then return end
		
		local charScript = enemy.Parent:FindFirstChild("CharacterScript")
		if charScript then
			local giveExp = charScript:FindFirstChild("GiveExperience")
			local giveTix = charScript:FindFirstChild("GiveTix")
			if giveExp and giveTix then
				table.insert(benefactors, {Exp = giveExp, Tix = giveTix})
			end
		end
	end
	ds.AOE:Invoke(center, radius, team, onHit)
	local num = #benefactors
	if num > 0 then
		for _, benefactor in pairs(benefactors) do
			benefactor.Exp:Invoke(givenExp / num)
			benefactor.Tix:Invoke(givenTix / num)
		end
	end
	
	local d = game:GetService("Debris")
	d:AddItem(MINION, 1)
	d:AddItem(script, 0)
end

function main()
	script.Tick.OnInvoke = tick
	HUMAN.Died:connect(died)
	WALK:Play()
	local team = getClosestTeam:Invoke(teams)
	team:AddCharacter(MINION)
	MINION.Torso.BrickColor = team.Color
	
	script.Name = "MinionScript"
	MINION.Name = "Minion"
	setStat("Skillz",damage)
	setStat("Health",health)
end

main()