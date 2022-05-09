local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	
	local position = d.HRP.Position
	local direction = d.HRP.CFrame.lookVector
	local range = 30
	local speed = 100
	local width = 6
	local team = d.CHAR.Team.Value

	
	local function onHit(p, enemy)
		if enemy.Parent.Name == "Minion" and not game.Players:GetPlayerFromCharacter(enemy.Parent) then
            if enemy.Health < enemy.MaxHealth * 0.375 then
                d.DS.Damage:Invoke(enemy, enemy.MaxHealth, "Resistance", d.PLAYER)
				p.Moving = false
				local gt = d.CONTROL:FindFirstChild("GiveTix")
				if gt then
					gt:Invoke(15)	
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
	d.SFX.ProjShrink:Invoke(p:ClientArgs(), 2.5, "Really black", 1)
	
	active = false
	wait(6)
	active = true
	
end  