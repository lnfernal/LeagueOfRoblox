function playSound(object, id, volume, pitch,TimePosition)
	if object then
		local sound = Instance.new("Sound")
		sound.SoundId = "http://www.roblox.com/asset/?id="..id
		sound.Volume = volume or 0.5
		sound.Pitch = pitch or 1
		sound.TimePosition = TimePosition or 0
		if object:IsA("BasePart") then
			sound.Parent = object
		elseif object:IsA("Humanoid") then
			if object.Parent then
				sound.Parent = object.Parent:FindFirstChild("HumanoidRootPart")
			end
		else
			sound.Parent = object
		end
		local duration = sound.TimeLength
		sound:Play()
		game:GetService("Debris"):AddItem(sound,duration)
	end
end

return playSound