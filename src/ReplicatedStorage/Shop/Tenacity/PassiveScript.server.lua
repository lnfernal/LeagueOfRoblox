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
if hum.Health < hum.MaxHealth * 0.5 and below == false then
	Effects.BasicCDR.Value = 0.275
	Effects.H4x.Value = 100
	Effects.HealthRegen.Value = 8
	Effects.Skillz.Value = 100
	below = true
elseif below == true and hum.Health > hum.MaxHealth * 0.5 then
Effects.BasicCDR.Value = 0.225
	Effects.H4x.Value = 50
	Effects.HealthRegen.Value = 5
	Effects.Skillz.Value = 50
below = false
end
end)

