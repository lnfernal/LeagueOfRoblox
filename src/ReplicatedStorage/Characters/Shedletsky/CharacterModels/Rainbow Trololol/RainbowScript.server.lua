while true do
	for _, part in pairs(script.Parent:GetChildren()) do
		if part:IsA("BasePart") then
			part.BrickColor = BrickColor.palette(math.random(0, 63))
		end
	end
	wait(0.5)
end