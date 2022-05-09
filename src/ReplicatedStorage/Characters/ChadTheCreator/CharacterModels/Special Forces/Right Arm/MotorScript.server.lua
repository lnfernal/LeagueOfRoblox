local m = Instance.new("Motor6D")
m.Part0 = script.Parent
m.Part1 = script.Parent.Parent.Gun
m.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(180),math.rad(0),math.rad(-40)) * CFrame.Angles(math.rad(0),math.rad(40),math.rad(0)) * CFrame.new(-2, 0.85, 1.5)
m.Parent = m.Part0
game:GetService("Debris"):AddItem(script, 0)