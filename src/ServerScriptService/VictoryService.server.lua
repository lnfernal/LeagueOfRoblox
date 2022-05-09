wait(4)
math.randomseed(os.time())

local config = {
	DoNotReportScriptErrors = false;
	DoNotTrackServerStart = true; 
	DoNotTrackVisits = true; 
}

local points = game:GetService("PointsService")
local WINS_LB = game:GetService("DataStoreService"):GetOrderedDataStore("WinsLeaderboard")
local KILLS_LB = game:GetService("DataStoreService"):GetOrderedDataStore("KillsLeaderboard")
local LEVELS = game:GetService("DataStoreService"):GetDataStore("PlayerLevels")
local IS = game:GetService("InsertService")

local R = game.ReplicatedStorage.Remotes
local S = game.ServerScriptService

local TELEPORT_BACK = false
local TELEPORT_SERVICE = game:GetService("TeleportService")

local GS = game.ReplicatedStorage.GameState
local GAMEMODE = GS.Gamemode
local EXP_MODIFIER = 6

local rr = Instance.new("BoolValue", workspace)
rr.Name = "RegenReady"
local ROUNDS = 0
local MAPS = {9584174639}
local GAMEMODES = {{"No Item Limit",539827270},{"All for one",539827337},{"No Champion Restriction",539827435},{"Ultra Rapid Fire",539827543},{"All Random All Mid",541130019},{"Identity Crisis",561205494}}
local SCRIPTS = {}

local FIRST_ROUND = true
function initiatecharactervoting()
	local voteTimer = Instance.new("IntValue")
	voteTimer.Name = "CharacterVoteTimer"
	voteTimer.Value = 25
	voteTimer.Parent = GS
	
	--create a container in game state to hold them
	local votes = Instance.new("Model")
	votes.Name = "CharacterVotes"
	votes.Parent = GS
	
	--create a subcontainer for each map
	for _, char in pairs(game.ReplicatedStorage.Characters:GetChildren()) do
		local v = Instance.new("NumberValue")
		v.Name = char.Name
		v.Value = 0
		v.Parent = votes
	end
	
	--catch any votes coming in, ensure one vote per player
	local votesByPlayer = {}
	local playersWithBonus = {}
	
	R.VoteOnCharacter.OnServerEvent:connect(function(player, id)
		--tally the vote
		votesByPlayer[player.Name] = id
		
		--reset the votes on each map
		for _, v in pairs(votes:GetChildren()) do
			v.Value = 0
		end
		
		if game:GetService("GamePassService"):PlayerHasPass(player, 170848603) or game:GetService("GamePassService"):PlayerHasPass(player, 389391677) then
			playersWithBonus[player.Name] = true
		end
		
		--[[
		local extraVotes = 0;
		local plrLevel = game.ServerScriptService.CommuncationService.GetPlayerLevel:Invoke(player);
		if(plrLevel >= 10) then
			extraVotes = 1;
		elseif(plrLevel >= 15) then
			extraVotes = 2;
		elseif(plrLevel >= 20) then
			extraVotes = 3;
		end]]
		
		--re-add the votes up
		for playerName, id in pairs(votesByPlayer) do
			if votes:FindFirstChild(id) then
				votes[id].Value = votes[id].Value + 1
				
				if playersWithBonus[playerName] then
					votes[id].Value = votes[id].Value + 2
				end
				
				--votes[id].Value = votes[id].Value + extraVotes;
			end
		end
	end)
	
	--use the timer to pause for a while and let players vote
	while voteTimer.Value > 0 do
		voteTimer.Value = voteTimer.Value - 1
		wait(1)
	end
	
	--detect which was the most voted for
	local topVotes = 0
	local topVoted = {}
	for _, v in pairs(votes:GetChildren()) do
		if v.Value == topVotes then
			table.insert(topVoted, v.Name)
		elseif v.Value > topVotes then
			topVoted = {v.Name}
			topVotes = v.Value
		end
	end
	local pick = Instance.new("StringValue")
	pick.Name = "ForceChar"
	pick.Value = topVoted[1]
	pick.Parent = GAMEMODE.Parent
	voteTimer:Destroy()
	votes:Destroy()
end
--this function returns if a table has a certain value
local function contains(t, v)
	for _, val in pairs(t) do
		if val == v then
			return true
		end
	end
	return false
end

function chooseMap()
	--if we're offline, just return a random one
	if true then
		GAMEMODE.Value = "Classic"
		return MAPS[math.random(1, #MAPS)]
	end
	
	--select three maps at random
	local maps = {}
	for _ = 1, 4 do
		local nextMap
		repeat
			nextMap = MAPS[math.random(1, #MAPS)]
		until not contains(maps, nextMap)
		table.insert(maps, nextMap)
	end
	--Handle Gamemodes
	local topVotedGamemode = {}
	local gamemode = {}
	ROUNDS = ROUNDS + 1
	if ROUNDS < 3 then
		GAMEMODE.Value = "Classic"
	elseif ROUNDS >= 3 then
		ROUNDS = 0 --Restart the timer
		for _ = 1, 4 do
		local nextMap
		repeat
			nextMap = GAMEMODES[math.random(1, #GAMEMODES)]
		until not contains(gamemode, nextMap)
		table.insert(gamemode, nextMap)
	end--Initiate Gamemode voting
	end
	if #gamemode ~= 0 then
	local gamemodevoteTimer = Instance.new("IntValue")
	gamemodevoteTimer.Name = "GamemodeVoteTimer"
	gamemodevoteTimer.Value = 30
	gamemodevoteTimer.Parent = GS
	
	--create a container in game state to hold them
	local gamemodevotes = Instance.new("Model")
	gamemodevotes.Name = "GamemodeVotes"
	gamemodevotes.Parent = GS
	for _, gamemodetopick in pairs(gamemode) do
		local gamemodes = gamemodetopick[1]
		local picture = gamemodetopick[2]
		local v = Instance.new("NumberValue")
		v.Name = gamemodes
		v.Value = 0
		v.Parent = gamemodevotes
		local pic = Instance.new("NumberValue")
		pic.Parent = v
		pic.Name = "Picture"
		pic.Value = picture
	end
	local votesByPlayer = {}
	local playersWithBonus = {}
	
	R.VoteOnGamemode.OnServerEvent:connect(function(player, id)
		--tally the vote
		votesByPlayer[player.Name] = id
		
		--reset the votes on each map
		for _, v in pairs(gamemodevotes:GetChildren()) do
			v.Value = 0
		end
		
		if game:GetService("GamePassService"):PlayerHasPass(player, 170848603) or game:GetService("GamePassService"):PlayerHasPass(player, 389391677) then
			playersWithBonus[player.Name] = true
		end
		
		--[[
		local extraVotes = 0;
		local plrLevel = game.ServerScriptService.CommuncationService.GetPlayerLevel:Invoke(player);
		if(plrLevel >= 10) then
			extraVotes = 1;
		elseif(plrLevel >= 15) then
			extraVotes = 2;
		elseif(plrLevel >= 20) then
			extraVotes = 3;
		end]]
		
		--re-add the votes up
		for playerName, id in pairs(votesByPlayer) do
			if gamemodevotes:FindFirstChild(id) then
				gamemodevotes[id].Value = gamemodevotes[id].Value + 1
				
				if playersWithBonus[playerName] then
					gamemodevotes[id].Value = gamemodevotes[id].Value + 2
				end
				
				--votes[id].Value = votes[id].Value + extraVotes;
			end
		end
	end)
	while gamemodevoteTimer.Value > 0 do
		gamemodevoteTimer.Value = gamemodevoteTimer.Value - 1
		wait(1)
	end
	
	--detect which was the most voted for
	local topVotes = 0
	
	for _, v in pairs(gamemodevotes:GetChildren()) do
		if v.Value == topVotes then
			table.insert(topVotedGamemode, v.Name)
		elseif v.Value > topVotes then
			topVotedGamemode = {v.Name}
			topVotes = v.Value
		end
	end
	GAMEMODE.Value = topVotedGamemode[math.random(1, #topVotedGamemode)]
	gamemodevoteTimer:Destroy()
			gamemodevotes:Destroy()
	end
	if GAMEMODE.Value == "All Random All Mid" then
	local midmaps = {508020663,502792700}
	return midmaps[math.random(1, #midmaps)]
	else
	--create a timer so players know how long 'til voting's done
	local voteTimer = Instance.new("IntValue")
	voteTimer.Name = "MapVoteTimer"
	voteTimer.Value = 15
	voteTimer.Parent = GS
	
	--create a container in game state to hold them
	local votes = Instance.new("Model")
	votes.Name = "MapVotes"
	votes.Parent = GS
	
	--create a subcontainer for each map
	for _, map in pairs(maps) do
		local v = Instance.new("NumberValue")
		v.Name = map
		v.Value = 0
		v.Parent = votes
	end
	
	--catch any votes coming in, ensure one vote per player
	local votesByPlayer = {}
	local playersWithBonus = {}
	
	R.VoteOnMap.OnServerEvent:connect(function(player, id)
		--tally the vote
		votesByPlayer[player.Name] = id
		
		--reset the votes on each map
		for _, v in pairs(votes:GetChildren()) do
			v.Value = 0
		end
		
		if game:GetService("GamePassService"):PlayerHasPass(player, 170848603) or game:GetService("GamePassService"):PlayerHasPass(player, 389391677) then
			playersWithBonus[player.Name] = true
		end
		
		--[[
		local extraVotes = 0;
		local plrLevel = game.ServerScriptService.CommuncationService.GetPlayerLevel:Invoke(player);
		if(plrLevel >= 10) then
			extraVotes = 1;
		elseif(plrLevel >= 15) then
			extraVotes = 2;
		elseif(plrLevel >= 20) then
			extraVotes = 3;
		end]]
		
		--re-add the votes up
		for playerName, id in pairs(votesByPlayer) do
			if votes:FindFirstChild(id) then
				votes[id].Value = votes[id].Value + 1
				
				if playersWithBonus[playerName] then
					votes[id].Value = votes[id].Value + 2
				end
				
				--votes[id].Value = votes[id].Value + extraVotes;
			end
		end
	end)
	
	--use the timer to pause for a while and let players vote
	while voteTimer.Value > 0 do
		voteTimer.Value = voteTimer.Value - 1
		wait(1)
	end
	
	--detect which was the most voted for
	local topVotes = 0
	local topVoted = {}
	for _, v in pairs(votes:GetChildren()) do
		if v.Value == topVotes then
			table.insert(topVoted, v.Name)
		elseif v.Value > topVotes then
			topVoted = {v.Name}
			topVotes = v.Value
		end
	end
	
	--set up for cleanup
	workspace.ChildAdded:connect(function(obj)
		if obj.Name == "Map" then
			votes:Destroy()
			voteTimer:Destroy()
			--Initiate Character Voting for each team
			if GAMEMODE.Value == "All for one" then
				initiatecharactervoting()
			end
		end
	end)
	
	--return randomly from those with the highest votes
	return topVoted[math.random(1, #topVoted)]
end
end
function shouldCycleScript(scr)
	return scr:FindFirstChild("NoCycleOnRegen") == nil
end

function cycleServerScripts(disabled)
	if disabled then
		SCRIPTS = {}
		for _, scr in pairs(S:GetChildren()) do
			if scr:IsA("Script") and shouldCycleScript(scr) then
				table.insert(SCRIPTS, scr:Clone())
				scr:Destroy()
			end
		end
	else
		--place 'em
		for _, scr in pairs(SCRIPTS) do
			scr.Disabled = true
			scr.Parent = S
		end
		
		wait(1)
		
		--start 'em up
		for _, scr in pairs(SCRIPTS) do
			scr.Disabled = false
		end
	end
end

function clearMinions()
	for _, obj in pairs(workspace:GetChildren()) do
		if obj.Name == "Minion" or obj.Name == "Turret" or obj.Name == "Map" or obj:FindFirstChild("MobScript") then
			obj:Destroy()
		end
	end
end

function cycleSpawns()
	workspace.Map.Spawns:Destroy()
	
	local new = spawns:clone()
	new.Parent = workspace.Map
end

function killAll()
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Character then
			player.Character:BreakJoints()
		end
	end
end

function getLargestPart(map)
	local best
	local bestMass = 0
	local function recurse(root)
		for _, obj in pairs(root:GetChildren()) do
			if obj:IsA("BasePart") then
				if obj:GetMass() > bestMass then
					best = obj
					bestMass = obj:GetMass()
				end
			end
			recurse(obj)
		end
	end
	recurse(map)
	return best
end

function regenerate()
	
	cycleServerScripts(true)
	
	if not FIRST_ROUND then
		killAll()
	else
		FIRST_ROUND = false
	end
	clearMinions()
	GAMEMODE.Value = ""
	
	local pick = chooseMap()
	local map = IS:LoadAsset(pick).Map
	--[[if game:FindFirstChild("NetworkServer") then
		GA.ReportEvent("Map", pick, "none", 1)
	end]]
	map.Parent = workspace
	if not map.PrimaryPart then
		map.PrimaryPart = getLargestPart(map)
	end
	print(map.PrimaryPart.Name)
	print("there we go")
	map:SetPrimaryPartCFrame(CFrame.new())
	print("there we go")
	
	cycleServerScripts(false)
	script.Regenerate:Invoke()
end



function getTurretsByTeam()
	local turretsByTeam = {}
	
	turretsByTeam["Red Team"] = 0
	turretsByTeam["Blue Team"] = 0
	
	for _, obj in pairs(workspace:GetChildren()) do
		if obj.Name == "Turret" then
			local team = obj:FindFirstChild("Team")
			if team then
				team = team.Value
				if turretsByTeam[team] then
					turretsByTeam[team] = turretsByTeam[team] + 1
				end
			end
		end
	end
	
	return turretsByTeam
end

function getKillsDeaths(char)
	local scr = char:FindFirstChild("CharacterScript")
	if scr then
		local gs = scr:FindFirstChild("GetStat")
		if gs then
			local kills = gs:Invoke("Kills")
			local deaths = gs:Invoke("Deaths")
			local assists = gs:Invoke("Assists")
			
			return kills.." / "..deaths.." / "..assists
		end
	end
	
	return ""
end

function victoryProtection()
	for _, player in pairs(game.Players:GetPlayers()) do
		local char = player.Character
		if char then
			local human = char:FindFirstChild("Humanoid")
			if human then
				Instance.new("ForceField", char)
				game.ServerScriptService.DamageService.KnockAirborne:Invoke(human, 16, 120)
			end
		end
	end
end

function victoryMessage(winningTeamName)	
	local winningTeam = game.ServerScriptService.TeamScript.GetTeamByName:Invoke(winningTeamName)
	local winningColor = winningTeam.Color
	
	local wName = Instance.new("StringValue")
	wName.Name = "WinningTeamName"
	wName.Value = winningTeamName
	wName.Parent = game.ReplicatedStorage.GameState
	
	local wCol = Instance.new("BrickColorValue")
	wCol.Name = "WinningTeamColor"
	wCol.Value = winningColor
	wCol.Parent = game.ReplicatedStorage.GameState
	
	R.Endgame:FireAllClients()
end

function victoryPlayerPoints(teamName)
	local pointsPerPerson = 5000
	if points:GetAwardablePoints() >= 5 * pointsPerPerson then
		for _, player in pairs(game.Players:GetPlayers()) do
			local char = player.Character
			if char then
				local team = char:FindFirstChild("Team")
				if team then
					if team.Value == teamName then
						points:AwardPoints(player.userId, pointsPerPerson)
					end
				end
			end
		end
	end
end

function victoryPoints(teamName)
	for _, player in pairs(game.Players:GetPlayers()) do
		local ps = player:FindFirstChild("PlayerState", true)
		if ps and ps:FindFirstChild("TeamName") then
			--store their exp here
			local playerExp
			local playerLvl = LEVELS:GetAsync(player.userId) or 0
			local vLvl = Instance.new("NumberValue")
			vLvl.Name = "PlayerLevel"
			vLvl.Value = playerLvl
			vLvl.Parent = ps
			--did they win?
			if ps.TeamName.Value == teamName then
				WINS_LB:IncrementAsync(player.Name)
				if game.VIPServerId == nil or game.VIPServerId == "" then
				
				
				pcall(function()
				playerExp = LEVELS:IncrementAsync(player.Name.."Experience", math.abs(999 * EXP_MODIFIER))
				end)
				else
				pcall(function()
				playerExp = LEVELS:IncrementAsync(player.Name.."Experience", 999)
				end)
				end
			else
				if game.VIPServerId == nil or game.VIPServerId == "" then
				
				pcall(function()
				playerExp = LEVELS:IncrementAsync(player.Name.."Experience", math.abs(999 * EXP_MODIFIER))
				end)
				else
				pcall(function()
				playerExp = LEVELS:IncrementAsync(player.Name.."Experience", 999)
				end)
				
				end
			end
			
			--did they level up?
			local leveledUp = playerExp > playerLvl * 3.99
			if true then
				pcall(function()
				playerLvl = LEVELS:IncrementAsync(player.userId)
				LEVELS:SetAsync(player.Name.."Experience", 0)
				playerExp = 0
				vLvl.Value = vLvl.Value + 100;
				end)
			end
			
			--give the endgame message something to show
			local vExp = Instance.new("NumberValue")
			vExp.Name = "PlayerExperience"
			vExp.Value = playerExp
			vExp.Parent = ps
			
			
			
			local vExpReq = Instance.new("NumberValue")
			vExpReq.Name = "PlayerExperienceRequired"
			vExpReq.Value = playerLvl * 4
			vExpReq.Parent = ps
			
			local vUp = Instance.new("BoolValue")
			vUp.Name = "PlayerLeveledUp"
			vUp.Value = leveledUp
			vUp.Parent = ps
			
			local vKills = Instance.new("NumberValue")
			vKills.Name = "LifetimeKills"
			vKills.Value = KILLS_LB:GetAsync(player.Name)
			vKills.Parent = ps
			
			local vWins = Instance.new("NumberValue")
			vWins.Name = "LifetimeWins"
			vWins.Value = WINS_LB:GetAsync(player.Name)
			vWins.Parent = ps
			--[[if game:FindFirstChild("NetworkServer") then
			GA.ReportEvent(player.userId, "Level", vLvl.Value,1)
			end]]
		end
	end
end

function noTurrets()
	for _, obj in pairs(workspace:GetChildren()) do
		if obj.Name == "Turret" then
			if obj:FindFirstChild("Team") == nil then
				return false
			end
		end
	end
	return true
end

regenerate()


ms = game:GetService("MarketplaceService");
needsShutdown = false;

currentServerUpdated = ms:GetProductInfo(game.PlaceId)["Updated"];

coroutine.resume(coroutine.create(function()
	while(true) do
		if(ms:GetProductInfo(game.PlaceId)["Updated"] ~= currentServerUpdated) then
			needsShutdown = true;
			while(true) do
				local h = Instance.new("Hint", game.Workspace);
				h.Text = "This is an old server, and it will be shutdown after the current round ends.";
				wait(10);
				h:Destroy();
				wait(50);
			end
		end
		wait(10);
	end
end))

function antiJoin()
	game.Players.PlayerAdded:connect(function(plr)
		plr:Kick("This server is in the process of being shutdown. Try rejoining the game.");
	end)
end

while true do
	wait(1)
		
	local turretsByTeam = getTurretsByTeam()
	
	if turretsByTeam["Red Team"] == 0 and noTurrets() then
		delay(0, function()
			victoryProtection()
			victoryPoints("Blue Team")
			victoryMessage("Blue Team")
			victoryPlayerPoints("Blue Team")
		end)
		
		if(needsShutdown) then
			local h = Instance.new("Hint", game.Workspace);
			h.Text = "This server is outdated and will now shutdown.";
		end

		wait(40)
		
		if(needsShutdown) then
			antiJoin();
			
			for i, plr in ipairs(game.Players:GetPlayers()) do
				plr:Kick("The server has shutdown because it was outdated."); --a
			end
		end
		
		regenerate()	
	elseif turretsByTeam["Blue Team"] == 0 and noTurrets() then
		delay(0, function()
			victoryProtection()
			victoryPoints("Red Team")
			victoryMessage("Red Team")
			victoryPlayerPoints("Red Team")
		end)
		
		if(needsShutdown) then
			local h = Instance.new("Hint", game.Workspace);
			h.Text = "This server is outdated and will now shutdown.";
		end
		
		wait(40)
		
		if(needsShutdown) then
			antiJoin();
			
			for i, plr in ipairs(game.Players:GetPlayers()) do
				plr:Kick("The server has shutdown because it was outdated."); --a
			end
		end
		
		regenerate()
	end
end
