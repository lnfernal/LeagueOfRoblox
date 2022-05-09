function stealth(parts, duration)

	
	
	for _, data in pairs(parts) do
		if data.Part.Name ~= "HumanoidRootPart" then
		data.Part.Transparency = 0.5
		end
	end
	delay(duration, function()
		for _, data in pairs(parts) do
			data.Part.Transparency = data.Transparency
		end
	end)
end
game.ReplicatedStorage.Remotes.Stealth.OnClientEvent:connect(stealth)