local dogeMesh = Instance.new("SpecialMesh")
dogeMesh.MeshType = "FileMesh"
dogeMesh.MeshId = "http://www.roblox.com/asset/?id=151778863"
dogeMesh.TextureId = "http://www.roblox.com/asset/?id=151778895"

local adverbs = {"so", "very", "how", "much", "quite", "wow"}
local noun = {"damage", "special", "boom", "candidate", "attack", "wow"}
local function dogeMessage()
	return adverbs[math.random(1, #adverbs)].." "..noun[math.random(1, #noun)]
end

local function r(...)
	return math.random(...)
end

local function rc()
	return BrickColor.palette(math.random(0, 63))
end

local function dogePart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.FormFactor = "Symmetric"
	part.Size = Vector3.new(1, 1, 1)
	part.Transparency = 1
	
	local bg = Instance.new("BillboardGui")
	bg.Name = "MessageGui"
	bg.Size = UDim2.new(4, 0, 4, 0)
	bg.Parent = part
	
	local tl = Instance.new("TextLabel")
	tl.Name ="Message"
	tl.TextScaled = true
	tl.TextStrokeTransparency = 0
	tl.TextColor3 = Color3.new(math.random(), math.random(), math.random())
	tl.Text = dogeMessage()
	tl.Size = UDim2.new(1, 0, 1, 0)
	tl.BackgroundTransparency = 1
	tl.Parent = bg

	return part
end

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 1.25 - (1.25 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	local damage = d.CONTROL.GetStat:Invoke("H4x") * 0.25
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DogeBasicAttackFinal-item?id=263115607")
	
	
	local part = dogePart()
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local position = d.CHAR.Head.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 32
	local speed = 80
	local width = 4
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		p.Moving = false
		d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1.25, "Resistance", d.PLAYER)
		end 
	end
	local function onStep() end
	local function onEnd() end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd, nil, true)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,rc().Name, 0.25,direction,"Neon",0.039)
end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 3 - (3 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local tagName = d.PLAYER.Name.."Doged"
	local tagName2 = d.PLAYER.Name.."Derped"
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DogeVeryWow-Startup-Final-item?id=263116004")
	wait(0.5)
	
	local part = d.CHAR.Doge:Clone()
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 0
	part.Size = Vector3.new(3.86, 3.54, 3.2)
	part.Mesh.Scale = Vector3.new(2,2,2)
	--part = game.ServerStorage.DogeProjectile:Clone()
	for _, obj in pairs(part:GetChildren()) do if not obj:IsA("SpecialMesh") then obj:Destroy() end end
	part.Parent = game.ReplicatedStorage
	d.DB(part)
	
	local center = d.CHAR.Head.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 48
	local speed = 64
	local width = 4
	local team = d.CHAR.Team.Value
	
	local function onHit(p, enemy)
		p.Moving = false

		local hrp = d.GET_HRP(enemy)
		if hrp then
			d.ST.Tag:Invoke(enemy, 1, tagName2)
			if d.ST.GetEffect:Invoke(enemy, tagName) then
				local position = hrp.Position
				local radius = 16
				local function onHit(enemy)
					d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
					if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
					d.ST.Tag:Invoke(enemy, 6, tagName)
					if d.ST.GetEffect:Invoke(enemy, tagName2) then
						d.DS.Damage:Invoke(enemy, damage * -1, "Resistance", d.PLAYER)
					end
				end
				d.DS.AOE:Invoke(position, radius, team, onHit)
				d.SFX.Explosion:Invoke(position, radius, rc().Name)
			end
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			d.ST.Tag:Invoke(enemy, 6, tagName)
		end
	end
	local function onStep() end
	
	local function onEnd()
		 end
	local p = d.DS.AddProjectile:Invoke(center, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjPart:Invoke(p:ClientArgs(), part, CFrame.new())
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,rc().Name, 0.25,direction,"Neon",0.039)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local damage = ability:C(data.damage)
	local slow = -ability:C(data.slow)/100
	local duration = ability:C(data.duration)
	local tagName = d.PLAYER.Name.."Doged"
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DogeKeepurHandsAwayFinal-item?id=263117422")
	
	local center = d.HRP.Position
	local radius = 12
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		local hrp = d.GET_HRP(enemy)
		if hrp then
			local message = dogeMessage()
			
			if d.ST.GetEffect:Invoke(enemy, tagName) then
				d.ST.MoveSpeed:Invoke(enemy, slow, duration)
				message = "u ben doged"
			end
			
			d.SFX.RisingMessage:Invoke(
				hrp.Position + Vector3.new(0, 2, 0),
				message,
				1,
				{TextColor3 = Color3.new(r(), r(), r())}				
			)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
			d.ST.Tag:Invoke(enemy, 6, tagName)
		end
	end
	d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Explosion:Invoke(center, radius, rc().Name)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12 - (12 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	local damage = ability:C(data.damage)
	local tagName = d.PLAYER.Name.."Doged"
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DogeWhatRUDoingFinal-item?id=276955595")
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 40
	local speed = range / 0.75
	local width = 4
	local team = d.CHAR.Team.Value
	local function onHit(p, enemy)
		p.Moving = false
		local special = false
		local hrp = d.GET_HRP(enemy)
		if hrp then
			if d.ST.GetEffect:Invoke(enemy, tagName) then
				d.CONTROL.AbilityCooldownReduce:Invoke("C", 6 - (6 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
			end
			
			d.DS.KnockAirborne:Invoke(enemy, 12, 1)
			d.DS.Damage:Invoke(enemy, damage, "Resistance", d.PLAYER)
			if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Resistance", d.PLAYER)
		end 
		end
	end
	local function onStep() end
	local function onEnd() end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
	d.SFX.ProjTrail:Invoke(p:ClientArgs(), 0.2,rc().Name, 0.25,direction,"Neon",0.039)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 50 - (50 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local duration = ability:C(data.duration)
	local slow = -ability:C(data.slow)/100
	local tagName = d.PLAYER.Name.."Doged"
	
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DogeSoScareFinal-item?id=263118210")
	wait(0.7)
	
	local position = d.CHAR.Head.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 36
	local width = 8
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.ST.MoveSpeed:Invoke(enemy, slow, duration)
		if d.ST.GetEffect:Invoke(enemy, tagName) then
			d.ST.Stun:Invoke(enemy, duration)
			local hrp = d.GET_HRP(enemy)
			if hrp then
				d.SFX.RisingMessage:Invoke(
					hrp.Position,
					'ultimate doge!',
					1,
					{TextColor3 = Color3.new(r(), r(), r())}
				)
			end
		end
	end
	d.DS.Line:Invoke(d.HRP, range, width, team, onHit)
	d.SFX.Line:Invoke(position, direction, range, width, rc().Name)
end
script.Ability4.OnInvoke = ability4

local abilityData = {
	A = {
		Name = "Very Wow",
		Desc = "Using a powerful doge-speak known as 'very wow', Doge fires his flawless head at enemies, dealing <damage> damage and applying a 'Doged' effect. If this move is used on a Doged enemy, then the head explodes, spreading the 'Doged' effect and damage to nearby enemies.",
		MaxLevel = 5,
		damage = {
			Base = 22.5,
			AbilityLevel = 5,
			H4x = 0.3,
		}
	},
	B = {
		Name = "'keep ur hands away from me'",
		Desc = "Doge wants to keep 'ur hands away from' him. He creates an AOE at his location, dealing <damage> damage and giving the 'Doged' effect to all nearby enemies. Enemies that are already 'Doged' are slowed by <slow>% for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			Base = 25,
			AbilityLevel = 5,
			H4x = 0.35,
		},
		slow = {
			Base = 25,
			AbilityLevel = 5,
		},
		duration = {
			Base = 2.25,
		}
	},
	C = {
		Name = "'What r you doing'",
		Desc = "Doge wants to know what your doing. That's kinda hard from away, so he charges to your location dealing <damage> damage to you and knocking you airborne. If you happen to be 'Doged', then the cooldown of the move will be drastically decreased.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 10,
			H4x = 0.4,
		}
	},
	D = {
		Name = "'so scare'",
		Desc ="Doge scares everyone in front of him. All enemies which are not 'Doged' are slowed by <slow>% for <duration> seconds. However, all 'Doged' enemies are stunned for <duration> seconds.",
		MaxLevel = 3,
		duration = {
			Base = 3,
			
		},
		slow = {
			Base = 20,
			AbilityLevel = 10,
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
	Health = function(level)
		return 160 + level * 20
	end,
	Skillz = function(level)
		return 0
	end,
}
script.CharacterData.OnInvoke = function()
	return characterData
end


--test