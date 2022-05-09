local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 100
	local speed = 100
	local width = 4
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		if enemy.Parent then
			local gs = enemy.Parent:FindFirstChild("GetStat", true)
			if gs then
				local h4x = gs:Invoke("H4x")
				local skillz = gs:Invoke("Skillz")
				local debuffh4x = h4x * 0.2
				local debuffskillz = skillz * 0.2
				d.ST.StatBuff:Invoke(enemy, "H4x", -debuffh4x, 4)
				d.ST.StatBuff:Invoke(enemy, "Skillz", -debuffskillz, 4)
			end
		end
	end
	local function onStep(p, dt)
	end
	local function onStep(p)
	end
	local function onEnd(p)
		
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 1.5, "Bright green", 1)
	
	active = false
	wait(20)
	active = true
end