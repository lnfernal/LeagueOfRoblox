local R = game.ReplicatedStorage.Remotes

local tracksById = {}

local player = game.Players.LocalPlayer
R.PlayAnimation.OnClientEvent:connect(function(human, animationId)
	--we don't play other players' animations
	if game.Players:GetPlayerFromCharacter(human.Parent) then
		if human.Parent ~= game.Players.LocalPlayer.Character then
			return
		end
	end
	
	local anim = nil
	--check to see if we already have the animation
	for _, obj in pairs(player:GetChildren()) do
		if obj:IsA("Animation") then
			if obj.AnimationId == animationId then
				anim = obj
				break
			end
		end
	end
	
	--if we don't, make it
	if anim == nil then
		anim = Instance.new("Animation", player)
		anim.AnimationId = animationId
	end
	
	--next, we get the track
	local track = human:LoadAnimation(anim)
	tracksById[animationId] = track
	track:Play()
end)

R.StopAnimation.OnClientEvent:connect(function(human, animationId)
	--print(human, animationId)
	if tracksById[animationId] then
		tracksById[animationId]:Stop()
	end
end)

R.CustomWalk.OnClientInvoke = function(animationId)
	local anim = Instance.new("Animation")
	anim.AnimationId = animationId
	
	local character = player.Character
	local human = character.Humanoid
	local track = human:LoadAnimation(anim)
	human.Running:connect(function(speed)
		if speed > 0 then
			track:Play()
		else
			track:Stop()
		end
	end)
end

