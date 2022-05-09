local CHAR = script.Parent.Parent.Parent.Parent
local HRP = CHAR.HumanoidRootPart
local Player = game.Players:GetPlayerFromCharacter(CHAR) 
local DS = game.ServerScriptService.DamageService
local SFX = game.ServerScriptService.SFXService
local CONTROL = CHAR:WaitForChild("CharacterScript")
local Current = script.Parent.BotsAroundPlayer
local triggered = true

function script.MyPassive.OnInvoke(damage)
	if not triggered then return end
	if  Current.Value > 0 then
	SFX.ProjRotateDead:Invoke(HRP,Current.Value,"Bot")
	Current.Value = Current.Value - 1
	script.Parent.Effects.HealthRegen.Value = 5 + (4.5 * Current.Value)
	triggered = false
	delay(0.1,function()
		triggered = true
	end)
	end
	end
