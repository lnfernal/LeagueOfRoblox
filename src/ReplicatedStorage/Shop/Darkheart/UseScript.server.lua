local active = true
function script.Use.OnInvoke(item, d)
	if not active then return end
		local radius = 12
		local duration = 5
		
	local center = d.HRP.Position
	local team = d.CHAR.Team.Value

		
		d.ST.StatBuff:Invoke(d.HUMAN, "BasicCDR", .1, duration)
		local function onHit(enemy)
				d.ST.StatBuff:Invoke(enemy, "BasicCDR", -.1, duration)
			 
				
			end
	local function onStep(p, dt) 
	end
	local function onStep(p)
	end
	
		d.DS.AOE:Invoke(center, radius, team, onHit) 
	d.SFX.Explosion:Invoke(d.FLAT(center), radius, "Really red") 
	
	active = false 
	wait(20)	
	active = true
 end

