function getParts(model)
	local parts = {}
	
	function recurse(root)
		for index, child in pairs(root:GetChildren()) do
			if child:IsA("BasePart") then
				table.insert(parts, child)
			end
			recurse(child)
		end
	end
	recurse(model)
	
	return parts
end

function moveModel(model, cframe)
	local center = model:GetModelCFrame()
	
	for _, part in pairs(getParts(model)) do
		local deltaFrame = center:toObjectSpace(part.CFrame)
		local newFrame = cframe:toWorldSpace(deltaFrame)
		part.CFrame = newFrame
	end
end

return moveModel