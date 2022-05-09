function script.Use.OnInvoke(item, d)
	if not d.ST.GetEffect:Invoke(d.HUMAN, "FortuneCookie") then
		d.ST.StatBuff:Invoke(d.HUMAN, "Health",d.CONTROL.GetStat:Invoke("Health") * .05, 180, "FortuneCookie")
		d.ST.StatBuff:Invoke(d.HUMAN, "Skillz",d.CONTROL.GetStat:Invoke("Skillz") * .125, 180, "FortuneCookie")
		d.ST.StatBuff:Invoke(d.HUMAN, "H4x",d.CONTROL.GetStat:Invoke("H4x") * .125, 180, "FortuneCookie")
		d.ST.StatBuff:Invoke(d.HUMAN, "HealthRegen", 12, 180, "FortuneCookie")
		item:Destroy()
	end
end