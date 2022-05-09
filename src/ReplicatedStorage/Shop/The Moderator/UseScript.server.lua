local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 52
	local speed = 100
	local width = 4
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .25
		d.ST.MoveSpeed:Invoke(enemy, -.25, 2.5)
	d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER) 
				
	end
	local function onStep(p, dt)
	end
	local function onStep(p)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
		d.SFX.ProjShrink:Invoke(p:ClientArgs(), 1.5, "Really red", 1)
	active = false
	wait(25)
	active = true
end