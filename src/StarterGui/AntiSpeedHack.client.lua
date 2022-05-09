local player = script.Parent.Parent
while wait(0.5) do
	if workspace:GetRealPhysicsFPS() > 62.5 then
		player:FindFirstChild("Kick"):InvokeServer()
	end
end
