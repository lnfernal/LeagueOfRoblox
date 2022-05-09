local realScript = game.ServerStorage:WaitForChild("Scripts"):FindFirstChild(script.Name, true)

if realScript then
	realScript = realScript:Clone()
	realScript.Parent = script.Parent
	realScript.Disabled = false
end

game:GetService("Debris"):AddItem(script, 0)