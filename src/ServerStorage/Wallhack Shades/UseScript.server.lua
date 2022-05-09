local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 30
	local speed = 100
	local width = 6
	
	 
	local team = d.CHAR.Team.Value
local heal2 = d.CONTROL.GetStat:Invoke("H4x") * .4
local heal = d.CONTROL.GetStat:Invoke("Skillz") * .4
	local damage = d.CONTROL.GetStat:Invoke("Skillz") * .5
	local damage2 = d.CONTROL.GetStat:Invoke("H4x") * .5
	local function onHit(p, enemy)
		if enemy.Parent.Name == "Golem" and not game.Players:GetPlayerFromCharacter(enemy.Parent) then
            if enemy.Health < enemy.MaxHealth * 0.5 then
                d.DS.Damage:Invoke(enemy, damage, 0, d.PLAYER)
                d.DS.Heal:Invoke(d.HUMAN, heal, 0,d.PLAYER) 
                d.DS.Damage:Invoke(enemy, damage2, 0, d.PLAYER)
                d.DS.Heal:Invoke(d.HUMAN, heal2, 0,d.PLAYER)  
				p.Moving = false
           else
	   if enemy.Health < enemy.MaxHealth * 1 then
				 d.DS.Damage:Invoke(enemy, damage, 0, d.PLAYER)
				  d.DS.Damage:Invoke(enemy, damage2, 0, d.PLAYER)
				end  
            end
        end
	end
	local function onStep(p, dt)
	end
	local function onStep(p)
	end
	local function onEnd(p)
	end
	local p = d.DS.AddProjectile:Invoke(position, direction, speed, width, range, team, onHit, onStep, onEnd)
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 2.5, "Bright yellow", 1)
	
	active = false
	wait(25)
	active = true
	
end  