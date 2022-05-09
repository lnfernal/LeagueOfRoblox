wait(0.5)

local TURRET = script.Parent
local FIRING_PART = TURRET.FiringPart

local MY_TEAM = nil

local CONFIG = TURRET.Configuration
local RANGE = CONFIG.Range.Value
local DAMAGE = CONFIG.Damage.Value
local SPEED = CONFIG.Speed.Value

local SOUND_ID = "http://www.roblox.com/asset/?id=12222208"
local PITCH = 0.5

local MAX_MINIONS = 1
local MINIONS_LEFT = MAX_MINIONS

local GET_HUMANOIDS = game.ServerScriptService.GetNearbyEnemiesTurret.GetEnemies
local DS = game.ServerScriptService.DamageService
--local Mobs = require(game.ServerScriptService.UnitedCharacterScript)
local BAR = nil
local LABEL = nil

local CFRAME = TURRET:GetModelCFrame()
local moveModel = require(game.ServerStorage.MoveModel)

function randomVelocity(d)
	local x = math.random(-d, d)
	local y = math.random(-d, d)
	local z = math.random(-d, d)
	return Vector3.new(x, y, z)
end

function allAxisSpin()
	local x = math.random() * math.pi * 2
	local y = math.random() * math.pi * 2
	local z = math.random() * math.pi * 2
	return CFrame.Angles(x, y, z)
end

function In(tab,stuff,object,thing)
	thing = thing or "Functions"
	for _,v in pairs(tab) do
		if v[stuff] == object then
			return v[thing]
		end
	end
end

--[[function getStat(statName)
	local getStat = In(Mobs.Mobs,"Character",TURRET)
	if getStat then
		return getStat:GetStat(statName)
	end
	
	return 0
end]]
function getStat(statName)
	local getStat = TURRET:FindFirstChild("GetStat", true)
	if getStat then
		return getStat:Invoke(statName)
	end
	
	return 0
end


function fireOnCharacter(character)
	local hrp = character.HumanoidRootPart
	local d = 0
	
	local sound = Instance.new("Sound")
	sound.SoundId = SOUND_ID
	sound.Pitch = PITCH
	sound.Parent = FIRING_PART
	sound:Play()
	game:GetService("Debris"):AddItem(sound)
	game.ServerScriptService.SFXService.RayShot:Invoke(FIRING_PART.Position, hrp.Position, MY_TEAM.Color.Name, 0.1,1.5)
	local human = character:FindFirstChild("Humanoid")
	if human then
		pcall(function() DS.Damage:Invoke(human, getStat("Skillz"), "Toughness") end)
		pcall(function() DS.Damage:Invoke(human, getStat("H4x"), "Resistance") end)
	if game:GetService("Players"):GetPlayerFromCharacter(human.Parent) then
		local percentdamage = human.MaxHealth * .0375
		pcall(function() DS.Damage:Invoke(human, percentdamage, nil) end)
	end
		
		if CONFIG:FindFirstChild("Invincible") then
			pcall(function() DS.Damage:Invoke(human, human.MaxHealth * 10) end)
		end
	end
	

end

function takeDamage()
	if CONFIG:FindFirstChild("Invincible") then return end
	
	MINIONS_LEFT = MINIONS_LEFT - 1
	
	if MINIONS_LEFT <= 0 then
		for index, child in pairs(TURRET:GetChildren()) do
			if child:IsA("BasePart") then
				child.Anchored = false
				child.Velocity = randomVelocity(50)
			end
		end
		
		local sound = Instance.new("Sound")
		sound.SoundId = "http://www.roblox.com/asset/?id=12221984"
		sound.Volume = 1
		sound.Pitch = 0.25
		sound.Parent = TURRET.Torso
		sound:Play()
		
		local msgAll = game.ServerScriptService.MessageService:FindFirstChild("MessageAll")
		if msgAll then
			msgAll:Invoke("A turret", "has been destroyed!", MY_TEAM.Color.Color)
		end
		
		game:GetService("Debris"):AddItem(TURRET)
		game:GetService("Debris"):AddItem(script, 0)
	end
end

function getEnemyHumans()
	local humans = GET_HUMANOIDS:Invoke(TURRET,MY_TEAM.Name,RANGE)
	local enemies = {}
	
	for _, human in pairs(humans) do
		local char = human.Parent
		table.insert(enemies, human)
	end
	
	return enemies
end

function getEnemyMinnions()
	local humans = GET_HUMANOIDS:Invoke(TURRET,MY_TEAM.Name,RANGE)
	local enemies = {}
	
	for _, human in pairs(humans) do
	if human.Parent.Name == "Minion" then	
	table.insert(enemies, human)
	end
	end
	
	return enemies
end

function getNearestHumanoid()
	local humans = getEnemyHumans()
	local mins = getEnemyMinnions()
	local bestHuman = nil
	local bestDistance = RANGE
	
	for _, human in pairs(humans) do
		if human.Health > 0 then
			if human.Parent:FindFirstChild("Aggro") and human.Parent:FindFirstChild("Aggro").Value == true then
				local char = human.Parent
			local hrp = char:FindFirstChild("HumanoidRootPart")
			
			if hrp then
				local b = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
				local a = Vector3.new(FIRING_PART.Position.X, 0, FIRING_PART.Position.Z)
				local dist = (b - a).magnitude
				
				if dist < bestDistance then
					bestHuman = human
					bestDistance = dist	
					break --Makes sure that the target is the target well the 1st plausible target that is.
				end
				end
				else
			local charb = human.Parent
			local hrpb = charb:FindFirstChild("HumanoidRootPart")
			
			if hrpb then
				local bb = Vector3.new(hrpb.Position.X, 0, hrpb.Position.Z)
				local ab = Vector3.new(FIRING_PART.Position.X, 0, FIRING_PART.Position.Z)
				local distb = (bb - ab).magnitude
				
				if distb < bestDistance and #mins == 0 then
					bestHuman = human
					bestDistance = distb
				
				else
						
					for _, hum in pairs(mins) do
		if hum.Health > 0 then
			local chara = hum.Parent
			local hrpa = chara:FindFirstChild("HumanoidRootPart")
			
			if hrpa then
				local ba = Vector3.new(hrpa.Position.X, 0, hrpa.Position.Z)
				local aa = Vector3.new(FIRING_PART.Position.X, 0, FIRING_PART.Position.Z)
				local dista = (ba - aa).magnitude
				
				if dista < bestDistance then
					bestHuman = hum
					bestDistance = dista
				end
			end
		end
		end	
				end
			end
		end
	end

	end
	
	return bestHuman
end

function setupHumanoid()
	if CONFIG:FindFirstChild("Invincible") then return end
	
	local h = TURRET.Humanoid
	
	game.ServerScriptService.BalanceService.AddCharacter:Invoke(TURRET)
	
	h.Died:connect(function()
		takeDamage()
	local R = game.ReplicatedStorage.Remotes
	local HRP = TURRET.Head
	local ds = game.ServerScriptService.DamageService
	local center = HRP.Position
	local radius = 10000
	
	local team = TURRET:WaitForChild("Team").Value
	local benefactors = {}
	local givenExp = getStat("ExpReward")
	local givenTix = getStat("TixReward")
	local function onHit(enemy)
		local player = game.Players:GetPlayerFromCharacter(enemy.Parent)
		if not player then return end
		local charScript = enemy.Parent:FindFirstChild("CharacterScript")
		if charScript then
			local giveExp = charScript:FindFirstChild("GiveExperience")
			local giveTix = charScript:FindFirstChild("GiveTix")
			if giveExp and giveTix then
				table.insert(benefactors, {Exp = giveExp, Tix = giveTix, Player = player})
			end
		end
	end
	ds.AOE:Invoke(center, radius, team, onHit)
	local num = #benefactors
	if num > 0 then
		for _, benefactor in pairs(benefactors) do
			local e = 0
			local t = math.random(300,600)
			
			benefactor.Exp:Invoke(e)
			benefactor.Tix:Invoke(t)
			
			e = tostring(e):sub(1, 4)
			t = tostring(t):sub(1, 4)
			local msg = "+"..e.." Exp, +"..t.." Tix"
			R.SFX.RisingMessage:FireClient(benefactor.Player, TURRET.Head.Position + Vector3.new(0, 1, 0), msg, 3, {TextColor3 = Color3.new(1, 1, 0)})
		end
	end
	end)
end

function showRange()
	if CONFIG:FindFirstChild("Invincible") then return end

	local base = TURRET.Base
	
	local function placeMarker(marker, mainTheta, deltaTheta)
		local float = math.sin(mainTheta * 12) / 3
		marker.CFrame = base.CFrame * CFrame.Angles(0, mainTheta + deltaTheta, 0) * CFrame.new(0, -3.2 + float, RANGE + 2)
	end
	
	local markers = {}
	
	local theta = 0
	local dTheta = math.pi / 16
	while theta < math.pi * 2 do
		local newPart = base:Clone()
		newPart.FormFactor = "Custom"
		newPart.Material = "SmoothPlastic"
		newPart.BrickColor = FIRING_PART.BrickColor
		newPart.Transparency = 0.5
		newPart.Size = Vector3.new(7.4, 4, 0.25)
		placeMarker(newPart, 0, theta)
		newPart.Parent = TURRET
		newPart.CanCollide = false
		table.insert(markers, {Marker = newPart, Delta = theta})
		theta = theta + dTheta
	end
end

function main()
	setupHumanoid()

	--team setup
	MY_TEAM = game.ServerScriptService.TeamScript.GetClosestTeam:Invoke(FIRING_PART.Position)
	MY_TEAM:AddCharacter(TURRET)
	FIRING_PART.BrickColor = MY_TEAM.Color
	
	showRange()
	
	while wait(0.95) do
		local target = getNearestHumanoid()
		
		if target ~= nil then
			fireOnCharacter(target.Parent)
		end
		
	end
end

main()