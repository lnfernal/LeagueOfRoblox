local R = game.ReplicatedStorage.Remotes
local SFX = game.ServerScriptService.SFXService

function getStatuses(human)
	if human.Parent:FindFirstChild("Passives") then
	return human.Parent.Passives
	else
	local Passives = Instance.new("Model")
	Passives.Name = "Passives"
	Passives.Parent = human.Parent
	return human.Parent.Passives
	end	
end

function customV(status, type, vName, vValue)
	local v = Instance.new(type.."Value")
	v.Name = vName
	v.Value = vValue
	v.Parent = status
end

function effectV(status, effectName)
	local e = Instance.new("StringValue")
	e.Name = "Effect"
	e.Value = effectName
	e.Parent = status
end

function amountV(status, amount)
	local a = Instance.new("NumberValue")
	a.Name = "Amount"
	a.Value = amount
	a.Parent = status
end

function ownerV(status, owner)
	local e = Instance.new("StringValue")
	e.Name = "Owner"
	e.Value = owner
	e.Parent = status
end

function healV(status, amount)
	local e = Instance.new("NumberValue")
	e.Name = "Heal"
	e.Value = amount
	e.Parent = status
end

function statusMessage(human, message)
	local char = human.Parent
	local player = game.Players:GetPlayerFromCharacter(char)
	--[[if player then
		SFX.RisingMessage:Invoke(player, message)
	end]]
	
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local pos = hrp.Position + Vector3.new(0, 3, 0)
			SFX.RisingMessage:Invoke(pos, message)
		end
	end
end

function script.MoveSpeed.OnInvoke(human, amount, name)
	local slow = Instance.new("Model")
	slow.Name = name or "MoveSpeed"
	if human.Parent.Name == "Golem" and amount > 0 then 
		--does nothing
		else
	
	effectV(slow, "PercentMoveSpeed")
	amountV(slow, amount)
	
	slow.Parent = getStatuses(human)
	end
	return slow
end



function script.StatBuff.OnInvoke(human, stat, amount, name)
	local buff = Instance.new("Model")
	buff.Name = name or "Buff"
	if human.Parent.Name == "Golem" and amount > 0 then 
		else
	effectV(buff, "StatBuff")
	customV(buff, "String", "Stat", stat)
	amountV(buff, amount)
	
	buff.Parent = getStatuses(human)
	end
	return buff
end
