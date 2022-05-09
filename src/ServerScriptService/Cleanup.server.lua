game:GetService('Players').PlayerAdded:connect(function(player)
		
	player.CharacterAdded:connect(function(character)
		player.Neutral = true
		player.TeamColor = BrickColor.new("Bright yellow")
		character:WaitForChild("CharacterScript")--Makes sure the player clicks play
		game.ReplicatedStorage.Remotes.Cleanup:FireClient(player) --Kills all the sfx current and present
		character:WaitForChild("Humanoid").Died:connect(function()
			game.ReplicatedStorage.Remotes.Cleanup:FireClient(player)  --Kills all the sfx current and present
			if game.ReplicatedStorage.PlayerStats:FindFirstChild(character.Name) then
	 game.ReplicatedStorage.PlayerStats:FindFirstChild(character.Name):Destroy()
end
		end)
	end)
end)
game.Players.PlayerRemoving:connect(function(player)
 if game.ReplicatedStorage.PlayerStats:FindFirstChild(player.Name) then
	 game.ReplicatedStorage.PlayerStats:FindFirstChild(player.Name):Destroy()
end  
end)