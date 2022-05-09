wait(0.5)

local MINION = script.Parent
local HRP = MINION.HumanoidRootPart
local HUMAN = MINION.Humanoid

local SOUND_ID = "http://www.roblox.com/asset/?id=12222058"
local PITCH = 0.5

--animation stuff
local ANIMATOR = MINION.AnimationController

local walkAnim = Instance.new("Animation")
walkAnim.AnimationId = "http://www.roblox.com/MinionWalkingFinal-item?id=263131959"
local WALK = ANIMATOR:LoadAnimation(walkAnim)

local punchAnim = Instance.new("Animation")
punchAnim.AnimationId = "http://www.roblox.com/MinionPunchFinal-item?id=263132183"
local PUNCH = ANIMATOR:LoadAnimation(punchAnim)
--/animation stuff

local DETECTION_DISTANCE = 32
local MELEE_DISTANCE = 6

local MY_TEAM = nil

local GET_HUMANOIDS = game.ServerScriptService.HumanoidService.GetHumanoids

--pathing variables
local PATH = MINION.Path.Value
local VISITED = {}
local CURRENT_WAYPOINT = nil
local ARRIVAL_DISTANCE = 12

local hitSound = require(game.ServerStorage.HitSound)

function nearestUnvisitedWaypoint()
	local waypoints = PATH:GetChildren()
	local best = nil
	local bestDistance = 100000
	
	for _, waypoint in pairs(waypoints) do
		--check to see if I've visited this one
		local visited = false
		for _, check in pairs(VISITED) do
			if check == waypoint then
				visited = true
			end
		end
		
		if not visited then
			local dist = (waypoint.Position - HRP.Position).magnitude
			
			if dist < bestDistance then
				best = waypoint
				bestDistance = dist
			end
		end
	end
	
	return best
end

function getEnemyHumans()
	local humans = GET_HUMANOIDS:Invoke()
	local enemies = {}
	
	for _, human in pairs(humans) do
		local char = human.Parent
		local team = char:FindFirstChild("Team")
		
		if team then
			if team.Value ~= MY_TEAM.Name then
				table.insert(enemies, human)
			end
		end
	end
	
	return enemies
end

function getNearestHumanoid()
	local humans = getEnemyHumans()
	
	local bestHuman = nil
	local bestDistance = DETECTION_DISTANCE
	
	for _, human in pairs(humans) do
		if human.Health > 0 then
			local char = human.Parent
			local hrp = char:FindFirstChild("HumanoidRootPart")
			
			if hrp then
				local dist = (hrp.Position - HRP.Position).magnitude
				
				if dist < bestDistance then
					bestHuman = human
					bestDistance = dist
				end
			end
		end
	end
	
	return bestHuman
end

function stopMoving()
	HUMAN:MoveTo(HRP.Position, workspace.GlobalMover)
end

function travelPath()
	WALK:Play()
	
	CURRENT_WAYPOINT = nearestUnvisitedWaypoint()
	while CURRENT_WAYPOINT do		
		local dist = ARRIVAL_DISTANCE + 1
		while dist > ARRIVAL_DISTANCE do
			--basic pathing stuff
			HUMAN:MoveTo(CURRENT_WAYPOINT.Position, workspace.GlobalMover)
			dist = (CURRENT_WAYPOINT.Position - HRP.Position).magnitude			
			wait()
			
			--fighting stuff
			local enemy = getNearestHumanoid()
			if enemy then
				while getNearestHumanoid() == enemy do
					local enhrp = enemy.Parent.HumanoidRootPart
					HUMAN:MoveTo(enhrp.Position, workspace.GlobalMover)
					
					local enemyDist = (enhrp.Position - HRP.Position).magnitude
					if enemyDist < MELEE_DISTANCE then
						stopMoving()
						WALK:Stop()
						PUNCH:Play()
						
						enemy:TakeDamage(10)
						hitSound(enemy)
						wait(0.75)
						
						WALK:Play()
					end
					
					wait()
				end
			end
		end
		
		table.insert(VISITED, CURRENT_WAYPOINT)
		CURRENT_WAYPOINT = nearestUnvisitedWaypoint()
	end
end

function characterDied()
	local sound = Instance.new("Sound")
	sound.SoundId = SOUND_ID
	sound.Pitch = PITCH
	sound.Volume = 0.25
	sound.Parent = HRP
	sound:Play()
	
	game:GetService("Debris"):AddItem(MINION, 1)
	game:GetService("Debris"):AddItem(script, 0)
end

function main()
	MINION.Name = "Minion"
	
	--team setup
	MY_TEAM = game.ServerScriptService.TeamScript.GetClosestTeam:Invoke(HRP.Position)
	MY_TEAM:AddNonPlayer(MINION)
	MINION.Torso.BrickColor = MY_TEAM.Color
	
	HUMAN.Died:connect(characterDied)
	
	travelPath()
end

main()