local Class = require(game.ReplicatedStorage.Classes.Class)
--local Mobs = require(game.ServerScriptService.UnitedCharacterScript) 
local Mob = Class:Extend()
function In(tab,stuff,object,thing)
	thing = thing or "Functions"
	for _,v in pairs(tab) do
		if v[stuff] == object then
			return v[thing]
		end
	end
end
function Mob:OnNew()
	self.Active = true
	
	--model information gathering
	self.Root = self.Model.HumanoidRootPart
	self.Human = self.Model.Humanoid
	
	--ensure old stuff works
	local characterScript = game.ServerStorage.Scripts.CharactersScript:Clone()
	characterScript.Disabled = false
	characterScript.Parent = self.Model
	self.CharacterScript = characterScript
	--self.CharacterScript = Mobs:CharacterScript(self.Model)
	local HealthScript = game.ServerStorage.Scripts.HealthScript:Clone()
	HealthScript.Disabled = false
	HealthScript.Parent = self.Model
	self.HealthScript = HealthScript
	
	--ai variables
	self.AttackAble = true
	self.AttackRestTime = 1.33
	self.StartingPoint = self.Root.Position
	self.DetectionRange = 16
	self.MeleeRange = 4
	self.ReturnRange = 16
	self.State = "Waiting"
	
	--create a gui
	self:AcquireTeamGui()
	
	--join the balance service
	self:JoinBalanceService()
	
	--animations
	self:InitializeAnimations()
end

function Mob:AddAnimationTrack(name, id)
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://"..id
	
	self.AnimationTracks[name] = self.Model.Humanoid:LoadAnimation(anim)
end

function Mob:PlayAnimation(name, ...)
	local track = self.AnimationTracks[name]
	if track then
		track:Play(...)
	end
end

function Mob:StopAnimation(name)
	local track = self.AnimationTracks[name]
	if track then
		track:Stop()
	end
end

function Mob:InitializeAnimations()
	self.AnimationTracks = {}
	
	self:AddAnimationTrack("Punch", 436447873)
	self:AddAnimationTrack("Walk", 180426354)
end

function Mob:JoinBalanceService()
	local balanceService = game.ServerScriptService:WaitForChild("BalanceService")
	balanceService.AddCharacter:Invoke(self.Model)
end

function Mob:AcquireTeamGui()
	local teamService = game.ServerScriptService:WaitForChild("TeamScript")
	local neutralTeam = teamService.GetTeamByName:Invoke("Neutral Team")
	neutralTeam:CreateTeamGui(self.Model)
end

function Mob:GetStat(statName)
	local statBindable = self.Model:FindFirstChild("GetStat", true)
	if statBindable then
		return statBindable:Invoke(statName)
	end
end

function Mob:DistanceTo(point)
	return (point - self.Root.Position).magnitude
end

function Mob:Contains(t, v)
	for _, val in pairs(t) do
		if val == v then
			return true
		end
	end
	return false
end

function Mob:GetRootFromHumanoid(humanoid)
	if humanoid then
		local char = humanoid.Parent
		if char then
			return char:FindFirstChild("HumanoidRootPart")
		end
	end
end

function Mob:GetPointFromHumanoid(humanoid)
	local root = self:GetRootFromHumanoid(humanoid)
	if root then
		return root.Position
	else
		return self.StartingPoint
	end
end

function Mob:GetNearestPlayer()
	local humanoidService = game.ServerScriptService.HumanoidService
	local playerHumanoids = humanoidService.GetPlayers:Invoke()
	
	local nearestPlayer = nil
	local smallestDistance = self.DetectionRange
	
	for _, playerHumanoid in pairs(playerHumanoids) do
		local playerRoot = self:GetRootFromHumanoid(playerHumanoid)
		if playerRoot then
			local distance = self:DistanceTo(playerRoot.Position)
			if distance < smallestDistance then
				nearestPlayer = playerHumanoid
				smallestDistance = distance
			end
		end
	end
	
	return nearestPlayer
end

function Mob:Face(point)
	local a = self.Root.Position
	local b = Vector3.new(point.X, a.Y, point.Z)
	self.Root.CFrame = CFrame.new(a, b)
end

function Mob:MoveTo(point)
	self.Human:MoveTo(point)
end

function Mob:StopMoving()
	self:MoveTo(self.Root.Position)
end

function Mob:GiveReward(char)
	local giveExp = char:FindFirstChild("GiveExperience", true)
	if giveExp then
		giveExp:Invoke(self:GetStat("ExpReward"))
	end
	
	local giveTix = char:FindFirstChild("GiveTix", true)
	if giveTix then
		giveTix:Invoke(self:GetStat("TixReward"))
	end
end

function Mob:DyingHeal(char,amount)
	local human = char:FindFirstChild("Humanoid")
	if human then
		local damageService = game.ServerScriptService.DamageService
		damageService.GolemHeal:Invoke(human, human.MaxHealth * amount)
	end
end

function Mob:DyingBuff(char,stat,amount)
	local human = char:FindFirstChild("Humanoid")
	if human then
		local ST = game.ServerScriptService.StatusService
		if stat == "Attack" and not ST.GetEffect:Invoke(human, "JungleSkillz") and not ST.GetEffect:Invoke(human, "H4x") then
		ST.StatBuff:Invoke(human, "Skillz", char.CharacterScript.GetStat:Invoke("Skillz") * amount/100, 90,"JungleSkillz")
		ST.StatBuff:Invoke(human, "H4x", char.CharacterScript.GetStat:Invoke("H4x") * amount/100, 90,"JungleH4x")
		elseif stat == "BasicCDR" and not ST.GetEffect:Invoke(human, "JungleBasicCDR")  then
		ST.StatBuff:Invoke(human, stat, amount/100, 90,"JungleBasicCDR")
		elseif not ST.GetEffect:Invoke(human, "Jungle"..stat) then
		ST.StatBuff:Invoke(human, stat, char.CharacterScript.GetStat:Invoke(stat) * amount/100, 90,"Jungle"..stat)
		end
	end
end

function Mob:GetKillerChar()
	local killCredit = self.Human:FindFirstChild("KillCredit")
	if killCredit then
		if killCredit.Value then
			return killCredit.Value.Character
		end
	end
end

function Mob:Deactivate()
	self.Active = false
end

function Mob:RemoveModel()
	game:GetService("Debris"):AddItem(self.Model, 1.5)
end

function Mob:OnDeath()
	local char = self:GetKillerChar()
	local reward = self.Model.HumanoidRootPart:FindFirstChild("Reward")
	local val = reward.Value
	local healamount = reward.HealAmount.Value
	local other = reward:FindFirstChild("Type")
	local others = reward:FindFirstChild("Amount")
	if char then
		self:GiveReward(char)
		if val == "Heal" then
		self:DyingHeal(char,healamount)
		elseif other and others then
		self:DyingBuff(char,other.Value,others.Value)
		self:DyingHeal(char,healamount)
		end
	end
	
	self:Deactivate()
	self:RemoveModel()
end

function Mob:FullHeal()
	local damageService = game.ServerScriptService.DamageService
	damageService.GolemHeal:Invoke(self.Human, self.Human.MaxHealth)
end

function Mob:CooldownAttack()
	self.AttackAble = false
	self.State = "Resting"
	self:StopAnimation("Walk")
	delay(self.AttackRestTime, function()
		self.AttackAble = true
		self.State = "Chasing"
		self:PlayAnimation("Walk")
	end)
end

function Mob:DamageTarget()
	local damageService = game.ServerScriptService.DamageService
	local damage = self:GetStat("Skillz") or 0
	
	damageService.Damage:Invoke(self.Target, damage, "Toughness")
end

function Mob:Attack()
	if not self.AttackAble then return end
	
	self:CooldownAttack()
	self:PlayAnimation("Punch")
	self:Face(self:GetTargetPoint())
	delay(0.5, function()
		self:Face(self:GetTargetPoint())
		self:DamageTarget(self:GetTargetPoint())
	end)
end

function Mob:ShouldStopChasing(targetPoint)
	local ranAway = self:DistanceTo(targetPoint) > self.DetectionRange
	local farAway = self:DistanceTo(self.StartingPoint) > self.ReturnRange
	return ranAway or farAway
end

function Mob:StateWaiting(dt)
	self:StopMoving()
	if self.Human.Health == self.Human.MaxHealth then return end
	self.Target = self:GetNearestPlayer()
	if self.Target ~= nil then
		self.State = "Chasing"
		self:PlayAnimation("Walk")
	else
	self:FullHeal()
	end
end

function Mob:GetTargetPoint()
	return self:GetPointFromHumanoid(self.Target)
end

function Mob:StateChasing(dt)
	local targetPoint = self:GetPointFromHumanoid(self.Target)
	
	if self:DistanceTo(targetPoint) < self.MeleeRange then
		self:Attack()
	elseif self:ShouldStopChasing(targetPoint) then
		self.Target = nil
		self.State = "Returning"
	else
		self:MoveTo(targetPoint)
	end
end

function Mob:StateReturning(dt)
	self:FullHeal()
	self:MoveTo(self.StartingPoint)
	
	if self:DistanceTo(self.StartingPoint) < self.MeleeRange then
		self.State = "Waiting"
		self:StopAnimation("Walk")
	end
end

function Mob:StateResting(dt)
	self:StopMoving()
end

function Mob:StateMachine(dt)

	if self.State == "Waiting" then
		self:StateWaiting(dt)
	elseif self.State == "Chasing" then
		self:StateChasing(dt)
	elseif self.State == "Returning" then
		self:StateReturning(dt)
	elseif self.State == "Resting" then
		self:StateResting(dt)
	end
end

function Mob:Dead()
	return self.Human.Health <= 0
end

function Mob:Update(dt)
	self:StateMachine()
	
	if self:Dead() then
		self:OnDeath()
	end
end

return Mob