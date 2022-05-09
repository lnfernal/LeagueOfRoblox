wait(1)

local Model = script.Parent



local Meshes = {}
for _, obj in pairs(Model:GetChildren()) do
	if obj:FindFirstChild("Mesh") then
		table.insert(Meshes, {
			Mesh = obj:FindFirstChild("Mesh"),
			MeshId = obj:FindFirstChild("Mesh").MeshId,
		})
	end
end

while true do
	wait(2)
	delay(1,function()
	for _, hat in pairs(Meshes) do
		local scale = hat.Mesh.Scale
		hat.Mesh.Scale = Vector3.new(
			math.random() * 2,
			math.random() * 2,
			math.random() * 2
		)
		delay(.2,function()
		hat.Mesh.Scale = scale
		end)
	end
	end)
	
end
