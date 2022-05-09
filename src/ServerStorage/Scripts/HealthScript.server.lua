local CHAR = script.Parent
local HUMAN = CHAR:WaitForChild("Humanoid")
local HRP = CHAR.HumanoidRootPart
local PLAYER = game.Players:GetPlayerFromCharacter(CHAR)
local STATUSES = CHAR:WaitForChild("Statuses")
local R = game.ReplicatedStorage.Remotes

local DS = game.ServerScriptService.DamageService

function loop(dt)
	local percentMoveSpeedMod = 0
	local foundAStun = false
	for _, status in pairs(STATUSES:GetChildren()) do
		--perform some logic based upon the type
		
		
		if status.Effect.Value == "DOT" then
			local dur = status.MaxTime.Value 
			local dps = status.Amount.Value
			local source = status.Source.Value
			local type = status.DamageType.Value
			DS.Damage:Invoke(HUMAN, (dps * dt), type, source,nil,nil,nil,true)
		end
		
		--deteriorate the effect's timer
		if status:FindFirstChild("TimeLeft") then
			status.TimeLeft.Value = status.TimeLeft.Value - dt
			if status.TimeLeft.Value <= 0 then
				status:Destroy()
			end
		end
	end
	
	
	
	--do ability cooldowns
	
	
	--set the health, perform health regen

	
	--kill players that fell off the map the appropriate way
	if HRP.Position.Y < -10 then
		local gt = HUMAN.Parent:FindFirstChild("GetTeam")
		game.ServerScriptService.DamageService.Damage:Invoke(HUMAN, HUMAN.MaxHealth * .8)
		if gt and CHAR.Name ~= "Minion" then
			local team = gt:Invoke()
			if team then
				HUMAN.Parent:MoveTo(team:GetRandomSpawnPosition())
			end
		end
	end


	--billboard stuff
	
end



function main()
	--make sure we have everything we need
	CHAR:WaitForChild("Head")
	game:GetService("RunService").Heartbeat:connect(loop)
	HUMAN.HealthChanged:connect(function(health)
	if CHAR:FindFirstChild("Head") then
		local teamGui = CHAR.Head:FindFirstChild("TeamGui")
		if teamGui then
			local ratio = health / HUMAN.MaxHealth
			teamGui.HealthBar.Size = UDim2.new(teamGui.HealthFrame.Size.X.Scale * ratio, 0, teamGui.HealthFrame.Size.Y.Scale, 0)
		end
	end
	end)
end

main()
