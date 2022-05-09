--Made by 1234Christopher, hello :)

light = script.Parent.PointLight

game.Lighting.Changed:connect(function()
	if game.Lighting.TimeOfDay == "18:00:00" then -- Night
		light.Brightness = 1
		for r = 0,15,0.1 do -- Light range
			wait(.1)
			light.Range = r
		end
	end
	if game.Lighting.TimeOfDay == "06:00:00" then --Day
		for r2 = 15,0,-0.1 do -- Light range
			wait(.1)
			light.Range = r2
		end
		light.Brightness = 0
	end
end)
	



