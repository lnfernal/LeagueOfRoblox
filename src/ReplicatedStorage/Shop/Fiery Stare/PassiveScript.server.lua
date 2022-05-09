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

	
	  ST.DOT:Invoke(hums, (hums.MaxHealth*.05), 2, 0,Player, "Burned!")  
	local pos = hums.Parent.HumanoidRootPart.Position
	SFX.Shockwave:Invoke(Vector3.new(pos.X,pos.Y - 2.5, pos.Z), 4, "Bright orange")
	local hrp =  hums.Parent:FindFirstChild("HumanoidRootPart")
				if hrp then
					local s = Instance.new("Fire", hrp)
					s.Color = Color3.new(255, 170, 0) 
					 delay(1, function()
						s:Destroy()
					end)    
					end
	active = false
	delay(6,function() 
	active = true
	end)
	end
	
	 

