--other services
local GET_HUMANS = game.ServerScriptService.HumanoidService.GetHumanoids
local GET_ENEMIES = game.ServerScriptService.HumanoidService.GetEnemies
local ST = game.ServerScriptService.StatusService
local MSG = game.ServerScriptService.MessageService
local KILL_LB = game:GetService("DataStoreService"):GetOrderedDataStore("KillsLeaderboard")
local POINTS = game:GetService("PointsService")
local DEBRIS = game:GetService("Debris")
local R = game.ReplicatedStorage.Remotes
--local Mobs = require(script.Parent.UnitedCharacterScript)
--/other services
function In(tab,stuff,object)
	for _,v in pairs(tab) do
		if v[stuff] == object then
			return v["Functions"]
		end
	end
end
--projectile stuff
local PROJECTILES = {}
local PROJECTILE_ID = 0

function inList(value, list)
	for _, test in pairs(list) do
		if value == test then
			return true
		end
	end
	
	return false
end

function projectileCollides(pos, ray, length, width)
	local lengthCheck = (ray:ClosestPoint(pos) - ray.Origin).magnitude < length
	local d = pos - ray:ClosestPoint(pos)
	local widthCheck = math.sqrt(d.X^2 + d.Z^2) < width
	return lengthCheck and widthCheck
end

function ignoreAllButMap()
	local ignored = {}
	
	for _, obj in pairs(workspace:GetChildren()) do
		if obj.Name ~= "Map" then
			table.insert(ignored, obj)
		end
	end
	
	return ignored
end

function getTrueProjectileRange(position, direction, range)
	local bestDist = 1000
	for dy = -1.75, 1.75, 0.25 do
		local ray = Ray.new(position + Vector3.new(0, dy, 0), direction * range)
		local part, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignoreAllButMap())
		local dist = (pos - position).magnitude
		if dist < bestDist then
			bestDist = dist
		end
	end
	return math.max(bestDist - 2, 0)
end

--this function raycasts the map only
local function raycastMap(ray)
	return workspace:FindPartOnRayWithIgnoreList(ray, ignoreAllButMap())
end
script.RaycastMap.OnInvoke = raycastMap

function Projectile(position, direction, speed, width, range, team, onHit, onStep, onEnd, solid, hitsTurrets, player)
	local self = {}
	player = player or false
	self.Id = PROJECTILE_ID
	PROJECTILE_ID = PROJECTILE_ID + 1
	
	self.Position = position
	self.Direction = direction
	self.Speed = speed
	self.Width = width
	self.Range = range
	self.OnHit = onHit
	self.OnStep = onStep
	self.OnEnd = onEnd
	self.Team = team
	self.Moving = true
	self.TargetsHit = {}
	self.HitsTurrets = hitsTurrets
	
	self.Distance = 0
	if solid == nil then
		self.Solid = true
	else
		self.Solid = solid
	end
	
	if self.Solid then
		self.Range = getTrueProjectileRange(position, direction, range)
	end
	
	function self.CFrame(self)
		return CFrame.new(self.Position, self.Position + self.Direction)
	end
	
	function self.FlatCFrame(self)
		local a = self.Position
		local b = self.Position + self.Direction
		b = Vector3.new(b.X, a.Y, b.Z)
		
		return CFrame.new(a, b)
	end
	
	function self.Step(self, dt)
		if not self.Moving then return end
		
		--never let projectiles go further than their range, calculate dDistance
		local dDistance = self.Speed * dt
		if self.Distance + dDistance > self.Range then
			self.Speed = (self.Range - self.Distance) / dt
			dDistance = self.Speed * dt
		end
		
		--raycast and check the map if solid
		if self.Solid then
			local part, pos = workspace:FindPartOnRay(Ray.new(self.Position, self.Direction * dDistance))
			if part then
				if part:IsDescendantOf(workspace.Map) then
					dDistance = (pos - self.Position).magnitude
					self.Moving = false
				end
			end
		end
		
		self.Distance = self.Distance + dDistance
		
		--do a width raycast with all the humanoids
		local ray = Ray.new(self.Position, self.Direction).Unit
		for _, enemy in pairs(GET_ENEMIES:Invoke(self.Team, self.HitsTurrets)) do
			if not inList(enemy, self.TargetsHit) then
				if enemy.Parent:FindFirstChild("HumanoidRootPart") then
					local char = enemy.Parent
					local hrp = char.HumanoidRootPart
					local pos = hrp.Position
					
					if projectileCollides(pos, ray, dDistance, self.Width) then
						self:OnHit(enemy)
						table.insert(self.TargetsHit, enemy)
						
					end
					
					if not self.Moving then
						break
					end
				end
			end
		end
		
		--change my position
		self.Position = self.Position + self.Direction * dDistance

		self:OnStep(dt)
		
		--stop moving if I'm at my max distance
		if self.Distance >= self.Range then
			self.Moving = false
		end
	end
	
	function self.Track(self, parent)
		local tracker = Instance.new("BoolValue")
		tracker.Name = "ProjectileTracker"
		tracker.Parent = parent
		
		tracker.AncestryChanged:connect(function()
			self.Moving = false
		end)
		
		game:GetService("Debris"):AddItem(tracker, 10)
	end
	
	function self.ClientArgs(self)
		return {self.Position, self.Direction, self.Speed, self.Range, self.Id}
	end
	
	table.insert(PROJECTILES, self)
	return self
end

game:GetService("RunService").Heartbeat:connect(function(dt)
	for index, projectile in pairs(PROJECTILES) do
		pcall(function() projectile:Step(dt) end)
		
		if not projectile.Moving then
			table.remove(PROJECTILES, index)
			pcall(function()
				game.ServerScriptService.SFXService.RemoveEffectById:Invoke(projectile.Id)
				projectile:OnEnd()
			end)
		end
	end
end)

script.AddProjectile.OnInvoke = Projectile

script.GetProjectiles.OnInvoke = function()
	return PROJECTILES
end
--/projectile stuff

--melee stuff
function melee(hrp, team, onHit,range,width)
	range = range or 7
	width = width or 5
	local ray = Ray.new(hrp.Position, hrp.CFrame.lookVector)
	for _, enemy in pairs(GET_ENEMIES:Invoke(team, true)) do
		if enemy.Parent:FindFirstChild("HumanoidRootPart") then
			local pos = enemy.Parent.HumanoidRootPart.Position
			
			if projectileCollides(pos, ray, range, width) then
				onHit(enemy)

				break
			end
		end
	end
end

script.Melee.OnInvoke = melee
--/melee stuff

--aoe stuff
function withinAOE(pos, center, range)
	local dx = pos.X - center.X
	local dz = pos.Z - center.Z
	local dist = math.sqrt(dx^2 + dz^2)
	return dist <= range
end

function aoe(center, range, team, onHit)
	for _, enemy in pairs(GET_ENEMIES:Invoke(team)) do
		if enemy.Parent then
			local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
			if hrp then
				local pos = hrp.Position
				if withinAOE(pos, center, range) then
					onHit(enemy)
					
				end
			end
		end
	end
end

script.AOE.OnInvoke = aoe

--Secondary Aoe if you want a aoe within a aoe
function aoe2(center, range, team, onHit)
	for _, enemy in pairs(GET_ENEMIES:Invoke(team)) do
		if enemy.Parent then
			local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
			if hrp then
				local pos = hrp.Position
				if withinAOE(pos, center, range) then
					onHit(enemy)
					
				end
			end
		end
	end
end
script.AOE2.OnInvoke = aoe2
--/aoe stuff

--line stuff
function line(hrp, range, width, team, onHit, turret,direction)
	direction = direction or hrp.CFrame.lookVector
	turret = turret or false
	local ray = Ray.new(hrp.Position, direction)
	for _, enemy in pairs(GET_ENEMIES:Invoke(team, turret)) do
		if enemy.Parent then
			if enemy.Parent:FindFirstChild("HumanoidRootPart") then
				local pos = enemy.Parent.HumanoidRootPart.Position
				if projectileCollides(pos, ray, range, width) then
					onHit(enemy)
	
				end
			end
		end
	end
end

script.Line.OnInvoke = line
--/line stuff

--constructArena stuff
function constructArena(arena, position, constructionTime, duration, color)
	arena = arena:clone()
	for _, part in pairs(arena:GetChildren()) do
			if color == "random" then
			part.BrickColor = BrickColor.palette(math.random(0, 63))
			end
		end
	local size = arena:GetModelSize()
	position = Vector3.new(position.X, position.Y+4, position.Z)
	local cframe = arena:GetModelCFrame()
	local delta = position - cframe.p
	arena:TranslateBy(delta)
	arena.Parent = workspace.Map
	delay(duration + constructionTime + 3,function()
		arena:Destroy()
	end)

	local risingSpeed = size.Y / 4
	local t = 0
	while t < constructionTime do
		local dt = wait()
		
		for _, part in pairs(arena:GetChildren()) do
			part.CFrame = part.CFrame * CFrame.new(0, risingSpeed * dt, 0)
		end
		
		t = t + dt
	end
	
	wait(duration)
	arena.Parent = workspace
	for _, part in pairs(arena:GetChildren()) do
		part.CanCollide = false
		part.Anchored = false
		part.RotVelocity = Vector3.new(
			math.random(-45, 45),
			math.random(-45, 45),
			math.random(-45, 45)
		)
		part.Velocity = Vector3.new(
			math.random(-40, 40),
			math.random(20, 80),
			math.random(-40, 40)
		)
	end
end

script.ConstructArena.OnInvoke = constructArena
--/constructArena stuff
--knockAirborne stuff
function knockAirborne(enemy, height, duration)
	local hrp = enemy.Parent.HumanoidRootPart
	
	local bp = Instance.new("BodyPosition")
	bp.position = Vector3.new(hrp.Position.X,hrp.Position.Y + height, hrp.Position.Z)
	bp.maxForce = Vector3.new(2^15, 2^15, 2^15)
	bp.Parent = hrp
	
	game:GetService("Debris"):AddItem(bp, duration)
	
	ST.Stun:Invoke(enemy, duration)
end

script.KnockAirborne.OnInvoke = knockAirborne
--/knockAirborne stuff

--damage stuff
function reducedDamage(human, damage, type,source)
	if not type then
		return damage
	end
	local enemy = human.Parent
	local get2 
	local penetration = 0
	if source then
		local charS = source.Character:FindFirstChild("CharacterScript")
		 get2 = charS:FindFirstChild("GetStat")
	end
	--local Functions = In(Mobs.Mobs,"Character",enemy)
	local charScript = human.Parent:FindFirstChild("CharacterScript") or human.Parent:FindFirstChild("CharactersScript")
	if charScript then
		
		local get = charScript:FindFirstChild("GetStat")
		
		if get then
			local stat = get:Invoke(type)
			if get2 then
			penetration = get2:Invoke(type.."Penetration")
			end
			local protection = -100 * math.exp(-stat / 300) + 100
			local percent = 1 - ((protection / 100) + penetration)
			local reduced = damage * percent
			
			return reduced
		
		end
	--[[elseif Functions then
			
			local stat = Functions:GetStat(type)
			if get2 then
			penetration = get2:Invoke(type.."Penetration")
			end
			local protection = -100 * math.exp(-stat / 300) + 100
			local percent = 1 - ((protection / 100) + penetration)
			local reduced = damage * percent
			return reduced]]
	end
	return damage
end

function Lifesteal(human,damage, type,poison)
	if poison then return end
	local CounterParts = {Toughness = "Skillz", Resistance = "H4x"}
	
	local charScript = human.Parent:FindFirstChild("CharacterScript")
	if charScript then
		local get = charScript:FindFirstChild("GetStat")
		if get then
			if CounterParts[type] ~= nil then
			local vamp = get:Invoke(CounterParts[type].."Vampirism")
			if vamp > 0 then
			local heal = damage * vamp
			Heal(human, heal)
			end
			end
		end
	end
	
end

function incrementStat(char, stat)
	if char:IsA("Player") then
		char = char.Character
	end
	
	if char then
		local scr = char:FindFirstChild("CharacterScript")
		if scr then
			local gs = scr:FindFirstChild("GetStat")
			local ss = scr:FindFirstChild("SetStat")
			if gs and ss then
				ss:Invoke(stat, gs:Invoke(stat) + 1)
			end
		end
	end
end

function deathAnimation(character)
	for _, part in pairs(character:GetChildren()) do
		if part:IsA("Part") then
			local p = part:clone()
			p.CanCollide = true
			p.Parent = workspace
			game:GetService("Debris"):AddItem(p, 1.5)
		end
	end
end

function breakRecall(character)
	while character:FindFirstChild("Recalling") do
		character.Recalling:Destroy()
	end
end

function getKillers(human)
	local function isIn(tab, val)
		for _, obj in pairs(tab) do
			if obj == val then
				return true
			end
		end
		return false
	end
	
	local killers = {}
	for _, credit in pairs(human:GetChildren()) do
		if credit:IsA("ObjectValue") then
			if credit.Name ~= "KillCredit" then
				if not isIn(killers, credit.Value) then
					table.insert(killers, credit.Value)
				end
			end
		end
	end
	return killers
end


function getKillString(human)
	local killer = human.KillCredit.Value
	local assisters = getKillers(human)
	local str = ""
	
	if #assisters > 0 then
		str = str..killer.Name.." ("
		for idx, assister in pairs(assisters) do
			if idx > 1 then
				str = str..", "
			end
			str = str..assister.Name
		end
		str = str..")"
	else
		str = killer.Name
	end
	
	return str
end

function killExperience(character)
	local center = character.HumanoidRootPart.Position
	local radius = 80
	local team = character.Team.Value
	local amount = character.CharacterScript.GetStat:Invoke("Level")
	local kil = character.CharacterScript.GetStat:Invoke("Kills")
	local death = character.CharacterScript.GetStat:Invoke("Deaths")
	local assisst = character.CharacterScript.GetStat:Invoke("Assists")
	local function onHit(enemy)
		local char = enemy.Parent
		if char then
			local charScript = char:FindFirstChild("CharacterScript")
			if charScript then
				local ge = charScript:FindFirstChild("GiveExperience")
				local gt = charScript:FindFirstChild("GiveTix")
				if ge and gt then
					ge:Invoke(10 +(amount))
					local reward = (50 + (amount))+ (400 + (kil)) +  (150 + (assisst)) - (death * 13)
					if reward < 0 then
						reward = 1
					end
					gt:Invoke(reward)
					if charScript:FindFirstChild("Inventory") and charScript:FindFirstChild("Inventory"):FindFirstChild("Money Socks") then
					gt:Invoke(100 + (amount * 5))	
					end
				end
			end
		end
	end
	aoe(center, radius, team, onHit)
	
	--a kill message!
	local human = character:FindFirstChild("Humanoid")
	if human then
		local credit = human:FindFirstChild("KillCredit")
		local msgAll = game.ServerScriptService.MessageService.MessageAll
		if msgAll and credit then
			local player = credit.Value
			local char = player.Character
			if char then
				incrementStat(credit.Value, "Kills")
				for _, assister in pairs(getKillers(human)) do
					incrementStat(assister, "Assists")
				end
				msgAll:Invoke(getKillString(human), "has slain "..character.Name.."!", player.TeamColor.Color)
				spawn(function()
					POINTS:AwardPoints(player.userId, 2)
					KILL_LB:IncrementAsync(player.Name)
				end)
			end
		else
			msgAll:Invoke(character.Name, "has been slain!")
		end
	end
	
	incrementStat(character, "Deaths")
end

--[[
function killExperience(character)
	local center = character.HumanoidRootPart.Position
	local radius = 64
	local team = character.Team.Value
	local amount = character.CharacterScript.GetStat:Invoke("Level")
	
	local killerValue = game.ReplicatedStorage.GetPlayerValue:Invoke(character.Humanoid.KillCredit.Value);
	local victimValue = game.ReplicatedStorage.GetPlayerValue:Invoke(game.Players:GetPlayerFromCharacter(character));
	
	local function onHit(enemy)
		local char = enemy.Parent
		if char and victimValue >= killerValue * .5 then
			local charScript = char:FindFirstChild("CharacterScript")
			if charScript then
				local ge = charScript:FindFirstChild("GiveExperience")
				local gt = charScript:FindFirstChild("GiveTix")
				if ge and gt then
					ge:Invoke(amount)
					gt:Invoke(amount * 18)
				end
			end
		end
	end
	aoe(center, radius, team, onHit)
	
	--a kill message!
	local human = character:FindFirstChild("Humanoid")
	if human then
		local credit = human:FindFirstChild("KillCredit")
		local msgAll = Game.ServerScriptService.MessageService.MessageAll
		if msgAll and credit then
			local player = credit.Value
			local char = player.Character
			if char then
				if(char:FindFirstChild("CharacterScript")) then
					if(victimValue >= killerValue * .5) then
						incrementStat(credit.Value, "Kills")
						for _, assister in pairs(getKillers(human)) do
							incrementStat(assister, "Assists")
						end
						msgAll:Invoke(getKillString(human), "has slain "..character.Name.."!", player.TeamColor.Color)
						spawn(function()
							POINTS:AwardPoints(player.userId, 10)
							KILL_LB:IncrementAsync(player.Name)
						end)
					end
				end
			end
		else
			msgAll:Invoke(character.Name, "has been slain!")
		end
	end
	
	incrementStat(character, "Deaths")
end
]]
function Heal(human, amount, regen)
	regen = regen or false
	if human.Parent.Name ~= "Golem" then
	local health = human.Health
	local after = health + amount
	if after > human.MaxHealth then
		after = human.MaxHealth		
	end
	human.Health = after
	end
end

script.Heal.OnInvoke = Heal
--/heal stuff
function GolHeal(human, amount)
	local health = human.Health
	local after = health + amount
	if after > human.MaxHealth then
		after = human.MaxHealth
	end
	human.Health = after
end

script.GolemHeal.OnInvoke = GolHeal
--Specially made for legolems
function CheckPassives(src,hum,damage,pst)
	if src.Character:FindFirstChild("CharacterScript") and src.Character:FindFirstChild("CharacterScript"):FindFirstChild("Inventory") and pst == false then
	local Inventory = src.Character.CharacterScript.Inventory
	for i,v in pairs(Inventory:GetChildren()) do
		if v:FindFirstChild("PassiveScript") and v:FindFirstChild("PassiveScript"):FindFirstChild("Passive") and v.Name ~= "Prickly Helmet" then
		v.PassiveScript.Passive:Invoke(hum,damage)	
end
	end
	end
end
function CheckMyPassives(src,damage,pst,hum)
	if game.Players:GetPlayerFromCharacter(src) then
	local Inventory = src.CharacterScript.Inventory
	for i,v in pairs(Inventory:GetChildren()) do
		if v:FindFirstChild("PassiveScript") and v:FindFirstChild("PassiveScript"):FindFirstChild("MyPassive") then
		v.PassiveScript.MyPassive:Invoke(damage,hum)	
end
	end
	end
end
function damage(human, damage, type, source, reduce, sourcehuman, heal, pst)
	if not human then return end
	if human.Health <= 0 then return end
	if not human.Parent then return end
	if human.Parent:FindFirstChild("ForceField") then return end
	if human:FindFirstChild("Dead") then return end
	reduce = reduce or nil
	sourcehuman = sourcehuman or nil
	heal = heal or nil
	pst = pst or false
	breakRecall(human.Parent)
	
	if source then
		local kc = human:FindFirstChild("KillCredit")
		if kc then
			if source ~= kc.Value then
				local ac = kc:Clone()
				ac.Name = "AssistCredit"
				ac.Parent = human
				DEBRIS:AddItem(ac, 8)
			end
			
			kc:Destroy()
		end

		for _, credit in pairs(human:GetChildren()) do
			if credit:IsA("ObjectValue") then
				if credit.Value == source then
					credit:Destroy()
				end
			end
		end
		
		kc = Instance.new("ObjectValue")
		kc.Name = "KillCredit"
		kc.Parent = human
		kc.Value = source
		DEBRIS:AddItem(kc, 5)
	end
	
	damage = reducedDamage(human, damage, type,source)
	if source then
		local char = source.Character
		local hum = char:FindFirstChild("Humanoid")
		if hum then
		Lifesteal(hum,damage, type,pst)
		end
	end
	if human.Parent:FindFirstChild("Shield") then
		local shield = human.Parent:FindFirstChild("Shield")
		if shield.Value >= damage then
			shield.Value = shield.Value - damage
			damage = 0
		elseif shield.Value < damage then
			damage = damage - shield.Value
			shield.Value = 0
		end
	end
	
	
		
	if source then
		local char = human.Parent
		if char then
			local head = char:FindFirstChild("Head")
			if head then
				if damage > 1.9 then
			R.SFX.RisingMessage:FireClient(source, head.Position + Vector3.new(0, 2, 0), "-"..math.floor(damage), 0.75, {
						TextColor3 = Color3.new(1, 0, 0)
					}, true,head.Parent.Name, pst)
		if game.Players:GetPlayerFromCharacter(human.Parent) and source.Character:FindFirstChild("Aggro") and source.Character:FindFirstChild("Aggro").Value == false then
		source.Character.Aggro.Value = true
			delay(5,function()
			source.Character.Aggro.Value = false
			end)
			end
			
				end
			end
		end
	end
	
	local health = human.Health
	local after = health - damage
	if after <= 0 then
		local player = game.Players:GetPlayerFromCharacter(human.Parent)
		if player then
			if reduce then
				if source.Backpack.CharMods.Value == "Nightgaladeld" then
					reduce.AbilityCooldownReduce:Invoke("A", 12.5)
					--source.Character:FindFirstChild("AbilityCooldownReduce", true):Invoke("A", 12.5)
				end
			end
			local team = human.Parent:FindFirstChild("GetTeam")
			if team then
				--deathAnimation(human.Parent)
				
				spawn(function() killExperience(human.Parent) end)
				
				team = team:Invoke()
				team:Respawn(human.Parent)
			end
		else
			human.Parent:BreakJoints()
		end
	else
		human.Health = after
		if reduce and source.Backpack.CharMods.Value == "ColdArmada" then
			local player = game.Players:GetPlayerFromCharacter(human.Parent)
			if player then
				player.Character.CharacterScript.AbilityCooldown:Invoke("A", reduce)
				player.Character.CharacterScript.AbilityCooldown:Invoke("B", reduce)
				player.Character.CharacterScript.AbilityCooldown:Invoke("C", reduce)
				player.Character.CharacterScript.AbilityCooldown:Invoke("D", reduce)
			end
		end
		if heal then
			local char = human.Parent
			if game.Players:GetPlayerFromCharacter(char) then
				Heal(sourcehuman, (heal+(heal*.04)))
			else
				Heal(sourcehuman, (heal+(heal*.02)))
			end
		end
	CheckMyPassives(human.Parent,damage,pst,source)
	end
	
	if damage / human.MaxHealth > .05 then
		local player = game.Players:GetPlayerFromCharacter(human.Parent)
		if player then
			R.DamageFlash:FireClient(player)
		end
	end
if source then
		CheckPassives(source,human,damage,pst)
end

end

script.Damage.OnInvoke = damage
--/damage stuff
--Return Damge stuff
function returndamage(human, damage, type, source, reduce, sourcehuman)
	if not human then return end
	if human.Health <= 0 then return end
	if not human.Parent then return end
	if human.Parent:FindFirstChild("ForceField") then return end
	if human:FindFirstChild("Dead") then return end
	reduce = reduce or nil
	sourcehuman = sourcehuman or nil
	breakRecall(human.Parent)
	
	if source then
		local kc = human:FindFirstChild("KillCredit")
		if kc then
			if source ~= kc.Value then
				local ac = kc:Clone()
				ac.Name = "AssistCredit"
				ac.Parent = human
				DEBRIS:AddItem(ac, 8)
			end
			
			kc:Destroy()
		end

		for _, credit in pairs(human:GetChildren()) do
			if credit:IsA("ObjectValue") then
				if credit.Value == source then
					credit:Destroy()
				end
			end
		end
		
		kc = Instance.new("ObjectValue")
		kc.Name = "KillCredit"
		kc.Parent = human
		kc.Value = source
		DEBRIS:AddItem(kc, 8)
	end
	
	damage = reducedDamage(human, damage, type)
	if source then
		local char = human.Parent
		if char then
			local head = char:FindFirstChild("Head")
			if head then
				if damage > 1 then
			if game.Players:GetPlayerFromCharacter(char) then
			R.SFX.RisingMessage:FireClient(game.Players:GetPlayerFromCharacter(char), head.Position + Vector3.new(0, 2, 0), "-"..math.floor(damage).." Returned!", 0.75, {
						TextColor3 = Color3.new(1, 0, 0)
			}, true)
			R.SFX.RisingMessage:FireClient(source, head.Position + Vector3.new(0, 2, 0), "-"..math.floor(damage).." Returned!", 0.75, {
						TextColor3 = Color3.new(1, 0, 0)
			}, true)
			if game.Players:GetPlayerFromCharacter(human.Parent) and source.Character:FindFirstChild("Aggro") and source.Character:FindFirstChild("Aggro").Value == false then
			source.Character.Aggro.Value = true
			delay(5,function()
			source.Character.Aggro.Value = false
			end)
			end
			end
			
				end
			end
		end
	end
	
	local health = human.Health
	local after = health - damage
	if after <= 0 then
		local player = game.Players:GetPlayerFromCharacter(human.Parent)
		if player then
			local team = human.Parent:FindFirstChild("GetTeam")
			if team then
				--deathAnimation(human.Parent)
				
				spawn(function() killExperience(human.Parent) end)
				
				team = team:Invoke()
				team:Respawn(human.Parent)
			end
		else
			human.Parent:BreakJoints()
		end
	else
		human.Health = after
	end
	
	


end
--/returndamagestuff
script.returnDamage.OnInvoke = returndamage
--targeted stuff
function targeted(a, range, b)
	b = Vector3.new(b.X, a.Y, b.Z)
	
	local measureA = Vector3.new(a.X, a.Y, a.Z)
	local measureB = Vector3.new(b.X, b.Y, b.Z)
	local dist = (measureB - measureA).magnitude
	
	if dist < range then
		return b
	else
		local vector = (b - a).unit
		return a + vector * range
	end
end

script.Targeted.OnInvoke = targeted
--/targeted stuff

--stealth stuff
function stealth(char, duration)
	local parts = {}
	local function recurse(root)
		for _, child in pairs(root:GetChildren()) do
			if child:IsA("BasePart") or child:IsA("Decal") then
				table.insert(parts, {
					Part = child,
					Transparency = child.Transparency
				})
			end
			recurse(child)
		end
		end
	recurse(char)
	
	local gui = char.Head:FindFirstChild("TeamGui")
	
	if gui then
		gui.Enabled = false
	end
	game.ReplicatedStorage.Remotes.Stealth:FireClient(game.Players:GetPlayerFromCharacter(char),parts, duration)
	for _, data in pairs(parts) do
		data.Part.Transparency = 1
	end
	delay(duration, function()
		if gui then
			gui.Enabled = true
		end
		for _, data in pairs(parts) do
			data.Part.Transparency = data.Transparency
		end
	end)
end

script.Stealth.OnInvoke = stealth
--/stealth stuff


--/stealth stuff

--nearestTarget stuff
function nearestTarget(position, range, team)
	local enemies = GET_ENEMIES:Invoke(team)
	local best = nil
	local bestRange = range
	for _, enemy in pairs(enemies) do
		local parent = enemy.Parent
		if parent then
			local hrp = parent:FindFirstChild("HumanoidRootPart")
			if hrp then
				local pos = Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
				local dist = (pos - position).magnitude
				if dist < bestRange then
					best = enemy
					bestRange = dist
				end
			end
		end
	end
	return best
end

script.NearestTarget.OnInvoke = nearestTarget
--/nearestTarget stuff