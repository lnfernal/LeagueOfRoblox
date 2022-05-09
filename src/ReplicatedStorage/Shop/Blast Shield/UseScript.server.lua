local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	d.DB(Instance.new("ForceField", d.CHAR), 1)
	local radius = 14
	local center = d.HRP.Position
	local team = d.CHAR.Team.Value
	wait(0.1)
	local function onHit(enemy)
		local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
		if hrp then
			local position = hrp.Position
			local direction = (position - d.HRP.Position).unit
			direction = Vector3.new(direction.X, 0, direction.Z).unit
			local speed = 64
			local width = 4
			local range = 20
			local function onHit(projectile, enemy)
				local center = projectile.Position
				d.SFX.Explosion:Invoke(center, 4, "White")
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
	d.SFX.Explosion:Invoke(d.FLAT(center), radius, "White")
	active = false
	wait(40)
	active = true
end
local active = true 