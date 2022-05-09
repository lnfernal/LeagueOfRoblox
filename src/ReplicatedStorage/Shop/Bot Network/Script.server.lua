local CHAR = script.Parent.Parent.Parent.Parent
local HRP = CHAR.HumanoidRootPart
local Player = game.Players:GetPlayerFromCharacter(CHAR) 
local DS = game.ServerScriptService.DamageService
local SFX = game.ServerScriptService.SFXService
local CONTROL = CHAR:WaitForChild("CharacterScript")
local Current = script.Parent.BotsAroundPlayer
while wait(6) do
	if Current.Value < 3 then
	Current.Value = Current.Value + 1
	SFX.ProjRotate:Invoke(HRP,"Medium stone grey",3,Current.Value,"Bot",true,"http://www.roblox.com/asset/?id=133512910","rbxassetid://133512897")
	script.Parent.Effects.HealthRegen.Value = 5 + (4.5 * Current.Value)
	end
end