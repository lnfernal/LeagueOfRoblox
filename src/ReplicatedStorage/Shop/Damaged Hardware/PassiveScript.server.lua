local CHAR = script.Parent.Parent.Parent.Parent
local Player = game.Players:GetPlayerFromCharacter(CHAR) 
local DS = game.ServerScriptService.DamageService
local SFX = game.ServerScriptService.SFXService
local CONTROL = CHAR:WaitForChild("CharacterScript")
local HRP = CHAR:FindFirstChild("HumanoidRootPart")
local Current = 0
local GET_HUMANOIDS = game.ServerScriptService.HumanoidService.GetHumanoids
local MyTeam = CHAR.Team.Value
local ST = game.ServerScriptService.StatusService
local active = true
function script.Passive.OnInvoke(hums,damage)
	if hums.Parent.Name == "Turret" then return end
	if not active then return end
	local dam = damage * .1
	ST.DOT:Invoke(hums, dam, 1, 0, Player, "Poisoned!")
	active = false
	delay(10,function()
	active = true
	end)
end

