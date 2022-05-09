script:ClearAllChildren()

function message(player, data)
	game.ReplicatedStorage.Remotes.Message:FireClient(player, data)
end

local bf = Instance.new("BindableFunction")
bf.Name = "MessageAll"
bf.OnInvoke = function(title, content, titleColor, duration)
	local data = {
		Title = title,
		Content = content,
		Duration = duration or 2.5,
		TitleColor = titleColor or Color3.new(1, 1, 1)
	}
	
	for _, player in pairs(game.Players:GetPlayers()) do
		message(player, data)
	end
end
bf.Parent = script