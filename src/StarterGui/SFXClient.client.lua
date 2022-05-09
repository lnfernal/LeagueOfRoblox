local PLAYER = game.Players.LocalPlayer
local R = game.ReplicatedStorage.Remotes
local S = R.SFX
local posw = Vector3.new(0,0,0)
local RenderDistance = 128
local FX = {}

local D = {
	Timer = 0,
	Items = {},
	AddItem = function(self, obj, t)
		t = t or 5
		
		table.insert(self.Items, {
			Object = obj,
			RemoveTime = self.Timer + t
		})
	end,
	
	Tick = function(self, dt)
		self.Timer = self.Timer + dt
		
		for index, itemData in pairs(self.Items) do
			if itemData.RemoveTime < self.Timer then
				itemData.Object:Destroy()
				table.remove(self.Items, index)
			end
		end
	end
}
local DEFAULT_EFFECT_TIME = 0.2
local EFFECT_TIME = DEFAULT_EFFECT_TIME
local Gyro

function basePart()
	local part = Instance.new("Part")
	part.FormFactor = "Custom"
	part.Anchored = true
	part.CanCollide = false
	part.Size = Vector3.new(2, 2, 2)
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
	
	return part
end

function spherePart(position, radius, color)
	local diameter = radius * 2
	
	local part = basePart()
	part.Size = Vector3.new(1, 1, 1)
	part.Position = position
	part.Shape = "Ball"
	part.BrickColor = color
	
	local mesh = Instance.new("SpecialMesh", part)
	mesh.MeshType = "Sphere"
	mesh.Scale = Vector3.new(diameter, diameter, diameter)
	
	return part
end

function columnPart(position, radius, height, color)
	local diameter = radius * 2
	
	local part = basePart()
	part.Size = Vector3.new(diameter, height, diameter)
	part.Position = position + Vector3.new(0, height / 2, 0)
	part.BrickColor = color
	
	local mesh = Instance.new("CylinderMesh")
	mesh.Parent = part
	
	return part
end

function cylinderPart(position, radius, color,material)
	local diameter = radius * 2
	material = material or "Plastic"
	local part = basePart()
	part.Size = Vector3.new(diameter, 1, diameter)
	part.Position = position
	part.BrickColor = color
	part.Material = material
	local mesh = Instance.new("CylinderMesh")
	mesh.Parent = part
	
	return part
end

function AreaAOEPart(position, radius, color,material)
	local diameter = radius * 2
	material = material or "Plastic"
	local part = game.ReplicatedStorage.Items.GroundAOE:Clone()
	part.Size = Vector3.new(diameter, 0.6, diameter)
	part.Position = position
	part.BrickColor = color
	part.Material = material
	part.Anchored = true
	return part
end

function circlePart(position, radius, color,direction)
	local diameter = radius * 2

	local part = basePart()
	part.Name = ""
	part.Size = Vector3.new(diameter, 1, diameter)
	part.Position = position
	part.Rotation = direction
	part.BrickColor = color
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshId = "http://www.roblox.com/asset/?id=3270017"
	mesh.TextureId = ""
	mesh.Scale = Vector3.new(radius,radius,radius)
	mesh.Parent = part
	return part
end

function cloudPart(position, radius, color)
	local diameter = radius * 2
	
	
	local part = basePart()
	part.Size = Vector3.new(diameter, 1, diameter)
	part.Position = position
	part.BrickColor = color
	
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshId = "http://www.roblox.com/asset/?id=1095708"
	mesh.TextureId = ""
	mesh.Scale = Vector3.new(radius,7.5,radius)
	mesh.Parent = part
	
	return part
end

function randomTheta()
	return math.random() * math.pi * 2
end

function allAxisSpin()
	return CFrame.Angles(randomTheta(), randomTheta(), randomTheta())
end

game.ReplicatedStorage.Remotes.Cleanup.OnClientEvent:connect(function()  --Kills all the sfx parts
	for i,v in pairs(game.Workspace:GetChildren()) do
		if (v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart")) and v.Name ~= "GlobalMover"  then
			v:Destroy()
		end
	end

end)


function Explosion(position, radius, color, duration)
	duration = duration or EFFECT_TIME
	
	if (posw - position).magnitude > RenderDistance then return end
	local self = {}
	
	self.Position = position
	self.MaxRadius = radius
	self.Radius = 0
	self.RadSpeed = self.MaxRadius / duration
	self.Color = BrickColor.new(color)
	self.Active = true
	self.Name = "Explosion"
	function self.Step(self, dt)
		self.Radius = self.Radius + self.RadSpeed * dt
		if self.Radius >= self.MaxRadius then
			self.Radius = self.MaxRadius
			self.Active = false
		end
		
		local sphere = spherePart(self.Position, self.Radius, self.Color)
		sphere.Transparency = 0.75
		sphere.Parent = workspace
		D:AddItem(sphere, dt)
	end
	
	function self.End(self)
		
	end
	
	table.insert(FX, self)
	return self
end
S.Explosion.OnClientEvent:connect(Explosion)

function StaticExplosion(position, radius, color, duration)
	duration = duration or EFFECT_TIME
	if (posw - position).magnitude > RenderDistance then return end
	local sphere = spherePart(position, radius, BrickColor.new(color))
	sphere.Transparency = 0.75
	sphere.Parent = workspace
	D:AddItem(sphere, duration)
end
S.StaticExplosion.OnClientEvent:connect(StaticExplosion)

function ReverseExplosion(position, radius, color, duration,t)
	duration = duration or EFFECT_TIME
	if t then 
	elseif ((posw - position).magnitude > RenderDistance) then 
	return 
	end
	local self = {}
	
	self.Position = position
	self.Radius = radius
	self.RadSpeed = self.Radius / duration
	self.Color = BrickColor.new(color)
	self.Active = true
	self.Name = "ReverseExplosion"
	function self.Step(self, dt)
		self.Radius = self.Radius - self.RadSpeed * dt
		if self.Radius <= 0 then
			self.Radius = 0
			self.Active = false
		end
		
		local sphere = spherePart(self.Position, self.Radius, self.Color)
		sphere.Transparency = 0.75
		sphere.Parent = workspace
		D:AddItem(sphere, dt)
	end
	
	function self.End(self)
		
	end
	
	table.insert(FX, self)
	return self
end
S.ReverseExplosion.OnClientEvent:connect(ReverseExplosion)

function Artillery(position, radius, color, duration)
	duration = duration or EFFECT_TIME
	if (posw - position).magnitude > RenderDistance then return end
	local self = {}
	
	self.Position = position
	self.Radius = 0
	self.MaxRadius = radius / 8
	self.RadSpeed = self.MaxRadius / duration
	if type(color) == "table" then
	self.Color = BrickColor.new( color[math.random(1,#color)])
	color = color[math.random(1,#color)]
	else
	self.Color = BrickColor.new(color)
	end
	self.Explosion = Explosion(position, radius, color, duration)
	self.Active = true
	self.Name = "ArtilleryExplosion"
	function self.Step(self, dt)
		self.Radius = self.Radius + self.RadSpeed * dt
		if self.Radius >= self.MaxRadius then
			self.Radius = self.MaxRadius
			self.Active = false
		end
		
		local column = columnPart(self.Position, self.Radius, 256, self.Color)
		column.Transparency = 0.5
		column.Parent = workspace
		D:AddItem(column, dt)
	end
	
	function self.End(self)
		
	end
	
	table.insert(FX, self)
	return self
end
S.Artillery.OnClientEvent:connect(Artillery)

function Shockwave(position, radius, color, duration,material)
	duration = duration or EFFECT_TIME
	material = material or "Plastic"
	
	if (posw - position).magnitude > RenderDistance then return end
	local self = {}
	
	self.Position = position
	self.Radius = 0
	self.MaxRadius = radius
	self.RadSpeed = self.MaxRadius / duration
	self.RisingSpeed = 12
	self.RisingHeight = 1
	self.Risers = {}
	if type(color) == "table" then
	self.Color = BrickColor.new( color[math.random(1,#color)])
	else
	self.Color = BrickColor.new(color)
	end
	self.Active = true
	self.Name = "Shockwave"
	self.Material = material
	function self.Step(self, dt)
		if self.Radius < self.MaxRadius then
			if type(color) == "table" then
			self.Color = BrickColor.new( color[math.random(1,#color)])
			end
			self.Radius = self.Radius + self.RadSpeed * dt
			
			local riser = cylinderPart(self.Position, self.Radius, self.Color,self.Material)
			riser.Transparency = 0.5
			riser.Parent = workspace
			
			table.insert(self.Risers, {
				Riser = riser,
				Height = 0,
			})
			
			D:AddItem(riser)
		end
		
		if #self.Risers > 0 then
			for index, data in pairs(self.Risers) do
				local dHeight = self.RisingSpeed * dt
				data.Riser.CFrame = data.Riser.CFrame + Vector3.new(0, dHeight, 0)
				data.Height = data.Height + dHeight
				
				if data.Height >= self.RisingHeight then
					data.Riser:Destroy()
					table.remove(self.Risers, index)
				end
			end
		else
			self.Active = false
		end
	end
	
	function self.End(self)
		
	end
	
	table.insert(FX, self)
	return self
end
S.Shockwave.OnClientEvent:connect(Shockwave)

function AreaAOEStart(position, radius, color, duration,material)
	material = material or "Plastic"
	local self = {}
	self.TimeLeft = duration
	self.Position = position
	self.Radius = 0.2
	self.MaxRadi = radius * 2
	self.Active = true
	self.Material = material
	self.Color = BrickColor.new(color)
	self.Part = AreaAOEPart(self.Position, self.Radius, self.Color,self.Material)
	self.Part.Parent = workspace
	self.DisappearanceSpeed = 0.7 / duration
	self.GrowthRate = self.MaxRadi * duration
	function self.Step(self,dt)
	if self.Radius <= self.MaxRadi then
		self.Radius = self.Radius + (self.GrowthRate * dt)
		self.Part.Size = Vector3.new(self.Radius,self.Part.Size.Y,self.Radius)
	else
		self.Part.Size = Vector3.new(self.MaxRadi,self.Part.Size.Y,self.MaxRadi)
	end
	self.Part.Transparency = self.Part.Transparency + (self.DisappearanceSpeed * dt)
	self.TimeLeft = self.TimeLeft - dt
		if self.TimeLeft <= 0 then
			self.Active = false
		end
		
	end
	
	function self.End(self)
	self.Part:Destroy()	
	end
	
	table.insert(FX, self)
	return self
end
S.AreaAOEStart.OnClientEvent:connect(AreaAOEStart)

function AreaAOEFollow(part, radius, color, duration,material)
	material = material or "Plastic"
	local self = {}
	self.TimeLeft = duration
	self.Follow = part
	self.Position = part.Position
	self.Radius = 0.2
	self.MaxRadi = radius * 2
	self.Active = true
	self.Material = material
	self.Color = BrickColor.new(color)
	self.Part = AreaAOEPart(self.Position, self.Radius, self.Color,self.Material)
	self.Part.Parent = workspace
	self.DisappearanceSpeed = 0.7 / duration
	self.GrowthRate = self.MaxRadi * duration
	function self.Step(self,dt)
	if self.Radius <= self.MaxRadi then
		self.Radius = self.Radius + (self.GrowthRate * dt)
		self.Part.Size = Vector3.new(self.Radius,self.Part.Size.Y,self.Radius)
	else
		self.Part.Size = Vector3.new(self.MaxRadi,self.Part.Size.Y,self.MaxRadi)
	end
	self.Part.Transparency = self.Part.Transparency + (self.DisappearanceSpeed * dt)
	self.Part.Position = self.Follow.Position
	self.TimeLeft = self.TimeLeft - dt
		if self.TimeLeft <= 0 then
			self.Active = false
		end
		
	end
	
	function self.End(self)
	self.Part:Destroy()	
	end
	
	table.insert(FX, self)
	return self
end
S.AreaAOEFollow.OnClientEvent:connect(AreaAOEFollow)

function PartRandomFollow(part, radius, color, duration,material)
	material = material or "Plastic"
	duration = duration or EFFECT_TIME
	local self = {}
	self.TimeLeft = duration
	self.Follow = part
	self.Position = part.Position
	self.Radius = radius
	self.Active = true
	self.Material = material
	self.Color = BrickColor.new(color)
	self.Part = basePart()
	self.Part.Anchored = true
	self.Part.Size = Vector3.new(radius,radius,radius)
	self.Part.BrickColor = BrickColor.new(color)
	self.Part.Material = material
	self.Part.Parent = workspace
	self.DisappearanceSpeed = 1 / duration
	function self.Step(self,dt)
	self.Part.Transparency = self.Part.Transparency + (self.DisappearanceSpeed * dt)
	self.Part.Position = self.Follow.Position
	self.Part.Rotation = Vector3.new(math.random(0,180),math.random(0,180),math.random(0,180))
	self.TimeLeft = self.TimeLeft - dt
		if self.TimeLeft <= 0 then
			self.Active = false
		end
		
	end
	
	function self.End(self)
	self.Part:Destroy()	
	end
	
	table.insert(FX, self)
	return self
end
S.PartRandomFollow.OnClientEvent:connect(PartRandomFollow)

function Circlaes(position, radius, color, duration,direction)
	duration = duration or EFFECT_TIME
	
	if (posw - position).magnitude > RenderDistance then return end
	local self = {}
	
	self.Position = position
	self.Radius = 0
	self.MaxRadius = radius
	self.RadSpeed = self.MaxRadius / duration
	self.RisingSpeed = 12
	self.RisingHeight = 1
	self.Risers = {}
	if type(color) == "table" then
	self.Color = BrickColor.new( color[math.random(1,#color)])
	else
	self.Color = BrickColor.new(color)
	end
	self.Active = true
	
	self.direction = direction
	function self.Step(self, dt)
		if self.Radius < self.MaxRadius then
			if type(color) == "table" then
			self.Color = BrickColor.new(color[math.random(1,#color)])
			end
			self.Radius = self.Radius + self.RadSpeed * dt
			
			local riser = circlePart(self.Position, self.Radius, self.Color,self.direction )
			riser.Transparency = 0.5
			riser.Parent = workspace
			
			table.insert(self.Risers, {
				Riser = riser,
				Height = 0,
			})
			
			D:AddItem(riser)
		end
		
		if #self.Risers > 0 then
			for index, data in pairs(self.Risers) do
				local dHeight = self.RisingSpeed * dt
				data.Riser.CFrame = data.Riser.CFrame + Vector3.new(0, dHeight, 0)
				data.Height = data.Height + dHeight
				
				if data.Height >= self.RisingHeight then
					data.Riser:Destroy()
					table.remove(self.Risers, index)
				end
			end
		else
			self.Active = false
		end
	end
	
	function self.End(self)
		
	end
	
	table.insert(FX, self)
	return self
end
S.Circles.OnClientEvent:connect(Circlaes)

function Cloud(position, radius, color, duration)
	duration = duration or EFFECT_TIME
	if (posw - position).magnitude > RenderDistance then return end
	local self = {}
	
	self.Position = position
	self.Radius = 0
	self.MaxRadius = radius
	self.RadSpeed = self.MaxRadius / duration
	self.RisingSpeed = 12
	self.RisingHeight = 1
	self.Risers = {}
	self.Color = BrickColor.new(color)
	self.Active = true
	self.Name = "Cloud"
	function self.Step(self, dt)
		if self.Radius < self.MaxRadius then
			self.Radius = self.Radius + self.RadSpeed * dt
			
			local riser = cloudPart(self.Position, self.Radius, self.Color)
			riser.Transparency = 0
			riser.Parent = workspace
			
			table.insert(self.Risers, {
				Riser = riser,
				Height = 0,
			})
			
			D:AddItem(riser)
		end
		
		if #self.Risers > 0 then
			for index, data in pairs(self.Risers) do
				local dHeight = self.RisingSpeed * dt
				data.Riser.CFrame = data.Riser.CFrame + Vector3.new(0, dHeight, 0)
				data.Height = data.Height + dHeight
				
				if data.Height >= self.RisingHeight then
					data.Riser:Destroy()
					table.remove(self.Risers, index)
				end
			end
		else
			self.Active = false
		end
	end
	
	function self.End(self)
		
	end
	
	table.insert(FX, self)
	return self
end
S.Cloud.OnClientEvent:connect(Cloud)








function Bolt(pos, size, color, duration)
	duration = duration or EFFECT_TIME
	if (posw - pos).magnitude > RenderDistance then return end
	local self = {}
	
	self.Active = true
	self.Parts = {}
	self.Transparency = 0
	self.TransparencySpeed = 1 / duration
	self.Name = "Bolt"
	local function lineBetween(a, b)
		local mid = (a + b) / 2
		local len = (b - a).magnitude
		
		local part = basePart()
		part.Size = Vector3.new(size, size, len)
		part.CFrame = CFrame.new(mid, b)
		
		return part
	end
	
	local function r()
		local num = size * 4
		return -num + math.random() * num * 2
	end
	
	local upper = 256
	local delta = size * 8
	local shift = Vector3.new(r(), 0, r())
	for height = 0, upper, delta do
		local a = pos + Vector3.new(0, height, 0) + shift
		shift = Vector3.new(r(), 0, r())
		local b = pos + Vector3.new(0, height + delta, 0) + shift
		
		local part = lineBetween(a, b)
		part.BrickColor = BrickColor.new(color)
		part.Parent = workspace
		
		D:AddItem(part)
		
		table.insert(self.Parts, part)
	end
	
	function self.Step(self, dt)
		self.Transparency = self.Transparency + self.TransparencySpeed * dt
		
		for _, part in pairs(self.Parts) do
			part.Transparency = self.Transparency
		end
		
		if self.Transparency >= 1 then
			self.Active = false
		end
	end
	
	function self.End(self)
		for _, part in pairs(self.Parts) do
			part:Destroy()
		end
	end
	
	table.insert(FX, self)
end
S.Bolt.OnClientEvent:connect(Bolt)

function Line(pos, dir, length, size, color, duration)
	duration = duration or EFFECT_TIME
	if (posw - pos).magnitude > RenderDistance then return end
	local self = {}
	
	self.CFrame = CFrame.new(pos + dir * (length / 2), pos) * CFrame.Angles(math.pi / 2, 0, 0)
	self.Radius = size
	self.RadSpeed = self.Radius / duration
	self.Active = true
	self.Name = "Line"
	function self.Step(self, dt)
		local part = basePart()
		part.Size = Vector3.new(self.Radius, length, self.Radius)
		part.BrickColor = BrickColor.new(color)
		part.Transparency = 0.5
		part.CFrame = self.CFrame
		Instance.new("CylinderMesh", part)
		part.Parent = workspace
		D:AddItem(part, dt)
		
		self.Radius = self.Radius - self.RadSpeed * dt
		if self.Radius <= 0 then
			self.Active = false
		end
	end
	
	function self.End(self)
		
	end
	
	table.insert(FX, self)
	return self
end
S.Line.OnClientEvent:connect(Line)

function Trail(part, delta, size, partArgs, trailDur, dur)
	partArgs = partArgs or {}
	trailDur = trailDur or EFFECT_TIME
	dur = dur or EFFECT_TIME
	
	local self = {Active = true}
	
	self.PosPart = part
	self.PosDelta = delta
	
	self.TrailDur = trailDur
	self.Duration = dur
	self.Time = 0
	self.Name = "Trail"
	function self.Position(self)
		return self.PosPart.CFrame:pointToWorldSpace(self.PosDelta)
	end
	
	function self.Step(self, dt)
		local ps = ProjShrink(self:Position(), size, "", trailDur)
		for property, value in pairs(partArgs) do
			if ps ~= nil then
			ps.Part[property] = value
			end
		end
		
		self.Time = self.Time + dt
		if self.Time >= self.Duration then
			self.Active = false
		end
	end
	
	function self.End(self)
		
	end
	
	table.insert(FX, self)
	return self
end
S.Trail.OnClientEvent:connect(Trail)



function RisingForce(part, delta, radius, height, partArgs, dur)
	dur = dur or EFFECT_TIME
	partArgs = partArgs or {}
	
	local self = {}
	self.Active = true
	
	self.PosPart = part
	self.PosDelta = delta
	
	self.RadTotal = radius
	self.Radius = self.RadTotal
	self.RadSpeed = self.Radius / dur
	self.Height = height
	self.Name = "RiseForce"
	--create a part for reference
	local part = basePart()
	Instance.new("CylinderMesh", part)
	for property, value in pairs(partArgs) do
		part[property] = value
	end
	self.Part = part
	
	function self.Position(self)
		return self.PosPart.CFrame:pointToWorldSpace(self.PosDelta)
	end
	
	function self.Step(self, dt)
		local progress = ((self.RadTotal - self.Radius) / self.RadTotal) ^ 2.5
		
		local h = self.Height * progress
		local part = self.Part:Clone()
		part.Size = Vector3.new(self.Radius, h, self.Radius)
		part.Position = self:Position() + Vector3.new(0, h / 2, 0)
		part.Parent = workspace
		D:AddItem(part, dt * 2)
		
		self.Radius = self.Radius - self.RadSpeed * dt
		if self.Radius <= 0 then
			self.Active = false
		end
	end
	
	function self.End(self)
		self.Part:Destroy()
	end
	
	table.insert(FX, self)
	return self
end
S.RisingForce.OnClientEvent:connect(RisingForce)

function RisingMessage(pos, message, dur, textArgs, damage,where,pst)
	if (posw - pos).magnitude > RenderDistance then return end
	if pst then return end
	dur = dur or 1
	textArgs = textArgs or {}
	damage = damage or false
	where = where or ""
	local self = {}
	
	self.Position= pos
	self.TimeLeft= dur
	self.Message = message
	self.Active = true
	self.Name = "RiseMessage"
	--create the part
	local part = Instance.new("Part")
	part.Size = Vector3.new(1, 1, 1)
	part.FormFactor = "Symmetric"
	part.CanCollide = false
	part.Anchored = true
	part.Transparency = 1
	part.Parent = workspace
	D:AddItem(part, dur)
	self.Part = part
	--create the billboard
	local bb = Instance.new("BillboardGui")
	bb.Size = UDim2.new(8, 0, 2, 0)
	bb.Parent = part
	bb.Adornee = bb.Parent
	self.Billboard = bb
	
	--create the textlabel
	local tl = Instance.new("TextLabel")
	tl.Size = UDim2.new(1, 0, 1, 0)
	tl.BackgroundTransparency = 1
	tl.TextStrokeTransparency = 0
	tl.TextScaled = true
	tl.TextColor3 = Color3.new(1, 1, 1)
	tl.Parent = bb
	tl.Text = message
	for property, value in pairs(textArgs) do
		tl[property] = value
	end
	self.Label = tl
	
	function self.Step(self, dt)
		self.TimeLeft = self.TimeLeft - dt
		if self.TimeLeft <= 0 then
			self.Active = false
		end
		
		self.Position = self.Position + Vector3.new(0, 1, 0) * dt
		self.Part.Position = self.Position
	end
	
	function self.End(self, dt)
		self.Part:Destroy()
	end
	
	table.insert(FX, self)
	return self
end
S.RisingMessage.OnClientEvent:connect(RisingMessage)

function removeEffectById(id)
	for _, effect in pairs(FX) do
		if effect.Id == id then
			effect.Active = false
		end
	end
end
S.RemoveEffectById.OnClientEvent:connect(removeEffectById)

function jumpHeight(distance, height, current)
	local funcHeight = (distance/2)^2
	local func = -current * (current - distance)
	func = func / funcHeight
	func = func * height
	return Vector3.new(0, func, 0)
end

--PROJECTILE EFFECTS MUST BE REWRITTEN
function steady()
	local function recurse(root)
		for index, child in pairs(root:GetChildren()) do
			if child:IsA("BasePart") then
				child.Velocity = Vector3.new()
				child.RotVelocity = Vector3.new()
			end
			recurse(child)
		end
	end
	recurse(PLAYER.Character)
end

function LocalProjectile(args, stepFunction)
	local position, direction, speed, range, id = unpack(args)
	
	local self = {}
	
	self.Position = position
	self.Direction = direction
	self.Speed = speed
	self.Range = range
	self.Distance = 0
	self.Id = id
	self.Active = true
	self.Name = "LocalProj"
	function self.CFrame(self)
		local flatDirection = Vector3.new(self.Direction.X, 0, self.Direction.Z)
		local cframe = CFrame.new(self.Position, self.Position + flatDirection)
		return cframe
	end
	
	function self.Step(self, dt)
		local dDistance = self.Speed * dt
		local newDistance = self.Distance + dDistance
		if newDistance > self.Range then
			dDistance = self.Range - self.Distance
		end
		self.Distance = self.Distance + dDistance
		self.Position = self.Position + self.Direction * dDistance
		if self.Distance >= self.Range then
			self.Active = false
		end
		self:OnStep(dt)
	end
	
	function self.End(self)
		
	end
	
	self.OnStep = stepFunction
	
	table.insert(FX, self)
	return self
end

function ProjZap(position, size, color, duration)
	local part = basePart()
	part.Size = Vector3.new(size, size, size)
	part.CFrame = CFrame.new(position) * allAxisSpin()
	if type(color) == "table" then
		color = color[math.random(1,#color)]
	end
	part.BrickColor = BrickColor.new(color)
	D:AddItem(part, duration)
	part.Parent = workspace
end
S.ProjZap.OnClientEvent:connect(function(args, size, color, duration)
	LocalProjectile(args, function(p, dt)
		ProjZap(p.Position, size, color, duration)
	end)
end)

function ProjDash(hrp, cframe)
	hrp.CFrame = cframe
	steady()
end
S.ProjDash.OnClientEvent:connect(function(args, hrp)
	if not hrp:IsDescendantOf(PLAYER.Character) then return end
	
	LocalProjectile(args, function(p, dt)
		ProjDash(hrp, p:CFrame())
	end)
end)
S.ProjLeap.OnClientEvent:connect(function(args, hrp, height)
	if not hrp:IsDescendantOf(PLAYER.Character) then return end
	
	LocalProjectile(args, function(p, dt)
		ProjDash(hrp, p:CFrame() + jumpHeight(p.Range, height, p.Distance))
	end)
end)

function ProjPart(part, cframe)
	part.CFrame = cframe
end

function ProjPart2(part, cframe,duration)
	part = part:Clone()
	part.Position = cframe
	part.Parent = game.Workspace
	delay(duration,function()
		part:Destroy()
	end)
	
end

S.ProjPart.OnClientEvent:connect(function(args, part, spin, extras)
	extras = extras or {}
	if part == nil then return end 
	part = part:Clone()
	part.Parent = workspace
	
	LocalProjectile(args, function(p, dt)
		if extras.Spin then
			spin = spin * extras.Spin
		end
		
		ProjPart(part, p:CFrame() * spin)
	end).End = function()
		part:Destroy()
		
	end
end)

S.ProjPart2.OnClientEvent:connect(function(args, part,duration)
	
	duration = duration or EFFECT_TIME
	if part == nil then return end 
	print("hello")
	
	
	LocalProjectile(args, function(p, dt)
		
		
		ProjPart2(part, p.Position,duration)
	end).End = function()
		part:Destroy()
		
	end
end)


function ProjMeander(position, size, color, duration)
	--if tonumber(position) then
	--if (posw - Vector3.new(position,position,position)).magnitude > RenderDistance then return end
	local function rand()
		local r = size / 2
		return -r + math.random() * r * 2
	end
	local function deltaPos()
		return Vector3.new(rand(), rand(), rand())
	end
	if type(color) == "table" then
		color = color[math.random(1,#color)]
	end
	local part = basePart()
	part.Shape = "Ball"
	part.Size = Vector3.new(size, size, size)
	part.CFrame = CFrame.new(position + deltaPos())
	part.BrickColor = BrickColor.new(color)
	D:AddItem(part, duration)
	part.Parent = workspace
	end
--end
S.ProjMeander.OnClientEvent:connect(function(args, size, color, duration)
	LocalProjectile(args, function(p, dt)
		
		ProjMeander(p.Position, size, color, duration)
	end)
end)
--Rotating Around
function ProjRotate(hrp, color,range,number,name,meshed,meshtex,meshid)
	local self = {}
	meshed = meshed or false
	self.Active = true
	self.Name = "Rotate"
	self.Position = hrp.Position
	self.part = basePart()
	self.part.BrickColor = BrickColor.new(color)
	self.part.Size = Vector3.new(1,1,1)
	self.part.CFrame = CFrame.new(hrp.Position)
	self.part.Name = hrp.Parent.Name..name..tostring(number)
	if meshed then
		local mesh = Instance.new("SpecialMesh",self.part)
		mesh.MeshId = meshid
		mesh.TextureId = meshtex
	end
	self.part.Parent = workspace
	self.rotate = 1
	 function self.Step(self, dt)
      self.rotate = self.rotate + 2
		if self.rotate > 360 then self.rotate =1 end
        self.part.CFrame = CFrame.new(hrp.CFrame.X+math.sin(math.rad(self.rotate + (90 * number+ (90 * number))))*range,hrp.CFrame.Y,hrp.CFrame.Z+math.cos(math.rad(self.rotate + (90 * number+ (90 * number))))*range) 
	end

	table.insert(FX, self)
end
function ProjRotateDead(hrp,shots,part)
	if game.Workspace:FindFirstChild(hrp.Parent.Name..part..tostring(shots)) then
		game.Workspace:FindFirstChild(hrp.Parent.Name..part..tostring(shots)):Destroy()
	end
	for i,v in pairs(FX) do
		if v.part and v.part.Name == hrp.Parent.Name..part..tostring(shots) then
			
		end
	end
end

S.ProjRotate.OnClientEvent:connect(ProjRotate)
S.ProjRotateDead.OnClientEvent:connect(ProjRotateDead)

function RayShot(pos,pos2, color, duration,size)
if (posw - pos).magnitude > RenderDistance then return end	
local self = {}
	self.Name = "RayShot"
	self.Active = true
	self.dur = duration
		self.Part = basePart()
	
	self.distance = (pos - pos2).magnitude
	self.Part.Size = Vector3.new(size,size,self.distance)
	self.Part.Material = "Neon"
	self.Part.CFrame = CFrame.new(pos, pos2) * CFrame.new(0, 0, -self.distance/2)
	self.Part.BrickColor = BrickColor.new(color)
	self.Part.Parent = workspace
	D:AddItem(self.Part, duration)
	 function self.Step(self, dt)
		
	end
	function self.End(self)
		self.Part:Destroy()
	end
	delay(self.dur,function()
		self.Active = false
	end)
	table.insert(FX, self)
	return self
end
S.RayShot.OnClientEvent:connect(RayShot)


-----Emma
function ProjEmma(hrp, color, duration)
	local self = {}
	
	self.Active = true
	
	self.Position = hrp.Position
	
	self.Name = "Emma"
	self.bubble = spherePart(hrp.Position,1,BrickColor.new(color))
	self.bubble.CFrame = CFrame.new(hrp.Position)
	self.bubble.Parent = workspace
	self.bubble.Name = hrp.Parent.Name.."Bubble1"
	self.bubble2 = spherePart(hrp.Position,1,BrickColor.new(color))
	self.bubble2.CFrame = CFrame.new(hrp.Position)
	self.bubble2.Parent = workspace
	self.bubble2.Name = hrp.Parent.Name.."Bubble2"
	self.bubble3 = spherePart(hrp.Position,1,BrickColor.new(color))
	self.bubble3.CFrame = CFrame.new(hrp.Position)
	self.bubble3.Parent = workspace
	self.bubble3.Name = hrp.Parent.Name.."Bubble3"
	self.bubble4 = spherePart(hrp.Position,1,BrickColor.new(color))
	self.bubble4.CFrame = CFrame.new(hrp.Position)
	self.bubble4.Name = hrp.Parent.Name.."Bubble4"
	self.bubble4.Parent = workspace
	self.rotation = 1
	self.TimeLeft = duration
	 function self.Step(self, dt)
		self.TimeLeft = self.TimeLeft - dt
		if self.TimeLeft < 0 then
			self.Active = false
			end
       		self.rotation = self.rotation + 2
		if self.rotation > 360 then self.rotation =1 end
        self.bubble.CFrame = CFrame.new(hrp.CFrame.X+math.sin(math.rad(self.rotation))*4,hrp.CFrame.Y,hrp.CFrame.Z+math.cos(math.rad(self.rotation))*4) 
        self.bubble2.CFrame = CFrame.new(hrp.CFrame.X-math.sin(math.rad(self.rotation + 90))*4,hrp.CFrame.Y,hrp.CFrame.Z-math.cos(math.rad(self.rotation + 90))*4) 
        self.bubble3.CFrame = CFrame.new(hrp.CFrame.X-math.sin(math.rad(self.rotation + 270))*4,hrp.CFrame.Y,hrp.CFrame.Z-math.cos(math.rad(self.rotation + 270))*4) 
		self.bubble4.CFrame = CFrame.new(hrp.CFrame.X-math.sin(math.rad(self.rotation + 360))*4,hrp.CFrame.Y,hrp.CFrame.Z-math.cos(math.rad(self.rotation + 360))*4)  
	end

	function self.End(self)
if game.Workspace:FindFirstChild(self.bubble.Name) then
		self.bubble:Destroy()
end
if game.Workspace:FindFirstChild(self.bubble2.Name) then
		self.bubble2:Destroy()
	end
if game.Workspace:FindFirstChild(self.bubble3.Name) then		
		self.bubble3:Destroy()
end
if game.Workspace:FindFirstChild(self.bubble4.Name) then
		self.bubble4:Destroy()
		end
		end

		

	table.insert(FX, self)
end
function KillEmmaShots(hrp,shots)
	game.Workspace:FindFirstChild(hrp.Parent.Name.."Bubble"..tostring(shots)):Destroy()
end

S.ProjEmma.OnClientEvent:connect(ProjEmma)
S.KillEmmaShots.OnClientEvent:connect(KillEmmaShots)
		
function ProjShrink(position, size, color, duration,mat)
	--if tonumber(position) then
	--if (posw - Vector3.new(position,position,position)).magnitude > RenderDistance then return end
	if type(color) == "table" then
		color = color[math.random(1,#color)]
	end
	mat = mat or "Plastic"
	local self = {}
	
	self.Active = true
	self.mat = mat
	self.Position = position
	self.Size = size
	self.Name = "Shrink"
	self.Part = basePart()
	self.Part.Size = Vector3.new(1, 1, 1)
	self.Part.CFrame = CFrame.new(position)
	self.Part.BrickColor = BrickColor.new(color)
	self.Part.Material = self.mat	
	self.Mesh = Instance.new("SpecialMesh", self.Part)
	self.Mesh.MeshType = "Sphere"
	
	self.Part.Parent = workspace
	D:AddItem(self.Part, duration)
	
	self.ShrinkSpeed = self.Size / duration
	
	function self.Step(self, dt)
		self.Size = self.Size - self.ShrinkSpeed * dt
		self.Mesh.Scale = Vector3.new(self.Size, self.Size, self.Size)
		self.Part.CFrame = CFrame.new(self.Position)
		
		if self.Size <= 0 then
			self.Active = false
		end
	end
	
	function self.End(self)
		self.Part:Destroy()
	end
	
	table.insert(FX, self)
	return self
	--end
end
S.ProjShrink.OnClientEvent:connect(function(args, size, color, duration,material)
	LocalProjectile(args, function(p, dt)
		ProjShrink(p.Position, size, color, duration,material)
	end)
end)

function ProjTrailBrick(position, size, color, duration,direction,mat,t)
	--if tonumber(position) then
	--if (posw - Vector3.new(position,position,position)).magnitude > RenderDistance then return end
	delay(t,function()
	if type(color) == "table" then
		color = color[math.random(1,#color)]
	end
	mat = mat or "Plastic"
	local self = {}
	
	self.Active = true
	self.mat = mat
	self.Position = position
	self.Size = size
	self.Name = "Shrink"
	self.Part = basePart()
	self.Part.Anchored = true
	self.Part.Size = Vector3.new(size, 1.5, size)
	self.Part.CFrame = CFrame.new(position + direction * (size / 2), position) * CFrame.Angles(math.pi / 2, 0, 0)
	self.dir = direction
	self.Part.BrickColor = BrickColor.new(color)
	
	self.Part.Material = self.mat	
	self.Part.Parent = workspace
	self.Transparency = 0
	D:AddItem(self.Part, duration)
	
	self.ShrinkSpeed = self.Size / duration
	
	function self.Step(self, dt)
		self.Transparency = self.Transparency + self.ShrinkSpeed * dt
		self.Part.Transparency = self.Transparency
		if self.Transparency >= 1 then
			self.Active = false
		end
	end
	
	function self.End(self)
		self.Part:Destroy()
	end
	
	table.insert(FX, self)
	return self
	--end
	end)
end
S.ProjTrail.OnClientEvent:connect(function(args, size, color, duration,direction,material,t)

	LocalProjectile(args, function(p, dt)
		ProjTrailBrick(p.Position, size, color, duration,direction,material,t)
	end)
end)



function ProjShrinkBrick(position, size, color, duration)
	if (posw - position).magnitude > RenderDistance then return end
	local self = {}
	if type(color) == "table" then
		color = color[math.random(1,#color)]
	end
	self.Active = true
	
	self.Position = position
	self.Size = size
	self.Name = "Wave"
	self.Part = basePart()
	self.Part.Size = Vector3.new(1, 6, 1)
	self.Part.CFrame = CFrame.new(position)
	self.Part.BrickColor = BrickColor.new(color)
			
	self.Mesh = Instance.new("BlockMesh", self.Part)
	
	self.Part.Parent = workspace
	D:AddItem(self.Part, duration)
	
	self.ShrinkSpeed = self.Size / duration
	
	function self.Step(self, dt)
		self.Size = self.Size - self.ShrinkSpeed * dt
		self.Mesh.Scale = Vector3.new(self.Size, self.Size, self.Size)
		self.Part.CFrame = CFrame.new(self.Position)
		
		if self.Size <= 0 then
			self.Active = false
		end
	end
	
	function self.End(self)
		self.Part:Destroy()
	end
	
	table.insert(FX, self)
	return self
end
S.ProjShrinkBrick.OnClientEvent:connect(function(args, size, color, duration)
	LocalProjectile(args, function(p, dt)
		ProjShrinkBrick(p.Position, size, color, duration)
	end)
end)

S.MusicEffects.OnClientEvent:connect(function(position, Sound, color, duration)
	while Sound do
		wait(.45)
		Explosion(position.Position, Sound.PlaybackLoudness/180, color, duration)
	end
	
end)

function Attachment(anchor, part, deltaFrame, duration)
	if part.Name == "HumanoidRootPart" then
		if not part:IsDescendantOf(PLAYER.Character) then
			return
		end
	end
	
	local self = {Active = true}
	self.Name = "Attach"
	self.Anchor = anchor
	self.Part = part
	self.Delta = deltaFrame
	self.Duration = duration
	self.LastPosition = self.Anchor.Position
	self.DetachRange = 32
	
	function self.Step(self, dt)
		local vector = self.Anchor.Position - self.LastPosition
		if vector.magnitude > self.DetachRange then
			self.Active = false
			return
		end
		self.LastPosition = self.Anchor.Position
		
		self.Part.CFrame = self.Anchor.CFrame:toWorldSpace(self.Delta)
		steady()
		
		self.Duration = self.Duration - dt
		if self.Duration <= 0 then
			self.Active = false
		end
	end
	
	function self.End(self)
		
	end
	
	table.insert(FX, self)
	return self
end
S.Attachment.OnClientEvent:connect(Attachment)
local Gyro = Instance.new("BodyGyro")
function preventFling()
	repeat wait() until PLAYER.Character
	local hrp = PLAYER.Character:WaitForChild("HumanoidRootPart")
	
	Gyro.Parent = hrp
	Gyro.cframe = CFrame.new()
	Gyro.P = 10000
	Gyro.maxTorque = Vector3.new(1, 1, 1) * math.huge
	
	
	local debounce = false;
	
	local enabled = true
	game.ReplicatedStorage.ToggleMouseLock:InvokeServer(not enabled);
	PLAYER:GetMouse().KeyDown:connect(function(key)
		if(not debounce) then
			coroutine.resume(coroutine.create(function()
				debounce = true;
				wait(2);
				debounce = false;
			end))
			if key == "q" then
				if enabled then
					enabled = false
					Gyro.maxTorque = Vector3.new(math.huge, 0, math.huge)
				else
					enabled = true
					Gyro.maxTorque = Vector3.new(1, 1, 1) * math.huge
				end
				game.ReplicatedStorage.ToggleMouseLock:InvokeServer(not enabled);
			end
		end
	end)
end

local lastTime = tick()
local function getDt()
	local dt = tick() - lastTime
	lastTime = tick()
	return dt
end

preventFling()



function getMouseTargetPoint()
	local gui = script.Parent
	local inputScript = gui:FindFirstChild("InputScript")
	if inputScript then
		return inputScript.GetMouseTargetPoint:Invoke()
	end
	return Vector3.new()
end

game:GetService("RunService").Heartbeat:connect(function(...)
	local dt = getDt()
	for index, effect in pairs(FX) do
		effect:Step(dt)
		
		if not effect.Active then
			table.remove(FX, index)
			effect:End()
		end
	end
	posw = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
	--gyro stuff
	if Gyro.Parent then
		local a = Gyro.Parent.Position
		local b = getMouseTargetPoint()
		b = Vector3.new(b.x, a.y, b.z)
		Gyro.cframe = CFrame.new(a, b)
	end
	
	D:Tick(dt)
end)



game.ReplicatedStorage.Remotes.DisableRotation.OnClientEvent:connect(function(t)
	local torque = Gyro.maxTorque
	
	local noRotateTime = t
	while noRotateTime > 0 do
		Gyro.maxTorque = Vector3.new(math.huge, 0, math.huge)
		noRotateTime = noRotateTime - wait()
	end
	
	Gyro.maxTorque = torque
end)


	
		

