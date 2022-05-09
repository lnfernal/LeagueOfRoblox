local CHAR = script.Parent.Parent.Parent.Parent
local Player = game.Players:GetPlayerFromCharacter(CHAR) 
local DS = game.ServerScriptService.DamageService
local SFX = game.ServerScriptService.SFXService
local CONTROL = CHAR:WaitForChild("CharacterScript")
local HRP = CHAR:FindFirstChild("HumanoidRootPart")
local MyTeam = CHAR.Team.Value
local ST = game.ServerScriptService.StatusService
local GET_HUMANOIDS = game.ServerScriptService.HumanoidService.GetHumanoids
local HUMAN = CHAR.Humanoid

local active = true
function script.Passive.OnInvoke(hums,damage)
	if hums.Parent.Name == "Golem" then 
	if not active then return end

	local speed = CONTROL.GetStat:Invoke("Skillz") * .15
	ST.StatBuff:Invoke(HUMAN,"Skillz",speed,3)  
	 ST.StatBuff:Invoke(HUMAN,"SkillzVampirism",.15,3) 
	local pos = HUMAN.Parent.HumanoidRootPart.Position
	SFX.Shockwave:Invoke(Vector3.new(pos.X,pos.Y - 2.5, pos.Z), 4, "Earth green")
	active = false
	delay(10,function() 
	active = true
	end)
	end
	end 

