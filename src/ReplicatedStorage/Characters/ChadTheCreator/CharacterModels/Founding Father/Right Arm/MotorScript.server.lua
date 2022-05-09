local m = Instance.new("Motor6D")
m.Part0 = script.Parent
m.Part1 = script.Parent.Parent.Gun
m.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(-math.pi / 2, 0, 0) * CFrame.new(0, 0.2, -0.75)
m.Parent = m.Part0
game:GetService("Debris"):AddItem(script, 0)