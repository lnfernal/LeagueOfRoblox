workspace:WaitForChild("Map")
wait(50)
local Mobs = {}
local connection

local Mob = require(game.ReplicatedStorage.Classes.Mob)
local Types = game.ServerStorage.MobTypes:GetChildren()

function objectAdded(obj)
	if obj.Name == "MobSpawn" then
		delay(5, function()
			addMob(obj, Types[math.random(1,#Types)])
		end)
		game:GetService("Debris"):AddItem(obj, 0)
	end
end

function recurse(root)
	for _, child in pairs(root:GetChildren()) do
		objectAdded(child)
		recurse(child)
	end
end

function addMob(spawn, modelTemplate)
	local model = modelTemplate:Clone()
	model.Parent = workspace
	model:SetPrimaryPartCFrame(spawn.CFrame + Vector3.new(0, 4, 0))
	
	local mob = Mob:New{
		Model = model
	}
	
	table.insert(Mobs, {
		Mob = mob,
		Spawn = spawn,
		Model = modelTemplate,
	})
end

function main()
	workspace.DescendantAdded:connect(objectAdded)
	recurse(workspace)
	
	local function onHeartbeat(dt)
	
		for index, mobData in pairs(Mobs) do
			local mob = mobData.Mob
			if mob.Active then
				mob:Update(dt)
			else
				local spawn = mobData.Spawn
				local model = mobData.Model
				delay(85, function()
					addMob(spawn, model)
				end)
				
				table.remove(Mobs, index)
				
			end
		end
	end
	connection = game:GetService("RunService").Heartbeat:connect(onHeartbeat)
	function game.ServerScriptService.VictoryService.Regenerate.OnInvoke()
	Mobs = {}
	if connection then
		connection:Disconnect()
		connection = game:GetService("RunService").Heartbeat:connect(onHeartbeat)
	end
end
end

main()

