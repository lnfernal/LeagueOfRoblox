local share = require(script.Parent.Humanoids)
local humanoids = share.Humanoids



function script.GetEnemies.OnInvoke(self,DetectionRange, teamName, getTurrets)
	if not teamName then
		return humanoids
	end
	
	local enemies = {}
	
	for _, human in pairs(humanoids) do
		local char = human.Parent
		local team = char:FindFirstChild("Team")
		local insert = false
		if char ~= self then  
		if (self.HumanoidRootPart.Position - char.HumanoidRootPart.Position).magnitude <= DetectionRange then
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
	end
	end
	return enemies
end
