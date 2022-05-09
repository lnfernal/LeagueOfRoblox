local share = require(script.Parent.Humanoids)
local humanoids = share.Humanoids

function removeHumanoid(obj)
	local remInd = nil
	for index, humanoid in pairs(humanoids) do
		if obj == humanoid then
			remInd = index
			break
		end
	end
	
	if remInd ~= nil then
		table.remove(humanoids, remInd)
	end
end

workspace.DescendantAdded:connect(function(obj)
	if not obj:IsA("Humanoid") then return end
	if obj:IsA("Humanoid") then
		table.insert(humanoids, obj)
		obj.Died:connect(function()
			removeHumanoid(obj)
		end)
	end
end)

workspace.DescendantRemoving:connect(removeHumanoid)

function main()
	local function recurse(root)
		if root:FindFirstChild("Humanoid") then
				table.insert(humanoids, root.Humanoid)
			
			--recurse(root.Humanoid)
		end
	end
	recurse(workspace)
	
	local ready = Instance.new("BoolValue")
	ready.Name = "Ready"
	ready.Parent = script
end

function script.GetHumanoids.OnInvoke()
	local living = {}
	
	for _, human in pairs(humanoids) do
		if not human:FindFirstChild("Dead") then
			table.insert(living, human)
		end
	end
	
	return living
end

function script.GetPlayers.OnInvoke()
	local players = {}
	
	for _, human in pairs(humanoids) do
		if game.Players:GetPlayerFromCharacter(human.Parent) then
			if not human:FindFirstChild("Dead") then
				table.insert(players, human)
			end
		end
	end
	
	return players
end

function script.GetEnemies.OnInvoke(teamName, getTurrets)
	if not teamName then
		return humanoids
	end
	
	local enemies = {}
	
	for _, human in pairs(humanoids) do
		local char = human.Parent
		local team = char:FindFirstChild("Team")
		local insert = false
		
		if team then
			if team.Value ~= teamName then
				insert = true

				if char.Name == "Turret" then
					insert = getTurrets
				end
			end
		else
			insert = true
		end
		
		if insert then
			if not human:FindFirstChild("Dead") then
				table.insert(enemies, human)
			end
		end
	end
	
	return enemies
end

main()