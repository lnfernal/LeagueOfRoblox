wait(1)

local Model = script.Parent

local Hats = {
	Model:WaitForChild("Mask").Mesh,
	Model:WaitForChild("Wings").Mesh,
}

Model:WaitForChild("Head").Transparency = 1

local Meshes = {}
for _, obj in pairs(Model:GetChildren()) do
	if obj.Name == "Mesh" then
		table.insert(Meshes, {
			Mesh = obj,
			MeshId = obj.MeshId,
		})
	end
end

while true do
	wait(0.25)
	
	for _, hat in pairs(Hats) do
		hat.Scale = Vector3.new(
			math.random() * 2,
			math.random() * 2,
			math.random() * 2
		)
	end
	
	for i = 1, 3 do
		local mesh = Meshes[math.random(1, #Meshes)]
		mesh.Mesh.MeshId = 0
		delay(0.25, function()
			mesh.Mesh.MeshId = mesh.MeshId
		end)
	end
end
