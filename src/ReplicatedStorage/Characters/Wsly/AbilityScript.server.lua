local attackNumber = 1
local bonusDamage = 0
function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", 0.75 - (0.375 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * 0.4 + ((d.CONTROL.GetStat:Invoke("Skillz") * .4) * bonusDamage)
		
	d.PLAY_SOUND(d.HUMAN, 12222216)
	attackNumber = attackNumber + 1
	if attackNumber > 2 then
		attackNumber = 0
	end
	
	d.PLAY_SOUND(d.HUMAN, 12222216)
	
	if attackNumber == 1 then 
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/DeadpoolBasicAttack1Final-item?id=263086897")
	else
		d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/WslyBasicAttack1Final-item?id=263140441")
		wait(0.2)
	end
		local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		
		d.RefreshStack(d.HUMAN, getStackName(d))
		d.CONTROL.AbilityCooldownReduce:Invoke("D", 0.75)
	end
	d.DS.Melee:Invoke(hrp, team, onHit,10,6) 

end
script.BasicAttack.OnInvoke = basicAttack

function getStackName(d)
	return d.PLAYER.Name.."WslyDeathRun"
end

	
function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 7.5 - (7.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	wait(0.15)
	local damage = ability:C(data.damage)
	local tagName = getStackName(d)
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=396462642")
	
	local tagName = getStackName(d)
	local stackcount = d.ST.GetStatusCount:Invoke(d.HUMAN, tagName)
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local speed = 28 * 6
	local width = 6
	local range = 23
	local team = d.CHAR.Team.Value
	local circles = 0
	local topos = Vector3.new(0,0,0)
	local dir = d.HRP.Rotation
	local damage = ability:C(data.damage)
	local function onHit(projectile, enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
			if not d.IS_MINION(enemy.Parent) then
		if stackcount < 10 then
			d.EasyStack(d.HUMAN, tagName, 10)
			
		
		elseif stackcount >= 10 then
			d.RefreshStack(d.HUMAN, getStackName(d))
	
		
			end
		end
	end
	local function onStep(projectile)
		topos = projectile.Position
	
	end
	local function onEnd(projectile)
		d.HRP.CFrame = projectile:CFrame()
	end
	local p = d.PROJECTILE:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
	repeat
	wait(.1)
	circles = circles + 1
	d.SFX.Circles:Invoke(topos, 6,script.Parent.Parent.Character.Torso.Skills.Value.Color,.2,dir)
	until circles == 3
end
	
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 10 - (10 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local range = 16
	local damage = ability:C(data.damage)
	local tagName = getStackName(d)
	local stackcount = d.ST.GetStatusCount:Invoke(d.HUMAN, tagName)
	
	wait(0.15)
	d.PLAY_ANIM(d.PLAYER, "http://www.roblox.com/WslyLeapFinal-item?id=263141055")
	
	local p = d.EasyProjectile{
		Position = d.HRP.Position,
		Direction = d.HRP.CFrame.lookVector,
		Speed = range * 3,
		Range = range,
		OnEnd = function(p)
			d.DS.AOE:Invoke( p.Position, 14, d.CHAR.Team.Value, function(enemy) 
					d.EasyDamage(enemy, damage, "Toughness")
				if enemy.Parent.Name == "Minion" then
			d.EasyDamage:Invoke(enemy, damage*1, "Toughness")
		end 
				
					if stackcount ==10 then
					d.ST.Stun:Invoke(enemy, 1) 
					end
				end
			)
			d.SFX.Explosion:Invoke(p.Position, 14, script.Parent.Parent.Character.Torso.Skills.Value.Color)
		end
	}

	d.SFX.ProjLeap:Invoke(p:ClientArgs(), d.HRP, range/3)
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 16 - (13 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	local tagName = getStackName(d) 
	local boost = ability:C(data.boost)
	local duration = ability:C(data.duration)
	wait(0.15)
	local stacks = math.max(d.ST.GetStatusCount:Invoke(d.HUMAN, tagName), 1)
	local stackcount = d.ST.GetStatusCount:Invoke(d.HUMAN, tagName)
	local speed = stacks * boost
	local buff = d.CONTROL.GetStat:Invoke("Skillz") * 0.25
	d.ST.StatBuff:Invoke(d.HUMAN, "Speed",speed, duration)
	d.ST.MoveSpeed:Invoke(d.HUMAN, .125, duration)
	if stackcount ==  10 then
		d.ST.StatBuff:Invoke(d.HUMAN, "Skillz", buff, 5)  
	end
	d.SFX.Trail:Invoke(d.HRP, Vector3.new(0, 0, 0), 1, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skills.Value.Color)}, 0.5, duration)
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", 50 - (50 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	    d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 32, {BrickColor = d.C(script.Parent.Parent.Character.Torso.Skills.Value.Color)}, 0.1)
	local tagName = getStackName(d)
	local extraDamage = ability:C(data.extraDamage)/100
	wait(0.15)
	d.PLAY_SOUND(d.HUMAN, 96626016)
	
	local fire = Instance.new("Fire")
	fire.SecondaryColor = BrickColor.new(script.Parent.Parent.Character.Torso.flame.Value.Color).Color
	fire.Color = BrickColor.new(script.Parent.Parent.Character.Torso.Skills.Value.Color).Color
	fire.Parent = d.HRP
	
	local t = ability:C(data.duration)
	while t > 0 do
		local stackcount = d.ST.GetStatusCount:Invoke(d.HUMAN, tagName)
		if stackcount <10 then
		d.EasyStack(d.HUMAN, tagName, 5)
		end
		if stackcount >= 10 then
		d.RefreshStack(d.HUMAN, getStackName(d))
		end
		
		bonusDamage = extraDamage
		t = t - wait(0.00005)
		end
	bonusDamage = 0
	
	fire:Destroy()
end
script.Ability4.OnInvoke = ability4

function initializeStackGui()
	local backpack = script.Parent
	local controlScript = backpack:WaitForChild("ControlScript")
	local data = controlScript.GetData:Invoke()
	
	data.R.WslyTrackStacks:FireClient(data.PLAYER, data.CHAR, getStackName(data))
end

local abilityData = {
	A = {
		Name = "Dash",
		Desc = "Wsly dashes, dealing <damage> damage to enemies he passes through. Each time he hits an enemy player, he earns a stack of Death Run, up to a maximum of 10.",
		MaxLevel = 5,
		damage = {
			Base = 20,
			AbilityLevel = 7.5,
			Skillz = 0.3,
		}
	},
	B = {
		Name = "Leap",
		Desc = "Wsly jumps as he would to avoid an obstacle. Upon landing, he deals <damage> damage to surrounding enemies. At 10 stacks, the explosion stuns enemies for 1 second.",
		MaxLevel = 5,
		damage = {
			Base = 15,
			AbilityLevel = 5,
			Skillz = 0.35,
		},
	},
	C = {
		Name = "Sprint",
		Desc = "Wsly boosts his speed by 12.5% + <boost> for each stack of Death Run he currently has. If Death Run is active or he has managed to gain 10 stacks, he will gain 25% increased Skillz. This effect lasts <duration> seconds.",
		MaxLevel = 5,
		boost = {
			AbilityLevel = 0.1,
		},
		duration = {
			Base = 1.8,
			AbilityLevel = 0.2,
		}
	},
	D = {
		Name = "Death Run",
		Desc = "[Innate] Death Run is a stack mechanic that grants Wsly some utility against enemy champions, making him a little hard to catch. His basic attacks also reduces the cooldown of Death Run by 0.75 per hit. [Active] For <duration> seconds, Wsly is locked at 10 Death Run stacks. During this time, his basic attacks deal <extraDamage>% more damage.",
		MaxLevel = 3,
		duration = {
			Base = 3,
			AbilityLevel = 1,
		},
		extraDamage = {
			Base = 7.5,
			AbilityLevel = 2.5,
		}
	}
}
script.AbilityData.OnInvoke = function()
	return abilityData
end

local characterData = {
}
script.CharacterData.OnInvoke = function()
	return characterData
end

initializeStackGui()