wait(2)
for i,v in pairs(game.ReplicatedStorage.Characters:GetChildren()) do
	if v.ClassName == "Model" then
		print("yup")
		if v:FindFirstChild("RequiredLevel") then
	v.RequiredLevel.Value = 1
	end
	
	end
end

