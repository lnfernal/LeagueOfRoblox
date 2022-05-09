local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	local position = d.HRP.Position
	local radius = 16
	local team = d.CHAR.Team.Value
		local function onHit(ally)
		if not game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then return end		
		d.ST.StatBuff:Invoke(ally, "Resistance", d.CONTROL.GetStat:Invoke("H4x") * .15, 10)
		d.ST.StatBuff:Invoke(ally, "Toughness", d.CONTROL.GetStat:Invoke("H4x") * .15, 10)
		end
	d.DS.AOE:Invoke(d.FOOT(), radius, d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value),onHit)
	d.SFX.Artillery:Invoke(d.FOOT(), radius, "Alder")	
		active = false
		wait(30)
		active = true
end