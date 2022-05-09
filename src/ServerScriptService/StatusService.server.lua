local R = game.ReplicatedStorage.Remotes
local SFX = game.ServerScriptService.SFXService

function getStatuses(human)
	if human.Parent:FindFirstChild("Statuses") then
	return human.Parent.Statuses
	else
	local StatusModel = Instance.new("Model")
	StatusModel.Name = "Statuses"
	StatusModel.Parent = human.Parent
	return human.Parent.Statuses
	end	
end

function timeLeftV(status, duration)
	if duration < 0 then return end
	
	local tl = Instance.new("NumberValue")
	tl.Name = "TimeLeft"
	tl.Value = duration
	tl.Parent = status
	
	local mt = Instance.new("NumberValue")
	mt.Name = "MaxTime"
	mt.Value = duration
	mt.Parent = status
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
	end]]--
	
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local pos = hrp.Position + Vector3.new(0, 3, 0)
			SFX.RisingMessage:Invoke(pos, message)
		end
	end
end

function script.MoveSpeed.OnInvoke(human, amount, duration, name, t)
	local slow = Instance.new("Model")
	slow.Name = name or "MoveSpeed"
	if human.Parent.Name == "Golem" and amount > 0 then 
		--does nothing
		else
	t = t or false
	if t == true or name == "Impale" then
		amount = -0.3
	end
	effectV(slow, "PercentMoveSpeed")
	amountV(slow, amount)
	timeLeftV(slow, duration)
	
	slow.Parent = getStatuses(human)
	
	if amount > 0 then
		customV(slow, "Number", "Icon", 555190121)
		statusMessage(human, "Speed boost!")
	else
		customV(slow, "Number", "Icon", 555190102)
		statusMessage(human, "Slowed!")
	end
	end
	return slow
end

function script.Stun.OnInvoke(human, duration, name)
	local stun = Instance.new("Model")
	stun.Name = name or "Stun"
	
	effectV(stun, "Stun")
	timeLeftV(stun, duration)
	customV(stun, "Number", "Icon", 555190255)
	stun.Parent = getStatuses(human)
	
	statusMessage(human, "Stunned!")
	
	return stun
end

function script.StatBuff.OnInvoke(human, stat, amount, duration, name)
	local buff = Instance.new("Model")
	buff.Name = name or "Buff"
	if human.Parent.Name == "Golem" and amount > 0 then 
		else
	effectV(buff, "StatBuff")
	timeLeftV(buff, duration)
	customV(buff, "String", "Stat", stat)
	amountV(buff, amount)
	
	buff.Parent = getStatuses(human)
	
	if amount > 0 then
		customV(buff, "Number", "Icon", 555190146)
		statusMessage(human, stat.." up!")
	else
		customV(buff, "Number", "Icon", 555190181)
		statusMessage(human, stat.." down!")
	end
	end
	return buff
end

function script.DOT.OnInvoke(human, damage, duration, damageType, source, message, name)
	local dot = Instance.new("Model")
	dot.Name = name or "DOT"
	
	effectV(dot, "DOT")
	timeLeftV(dot, duration)
	amountV(dot, damage / duration)
	customV(dot, "Object", "Source", source)
	customV(dot, "String", "DamageType", damageType)
	customV(dot, "Number", "Icon", 555190215)
	local knife = game.ServerStorage.Handle
	
	dot.Parent = getStatuses(human)
	
	statusMessage(human, message or "Poisoned!")
	
	return dot
end

function script.Tag.OnInvoke(human, duration, name, fire, color)
	local tag = Instance.new("Model")
	tag.Name = name or "Tag"
	
	effectV(tag, "Tag")
	timeLeftV(tag, duration)
	customV(tag, "Number", "Icon", 555190268)
	if human.Parent then
		local tor = human.Parent:FindFirstChild("Torso")
		if tor then
		
		local part = Instance.new("ParticleEmitter")
	
		if fire then
		part = Instance.new("Fire")	
		
		end
		if color then
		part.Color = color 
		end
		part.Parent = tor
		
	delay(duration,function()
		part:Destroy()
	end)
		end
		end
			
	tag.Parent = getStatuses(human)
	return tag
end

function script.TagOtherEffect.OnInvoke(human, duration, name, owner, heal)
	local tag = Instance.new("Model")
	tag.Name = name or "Tag"
	
	effectV(tag, "Tag")
	ownerV(tag, owner)
	healV(tag, heal)
	customV(tag, "Bool", "Done?", false)
	customV(tag, "Number", "Icon", 555190233)
	if human.Parent then
		local tor = human.Parent:FindFirstChild("Torso")
		if tor then
		local part = Instance.new("ParticleEmitter", tor)
		part.Name = "ReviveParticles"
		part.Color = ColorSequence.new(Color3.fromRGB(255,255,0),Color3.fromRGB(255,255,0))
	delay(duration,function()
		if human.Parent:FindFirstChild("Revival") and human.Parent:FindFirstChild("Revival"):FindFirstChild("Owner").Value == owner then --this assumes that they did not die
			tag:Destroy()
			part:Destroy()
		end
	end)
		end
		end
			
	tag.Parent = human.Parent
	return tag
end

function script.GetEffect.OnInvoke(human, name)
	return getStatuses(human):FindFirstChild(name)
end

function script.Stack.OnInvoke(human, name, stacks)
	stacks = stacks or 1
	
	local s = getStatuses(human)
	if s then
		local base = s:FindFirstChild(name)
		if base then
			for _, status in pairs(s:GetChildren()) do
				if status.Name == name then
					status.TimeLeft.Value = status.MaxTime.Value
				end
			end
			
			if stacks > 0 then
				for _ = 1, stacks do
					base:Clone().Parent = s
				end
			end
		end
	end
end

function script.GetStatusCount.OnInvoke(human, name)
	local count = 0
	
	local s = getStatuses(human)
	if s then
		for _, status in pairs(s:GetChildren()) do
			if status.Name == name then
				count = count + 1
			end
		end
	end
	
	return count
end

function script.Blind.OnInvoke(human, duration)
	local player = game.Players:GetPlayerFromCharacter(human.Parent)
	if player ~= nil then
		local blind = game.ReplicatedStorage.Items.Blind:Clone()
		blind.Parent = player.PlayerGui
		delay(duration/1.25, function()
			for i = 1, 10 do
   		    blind.Frame.BackgroundTransparency = blind.Frame.BackgroundTransparency + 0.1
			wait(duration/10)
			end
			blind:Destroy()
		end)
	end
end






