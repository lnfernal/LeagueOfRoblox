function script.Use.OnInvoke(item, d)
	if not d.ST.GetEffect:Invoke(d.HUMAN, "SkillzPotion") then
		d.ST.StatBuff:Invoke(d.HUMAN, "Skillz", 50, 300, "SkillzPotion")
		item:Destroy()
	end
end