local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	local position = d.HRP.Position
	local radius = 16
	local team = d.CHAR.Team.Value
		local function onHit(ally)
		if not game:GetService("Players"):GetPlayerFromCharacter(ally.Parent) then return end
		d.ST.StatBuff:Invoke(ally, "H4x", d.CONTROL.GetStat:Invoke("H4x") * .15, 5)
		d.ST.StatBuff:Invoke(ally, "Skillz", d.CONTROL.GetStat:Invoke("H4x") * .15, 5)
		end
	d.DS.AOE:Invoke(d.FOOT(), radius, d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value),onHit)
	d.SFX.Artillery:Invoke(d.FOOT(), radius, "Bright blue")	
		active = false
		wait(30)
		active = true
end