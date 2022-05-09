wait(0.5)

local R = game.ReplicatedStorage.Remotes

local MINION = script.Parent
local HRP = MINION.HumanoidRootPart
local HUMAN = MINION.Humanoid
local MINIONTORSO = MINION["Torso"]

local walkAnim = Instance.new("Animation")
walkAnim.AnimationId = "http://www.roblox.com/asset/?id=180426354"
walkAnim.Parent = HUMAN
local WALK = HUMAN:LoadAnimation(walkAnim)

local punchAnim = Instance.new("Animation")
punchAnim.AnimationId = "http://www.roblox.com/MinionPunchFinal-item?id=263132183"
punchAnim.Parent = HUMAN
local PUNCH = HUMAN:LoadAnimation(punchAnim)

local DS = game.ServerScriptService.DamageService

local DETECTION_DISTANCE = 48
local MELEE_RANGE = 6

local RANGED = false
local RANGED_RANGE = 24

local STATE = "Pathing"

--pathing state variables
local PATH = MINION.Path.Value
local VISITED = {}
local CURRENT = nil
local ARRIVAL_DISTANCE = 12

--chasing state variables
local TARGET = nil

local PAUSE_TIME = 0
local PAUSE_QUEUE = {}

local hitSound = require(game.ServerStorage.HitSound)
local getEnemies = game.ServerScriptService.GetNearbyEnemies.GetEnemies
local getClosestTeam = game.ServerScriptService.TeamScript.GetClosestTeam
local sfx = game.ServerScriptService.SFXService
--local Mobs = require(game.ServerScriptService.UnitedCharacterScript)
local collider = Instance.new("Part")
collider.Shape = "Ball"
collider.Size = Vector3.new(3, 3, 3)
collider.Transparency = 1
--collider.Parent = MINION
--local w = Instance.new("Weld")
--w.Part0 = HRP
--w.Part1 = collider
--w.Parent = HRP

if MINION:FindFirstChild("Ranged") then
	RANGED = true
end
function In(tab,stuff,object,thing)
	thing = thing or "Functions"
	for _,v in pairs(tab) do
		if v[stuff] == object then
			return v[thing]
		end
	end
end
--[[function getStat(statName)
	local getStat = In(Mobs.Mobs,"Character",MINION)
	if getStat then
		return getStat:GetStat(statName)
	end
	
	return 0
end

function setStat(statName, value)
	local setStat = In(Mobs.Mobs,"Character",MINION)
	if setStat then
		setStat:SetStat(statName, value)
		return true
	end
	
	return false
end]]

function getStat(statName)
	local getStat = MINION:FindFirstChild("GetStat", true)
	if getStat then
		return getStat:Invoke(statName)
	end
	
	return 0
end

function setStat(statName, value)
	local setStat = MINION:FindFirstChild("SetStat", true)
	if setStat then
		setStat:Invoke(statName, value)
		return true
	end
	
	return false
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

function getUnvisitedWaypoints()
	local waypoints = PATH:GetChildren()
	local unvisited = {}
	
	for _, waypoint in pairs(waypoints) do
		if not inList(waypoint, VISITED) then
			table.insert(unvisited, waypoint)
		end
	end
	
	return unvisited
end

function nearestUnvisitedWaypoint()
	local unvisited = getUnvisitedWaypoints()
	if #unvisited == 0 then return nil end
	
	local best = unvisited[1]
	local bestDistance = distanceTo(best.Position)
	
	for _, waypoint in pairs(unvisited) do
		local dist = distanceTo(waypoint.Position)
		if dist < bestDistance then
			best = waypoint
			bestDistance = dist
		end
	end
	
	return best
end

function getNearestHumanoid()
	local humans = getEnemies:Invoke(MINION,DETECTION_DISTANCE,MINION.Team.Value, true)
	
	local best = nil
	local bestDistance = DETECTION_DISTANCE
	if humans == nil then return best end
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

function arrived()
	table.insert(VISITED, CURRENT)
	CURRENT = nil
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

function fireOnHumanoid(human)
	local char = human.Parent
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
		game.ServerScriptService.SFXService.RayShot:Invoke(MINION["Right Arm"].Position, hrp.Position,MINIONTORSO.BrickColor.Color, 0.1,0.5)
					pcall(function() DS.Damage:Invoke(TARGET, getStat("Skillz"), "Toughness") end)
					pcall(function() DS.Damage:Invoke(TARGET, getStat("H4x"), "Resistance") end) 
			
		end
	end
end

function tick(dt)
	if paused() then
		pauseTick(dt)
	else
		if STATE == "Pathing" then
			if CURRENT then
				moveTo(CURRENT.Position)
				
				--check to see if we've arrived
				if distanceTo(CURRENT.Position) < ARRIVAL_DISTANCE then
					arrived()
				end
			else
				CURRENT = nearestUnvisitedWaypoint()
			end
			
			TARGET = getNearestHumanoid()
			if TARGET then
				STATE = "Chasing"
				
				if RANGED then
					STATE = "RangedChasing"
				end
			end
		elseif STATE == "Chasing" then
			TARGET = getNearestHumanoid()
			if TARGET then
				local targetPos = TARGET.Parent.HumanoidRootPart.Position
				
				moveTo(targetPos)
				if distanceTo(targetPos) < MELEE_RANGE then
					WALK:Stop()
					MINIONTORSO.Anchored = true
					PUNCH:Play()
					
					pcall(function() DS.Damage:Invoke(TARGET, getStat("Skillz"), "Toughness") end)
					pcall(function() DS.Damage:Invoke(TARGET, getStat("H4x"), "Resistance") end)
					stopMoving()
					
					pause(1, function()
						MINIONTORSO.Anchored = false
						WALK:Play()
					end)
				end
			else
				STATE = "Pathing"
			end
		elseif STATE == "RangedChasing" then
			pause(0.3,function()
			TARGET = getNearestHumanoid()
			if TARGET then
				local targetPos = TARGET.Parent.HumanoidRootPart.Position
				
				moveTo(targetPos)
				if distanceTo(targetPos) < RANGED_RANGE then
					WALK:Stop()
					PUNCH:Play()
					
					fireOnHumanoid(TARGET)
					stopMoving()
					
					pause(1, function()
						WALK:Play()
					end)
				
				end
			else
				STATE = "Pathing"
			end
			end)
		end
	end
end

function died()
	local ds = game.ServerScriptService.DamageService
	
	local center = HRP.Position
	local radius = 50
	local team = MINION.Team.Value
	local benefactors = {}
	local givenExp = getStat("ExpReward")
	local givenTix = getStat("TixReward")
	local function onHit(enemy)
		local player = game.Players:GetPlayerFromCharacter(enemy.Parent)
		if not player then return end
		
		local charScript = enemy.Parent:FindFirstChild("CharacterScript")
		if charScript then
			local giveExp = charScript:FindFirstChild("GiveExperience")
			local giveTix = charScript:FindFirstChild("GiveTix")
			if giveExp and giveTix then   
				table.insert(benefactors, {Exp = giveExp, Tix = giveTix, Player = player})
			end
		end
	end
	ds.AOE:Invoke(center, radius, team, onHit)
	local num = #benefactors
	if num > 0 then
		for _, benefactor in pairs(benefactors) do
			
			local e = givenExp 
			local t = givenTix 
			benefactor.Exp:Invoke(e)
			benefactor.Tix:Invoke(t)
 
			e = tostring(e):sub(1, 4)
			t = tostring(t):sub(1, 4)	
			local msg = "+"..e.." Exp, +"..t.." Tix"
			R.SFX.RisingMessage:FireClient(benefactor.Player, MINION.Head.Position + Vector3.new(0, 1, 0), msg, 3, {TextColor3 = Color3.new(1, 1, 0)})	 
		end 
	end
	--w:Destroy()
	MINION["Right Arm"].CanCollide = false
	MINION["Left Arm"].CanCollide = false
	MINION["Right Leg"].CanCollide = false
	MINION["Left Leg"].CanCollide = false
	MINION.collider.CanCollide = false
	HRP.CanCollide = false
	MINION.Head.CanCollide = false
	collider.CanCollide = false
	MINIONTORSO.CanCollide = false
	
	--game:GetService("Debris"):AddItem(MINION, 1)
	--game:GetService("Debris"):AddItem(script, 0)	
end

function main()
	script.Tick.OnInvoke = tick
	HUMAN.Died:connect(died)
	
	local team = getClosestTeam:Invoke(HRP.Position)
	team:AddCharacter(MINION)
	MINION.Torso.BrickColor = team.Color
	
	if RANGED then
		for _, obj in pairs(MINION:GetChildren()) do
			if obj:IsA("CharacterAppearance") then
				obj:Destroy()
			end
		end
	end
		
	WALK:Play()
	
	game.ServerScriptService.BalanceService.AddCharacter:Invoke(MINION)
end

main()