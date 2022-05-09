local m = Instance.new("Motor6D")
m.Part0 = script.Parent
m.Part1 = script.Parent.Parent.StoneAxe
m.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(0, math.pi, 0) * CFrame.new(0.2, 0, 0.4)
m.Parent = m.Part0
game:GetService("Debris"):AddItem(script, 0)