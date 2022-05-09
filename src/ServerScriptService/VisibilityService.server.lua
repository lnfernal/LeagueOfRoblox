local SIGHT_DISTANCE = 128

local function getTeam(player)
	local char = player.Character
	if char then
		local team = char:FindFirstChild("Team")
		if team then
			return team.Value
		end
	end
	return nil
end

local function inSightDistance(looker, lookee)
	local char = lookee.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local distance = looker:DistanceFromCharacter(hrp.Position)
			if distance < SIGHT_DISTANCE then
				return true
			end
		end
	end
	return false
end

local function getVisiblePlayersOfPlayer(looker)
	local players = game.Players:GetPlayers()
	for _, player in pairs(players) do
		local team = getTeam(player)
		if team then
			if inSightDistance(looker, player) then
				
			end
		end
	end
end