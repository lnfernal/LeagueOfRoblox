function script.Use.OnInvoke(item, d)
	if not d.ST.GetEffect:Invoke(d.HUMAN, "HealthPotion") then
		d.ST.StatBuff:Invoke(d.HUMAN, "HealthRegen", 8, 8, "HealthPotion")
		
		local sparkles = Instance.new("Sparkles", d.HRP)
		sparkles.Color = Color3.new(0, 1, 0)
		d.DB(sparkles, 8)
		
		item:Destroy()
	end
end