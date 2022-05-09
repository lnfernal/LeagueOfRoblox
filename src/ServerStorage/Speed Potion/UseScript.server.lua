function script.Use.OnInvoke(item, d)
	if not d.ST.GetEffect:Invoke(d.HUMAN, "SpeedPotion") then
		d.ST.StatBuff:Invoke(d.HUMAN, "Speed", 4, 4, "SpeedPotion")
		item:Destroy()
	end
end