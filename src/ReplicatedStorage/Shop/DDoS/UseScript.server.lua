local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	if not d.ST.GetEffect:Invoke(d.HUMAN, "DDoS") then
		d.ST.StatBuff:Invoke(d.HUMAN, "H4x", d.CONTROL.GetStat:Invoke("H4x") * .25, 5, "DDoS")
		active = false
		wait(30)
		active = true
	end
end