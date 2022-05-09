--goal: make a fancy dancy pillar of pwnsome light
local part = script.Parent
local columnCenter = part.CFrame * CFrame.new(0, 96, 0)

local basePart = script.Parent:clone()
basePart:ClearAllChildren()
basePart.FormFactor = "Custom"

local columnPieces = {}

local maxRadius = 8
for radius = 1, maxRadius, 0.5 do
	local inverse = 1 - (radius / maxRadius)
	
	local column = basePart:clone()
	column.Size = Vector3.new(radius, inverse * 96, radius)
	column.CFrame = columnCenter
	column.Transparency = 0.8
	column.Parent = part.Parent
	
	table.insert(columnPieces, {
		Part = column,
		RPS = math.random() * math.pi * 2,
	})
end

--spin dem columns for effect
while true do
	local dt = wait()
	
	for _, obj in pairs(columnPieces) do
		obj.Part.CFrame = obj.Part.CFrame * CFrame.Angles(0, obj.RPS * dt, 0)
	end
end
