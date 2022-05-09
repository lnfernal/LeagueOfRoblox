wait(0.5)

local MONSTER = script.Parent
local HRP = MONSTER.HumanoidRootPart
local HUMAN = MONSTER.Humanoid



local walkAnim = Instance.new("Animation")
walkAnim.AnimationId = "http://www.roblox.com/MinionWalkingFinal-item?id=263131959"
--walkAnim.Parent = HUMAN
--local WALK = HUMAN:LoadAnimation(walkAnim)

local punchAnim = Instance.new("Animation")
punchAnim.AnimationId = "https://www.roblox.com/GolemAnimation-item?id=436447873"
--punchAnim.Parent = HUMAN
--local PUNCH = HUMAN:LoadAnimation(punchAnim)

local DS = game.ServerScriptService.DamageService

local DETECTION_DISTANCE = 32
local MELEE_RANGE = 6

local STATE = "Waiting"

--waiting state variables
local WAIT_POS = HRP.Position

--chasing state variables
local TARGET = nil

local PAUSE_TIME = 0
local PAUSE_QUEUE = {}

local SecondsChasedWithoutHit = 0
local ChaseWithoutHitGiveUp = 2

local hitSound = require(game.ServerStorage.HitSound)
local getHumans = game.ServerScriptService.HumanoidService.GetHumanoids
local getEnemies = game.ServerScriptService.HumanoidService.GetEnemies
local getPlayers = game.ServerScriptService.HumanoidService.GetPlayers

function getStat(statName)
	local gs = MONSTER:FindFirstChild("GetStat", true)
	if gs then
		return gs:Invoke(statName)
	end
	
	return 0
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

function getNearestHumanoid()
	local humans = getPlayers:Invoke()
	
	local best = nil
	local bestDistance = DETECTION_DISTANCE
	
	for _, human in pairs(humans) do
		if human.Parent:FindFirstChild("HumanoidRootPart") then
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
		if distanceTo(WAIT_POS) > DETECTION_DISTANCE then
			STATE = "Returning"
		end
		
		if STATE == "Returning" then
			moveTo(WAIT_POS)
			DS.GolemHeal:Invoke(HUMAN, 50 * dt)
			
			if distanceTo(WAIT_POS)  < DETECTION_DISTANCE / 2 then
				STATE = "Waiting"
			end
		elseif STATE == "Waiting" then		
			moveTo(WAIT_POS)
			DS.GolemHeal:Invoke(HUMAN, 50 * dt)
			
			if distanceTo(WAIT_POS) < 2 then
				--WALK:Stop()
			end
			
			TARGET = getNearestHumanoid()
			if TARGET then
				STATE = "Chasing"
				--WALK:Play()
			end
		elseif STATE == "Chasing" then
			TARGET = getNearestHumanoid()
			if TARGET then
				local targetPos = TARGET.Parent.HumanoidRootPart.Position
				
				moveTo(targetPos)
				SecondsChasedWithoutHit = SecondsChasedWithoutHit + dt
				if distanceTo(targetPos) < MELEE_RANGE then
					--WALK:Stop()
					--PUNCH:Play()
					
					pcall(function() DS.Damage:Invoke(TARGET, getStat("Skillz"), "Toughness") end)
					stopMoving()
					
					pause(1, function()
						--WALK:Play()
					end)
					
					SecondsChasedWithoutHit = 0
				end
				
				if SecondsChasedWithoutHit > ChaseWithoutHitGiveUp then
					SecondsChasedWithoutHit = 0
					STATE = "Returning"
				end
			else
				STATE = "Waiting"
			end
		end
	end
end

function died()
	local killer = HUMAN:FindFirstChild("KillCredit")
	if killer then
		killer = killer.Value
		local char = killer.Character
		if char then
			local giveExp = char:FindFirstChild("GiveExperience", true)
			local giveTix = char:FindFirstChild("GiveTix", true)
			if giveExp and giveTix then
				giveExp:Invoke(getStat("ExpReward"))
				giveTix:Invoke(getStat("TixReward"))
				
				local human = char:FindFirstChild("Humanoid")
				if human then
					DS.GolemHeal:Invoke(human, human.MaxHealth * 0.075)
				end
			end
		end
	end
	
	local d = game:GetService("Debris")
	d:AddItem(MONSTER, 1)
	d:AddItem(script, 0)
end

function main()
	game.ServerScriptService.TeamScript.GetTeamByName:Invoke("Neutral Team"):CreateTeamGui(MONSTER)
	script.Tick.OnInvoke = tick
	HUMAN.Died:connect(died)
	
	game.ServerScriptService.BalanceService.AddCharacter:Invoke(MONSTER)
end

main()