local CHAR = script.Parent.Parent.Parent.Parent
local HRP = CHAR.HumanoidRootPart
local Player = game.Players:GetPlayerFromCharacter(CHAR) 
local DS = game.ServerScriptService.DamageService
local SFX = game.ServerScriptService.SFXService
local CONTROL = CHAR:WaitForChild("CharacterScript")
local triggered = true

function script.MyPassive.OnInvoke(damage,source)
	if not triggered then return end
	if not source then return end
	DS.returnDamage:Invoke(source.Character.Humanoid, damage * 0.2, 0, Player)
	triggered = false
	delay(0.1,function()
		triggered = true
	end)
	end