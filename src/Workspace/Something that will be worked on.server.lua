workspace.DescendantAdded:Connect(function(part)
	if part:IsA("BasePart") or part:IsA("UnionOperation") or part:IsA("MeshPart") then
		
		if part.CustomPhysicalProperties then
			local oldProp = part.CustomPhysicalProperties			
			local physicalProp = PhysicalProperties.new(10, oldProp.Friction,0,oldProp.FrictionWeight,0)
			part.CustomPhysicalProperties = physicalProp
		else
		local physicalProp = PhysicalProperties.new(10,0.3,0,1, 0)
		part.CustomPhysicalProperties = physicalProp
		end
	end
end)