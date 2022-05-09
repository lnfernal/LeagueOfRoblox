local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	local position = d.HRP.Position
	local radius = 25
	local team = d.CHAR.Team.Value
	local center = d.HRP.Position
	local heal = d.CONTROL.GetStat:Invoke("Level") * 17.5
	
	d.SFX.ReverseExplosion:Invoke(center, 20, "CGA brown", 0.1)
	 wait(0.1)
		local function onHit(ally)
		if game.Players:GetPlayerFromCharacter(ally.Parent) and ally ~= d.HUMAN then 
		d.ST.StatBuff:Invoke(ally, "H4x", d.CONTROL.GetStat:Invoke("Level") * 7.5, 5)  
	    d.ST.StatBuff:Invoke(ally, "Skillz", d.CONTROL.GetStat:Invoke("Level") * 7.5, 5) 
	     d.ST.StatBuff:Invoke(ally, "Resistance", d.CONTROL.GetStat:Invoke("Level") * 7.5, 5)  
	    d.ST.StatBuff:Invoke(ally, "Toughness", d.CONTROL.GetStat:Invoke("Level") * 7.5, 5)
	    d.DS.Heal:Invoke(ally, heal, d.HUMAN) 
	
		end
		end 
	d.DS.AOE:Invoke(d.FOOT(), radius, d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value),onHit)
	d.SFX.Artillery:Invoke(d.FOOT(), radius, "Bright orange")	
		active = false
		wait(30)
		active = true
end