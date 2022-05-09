function script.Use.OnInvoke(item, d)
	if not d.ST.GetEffect:Invoke(d.HUMAN, "H4xPotion") then
		d.ST.StatBuff:Invoke(d.HUMAN, "H4x", 50, 300, "H4xPotion")
		item:Destroy()
	end
end