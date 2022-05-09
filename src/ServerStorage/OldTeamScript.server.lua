workspace:WaitForChild("Map")

local R = game.ReplicatedStorage.Remotes

local PLAYER_CONNECTION

function r(lower, upper)
	return lower + math.random() * (math.abs(lower) + upper)
end

function Team()
	local self = {}
	
	self.Name = "DefaultTeamName"
	self.Color = BrickColor.new("Dark stone grey")
	self.Players = {}
	self.NonPlayers = {}
	self.Spawn = workspace.Map.RedSpawn
	
	function self.CreateTeamObject(self)
		local team = Instance.new("Team")
		team.Name = self.FullName
		team.TeamColor = self.Color
		team.AutoColorCharacters = false
		team.AutoAssignable = false
		team.Parent = game:GetService("Teams") 
	end
	
	function self.SpawnPlayers(self)
		for _, player in pairs(self.Players) do
			self:SpawnPlayer(player)
		end
	end
	
	function self.PutPlayerOnSpawn(self, player)
		local spawnLocation = self.Spawn:GetModelCFrame()
		local size = self.Spawn:GetModelSize().X
		local half = size / 2
		local spawnDelta = CFrame.new(r(-half, half), 3, r(-half, half))
		local spawn = (spawnLocation * spawnDelta).p
		
		while not player.Character do wait() end
		while not player.Character:FindFirstChild("HumanoidRootPart") do wait() end
		while not player.Character:FindFirstChild("Torso") do wait() end
		wait(0.25)
		player.Character:MoveTo(spawn)
	end
	
	function self.HealPlayer(self, player)
		local char = player.Character
		if char then
			local h = char:FindFirstChild("Humanoid")
			if h then
				h.Health = h.MaxHealth
			end
		end
	end
	
	function self.RemoveTrackers(self, player)
		local char = player.Character
		if char then
			local human = char:FindFirstChild("Humanoid")
			if human then
				for _, obj in pairs(human:GetChildren()) do
					if obj.Name == "ProjectileTracker" then
						obj:Destroy()
					end
				end
			end
		end
	end
	
	function self.SpawnTime(self, player)
		local char = player.Character
		if char then
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if hrp then
				local charScript = char:FindFirstChild("CharacterScript")
				if charScript then
					local gs = charScript:FindFirstChild("GetStat")
					if gs then
						local spawnTime = 5 + gs:Invoke("Level") * 2.5
						local pos = hrp.Position
						
						R.ShowDeathTimer:FireClient(player, spawnTime)
						
						game.ServerScriptService.StatusService.Stun:Invoke(char.Humanoid, spawnTime)
					end
				end
			end
		end
	end
	
	function self.RespawnPlayer(self, player)
		local char = player.Character
		if char then
			local ff = char:FindFirstChild("ForceField")
			if ff then
				return
			end
		end
		
		game:GetService("Debris"):AddItem(Instance.new("ForceField", player.Character))
		delay(0, function()
			self:RemoveTrackers(player)
			self:PutPlayerOnSpawn(player)
			self:HealPlayer(player)
			self:SpawnTime(player)
		end)
	end
	
	function self.GiveBillboard(self, char, isPlayer, noTeam)
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "TeamGui"
		billboard.StudsOffset = Vector3.new(0, 3.5, 0)
		billboard.Size = UDim2.new(3, 0, 1.5, 0)
		billboard.Parent = char.Head
		billboard.Adornee = billboard.Parent
		--billboard.PlayerToHideFrom = player
		
		if isPlayer then
			local levelLabel = Instance.new("TextLabel")
			levelLabel.ZIndex = 2
			levelLabel.Name = "LevelLabel"
			levelLabel.Size = UDim2.new(1, -4, 0.4, -4)
			levelLabel.Position = UDim2.new(0, 2, 0.4, 2)
			levelLabel.BackgroundTransparency = 1
			levelLabel.TextStrokeTransparency = 0
			levelLabel.TextColor3 = Color3.new(1, 1, 1)
			levelLabel.TextScaled = true
			levelLabel.Parent = billboard
			
			local nameLabel = levelLabel:clone()
			nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
			nameLabel.Position = UDim2.new(0, 0, 0, 0)
			nameLabel.Text = char.Name
			nameLabel.Parent = billboard
		end
		
		local healthFrame = Instance.new("Frame")
		healthFrame.ZIndex = 2
		healthFrame.Size = UDim2.new(1, 0, 0.2, 0)
		healthFrame.BackgroundColor3 = Color3.new(1, 0, 0)
		healthFrame.BorderColor3 = Color3.new(0, 0, 0)
		healthFrame.BorderSizePixel = 2
		healthFrame.Position = UDim2.new(0, 0, 0.8, 0)
		healthFrame.Name = "HealthFrame"
		healthFrame.Parent = billboard
		
		local healthBar = healthFrame:Clone()
		healthBar.ZIndex = 3
		healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
		healthBar.Name = "HealthBar"
		healthBar.Parent = billboard
		
		if isPlayer then
			local frame = Instance.new("Frame")
			frame.ZIndex = 1
			frame.Size = UDim2.new(0.5, 0, 1, 0)
			frame.Position = UDim2.new(0.25, 0, 0, 0)
			frame.BorderColor3 = Color3.new(0, 0, 0)
			frame.BackgroundColor3 = self.Color.Color
			frame.Parent = billboard
			
			if noTeam then
				frame.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
			end
			
			local cockedFrame = frame:clone()
			cockedFrame.ZIndex = 1
			cockedFrame.Rotation = 45
			cockedFrame.Parent = billboard
		end
	end
	
	function self.SpawnPlayer(self, player)
		if player.Character:FindFirstChild("Team") then return end
		
		self:PutPlayerOnSpawn(player)
		
		local getTeam = Instance.new("BindableFunction")
		getTeam.Name = "GetTeam"
		getTeam.OnInvoke = function()
			return self
		end
		getTeam.Parent = player.Character

		local team = Instance.new("StringValue")
		team.Name = "Team"
		team.Value = self.Name
		team.Parent = player.Character
		
		local characterScript = game.ServerStorage.Scripts.CharacterScript:clone()
		characterScript.Parent = player.Character
		
		player.Character:WaitForChild("Health"):Destroy()
		
		self:HealPlayer(player)
	end
	
	function self.GetPlayerCount(self)
		local count = 0
		for _, player in pairs(game.Players:GetPlayers()) do
			if player.TeamColor == self.Color then
				count = count + 1
			end
		end
		return count
	end
	
	function self.HasPlayer(self, playerToCheck)
		for _, obj in pairs(self.Players) do
			if obj == playerToCheck then
				return true
			end
		end
		return false
	end
	
	function self.AddPlayer(self, player)
		if self:HasPlayer(player) then return end
		if self:GetOtherTeam():HasPlayer(player) then return end
		
		table.insert(self.Players, player)
		player.TeamColor = self.Color
		player.Neutral = false
		
		player.CharacterAdded:connect(function()
			self:SpawnPlayer(player)
			
			R.RenderCharacters:InvokeClient(player)
		end)
	end
	
	function self.AddNonPlayer(self, npc)
		table.insert(self.NonPlayers, npc)
		
		local getTeam = Instance.new("BindableFunction")
		getTeam.Name = "GetTeam"
		getTeam.OnInvoke = function()
			return self
		end
		getTeam.Parent = npc
		
		local team = Instance.new("StringValue")
		team.Name = "Team"
		team.Value = self.Name
		team.Parent = npc
	end
	
	function self.GetTeamStat(self, stat)
		local stats = 0
		for _, player in pairs(self.Players) do
			local char = player.Character
			if char then
				local charScript = char:FindFirstChild("CharacterScript")
				if charScript then
					local gs = charScript:FindFirstChild("GetStat")
					if gs then
						stats = stats + gs:Invoke(stat)
					end
				end
			end
		end
		return stats
	end
	
	return self
end

game:GetService("Teams"):ClearAllChildren()

local RED_TEAM = Team()
RED_TEAM.Name = "RedTeam"
RED_TEAM.FullName = "Red Team"
RED_TEAM.Color = BrickColor.new("Bright red")
RED_TEAM.Spawn = workspace.Map.RedSpawn
RED_TEAM:CreateTeamObject()

local BLUE_TEAM = Team()
BLUE_TEAM.Name = "BlueTeam"
BLUE_TEAM.FullName = "Blue Team"
BLUE_TEAM.Color = BrickColor.new("Bright blue")
BLUE_TEAM.Spawn = workspace.Map.BlueSpawn
BLUE_TEAM:CreateTeamObject()

RED_TEAM.GetOtherTeam = function(self) return BLUE_TEAM end
BLUE_TEAM.GetOtherTeam = function(self) return RED_TEAM end

function getSmallestTeam()
	local redCount = RED_TEAM:GetPlayerCount()
	local blueCount = BLUE_TEAM:GetPlayerCount()
	
	if redCount > blueCount then
		return BLUE_TEAM
	else
		return RED_TEAM
	end
end

function playerAdded(player)
	player.HealthDisplayDistance = 0
	player.NameDisplayDistance = 0
	local smallestTeam = getSmallestTeam()
	smallestTeam:AddPlayer(player)
end

function script.GetTeamByName.OnInvoke(name)
	if name == "RedTeam" then
		return RED_TEAM
	else
		return BLUE_TEAM
	end
end

function script.GetClosestTeam.OnInvoke(position)
	local dr = (RED_TEAM.Spawn:GetModelCFrame().p - position).magnitude
	local db = (BLUE_TEAM.Spawn:GetModelCFrame().p - position).magnitude
	if dr < db then
		return RED_TEAM
	else
		return BLUE_TEAM
	end
end

function script.GetOtherTeam.OnInvoke(team)
	if team == "RedTeam" then
		return "BlueTeam"
	else
		return "RedTeam"
	end
end

function script.GetAverageLevel.OnInvoke()
	local redAverage = RED_TEAM:GetTeamStat("Level") / math.max(RED_TEAM:GetPlayerCount(), 1)
	local blueAverage = BLUE_TEAM:GetTeamStat("Level") / math.max(BLUE_TEAM:GetPlayerCount(), 1)
	return (redAverage + blueAverage) / 2
end

script.PreDisable.Event:connect(function()
	PLAYER_CONNECTION:disconnect()
end)

function main()
	PLAYER_CONNECTION = game.Players.PlayerAdded:connect(playerAdded)
	for _, player in pairs(game.Players:GetPlayers()) do
		playerAdded(player)
		
		if player.Character then
			player.Character:BreakJoints()
		end
	end
end

main()
