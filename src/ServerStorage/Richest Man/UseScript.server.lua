local active = true
function script.Use.OnInvoke(item, d)
	if not active then return end
	local center = d.HRP.Position
	local radius = 16
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then
			local position = hrp.Position
			local vector = (d.HRP.Position - position)
			local direction = vector.unit
			local distance = vector.magnitude
			direction = Vector3.new(direction.X, 0, direction.Z).unit
			local speed = distance / 0.2
			local width = 4
			local range = distance
			d.DS.KnockAirborne:Invoke(enemy, 0, .15)
			local function onHit(projectile, enemy)
			end
			local function onStep(projectile)
				hrp.CFrame = CFrame.new(projectile.Position)
			end
			local function onEnd(projectile)
			end
			d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
		end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	
	d.SFX.Shockwave:Invoke(d.FLAT(center), radius, "Gold")
	active = false
	wait(50)
	active = true
end