local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	
	local percent = 15/100
	local heal = d.HUMAN.MaxHealth * percent
	local myTeam = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
	
	local function helper(player)
		local char = player.Character
		if char then
			local team = char:FindFirstChild("Team")
			if team then
				if team.Value ~= myTeam then
					local ally = char:FindFirstChild("Humanoid")
					local hrp = char:FindFirstChild("HumanoidRootPart")
					if ally then
						d.SFX.Artillery:Invoke(hrp.Position, 1, "Bright green")
						wait()
						d.PLAY_SOUND(ally, 84937942)
						d.SFX.Artillery:Invoke(hrp.Position, 6, "Bright green")
						d.ST.StatBuff:Invoke(ally, heal,"HealthRegen",1, d.PLAYER)
					end
				end
			end
		end
	end
	
	for _, player in pairs(game.Players:GetPlayers()) do
		delay(0, function()
			helper(player)
		end)
	end

	
	active = false
	wait(50)
	active = true
end