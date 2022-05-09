function playAnimation(playerToAnimate, animationId)
	local char = playerToAnimate.Character
	if char then
		local human = char:FindFirstChild("Humanoid")
		if human then
			for _, player in pairs(game.Players:GetPlayers()) do
				game.ReplicatedStorage.Remotes.PlayAnimation:FireClient(player, human, animationId)
			end
		end
	end
end

return playAnimation