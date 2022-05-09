for _, child in pairs(script.Parent:GetChildren()) do
	if child:IsA("BasePart") then
		local cfv = Instance.new("CFrameValue")
		cfv.Value = child.CFrame
		cfv.Parent = script.Parent
		
		child:remove()
	end
end

game:GetService("Debris"):AddItem(script, 0)