local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	local radius = 16
	local center = d.HRP.Position
	local team = d.CHAR.Team.Value
	local damage =  d.CONTROL.GetStat:Invoke("Level") * 20
	local function onHit(enemy)
	d.ST.DOT:Invoke(enemy,damage, 2, "Resistance", d.PLAYER, "Fire!")
	end
	local function onStep(p, dt)
	end
	local function onStep(p)
	end
d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Shockwave:Invoke(d.FLAT(center), radius, "Pastel blue-green")
	active = false
	wait(20)
	active = true
end
local active = true 