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
	if hums.Parent.Name == "Turret" then return end
	if not active then return end

	local speed = 5/100*hums.MaxHealth 
	ST.StatBuff:Invoke(HUMAN,"H4x",speed,3)   
	local pos = HUMAN.Parent.HumanoidRootPart.Position
	SFX.Shockwave:Invoke(Vector3.new(pos.X,pos.Y - 2.5, pos.Z), 4, "Bright blue")
	active = false
	delay(20,function() 
	active = true
	end)
	end

	 

