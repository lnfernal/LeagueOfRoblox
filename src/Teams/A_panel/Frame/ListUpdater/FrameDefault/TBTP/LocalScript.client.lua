script.Parent.MouseButton1Click:connect(function()
	local mychar = game.Players.LocalPlayer.Character
	local target = script.Parent.Parent.Player.Value.Character
	
	if mychar and target then
		mychar:MoveTo(target:WaitForChild("Torso").Position)
	end
end)