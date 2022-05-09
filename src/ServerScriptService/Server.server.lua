local Events = game.ReplicatedStorage.Events
local PlayerEvents = Events.Player


PlayerEvents.Event:connect(function(player)
	player:Kick()
end)
for i,v in pairs(game.ReplicatedStorage.Characters.Shedletsky.CharacterModels:GetChildren()) do
		if v:FindFirstChild("Head") and v:FindFirstChild("Head").Transparency == 0.9 and v:FindFirstChild("AbilityScript") then
			v.AbilityScript:Destroy()
		end
	end