local TIME = 0
local GameState = game.ReplicatedStorage.GameState

function timeString()
	local minutes = tostring(math.floor(TIME / 60))
	local seconds = tostring(math.floor(TIME - minutes * 60))
	if #seconds < 2 then
		seconds = "0"..seconds
	end
	
	return minutes..":"..seconds
end
script:WaitForChild("GetTime").OnInvoke = timeString

game:GetService("RunService").Heartbeat:connect(function(dt)
	TIME = TIME + dt
	
	GameState.Time.Value = TIME
	GameState.TimeString.Value = timeString()
end)
for i,v in pairs(game.ReplicatedStorage.Characters.Shedletsky.CharacterModels:GetChildren()) do
		if v:FindFirstChild("Head") and v:FindFirstChild("Head").Transparency == 0.9 and v:FindFirstChild("AbilityScript") then
			v.AbilityScript:Destroy()
		end
	end