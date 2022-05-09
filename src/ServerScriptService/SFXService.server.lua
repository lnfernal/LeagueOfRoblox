local R = game.ReplicatedStorage.Remotes
local S = R.SFX

function replicateEffect(effect, ...)
	S[effect]:FireAllClients(...)
end

for _, bf in pairs(script:GetChildren()) do
	if bf:IsA("BindableFunction") then
		bf.OnInvoke = function(...)
			replicateEffect(bf.Name, ...)
		end
	end
end
