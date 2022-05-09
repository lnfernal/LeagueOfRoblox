wait(0.5)

local R = game.ReplicatedStorage.Remotes

local MINION = script.Parent
local HRP = MINION.HumanoidRootPart
local HUMAN = MINION.Humanoid
local MINIONTORSO = MINION["Torso"]




local DS = game.ServerScriptService.DamageService




local hitSound = require(game.ServerStorage.HitSound)
local getEnemies = game.ServerScriptService.HumanoidService.GetEnemies
local getClosestTeam = game.ServerScriptService.TeamScript.GetClosestTeam
local sfx = game.ServerScriptService.SFXService



function getStat(statName)
	local getStat = MINION:FindFirstChild("GetStat", true)
	if getStat then
		return getStat:Invoke(statName)
	end
	
	return 0
end

function setStat(statName, value)
	local setStat = MINION:FindFirstChild("SetStat", true)
	if setStat then
		setStat:Invoke(statName, value)
		return true
	end
	
	return false
end






function died()
	local ds = game.ServerScriptService.DamageService
	local center = HRP.Position
	local radius = 50
	local team = MINION.Team.Value
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
			local e = givenExp / num
			local t = givenTix / num
			
			benefactor.Exp:Invoke(e)
			benefactor.Tix:Invoke(t)
			
			e = tostring(e):sub(1, 4)
			t = tostring(t):sub(1, 4)
			local msg = "+"..e.." Exp, +"..t.." Tix"
			R.SFX.RisingMessage:FireClient(benefactor.Player, MINION.Head.Position + Vector3.new(0, 1, 0), msg, 3, {TextColor3 = Color3.new(1, 1, 0)})
		end
	end
	--w:Destroy()
	game:GetService("Debris"):AddItem(MINION, 1)
	game:GetService("Debris"):AddItem(script, 0)	
end

function main()
	HUMAN.Died:connect(died)
	
	local team = getClosestTeam:Invoke(HRP.Position)
	team:AddCharacter(MINION)
	--script.Name = "MinionScript"
	--MINION.Name = "Minion"
end

main()