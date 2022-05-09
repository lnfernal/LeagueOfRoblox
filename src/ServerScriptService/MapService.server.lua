local SIZE = workspace.Map:GetModelSize().X
local CENT = workspace.Map:GetModelCFrame().p
local FRAMES = {}

local HS = game.ServerScriptService.HumanoidService

function addFrame(frame)
	table.insert(FRAMES, frame)
end
script.AddFrame.OnInvoke = addFrame

function dot(frame, center, color, type)
	local dot = Instance.new("Frame")
	dot.Name = "Dot"
	dot.BackgroundColor3 = color
	dot.BorderColor3 = color
	
	if type == "Player" then
		dot.Size = UDim2.new(0, 4, 0, 4)
		dot.Position = center + UDim2.new(0, -2, 0, -2)
		
		local tilt = dot:clone()
		tilt.Rotation = 45
		tilt.Position = UDim2.new(0, 0, 0, 0)
		tilt.Parent = dot
		
		dot.ZIndex = 3
	elseif type == "Turret" then
		dot.Size = UDim2.new(0, 6, 0, 6)
		dot.Position = center + UDim2.new(0, -2, 0, -2)
		
		local sub = dot:clone()
		sub.Size = UDim2.new(0, 4, 0, 4)
		sub.Position = UDim2.new(0, 1, 0, 1)
		sub.BorderColor3 = Color3.new(0, 0, 0)
		sub.Parent = dot
	else
		dot.Size = UDim2.new(0, 2, 0, 2)
		dot.Position = center + UDim2.new(0, -1, 0, -1)
	end
	
	dot.Parent = frame
end

function getRelativePosition(position)
	local delta = (position - CENT)
	local unit = delta / SIZE
	local pos = UDim2.new(unit.X, 0, unit.Z, 0)
	pos = pos + UDim2.new(0.5, 0, 0.5, 0)
	
	return pos
end

function removeDots(frame)
	for _, child in pairs(frame:GetChildren()) do
		if child.Name == "Dot" then
			child:Destroy()
		end
	end
end

function getTurrets()
	local turrets = {}
	for _, child in pairs(workspace:GetChildren()) do
		if child.Name == "Turret" then
			table.insert(turrets, child)
		end
	end
	return turrets
end

function loop(dt)
	local humans = HS.GetHumanoids:Invoke()
	local turrets = getTurrets()
	
	for _, frame in pairs(FRAMES) do
		removeDots(frame)
		
		for _, human in pairs(humans) do
			local char = human.Parent
			if char then
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local gt = char:FindFirstChild("GetTeam")
				if hrp and gt then
					local type = "Minion"
					if game.Players:GetPlayerFromCharacter(char) then
						type = "Player"
					end
					
					pcall(function()
						local team = gt:Invoke()
						dot(frame, getRelativePosition(hrp.Position), team.Color.Color, type)
					end)
				end
			end
		end
		
		for _, turret in pairs(turrets) do
			local fp = turret:FindFirstChild("FiringPart")
			local gt = turret:FindFirstChild("GetTeam")
			if fp and gt then
				pcall(function()
					local team = gt:Invoke()
					dot(frame, getRelativePosition(fp.Position), team.Color.Color, "Turret")
				end)
			end
		end
	end
end

game:GetService("RunService").Heartbeat:connect(loop)
