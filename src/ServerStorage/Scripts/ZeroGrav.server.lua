local part = script.Parent

local bf = Instance.new("BodyForce")
bf.force = Vector3.new(0, 196.2, 0) * part:GetMass()
bf.Parent = part

game:GetService("Debris"):AddItem(script, 0)