function script.Use.OnInvoke(item, d)
	if not d.ST.GetEffect:Invoke(d.HUMAN, "AttackSpeedPotion") then
		d.ST.StatBuff:Invoke(d.HUMAN, "BasicCDR", .15, 300, "AttackSpeedPotion")
		item:Destroy()
	end
end