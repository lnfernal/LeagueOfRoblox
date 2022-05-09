local realScript = game.ServerStorage:WaitForChild("Scripts"):FindFirstChild(script.Name, true)

if realScript then
	realScript = realScript:clone()
	realScript.Parent = script.Parent
	realScript.Disabled = false
end

game:GetService("Debris"):AddItem(script)