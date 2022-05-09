local brawling = false
local combo = {}
local currentcombos = {}
math.randomseed(os.time())
local random = math.random
local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end
--Brawl effects are: 1 = bonus damage, 2 = slow, 3 = stun. The uppercut only has the 1/2, no stun.
--[[Designated combos, p/p/k grants sweeping kick p/p/u grants kick to stun, s/u/k leads to double kick, p/k/u leads to some sort of dancing,s/p/k/u/p/p grants all of them
p = 1
k = 2
u = 3
s = 4
p/p/k = 4 completed
p/p/u = 5 completed
s/u/k = 9 completed
p/k/u = 6
s/p/k/u/p/p = 12
or i could do it based on table like if table is empty, insert string then detect order
log so every time the combo is wrong, it resets to 0, player gui link time
]]
function initializeStackGui()
	local backpack = script.Parent
	local controlScript = backpack:WaitForChild("ControlScript")
	local data = controlScript.GetData:Invoke()
	data.R.AverageTrackCOMBO:FireClient(data.PLAYER,combo)
end
function record(attack)
	local uniqueid  = uuid()
	table.insert(combo,{attack,uniqueid})
	table.insert(currentcombos,attack)
	
	if ((currentcombos[1] ~= nil and currentcombos[1] =="kick") or (currentcombos[1] ~= nil and currentcombos[1] =="uppercut") or (currentcombos[2] ~= nil and currentcombos[2] == "slide") or (currentcombos[3] ~= nil and currentcombos[3] == "slide") or (currentcombos[3] ~= nil and currentcombos[3] == "punch") or (currentcombos[4] ~= nil and currentcombos[4] ~= "uppercut") or (currentcombos[5] ~= nil and currentcombos[5] ~= "punch") or (currentcombos[6] ~= nil and currentcombos[6] ~= "punch")  )   then
		combo = {}
		currentcombos = {}
		initializeStackGui()
	
end 
	initializeStackGui()
	delay(3,function()
		if #combo > 0 then
		for i,v in pairs(combo) do
			if v[2] == uniqueid then
				table.remove(combo,i)
				table.remove(currentcombos,i)
				initializeStackGui()
			end
		end
		end
	end)
	end

function check()
	
if currentcombos[1] == "punch" and currentcombos[2] == "punch" and currentcombos[3] == "kick" then
combo = {}

currentcombos = {}
initializeStackGui()
return "sweep"

elseif currentcombos[1] == "punch" and currentcombos[2] == "punch" and currentcombos[3] == "uppercut" then
	combo = {}
	currentcombos = {}
	initializeStackGui()
	return "stun"
	
elseif currentcombos[1] == "punch" and currentcombos[2] == "kick" and currentcombos[3] == "uppercut" then
	combo = {}
	currentcombos = {}
	initializeStackGui()
	return "dance"
	
elseif currentcombos[1] == "slide" and currentcombos[2] == "uppercut" and currentcombos[3] == "kick" then	
	combo = {}
	currentcombos = {}
	initializeStackGui()
	return "double"
	
elseif currentcombos[1] == "slide" and currentcombos[2] == "punch"and currentcombos[3] == "kick"and currentcombos[4] == "uppercut"and currentcombos[5] == "punch"and currentcombos[6] == "punch"then
	combo = {}
	currentcombos = {}
	initializeStackGui()
	return "all"
	
end
end

function basicAttack(d)
	if d.CONTROL.AbilityOnCooldown:Invoke("Q") then return end
	d.CONTROL.AbilityCooldown:Invoke("Q", .85 - (.85 * d.CONTROL.GetStat:Invoke("BasicCDR")))
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/item.aspx?id=567825036")
	d.PLAY_SOUND(d.HUMAN, 12222200, nil, 0.75)
	wait(0.3)
	local function PickRandomEffect()
		local Values = {1, 2, 3}
		return Values[math.random(1, #Values)]
	end
	
	local brawlEffect = PickRandomEffect()
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .4
	local hrp = d.HRP
	local team = d.CHAR.Team.Value
	local function onHit(enemy)
	
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		if brawling == true then
			if brawlEffect == 1 then
				if enemy.Parent.Name == "Turret" then
				d.DS.Damage:Invoke(enemy, damage * .2, 0, d.PLAYER)
				else
				d.DS.Damage:Invoke(enemy, damage * .35, 0, d.PLAYER)	
					end
			elseif brawlEffect == 2 then
				if enemy.Parent.Name == "Turret" then
				d.DS.Damage:Invoke(enemy, damage * .05, 0, d.PLAYER)
				else
				d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
				end
				elseif brawlEffect == 3 then
				if enemy.Parent.Name == "Turret" then
				d.DS.Damage:Invoke(enemy, damage * .05, 0, d.PLAYER)
				else
				d.ST.Stun:Invoke(enemy, 0.25)
				end
			end
		end

	end
	d.DS.Melee:Invoke(hrp, team, onHit,10,6)	
	record("punch")
	local tocheck = check()
	if tocheck == "all" then
		local dataB = d.ABILITY_DATA.B
	local abilityB = d.CONTROL.AbilityGetInfo:Invoke("B")
	local dataC = d.ABILITY_DATA.C
	local abilityC = d.CONTROL.AbilityGetInfo:Invoke("C")
	local rangea = 16
	local widtha = 5
	local damagea = abilityB:C(dataB.damage)
	local center = d.HRP.Position
	local rangeb = 12
	local damageb = abilityB:C(dataB.sweepdamage)
	local stundamage = abilityC:C(dataC.stundamage)
	local duration = abilityC:C(dataC.duration)
	local range = 16
	local width = 5
	--Does magic of all the abilities	
	wait(0.1)
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/Sweep-item?id=513298937")	
		
	local function onHitb(enemy)
		d.DS.Damage:Invoke(enemy, damageb, "Toughness", d.PLAYER)
		if brawling == true then
		if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, damageb * .35, 0, d.PLAYER)		
			elseif brawlEffect == 2 then
				d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
				elseif brawlEffect == 3 then
				d.ST.Stun:Invoke(enemy, 0.25)
		end
		end
	end
	d.DS.AOE:Invoke(center, rangeb, team, onHitb)
	d.SFX.Shockwave:Invoke(center, rangeb,d.CHAR.Torso.Kick.Value.Color,0.2,"Neon")
	
	wait(0.4)
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/Double-item?id=513284071")
	
	
	local function onHita(enemy)
		d.DS.Damage:Invoke(enemy, (damagea * 0.45), "Toughness", d.PLAYER)
		d.ST.Stun:Invoke(enemy,0.25)
		if brawling == true then
			if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, (damagea * 0.45) * .35, 0, d.PLAYER)
			elseif brawlEffect == 2 then
				delay(1, function()
					d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
				end)
			end
		end
	end
	
	wait(0.4)
	local direction3 = d.HRP.CFrame.lookVector
	local position1 = d.CHAR["Right Leg"].Position
	d.DS.Line:Invoke(d.CHAR["Right Leg"], rangea, widtha, team, onHita, false,direction3)
	d.SFX.Line:Invoke(position1, direction3, rangea, widtha, d.CHAR.Torso.Kick.Value.Color)
	wait(0.5)
	local direction2 = d.HRP.CFrame.lookVector
	local position2 = d.CHAR["Left Leg"].Position
	d.DS.Line:Invoke(d.CHAR["Left Leg"], rangea, widtha, team, onHita, false,direction2)
	d.SFX.Line:Invoke(position2, direction2, rangea, widtha, d.CHAR.Torso.Slide.Value.Color)
	wait(0.1)
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/Stun-item?id=513292303")	
	wait(0.1)
	
	local function onHitStun(enemy)
		d.DS.Damage:Invoke(enemy, stundamage, "Toughness", d.PLAYER)
		d.ST.Stun:Invoke(enemy, 0.25)
		if brawling == true then
			if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, stundamage * .35, 0, d.PLAYER)
			elseif brawlEffect == 2 then
				delay(1, function()
					d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
				end)
			end
		end
	end
wait(0.1)
d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/Stun-item?id=513335238")
local position5= d.CHAR["Right Leg"].Position
local direction7 = d.HRP.CFrame.lookVector
	d.DS.Line:Invoke(d.CHAR["Right Leg"], range, width, team, onHitStun, false,direction7)
	d.SFX.Line:Invoke(position5, direction7, range, width, d.CHAR.Torso.Slide.Value.Color)	
	wait(0.4)
	local function onHitCombo(enemy)
		d.DS.Damage:Invoke(enemy, stundamage * 0.7, "Toughness", d.PLAYER)
		d.DS.KnockAirborne:Invoke(enemy, 16, 0.25)
		if brawling == true then
			if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, (stundamage * 0.7) * .35, 0, d.PLAYER)
			elseif brawlEffect == 2 then
				delay(0.5, function()
					d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
				end)
			end
		end
	end	
	local function onHitPunch(enemy)
		d.DS.Damage:Invoke(enemy, stundamage * 0.4, "Toughness", d.PLAYER)
		if brawling == true then
			if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, (stundamage * 0.4) * .35, 0, d.PLAYER)
			elseif brawlEffect == 2 then
					d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
				
			end
		end
	end	
	
	local direction = d.HRP.CFrame.lookVector
	local Shoryuken= d.CHAR["Right Arm"].Position
	d.DS.Line:Invoke(d.CHAR["Right Arm"], range, width, team, onHitCombo, false,direction)
	d.SFX.Line:Invoke(Shoryuken, direction, range, width, d.CHAR.Torso.Uppercut.Value.Color)
	d.ST.MoveSpeed:Invoke(d.HUMAN, 125/100, 0.4)
	wait(0.4)
	for i = 1, 2 do
		wait(0.2)
		local Punch1= d.CHAR["Right Arm"].Position
		local Punch2= d.CHAR["Left Arm"].Position
	if i == 1 then
		local direction5 = d.HRP.CFrame.lookVector
	d.DS.Line:Invoke(d.CHAR["Right Arm"], range, width, team, onHitPunch, false,direction5)
	d.SFX.Line:Invoke(Punch1, direction5, range, width, d.CHAR.Torso.Slide.Value.Color)
	else
		local direction6 = d.HRP.CFrame.lookVector
	d.DS.Line:Invoke(d.CHAR["Left Arm"], range, width, team, onHitPunch, false,direction6)
	d.SFX.Line:Invoke(Punch2, direction6, range, width, d.CHAR.Torso.Uppercut.Value.Color)	
	end
	end
end

end
script.BasicAttack.OnInvoke = basicAttack

function ability1(d)
	local data = d.ABILITY_DATA.A
	local ability = d.CONTROL.AbilityGetInfo:Invoke("A")
	if d.CONTROL.AbilityOnCooldown:Invoke("A") then return end
	d.CONTROL.AbilityCooldown:Invoke("A", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local speed = ability:C(data.percent)/100
	
	d.ST.MoveSpeed:Invoke(d.HUMAN, speed, 1.5)
	wait(1.25)
	record("slide")
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ImAnAverage1st-item?id=493774380")
	d.SFX.Trail:Invoke(d.CHAR["Left Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C(d.CHAR.Torso.Slide.Value.Color)}, 0.5, 0.4)
	d.SFX.Trail:Invoke(d.CHAR["Right Arm"], Vector3.new(0, -1, 0), 1, {BrickColor = d.C(d.CHAR.Torso.Slide.Value.Color)}, 0.5, 0.4)	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 32
	local speed2 = range * 2
	local width = 4
	local slow = -ability:C(data.slow)/100
	local damage = ability:C(data.damage)
	local team = d.CHAR.Team.Value
	local function PickRandomEffect()
		local Values = {1, 2, 3}
		return Values[math.random(1, #Values)]
	end
	local brawlEffect = PickRandomEffect()
	local function onHit(p, enemy)
		local colors = {d.CHAR.Torso.Kick.Value.Color,d.CHAR.Torso.Slide.Value.Color,d.CHAR.Torso.Uppercut.Value.Color}
		d.SFX.Shockwave:Invoke(p.Position - Vector3.new(0,2,0), 6,colors[math.random(1,#colors)],0.2,"Neon")	
		d.ST.MoveSpeed:Invoke(enemy, slow, 2.5)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		if brawling == true then
			if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, damage * .35, 0, d.PLAYER)
			elseif brawlEffect == 2 then
				d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
			elseif brawlEffect == 3 then
				d.ST.Stun:Invoke(enemy, 0.25)
			end
		end
	end
	local function onStep(p, dt)
	d.HRP.CFrame = CFrame.new(p.Position, p.Position + p.Direction)			
	end
	local function onEnd(p)
		d.HRP.CFrame = p:CFrame()
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed2, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjDash:Invoke(p:ClientArgs(), d.HRP)
end
script.Ability1.OnInvoke = ability1

function ability2(d)
	local data = d.ABILITY_DATA.B
	local ability = d.CONTROL.AbilityGetInfo:Invoke("B")
	if d.CONTROL.AbilityOnCooldown:Invoke("B") then return end
	d.CONTROL.AbilityCooldown:Invoke("B", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	local function PickRandomEffect()
		local Values = {1, 3}
		return Values[math.random(1, #Values)]
	end
	d.SFX.RisingForce:Invoke(d.HRP, Vector3.new(0, -2.5, 0), 8, 16, {BrickColor = d.C(d.CHAR.Torso.Kick.Value.Color)}, 0.1)
	d.SFX.Artillery:Invoke(d.HRP.Position, 8, d.CHAR.Torso.Uppercut.Value.Color)
	local range = 16
	local width = 5
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local push = ability:C(data.knockback)
	local brawlEffect = PickRandomEffect()
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ImAnAverageAbility2-item?id=447981849")
	
	
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		if brawling == true then
			if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, damage * .35, 0, d.PLAYER)
			end
		end
		if enemy.Parent then
			local hrp = enemy.Parent:FindFirstChild("HumanoidRootPart")
			if hrp then
				local position = hrp.Position
				local speed = push * 4
				local function onHit()
				end
				local function onStep(projectile)
					hrp.CFrame = CFrame.new(projectile.Position)
				end
				local function onEnd()
					if brawling == true then
						if brawlEffect == 2 then
							d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
						end
						if brawlEffect == 3 then
							d.ST.Stun:Invoke(enemy, 0.5)
						end
					end
				end
				local direction = d.HRP.CFrame.lookVector
				d.DS.AddProjectile:Invoke(position, direction, speed, 0, push, team, onHit, onStep, onEnd)
			end
		end
	end
	local direction = d.HRP.CFrame.lookVector
	local position = d.CHAR["Right Leg"].Position
	d.DS.Line:Invoke(d.CHAR["Right Leg"], range, width, team, onHit, false,direction)
	d.SFX.Line:Invoke(position, direction, range, width, d.CHAR.Torso.Kick.Value.Color)
	record("kick")
	local tocheck = check()
	if tocheck == "sweep" then
		wait(0.1)
		d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/Sweep-item?id=513298937")	
		local center = d.HRP.Position
	local rangeb = 12
	local damageb = ability:C(data.sweepdamage)
	local function onHitb(enemy)
		d.DS.Damage:Invoke(enemy, damageb, "Toughness", d.PLAYER)
		if brawling == true then
		if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, damageb * .35, 0, d.PLAYER)		
			elseif brawlEffect == 2 then
				d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
				elseif brawlEffect == 3 then
				d.ST.Stun:Invoke(enemy, 0.25)
		end
		end
	end
	d.DS.AOE:Invoke(center, rangeb, team, onHitb)
	d.SFX.Shockwave:Invoke(center, rangeb,d.CHAR.Torso.Kick.Value.Color,0.2,"Neon")
	end
	if tocheck == "double" then
		
	
	local rangea = 16
	local widtha = 5
	local damagea = ability:C(data.damage)
	local brawlEffect = PickRandomEffect()
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/Double-item?id=513284071")
	
	
	local function onHita(enemy)
		d.DS.Damage:Invoke(enemy, (damagea * 0.45), "Toughness", d.PLAYER)
		d.ST.Stun:Invoke(enemy,0.25)
		if brawling == true then
			if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, (damagea * 0.45) * .35, 0, d.PLAYER)
			elseif brawlEffect == 2 then
				delay(0.5, function()
					d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
				end)
			end
		end
	end
	
	wait(0.4)
	local direction3 = d.HRP.CFrame.lookVector
	local position1 = d.CHAR["Right Leg"].Position
	d.DS.Line:Invoke(d.CHAR["Right Leg"], rangea, widtha, team, onHita, false,direction3)
	d.SFX.Line:Invoke(position1, direction3, rangea, widtha, d.CHAR.Torso.Kick.Value.Color)
	wait(0.5)
	local direction2 = d.HRP.CFrame.lookVector
	local position2 = d.CHAR["Left Leg"].Position
	d.DS.Line:Invoke(d.CHAR["Left Leg"], rangea, widtha, team, onHita, false,direction2)
	d.SFX.Line:Invoke(position2, direction2, rangea, widtha, d.CHAR.Torso.Slide.Value.Color)
	end
end
script.Ability2.OnInvoke = ability2

function ability3(d)
	local data = d.ABILITY_DATA.C
	local ability = d.CONTROL.AbilityGetInfo:Invoke("C")
	if d.CONTROL.AbilityOnCooldown:Invoke("C") then return end
	d.CONTROL.AbilityCooldown:Invoke("C", 12.5 - (12.5 * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	d.SFX.Artillery:Invoke(d.HRP.Position, 8, d.CHAR.Torso.Kick.Value.Color)
	
	local function PickRandomEffect()
		local Values = {1, 2}
		return Values[math.random(1, #Values)]
	end
	
	local range = 16
	local width = 5
	local team = d.CHAR.Team.Value
	local damage = ability:C(data.damage)
	local duration = ability:C(data.duration)
	local stundamage = ability:C(data.stundamage)
	local brawlEffect = PickRandomEffect()
	
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ImAnAverageAbility3-item?id=447989238")
	
	
	local function onHit(enemy)
		d.DS.Damage:Invoke(enemy, damage, "Toughness", d.PLAYER)
		if enemy.Parent.Name == "Minion" then
			d.DS.Damage:Invoke(enemy, damage*1, "Toughness", d.PLAYER)
		end 
		d.DS.KnockAirborne:Invoke(enemy, 16, duration)
		if brawling == true then
			if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, damage * .35, 0, d.PLAYER)
			elseif brawlEffect == 2 then
				delay(duration, function()
					d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
				end)
			end
		end
	end
	local direction = d.HRP.CFrame.lookVector
	local position = d.CHAR["Right Arm"].Position
	d.DS.Line:Invoke(d.CHAR["Right Arm"], range, width, team, onHit, false,direction)
	d.SFX.Line:Invoke(position, direction, range, width, d.CHAR.Torso.Uppercut.Value.Color)
	record("uppercut")
	local tocheck = check()
	if tocheck == "stun" then
	game.ReplicatedStorage.Remotes.StopAnimation:FireClient(d.PLAYER,d.HUMAN, "https://www.roblox.com/ImAnAverageAbility3-item?id=447989238")
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/Stun-item?id=513292303")	
	wait(0.1)
	local function onHitStun(enemy)
		d.DS.Damage:Invoke(enemy, stundamage, "Toughness", d.PLAYER)
		d.ST.Stun:Invoke(enemy, 0.25)
		if brawling == true then
			if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, stundamage * .35, 0, d.PLAYER)
			elseif brawlEffect == 2 then
				delay(0.5, function()
					d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
				end)
			end
		end
	end
	local position2= d.CHAR["Right Leg"].Position
	local direction4= d.HRP.CFrame.lookVector
	d.DS.Line:Invoke(d.CHAR["Right Leg"], range, width, team, onHitStun, false,direction4)
	d.SFX.Line:Invoke(position2, direction4, range, width, d.CHAR.Torso.Uppercut.Value.Color)
	end
	if tocheck == "dance" then
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/Stun-item?id=513335238")	
	wait(0.4)
	local function onHitCombo(enemy)
		d.DS.Damage:Invoke(enemy, damage * 0.7, "Toughness", d.PLAYER)
		d.DS.KnockAirborne:Invoke(enemy, 16, 0.25)
		if brawling == true then
			if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, damage * .35, 0, d.PLAYER)
			elseif brawlEffect == 2 then
				delay(0.5, function()
					d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
				end)
			end
		end
	end	
	local function onHitPunch(enemy)
		d.DS.Damage:Invoke(enemy, damage * 0.4, "Toughness", d.PLAYER)
		
		if brawling == true then
			if brawlEffect == 1 then
				d.DS.Damage:Invoke(enemy, damage * .35, 0, d.PLAYER)
			elseif brawlEffect == 2 then
				d.ST.MoveSpeed:Invoke(enemy, -.35, 1)
			end
		end
	end	
	local Shoryuken= d.CHAR["Right Arm"].Position
	local direction7 = d.HRP.CFrame.lookVector
	d.DS.Line:Invoke(d.CHAR["Right Arm"], range, width, team, onHitCombo, false,direction7)
	d.SFX.Line:Invoke(Shoryuken, direction7, range, width, d.CHAR.Torso.Slide.Value.Color)
	d.ST.MoveSpeed:Invoke(d.HUMAN, 125/100, 0.4)
	wait(0.4)
	for i = 1, 2 do
		wait(0.2)
		local Punch1= d.CHAR["Right Arm"].Position
		local Punch2= d.CHAR["Left Arm"].Position
	if i == 1 then
		local direction1 = d.HRP.CFrame.lookVector
	d.DS.Line:Invoke(d.CHAR["Right Arm"], range, width, team, onHitPunch, false,direction1)
	d.SFX.Line:Invoke(Punch1, direction1, range, width, d.CHAR.Torso.Slide.Value.Color)
	else
		local direction2 = d.HRP.CFrame.lookVector
	d.DS.Line:Invoke(d.CHAR["Left Arm"], range, width, team, onHitPunch, false,direction2)
	d.SFX.Line:Invoke(Punch2, direction2, range, width, d.CHAR.Torso.Uppercut.Value.Color)	
	end
	end
	end
	
	
end
script.Ability3.OnInvoke = ability3

function ability4(d)
	local data = d.ABILITY_DATA.D
	local ability = d.CONTROL.AbilityGetInfo:Invoke("D")
	if d.CONTROL.AbilityOnCooldown:Invoke("D") then return end
	d.CONTROL.AbilityCooldown:Invoke("D", ability:C(data.duration2) - (ability:C(data.duration2) * d.CONTROL.GetStat:Invoke("CooldownReduction")))
	
	d.CHAR.Glass.Transparency = 0.625
	d.CHAR.Liquid.Transparency = 0
	d.PLAY_ANIM(d.PLAYER, "https://www.roblox.com/ImAnAverageUltimate-item?id=448001899")
	wait(0.355)
	d.CHAR.Glass.Transparency = 1
	d.CHAR.Liquid.Transparency = 1
	
	local duration = ability:C(data.duration)
	brawling = true
	local fist = d.HUMAN.Parent:FindFirstChild("Right Arm")
	local fire = Instance.new("Fire", fist)
	local fist2 = d.HUMAN.Parent:FindFirstChild("Left Arm")
	local fire2 = Instance.new("Fire", fist2)
	wait(duration)
	
	brawling = false
	fire:Destroy()
	fire2:Destroy()	
end
script.Ability4.OnInvoke = ability4




local abilityData = {
	A = {
		Name = "Slide",
		Desc = "ImAnAverageNormalMan takes off in a sprint, gaining <percent>% bonus movespeed for 1.5 seconds. After which she does a sliding kick dealing <damage> damage and slowing them down by <slow>% for 2.5s",
		MaxLevel = 5,
		percent = {
			Base = 25,
			AbilityLevel = 5,
		},
		slow = {
			Base = 35,
			
		},
		damage = {
			AbilityLevel = 4,
			Skillz = .25,
		},
	},
	B = {
		Name = "Kick",
		Desc = "ImAnAverageNormalMan kicks her opponents, dealing <damage> damage and knocking them back <knockback> studs.",
		MaxLevel = 5,
		damage = {
			Base = 5,
			AbilityLevel = 4,
			Skillz = .3, -- Double kick uses this but x 0.45
		},
		sweepdamage = {
			Base = 5,
			AbilityLevel = 2,
			Skillz = .25,
		},
		knockback = {
			Base = 5,
			AbilityLevel = 2,
		}
	},
	C = {
		Name = "Uppercut",
		Desc = "ImAnAverageNormalMan uppercuts her opponents, dealing <damage> damage and throwing them in the air for <duration> seconds.",
		MaxLevel = 5,
		damage = {
			AbilityLevel = 6,
			Skillz = .35,
		},
		stundamage = {
			AbilityLevel = 5,
			Skillz = .25, --this is for the stun kick, the dancing combo also uses this but the 1st uppercut is *0.7 and the 2 punches are 0.4
		},
		duration = {
			Base = .5,
			AbilityLevel = .1,
		}
	},
	D = {
		Name = "All-out Brawling",
		Desc = "ImAnAverageNormalMan chugs some random fluid and goes into a frenzy. Any attack that lands will gain one of the following effects: 35% bonus true damage, 35% slow for 2.5 seconds, or a 1 second stun. Lasts <duration> seconds, and the cooldown is <duration2> seconds.",
		MaxLevel = 3,
		duration = {
			Base = 3,
			AbilityLevel = 1,
		},
		duration2 = {
			Base = 60,
			AbilityLevel = -5,
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

