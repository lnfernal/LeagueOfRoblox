--pause and allow the map to load, so that things don't break
workspace:WaitForChild("Map")
wait(1)

--clear all the team service objects so we don't make a lot of duplicates
game:GetService("Teams"):ClearAllChildren()

--these globals refer to important places
local S = game.ServerScriptService
local R = game.ReplicatedStorage.Remotes
local Storage = game.ServerStorage

--these helper globals decrease gui definition size
local BaseFrame, BaseText, BaseButton = unpack(require(S.BaseGuis))

--this global is the character script for easy reference
local CharacterScript = Storage.Scripts.CharacterScript:Clone()
local TixGrowth = Storage.Scripts.TixGrowth:Clone()
local Regen = Storage.Scripts.RegenScript:Clone()
local StatModule = Storage.Scripts.StatModule:Clone()
local SetStats = Storage.Scripts.SetStats:Clone()
--this variable contains every Team in the game
local Teams = {}

--this helper function determines if a character belongs to a player
local function isPlayer(character)
	return game.Players:GetPlayerFromCharacter(character) ~= nil
end

--this helper function finds the spawn of a given team by name
local function getTeamSpawnPosition(name)
	return workspace.Map:FindFirstChild(name):FindFirstChild("Spawn").Position
end

--this helper function detects if a character already belongs to a team
local function characterHasTeam(character)
	for _, team in pairs(Teams) do
		if team:HasCharacter(character) then
			return true
		end
	end
	
	return false
end

--this helper function explicitly extracts stats from a character and returns 0 upon a failure to find it
local function getStatFromCharacter(character, stat)
	local charScript = character:FindFirstChild("CharacterScript")
	if charScript then
		local gs = charScript:FindFirstChild("GetStat")
		if gs then
			return gs:Invoke(stat) or 0
		end
	end
	return 0
end

--set up class definition
local function Team(name, spawnPosition, colorName)
	local self = {}
	
	--the name of the team
	self.Name = name
	
	--where the players spawn
	self.SpawnPosition = spawnPosition
	
	--name of the color
	self.ColorName = colorName
	
	--brick color by that name
	self.Color = BrickColor.new(self.ColorName)
	
	--quick reference color3 of that color
	self.Color3 = self.Color.Color
	
	--table holding all characters in the team
	self.Characters = {}
	
	--this method adds a character to the team
	function self.AddCharacter(self, character)
		if not characterHasTeam(character) then
			if isPlayer(character) then
				local player = self:GetPlayer(character)
				player.TeamColor = self.Color
				player.Neutral = false
			end
			
			self:InsertCharacter(character)
			self:CreateTeamReference(character)
			self:CreateTeamName(character)
			
			if isPlayer(character) then
				self:CreatePlayerTeamGui(character)
				self:FirstSpawn(character)
			else
				self:CreateTeamGui(character)
			end
		end
	end
	
	--this method creates a bindable function which returns this team
	function self.CreateTeamReference(self, character)
		local ref = Instance.new("BindableFunction")
		ref.Name = "GetTeam"
		ref.OnInvoke = function()
			return self
		end
		ref.Parent = character
	end
	
	--this method puts a string value in the character whose name is this team's name
	function self.CreateTeamName(self, character)
		local val = Instance.new("StringValue")
		val.Name = "Team"
		val.Value = self.Name
		val.Parent = character
	end
	
	--this method sets up a billboard gui, returns for further customization
	function self.CreateTeamGui(self, character)
		local gui = Instance.new("BillboardGui")
		gui.Name = "TeamGui"
		gui.StudsOffset = Vector3.new(0, 4, 0)
		gui.Size = UDim2.new(4, 0, 2, 0)
		gui.Parent = character:WaitForChild("Head")
		gui.Adornee = gui.Parent
		
		--all team guis have a health bar
		local hpFrame = BaseFrame:Clone()
		hpFrame.Name = "HealthFrame"
		hpFrame.ZIndex = 2
		hpFrame.Size = UDim2.new(1, 0, 0.25, 0)
		hpFrame.Position = UDim2.new(0, 0, 0.75, 0)
		hpFrame.Parent = gui
		
		local hpBar = hpFrame:Clone()
		hpBar.Name = "HealthBar"
		hpBar.ZIndex = hpBar.ZIndex + 1
		hpBar.BackgroundColor3 = Color3.new(0, 1, 0)
		hpBar.Parent = gui
		
		local shieldBar = hpFrame:Clone()
		shieldBar.Name = "ShieldBar"
		shieldBar.ZIndex = hpBar.ZIndex + 1
		shieldBar.BackgroundColor3 = Color3.new(1, 1, 1)
		shieldBar.Size = UDim2.new(0,0,0,0)
		shieldBar.Parent = gui
		
		return gui
	end
	
	--this method sets up a billboard gui created specifically for a player character
	function self.CreatePlayerTeamGui(self, character)
		local gui = self:CreateTeamGui(character)
		
		local colorFrameA = BaseFrame:Clone()
		colorFrameA.Size = UDim2.new(0.5, 0, 1, 0)
		colorFrameA.BackgroundColor3 = self.Color3
		colorFrameA.Position = UDim2.new(0.25, 0, 0, 0)
		colorFrameA.Parent = gui
		
		local colorFrameB = colorFrameA:Clone()
		colorFrameB.Rotation = 45
		colorFrameB.Parent = gui
		
		local levelText = BaseText:Clone()
		levelText.Name = "LevelLabel"
		levelText.ZIndex = 2
		levelText.Size = UDim2.new(1, 0, 0.25, 0)
		levelText.Text = "0"
		levelText.Parent = gui
		
		local nameText = BaseText:Clone()
		nameText.ZIndex = 2
		nameText.Size = UDim2.new(1, 0, 0.5, 0)
		nameText.Position = UDim2.new(0, 0, 0.25, 0)
		nameText.Text = character.Name
		nameText.Parent = gui
	end
	
	--this function creates a TeamService object for easier organization
	function self.CreateTeamServiceObject(self)
		local team = Instance.new("Team")
		team.Name = self.Name
		team.TeamColor = self.Color
		team.AutoColorCharacters = false
		team.AutoAssignable = false
		team.Parent = game:GetService("Teams") 
	end
	
	--this method returns whether or not the character is in this team
	function self.HasCharacter(self, characterToCheck)
		for _, character in pairs(self.Characters) do
			if character == characterToCheck then
				return true
			end
		end
		
		return false
	end
	
	--this method inserts a character and preps it for removal upon death
	function self.InsertCharacter(self, character)
		character:WaitForChild("Humanoid").Died:connect(function()
			self:RemoveCharacter(character)
		end)
		
		table.insert(self.Characters, character)
	end
	
	--this method removes a character from the team's internal table
	function self.RemoveCharacter(self, characterToRemove)
		local indexes = {}
		
		for index, character in pairs(self.Characters) do
			if character == characterToRemove then
				table.insert(indexes, index)
			end
		end
		
		for _, index in pairs(indexes) do
			table.remove(self.Characters, index)
		end
	end
	
	--this method returns a randomized spawn location
	function self.GetRandomSpawnPosition(self)
		local dx = math.random(-16, 16)
		local dz = math.random(-16, 16)
		return self.SpawnPosition + Vector3.new(dx, 0, dz)
	end
	
	--this method sets up a character for use in the game
	function self.SetupPlayerCharacter(self, character)
		CharacterScript:Clone().Parent = character
		Regen:Clone().Parent = character
		TixGrowth:Clone().Parent = character
		local Stats = StatModule:Clone()
		Stats.Parent = game.ReplicatedStorage.PlayerStats
		Stats.Name = character.Name
		SetStats:Clone().Parent = character
		character:WaitForChild("Health"):Destroy()
	end
	
	--this method performs the 'first spawn' duties of a character
	function self.FirstSpawn(self, character)
		character:MoveTo(self:GetRandomSpawnPosition())
		self:SetupPlayerCharacter(character)
		self:StartCharacterSelect(character)
	end
	
	--this method returns the player from a character
	function self.GetPlayer(self, character)
		return game.Players:GetPlayerFromCharacter(character)
	end
	
	--this method calls the character select remote given a character
	function self.StartCharacterSelect(self, character)
		local player = self:GetPlayer(character)
		if player then
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local hold = Instance.new("BodyPosition")
				hold.maxForce = Vector3.new(1e9, 1e9, 1e9)
				hold.position = hrp.Position
				hold.Name = "CharacterSelectHold"
				hold.Parent = hrp
			end
			R.RenderCharacters:InvokeClient(player)
		end
	end
	
	--this method performs the respawn duties of a character
	function self.Respawn(self, character)
		local hrp = character:FindFirstChild("HumanoidRootPart", true)
		local gs = character:FindFirstChild("GetStat", true)
		local human = character:FindFirstChild("Humanoid", true)
		local player = self:GetPlayer(character)
		if hrp and gs and player and human then
			local t = 5 + gs:Invoke("Level") * 2.5
			if character:FindFirstChild("Revival") then --Should have made revival a status but idk loop breaks it so this fits :D
			S.StatusService.Stun:Invoke(human, 1)
			R.DisableRotation:FireClient(player, 1)
			R.PlayAnimation:FireClient(player, human, "http://www.roblox.com/GeneralDeathFinal-item?id=263208342")
			local plr = game.Players:FindFirstChild(character.Revival.Owner.Value)
			local heal = (character.Revival.Heal.Value/100)
		game:GetService("Debris"):AddItem(Instance.new("ForceField", character), 1.5)
		delay(1, function() --what do you think? its instant?
		R.StopAnimation:FireClient(player, human, "http://www.roblox.com/GeneralDeathFinal-item?id=263208342")
		if character:FindFirstChild("Revival") then
		character.Humanoid.Health = (character.Humanoid.MaxHealth *heal)
		local delta = Vector3.new(0, 0, -2)
		hrp.Parent:MoveTo(plr.Character.HumanoidRootPart.Position + delta)
		character:FindFirstChild("Revival"):Destroy() --this will destroy a random revival
		character.Torso:FindFirstChild("ReviveParticles"):Destroy() --this will also destroy a random particle
		else --just incase it gets deleted during the process
		character.Humanoid.Health = (character.Humanoid.MaxHealth * heal)
		local delta = Vector3.new(0, 0, -2)
		hrp.Parent:MoveTo(plr.Character.HumanoidRootPart.Position + delta)
		end
		end)
		else
			local dead = Instance.new("BoolValue")
			dead.Name = "Dead"
			dead.Parent = human
			local anti = Instance.new("BoolValue")
			anti.Name = "Anti"
			anti.Parent = human
			game:GetService("Debris"):AddItem(anti, t)
			S.StatusService.Stun:Invoke(human, t)
			R.ShowDeathTimer:FireClient(player, t)
			R.DisableRotation:FireClient(player, t)
			game:GetService("Debris"):AddItem(Instance.new("ForceField", character), t)
			R.PlayAnimation:FireClient(player, human, "http://www.roblox.com/GeneralDeathFinal-item?id=263208342")
			character.Head:FindFirstChild("TeamGui").Enabled = false
			delay(1.5, function()
				character.Head:FindFirstChild("TeamGui").Enabled = true
				R.StopAnimation:FireClient(player, human, "http://www.roblox.com/GeneralDeathFinal-item?id=263208342")
				dead:Destroy()
				character:MoveTo(self:GetRandomSpawnPosition())
			end)
		end
		end
	end
	
	--yields! this method enforces the position of a character for a given time
	function self.EnforcePosition(self, character, position, t)
		character:MoveTo(position)
		
		local bp = Instance.new("BodyPosition")
		bp.maxForce = Vector3.new(1e9, 1e9, 1e9)
		bp.position = position
		bp.Parent = character.HumanoidRootPart
		
		game:GetService("Debris"):AddItem(bp, t)
	end
	
	--this method returns the number of players on this team
	function self.GetPlayerCount(self)
		local count = 0
		for _, player in pairs(game.Players:GetPlayers()) do
			if player.TeamColor == self.Color then
				count = count + 1
			end
		end
		return count
	end
	
	--this method returns the players on my team
	function self.GetPlayerCharacters(self)
		local players = {}
		for _, character in pairs(self.Characters) do
			if self:GetPlayer(character) then
				table.insert(players, character)
			end
		end
		return players
	end
	
	--this method returns the sum of a given stat of all players on the team
	function self.GetTeamStat(self, stat)
		local total = 0
		for _, character in pairs(self:GetPlayerCharacters()) do
			total = total + getStatFromCharacter(character, stat)
		end
		return total
	end
	
	--after all this, create a team service object for myself
	self:CreateTeamServiceObject()
	
	table.insert(Teams, self)
	return self
end

--now that we have the class defined, let's make some further globals
local RedTeam = Team("Red Team", getTeamSpawnPosition("RedSpawn"), "Bright red")
local BlueTeam = Team("Blue Team", getTeamSpawnPosition("BlueSpawn"), "Bright blue")
local NeutralTeam = Team("Neutral Team", Vector3.new(), "Mid gray")

--Red Team and Blue Team have special functions which return the other
function RedTeam.GetOtherTeam(self)
	return BlueTeam
end

function BlueTeam.GetOtherTeam(self)
	return RedTeam
end

--this bindable returns the average level of the game (players on red and blue)
function getAverageLevel()
	local redAverage = RedTeam:GetTeamStat("Level") / math.max(RedTeam:GetPlayerCount(), 1)
	local blueAverage = BlueTeam:GetTeamStat("Level") / math.max(BlueTeam:GetPlayerCount(), 1)
	return (redAverage + blueAverage) / 2
end
script.GetAverageLevel.OnInvoke = getAverageLevel

function getAverageExperience()
	local redAverage = RedTeam:GetTeamStat("Experience") / math.max(RedTeam:GetPlayerCount(), 1)
	local blueAverage = BlueTeam:GetTeamStat("Experience") / math.max(BlueTeam:GetPlayerCount(), 1)
	return (redAverage + blueAverage) / 2
end
script.GetAverageExperience.OnInvoke = getAverageExperience

--this bindable returns the team whose spawn is closest to the given position (red and blue only)
function getClosestTeam(position)
	local dr = (position - RedTeam.SpawnPosition).magnitude
	local db = (position - BlueTeam.SpawnPosition).magnitude
	if dr < db then
		return RedTeam
	else
		return BlueTeam
	end
end
script.GetClosestTeam.OnInvoke = getClosestTeam

--this bindable gets the opposite team of the given team (red and blue)
function getOtherTeam(name)
	if name == RedTeam.Name then
		return BlueTeam.Name
	else
		return RedTeam.Name
	end
end
script.GetOtherTeam.OnInvoke = getOtherTeam

--this bindable gets a team by its name
function getTeamByName(name)
	for _, team in pairs(Teams) do
		if team.Name == name then
			return team
		end
	end
end
script.GetTeamByName.OnInvoke = getTeamByName

--this bindable tracks the addition of player characters and assigns them to teams
function playerCharacterAdded(character)
	local rc = RedTeam:GetPlayerCount()
	local bc = BlueTeam:GetPlayerCount()
	if rc > bc then
		BlueTeam:AddCharacter(character)
	else
		RedTeam:AddCharacter(character)
	end

end
script.PlayerCharacterAdded.Event:connect(playerCharacterAdded)
--this remote has people click a button to start, rather than automating it
function requestTeam(player)
	player.NameDisplayDistance = 0
	player.HealthDisplayDistance = 0
	--player
	playerCharacterAdded(player.Character)
end
R.RequestTeam.OnServerEvent:connect(requestTeam)