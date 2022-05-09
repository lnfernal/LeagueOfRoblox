workspace:WaitForChild("Map")

local TURRET = game.ServerStorage.Turret
local MINION = game.ServerStorage.Minion 
local MINIONBODY = MINION["Head"] and MINION["HumanoidRootPart"] and MINION["Torso"] and MINION["Left Arm"] and MINION["Right Arm"] and MINION["Right Leg"] and MINION["Left Leg"]
local MINION_SPAWNS = {}
local MINIONS_PER_WAVE = 6
local WAVE_COOLDOWN = 30
local MINIONS = {}
local MINION_CAP = 108
local paths = {}
local moveModel = require(game.ServerStorage.MoveModel)
--local Mobs = require(script.Parent.UnitedCharacterScript)
function In(tab,stuff,object)
	for i,v in pairs(tab) do
		if v[stuff] == object then
			table.remove(tab,i)
			break
		end
	end
end
for index, child in pairs(workspace.Map.Spawns:GetChildren()) do
	if child.Name == "TurretSpawn" then
		local c = child.CFrame
		child:Destroy()
		
		local newTurret = TURRET:Clone()
		newTurret.Parent = workspace
		moveModel(newTurret, c + Vector3.new(0, 10, 0))
		newTurret:MakeJoints()
		--Mobs:CharacterScript(newTurret)
	end
	
	if child.Name == "MinionSpawn" then
		local c = child.CFrame
		local p = workspace.Map:FindFirstChild(child.PathName.Value)
		table.insert(MINION_SPAWNS, {CFrame = c, Path = p})
		child:Destroy()
	end
end

for i,v in pairs(workspace.Map:GetChildren()) do
	if v.Name:match("Path") == "Path" then
		table.insert(paths,v)
	end
end

function spawnMinion(pair)
	if #MINIONS > MINION_CAP then
		return nil
	end
	
	local c = pair.CFrame
	local p = pair.Path
	
	local pathRef = Instance.new("ObjectValue")
	pathRef.Name = "Path"
	pathRef.Value = p
	local newMinion = MINION:Clone()
	--Mobs:CharacterScript(newMinion)
	pathRef.Parent = newMinion
	newMinion.Parent = workspace
	newMinion:MoveTo(c.p + Vector3.new(0,3,0))
	--newMinion:MakeJoints()
	
	
	
	return newMinion
end

function minionDied(minion)
	for index, check in pairs(MINIONS) do
		if minion == check then
			MINIONBODY.CanCollide = false
			table.remove(MINIONS, index)
			
			break
		end
	end
end

function getclosestpath(minion)
	local best = math.huge
	local path = nil
	local tru = Vector3.new(0,0,0)
	local hrp = minion:FindFirstChild("HumanoidRootPart")
	if hrp then
	for i,theonlypaths in pairs(paths) do
		print(i)
		for z,places in pairs(theonlypaths:GetChildren()) do
			local mag = (places.Position - hrp.Position).magnitude
			print(mag)
			if best > mag then
				best = mag
				
				path = theonlypaths
				
				tru = places.Position
			end
		end
	end
	print(best)
	print(path.Name)
	print(tru)
	return path,tru
	end

end
script.AddMinion.OnInvoke = function(minion)
	table.insert(MINIONS, minion)
	local pathRef = Instance.new("ObjectValue")
	--[[local path,pos = getclosestpath(minion)
	pathRef.Name = "Path"
	pathRef.Value = path
	pathRef.Parent = minion
	local waypointRef = Instance.new("Vector3Value")
	waypointRef.Name = "waypointRef"
	waypointRef.Value = pos
	waypointRef.Parent = minion]]
	minion.Humanoid.Died:connect(function()
					game:GetService("Debris"):AddItem(minion, 1)
					game:GetService("Debris"):AddItem(minion:FindFirstChild("MinionScript"), 0)
					minionDied(minion)
				end)
end

local pulse = 0
local threshold = 0.25
game:GetService("RunService").Heartbeat:connect(function(dt)
	pulse = pulse + dt
	if pulse > threshold then
		for _, minion in pairs(MINIONS) do
			if minion:FindFirstChild("MinionScript") then
				
				if minion.MinionScript:FindFirstChild("Tick") then
					
					if minion:FindFirstChild("Team") then
						
						minion.MinionScript.Tick:Invoke(pulse)
					end
				end
			end
		end
		pulse = 0
	end
end)

wait(5)
game.ServerScriptService.MessageService:WaitForChild("MessageAll"):Invoke("45 seconds until mobs spawn!", "Take this time to formulate your strategies!")
wait(10)

while true do
	for minions = 1, MINIONS_PER_WAVE do
		for _, pair in pairs(MINION_SPAWNS) do
			local minion = spawnMinion(pair)
			if minion then
				if minions > 4 then
					local ranged = Instance.new("BoolValue")
					ranged.Name = "Ranged"
					ranged.Parent = minion
				end
				
				table.insert(MINIONS, minion)
				minion.Humanoid.Died:connect(function()
					game:GetService("Debris"):AddItem(minion, 1)
					game:GetService("Debris"):AddItem(minion:FindFirstChild("MinionScript"), 0)
					MINIONBODY.CanCollide = false
					minionDied(minion)
				end)
			end
		end
		wait(2)
	end
	
	wait(WAVE_COOLDOWN)
end