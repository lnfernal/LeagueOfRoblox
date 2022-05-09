function script.Use.OnInvoke(item, d)
	if not d.ST.GetEffect:Invoke(d.HUMAN, "Crystallize") then
		local radius = 14
		local duration = 30
		local t = 0
		d.ST.Tag:Invoke(d.HUMAN, 30, "Crystallize")
		while t < duration do
		local dt = wait(1)
		t = t + dt
	local center = d.HRP.Position
	local team = d.CHAR.Team.Value
		d.ST.StatBuff:Invoke(d.HUMAN, "Resistance", 25, dt, "Crystallize")
		d.ST.StatBuff:Invoke(d.HUMAN, "Toughness", 25, dt, "Crystallize")
		local function onHit(enemy)
				local slow = 0.1
				d.ST.MoveSpeed:Invoke(enemy, -slow, dt)
				
			end
	local function onStep(p, dt)
	end
	local function onStep(p)
	end
		d.DS.AOE:Invoke(center, radius, team, onHit) 
	d.SFX.Shockwave:Invoke(d.FLAT(center), radius, "Pastel blue-green")
		item:Destroy()
		end 
	end
end