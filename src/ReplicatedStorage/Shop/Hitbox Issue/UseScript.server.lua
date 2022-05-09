local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	if d.CHAR:FindFirstChild("ForceField") then return end
	if d.HUMAN:FindFirstChild("Anti") then return end
	local STATUSES = d.CHAR:FindFirstChild("Statuses")
	if STATUSES and not d.CHAR:FindFirstChild("ForceField") then
		for i,v in pairs(STATUSES:GetChildren()) do
			if v.Name == "Stun" then
				v:Destroy()
				for i,body in pairs(d.HRP:GetChildren()) do
					if body:IsA("BodyPosition") then
						body:Destroy()
					end
				end
			elseif v:FindFirstChild("Amount") and v:FindFirstChild("Amount").Value < 0 then
				v:Destroy()
			end
		end
	end
	d.SFX.Explosion:Invoke(d.HRP.Position, 8, "Bright green")
	d.ST.MoveSpeed:Invoke(d.HUMAN, .15, 2)
	active = false
	local function Event(obj)
	if obj:FindFirstChild("TimeLeft") and not d.CHAR:FindFirstChild("ForceField") then
			delay((obj:FindFirstChild("TimeLeft").Value) * 0.4,function()
				if obj then
					obj:Destroy()
				end
			end)
		end
	end
	
	local Temp = STATUSES.ChildAdded:connect(Event)
	delay(6,function()
		Temp:Disconnect()
	end)
	wait(40)
	active = true
	
end
