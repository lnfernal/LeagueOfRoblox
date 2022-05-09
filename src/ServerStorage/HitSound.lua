function hitSound(object, pitch)
	if object then
		local sound = Instance.new("Sound")
		sound.SoundId = "http://www.roblox.com/asset/?id=12222170"
		sound.Volume = 0.25
		sound.Pitch = pitch or 0.25
		
		if object:IsA("BasePart") then
			sound.Parent = object
		elseif object:IsA("Humanoid") then
			sound.Parent = object.Parent:FindFirstChild("HumanoidRootPart")
		end
		
		sound:Play()
		game:GetService("Debris"):AddItem(sound)
	end
end

return hitSound