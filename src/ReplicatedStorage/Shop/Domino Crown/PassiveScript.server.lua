local CHAR = script.Parent.Parent.Parent.Parent
local Player = game.Players:GetPlayerFromCharacter(CHAR) 
local DS = game.ServerScriptService.DamageService
local SFX = game.ServerScriptService.SFXService
local CONTROL = CHAR:WaitForChild("CharacterScript")
local HRP = CHAR:FindFirstChild("HumanoidRootPart")
local below = false
local GET_HUMANOIDS = game.ServerScriptService.HumanoidService.GetHumanoids
local MyTeam = CHAR.Team.Value
local Effects = script.Parent.Effects


local hum = CHAR.Humanoid
hum.HealthChanged:connect(function(health)
if hum.Health < hum.MaxHealth * 0.4 and below == false then
	Effects.Speed.Value = 2
	
	below = true
elseif below == true and hum.Health > hum.MaxHealth * 0.4 then
Effects.Speed.Value = 0
below = false
end
end)

